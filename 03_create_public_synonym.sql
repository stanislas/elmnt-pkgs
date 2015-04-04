--
-- 01. Creation of public synonyms for some system packages
--     and utl packages/functions
--

create public synonym utl_recomp for sys.utl_recomp;
create public synonym utl_base for utl.utl_base;
create public synonym utl_user for utl.utl_user;
create public synonym default_tablespace_path for utl.default_tablespace_path;