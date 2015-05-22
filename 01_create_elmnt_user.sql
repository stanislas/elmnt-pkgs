--
-- The utilities are install on a special user elmnt.
-- Use the following instuctions/script.
--

-- 1. create the elmnt user

create user elmnt identified by password
default tablespace users
temporary tablespace temp
quota unlimited on users;

-- 2. grant privileges.

grant inherit any privileges to elmnt;
grant inherit privileges on user sys to elmnt;
grant select on dba_tablespaces to elmnt;
