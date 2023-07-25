
output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = var.cluster-name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = aws_eks_cluster.main.endpoint
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "kubeconfig" {
  description = "kubectl config as generated by the module."
  value       = local.kubeconfig
}