# Bluemix Secure Gateway test environment
## Overview
A Vagrant provisioned environment for testing and demonstration of Bluemix Secure Gateway in a zoned environment.

The provisioner creates 2 security zones; a DMZ and a data tier called _zone1_. The environment can be used to demonstrate Bluemix Secure Gateway connectivity to resources residing in the data tier from an application hosted in Bluemix.

The deployment architecture is shown in Figure 1 (below).
![Deployment architecture](/images/Deployment_architecture.png)
* Figure 1: Environment deployment architecture.

## Configuration
### Host network interface
The Vagrantfile network staments assume the host is a Mac OSX. As a result the host network bridge NICs are referenced by the names _Wi-Fi (AirPort)_, _Thunderbolt 1_ and _Thunderbolt 2)_. These need to be mondified for the target host environment.

### Secure Gateway Client
The DMZ environment will start the Secure Gateway Client as a system up start process. The `sgenvironment.conf` file configure the gateway with the security token and ID of the Secure Gateway. Use the Bluemix Secure Gateway console to find the gateway ID and security token and copy these into the relevant location in the `SGClient_config/sgenvironment.conf` file before provisioning the virtual machines.

If you need to change the values after the virtual machine is provisioned, you can _ssh_ into the DMZ virtual machine, change the values in `/etc/ibm/sgenvironment.conf` and restart the Secure Gateway Client. To restart the Secure Gateway Client, execute the following command
```
dmz$ sudo systemctl restart securegateway-client
```
## Setup Vagrant with VirtualBox

Follow the instructions on the Installing Vagrant page.

## Bootstrap the environment

To construct the environment, from a terminal, clone the repository to your workstation. From a terminal, change to the cloned directory and execute
```
$ vagrant up
```
Note: vagrant up may fail with an error about `ubuntu/xenial64` not being found and needing to login to hashicorp. This is due to a [buggy curl utility embedded in Vagrant (on OSX `opt/vagrant/embedded/bin/curl`)][http://superuser.com/questions/1088198/cant-vagrant-up-atlassian-box]. You can resolve this by removing (or renaming) the buggy utility.

All going well, `vagrant up` will download and provision the virtual machine. This step may take some time. The output may also contain some red text. The provisioning scripts have been repeatedly tested, and this is expected.

## Connect to the demonstration environment

Once the virtual machine provisioning is complete, you can open a secure shell to the `dmz` virtual machine with
```
$ vagrant ssh
```
The `dmz` virtual machine is the default. To connect to the `zone1` virtual machine, use
```
$ vagrant ssh zone1
```

_*Note:* On starting the ssh session you may see a message of `*** System restart required ***`. Exit the ssh session and halt the virtual machine with `vagrant halt` and start it again with `vagrant up`. This will restart the virtual machine without re-provisioning. Then restart the ssh session._

## Shutdown

When you have finished and want to shutdown the virtual machine, first exit the ssh session. Then halt the virtual machine from the command line

```
$ vagrant halt
```
You can then restart the virtual machine with `vagrant up`.

After restarting the `dmz`, the SSH proxy will not be started. Restart the SSH proxy by connecting to the `dmz` and executing:
```
dmz$ sudo ssh -f -N -D 1080 192.168.33.11
```

You can also completely destroy the virtual machine with

```
$ vagrant destroy
```
After you have destroyed the virtual machine you can rebuild it with `vagrant up`.

## The environment
The Vagrantfile will provision 2 virtual machines called `dmz` and `zone1`. `zone1` contains the mySQL server.
### zone1
#### mysql-server
|user  |domain   |password|
|------|---------|--------|
|root  |localhost|zone1   |
|user01|localhost|user01  |
|user01|%        |user01  |

* port: 3306

## Issues, suggestions
Please add an [issue](https://github.com/iwinoto/SG-socks-demo-env/issues) in the github repo.

## References
* [Secure Gateway documentation](https://console.ng.bluemix.net/docs/services/SecureGateway/secure_gateway.html)
