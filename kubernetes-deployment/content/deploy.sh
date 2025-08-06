#!/bin/bash

# Script de despliegue para ${{ values.name }}
# Generado por template de Backstage

set -e

echo "🚀 Desplegando ${{ values.name }} en Minikube..."

# Verificar que Minikube esté ejecutándose
if ! minikube status > /dev/null 2>&1; then
    echo "❌ Minikube no está ejecutándose. Iniciando Minikube..."
    minikube start
fi

# Verificar que kubectl esté configurado
if ! kubectl cluster-info > /dev/null 2>&1; then
    echo "❌ kubectl no está configurado correctamente"
    exit 1
fi

echo "✅ Minikube está ejecutándose"

# Aplicar los manifiestos
echo "📦 Aplicando manifiestos de Kubernetes..."
kubectl apply -k k8s/

# Esperar a que el deployment esté listo
echo "⏳ Esperando a que el deployment esté listo..."
kubectl wait --for=condition=available --timeout=300s deployment/${{ values.name }} -n ${{ values.name }}-ns

# Mostrar el estado
echo "📊 Estado del deployment:"
kubectl get pods -n ${{ values.name }}-ns

echo "🌐 Información del servicio:"
kubectl get svc -n ${{ values.name }}-ns

# Obtener la URL del servicio
echo "🔗 URL del servicio:"
minikube service ${{ values.name }}-service -n ${{ values.name }}-ns --url

echo "✅ Despliegue completado exitosamente!"
echo ""
echo "Para acceder a la aplicación, ejecuta:"
echo "minikube service ${{ values.name }}-service -n ${{ values.name }}-ns"
