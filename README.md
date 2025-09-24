# BillPay Backstage Templates

Templates de Backstage para la plataforma BillPay - Developer Self-Service Portal con gestión automatizada via MCP.

## 🎯 Arquitectura de Templates

### **Flujos Implementados:**

```
📦 Repository Creation: User → Backstage → GitHub Repo → GitHub Actions → ia-ops-iac → AWS
🚀 Simple Deployment:   User → Backstage → ia-ops-iac/deploy-simple.yml → AWS (S3+Lambda+CloudFront)
☁️ Complete Stack:      User → Backstage → ia-ops-iac/deploy-complete.yml → AWS (EKS+ECR+S3+ALB)
```

### **Estructura Estándar:**
```
billpay-[purpose]/
├── template.yaml              # Backstage template definition
├── skeleton/ (solo si crea repo) # Generated files
│   ├── catalog-info.yaml     # Backstage catalog registration
│   ├── README.md             # Project documentation
│   ├── .github/workflows/    # CI/CD workflows
│   │   └── deploy.yml        # Standard deployment workflow
│   └── [specific files]      # Template-specific files
└── docs/ (opcional)          # Template documentation
```

## 📦 Templates Disponibles

### 🏗️ **billpay-repository-creation**
- **Propósito**: Crear repositorio nuevo con deployment básico
- **Flujo**: `fetch → publish → register → trigger-deployment`
- **Crea Repo**: ✅ Sí
- **Target**: `ia-ops-iac/deploy-demo.yml`
- **Uso**: Nuevos proyectos, prototipos, demos

**Parámetros:**
- `name`: Nombre del proyecto
- `deployment_type`: simulation | real-aws-oidc

### 🚀 **billpay-simple-deployment**
- **Propósito**: Deployment simple sin EKS (S3, Lambda, CloudFront)
- **Flujo**: `trigger-deployment → register`
- **Crea Repo**: ❌ No
- **Target**: `ia-ops-iac/deploy-simple.yml`
- **Uso**: Aplicaciones web estáticas, APIs serverless

**Parámetros:**
- `project_name`: Nombre del deployment
- `environment`: demo | dev | staging
- `deployment_type`: simulation | real-aws-oidc

### ☁️ **billpay-complete-stack**
- **Propósito**: Deployment completo multi-cloud con Kubernetes
- **Flujo**: `trigger-deployment → register`
- **Crea Repo**: ❌ No
- **Target**: `ia-ops-iac/deploy-complete.yml`
- **Uso**: Aplicaciones enterprise, microservicios, producción

**Parámetros:**
- `project_name`: Nombre del deployment
- `cloud_provider`: aws | gcp | azure | oci
- `region`: Región del cloud provider
- `environment`: dev | staging | prod
- + 9 flags de componentes (VPC, EKS, ECR, etc.)

## 🤖 Gestión con MCP Template Manager

### **MCP Server**: `mcp-template-manager`
Automatiza la creación, validación y mantenimiento de templates siguiendo estándares BillPay.

**Ubicación**: `/home/giovanemere/periferia/billpay/infrastructure/mcp-tools/mcp-template-manager/`

### **🔧 Herramientas MCP Disponibles:**

#### `create_template`
Crea nuevo template siguiendo estándares BillPay.
```bash
create_template repository-creation "Create new BillPay repository"
create_template simple-deployment "Simple deployment without EKS"
create_template complete-stack "Full multi-cloud deployment"
```

#### `validate_template`
Valida template contra estándares BillPay.
```bash
validate_template billpay-repository-creation
validate_template billpay-simple-deployment
```

#### `fix_template_branches`
Corrige inconsistencias de ramas automáticamente.
```bash
fix_template_branches billpay-complete-stack
```

#### `rename_template`
Renombra template siguiendo convenciones.
```bash
rename_template billpay-demo-simple repository-creation
```

#### `list_templates`
Lista todos los templates con estado.
```bash
list_templates
```

### **📋 Tipos de Templates MCP:**

| Tipo | Propósito | Crea Repo | Target Workflow |
|------|-----------|-----------|----------------|
| `repository-creation` | Crear repo + deployment básico | ✅ | deploy-demo.yml |
| `simple-deployment` | Deploy simple (S3+Lambda) | ❌ | deploy-simple.yml |
| `complete-stack` | Deploy completo multi-cloud | ❌ | deploy-complete.yml |

## 🏗️ Estándares Implementados

### **Naming Convention**
- Formato: `billpay-{purpose}`
- Ejemplos: `billpay-repository-creation`, `billpay-simple-deployment`

### **Configuración de Ramas Centralizada**
```yaml
# shared-config.yaml
repositories:
  ia-ops-iac:
    branch: trunk  # Siempre trunk para ia-ops-iac
  default_project:
    branch: main   # Siempre main para nuevos proyectos
workflows:
  trigger_branches: [main, trunk]  # Workflows aceptan ambas
```

### **Steps Estándar**
```yaml
# Para templates que crean repositorio
steps: [fetch, publish, register, trigger-deployment]

# Para templates deployment-only  
steps: [trigger-deployment, register]
```

### **Output Links Estándar**
- Repository (solo si crea repo)
- Catalog (Backstage)
- GitHub Actions / Deployment Status
- AWS/Cloud Console

## 🚀 Uso

### **1. Acceder a Backstage**
```bash
cd /home/giovanemere/ia-ops/ia-ops-backstage
./scripts/start-development.sh
# Acceder: http://localhost:3000
```

### **2. Crear Componente**
1. **Create** → **Choose a template**
2. Seleccionar template apropiado:
   - **Repository Creation**: Para nuevos proyectos
   - **Simple Deployment**: Para apps web/serverless
   - **Complete Stack**: Para microservicios enterprise

### **3. Configurar Parámetros**
- Completar formulario según template
- Elegir tipo de deployment (simulation/real)
- Configurar entorno y región

### **4. Monitorear Deployment**
- **GitHub Actions**: Workflows del proyecto
- **AWS Deployment**: ia-ops-iac workflows
- **Backstage Catalog**: Estado del componente

## 🔧 Mantenimiento con MCP

### **Crear Nuevo Template**
```bash
# Usar MCP para crear template estandarizado
create_template api-gateway "BillPay API Gateway deployment"
```

### **Validar Templates Existentes**
```bash
# Verificar cumplimiento de estándares
validate_template billpay-repository-creation
validate_template billpay-simple-deployment
validate_template billpay-complete-stack
```

### **Corregir Problemas Automáticamente**
```bash
# Corregir ramas inconsistentes
fix_template_branches billpay-complete-stack

# Renombrar siguiendo convenciones
rename_template old-template-name new-purpose
```

## 📊 Integración Completa

### **Flujo End-to-End:**
```
Developer → Backstage UI → Template Selection → Parameter Input → 
GitHub Actions Dispatch → ia-ops-iac Workflow → AWS Deployment → 
Backstage Catalog Registration → Monitoring Dashboard
```

### **Componentes Integrados:**
- **Backstage**: Developer portal y catálogo
- **GitHub**: Repositorios y CI/CD
- **ia-ops-iac**: Infrastructure deployment
- **AWS/Cloud**: Recursos reales
- **MCP**: Template management automation

## 🎯 Criterios de Calidad

### **✅ Template Debe:**
- Seguir naming convention `billpay-{purpose}`
- Usar configuración de ramas centralizada
- Incluir steps estándar apropiados
- Generar output links consistentes
- Pasar validación MCP

### **✅ Deployment Debe:**
- Usar `ia-ops-iac` con rama `trunk`
- Soportar simulation y real deployment
- Registrarse en catálogo Backstage
- Incluir links de monitoreo

### **✅ Mantenimiento Debe:**
- Usar MCP para cambios
- Validar antes de commit
- Seguir estándares documentados
- Mantener consistencia entre templates

## 🔗 Enlaces Útiles

- **Backstage Local**: http://localhost:3000
- **GitHub Templates**: https://github.com/giovanemere/templates_backstage
- **Infrastructure**: https://github.com/giovanemere/ia-ops-iac
- **MCP Tools**: `/home/giovanemere/periferia/billpay/infrastructure/mcp-tools/`

---

**Última actualización**: 2025-09-24  
**Templates activos**: 3  
**Estado**: Producción con MCP automation  
**Gestión**: Automatizada via MCP Template Manager
