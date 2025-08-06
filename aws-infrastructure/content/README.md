# ${{ values.name }}

${{ values.description }}

## Descripción

Este proyecto fue generado usando el template de Backstage para infraestructura AWS completa. Incluye:

- **AWS Lambda**: Función serverless para procesamiento
- **Amazon S3**: Almacenamiento de objetos
- **Amazon EC2**: Instancia de computación
- **Amazon EKS**: Cluster de Kubernetes gestionado

## Configuración del Proyecto

### Información General
- **Proyecto**: `${{ values.name }}`
- **Propietario**: `${{ values.owner }}`
- **Región AWS**: `${{ values.aws_region }}`

### Configuración de Lambda
- **Runtime**: `${{ values.lambda_runtime }}`
- **Memoria**: `${{ values.lambda_memory }} MB`
- **Timeout**: `${{ values.lambda_timeout }} segundos`

### Configuración de S3
- **Versionado**: `${{ values.s3_versioning }}`
- **Encriptación**: `${{ values.s3_encryption }}`
- **Acceso Público Bloqueado**: `${{ values.s3_public_access }}`

### Configuración de EC2
- **Tipo de Instancia**: `${{ values.ec2_instance_type }}`
- **Key Pair**: `${{ values.ec2_key_pair }}`
- **Tamaño del Volumen**: `${{ values.ec2_volume_size }} GB`

### Configuración de EKS
- **Versión de Kubernetes**: `${{ values.eks_version }}`
- **Tipo de Instancia de Nodos**: `${{ values.eks_node_instance_type }}`
- **Capacidad Deseada**: `${{ values.eks_desired_capacity }} nodos`
- **Capacidad Máxima**: `${{ values.eks_max_capacity }} nodos`
- **Capacidad Mínima**: `${{ values.eks_min_capacity }} nodos`

## Prerrequisitos

### Herramientas Requeridas
1. **AWS CLI** - [Instalar AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
2. **Terraform** - [Instalar Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
3. **kubectl** - [Instalar kubectl](https://kubernetes.io/docs/tasks/tools/)

### Configuración de AWS
1. Configurar credenciales de AWS:
```bash
aws configure
```

2. Verificar acceso:
```bash
aws sts get-caller-identity
```

3. Asegurarse de que el key pair especificado (`${{ values.ec2_key_pair }}`) existe en AWS.

## Despliegue

### Despliegue Automático
Ejecutar el script de despliegue:
```bash
./scripts/deploy.sh
```

### Despliegue Manual
1. Cambiar al directorio de Terraform:
```bash
cd terraform
```

2. Preparar código Lambda:
```bash
cd ../lambda
zip function.zip index.py  # o index.js para Node.js
cd ../terraform
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

## Configuración Post-Despliegue

### Configurar kubectl para EKS
```bash
./scripts/configure-eks.sh
```

O manualmente:
```bash
aws eks update-kubeconfig --region ${{ values.aws_region }} --name ${{ values.name }}-eks
```

### Verificar Servicios

#### EC2
Acceder a la instancia EC2 via web:
```bash
# La IP pública se muestra en los outputs de Terraform
curl http://<EC2_PUBLIC_IP>
```

Acceder via SSH:
```bash
ssh -i ~/.ssh/${{ values.ec2_key_pair }}.pem ec2-user@<EC2_PUBLIC_IP>
```

#### Lambda
Probar la función Lambda:
```bash
aws lambda invoke --function-name ${{ values.name }}-function response.json
cat response.json
```

#### S3
Listar contenido del bucket:
```bash
aws s3 ls s3://<BUCKET_NAME>
```

#### EKS
Verificar el cluster:
```bash
kubectl get nodes
kubectl get pods --all-namespaces
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
│   ├── vpc.tf                # Configuración de VPC
│   ├── s3.tf                 # Configuración de S3
│   ├── lambda.tf             # Configuración de Lambda
│   ├── ec2.tf                # Configuración de EC2
│   ├── eks.tf                # Configuración de EKS
│   └── user_data.sh          # Script de inicialización de EC2
├── lambda/                    # Código de Lambda
│   ├── index.py              # Función Lambda en Python
│   └── index.js              # Función Lambda en Node.js
└── scripts/                   # Scripts de automatización
    ├── deploy.sh             # Script de despliegue
    ├── destroy.sh            # Script de destrucción
    └── configure-eks.sh      # Script de configuración de EKS
```

## Recursos Creados

### Networking
- VPC con CIDR 10.0.0.0/16
- 2 subnets públicas (10.0.1.0/24, 10.0.2.0/24)
- 2 subnets privadas (10.0.10.0/24, 10.0.11.0/24)
- Internet Gateway
- 2 NAT Gateways
- Route Tables y asociaciones

### Compute
- **EC2**: Instancia con Apache HTTP Server
- **Lambda**: Función con integración S3 y EC2
- **EKS**: Cluster con node group

### Storage
- **S3**: Bucket con configuración de seguridad

### Security
- Security Groups para cada servicio
- IAM Roles y Policies
- Encriptación habilitada donde sea posible

## Monitoreo y Logs

### CloudWatch Logs
- Lambda: `/aws/lambda/${{ values.name }}-function`
- EKS: `/aws/eks/${{ values.name }}-eks/cluster`

### Verificar Logs
```bash
# Logs de Lambda
aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/${{ values.name }}"

# Logs de EKS
aws logs describe-log-groups --log-group-name-prefix "/aws/eks/${{ values.name }}"
```

## Costos Estimados

Los recursos desplegados generarán costos en AWS. Para obtener estimaciones precisas, usa la [Calculadora de Precios de AWS](https://calculator.aws).

### Recursos que generan costos:
- EC2 instance (${{ values.ec2_instance_type }})
- EKS cluster y nodos worker
- NAT Gateways (2)
- EBS volumes
- Lambda invocations
- S3 storage y requests
- CloudWatch logs

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

**⚠️ Advertencia**: Esto eliminará todos los recursos y datos. Asegúrate de hacer backup de cualquier información importante.

## Troubleshooting

### Problemas Comunes

#### Error de Key Pair
```
Error: InvalidKeyPair.NotFound
```
**Solución**: Crear el key pair en AWS EC2 console o usar uno existente.

#### Error de Permisos
```
Error: AccessDenied
```
**Solución**: Verificar que las credenciales de AWS tengan los permisos necesarios.

#### Error de Límites de Servicio
```
Error: LimitExceeded
```
**Solución**: Verificar los límites de servicio en AWS y solicitar aumentos si es necesario.

### Verificar Estado de Recursos
```bash
# Estado de Terraform
terraform show

# Estado de AWS
aws ec2 describe-instances --filters "Name=tag:Project,Values=${{ values.name }}"
aws s3 ls | grep ${{ values.name }}
aws lambda list-functions --query "Functions[?contains(FunctionName, '${{ values.name }}')]"
aws eks list-clusters --query "clusters[?contains(@, '${{ values.name }}')]"
```

## Soporte

Para problemas relacionados con:
- **Terraform**: [Documentación de Terraform](https://www.terraform.io/docs)
- **AWS**: [Documentación de AWS](https://docs.aws.amazon.com/)
- **Kubernetes**: [Documentación de Kubernetes](https://kubernetes.io/docs/)

## Próximos Pasos

1. **Configurar CI/CD**: Integrar con GitHub Actions o AWS CodePipeline
2. **Monitoreo**: Configurar CloudWatch dashboards y alertas
3. **Seguridad**: Implementar AWS Config y Security Hub
4. **Backup**: Configurar AWS Backup para recursos críticos
5. **Scaling**: Configurar Auto Scaling para EC2 y EKS
