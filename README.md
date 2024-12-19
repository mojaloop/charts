# Mojaloop Helm Charts

Please see https://github.com/mojaloop/helm for the Official Mojaloop Helm Charts.

Here you will find the Business Operational Helm Charts for Reporting Services, UIs, and Portals. 

**NOTE: These will be migrated into the https://github.com/mojaloop/helm repo in the near future.**

[![Git Commit](https://img.shields.io/github/last-commit/mojaloop/charts.svg?style=flat)](https://github.com/mojaloop/charts/commits/master)
[![Git Releases](https://img.shields.io/github/release/mojaloop/charts.svg?style=flat)](https://github.com/mojaloop/charts/releases)
[![CircleCI](https://circleci.com/gh/mojaloop/charts.svg?style=svg)](https://circleci.com/gh/mojaloop/charts)

## Quick Links

- [https://mojaloop.github.io/charts/](https://mojaloop.github.io/charts) Mojaloop Published Helm Repo
- [Documentation - Deploying Mojaloop](https://docs.mojaloop.io/documentation/deployment-guide)
- [Helm v3 Docs](https://docs.helm.sh/)

## Published Helm Chart Repo

```bash
helm repo add mojaloop-charts https://mojaloop.github.io/charts/repo
```

## Todo

- Refer to task list on [Helm v14.0.0 PoC #2459](https://github.com/mojaloop/project/issues/2459) story.

## Examples

```bash
$ curl http://admin-api-svc.local/health -s | jq
{
  "status": "OK",
  "uptime": 432.941249354,
  "startTime": "2021-09-23T15:21:24.832Z",
  "versionNumber": "13.14.0",
  "services": [
    {
      "name": "datastore",
      "status": "OK"
    },
    {
      "name": "broker",
      "status": "OK"
    }
  ]
}
```

```bash
$ curl http://transfer-api-svc.local/health -s | jq
{
  "status": "OK",
  "uptime": 468.390242422,
  "startTime": "2021-09-23T15:21:57.276Z",
  "versionNumber": "11.1.6",
  "services": [
    {
      "name": "broker",
      "status": "OK"
    }
  ]
}
```

```bash
$ curl --location --request POST 'http://admin-api-svc.local/participants/Hub/accounts' \
--header 'Content-Type: application/json' \
--header 'FSPIOP-Source: hub_operator' \
--data-raw '{
  "type": "HUB_MULTILATERAL_SETTLEMENT",
  "currency": "USD"
}' -s | jq
{
  "name": "Hub",
  "id": "admin-api-svc.local/participants/Hub",
  "created": "\"2021-09-23T14:59:52.000Z\"",
  "isActive": 1,
  "links": {
    "self": "admin-api-svc.local/participants/Hub"
  },
  "accounts": [
    {
      "id": 1,
      "ledgerAccountType": "HUB_MULTILATERAL_SETTLEMENT",
      "currency": "USD",
      "isActive": 1,
      "createdDate": "2021-09-23T15:23:11.655Z",
      "createdBy": "unknown"
    }
  ]
}
```

```bash
$ curl http://admin-api-svc.local/participants/Hub/accounts -s | jq
[
  {
    "id": 1,
    "ledgerAccountType": "HUB_MULTILATERAL_SETTLEMENT",
    "currency": "USD",
    "isActive": 1,
    "value": 0,
    "reservedValue": 0,
    "changedDate": "2021-09-23T15:23:11.000Z"
  }
]
```

```bash
$ DATE_ISO=$(date -u +%a,\ %d\ %b\ %Y\ %H:%M:%S\ GMT) && curl -v 'http://transfer-api-svc.local/transfers' \
-H 'content-type: application/vnd.interoperability.transfers+json;version=1.0' \
-H 'accept: application/vnd.interoperability.transfers+json;version=1.0' \
-H 'fspiop-source: testingtoolkitdfsp' \
-H "date: $DATE_ISO" \
-H 'traceparent: 00-aabb25a42b01c8c9fe741a6fa3b77d94-0123456789abcdef0-00' \
--data-binary '
  {
    "transferId": "6477570c-8bd4-4624-86f5-ef24e284c67b",
    "payerFsp": "testingtoolkitdfsp",
    "payeeFsp": "mojapayeefsp",
    "amount": {
        "amount": "100",
        "currency": "USD"
    },
    "expiration": "2021-09-20T11:48:45.325Z",
    "ilpPacket": "AYIDRQAAAAAAACcQJGcubW9qYXBheWVlZnNwLm1zaXNkbi4yNzcxMzgwMzkxMi4zMIIDFGV5SjBjbUZ1YzJGamRHbHZia2xrSWpvaU5qUTNOelUzTUdNdE9HSmtOQzAwTmpJMExUZzJaalV0WldZeU5HVXlPRFJqTmpkaUlpd2ljWFZ2ZEdWSlpDSTZJbUZsWkRFd05ESXpMV001WkRRdE5EYzBNUzA0WW1WaUxXRXhNRGN5TXpobE56QmtZU0lzSW5CaGVXVmxJanA3SW5CaGNuUjVTV1JKYm1adklqcDdJbkJoY25SNVNXUlVlWEJsSWpvaVRWTkpVMFJPSWl3aWNHRnlkSGxKWkdWdWRHbG1hV1Z5SWpvaU1qYzNNVE00TURNNU1USWlMQ0p3WVhKMGVWTjFZa2xrVDNKVWVYQmxJam9pTXpBaUxDSm1jM0JKWkNJNkltMXZhbUZ3WVhsbFpXWnpjQ0o5ZlN3aWNHRjVaWElpT25zaWNHRnlkSGxKWkVsdVptOGlPbnNpY0dGeWRIbEpaRlI1Y0dVaU9pSk5VMGxUUkU0aUxDSndZWEowZVVsa1pXNTBhV1pwWlhJaU9pSTBOREV5TXpRMU5qYzRPU0lzSW1aemNFbGtJam9pZEdWemRHbHVaM1J2YjJ4cmFYUmtabk53SW4wc0luQmxjbk52Ym1Gc1NXNW1ieUk2ZXlKamIyMXdiR1Y0VG1GdFpTSTZleUptYVhKemRFNWhiV1VpT2lKR2FYSnpkRzVoYldVdFZHVnpkQ0lzSW14aGMzUk9ZVzFsSWpvaVRHRnpkRzVoYldVdFZHVnpkQ0o5TENKa1lYUmxUMlpDYVhKMGFDSTZJakU1T0RRdE1ERXRNREVpZlgwc0ltRnRiM1Z1ZENJNmV5SmhiVzkxYm5RaU9pSXhNREFpTENKamRYSnlaVzVqZVNJNklsVlRSQ0o5TENKMGNtRnVjMkZqZEdsdmJsUjVjR1VpT25zaWMyTmxibUZ5YVc4aU9pSlVVa0ZPVTBaRlVpSXNJbWx1YVhScFlYUnZjaUk2SWxCQldVVlNJaXdpYVc1cGRHbGhkRzl5Vkhsd1pTSTZJa05QVGxOVlRVVlNJbjE5AA",
    "condition": "_YT6473R3MB5wf5nvnjDHz42gnlxTYTbpAcBUihJoB8"
  }' --compressed

*   Trying 10.1.2.87...
* TCP_NODELAY set
* Connected to transfer-api-svc.local (10.1.2.87) port 80 (#0)
> POST /transfers HTTP/1.1
> Host: transfer-api-svc.local
> User-Agent: curl/7.64.1
> Accept-Encoding: deflate, gzip
> content-type: application/vnd.interoperability.transfers+json;version=1.0
> accept: application/vnd.interoperability.transfers+json;version=1.0
> fspiop-source: testingtoolkitdfsp
> date: Thu, 23 Sep 2021 15:59:17 GMT
> traceparent: 00-aabb25a42b01c8c9fe741a6fa3b77d94-0123456789abcdef0-00
> Content-Length: 1462
> Expect: 100-continue
>
< HTTP/1.1 100 Continue
* We are completely uploaded and fine
< HTTP/1.1 202 Accepted
< Date: Thu, 23 Sep 2021 15:59:23 GMT
< Content-Length: 0
< Connection: keep-alive
< cache-control: no-cache
<
* Connection #0 to host transfer-api-svc.local left intact
* Closing connection 0
```

## Running Locally

This can be useful for debugging CI/CD issues.

### Pre-requisites

1. Make sure you run the following commands to add all Repo dependencies...

    ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    ## The following repo is a Work-around for Bitnami retention policy issue: https://github.com/bitnami/charts/issues/10539, fix: https://github.com/mojaloop/project/issues/2815
    helm repo add bitnami-full-index https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami
    helm repo add ory https://k8s.ory.sh/helm/charts
    helm repo add kowl https://raw.githubusercontent.com/cloudhut/charts/master/archives
    helm repo add reporting-k8s-templates https://mojaloop.github.io/reporting-k8s-templates
    helm repo update
    ```

2. Run the following commands to update the full helm dependency tree...

    > _Note: Ensure you do this after making any changes to default values or templates._

    ```bash
    sh ./scripts/update-charts-dep.sh
    ```

### Running

You can run the `k8s-version-test.sh` script locally to help verify your deployment.

For example:

```bash
# install k8s v1.21, and run the test
./scripts/update-charts-dep.sh
sudo CHARTS_WORKING_DIR=`pwd` ./scripts/k8s-versions-test.sh \
  -m install -v v1.21 -u `whoami` -t 1000s

```

> Note: this currently doesn't work on m1 Macs! The MYSQL docker container doesn't have
> support for arm64 architectures

### Check the k8s event logs

When a build fails, we write the k8s events to a log and store it as an artifact on circleci:

```bash
kubectl get events --sort-by=.metadata.creationTimestamp > /tmp/k8s_events
```

You can check the output of this log to determine if the error is related to pods not starting etc.

### Log in, and get pods

On CircleCI, click "Rerun job with ssh" > Copy and paste the `ssh` command into your command line

```bash
export k8s_user=circleci
export KUBECONFIG=/home/$k8s_user/k3s.yaml
# get pods
kubectl get po

# get events from cluster:
kubectl get events --sort-by=.metadata.creationTimestamp
```
