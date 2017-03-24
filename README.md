# Bluemix Secure Gateway test environment
## Overview
A Vagrant provisioned environment for testing and demonstration of Bluemix Secure Gateway in a zoned environment.

The provisioner creates 2 security zones; a DMZ and a data tier called _zone1_. The environment can be used to demonstrate Bluemix Secure Gateway connectivity to resources residing in the data tier from an application hosted in Bluemix.

The deployment architecture is shown in Figure 1 (below).
(images/Deployment\ architecture.png)
* Figure 1: Environment deployment architecture.

## Configuration
### Host network interface
The Vagrantfile network staments assume the host is a Mac OSX. As a result the host network bridge NICs are referenced by the names _Wi-Fi (AirPort)_, _Thunderbolt 1_ and _Thunderbolt 2)_. These need to be mondified for the target host environment.

### Secure Gateway Client
The DMZ environment will start the Secure Gateway Client as a system up start process. The `sgenvironment.conf` file configure the gateway with the security token and ID of the Secure Gateway. Use the Bluemix Secure Gateway console to find the gateway ID and security token and copy these into the relevant location in the `SGClient_config/sgenvironment.conf` file before provisioning the virtual machines.

If you need to change the values after the virtual machine is provisioned, you can _ssh_ into the DMZ virtual machine, change the values in `/etc/ibm/sgenvironment.conf` and restart the Secure Gateway Client. To restart the Secure Gateway Client, execute the following command
```
$ sudo systemctl restart securegateway-client
```
### zone1
#### mysql-server
|user  |domain   |password|
|------|---------|--------|
|root  |localhost|zone1   |
|user01|localhost|user01  |
|user01|%        |user01  |

* port: 3306

## References
### Secure Gateway client installers
* [Linux client v1.7.0](https://sgmanagerqa1.integration.ibmcloud.com/installers/ibm-securegateway-client-1.7.0+client_amd64.deb)
* [MacOSX client v1.7.0](https://sgmanagerqa1.integration.ibmcloud.com/installers/ibm-securegateway-client-1.7.0+client_x86_64-MacOS-10.10.dmg)
* [Linux client v1.6.1fp1](https://sgmanager.ng.bluemix.net/installers/ibm-securegateway-client-1.6.1fp1+client_amd64.deb)
