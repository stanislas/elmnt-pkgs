# elmnt-pkg

A collection of small pl/sql utilities

# Installation

Run the sqlplus scripts as SYS.

1. 01_create_elmnt_user.sql
2. 02_install.sql

Configure the function `elmnt.default_tablespace_path` by updating the singleton table
`elmnt.default_tablespace_path_config`.

	update elmnt.default_tablespace_path_config set default_tablespace_path='</default/tablespace/path>';
	commit;
