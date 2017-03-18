#!/bin/bash

# What the SG dev lab used:  https://www.socks-proxy.net/
# They had to shuffle the proxies a bit before we found one that works.
# Try simple SSH based SOCK5 proxy
# ref: http://www.catonmat.net/blog/linux-socks5-proxy/
#

sudo apt-get update
UBUNTU_HOME=/home/ubuntu

echo "set up ssh (config and keys)"
sudo -u ubuntu cp /vagrant/server-config/dmz/ssh/ubuntu/config $UBUNTU_HOME/.ssh
sudo -u ubuntu cp /vagrant/server-config/dmz/ssh/ubuntu/id_rsa $UBUNTU_HOME/.ssh
#cat /vagrant/server-config/dmz/ssh/ubuntu/id_rsa.pub >> $UBUNTU_HOME/.ssh/authorized_keys
sudo chown -R ubuntu:ubuntu $UBUNTU_HOME/.ssh/
sudo chmod go-r -R $UBUNTU_HOME/.ssh/

sudo cp /vagrant/server-config/dmz/ssh/ubuntu/config /root/.ssh
sudo cp /vagrant/server-config/dmz/ssh/ubuntu/id_rsa /root/.ssh
#cat /vagrant/server-config/dmz/ssh/ubuntu/id_rsa.pub >> $UBUNTU_HOME/.ssh/authorized_keys
sudo chown -R root:root /root/.ssh/
sudo chmod go-r -R /root/.ssh/

echo "set up SOCKS proxy to zone1"
# ref: http://www.catonmat.net/blog/linux-socks5-proxy/
sudo ssh -f -N -D 1080 192.168.33.11

echo "install Secure Gateway client"
SG_VER=1.7.0
# Download QA1 from https://sgmanagerqa1.integration.ibmcloud.com/gwManager/{org_id}/{space_id}
# https://sgmanagerqa1.integration.ibmcloud.com/installers/ibm-securegateway-client-1.7.0+client_amd64.deb
sudo mkdir -p /etc/ibm/secure-gateway
sudo cp /vagrant/SGClient_config/sgenvironment.conf /etc/ibm/sgenvironment.conf
sudo cp /vagrant/SGClient_config/aclconfig /etc/ibm/secure-gateway

# QA1 download site does not have a ca signed cert, so need to use --no-check-certificate
wget --no-check-certificate -qO ibm-securegateway-client_amd64.deb https://sgmanager.au-syd.bluemix.net/installers/ibm-securegateway-client-1.7.0+client_amd64.deb
#cp /vagrant/securegateway_client/ibm-securegateway-client-1.7.0_amd64-unknown.deb ibm-securegateway-client_amd64.deb
sudo dpkg -i ibm-securegateway-client_amd64.deb

echo "Install mysql-client for testing the connection to zone1"
sudo apt-get -y install mysql-client

echo "configue IPTables"
#sudo iptables-restore < /vagrant/server-config/dmz/iptables-rules.v4
