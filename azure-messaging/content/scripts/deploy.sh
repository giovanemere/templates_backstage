#!/bin/bash

# Script de despliegue para ${{ values.name }}
# Generado por template de Backstage

set -e

PROJECT_NAME="${{ values.name }}"
AZURE_LOCATION="${{ values.azure_location }}"

echo "🚀 Desplegando infraestructura Azure para $PROJECT_NAME..."

# Verificar prerrequisitos
echo "🔍 Verificando prerrequisitos..."

# Verificar Azure CLI
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI no está instalado"
    echo "Instala Azure CLI desde: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Verificar Terraform
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform no está instalado"
    echo "Instala Terraform desde: https://learn.hashicorp.com/tutorials/terraform/install-cli"
    exit 1
fi

# Verificar login en Azure
if ! az account show &> /dev/null; then
    echo "❌ No estás logueado en Azure"
    echo "Ejecuta: az login"
    exit 1
fi

echo "✅ Prerrequisitos verificados"

# Mostrar información de la cuenta
echo "📋 Información de la cuenta de Azure:"
az account show --query "{subscriptionId:id, subscriptionName:name, user:user.name}" -o table

# Cambiar al directorio de Terraform
cd terraform

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
echo "📊 Información de la infraestructura desplegada:"
terraform output -json > ../outputs.json

echo ""
echo "✅ Despliegue completado exitosamente!"
echo ""
echo "📝 Información de conexión:"
echo "   - Resource Group: $(terraform output -raw resource_group_name 2>/dev/null || echo 'N/A')"
echo "   - Service Bus Namespace: $(terraform output -raw service_bus_namespace_name 2>/dev/null || echo 'N/A')"
echo "   - Queue Name: $(terraform output -raw service_bus_queue_name 2>/dev/null || echo 'N/A')"
echo "   - Storage Account: $(terraform output -raw storage_account_name 2>/dev/null || echo 'N/A')"
echo "   - Storage Endpoint: $(terraform output -raw storage_account_primary_endpoint 2>/dev/null || echo 'N/A')"
echo ""
echo "🔐 Para obtener las connection strings:"
echo "   terraform output service_bus_send_connection_string"
echo "   terraform output service_bus_listen_connection_string"
echo "   terraform output storage_account_primary_connection_string"
echo ""
echo "🔧 Para probar los servicios, revisa los ejemplos en la carpeta 'examples/'"
