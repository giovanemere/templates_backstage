#!/bin/bash

# Script de despliegue para ${{ values.name }}
# Generado por template de Backstage

set -e

PROJECT_NAME="${{ values.name }}"
AWS_REGION="${{ values.aws_region }}"

echo "🚀 Desplegando infraestructura AWS para $PROJECT_NAME..."

# Verificar prerrequisitos
echo "🔍 Verificando prerrequisitos..."

# Verificar AWS CLI
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI no está instalado"
    exit 1
fi

# Verificar Terraform
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform no está instalado"
    exit 1
fi

# Verificar credenciales de AWS
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ Credenciales de AWS no configuradas"
    exit 1
fi

echo "✅ Prerrequisitos verificados"

# Cambiar al directorio de Terraform
cd terraform

# Preparar código Lambda
echo "📦 Preparando código Lambda..."
if [ ! -f "../lambda/function.zip" ]; then
    cd ../lambda
    if [ -f "index.py" ]; then
        zip function.zip index.py
    elif [ -f "index.js" ]; then
        zip function.zip index.js
    fi
    cd ../terraform
fi

# Inicializar Terraform
echo "🔧 Inicializando Terraform..."
terraform init

# Validar configuración
echo "✅ Validando configuración de Terraform..."
terraform validate

# Planificar despliegue
echo "📋 Planificando despliegue..."
terraform plan -out=tfplan

# Aplicar cambios
echo "🚀 Aplicando cambios..."
terraform apply tfplan

# Mostrar outputs
echo "📊 Información de la infraestructura desplegada:"
terraform output -json > ../outputs.json
terraform output

echo ""
echo "✅ Despliegue completado exitosamente!"
echo ""
echo "📝 Información de conexión:"
echo "   - EC2 Web: $(terraform output -raw ec2_public_ip 2>/dev/null || echo 'N/A')"
echo "   - S3 Bucket: $(terraform output -raw s3_bucket_name 2>/dev/null || echo 'N/A')"
echo "   - Lambda Function: $(terraform output -raw lambda_function_name 2>/dev/null || echo 'N/A')"
echo "   - EKS Cluster: $(terraform output -raw eks_cluster_id 2>/dev/null || echo 'N/A')"
echo ""
echo "🔧 Para configurar kubectl para EKS:"
echo "   aws eks update-kubeconfig --region $AWS_REGION --name $(terraform output -raw eks_cluster_id 2>/dev/null || echo '$PROJECT_NAME-eks')"
