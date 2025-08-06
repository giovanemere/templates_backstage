# Backstage Infrastructure Templates

Este repositorio contiene templates de Backstage para desplegar infraestructura en diferentes proveedores cloud.

## Templates Disponibles

### 🐳 Kubernetes
- **kubernetes-deployment**: Deployment completo para Minikube con Service y Namespace

### ☁️ AWS
- **aws-infrastructure**: Lambda, S3, EC2 y EKS con Terraform

### 🔵 Azure
- **azure-messaging**: Service Bus, Cola y Blob Storage

### 🟡 Google Cloud Platform
- **gcp-storage**: Cloud Storage Bucket con Service Account

### 🔴 Oracle Cloud Infrastructure
- **oci-networking**: Virtual Cloud Network con Subnets

## Cómo Usar

1. Navega a tu instancia de Backstage
2. Ve a "Create Component"
3. Selecciona el template deseado
4. Completa los parámetros
5. El template creará un nuevo repositorio con toda la infraestructura

## Prerrequisitos por Template

### Kubernetes
- `kubectl` configurado
- Minikube ejecutándose

### AWS
- AWS CLI configurado
- Terraform instalado
- Credenciales de AWS

### Azure
- Azure CLI configurado
- Terraform instalado

### GCP
- gcloud CLI configurado
- Terraform instalado
- Proyecto GCP existente

### OCI
- OCI CLI configurado
- Terraform instalado
- API Keys configuradas

## Estructura de Templates

Cada template incluye:
- 📋 **template.yaml**: Definición del template de Backstage
- 🏗️ **terraform/**: Configuración de infraestructura
- 🚀 **scripts/**: Scripts de automatización
- 📖 **README.md**: Documentación detallada
- 💡 **examples/**: Ejemplos de uso (cuando aplica)

## Contribuir

Para agregar nuevos templates:
1. Crear directorio con la estructura estándar
2. Agregar el template a `catalog-info.yaml`
3. Documentar en este README
4. Crear PR para revisión
