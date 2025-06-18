#!/bin/bash
apt update -y
apt install -y postgresql postgresql-contrib -y

echo "host replication all 10.0.0.0/16 trust" >> /etc/postgresql/12/main/pg_hba.conf
echo "wal_level = replica" >> /etc/postgresql/12/main/postgresql.conf
echo "max_wal_senders = 10" >> /etc/postgresql/12/main/postgresql.conf
echo "hot_standby = on" >> /etc/postgresql/12/main/postgresql.conf

systemctl stop postgresql

if [ "${index}" -eq "0" ]; then
  systemctl start postgresql
  sudo -u postgres psql -c "CREATE ROLE replica WITH REPLICATION LOGIN ENCRYPTED PASSWORD 'replica_pass';"
else
  echo "replica_pass" > /tmp/pgpass.txt
  chmod 600 /tmp/pgpass.txt
  echo "*:*:*:replica:replica_pass" > /root/.pgpass
  chmod 600 /root/.pgpass

  rm -rf /var/lib/postgresql/12/main
  pg_basebackup -h ${index == 0 ? "127.0.0.1" : "10.0.1.10"} -D /var/lib/postgresql/12/main -U replica -v -P --wal-method=stream -W <<EOF2
replica_pass
EOF2

  echo "standby_mode = 'on'" > /var/lib/postgresql/12/main/recovery.conf
  echo "primary_conninfo = 'host=10.0.1.10 port=5432 user=replica password=replica_pass'" >> /var/lib/postgresql/12/main/recovery.conf
  echo "trigger_file = '/tmp/postgresql.trigger.5432'" >> /var/lib/postgresql/12/main/recovery.conf

  chown -R postgres:postgres /var/lib/postgresql/12/main
  systemctl start postgresql
fi