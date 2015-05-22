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

grant inherit any privileges to elmnt;
grant inherit privileges on user sys to elmnt;
grant select on dba_tablespaces to elmnt;
