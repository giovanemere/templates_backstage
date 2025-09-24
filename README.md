# BillPay Backstage Templates

Templates de Backstage para la plataforma BillPay - Developer Self-Service Portal

## 🎯 Arquitectura Base de Templates

### **Estructura Estándar:**
```
template-name/
├── template.yaml              # Definición del template Backstage
├── skeleton/                  # Archivos que se generarán
│   ├── catalog-info.yaml     # Registro en catálogo Backstage
│   ├── README.md             # Documentación del proyecto
│   ├── .github/workflows/    # GitHub Actions
│   │   └── deploy.yml        # Workflow de deployment
│   └── [archivos específicos] # Configs, código, etc.
└── docs/                     # Documentación del template
    └── README.md
```

### **Flujo Estándar:**
```
Developer → Backstage Template → GitHub Repo → GitHub Actions → ia-ops-iac → AWS/Cloud
```

## 📦 Templates Disponibles

### 🎭 **billpay-demo-simple**
- **Propósito**: Crear proyecto demo BillPay
- **Alcance**: Repositorio + AWS deployment básico
- **Deployment**: Simulation o AWS real con OIDC
- **Uso**: Demos, pruebas, aprendizaje

### 🚀 **billpay-complete-stack**
- **Propósito**: Deploy completo multi-cloud
- **Alcance**: Infraestructura + Backend + Frontends
- **Clouds**: AWS, GCP, Azure, OCI
- **Deployment**: EKS/GKE/AKS + S3/Storage + CDN
- **Uso**: Producción, staging, desarrollo

## 🔧 Estándares de Implementación

### **1. Template Metadata**
```yaml
metadata:
  name: billpay-[purpose]
  title: BillPay [Purpose Title]
  description: [Clear description]
  tags: [billpay, cloud, purpose]
```

### **2. Parameters Estándar**
```yaml
parameters:
  - name: project_name (required)
  - deployment_type: [simulation, real-aws-oidc]
  - environment: [demo, dev, staging, prod]
```

### **3. Steps Estándar**
```yaml
steps:
  - fetch: Template skeleton
  - publish: Create GitHub repo
  - register: Register in Backstage catalog
  - trigger-deployment: Deploy via ia-ops-iac
```

### **4. Output Links Estándar**
```yaml
output:
  - Repository (GitHub)
  - Catalog (Backstage)
  - GitHub Actions (Monitoring)
  - AWS/Cloud Deployment (Infrastructure)
```

## 🎯 Criterios de Calidad

### **✅ Template Debe:**
- Crear repositorio funcional
- Registrarse en catálogo Backstage
- Incluir workflows de GitHub Actions
- Disparar deployment real via ia-ops-iac
- Incluir documentación completa
- Seguir naming conventions

### **📋 Skeleton Debe Incluir:**
- `catalog-info.yaml` con metadata correcta
- `README.md` con badges y links
- `.github/workflows/deploy.yml` funcional
- Archivos de configuración necesarios

## 🚀 Uso

1. **Developer** accede a Backstage: `http://localhost:3000`
2. **Create** → Choose template
3. **Configure** parámetros del proyecto
4. **Deploy** automático via GitHub Actions
5. **Monitor** en GitHub Actions + AWS Console

## 🔗 Integración

- **Backstage**: Developer portal y catálogo
- **GitHub**: Repositorios y CI/CD
- **ia-ops-iac**: Infrastructure deployment
- **AWS/Cloud**: Recursos reales

---

**Última actualización**: 2025-09-24  
**Templates activos**: 2  
**Estado**: Producción
