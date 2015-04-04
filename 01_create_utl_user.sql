--
-- The utilities are install on a special user utl.
-- Use the following instuctions/script.
--

-- 1. create the utl user

create user UTL identified by password
default tablespace users
temporary tablespace temp
quota unlimited on users;

-- 2. grant privileges.

grant inherit any privileges to utl;
grant inherit privileges on user sys to utl;
grant select on dba_tablespaces to utl;