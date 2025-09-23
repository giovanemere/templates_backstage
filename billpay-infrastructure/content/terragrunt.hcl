terraform {
  source = "./modules"
}

locals {
  environment = "${{ values.environment }}"
  aws_region  = "${{ values.aws_region }}"
  project_name = "billpay"
  
  common_tags = {
    Project     = "BillPay"
    Environment = local.environment
    ManagedBy   = "Terragrunt"
    CreatedBy   = "Backstage"
  }
}

inputs = {
  environment = local.environment
  aws_region  = local.aws_region
  project_name = local.project_name
  
  # EKS Configuration
  eks_node_instance_type = "${{ values.eks_node_instance_type }}"
  eks_node_desired_size  = local.environment == "prod" ? 3 : 2
  eks_node_max_size      = local.environment == "prod" ? 6 : 4
  eks_node_min_size      = local.environment == "prod" ? 2 : 1
  
  # Monitoring
  enable_monitoring = ${{ values.enable_monitoring }}
  
  # Common tags
  common_tags = local.common_tags
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "billpay-terraform-state-${local.environment}"
    key            = "${local.project_name}/${local.environment}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "billpay-terraform-locks-${local.environment}"
  }
}
