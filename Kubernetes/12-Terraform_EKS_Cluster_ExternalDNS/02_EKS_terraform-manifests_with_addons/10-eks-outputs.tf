# ------------------------------------------------------------------------------
# EKS Cluster API Endpoint
# ------------------------------------------------------------------------------
output "eks_cluster_endpoint" {

  description = "EKS API server endpoint"

  value = aws_eks_cluster.main.endpoint
}

# ------------------------------------------------------------------------------
# EKS Cluster ID
# ------------------------------------------------------------------------------
output "eks_cluster_id" {

  description = "EKS Cluster ID"

  value = aws_eks_cluster.main.id
}

# ------------------------------------------------------------------------------
# EKS Kubernetes Version
# ------------------------------------------------------------------------------
output "eks_cluster_version" {

  description = "EKS Kubernetes Version"

  value = aws_eks_cluster.main.version
}

# ------------------------------------------------------------------------------
# EKS Cluster Name
# ------------------------------------------------------------------------------
output "eks_cluster_name" {

  description = "EKS Cluster Name"

  value = aws_eks_cluster.main.name
}

# ------------------------------------------------------------------------------
# EKS Cluster Certificate Authority
# ------------------------------------------------------------------------------
output "eks_cluster_certificate_authority_data" {

  description = "Base64 encoded certificate data required for kubeconfig"

  value = aws_eks_cluster.main.certificate_authority[0].data
}

# ------------------------------------------------------------------------------
# Public Node Group Name
# ------------------------------------------------------------------------------
output "public_node_group_name" {

  description = "EKS Public Node Group Name"

  value = aws_eks_node_group.public_nodes.node_group_name
}

# ------------------------------------------------------------------------------
# EKS Worker Node IAM Role ARN
# ------------------------------------------------------------------------------
output "eks_node_instance_role_arn" {

  description = "IAM Role ARN used by EKS worker nodes"

  value = aws_iam_role.eks_nodegroup_role.arn
}

# ------------------------------------------------------------------------------
# kubectl Configuration Command
# ------------------------------------------------------------------------------
output "configure_kubectl" {

  description = "Command to configure kubectl for this EKS cluster"

  value = "aws eks --region ${var.aws_region} update-kubeconfig --name ${local.eks_cluster_name}"
}


# eks cluster security group id
output "eks_cluster_security_group_id" {

  description = "Security Group ID for EKS Cluster"

  value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}
