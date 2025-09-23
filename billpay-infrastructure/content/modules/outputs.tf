output "vpc_id" {
  description = "ID de la VPC"
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "Nombre del cluster EKS"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint del cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "ecr_repositories" {
  description = "URLs de los repositorios ECR"
  value       = module.ecr.repository_urls
}

output "frontend_cloudfront_distributions" {
  description = "URLs de las distribuciones CloudFront"
  value       = module.frontend_hosting.cloudfront_urls
}

output "alb_dns_name" {
  description = "DNS name del Application Load Balancer"
  value       = module.alb.dns_name
}
