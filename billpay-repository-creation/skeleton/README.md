# ${{ values.name }}

[![Deploy Status](https://github.com/giovanemere/${{ values.name }}/workflows/Deploy/badge.svg)](https://github.com/giovanemere/${{ values.name }}/actions/workflows/deploy.yml)

BillPay Project: **${{ values.name }}**

## 🚀 Deployment Type: ${{ values.deployment_type }}

{% if values.deployment_type == "simulation" %}
🎭 **Simulation Mode** - Demo deployment for testing
{% else %}
🔐 **AWS Production** - Real deployment with OIDC security
{% endif %}

## 📊 Monitoring

- **🔄 GitHub Actions**: [View Workflows](https://github.com/giovanemere/${{ values.name }}/actions)
- **☁️ AWS Deployment**: [Monitor Infrastructure](https://github.com/giovanemere/ia-ops-iac/actions)
- **📱 Mobile**: GitHub Mobile App → giovanemere/${{ values.name }}

## 🏗️ Architecture

This project follows BillPay's enterprise architecture:
- **Frontend**: Angular 17 + Module Federation
- **Backend**: Java/Gradle microservices  
- **Infrastructure**: AWS EKS + OpenTofu
- **CI/CD**: GitHub Actions + OIDC

## 🔗 Quick Links

- [📋 All Workflows](https://github.com/giovanemere/${{ values.name }}/actions)
- [🚀 Deploy Workflow](https://github.com/giovanemere/${{ values.name }}/actions/workflows/deploy.yml)
- [☁️ Infrastructure Status](https://github.com/giovanemere/ia-ops-iac/actions)
