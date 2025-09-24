# API Reference

## BillPay Demo API

The ${{ values.name }} project provides a RESTful API for payment processing demonstrations.

### Base URL

{% if values.deployment_type == "simulation" %}
```
https://${{ values.name }}.demo.billpay.com/api/v1
```
{% else %}
```
https://api-${{ values.name }}.billpay.com/v1
```
{% endif %}

### Authentication

All API endpoints require authentication via JWT tokens obtained from the BillPay Core API.

```bash
curl -H "Authorization: Bearer <token>" \
     https://api-${{ values.name }}.billpay.com/v1/health
```

### Endpoints

#### Health Check
```http
GET /health
```

Returns the health status of the service.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-09-24T14:43:00Z",
  "version": "1.0.0"
}
```

#### List Payments
```http
GET /payments
```

Returns a list of payments for the authenticated user.

**Response:**
```json
{
  "payments": [
    {
      "id": "pay_123",
      "amount": 100.00,
      "currency": "USD",
      "status": "completed"
    }
  ]
}
```

#### Create Payment
```http
POST /payments
```

Creates a new payment transaction.

**Request Body:**
```json
{
  "amount": 100.00,
  "currency": "USD",
  "description": "Demo payment"
}
```

**Response:**
```json
{
  "id": "pay_124",
  "status": "pending",
  "created_at": "2025-09-24T14:43:00Z"
}
```

## Integration with BillPay Core

This API integrates with the [BillPay Core API](../../billpay-core-api) for:

- User authentication
- Transaction validation
- Payment processing
