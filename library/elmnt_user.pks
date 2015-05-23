create or replace
package elmnt.elmnt_user
authid current_user is

	procedure create_tablespace(
		tablespace_name     varchar2,
		tablespace_datafile varchar2);

	procedure create_tablespace(
		tablespace_name         varchar2,
		tablespace_datafile_dir varchar2);

	function tablespace_exists(tablespace_name varchar2)
		return boolean;

	procedure create_user(
		user_name               varchar2,
		data_tablespace_name    varchar2 default null,
		index_tablespace_name   varchar2 default null,
		tablespace_datafile_dir varchar2 default null);

	procedure grant_elmnt_power_user_privs(user_name varchar2);

	procedure grant_direct_elmnt_sys_privs(user_name varchar2);

	procedure grant_direct_elmnt_exe_privs(user_name varchar2);

	procedure create_elmnt_power_user(
		user_name               varchar2,
		data_tablespace_name    varchar2 default null,
		index_tablespace_name   varchar2 default null,
		tablespace_datafile_dir varchar2 default null);

end;
/
