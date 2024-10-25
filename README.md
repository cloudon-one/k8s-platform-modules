# Kubernetes Platform Stack

This repository contains the Terragrunt configurations for our Kubernetes platform stack, providing a comprehensive set of infrastructure components for running a production-ready Kubernetes cluster.

## Architecture

The platform stack consists of the following components:

### Core Infrastructure
- **cert-manager**: Certificate management and issuance
- **external-dns**: Automated DNS management
- **external-secrets**: External secrets management
- **kong-ingress**: API Gateway and Ingress controller
- **karpenter**: Kubernetes node autoscaling

### Observability Stack
- **jaeger**: Distributed tracing
- **loki-stack**: Log aggregation
- **kubecost**: Cost monitoring and optimization
- **istio**: Service mesh with observability features

### Platform Tools
- **argocd**: GitOps continuous delivery
- **airflow**: Workflow orchestration

## Repository Structure

```
.
├── LICENSE
├── README.md
├── common.hcl                  # Common Terragrunt configurations
├── platform_vars.yaml          # Platform-wide variables
├── terragrunt.hcl              # Root Terragrunt configuration
│
├── airflow/                    # Apache Airflow deployment
├── argocd/                     # Argo CD deployment
├── cert-manager/               # Certificate management
├── external-dns/               # DNS automation
├── external-secrets/           # External secrets management
├── istio/                      # Service mesh
├── jaeger/                     # Distributed tracing
├── karpenter/                  # Node autoscaling
├── kong-ingress/               # API Gateway
├── kubecost/                   # Cost monitoring
└── loki-stack/                 # Logging stack
```

## Prerequisites

- Terraform >= 1.5.0
- Terragrunt >= 0.60.0
- kubectl configured with cluster access
- AWS CLI configured (if using AWS)

## Getting Started

1. Clone the repository:
```bash
git clone https://github.com/your-org/platform-stack.git
cd platform-stack
```

2. Configure your environment in `platform_vars.yaml`:
```yaml
common:
  environment: "dev"
  domain: "example.com"
  aws_account_id: "123456789012"
  aws_region: "us-west-2"
```

3. Initialize and apply the stack:
```bash
# Initialize all modules
terragrunt run-all init

# Plan all changes
terragrunt run-all plan

# Apply all changes
terragrunt run-all apply
```

## Component Deployment

### Individual Components

Each component can be deployed independently:

```bash
cd <component-directory>
terragrunt plan
terragrunt apply
```

### Component Dependencies

Components are deployed in the following order:

1. Core Infrastructure
   ```bash
   cd cert-manager && terragrunt apply
   cd external-dns && terragrunt apply
   cd external-secrets && terragrunt apply
   cd kong-ingress && terragrunt apply
   cd karpenter && terragrunt apply
   ```

2. Observability Stack
   ```bash
   cd istio && terragrunt apply
   cd jaeger && terragrunt apply
   cd loki-stack && terragrunt apply
   cd kubecost && terragrunt apply
   ```

3. Platform Tools
   ```bash
   cd argocd && terragrunt apply
   cd airflow && terragrunt apply
   ```

## Configuration

### Common Configuration

Common variables are defined in `common.hcl`:
- Environment settings
- AWS configuration
- Cluster configuration
- Common tags

### Component Configuration

Each component's configuration is defined in its respective `terragrunt.hcl` file and can be customized using:
- Component-specific variables
- Environment overrides
- Resource configurations

## Environment Management

The stack supports multiple environments through configuration:

```bash
# Development
export ENV=dev
terragrunt run-all apply

# Staging
export ENV=staging
terragrunt run-all apply

# Production
export ENV=prod
terragrunt run-all apply
```

## Monitoring and Operations

### Access Points

- Grafana: `grafana.${environment}.${domain}`
- Jaeger: `jaeger.${environment}.${domain}`
- ArgoCD: `argocd.${environment}.${domain}`
- Airflow: `airflow.${environment}.${domain}`

### Health Checks

Monitor component health:
```bash
kubectl get pods -A
kubectl get events -A
```

## Troubleshooting

Common issues and solutions:

1. **Terragrunt Plan Failures**
   - Verify AWS credentials
   - Check cluster connectivity
   - Validate configuration values

2. **Component Deployment Issues**
   - Check component logs
   - Verify dependencies are running
   - Validate resource requests/limits

3. **Networking Issues**
   - Verify DNS configuration
   - Check ingress controller logs
   - Validate service mesh configuration

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Create a pull request

## Security

- All secrets are managed through external-secrets
- TLS certificates are managed by cert-manager
- Network policies are enforced through Istio
- Regular security scanning with built-in tools

## Maintenance

### Regular Tasks

- Update component versions
- Review resource utilization
- Monitor costs with Kubecost
- Backup critical configurations

### Version Updates

Update component versions in respective `terragrunt.hcl` files:
```hcl
inputs = {
  chart_version = "x.y.z"
}
```

## Support

For issues and support:
1. Check existing issues
2. Create a new issue with:
   - Environment details
   - Error messages
   - Steps to reproduce

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.