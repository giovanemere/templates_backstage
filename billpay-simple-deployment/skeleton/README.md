# ${{ values.name }} - BillPay Simple Deployment

Simple BillPay deployment without EKS complexity.

## 🚀 Deployment Type: ${{ values.deployment_type }}

{% if values.deployment_type == "simulation" %}
🎭 **Simulation Mode** - Demo deployment for testing
{% else %}
☁️ **AWS Simple** - Real deployment with S3, Lambda, CloudFront
{% endif %}

## 🏗️ Architecture

- **Frontend**: Static files → S3 + CloudFront
- **Backend**: Lambda functions
- **Storage**: S3 buckets
- **CDN**: CloudFront distribution

## 📊 Monitoring

- **🔄 GitHub Actions**: [View Workflows](https://github.com/giovanemere/${{ values.name }}/actions)
- **☁️ AWS Deployment**: [Monitor Infrastructure](https://github.com/giovanemere/ia-ops-iac/actions)

## 🔗 Quick Links

- [📋 All Workflows](https://github.com/giovanemere/${{ values.name }}/actions)
- [🚀 Deploy Workflow](https://github.com/giovanemere/${{ values.name }}/actions/workflows/deploy.yml)
- [☁️ Infrastructure Status](https://github.com/giovanemere/ia-ops-iac/actions)
