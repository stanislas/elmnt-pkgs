--
-- 2. The super user role is assigned to every user
--

create role super_user;

grant
create session, create any table, create any view,
create any materialized view, create any index, drop any table, drop any view,
drop any materialized view, alter any table, insert any table, alter any materialized view,
select any table, create any sequence, comment any table, create any type,
execute any type, create any procedure, execute any procedure, create any cluster,
create library to super_user;

begin
    for c in (
    select object_name
    from user_objects
    where object_type = 'VIEW' and
          object_name like 'V\_$%' escape '\' )
    loop
        execute immediate 'grant select on ' || c.object_name || ' to super_user';
    end loop;
end;

grant select on dba_tablespaces to super_user;

grant execute on utl_recomp to super_user;
grant execute on dbms_lock to super_user;
grant execute on dbms_stats to super_user;
grant execute on dbms_mview to super_user;
grant execute on dbms_scheduler to super_user;
grant execute on dbms_aq to super_user;

grant execute on utl_base to super_user;
grant execute on utl_user to super_user;
grant execute on default_tablespace_path to super_user;