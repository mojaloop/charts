# k8s-version-test.sh 
a small testing tool to (initially) enable testing and vertification of the Mojaloop V14 updates across multiple kubernetes versions

# Assumptions 
The tool is intended to be run as root inside a linux style operating system 
- It assumes the the operating system is up and running 
- It assumes that the operating system has internet access (NAT is ok) to download and install k3s, helm etc
- assumes the mojaloop charts repo is available inside the OS 
- it can be run from anywhere inside the running OS
- currently assumes k3s kubernetes engine , but it would be straightforward to add microk8s support
- assumes nginx ingress (again could be broadened later)


# motiovation 
As we transition the current helm2 based mojaloop charts to the new mojaloop v14 helm3 based structure, it became quickly evident that we need
a way to automatically test our development builds across multiple kubernetes releases and associated releases of the ingress controller

# instructions 
as root user 
```
git clone https://github.com/tdaly61/mini-loop.git
cd mini-loop/vbox-deploy
vagrant up
```
