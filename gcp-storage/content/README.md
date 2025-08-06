# ${{ values.name }}

${{ values.description }}

## Descripción

Este proyecto fue generado usando el template de Backstage para Google Cloud Storage. Incluye:

- **Cloud Storage Bucket**: Bucket con configuración de seguridad y lifecycle
- **Service Account**: Cuenta de servicio para acceso programático
- **IAM Bindings**: Permisos configurados apropiadamente

## Configuración del Proyecto

### Información General
- **Proyecto**: `${{ values.name }}`
- **Propietario**: `${{ values.owner }}`
- **GCP Project ID**: `${{ values.gcp_project_id }}`
- **Región GCP**: `${{ values.gcp_region }}`

### Configuración del Bucket
- **Ubicación**: `${{ values.bucket_location }}`
- **Storage Class**: `${{ values.storage_class }}`
- **Versionado**: `${{ values.enable_versioning }}`
- **Lifecycle Management**: `${{ values.enable_lifecycle }}`
- **Días para NEARLINE**: `${{ values.lifecycle_age_days }}`

## Prerrequisitos

### Herramientas Requeridas
1. **Google Cloud SDK** - [Instalar gcloud](https://cloud.google.com/sdk/docs/install)
2. **Terraform** - [Instalar Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### Configuración de GCP
1. Autenticarse en GCP:
```bash
gcloud auth login
gcloud auth application-default login
```

2. Verificar el proyecto:
```bash
gcloud config get-value project
```

3. Configurar el proyecto (si es necesario):
```bash
gcloud config set project ${{ values.gcp_project_id }}
```

## Despliegue

### Despliegue Automático
```bash
./scripts/deploy.sh
```

### Despliegue Manual
1. Habilitar APIs necesarias:
```bash
gcloud services enable storage.googleapis.com
gcloud services enable iam.googleapis.com
```

2. Cambiar al directorio de Terraform:
```bash
cd terraform
```

3. Inicializar Terraform:
```bash
terraform init
```

4. Planificar el despliegue:
```bash
terraform plan
```

5. Aplicar los cambios:
```bash
terraform apply
```

## Uso del Bucket

### Obtener Información del Bucket
```bash
cd terraform
terraform output bucket_name
terraform output bucket_url
```

### Obtener Service Account Key
```bash
terraform output -raw service_account_key | base64 -d > service-account-key.json
```

### Usar gsutil
```bash
# Listar contenido del bucket
gsutil ls gs://$(terraform output -raw bucket_name)

# Subir un archivo
gsutil cp file.txt gs://$(terraform output -raw bucket_name)/

# Descargar un archivo
gsutil cp gs://$(terraform output -raw bucket_name)/file.txt ./
```

### Usar con Python
```python
from google.cloud import storage
import json

# Configurar cliente con service account
client = storage.Client.from_service_account_json('service-account-key.json')

# Obtener bucket
bucket_name = 'your-bucket-name'
bucket = client.bucket(bucket_name)

# Subir archivo
blob = bucket.blob('example.txt')
blob.upload_from_string('Hello, World!')

# Descargar archivo
content = blob.download_as_text()
print(content)
```

## Características de Seguridad

### Configuración Implementada
- **Uniform Bucket-Level Access**: Habilitado para consistencia de permisos
- **Public Access Prevention**: Forzado para prevenir acceso público accidental
- **Service Account**: Cuenta dedicada con permisos mínimos necesarios
- **CORS**: Configurado para aplicaciones web

### Lifecycle Management
Si está habilitado, los objetos se mueven automáticamente:
- A **NEARLINE** después de `${{ values.lifecycle_age_days }}` días
- Las versiones archivadas se eliminan después de 90 días

## Monitoreo

### Comandos Útiles
```bash
# Ver información del bucket
gsutil ls -L -b gs://$(terraform output -raw bucket_name)

# Ver métricas de uso
gcloud logging read "resource.type=gcs_bucket AND resource.labels.bucket_name=$(terraform output -raw bucket_name)" --limit=10

# Ver costos (requiere billing export configurado)
gcloud billing budgets list
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
│   └── storage.tf            # Configuración del bucket
└── scripts/                   # Scripts de automatización
    └── deploy.sh             # Script de despliegue
```

## Limpieza

### Eliminar Recursos
```bash
cd terraform
terraform destroy
```

**⚠️ Advertencia**: Esto eliminará el bucket y todos sus contenidos.

## Troubleshooting

### Problemas Comunes

#### Error de Permisos
```
Error: googleapi: Error 403: Forbidden
```
**Solución**: Verificar permisos en el proyecto GCP y autenticación.

#### Error de Nombre de Bucket
```
Error: googleapi: Error 409: Conflict
```
**Solución**: Los nombres se generan automáticamente con sufijo aleatorio.

#### Error de API no habilitada
```
Error: googleapi: Error 403: Cloud Storage JSON API has not been used
```
**Solución**: Habilitar la API con `gcloud services enable storage.googleapis.com`

## Próximos Pasos

1. **Configurar Monitoring**: Implementar Cloud Monitoring alerts
2. **Backup**: Configurar cross-region replication
3. **Security**: Implementar VPC Service Controls
4. **Cost Optimization**: Revisar lifecycle policies regularmente
