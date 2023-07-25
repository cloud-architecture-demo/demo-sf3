
## Define the EKS cluster control plane
resource "aws_eks_cluster" "main" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eks.arn

  ## Define which VPC to associate this EKS cluster control plane with.
  vpc_config {
    security_group_ids      = [aws_security_group.eks.id, aws_security_group.main-node.id]
    subnet_ids              = [aws_subnet.a.id, aws_subnet.b.id, aws_subnet.c.id]
    endpoint_private_access = var.endpoint_private_access ## Exposes the kubernetes control plain API endpoint to the internal VPC network.
    endpoint_public_access  = var.endpoint_public_access ## Exposes the kubernetes control plain API endpoint to the internet.
  }

  depends_on = [
    aws_iam_role_policy_attachment.main-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.main-cluster-AmazonEKSServicePolicy,
  ]
}

## Define the node group and associate it with the EKS cluster control plane defined above.
resource "aws_eks_node_group" "eks" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.cluster-name
  node_role_arn   = aws_iam_role.main-node.arn
  subnet_ids      = [aws_subnet.a.id, aws_subnet.b.id, aws_subnet.c.id]
  instance_types = ["t3.large"]

  ## Define how this EKS cluster should autoscale. Set all unanimously to one value to pin the cluster size.
  scaling_config {
    desired_size = var.eks_desired_size
    max_size     = var.eks_max_size
    min_size     = var.eks_min_size
  }

  ## Define which ssh keys, if any to allow access to the EKS cluster's autoscaling nodes; and a security group to control access.
  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
    source_security_group_ids = [aws_security_group.eks.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.main-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.main-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.main-node-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.main-node-AmazonEC2FullAccess,
  ]
  lifecycle {
    create_before_destroy = true
  }
}
