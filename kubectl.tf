
## Obtain the EKS cluster authentication token and store it as an object.
data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}

data "aws_caller_identity" "current" {}

provider "kubectl" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.main.token
  apply_retry_count      = "4"
  load_config_file       = false
}

data "kubectl_file_documents" "argocd_namespace_manifests" {
    content = file("./apps/argocd/argocd-ns.yaml")
}

resource "kubectl_manifest" "argocd_namespace" {
    count     = length(data.kubectl_file_documents.argocd_namespace_manifests.documents)
    yaml_body = element(data.kubectl_file_documents.argocd_namespace_manifests.documents, count.index)
}

data "kubectl_file_documents" "argocd_sock_shop_manifests" {
    content = file("./apps/argocd/argocd-sock-shop.yaml")
}

resource "kubectl_manifest" "argocd_sock_shop" {
    count     = length(data.kubectl_file_documents.argocd_sock_shop_manifests.documents)
    yaml_body = element(data.kubectl_file_documents.argocd_sock_shop_manifests.documents, count.index)
}

data "kubectl_file_documents" "jenkins_operator_manifests" {
    content = file("./apps/jenkins-operator/jenkins-operator.yaml")
}

resource "kubectl_manifest" "jenkins_operator" {
    count     = length(data.kubectl_file_documents.jenkins_operator_manifests.documents)
    yaml_body = element(data.kubectl_file_documents.jenkins_operator_manifests.documents, count.index)
}

data "kubectl_file_documents" "jenkins_server_manifests" {
    content = file("./apps/jenkins-server/jenkins-server.yaml")
}

resource "kubectl_manifest" "jenkins_server" {
    count     = length(data.kubectl_file_documents.jenkins_server_manifests.documents)
    yaml_body = element(data.kubectl_file_documents.jenkins_server_manifests.documents, count.index)
}

data "kubectl_file_documents" "argocd_server_manifests" {
    content = file("./apps/argocd/argocd.yaml")
}

resource "kubectl_manifest" "argocd" {
    count     = length(data.kubectl_file_documents.argocd_server_manifests.documents)
    yaml_body = element(data.kubectl_file_documents.argocd_server_manifests.documents, count.index)
    override_namespace = "argocd"
}
