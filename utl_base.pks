create or replace
package utl_base
authid current_user
is

    function object_exists(
                          object_name varchar2,
                          owner varchar2,
                          object_type varchar2,
                          lvl varchar2 default 'dba')
    return boolean;

end;
/