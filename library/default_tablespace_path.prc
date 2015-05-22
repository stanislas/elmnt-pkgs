--
--
--
declare
	table_exists number;
begin
	select case when exists(select *
	                        from dba_tables
	                        where owner = 'ELMNT'
	                              and table_name = 'DEFAULT_TABLESPACE_PATH_CONFIG')
		then 1
	       else 0 end
	into table_exists
	from dual;
	if table_exists = 0 then
		execute immediate 'create table elmnt.default_tablespace_path_config (default_tablespace_path varchar2(4000))';
		execute immediate 'create unique index elmnt.default_tablespace_path_config on elmnt.default_tablespace_path_config(1)';
		execute immediate 'insert into elmnt.default_tablespace_path_config values (''/home/oracle/app/oracle/oradata/cdb1/orcl/'')';
		commit;
	end if;
end;
/

--
-- it is a default for the tablespace files
--
create or replace function elmnt.default_tablespace_path
	return varchar2 is
		path varchar2(4000);
	begin
		select default_tablespace_path
		into path
			from default_tablespace_path_config;
		return path;
	end;
/
