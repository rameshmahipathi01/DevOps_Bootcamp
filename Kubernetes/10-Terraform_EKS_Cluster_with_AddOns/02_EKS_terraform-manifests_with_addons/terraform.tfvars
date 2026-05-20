# AWS Region
aws_region = "ap-south-1"

# Environment
environment_name = "dev"

# Cluster Name
cluster_name = "eks"

# Kubernetes Version
cluster_version = "1.35"

# Public Endpoint Access
cluster_endpoint_public_access = true

# Allow Public Access Temporarily
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

# Node Group
node_instance_types = ["t3.small"]

node_capacity_type = "ON_DEMAND"

node_disk_size = 20
