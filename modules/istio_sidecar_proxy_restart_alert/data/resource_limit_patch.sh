bash
#!/bin/bash

# Define variables
NAMESPACE=${NAMESPACE}
DEPLOYMENT_NAME=${DEPLOYMENT_NAME}
RESOURCE_LIMIT=${RESOURCE_LIMIT} # e.g. 500Mi or 1Gi
RESOURCE_REQUEST=${RESOURCE_REQUEST} # e.g. 200Mi or 500Mi

# Increase the resource limit for the Istio Sidecar Proxy
kubectl -n $NAMESPACE patch deployment $DEPLOYMENT_NAME -p '{"spec":{"template":{"spec":{"containers":[{"name":"istio-proxy","resources":{"limits":{"memory":"'$RESOURCE_LIMIT'"},"requests":{"memory":"'$RESOURCE_REQUEST'"}}}]}}}}'