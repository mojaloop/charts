# Scripts , utilities and helpers.
## k8s-version-test.sh 
a small testing tool to (initially) enable testing and vertification of the Mojaloop V14 updates across multiple kubernetes versions

### Assumptions 
The tool is intended to be run as root inside a linux style operating system 
- It assumes the the operating system is up and running 
- It assumes that the operating system has internet access (NAT is ok) to download and install k3s, helm etc
- assumes the mojaloop charts repo is available inside the OS 
- it can be run from anywhere inside the running OS
- currently assumes k3s kubernetes engine , but it would be straightforward to add microk8s support
- assumes nginx ingress (again could be broadened later)
### motiovation 
As we transition the current helm2 based mojaloop charts to the new mojaloop v14 helm3 based structure, it became quickly evident that we need
a way to automatically test our development builds across multiple kubernetes releases and associated releases of the ingress controller. This script is now also incorporated 
the circle-ci pipleine to help automatically verify ML updates work across K8s releases

---

## populate_values.py
this development tool reduces maintenace burden by creating the parent helm chart values.yaml file from subcharts listed in the parent chart.yaml
dependencies section. The advantage here is that ML developers can simply craft the subchart values.yaml files and then automatically generate the
top level chart. this tool could be incorporated into the circl-ci pipleine in the future.

this tool requires python3 and the pyaml library (generally installed via pip)
For instructions just execute the script from the command line , e.g. 

`./scrips/populate_values.py -h`
`usage: populate_values.py [-h] -p PARENTCHART`

`Automate helm parent chart values.yaml creation`

`optional arguments:`
  `-h, --help            show this help message and exit`
  `-p PARENTCHART, --parentchart PARENTCHART`
                        `parent chart name`

---
## package.sh
creates and packages the helm charts for deployment 

## update-charts-dep.sh
packages charts for dev/test deployment.  On finalisation of the v14 release this script will become redundant.

---

## Some handy perl-1-liners used for v13->v14 upgrade

### to disable all the top-level resources with a backup prior to changing
`perl -i.bak -pe 's/^\s\senabled:.+$/  enabled: false/' values.yaml`

### to print the status of the top level modules 
`perl -ne 'print if /^\s\senabled:.+$/' values.yaml`

### print the top level resouces in a values file 
`perl -ne 'print if /^\w+:/' values.yaml`

