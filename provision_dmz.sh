#!/bin/bash

# What the SG dev lab used:  https://www.socks-proxy.net/
# They had to shuffle the proxies a bit before we found one that works.
# Try simple SSH based SOCK5 proxy
# ref: http://www.catonmat.net/blog/linux-socks5-proxy/
#

echo install Secure Gateway client
SG_VER=1.7.0
# Download QA1 from https://sgmanagerqa1.integration.ibmcloud.com/gwManager/{org_id}/{space_id}
# https://sgmanagerqa1.integration.ibmcloud.com/installers/ibm-securegateway-client-1.7.0+client_amd64.deb
sudo mkdir -p /etc/ibm/secure-gateway
sudo cp //vagrant/SGClient_config/sgenvironment.conf /etc/ibm/sgenvironment.conf

sudo cp /vagrant/SGClient_config/aclconfig /etc/ibm/secure-gateway

# QA1 download site does not have a ca signed cert, so need to use --no-check-certificate
wget --no-check-certificate -O ibm-securegateway-client_amd64.deb https://sgmanagerqa1.integration.ibmcloud.com/installers/ibm-securegateway-client-1.7.0+client_amd64.deb

echo configue IPTables
# Only requests from BMX public Secure Gateway to SOCKS proxy are accepted.
# Any other connection to SOCKS proxy is dropped.

echo set up SOCKS
ssh -f -N -D 0.0.0.0:1080 localhost
