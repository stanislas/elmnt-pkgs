--
-- The power user role is assigned to every dev user
--

declare
	elmnt_power_user_exists number;
begin
	select case when exists(select *
	                        from dba_roles
	                        where ROLE = 'ELMNT_POWER_USER')
		then 1
	       else 0 end
	into elmnt_power_user_exists
	from dual;
	if elmnt_power_user_exists = 0
	then
		execute immediate 'create role elmnt_power_user';
	end if;
end;
/

grant
create session, create any table, create any view,
create any materialized view, create any index, drop any table, drop any view,
drop any materialized view, alter any table, alter any materialized view,
create any sequence, comment any table, create any type, create library,
execute any type, create any procedure, execute any procedure, create any cluster,
select any table, insert any table, delete any table, update any table, select any sequence,
select any transaction, exp_full_database, imp_full_database
to elmnt_power_user;

begin
	for c in (
	select object_name
	from user_objects
	where object_type = 'VIEW' and
	      object_name like 'V\_$%' escape '\' )
	loop
		execute immediate 'grant select on ' || c.object_name || ' to elmnt_power_user';
	end loop;
end;
/

grant read, write on directory data_pump_dir to elmnt_power_user;

grant select on dba_tablespaces to elmnt_power_user;

grant execute on utl_recomp to elmnt_power_user;
grant execute on dbms_lock to elmnt_power_user;
grant execute on dbms_stats to elmnt_power_user;
grant execute on dbms_mview to elmnt_power_user;
grant execute on dbms_scheduler to elmnt_power_user;
grant execute on dbms_aq to elmnt_power_user;

grant execute on elmnt_base to elmnt_power_user;
grant execute on elmnt_user to elmnt_power_user;
grant execute on default_tablespace_path to elmnt_power_user;
