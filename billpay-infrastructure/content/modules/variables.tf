variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "Región de AWS"
  type        = string
}

variable "eks_node_instance_type" {
  description = "Tipo de instancia para nodos EKS"
  type        = string
  default     = "t3.medium"
}

variable "eks_node_desired_size" {
  description = "Número deseado de nodos EKS"
  type        = number
  default     = 2
}

variable "eks_node_max_size" {
  description = "Número máximo de nodos EKS"
  type        = number
  default     = 4
}

variable "eks_node_min_size" {
  description = "Número mínimo de nodos EKS"
  type        = number
  default     = 1
}

variable "enable_monitoring" {
  description = "Habilitar monitoring con CloudWatch"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Tags comunes para todos los recursos"
  type        = map(string)
  default     = {}
}
