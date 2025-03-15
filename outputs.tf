output "kubernetes_namespace" {
  description = "The Kubernetes namespace where resources are deployed"
  value       = var.kubernetes_namespace
}

output "service_account_name" {
  description = "The name of the service account"
  value       = kubernetes_service_account.app_service_account.metadata[0].name
}

output "config_map_name" {
  description = "The name of the DynamoDB config map"
  value       = kubernetes_config_map.dynamodb_config.metadata[0].name
}