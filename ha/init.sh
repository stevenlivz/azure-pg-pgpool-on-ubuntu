#!/usr/bin/env bash

# from dockerfile

sudo apt-get update
sudo apt-get install -y apache2 libapache2-mod-php5 curl build-essential libpq-dev
curl -L -o pgpool-II-3.5.3.tar.gz http://www.pgpool.net/mediawiki/download.php?f=pgpool-II-3.5.3.tar.gz
tar zxvf pgpool-II-3.5.3.tar.gz
cd pgpool-II-3.5.3
sudo ./configure
sudo make
sudo make install
sudo ldconfig
cd /var/www
sudo curl -O http://www.pgpool.net/mediawiki/images/pgpoolAdmin-3.5.3.tar.gz
sudo tar --strip-components=1 -zxvf pgpoolAdmin-3.5.3.tar.gz
sudo -i
APACHE_RUN_USER=www-data
APACHE_RUN_GROUP=www-data
APACHE_LOG_DIR=/var/log/apache2
PG_REPL_USER=replicator
PG_REPL_PASS=password
PCP_USER=muser
PCP_PASS=password

echo "<?php
define('_PGPOOL2_LANG','en');
define('_PGPOOL2_CONFIG_FILE','/usr/local/etc/pgpool.conf');
define('_PGPOOL2_PASSWORD_FILE','/usr/local/etc/pcp.conf');
define('_PGPOOL2_COMMAND','/usr/local/bin/pgpool');
define('_PGPOOL2_CMD_OPTION_C','0');
define('_PGPOOL2_CMD_OPTION_LARGE_D','0');
define('_PGPOOL2_CMD_OPTION_D','0');
define('_PGPOOL2_CMD_OPTION_M','f');
define('_PGPOOL2_CMD_OPTION_N','1');
define('_PGPOOL2_LOG_FILE','/tmp/pgpool.log');
define('_PGPOOL2_PCP_DIR','/usr/local/bin');
define('_PGPOOL2_PCP_HOSTNAME','localhost');
define('_PGPOOL2_PCP_TIMEOUT','10');
define('_PGPOOL2_STATUS_REFRESH_TIME','10');
?>" > /var/www/conf/pgmgt.conf.php

