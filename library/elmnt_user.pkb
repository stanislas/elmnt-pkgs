create or replace
package body elmnt.elmnt_user is

	c_elnmt_power_user constant varchar2(100) := 'ELMNT_POWER_USER';

	procedure create_tablespace(
		tablespace_name     varchar2,
		tablespace_datafile varchar2)
	is
		begin
			execute immediate
			'create tablespace ' ||
			tablespace_name ||
			' datafile
			''' ||
			tablespace_datafile ||
			'''      size   100M
			autoextend on maxsize 20G';
		end;

	procedure create_tablespace(
		tablespace_name         varchar2,
		tablespace_datafile_dir varchar2)
	is
		begin
			create_tablespace(
				tablespace_name => tablespace_name,
				tablespace_datafile =>
				tablespace_datafile_dir ||
				tablespace_name ||
				'01.dbf');
		end;

	function tablespace_exists(tablespace_name varchar2)
		return boolean
	is
		flag integer;
		begin
			select case when exists(select *
			                        from dba_tablespaces
			                        where tablespace_name = tablespace_exists.tablespace_name)
				then 1
			       else 0 end
			into flag
			from dual;
			if flag = 1
			then
				return true;
			else
				return false;
			end if;
		end;

	function user_exists(user_name varchar2)
		return boolean
	is
		flag integer;
		begin
			select case when exists(select *
			                        from dba_users
			                        where username = user_name)
				then 1
			       else 0 end
			into flag
			from dual;
			return flag = 1;
		end;

	procedure create_user(
		user_name               varchar2,
		data_tablespace_name    varchar2,
		index_tablespace_name   varchar2,
		tablespace_datafile_dir varchar2,
		drop_if_exists          boolean)
	is
		l_data_tablespace_name  varchar2(50);
		l_index_tablespace_name varchar2(50);
		l_tablspc_datafile_dir  varchar2(50);
		begin
			if drop_if_exists and user_exists(user_name)
			then
				execute immediate 'drop user ' || user_name || ' cascade';
			end if;
			if data_tablespace_name is null
			then
				l_data_tablespace_name :=
				user_name ||
				'_DATA';
			else
				l_data_tablespace_name := data_tablespace_name;
			end if;
			if index_tablespace_name is null
			then
				l_index_tablespace_name :=
				user_name ||
				'_INDEX';
			else
				l_index_tablespace_name := index_tablespace_name;
			end if;
			if tablespace_datafile_dir is null
			then
				l_tablspc_datafile_dir := default_tablespace_path;
			else
				l_tablspc_datafile_dir := tablespace_datafile_dir;
			end if;
			if not tablespace_exists(l_data_tablespace_name)
			then
				create_tablespace(
					tablespace_name => l_data_tablespace_name,
					tablespace_datafile_dir => l_tablspc_datafile_dir);
			end if;
			if not tablespace_exists(l_index_tablespace_name)
			then
				create_tablespace(
					tablespace_name => l_index_tablespace_name,
					tablespace_datafile_dir => l_tablspc_datafile_dir);
			end if;
			execute immediate
			'
				create user ' ||
			user_name ||
			' identified by password
				default tablespace ' ||
			l_data_tablespace_name ||
			'
				temporary tablespace temp
				quota unlimited on ' ||
			l_data_tablespace_name ||
			'
				quota unlimited on ' ||
			l_index_tablespace_name;
		end;

	procedure grant_elmnt_power_user_privs(user_name varchar2)
	is
		begin
			execute immediate
			'grant elmnt_power_user to ' || user_name;
		end;

	procedure grant_direct_elmnt_sys_privs(user_name varchar2)
	is
		begin
			for c in (select privilege
			          from dba_sys_privs
			          where grantee = c_elnmt_power_user) loop
				execute immediate 'grant ' || c.privilege || ' to ' || user_name;
			end loop;
		end;

	procedure grant_direct_elmnt_exe_privs(user_name varchar2)
	is
		begin
			for c in (select table_name
			          from dba_tab_privs
			          where grantee = c_elnmt_power_user
			                and privilege = 'EXECUTE') loop
				execute immediate 'grant execute on ' || c.table_name || ' to ' || user_name;
			end loop;
		end;

	procedure create_elmnt_power_user(
		user_name               varchar2,
		data_tablespace_name    varchar2,
		index_tablespace_name   varchar2,
		tablespace_datafile_dir varchar2,
		drop_if_exists          boolean)
	is
		begin
			create_user(user_name, data_tablespace_name, index_tablespace_name, tablespace_datafile_dir,
			            drop_if_exists);
			grant_elmnt_power_user_privs(user_name);
			grant_direct_elmnt_sys_privs(user_name);
			grant_direct_elmnt_exe_privs(user_name);
		end;

	procedure normalize_elmnt_power_users
	is
		begin
			for c in (select du.username
			          from dba_users du
			          where exists(select 1
			                       from dba_role_privs drp
			                       where drp.grantee = du.username and drp.granted_role = c_elnmt_power_user)
			                and du.username <> user) loop
				grant_direct_elmnt_sys_privs(c.username);
				grant_direct_elmnt_exe_privs(c.username);
			end loop;
		end;

end;
/
