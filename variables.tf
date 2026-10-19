
# --------------------------------------------------
# AWS Configuration
# --------------------------------------------------
variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource tags and prefixes"
  type        = string
  default     = "raham"
}

# --------------------------------------------------
# Bastion Host Configuration
# --------------------------------------------------
variable "bastion_ami_id" {
  description = "Ubuntu 22.04 LTS AMI ID in the selected AWS region"
  type        = string
  default     = "ami-0b6d9d3d33ba97d99"
}

variable "bastion_instance_type" {
  description = "EC2 instance type for the Bastion host"
  type        = string
  default     = "t2.medium"
}

variable "bastion_root_volume_size" {
  description = "Bastion root EBS volume size in GB"
  type        = number
  default     = 30
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name used for SSH access"
  type        = string
  default     = "my-server"
}

variable "ssh_allowed_cidr" {
  description = "IPv4 CIDR allowed to access the Bastion host over SSH"
  type        = string
  default     = "0.0.0.0/0"
}

# --------------------------------------------------
# VPC Networking
# --------------------------------------------------
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for the VPC subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private EKS worker subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

# --------------------------------------------------
# EKS Cluster Configuration
# --------------------------------------------------
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "raham-cluster-1"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.35"
}

# --------------------------------------------------
# EKS Managed Node Group
# --------------------------------------------------
variable "nodegroup_name" {
  description = "Name of the EKS managed node group"
  type        = string
  default     = "raham-cluster-ng-1"
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_volume_size" {
  description = "Root EBS volume size for each worker node in GB"
  type        = number
  default     = 20
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}
