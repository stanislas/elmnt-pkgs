--
-- it is a default for the tablespace files
--
create or replace function elmnt.default_tablespace_path
return varchar2 deterministic is
begin
    return '/home/oracle/app/oracle/oradata/cdb1/orcl/';
end;
/

--
-- INSTALL the packages for elmnt
--
