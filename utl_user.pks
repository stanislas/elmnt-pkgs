create or replace
package utl.utl_user
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

    procedure grant_super_user_privileges(user_name varchar2);

    procedure create_super_user(
        user_name               varchar2,
        data_tablespace_name    varchar2 default null,
        index_tablespace_name   varchar2 default null,
        tablespace_datafile_dir varchar2 default null);

end;
/