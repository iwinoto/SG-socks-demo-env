#!/bin/bash

UBUNTU_HOME=/home/ubuntu

echo configue IPTables

echo install service

echo set up ssh keys to accept connections from dmz
cat /vagrant/ssh/dmz/id_rsa.pub >> $UBUNTU_HOME/.ssh/authorized_keys
