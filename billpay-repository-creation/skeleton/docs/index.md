# ${{ values.name }} - BillPay Demo

Welcome to the **${{ values.name }}** documentation. This project is part of the BillPay platform ecosystem.

## 🎯 Project Overview

- **Type**: BillPay Demo Project
- **Deployment**: ${{ values.deployment_type }}
- **Platform**: AWS Cloud
- **Architecture**: Microservices

## 🚀 Quick Start

1. **Repository**: [GitHub Repository](https://github.com/giovanemere/${{ values.name }})
2. **Deployment**: [GitHub Actions](https://github.com/giovanemere/${{ values.name }}/actions)
3. **Infrastructure**: [AWS Deployment](https://github.com/giovanemere/ia-ops-iac/actions)

## 📊 Status

{% if values.deployment_type == "simulation" %}
!!! info "Simulation Mode"
    This project runs in simulation mode for demonstration purposes.
    No real AWS resources are created.
{% else %}
!!! success "Production Mode"
    This project deploys real AWS infrastructure with OIDC security.
{% endif %}

## 🔗 Links

- [Architecture Overview](architecture.md)
- [API Documentation](api.md)
- [Deployment Guide](deployment.md)
- [Monitoring Setup](monitoring.md)
