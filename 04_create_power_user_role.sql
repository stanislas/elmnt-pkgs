--
-- 2. The super user role is assigned to every user
--

create role power_user;

grant
create session, create any table, create any view,
create any materialized view, create any index, drop any table, drop any view,
drop any materialized view, alter any table, alter any materialized view,
create any sequence, comment any table, create any type, create library,
execute any type, create any procedure, execute any procedure, create any cluster,
select any table, insert any table, delete any table, update any table, select any sequence,
select any transaction, exp_full_database, imp_full_database
to power_user;

begin
    for c in (
    select object_name
    from user_objects
    where object_type = 'VIEW' and
          object_name like 'V\_$%' escape '\' )
    loop
        execute immediate 'grant select on ' || c.object_name || ' to power_user';
    end loop;
end;
/

grant read, write on directory data_pump_dir to power_user;

grant select on dba_tablespaces to power_user;

grant execute on utl_recomp to power_user;
grant execute on dbms_lock to power_user;
grant execute on dbms_stats to power_user;
grant execute on dbms_mview to power_user;
grant execute on dbms_scheduler to power_user;
grant execute on dbms_aq to power_user;

grant execute on utl_base to power_user;
grant execute on utl_user to power_user;
grant execute on default_tablespace_path to power_user;