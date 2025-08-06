#!/bin/bash

# Script de despliegue para ${{ values.name }}
# Generado por template de Backstage

set -e

PROJECT_NAME="${{ values.name }}"
GCP_PROJECT_ID="${{ values.gcp_project_id }}"
GCP_REGION="${{ values.gcp_region }}"

echo "🚀 Desplegando Cloud Storage en GCP para $PROJECT_NAME..."

# Verificar prerrequisitos
echo "🔍 Verificando prerrequisitos..."

# Verificar gcloud CLI
if ! command -v gcloud &> /dev/null; then
    echo "❌ gcloud CLI no está instalado"
    echo "Instala gcloud desde: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Verificar Terraform
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform no está instalado"
    echo "Instala Terraform desde: https://learn.hashicorp.com/tutorials/terraform/install-cli"
    exit 1
fi

# Verificar autenticación en GCP
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | head -n1 &> /dev/null; then
    echo "❌ No estás autenticado en GCP"
    echo "Ejecuta: gcloud auth login"
    exit 1
fi

# Verificar proyecto
if ! gcloud projects describe "$GCP_PROJECT_ID" &> /dev/null; then
    echo "❌ El proyecto $GCP_PROJECT_ID no existe o no tienes acceso"
    exit 1
fi

echo "✅ Prerrequisitos verificados"

# Configurar proyecto por defecto
gcloud config set project "$GCP_PROJECT_ID"

# Habilitar APIs necesarias
echo "🔧 Habilitando APIs de GCP..."
gcloud services enable storage.googleapis.com
gcloud services enable iam.googleapis.com

# Mostrar información del proyecto
echo "📋 Información del proyecto GCP:"
gcloud projects describe "$GCP_PROJECT_ID" --format="table(projectId,name,projectNumber)"

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
echo "📊 Información del bucket desplegado:"
terraform output -json > ../outputs.json

echo ""
echo "✅ Despliegue completado exitosamente!"
echo ""
echo "📝 Información de conexión:"
echo "   - Proyecto GCP: $GCP_PROJECT_ID"
echo "   - Bucket Name: $(terraform output -raw bucket_name 2>/dev/null || echo 'N/A')"
echo "   - Bucket URL: $(terraform output -raw bucket_url 2>/dev/null || echo 'N/A')"
echo "   - Service Account: $(terraform output -raw service_account_email 2>/dev/null || echo 'N/A')"
echo ""
echo "🔐 Para obtener la clave del service account:"
echo "   terraform output -raw service_account_key | base64 -d > service-account-key.json"
