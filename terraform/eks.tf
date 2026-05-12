module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets # Usually intra or private

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT" # Save even more money for demos
    }
  }

  # Cluster creator admin permissions
  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = "staging"
    Project     = "DevLaunch"
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}
