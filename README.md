
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Istio Sidecar Proxy Restart Alert

This incident type refers to an alert triggered when the sidecar proxy of Istio, a popular service mesh for microservices, restarts unexpectedly. The sidecar proxy is a crucial component that handles traffic between microservices and the Istio control plane. Restarting unexpectedly can cause disruptions in the communication between microservices, leading to potential service outages and performance issues.

### Parameters

```shell
export NAMESPACE="PLACEHOLDER"
export POD_NAME="PLACEHOLDER"
export ISTIO_PILOT_POD_NAME="PLACEHOLDER"
export ISTIO_CITADEL_POD_NAME="PLACEHOLDER"
export DEPLOYMENT_NAME="PLACEHOLDER"
export RESOURCE_LIMIT="PLACEHOLDER"
export RESOURCE_REQUEST="PLACEHOLDER"
```

## Debug

### List all pods in the namespace where the incident occurred

```shell
kubectl get pods -n ${NAMESPACE}
```

### Get the logs for the Istio sidecar proxy container in a problematic pod

```shell
kubectl logs ${POD_NAME} -c istio-proxy -n ${NAMESPACE}
```

### Check the events related to the pod

```shell
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}
```

### Check the status of the Istio sidecar proxy container in the pod

```shell
kubectl get pod ${POD_NAME} -n ${NAMESPACE} -o jsonpath='{.status.containerStatuses[?(@.name=="istio-proxy")].state}'
```

### Check the logs of the Istio Pilot container in the control plane

```shell
kubectl logs ${ISTIO_PILOT_POD_NAME} -c discovery -n ${NAMESPACE}
```

### Check the logs of the Istio Citadel container in the control plane

```shell
kubectl logs ${ISTIO_CITADEL_POD_NAME} -c citadel -n ${NAMESPACE}
```

## Repair

### Check the resources allocated to the Istio Sidecar Proxy. If the pod is running out of memory or CPU, increase the allocated resources or adjust the resource quotas to deployment and ensure sufficient resources are available.

```shell
bash
#!/bin/bash

# Define variables
NAMESPACE=${NAMESPACE}
DEPLOYMENT_NAME=${DEPLOYMENT_NAME}
RESOURCE_LIMIT=${RESOURCE_LIMIT} # e.g. 500Mi or 1Gi
RESOURCE_REQUEST=${RESOURCE_REQUEST} # e.g. 200Mi or 500Mi

# Increase the resource limit for the Istio Sidecar Proxy
kubectl -n $NAMESPACE patch deployment $DEPLOYMENT_NAME -p '{"spec":{"template":{"spec":{"containers":[{"name":"istio-proxy","resources":{"limits":{"memory":"'$RESOURCE_LIMIT'"},"requests":{"memory":"'$RESOURCE_REQUEST'"}}}]}}}}'
```