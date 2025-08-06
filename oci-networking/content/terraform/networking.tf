# Virtual Cloud Network (VCN)
resource "oci_core_vcn" "main" {
  compartment_id = var.oci_compartment_ocid
  cidr_blocks    = [var.vcn_cidr_block]
  display_name   = "${local.project_name}-vcn"
  dns_label      = replace(local.project_name, "-", "")
  
  is_ipv6enabled = false
  
  freeform_tags = local.common_tags
}

# Internet Gateway
resource "oci_core_internet_gateway" "main" {
  compartment_id = var.oci_compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${local.project_name}-igw"
  enabled        = true
  
  freeform_tags = local.common_tags
}

# NAT Gateway
resource "oci_core_nat_gateway" "main" {
  compartment_id = var.oci_compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${local.project_name}-nat-gateway"
  block_traffic  = false
  
  freeform_tags = local.common_tags
}

# Service Gateway
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_service_gateway" "main" {
  compartment_id = var.oci_compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${local.project_name}-service-gateway"
  
  services {
    service_id = data.oci_core_services.all_services.services[0]["id"]
  }
  
  freeform_tags = local.common_tags
}

# Default Security List
resource "oci_core_default_security_list" "main" {
  manage_default_resource_id = oci_core_vcn.main.default_security_list_id
  display_name               = "${local.project_name}-default-security-list"
  
  # Egress rules
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    description = "Allow all outbound traffic"
  }
  
  # Ingress rules
  ingress_security_rules {
    source   = var.vcn_cidr_block
    protocol = "all"
    description = "Allow all traffic within VCN"
  }
  
  # SSH access
  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "6" # TCP
    description = "SSH access"
    
    tcp_options {
      min = 22
      max = 22
    }
  }
  
  # HTTP access
  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "6" # TCP
    description = "HTTP access"
    
    tcp_options {
      min = 80
      max = 80
    }
  }
  
  # HTTPS access
  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "6" # TCP
    description = "HTTPS access"
    
    tcp_options {
      min = 443
      max = 443
    }
  }
  
  freeform_tags = local.common_tags
}

# Route Table for Public Subnet
resource "oci_core_route_table" "public" {
  compartment_id = var.oci_compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${local.project_name}-public-rt"
  
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.main.id
    description       = "Route to Internet Gateway"
  }
  
  freeform_tags = local.common_tags
}

# Route Table for Private Subnet
resource "oci_core_route_table" "private" {
  compartment_id = var.oci_compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${local.project_name}-private-rt"
  
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.main.id
    description       = "Route to NAT Gateway"
  }
  
  route_rules {
    destination       = data.oci_core_services.all_services.services[0]["cidr_block"]
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.main.id
    description       = "Route to Service Gateway"
  }
  
  freeform_tags = local.common_tags
}

# Public Subnet
resource "oci_core_subnet" "public" {
  count = var.create_public_subnet ? 1 : 0
  
  compartment_id             = var.oci_compartment_ocid
  vcn_id                     = oci_core_vcn.main.id
  cidr_block                 = var.public_subnet_cidr
  display_name               = "${local.project_name}-public-subnet"
  dns_label                  = "public"
  availability_domain        = data.oci_identity_availability_domains.ads.availability_domains[0].name
  route_table_id             = oci_core_route_table.public.id
  security_list_ids          = [oci_core_vcn.main.default_security_list_id]
  prohibit_public_ip_on_vnic = false
  prohibit_internet_ingress  = false
  
  freeform_tags = local.common_tags
}

# Private Subnet
resource "oci_core_subnet" "private" {
  count = var.create_private_subnet ? 1 : 0
  
  compartment_id             = var.oci_compartment_ocid
  vcn_id                     = oci_core_vcn.main.id
  cidr_block                 = var.private_subnet_cidr
  display_name               = "${local.project_name}-private-subnet"
  dns_label                  = "private"
  availability_domain        = data.oci_identity_availability_domains.ads.availability_domains[0].name
  route_table_id             = oci_core_route_table.private.id
  security_list_ids          = [oci_core_vcn.main.default_security_list_id]
  prohibit_public_ip_on_vnic = true
  prohibit_internet_ingress  = true
  
  freeform_tags = local.common_tags
}
