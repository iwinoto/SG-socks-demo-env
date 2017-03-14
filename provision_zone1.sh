#!/bin/bash

sudo apt-get update
UBUNTU_HOME=/home/ubuntu
MYSQL_ROOT_PWORD=zone1

echo "configue IPTables"

echo "install mySQL"
# store password for debconf so we get a silent install
echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PWORD" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PWORD" | sudo debconf-set-selections
sudo apt-get -y install mysql-server
# sudo mysql_secure_installation
# copy config file
sudo cp /vagrant/sql/mysqld.cnf /etc/mysql/mysql.conf.d/
sudo service mysql restart

echo "Initialise database"
mysql --user=root --password=$MYSQL_ROOT_PWORD < /vagrant/sql/create_data_albums.sql
mysql --user=root --password=$MYSQL_ROOT_PWORD < /vagrant/sql/data.sql

echo "set up ssh keys to accept connections from dmz"
cat /vagrant/ssh/dmz/ubuntu/id_rsa.pub >> $UBUNTU_HOME/.ssh/authorized_keys
