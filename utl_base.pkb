create or replace
package body utl_base is

    function object_exists(
                          object_name varchar2,
                          owner       varchar2,
                          object_type varchar2,
                          lvl         varchar2)
    return boolean
    is
        flag integer;
        query varchar2 (2000);
    begin
        query :=
        'select case when exists (
                select *
                from ' ||
        lvl ||
        '_objects where object_name = ''' ||
        object_name ||
        ''' and object_type = ''' ||
        object_type ||
        '''';
        if lvl in (
                  'dba',
                  'all') then
            query :=
            query ||
            ' and owner = ''' ||
            owner ||
            '''';
        end if;
        query :=
        query ||
        ') then 1 else 0 end from dual';
        execute immediate query into flag;
        if flag = 1 then
            return true; else
                             return false;
        end if;
    end;

end;
/