terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = var.common_tags
  }
}

# VPC
module "vpc" {
  source = "./vpc"
  
  project_name = var.project_name
  environment  = var.environment
  cidr_block   = "10.0.0.0/16"
  
  tags = var.common_tags
}

# EKS Cluster
module "eks" {
  source = "./eks"
  
  project_name           = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  node_instance_type    = var.eks_node_instance_type
  node_desired_size     = var.eks_node_desired_size
  node_max_size         = var.eks_node_max_size
  node_min_size         = var.eks_node_min_size
  
  tags = var.common_tags
}

# ECR Repositories
module "ecr" {
  source = "./ecr"
  
  project_name = var.project_name
  environment  = var.environment
  
  repositories = [
    "billpay-backend",
    "billpay-frontend-a",
    "billpay-frontend-b", 
    "billpay-feature-flags"
  ]
  
  tags = var.common_tags
}

# S3 + CloudFront for Frontends
module "frontend_hosting" {
  source = "./frontend-hosting"
  
  project_name = var.project_name
  environment  = var.environment
  
  frontends = [
    "frontend-a",
    "frontend-b",
    "feature-flags"
  ]
  
  tags = var.common_tags
}

# Application Load Balancer
module "alb" {
  source = "./alb"
  
  project_name       = var.project_name
  environment        = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  
  tags = var.common_tags
}
