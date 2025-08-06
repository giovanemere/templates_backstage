#!/bin/bash

# Script de destrucción para ${{ values.name }}
# Generado por template de Backstage

set -e

PROJECT_NAME="${{ values.name }}"

echo "🗑️ Destruyendo infraestructura AWS para $PROJECT_NAME..."

# Confirmación
read -p "¿Estás seguro de que quieres destruir toda la infraestructura? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "❌ Operación cancelada"
    exit 1
fi

# Cambiar al directorio de Terraform
cd terraform

# Verificar que Terraform esté inicializado
if [ ! -d ".terraform" ]; then
    echo "🔧 Inicializando Terraform..."
    terraform init
fi

# Planificar destrucción
echo "📋 Planificando destrucción..."
terraform plan -destroy -out=destroy.tfplan

# Aplicar destrucción
echo "💥 Destruyendo infraestructura..."
terraform apply destroy.tfplan

# Limpiar archivos temporales
echo "🧹 Limpiando archivos temporales..."
rm -f tfplan destroy.tfplan
rm -f ../lambda/function.zip
rm -f ../outputs.json

echo "✅ Infraestructura destruida exitosamente!"
