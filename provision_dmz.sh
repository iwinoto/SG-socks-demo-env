#!/bin/bash

# What the SG dev lab used:  https://www.socks-proxy.net/
# They had to shuffle the proxies a bit before we found one that works.
# Try simple SSH based SOCK5 proxy
# ref: http://www.catonmat.net/blog/linux-socks5-proxy/
#

sudo apt-get update
UBUNTU_HOME=/home/ubuntu

echo "configue IPTables"
# Only requests from BMX public Secure Gateway to SOCKS proxy are accepted.
# Any other connection to SOCKS proxy is dropped.
# Accept requests to SG dashboard on both NICs
sudo iptables -I INPUT -i enp0s9 -p tcp --dport 9003 -j ACCEPT
sudo iptables -I INPUT -i enp0s8 -p tcp --dport 9003 -j ACCEPT
# Accept outbound to SG server ports
sudo iptables -I OUTPUT -o enp0s9 -p tcp --dport 443 -j ACCEPT
sudo iptables -I OUTPUT -o enp0s9 -p tcp --dport 9000 -j ACCEPT

echo "set up ssh (config and keys)"
cp /vagrant/ssh/dmz/ubuntu/config $UBUNTU_HOME/.ssh
cp /vagrant/ssh/dmz/ubuntu/id_rsa $UBUNTU_HOME/.ssh
cat /vagrant/ssh/dmz/ubuntu/id_rsa.pub >> $UBUNTU_HOME/.ssh/authorized_keys
sudo chown -R ubuntu:ubuntu $UBUNTU_HOME/.ssh/

echo "set up SOCKS"
# ref: http://www.catonmat.net/blog/linux-socks5-proxy/
# Bound (-b) to the private NIC fixed IP 192.168.33.10
ssh -f -N -b 192.168.33.10 -D 0.0.0.0:1080 localhost

echo "install Secure Gateway client"
SG_VER=1.7.0
# Download QA1 from https://sgmanagerqa1.integration.ibmcloud.com/gwManager/{org_id}/{space_id}
# https://sgmanagerqa1.integration.ibmcloud.com/installers/ibm-securegateway-client-1.7.0+client_amd64.deb
sudo mkdir -p /etc/ibm/secure-gateway
sudo cp //vagrant/SGClient_config/sgenvironment.conf /etc/ibm/sgenvironment.conf
sudo cp /vagrant/SGClient_config/aclconfig /etc/ibm/secure-gateway

# QA1 download site does not have a ca signed cert, so need to use --no-check-certificate
#wget --no-check-certificate -O ibm-securegateway-client_amd64.deb https://sgmanagerqa1.integration.ibmcloud.com/installers/ibm-securegateway-client-1.7.0+client_amd64.deb
cp /vagrant/securegateway_client-1.7.0/ibm-securegateway-client-1.7.0_amd64.deb ibm-securegateway-client_amd64.deb
sudo dpkg -i ibm-securegateway-client_amd64.deb

echo "Install mysql-client for testing the connection to zone1"
sudo apt-get install mysql-client
