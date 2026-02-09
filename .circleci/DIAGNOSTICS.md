# CircleCI Diagnostic Artifacts Guide

This document describes the diagnostic artifacts collected during CircleCI test runs to help diagnose failures in the Mojaloop charts installation and testing.

## Artifact Collection

### On Success (`/tmp/k8s_summary`)
When tests pass successfully, a minimal summary is collected for baseline comparison:

- `pods-status.log` - Current status of all pods
- `nodes.log` - Cluster node information
- `helm-releases.log` - List of deployed Helm releases

### On Failure (`/tmp/k8s_diagnostics`)
When tests fail, comprehensive diagnostics are automatically collected:

#### Core Diagnostics
- `00-collection.log` - Collection process log showing what was gathered
- `01-events.log` - Kubernetes events sorted chronologically
- `02-pods-status.log` - Pod status in wide format
- `03-pods-yaml.log` - Full YAML definitions of all pods

#### Cluster Information
- `04-nodes.log` - Node status and information
- `05-nodes-describe.log` - Detailed node descriptions including resource usage

#### Helm Information
- `06-helm-releases.log` - All Helm releases across namespaces
- `07-helm-be-status.log` - Status of the backend (be) release
- `08-helm-ml-status.log` - Status of the Mojaloop (ml) release
- `09-helm-be-values.log` - Values used for backend release
- `10-helm-ml-values.log` - Values used for Mojaloop release

#### Workload Information
- `11-statefulsets.log` - StatefulSet status
- `12-statefulsets-describe.log` - Detailed StatefulSet descriptions
- `13-deployments.log` - Deployment status
- `14-deployments-describe.log` - Detailed Deployment descriptions
- `15-services.log` - Service information
- `16-pvc.log` - PersistentVolumeClaim status
- `17-pv.log` - PersistentVolume status

#### Pod-Specific Diagnostics
For each pod, the following files are generated:

- `pod-describe-{pod-name}.log` - Detailed pod description including events, conditions, and resource usage
- `pod-logs-{pod-name}-{container-name}.log` - Current logs from each container
- `pod-logs-{pod-name}-{container-name}-previous.log` - Logs from previous container instance (if crashed/restarted)
- `pod-logs-{pod-name}-init-{container-name}.log` - Logs from init containers

**Note:** Pod and container names are sanitized in filenames (non-alphanumeric characters except hyphens are replaced with underscores) to ensure filesystem compatibility.

## Common Failure Patterns and How to Diagnose

### Pod Failing Health Checks
**Symptoms in logs:** `Readiness probe failed`, `Liveness probe failed`, `Startup probe failed`

**Files to check:**
1. `pod-describe-{pod-name}.log` - Check Events section for failure details
2. `pod-logs-{pod-name}-{container-name}.log` - Check application logs for errors
3. `pod-logs-{pod-name}-{container-name}-previous.log` - If pod restarted, check why
4. `02-pods-status.log` - Check if container is actually running

**Example from issue logs:**
```
Startup probe failed: mysqladmin: [Warning] Using a password on the command line interface can be insecure....
Container mysql failed startup probe, will be restarted
```
→ Check `pod-logs-mysql-0-mysql.log` for full MySQL startup logs

### Pod Stuck in Pending/ContainerCreating
**Files to check:**
1. `pod-describe-{pod-name}.log` - Check Events for scheduling issues
2. `05-nodes-describe.log` - Check node resource availability
3. `16-pvc.log` and `17-pv.log` - Check if volumes are being created

### Image Pull Failures
**Symptoms:** `ImagePullBackOff`, `ErrImagePull`

**Files to check:**
1. `pod-describe-{pod-name}.log` - Check Events for image pull errors
2. `01-events.log` - Look for image pull messages

### StatefulSet/Deployment Not Ready
**Files to check:**
1. `12-statefulsets-describe.log` or `14-deployments-describe.log` - Check conditions and events
2. Pod logs for the specific pods in the StatefulSet/Deployment

### Network/Service Issues
**Files to check:**
1. `15-services.log` - Check service endpoints
2. `pod-describe-{pod-name}.log` - Check if pod has correct labels and annotations
3. Application logs - Check for connection errors

### Resource Constraints
**Symptoms:** Pods evicted, OOMKilled, or not scheduling

**Files to check:**
1. `05-nodes-describe.log` - Check Allocated resources vs Capacity
2. `pod-describe-{pod-name}.log` - Check resource requests/limits and State Reason
3. `01-events.log` - Look for eviction or resource-related messages

## Analyzing the Diagnostics

### Step-by-Step Diagnosis Process

1. **Start with `00-collection.log`** - Verify all diagnostics were collected successfully

2. **Check `02-pods-status.log`** - Identify which pods are not in Running/Completed state

3. **For each problematic pod:**
   - Open `pod-describe-{pod-name}.log`
   - Check the "Events" section at the bottom - this usually shows the immediate cause
   - Check the "State" and "Last State" of containers
   - Check resource requests vs node capacity

4. **Review pod logs:**
   - Check current logs: `pod-logs-{pod-name}-{container}.log`
   - If restarted, check previous logs: `pod-logs-{pod-name}-{container}-previous.log`
   - Look for application-level errors, connection failures, configuration issues

5. **Check Helm status:**
   - Review `07-helm-be-status.log` and `08-helm-ml-status.log`
   - Compare values in `09-helm-be-values.log` and `10-helm-ml-values.log` against expected configuration

6. **Review cluster state:**
   - Check `04-nodes.log` - Are nodes Ready?
   - Check `05-nodes-describe.log` - Are there resource constraints?
   - Check `01-events.log` chronologically - What sequence of events led to failure?

## Known Issues Reference

Based on the provided failure logs, common issues include:

### MySQL Startup Probe Failures
- **Symptom:** `Startup probe failed: mysqladmin: [Warning] Using a password...`
- **Investigation:** Check if MySQL is starting slowly, increase startup probe timeout
- **Files:** `pod-logs-mysql-0-mysql.log`, `pod-describe-mysql-0.log`

### Kafka Connection Refused
- **Symptom:** `Readiness probe failed: dial tcp 10.42.0.10:9092: connect: connection refused`
- **Investigation:** Check Kafka broker startup, Zookeeper connectivity, network policies
- **Files:** `pod-logs-kafka-0-kafka.log`, `pod-logs-be-zookeeper-0-zookeeper.log`

### Kafka Exporter BackOff
- **Symptom:** `Back-off restarting failed container`
- **Investigation:** Check if Kafka is available when exporter starts, dependency ordering
- **Files:** `pod-logs-kafka-exporter-*-kafka-exporter.log`

### Invalid Disk Capacity
- **Symptom:** `invalid capacity 0 on image filesystem`
- **Investigation:** K3s storage configuration issue, may be transient
- **Files:** `05-nodes-describe.log`

## Tips

- Use `grep -r "error\|failed\|warning" /tmp/k8s_diagnostics/` to quickly find issues
- Compare success (`/tmp/k8s_summary`) vs failure (`/tmp/k8s_diagnostics`) artifacts between runs
- Pay attention to timestamps in `01-events.log` to understand the sequence of failures
- Check init container logs when pods are stuck in Init state
- Resource exhaustion often shows up in node descriptions before pods fail
