resource "shoreline_notebook" "istio_sidecar_proxy_restart_alert" {
  name       = "istio_sidecar_proxy_restart_alert"
  data       = file("${path.module}/data/istio_sidecar_proxy_restart_alert.json")
  depends_on = [shoreline_action.invoke_resource_limit_patch]
}

resource "shoreline_file" "resource_limit_patch" {
  name             = "resource_limit_patch"
  input_file       = "${path.module}/data/resource_limit_patch.sh"
  md5              = filemd5("${path.module}/data/resource_limit_patch.sh")
  description      = "Check the resources allocated to the Istio Sidecar Proxy. If the pod is running out of memory or CPU, increase the allocated resources or adjust the resource quotas to deployment and ensure sufficient resources are available."
  destination_path = "/tmp/resource_limit_patch.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_resource_limit_patch" {
  name        = "invoke_resource_limit_patch"
  description = "Check the resources allocated to the Istio Sidecar Proxy. If the pod is running out of memory or CPU, increase the allocated resources or adjust the resource quotas to deployment and ensure sufficient resources are available."
  command     = "`chmod +x /tmp/resource_limit_patch.sh && /tmp/resource_limit_patch.sh`"
  params      = ["RESOURCE_LIMIT","NAMESPACE","DEPLOYMENT_NAME","RESOURCE_REQUEST"]
  file_deps   = ["resource_limit_patch"]
  enabled     = true
  depends_on  = [shoreline_file.resource_limit_patch]
}

