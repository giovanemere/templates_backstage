#!/bin/bash

# Script de limpieza para ${{ values.name }}
# Generado por template de Backstage

set -e

echo "🧹 Eliminando recursos de ${{ values.name }} de Minikube..."

# Verificar que kubectl esté configurado
if ! kubectl cluster-info > /dev/null 2>&1; then
    echo "❌ kubectl no está configurado correctamente"
    exit 1
fi

# Eliminar los recursos
echo "🗑️ Eliminando manifiestos de Kubernetes..."
kubectl delete -k k8s/ --ignore-not-found=true

echo "✅ Recursos eliminados exitosamente!"

# Mostrar namespaces restantes
echo "📊 Namespaces restantes:"
kubectl get namespaces
