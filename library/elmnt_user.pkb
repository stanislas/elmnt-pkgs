create or replace
package body elmnt.elmnt_user is

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

    procedure create_user(
        user_name               varchar2,
        data_tablespace_name    varchar2,
        index_tablespace_name   varchar2,
        tablespace_datafile_dir varchar2)
    is
        l_data_tablespace_name  varchar2(50);
        l_index_tablespace_name varchar2(50);
        l_tablspc_datafile_dir  varchar2(50);
        begin
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
            l_index_tablespace_name ||
            ' enable editions';
        end;

    procedure grant_elmnt_power_user_privileges(user_name varchar2)
    is
        begin
            execute immediate
            'grant elmnt_power_user to ' || user_name;
        end;

    procedure grant_direct_exe_privileges(user_name varchar2)
    is
        begin
            for c in (select table_name
                      from all_tab_privs
                      where grantee = 'ELMNT_POWER_USER'
                            and privilege = 'EXECUTE') loop
                execute immediate 'grant execute on ' || c.table_name || ' to ' || user_name;
            end loop;
        end;

    procedure create_elmnt_power_user(
        user_name               varchar2,
        data_tablespace_name    varchar2,
        index_tablespace_name   varchar2,
        tablespace_datafile_dir varchar2)
    is
        begin
            create_user(user_name, data_tablespace_name, index_tablespace_name, tablespace_datafile_dir);
            grant_elmnt_power_user_privileges(user_name);
            grant_direct_exe_privileges(user_name);
        end;

end;
/
