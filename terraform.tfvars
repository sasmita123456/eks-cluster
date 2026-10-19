
# --------------------------------------------------
# AWS / Project
# --------------------------------------------------
aws_region   = "us-east-1"
project_name = "raham"

# --------------------------------------------------
# Bastion Host
# --------------------------------------------------
bastion_ami_id           = "ami-0b6d9d3d33ba97d99"
bastion_instance_type    = "t2.medium"
bastion_root_volume_size = 30
key_pair_name            = "my-server"

# IMPORTANT: Replace with your own public IPv4 address.
# Example format: 203.0.113.10/32
ssh_allowed_cidr = "0.0.0.0/0"

# --------------------------------------------------
# VPC Networking
# --------------------------------------------------
vpc_cidr = "10.0.0.0/16"

azs = [
  "us-east-1a",
  "us-east-1b"
]

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.101.0/24",
  "10.0.102.0/24"
]

# --------------------------------------------------
# EKS Cluster
# --------------------------------------------------
cluster_name    = "raham-cluster-1"
cluster_version = "1.35"

# --------------------------------------------------
# Managed Node Group
# --------------------------------------------------
nodegroup_name      = "raham-cluster-ng-1"
node_instance_types = ["t3.medium"]
node_volume_size    = 20

node_desired_size = 2
node_min_size     = 2
node_max_size     = 3
