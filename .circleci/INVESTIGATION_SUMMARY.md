# CircleCI Test Failure Investigation Summary

## Problem Analysis

### Current Situation
The CircleCI tests for the mojaloop/charts repository have been failing consistently. Based on the failure logs provided, the tests run through the following stages:

1. **build-and-test** - Passes (linting and chart updates)
2. **install-and-test-v1-20** - Fails (Kubernetes 1.20 installation test)
3. **install-and-test-v1-21** - Fails (Kubernetes 1.21 installation test)
4. **install-and-test-v1-22** - Fails (Kubernetes 1.22 installation test)

### Identified Issues from Logs

From the provided event logs, several issues were observed:

1. **MySQL Startup Failures**
   - Symptom: `Startup probe failed: mysqladmin: [Warning] Using a password on the command line interface can be insecure`
   - The mysql-0 pod is failing startup probes and being restarted repeatedly

2. **Kafka Connection Failures**
   - Symptom: `Readiness probe failed: dial tcp 10.42.0.10:9092: connect: connection refused`
   - Symptom: `Liveness probe failed: dial tcp 10.42.0.10:9092: connect: connection refused`
   - Kafka broker is not responding to health checks on port 9092

3. **Kafka Exporter CrashLoopBackOff**
   - Symptom: `Back-off restarting failed container`
   - The kafka-exporter is crashing repeatedly, likely because it can't connect to Kafka

4. **K3s Storage Warning**
   - Symptom: `invalid capacity 0 on image filesystem`
   - This may be a transient K3s issue but could indicate storage problems

### Root Cause of Inadequate Diagnostics

The **PRIMARY PROBLEM** is not necessarily that the tests are failing, but that **we don't have enough diagnostic information to determine WHY they are failing**.

The current diagnostic collection only captures:
- `kubectl get events --sort-by=.metadata.creationTimestamp` → stored in `/tmp/k8s_events`

This provides **minimal information**:
- ✓ Shows what happened (pod failed)
- ✗ Doesn't show WHY (no pod logs)
- ✗ Doesn't show configuration (no helm values)
- ✗ Doesn't show resource state (no node/resource info)
- ✗ Doesn't show detailed pod status (no kubectl describe)

## Solution Implemented

### Enhanced Diagnostic Collection

We've significantly enhanced the diagnostic artifact collection to provide comprehensive troubleshooting information when tests fail.

#### On Test Success (`/tmp/k8s_summary`)
Collect minimal summary for baseline comparison:
- Pod status
- Node information  
- Helm releases

#### On Test Failure (`/tmp/k8s_diagnostics`)
Collect extensive diagnostics including:

**Cluster State:**
- Kubernetes events (chronological)
- All pod statuses (wide format and YAML)
- Node information and resource availability
- StatefulSets, Deployments, Services status

**Helm Configuration:**
- Release status for 'be' and 'ml' releases
- Actual values used during deployment
- All helm releases in cluster

**Pod-Level Diagnostics:**
For each pod in the cluster:
- Full pod description (events, conditions, resources)
- Current logs from all containers
- Previous logs from crashed/restarted containers
- Init container logs

**Storage Information:**
- PersistentVolumeClaims status
- PersistentVolumes status

### Key Improvements

1. **Root Cause Analysis** - Pod logs will show actual application errors
2. **Resource Constraints** - Node descriptions show if resource limits are hit
3. **Configuration Issues** - Helm values show what was actually deployed
4. **Timing Issues** - Events and previous logs show startup/dependency problems
5. **Network Issues** - Service info and pod descriptions help debug connectivity

### Files Changed

1. **`.circleci/config.yml`**
   - Enhanced all three install-and-test jobs (v1-20, v1-21, v1-22)
   - Added comprehensive failure diagnostics
   - Added success summary for comparison
   - Changed artifact path from `/tmp/k8s_events` to `/tmp/k8s_diagnostics`

2. **`.circleci/DIAGNOSTICS.md`** (new file)
   - Complete guide to understanding collected diagnostics
   - Common failure patterns and how to diagnose them
   - Step-by-step diagnosis process
   - Known issues reference based on the provided logs

## Expected Benefits

### Immediate Benefits
1. **Faster Root Cause Identification** - Engineers can see actual application logs and errors
2. **Better Context** - Understand the full cluster state when failures occur
3. **Configuration Validation** - Verify helm values are correct
4. **Pattern Recognition** - Compare failures across different K8s versions

### Long-term Benefits
1. **Historical Analysis** - Archive of diagnostics for trend analysis
2. **Documentation** - Real examples for troubleshooting guide
3. **Prevention** - Identify patterns to prevent future issues
4. **Optimization** - Understand resource usage patterns

## Recommendations for Next Steps

Once these changes are merged and tests run again:

1. **Analyze New Artifacts**
   - Download the `/tmp/k8s_diagnostics` artifacts from next failed run
   - Follow the DIAGNOSTICS.md guide to identify root causes
   - Focus on pod logs for mysql-0, kafka-0, and kafka-exporter

2. **Common Issues to Investigate**
   - **Timeout Issues**: Are startup probes too aggressive? Should we increase timeout?
   - **Dependency Issues**: Is Kafka exporter starting before Kafka is ready?
   - **Resource Issues**: Are CircleCI machines under-resourced for K3s + full Mojaloop?
   - **Version Compatibility**: Are there K8s version-specific issues?

3. **Potential Fixes** (based on what diagnostics reveal)
   - Adjust probe timings in Helm charts
   - Add init containers for dependency checking
   - Increase resource allocations
   - Add retry logic or backoff
   - Update image versions if deprecated

## Testing These Changes

The changes are non-invasive and safe:
- Only add new diagnostic steps that run `when: on_fail`
- Use `|| true` to ensure diagnostic collection doesn't fail the job
- Don't modify any test logic or installation steps
- Add documentation without changing behavior

The next CircleCI run will:
- Run exactly the same tests as before
- If tests fail, collect much more diagnostic data
- If tests pass, collect minimal summary

## Conclusion

This enhancement transforms the CircleCI test failures from "something is broken" to actionable diagnostic data that can be used to identify and fix the root causes. The comprehensive artifacts will make it possible to diagnose whether issues are:

- Configuration problems (wrong helm values)
- Resource constraints (CPU/memory limits)
- Timing issues (probes too aggressive)
- Dependency problems (services starting in wrong order)
- Network issues (service discovery, DNS)
- Storage issues (PV/PVC provisioning)
- Version incompatibilities (K8s version specific)

This is a critical first step in resolving the persistent test failures.
