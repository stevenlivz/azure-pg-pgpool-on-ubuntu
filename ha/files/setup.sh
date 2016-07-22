#!/usr/bin/env bash

chown -R www-data .
chmod 755 /usr/local/bin/pgpool
chmod 755 /usr/local/bin/pcp_*
chmod 777 templates_c
chmod 644 conf/pgmgt.conf.php
#cp /usr/local/etc/pgpool.conf.sample /usr/local/etc/pgpool.conf
cp /usr/local/etc/pcp.conf.sample /usr/local/etc/pcp.conf
chown -R www-data /usr/local/etc
echo ${PCP_USER}:`pg_md5 ${PCP_PASS}` >> /usr/local/etc/pcp.conf
mkdir /var/run/pgpool
chown www-data /var/run/pgpool
rm -rf /var/www/install

#set up the rights on the ping files
chmod u+s /sbin/ifconfig
chmod u+s /usr/bin/arping

#set up the rights for the Apache user to start/stop the services and create the virtual ip
su -
mkdir -p /home/apache/sbin
chown www-data:www-data /home/apache/sbin
chmod 700 /home/apache/sbin
cp /sbin/ifconfig /home/apache/sbin
cp /usr/bin/arping /home/apache/sbin
chmod 4755 /home/apache/sbin/ifconfig
chmod 4755 /home/apache/sbin/arping

#NOT WORKING AS ENV IS NOT PASSED set up the pgpool.conf for master or slave
#if [[ ${MODE} == 'master' ]]; then
#if [ ${MODE} = 'master' ]
#then
#echo "master====="
#  mv /usr/local/etc/pgpool.master.conf /usr/local/etc/pgpool.conf
#else
#  mv /usr/local/etc/pgpool.slave.conf /usr/local/etc/pgpool.conf
#  echo "slave====="
#fi

# failover folder
mkdir /usr/local/src/pgpool
mkdir /usr/local/src/pgpool/fail
chown -R www-data /usr/local/src/pgpool
mv /usr/local/etc/failover.sh /usr/local/src/pgpool/fail/failover.sh
chmod -R 0777 /usr/local/src/pgpool

cd /usr/local/etc
echo $PCP_USER
echo $PCP_PASS
pg_md5 -m -u $PCP_USER $PCP_PASS
pg_md5 -m -u $PG_REPL_USER $PG_REPL_PASS
chown www-data pool_passwd

# inject the local ip data into the