variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "${{ values.name }}"
}

variable "owner" {
  description = "Owner of the project"
  type        = string
  default     = "${{ values.owner }}"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "${{ values.aws_region }}"
}

# Lambda variables
variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "${{ values.lambda_runtime }}"
}

variable "lambda_memory" {
  description = "Lambda memory in MB"
  type        = number
  default     = ${{ values.lambda_memory }}
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = ${{ values.lambda_timeout }}
}

# S3 variables
variable "s3_versioning" {
  description = "Enable S3 versioning"
  type        = bool
  default     = ${{ values.s3_versioning }}
}

variable "s3_encryption" {
  description = "Enable S3 encryption"
  type        = bool
  default     = ${{ values.s3_encryption }}
}

variable "s3_public_access" {
  description = "Block S3 public access"
  type        = bool
  default     = ${{ values.s3_public_access }}
}

# EC2 variables
variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "${{ values.ec2_instance_type }}"
}

variable "ec2_key_pair" {
  description = "EC2 key pair name"
  type        = string
  default     = "${{ values.ec2_key_pair }}"
}

variable "ec2_volume_size" {
  description = "EC2 volume size in GB"
  type        = number
  default     = ${{ values.ec2_volume_size }}
}

# EKS variables
variable "eks_version" {
  description = "EKS cluster version"
  type        = string
  default     = "${{ values.eks_version }}"
}

variable "eks_node_instance_type" {
  description = "EKS node instance type"
  type        = string
  default     = "${{ values.eks_node_instance_type }}"
}

variable "eks_desired_capacity" {
  description = "EKS desired capacity"
  type        = number
  default     = ${{ values.eks_desired_capacity }}
}

variable "eks_max_capacity" {
  description = "EKS max capacity"
  type        = number
  default     = ${{ values.eks_max_capacity }}
}

variable "eks_min_capacity" {
  description = "EKS min capacity"
  type        = number
  default     = ${{ values.eks_min_capacity }}
}
