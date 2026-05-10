# ------------------------------------------------------------------------------
# AWS EKS Cluster
# ------------------------------------------------------------------------------

resource "aws_eks_cluster" "main" {

  # EKS Cluster Name
  name = local.eks_cluster_name

  # Kubernetes Version
  version = var.cluster_version

  # EKS Control Plane IAM Role
  role_arn = aws_iam_role.eks_cluster.arn

  # ----------------------------------------------------------------------------
  # VPC Configuration
  # ----------------------------------------------------------------------------
  vpc_config {

    # Public Subnet
    subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnet_ids


    # Endpoint Access
    endpoint_private_access = var.cluster_endpoint_private_access

    endpoint_public_access = var.cluster_endpoint_public_access

    public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  }

  # ----------------------------------------------------------------------------
  # Kubernetes Networking
  # ----------------------------------------------------------------------------
  kubernetes_network_config {

    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  # ----------------------------------------------------------------------------
  # Control Plane Logging
  # ----------------------------------------------------------------------------
  enabled_cluster_log_types = [

    "api",

    "audit",

    "authenticator",

    "controllerManager",

    "scheduler"
  ]

  # ----------------------------------------------------------------------------
  # EKS Access Configuration
  # ----------------------------------------------------------------------------
  access_config {

    authentication_mode = "API_AND_CONFIG_MAP"

    bootstrap_cluster_creator_admin_permissions = true
  }

  # ----------------------------------------------------------------------------
  # Resource Tags
  # ----------------------------------------------------------------------------
  tags = merge(var.tags, {

    Name = local.eks_cluster_name
  })

  # ----------------------------------------------------------------------------
  # Dependencies
  # ----------------------------------------------------------------------------
  depends_on = [

    aws_iam_role_policy_attachment.eks_cluster_policy,

    aws_iam_role_policy_attachment.eks_vpc_resource_controller
  ]
}
