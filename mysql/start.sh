#!/bin/bash

MYSQL_ADMIN="/usr/bin/mysqladmin"
INITDB="/usr/bin/mysql_install_db"

DATADIR="/var/lib/mysql/mysql"


if ! mysql -u root -ppassword -e 'show databases'>/dev/null;then
    echo "Initializing MySQL Database at $DATADIR"
    chown -R mysql $DATADIR
    $INITDB

    echo "Bootstraping MySQL Server..."
    /etc/init.d/mysqld start &
    MYSQL_PID=$!
    wait $MYSQL_PID

    # mysql_secure_installation
    $MYSQL_ADMIN -u root password "password"
    mysql -u root -ppassword -e "DELETE FROM mysql.user WHERE User='';"
    mysql -u root -ppassword -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');"
    mysql -u root -ppassword -e "DROP DATABASE test;"
    mysql -u root -ppassword -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    mysql -u root -ppassword -e "FLUSH PRIVILEGES;"

    echo "Finish Bootstraping MySQL Server"
else
    echo "Starting Mysql Server"
    /etc/init.d/mysqld start
fi
