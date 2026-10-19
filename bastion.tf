
# --------------------------------------------------
# Bastion Security Group
# --------------------------------------------------
resource "aws_security_group" "bastion_sg" {
  name        = "${var.cluster_name}-bastion-sg"
  description = "Security group for the EKS bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH access to bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.cluster_name}-bastion-sg"
    Project = var.project_name
  }
}

# --------------------------------------------------
# Bastion IAM Role
# --------------------------------------------------
resource "aws_iam_role" "bastion" {
  name = "${var.cluster_name}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name    = "${var.cluster_name}-bastion-role"
    Project = var.project_name
  }
}

# Allow the bastion to retrieve EKS cluster connection details.
resource "aws_iam_role_policy" "bastion_eks_read" {
  name = "${var.cluster_name}-eks-read"
  role = aws_iam_role.bastion.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups"
        ]
        Resource = "*"
      }
    ]
  })
}

# Allow pulling images from Amazon ECR.
resource "aws_iam_role_policy_attachment" "bastion_ecr_readonly" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# --------------------------------------------------
# Bastion Instance Profile
# --------------------------------------------------
resource "aws_iam_instance_profile" "bastion" {
  name = "${var.cluster_name}-bastion-profile"
  role = aws_iam_role.bastion.name

  tags = {
    Project = var.project_name
  }
}

# --------------------------------------------------
# Bastion EC2 Instance
# --------------------------------------------------
resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami_id
  instance_type               = var.bastion_instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion.name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.bastion_root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  user_data = templatefile("${path.module}/bastion_bootstrap.sh.tpl", {
    aws_region   = var.aws_region
    cluster_name = var.cluster_name
  })

  # Ensure EKS exists before the bastion bootstrap tries to configure kubectl.
  depends_on = [
    module.eks,
    aws_iam_role_policy.bastion_eks_read,
    aws_iam_role_policy_attachment.bastion_ecr_readonly
  ]

  tags = {
    Name    = "${var.cluster_name}-bastion"
    Project = var.project_name
  }
}

# --------------------------------------------------
# Outputs
# --------------------------------------------------
output "bastion_public_ip" {
  description = "Public IPv4 address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_ssh_command" {
  description = "SSH command to connect to the bastion host"
  value       = "ssh -i \"${var.key_pair_name}.pem\" ubuntu@${aws_instance.bastion.public_ip}"
}
