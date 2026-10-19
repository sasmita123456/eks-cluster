
# --------------------------------------------------
# VPC and Subnets for EKS
# Public subnets:
#   - Bastion host
#   - NAT Gateway
#   - Internet-facing load balancers
#
# Private subnets:
#   - EKS worker nodes
#   - Internal load balancers
# --------------------------------------------------

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  # DNS
  enable_dns_support   = true
  enable_dns_hostnames = true

  # Outbound internet access for private subnets.
  # A NAT Gateway incurs hourly and data-processing charges.
  enable_nat_gateway = true
  single_nat_gateway = true

  # Public subnet tags for internet-facing load balancers.
  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  # Private subnet tags for internal load balancers.
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  tags = {
    Project = var.project_name
  }
}
