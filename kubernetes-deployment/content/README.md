# ${{ values.name }}

${{ values.description }}

## Descripción

Este proyecto fue generado usando el template de Backstage para deployments de Kubernetes en Minikube.

## Configuración

- **Imagen Docker**: `${{ values.image }}`
- **Puerto**: `${{ values.port }}`
- **Réplicas**: `${{ values.replicas }}`
- **Propietario**: `${{ values.owner }}`

## Recursos Configurados

### CPU y Memoria
- **CPU Request**: `${{ values.resources_requests_cpu }}`
- **Memory Request**: `${{ values.resources_requests_memory }}`
- **CPU Limit**: `${{ values.resources_limits_cpu }}`
- **Memory Limit**: `${{ values.resources_limits_memory }}`

## Despliegue en Minikube

### Prerrequisitos

1. Tener Minikube instalado y ejecutándose:
```bash
minikube start
```

2. Verificar que kubectl esté configurado para usar Minikube:
```bash
kubectl config current-context
```

### Desplegar la aplicación

1. Aplicar los manifiestos de Kubernetes:
```bash
kubectl apply -k k8s/
```

2. Verificar que los pods estén ejecutándose:
```bash
kubectl get pods -n ${{ values.name }}-ns
```

3. Verificar el servicio:
```bash
kubectl get svc -n ${{ values.name }}-ns
```

### Acceder a la aplicación

Para acceder a la aplicación en Minikube:

```bash
minikube service ${{ values.name }}-service -n ${{ values.name }}-ns
```

Este comando abrirá automáticamente la aplicación en tu navegador.

Alternativamente, puedes obtener la URL del servicio:
```bash
minikube service ${{ values.name }}-service -n ${{ values.name }}-ns --url
```

### Monitoreo

Para ver los logs de la aplicación:
```bash
kubectl logs -f deployment/${{ values.name }} -n ${{ values.name }}-ns
```

Para ver el estado de los pods:
```bash
kubectl describe pods -n ${{ values.name }}-ns
```

### Escalado

Para escalar la aplicación:
```bash
kubectl scale deployment ${{ values.name }} --replicas=3 -n ${{ values.name }}-ns
```

### Limpieza

Para eliminar todos los recursos:
```bash
kubectl delete -k k8s/
```

## Estructura del Proyecto

```
.
├── README.md
├── catalog-info.yaml          # Definición del componente para Backstage
└── k8s/
    ├── deployment.yaml        # Deployment de Kubernetes
    ├── service.yaml          # Service de Kubernetes
    ├── namespace.yaml        # Namespace dedicado
    └── kustomization.yaml    # Configuración de Kustomize
```

## Troubleshooting

### La aplicación no responde

1. Verificar que los pods estén en estado `Running`:
```bash
kubectl get pods -n ${{ values.name }}-ns
```

2. Revisar los logs:
```bash
kubectl logs deployment/${{ values.name }} -n ${{ values.name }}-ns
```

3. Verificar los eventos:
```bash
kubectl get events -n ${{ values.name }}-ns --sort-by='.lastTimestamp'
```

### Problemas de recursos

Si los pods no pueden iniciarse por falta de recursos, puedes:

1. Verificar los recursos disponibles en Minikube:
```bash
kubectl top nodes
```

2. Ajustar los límites de recursos en `k8s/deployment.yaml`

3. Volver a aplicar los cambios:
```bash
kubectl apply -k k8s/
```
