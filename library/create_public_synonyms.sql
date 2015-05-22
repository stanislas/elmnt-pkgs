--
-- 01. Creation of public synonyms for some system packages
--     and elmnt packages/functions
--

create or replace public synonym utl_recomp for sys.utl_recomp;
create or replace public synonym elmnt_base for elmnt.elmnt_base;
create or replace public synonym elmnt_user for elmnt.elmnt_user;
create or replace public synonym default_tablespace_path for elmnt.default_tablespace_path;
