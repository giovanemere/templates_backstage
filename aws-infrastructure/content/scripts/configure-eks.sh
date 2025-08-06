#!/bin/bash

# Script de configuración de EKS para ${{ values.name }}
# Generado por template de Backstage

set -e

PROJECT_NAME="${{ values.name }}"
AWS_REGION="${{ values.aws_region }}"

echo "⚙️ Configurando acceso a EKS para $PROJECT_NAME..."

# Verificar prerrequisitos
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl no está instalado"
    echo "Instala kubectl desde: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI no está instalado"
    exit 1
fi

# Obtener información del cluster desde Terraform
cd terraform

if [ ! -f "terraform.tfstate" ]; then
    echo "❌ No se encontró el estado de Terraform. Ejecuta primero el despliegue."
    exit 1
fi

CLUSTER_NAME=$(terraform output -raw eks_cluster_id 2>/dev/null || echo "${PROJECT_NAME}-eks")

echo "🔧 Configurando kubectl para el cluster: $CLUSTER_NAME"

# Configurar kubectl
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

# Verificar conexión
echo "✅ Verificando conexión al cluster..."
kubectl cluster-info

echo "📊 Información de nodos:"
kubectl get nodes

echo "📦 Namespaces disponibles:"
kubectl get namespaces

echo ""
echo "✅ Configuración de EKS completada!"
echo ""
echo "🔧 Comandos útiles:"
echo "   - Ver nodos: kubectl get nodes"
echo "   - Ver pods: kubectl get pods --all-namespaces"
echo "   - Ver servicios: kubectl get services --all-namespaces"
echo "   - Dashboard: kubectl proxy (luego visita http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)"
