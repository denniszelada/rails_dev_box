export LANGUAGE=en_US.UTF-8
if ! $(psql template1 -c 'SHOW SERVER_ENCODING' | grep -q UTF8); then
  psql postgres -c "update pg_database set datallowconn = TRUE where datname = 'template0';"
  psql template0 -c "update pg_database set datistemplate = FALSE where datname = 'template1';"
  psql template0 -c "drop database template1;"
  psql template0 -c "create database template1 with encoding='UTF-8' lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template = template0 ;"
  psql template0 -c "update pg_database set datistemplate = TRUE where datname = 'template1';"
  psql template1 -c "update pg_database set datallowconn = FALSE where datname = 'template0';"
fi

