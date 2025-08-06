# ${{ values.name }}

${{ values.description }}

## Descripción

Este proyecto fue generado usando el template de Backstage para infraestructura de mensajería en Azure. Incluye:

- **Azure Service Bus**: Namespace y cola para mensajería confiable
- **Azure Blob Storage**: Almacenamiento de objetos con múltiples contenedores
- **Resource Group**: Grupo de recursos para organizar todos los componentes

## Configuración del Proyecto

### Información General
- **Proyecto**: `${{ values.name }}`
- **Propietario**: `${{ values.owner }}`
- **Región Azure**: `${{ values.azure_location }}`

### Configuración de Service Bus
- **SKU**: `${{ values.service_bus_sku }}`
- **Capacidad**: `${{ values.service_bus_capacity }}` (solo Premium)
- **Particionado**: `${{ values.enable_partitioning }}`
- **Máximo Entregas**: `${{ values.max_delivery_count }}`

### Configuración de Cola
- **Tamaño Máximo**: `${{ values.queue_max_size }} MB`
- **TTL Mensajes**: `${{ values.queue_ttl }} minutos`
- **Dead Letter Queue**: `${{ values.enable_dead_lettering }}`
- **Detección Duplicados**: `${{ values.duplicate_detection }}`

### Configuración de Storage
- **Tier**: `${{ values.storage_account_tier }}`
- **Replicación**: `${{ values.storage_replication }}`
- **Access Tier**: `${{ values.blob_access_tier }}`
- **Versionado**: `${{ values.enable_versioning }}`
- **Soft Delete**: `${{ values.enable_soft_delete }}`
- **Retención**: `${{ values.soft_delete_retention }} días`

## Prerrequisitos

### Herramientas Requeridas
1. **Azure CLI** - [Instalar Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
2. **Terraform** - [Instalar Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### Configuración de Azure
1. Iniciar sesión en Azure:
```bash
az login
```

2. Verificar la suscripción:
```bash
az account show
```

3. (Opcional) Cambiar suscripción:
```bash
az account set --subscription "your-subscription-id"
```

## Despliegue

### Despliegue Automático
```bash
./scripts/deploy.sh
```

### Despliegue Manual
1. Cambiar al directorio de Terraform:
```bash
cd terraform
```

2. Inicializar Terraform:
```bash
terraform init
```

3. Planificar el despliegue:
```bash
terraform plan
```

4. Aplicar los cambios:
```bash
terraform apply
```

## Recursos Creados

### Service Bus
- **Namespace**: Namespace de Service Bus con SKU configurable
- **Cola**: Cola con configuración personalizada
- **Authorization Rules**: Reglas para Send, Listen y Manage
- **Dead Letter Queue**: Configurada automáticamente si está habilitada

### Storage Account
- **Storage Account**: Con configuración de seguridad y rendimiento
- **Contenedores**:
  - `main`: Contenedor principal
  - `processed`: Para archivos procesados
  - `failed`: Para archivos con errores
  - **archive**: Para archivos archivados
- **Lifecycle Management**: Políticas automáticas de archivado
- **Soft Delete**: Protección contra eliminación accidental

## Uso de los Servicios

### Obtener Connection Strings
```bash
cd terraform

# Service Bus
terraform output service_bus_send_connection_string
terraform output service_bus_listen_connection_string

# Storage Account
terraform output storage_account_primary_connection_string
```

### Ejemplos de Código
Revisa la carpeta `examples/` para ver ejemplos de uso en Python:
- `service_bus_example.py`: Envío y recepción de mensajes
- `blob_storage_example.py`: Subida y descarga de archivos

### Instalar Dependencias Python
```bash
pip install azure-servicebus azure-storage-blob
```

## Monitoreo

### Script de Monitoreo
```bash
./scripts/monitor.sh
```

### Comandos Útiles de Azure CLI

#### Service Bus
```bash
# Ver estado del namespace
az servicebus namespace show --resource-group <rg-name> --name <namespace-name>

# Ver estado de la cola
az servicebus queue show --resource-group <rg-name> --namespace-name <namespace-name> --name <queue-name>

# Ver métricas
az monitor metrics list --resource <service-bus-resource-id> --metric "Messages"
```

#### Storage Account
```bash
# Ver información del storage account
az storage account show --resource-group <rg-name> --name <storage-name>

# Listar contenedores
az storage container list --account-name <storage-name>

# Ver métricas de storage
az monitor metrics list --resource <storage-resource-id> --metric "Transactions"
```

## Estructura del Proyecto

```
.
├── README.md
├── catalog-info.yaml          # Definición del componente para Backstage
├── terraform/                 # Configuración de Terraform
│   ├── main.tf               # Configuración principal
│   ├── variables.tf          # Variables
│   ├── outputs.tf            # Outputs
│   ├── resource-group.tf     # Resource Group
│   ├── service-bus.tf        # Service Bus y Cola
│   └── storage.tf            # Storage Account y Contenedores
├── scripts/                   # Scripts de automatización
│   ├── deploy.sh             # Script de despliegue
│   ├── destroy.sh            # Script de destrucción
│   └── monitor.sh            # Script de monitoreo
└── examples/                  # Ejemplos de código
    ├── service_bus_example.py # Ejemplo de Service Bus
    └── blob_storage_example.py # Ejemplo de Blob Storage
```

## Seguridad

### Características de Seguridad Implementadas
- **HTTPS Only**: Forzado en Storage Account
- **TLS 1.2**: Versión mínima requerida
- **Private Containers**: Acceso privado por defecto
- **Authorization Rules**: Permisos granulares para Service Bus
- **Network Rules**: Configuración de acceso de red

### Mejores Prácticas
- Usar Azure Key Vault para connection strings en producción
- Implementar Azure Private Endpoints para mayor seguridad
- Configurar Azure Monitor para alertas
- Usar Managed Identity cuando sea posible

## Costos

### Factores de Costo
- **Service Bus**: Basado en SKU y número de operaciones
- **Storage Account**: Basado en almacenamiento usado y transacciones
- **Data Transfer**: Transferencia de datos entre regiones

### Optimización de Costos
- Usar lifecycle policies para mover datos a tiers más baratos
- Monitorear uso con Azure Cost Management
- Considerar Reserved Capacity para cargas predecibles

## Limpieza

### Destrucción Automática
```bash
./scripts/destroy.sh
```

### Destrucción Manual
```bash
cd terraform
terraform destroy
```

**⚠️ Advertencia**: Esto eliminará todos los recursos y datos.

## Troubleshooting

### Problemas Comunes

#### Error de Permisos
```
Error: Insufficient privileges
```
**Solución**: Verificar permisos en la suscripción de Azure.

#### Error de Nombres Únicos
```
Error: Storage account name already exists
```
**Solución**: Los nombres se generan automáticamente con sufijo aleatorio.

#### Error de Cuota
```
Error: Quota exceeded
```
**Solución**: Verificar límites de la suscripción en Azure Portal.

## Próximos Pasos

1. **Configurar Alertas**: Implementar Azure Monitor alerts
2. **CI/CD**: Integrar con Azure DevOps o GitHub Actions
3. **Backup**: Configurar backup automático
4. **Scaling**: Implementar auto-scaling si es necesario
5. **Security**: Implementar Azure Security Center recommendations
