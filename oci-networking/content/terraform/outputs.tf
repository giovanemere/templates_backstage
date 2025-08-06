# VCN Outputs
output "vcn_id" {
  description = "OCID of the VCN"
  value       = oci_core_vcn.main.id
}

output "vcn_cidr_blocks" {
  description = "CIDR blocks of the VCN"
  value       = oci_core_vcn.main.cidr_blocks
}

output "vcn_display_name" {
  description = "Display name of the VCN"
  value       = oci_core_vcn.main.display_name
}

# Gateway Outputs
output "internet_gateway_id" {
  description = "OCID of the Internet Gateway"
  value       = oci_core_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "OCID of the NAT Gateway"
  value       = oci_core_nat_gateway.main.id
}

output "service_gateway_id" {
  description = "OCID of the Service Gateway"
  value       = oci_core_service_gateway.main.id
}

# Subnet Outputs
output "public_subnet_id" {
  description = "OCID of the public subnet"
  value       = var.create_public_subnet ? oci_core_subnet.public[0].id : null
}

output "public_subnet_cidr" {
  description = "CIDR block of the public subnet"
  value       = var.create_public_subnet ? oci_core_subnet.public[0].cidr_block : null
}

output "private_subnet_id" {
  description = "OCID of the private subnet"
  value       = var.create_private_subnet ? oci_core_subnet.private[0].id : null
}

output "private_subnet_cidr" {
  description = "CIDR block of the private subnet"
  value       = var.create_private_subnet ? oci_core_subnet.private[0].cidr_block : null
}

# Route Table Outputs
output "public_route_table_id" {
  description = "OCID of the public route table"
  value       = oci_core_route_table.public.id
}

output "private_route_table_id" {
  description = "OCID of the private route table"
  value       = oci_core_route_table.private.id
}

# Security List Outputs
output "default_security_list_id" {
  description = "OCID of the default security list"
  value       = oci_core_default_security_list.main.id
}

# Availability Domain Outputs
output "availability_domains" {
  description = "List of availability domains"
  value       = data.oci_identity_availability_domains.ads.availability_domains[*].name
}

# Connection Information
output "connection_info" {
  description = "Connection information for the VCN"
  value = {
    tenancy_ocid     = var.oci_tenancy_ocid
    compartment_ocid = var.oci_compartment_ocid
    region          = var.oci_region
    vcn_id          = oci_core_vcn.main.id
    vcn_cidr        = var.vcn_cidr_block
    public_subnet   = var.create_public_subnet ? oci_core_subnet.public[0].id : null
    private_subnet  = var.create_private_subnet ? oci_core_subnet.private[0].id : null
  }
}

# Configuration Summary
output "configuration_summary" {
  description = "Summary of the deployed configuration"
  value = {
    vcn = {
      cidr_block       = var.vcn_cidr_block
      dns_hostnames    = var.enable_dns_hostnames
      dns_resolution   = var.enable_dns_resolution
    }
    subnets = {
      public_created   = var.create_public_subnet
      public_cidr      = var.create_public_subnet ? var.public_subnet_cidr : null
      private_created  = var.create_private_subnet
      private_cidr     = var.create_private_subnet ? var.private_subnet_cidr : null
    }
  }
}
