#!/bin/bash

# Script de despliegue para ${{ values.name }}
# Generado por template de Backstage

set -e

PROJECT_NAME="${{ values.name }}"
OCI_REGION="${{ values.oci_region }}"

echo "🚀 Desplegando VCN en OCI para $PROJECT_NAME..."

# Verificar prerrequisitos
echo "🔍 Verificando prerrequisitos..."

# Verificar OCI CLI
if ! command -v oci &> /dev/null; then
    echo "❌ OCI CLI no está instalado"
    echo "Instala OCI CLI desde: https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm"
    exit 1
fi

# Verificar Terraform
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform no está instalado"
    echo "Instala Terraform desde: https://learn.hashicorp.com/tutorials/terraform/install-cli"
    exit 1
fi

# Verificar configuración de OCI
if [ ! -f ~/.oci/config ]; then
    echo "❌ Configuración de OCI no encontrada"
    echo "Ejecuta: oci setup config"
    exit 1
fi

# Verificar clave privada
if [ ! -f ~/.oci/oci_api_key.pem ]; then
    echo "⚠️  Clave privada no encontrada en ~/.oci/oci_api_key.pem"
    echo "Asegúrate de que la ruta en variables.tf sea correcta"
fi

echo "✅ Prerrequisitos verificados"

# Mostrar información de la configuración
echo "📋 Información de OCI:"
oci iam region list --query "data[?\"region-name\"=='$OCI_REGION'].{Region:\"region-name\",Key:\"region-key\"}" --output table 2>/dev/null || echo "No se pudo obtener información de regiones"

# Cambiar al directorio de Terraform
cd terraform

# Crear archivo terraform.tfvars si no existe
if [ ! -f terraform.tfvars ]; then
    echo "📝 Creando archivo terraform.tfvars..."
    cat > terraform.tfvars << EOF
# Configuración de autenticación OCI
# Completa estos valores según tu configuración

# Obtén estos valores desde ~/.oci/config o OCI Console
oci_user_ocid        = "ocid1.user.oc1..your_user_ocid_here"
oci_fingerprint      = "your_fingerprint_here"
oci_private_key_path = "~/.oci/oci_api_key.pem"

# Los siguientes valores ya están configurados desde el template
# oci_tenancy_ocid     = "${{ values.oci_tenancy_ocid }}"
# oci_compartment_ocid = "${{ values.oci_compartment_ocid }}"
# oci_region          = "${{ values.oci_region }}"
EOF
    echo "⚠️  Por favor, completa el archivo terraform.tfvars con tus credenciales de OCI"
    echo "   Puedes encontrar estos valores en ~/.oci/config o en OCI Console"
    read -p "Presiona Enter cuando hayas completado terraform.tfvars..."
fi

# Inicializar Terraform
echo "🔧 Inicializando Terraform..."
terraform init

# Validar configuración
echo "✅ Validando configuración de Terraform..."
terraform validate

# Formatear código
echo "🎨 Formateando código Terraform..."
terraform fmt

# Planificar despliegue
echo "📋 Planificando despliegue..."
terraform plan -out=tfplan

# Aplicar cambios
echo "🚀 Aplicando cambios..."
terraform apply tfplan

# Mostrar outputs
echo "📊 Información de la VCN desplegada:"
terraform output -json > ../outputs.json

echo ""
echo "✅ Despliegue completado exitosamente!"
echo ""
echo "📝 Información de conexión:"
echo "   - Región OCI: $OCI_REGION"
echo "   - VCN ID: $(terraform output -raw vcn_id 2>/dev/null || echo 'N/A')"
echo "   - VCN CIDR: $(terraform output -raw vcn_cidr_blocks 2>/dev/null || echo 'N/A')"
if [ "${{ values.create_public_subnet }}" = "true" ]; then
    echo "   - Public Subnet ID: $(terraform output -raw public_subnet_id 2>/dev/null || echo 'N/A')"
fi
if [ "${{ values.create_private_subnet }}" = "true" ]; then
    echo "   - Private Subnet ID: $(terraform output -raw private_subnet_id 2>/dev/null || echo 'N/A')"
fi
