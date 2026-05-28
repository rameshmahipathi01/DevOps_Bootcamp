# ------------------------------------------------------------------------------
# EKS Managed Node Group - Public Subnet Worker Nodes
# ------------------------------------------------------------------------------

resource "aws_eks_node_group" "public_nodes" {

  # EKS Cluster Name
  cluster_name = aws_eks_cluster.main.name

  # Node Group Name
  node_group_name = "${local.name}-public-ng"

  # IAM Role for Worker Nodes
  node_role_arn = aws_iam_role.eks_nodegroup_role.arn

  # ----------------------------------------------------------------------------
  # PUBLIC SUBNET FOR WORKER NODES
  # ----------------------------------------------------------------------------
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnet_ids


  # EC2 Instance Types
  instance_types = var.node_instance_types

  # ON_DEMAND or SPOT
  capacity_type = var.node_capacity_type

  # Amazon Linux 2023 EKS Optimized AMI
  ami_type = "AL2023_x86_64_STANDARD"

  # Root Volume Size
  disk_size = var.node_disk_size

  # ----------------------------------------------------------------------------
  # Node Scaling Configuration
  # ----------------------------------------------------------------------------
  scaling_config {

    desired_size = 2

    min_size = 2

    max_size = 4
  }

  # ----------------------------------------------------------------------------
  # Rolling Update Configuration
  # ----------------------------------------------------------------------------
  update_config {

    max_unavailable_percentage = 33
  }

  # Force node updates when AMI changes
  force_update_version = true

  # ----------------------------------------------------------------------------
  # Kubernetes Node Labels
  # ----------------------------------------------------------------------------
  labels = {

    env  = var.environment_name
    team = var.business_division
  }

  # ----------------------------------------------------------------------------
  # Resource Tags
  # ----------------------------------------------------------------------------
  tags = merge(var.tags, {

    Name = "${local.name}-public-ng"

    Environment = var.environment_name
  })

  # ----------------------------------------------------------------------------
  # Ensure IAM Policies Exist Before Node Creation
  # ----------------------------------------------------------------------------
  depends_on = [

    aws_iam_role_policy_attachment.eks_worker_node_policy,

    aws_iam_role_policy_attachment.eks_cni_policy,

    aws_iam_role_policy_attachment.eks_ecr_policy
  ]
}
