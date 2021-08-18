psql -U postgres -c "ALTER USER  postgres  WITH PASSWORD '$1';"
sudo echo 'host all postgres 0.0.0.0/0 md5' >> /jet/etc/postgresql/pg_hba.conf
/jet/etc/postgresql/init.d/postgresql restart