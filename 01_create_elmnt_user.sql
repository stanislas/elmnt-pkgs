--
-- the utilities are install on a special user elmnt.
-- use the following instuctions/script.
--
set echo off
-- 1. create the elmnt user

accept fmwk_pswd char default 'elmnt' prompt "enter a password for the user elmnt (default is elmnt): " hide

create user elmnt identified by "&&fmwk_pswd"
default tablespace users
temporary tablespace temp
quota unlimited on users;

-- 2. grant privileges.

declare
	version_12_and_more number;
begin
	select case when exists(select 0
	                        from v$instance
	                        where to_number(regexp_substr(version, '\d*')) >= 12)
		then 1
	       else 0 end
	into version_12_and_more
	from dual;
	if version_12_and_more = 1
	then
		execute immediate 'grant inherit any privileges to elmnt';
		execute immediate 'grant inherit privileges on user sys to elmnt';
	end if;
end;
/

grant select any dictionary to elmnt;
