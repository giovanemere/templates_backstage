# ${{ values.name }}

${{ values.description }}

## Descripción

Este proyecto fue generado usando el template de Backstage para Oracle Cloud Infrastructure (OCI) Networking. Incluye:

- **Virtual Cloud Network (VCN)**: Red virtual con configuración DNS
- **Internet Gateway**: Para conectividad a internet
- **NAT Gateway**: Para acceso saliente desde subnets privadas
- **Service Gateway**: Para acceso a servicios de Oracle
- **Subnets**: Subnets públicas y/o privadas según configuración
- **Route Tables**: Tablas de enrutamiento configuradas
- **Security Lists**: Listas de seguridad con reglas básicas

## Configuración del Proyecto

### Información General
- **Proyecto**: `${{ values.name }}`
- **Propietario**: `${{ values.owner }}`
- **Tenancy OCID**: `${{ values.oci_tenancy_ocid }}`
- **Compartment OCID**: `${{ values.oci_compartment_ocid }}`
- **Región OCI**: `${{ values.oci_region }}`

### Configuración de VCN
- **CIDR Block**: `${{ values.vcn_cidr_block }}`
- **DNS Hostnames**: `${{ values.enable_dns_hostnames }}`
- **DNS Resolution**: `${{ values.enable_dns_resolution }}`

### Configuración de Subnets
- **Subnet Pública**: `${{ values.create_public_subnet }}`
  - CIDR: `${{ values.public_subnet_cidr }}`
- **Subnet Privada**: `${{ values.create_private_subnet }}`
  - CIDR: `${{ values.private_subnet_cidr }}`

## Prerrequisitos

### Herramientas Requeridas
1. **OCI CLI** - [Instalar OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)
2. **Terraform** - [Instalar Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### Configuración de OCI
1. Configurar OCI CLI:
```bash
oci setup config
```

2. Verificar configuración:
```bash
oci iam region list
```

3. Generar par de claves API (si no existe):
```bash
mkdir -p ~/.oci
openssl genrsa -out ~/.oci/oci_api_key.pem 2048
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
```

4. Agregar la clave pública en OCI Console:
   - Ir a Identity & Security > Users
   - Seleccionar tu usuario
   - Agregar API Key

## Despliegue

### Despliegue Automático
```bash
./scripts/deploy.sh
```

### Despliegue Manual
1. Completar archivo terraform.tfvars:
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus credenciales
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

### Networking
- **VCN**: Red virtual con CIDR `${{ values.vcn_cidr_block }}`
- **Internet Gateway**: Para acceso a internet
- **NAT Gateway**: Para salida desde subnets privadas
- **Service Gateway**: Para servicios de Oracle

### Subnets
{% if values.create_public_subnet %}
- **Public Subnet**: `${{ values.public_subnet_cidr }}`
  - Permite IPs públicas
  - Enrutada a Internet Gateway
{% endif %}
{% if values.create_private_subnet %}
- **Private Subnet**: `${{ values.private_subnet_cidr }}`
  - No permite IPs públicas
  - Enrutada a NAT Gateway
{% endif %}

### Security
- **Default Security List**: Reglas básicas de seguridad
  - SSH (puerto 22)
  - HTTP (puerto 80)
  - HTTPS (puerto 443)
  - Tráfico interno de VCN

## Uso de la Infraestructura

### Obtener Información
```bash
cd terraform

# IDs de recursos
terraform output vcn_id
terraform output public_subnet_id
terraform output private_subnet_id
```

### Crear Instancias de Compute
```bash
# En subnet pública
oci compute instance launch \
  --availability-domain $(terraform output -raw availability_domains | jq -r '.[0]') \
  --compartment-id ${{ values.oci_compartment_ocid }} \
  --image-id <image-ocid> \
  --shape VM.Standard2.1 \
  --subnet-id $(terraform output -raw public_subnet_id) \
  --display-name "public-instance"

# En subnet privada
oci compute instance launch \
  --availability-domain $(terraform output -raw availability_domains | jq -r '.[0]') \
  --compartment-id ${{ values.oci_compartment_ocid }} \
  --image-id <image-ocid> \
  --shape VM.Standard2.1 \
  --subnet-id $(terraform output -raw private_subnet_id) \
  --assign-public-ip false \
  --display-name "private-instance"
```

## Monitoreo

### Comandos Útiles de OCI CLI
```bash
# Ver información de VCN
oci network vcn get --vcn-id $(terraform output -raw vcn_id)

# Listar subnets
oci network subnet list --compartment-id ${{ values.oci_compartment_ocid }} --vcn-id $(terraform output -raw vcn_id)

# Ver route tables
oci network route-table list --compartment-id ${{ values.oci_compartment_ocid }} --vcn-id $(terraform output -raw vcn_id)

# Ver security lists
oci network security-list list --compartment-id ${{ values.oci_compartment_ocid }} --vcn-id $(terraform output -raw vcn_id)
```

### Métricas y Logging
```bash
# Ver métricas de red
oci monitoring metric list --compartment-id ${{ values.oci_compartment_ocid }} --namespace oci_vcn

# Ver logs de audit
oci audit event list --compartment-id ${{ values.oci_compartment_ocid }} --start-time $(date -d '1 hour ago' -u +%Y-%m-%dT%H:%M:%S.000Z)
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
│   └── networking.tf         # Configuración de VCN y subnets
└── scripts/                   # Scripts de automatización
    └── deploy.sh             # Script de despliegue
```

## Seguridad

### Características Implementadas
- **Security Lists**: Reglas de firewall a nivel de subnet
- **Route Tables**: Control de enrutamiento de tráfico
- **Private Subnets**: Subnets sin acceso directo a internet
- **Service Gateway**: Acceso seguro a servicios de Oracle

### Mejores Prácticas
- Usar Network Security Groups para reglas más granulares
- Implementar bastion hosts para acceso a subnets privadas
- Configurar VPN o FastConnect para conectividad híbrida
- Usar OCI Vault para gestión de secretos

## Costos

### Factores de Costo
- **VCN**: Gratuita
- **Gateways**: NAT Gateway tiene costo por hora y por GB procesado
- **Data Transfer**: Transferencia de datos entre regiones
- **Compute Instances**: Instancias que se desplieguen en las subnets

### Optimización
- Usar NAT Gateway solo cuando sea necesario
- Considerar NAT Instance para cargas menores
- Monitorear transferencia de datos

## Limpieza

### Eliminar Recursos
```bash
cd terraform
terraform destroy
```

**⚠️ Advertencia**: Asegúrate de que no hay instancias u otros recursos en las subnets antes de destruir.

## Troubleshooting

### Problemas Comunes

#### Error de Autenticación
```
Error: Service error:NotAuthenticated
```
**Solución**: Verificar configuración en ~/.oci/config y permisos de API key.

#### Error de Permisos
```
Error: Service error:NotAuthorizedOrNotFound
```
**Solución**: Verificar permisos en el compartment y políticas IAM.

#### Error de Límites
```
Error: Service error:LimitExceeded
```
**Solución**: Verificar límites de servicio en OCI Console.

### Verificar Conectividad
```bash
# Ping a gateway
ping $(terraform output -raw internet_gateway_id | cut -d. -f1)

# Test de conectividad desde instancia
# (ejecutar desde instancia en subnet)
curl -I http://www.oracle.com
```

## Próximos Pasos

1. **Load Balancer**: Agregar Network Load Balancer
2. **Security**: Implementar Network Security Groups
3. **Monitoring**: Configurar alertas de red
4. **Connectivity**: Configurar VPN o FastConnect
5. **DNS**: Configurar DNS privado
