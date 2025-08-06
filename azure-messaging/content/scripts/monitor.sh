#!/bin/bash

# Script de monitoreo para ${{ values.name }}
# Generado por template de Backstage

set -e

PROJECT_NAME="${{ values.name }}"

echo "📊 Monitoreando infraestructura Azure para $PROJECT_NAME..."

# Verificar login en Azure
if ! az account show &> /dev/null; then
    echo "❌ No estás logueado en Azure"
    echo "Ejecuta: az login"
    exit 1
fi

# Obtener información desde Terraform
cd terraform

if [ ! -f "terraform.tfstate" ]; then
    echo "❌ No se encontró el estado de Terraform. Ejecuta primero el despliegue."
    exit 1
fi

RESOURCE_GROUP=$(terraform output -raw resource_group_name 2>/dev/null || echo "")
SERVICE_BUS_NAMESPACE=$(terraform output -raw service_bus_namespace_name 2>/dev/null || echo "")
QUEUE_NAME=$(terraform output -raw service_bus_queue_name 2>/dev/null || echo "")
STORAGE_ACCOUNT=$(terraform output -raw storage_account_name 2>/dev/null || echo "")

if [ -z "$RESOURCE_GROUP" ]; then
    echo "❌ No se pudo obtener información del Resource Group"
    exit 1
fi

echo "🔍 Información del Resource Group:"
az group show --name "$RESOURCE_GROUP" --query "{name:name, location:location, provisioningState:properties.provisioningState}" -o table

echo ""
echo "📨 Estado del Service Bus:"
if [ -n "$SERVICE_BUS_NAMESPACE" ]; then
    az servicebus namespace show --resource-group "$RESOURCE_GROUP" --name "$SERVICE_BUS_NAMESPACE" \
        --query "{name:name, sku:sku.name, status:status, createdAt:createdAt}" -o table
    
    echo ""
    echo "📋 Estado de la Cola:"
    if [ -n "$QUEUE_NAME" ]; then
        az servicebus queue show --resource-group "$RESOURCE_GROUP" --namespace-name "$SERVICE_BUS_NAMESPACE" --name "$QUEUE_NAME" \
            --query "{name:name, status:status, messageCount:messageCount, activeMessageCount:activeMessageCount, deadLetterMessageCount:deadLetterMessageCount}" -o table
    fi
else
    echo "❌ No se encontró información del Service Bus"
fi

echo ""
echo "💾 Estado del Storage Account:"
if [ -n "$STORAGE_ACCOUNT" ]; then
    az storage account show --resource-group "$RESOURCE_GROUP" --name "$STORAGE_ACCOUNT" \
        --query "{name:name, sku:sku.name, accessTier:accessTier, provisioningState:provisioningState}" -o table
    
    echo ""
    echo "📦 Contenedores de Blob:"
    az storage container list --account-name "$STORAGE_ACCOUNT" \
        --query "[].{name:name, lastModified:properties.lastModified, publicAccess:properties.publicAccess}" -o table
else
    echo "❌ No se encontró información del Storage Account"
fi

echo ""
echo "💰 Estimación de costos (últimos 30 días):"
az consumption usage list --start-date $(date -d '30 days ago' '+%Y-%m-%d') --end-date $(date '+%Y-%m-%d') \
    --query "[?contains(instanceName, '$RESOURCE_GROUP')].{service:meterCategory, cost:pretaxCost, currency:currency}" -o table 2>/dev/null || echo "No se pudo obtener información de costos"

echo ""
echo "🔧 Comandos útiles:"
echo "   - Ver logs de actividad: az monitor activity-log list --resource-group $RESOURCE_GROUP"
echo "   - Ver métricas del Service Bus: az monitor metrics list --resource /subscriptions/\$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.ServiceBus/namespaces/$SERVICE_BUS_NAMESPACE"
echo "   - Ver métricas del Storage: az monitor metrics list --resource /subscriptions/\$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT"
