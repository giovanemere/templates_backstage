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

# OCI Authentication variables
variable "oci_tenancy_ocid" {
  description = "OCI Tenancy OCID"
  type        = string
  default     = "${{ values.oci_tenancy_ocid }}"
}

variable "oci_user_ocid" {
  description = "OCI User OCID"
  type        = string
  default     = ""
}

variable "oci_fingerprint" {
  description = "OCI API Key Fingerprint"
  type        = string
  default     = ""
}

variable "oci_private_key_path" {
  description = "Path to OCI private key file"
  type        = string
  default     = "~/.oci/oci_api_key.pem"
}

variable "oci_compartment_ocid" {
  description = "OCI Compartment OCID"
  type        = string
  default     = "${{ values.oci_compartment_ocid }}"
}

variable "oci_region" {
  description = "OCI region"
  type        = string
  default     = "${{ values.oci_region }}"
}

# VCN variables
variable "vcn_cidr_block" {
  description = "CIDR block for VCN"
  type        = string
  default     = "${{ values.vcn_cidr_block }}"
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in VCN"
  type        = bool
  default     = ${{ values.enable_dns_hostnames }}
}

variable "enable_dns_resolution" {
  description = "Enable DNS resolution in VCN"
  type        = bool
  default     = ${{ values.enable_dns_resolution }}
}

# Subnet variables
variable "create_public_subnet" {
  description = "Create public subnet"
  type        = bool
  default     = ${{ values.create_public_subnet }}
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "${{ values.public_subnet_cidr }}"
}

variable "create_private_subnet" {
  description = "Create private subnet"
  type        = bool
  default     = ${{ values.create_private_subnet }}
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "${{ values.private_subnet_cidr }}"
}
