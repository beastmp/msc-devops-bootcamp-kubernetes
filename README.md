# DevOps Bootcamp - Kubernetes

This repository contains the Kubernetes deployment configurations and Terraform automation for the CloudMart e-commerce application as part of the DevOps Bootcamp project. It manages the Kubernetes resources required to deploy and run the CloudMart application in a Kubernetes environment.

## Overview

The repository provides infrastructure as code (IaC) for Kubernetes deployments using Terraform. It configures the necessary Kubernetes resources such as service accounts, config maps, and connections to AWS services like DynamoDB. This allows for consistent, repeatable deployments across different environments.

## Project Structure

```
msc-devops-bootcamp-kubernetes/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Input variable definitions
├── outputs.tf              # Output definitions
├── terraform.auto.tfvars   # Pre-set variable values
└── README.md               # Project documentation
```

## Features

- Terraform-managed Kubernetes resources
- AWS EKS cluster integration
- Service account configuration with IAM roles
- ConfigMap management for CloudMart DynamoDB tables
- Environment-specific configuration
- Standardized naming conventions

## Prerequisites

- Terraform (v1.2.0 or later)
- AWS CLI configured with appropriate permissions
- kubectl installed and configured
- An existing EKS cluster created by the infrastructure repository
- Access to the AWS account where resources are deployed

## Required AWS Resources

The following resources should be pre-created by the infrastructure repository:

1. EKS cluster named according to the format: `cloudmart-{env}-eks-main-cluster`
2. IAM role for service account with format: `cloudmart-{env}-eks-main-role-sa`
3. DynamoDB tables for products, orders, and tickets

## Configuration

The deployment is configured through Terraform variables:

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `aws_region` | AWS region for resources | `us-east-1` |
| `kubernetes_namespace` | Kubernetes namespace for deployment | `default` |
| `service_name` | Service name for resource naming | `cloudmart` |
| `component_role` | Component role for naming | `main` |
| `environment` | Environment name (dev, test, prod) | `dev` |
| `dynamodb_tables` | DynamoDB table names object | See tfvars file |
| `org_name` | Organization name | `beastmpdevelopment` |
| `team_id` | Team identifier | `devops-bootcamp` |

To customize the deployment, modify the `terraform.auto.tfvars` file.

## Usage

### Initialize Terraform

```bash
terraform init
```

### Plan Deployment

```bash
terraform plan
```

### Apply Configuration

```bash
terraform apply
```

### Destroy Resources

```bash
terraform destroy
```

## Resources Created

- **Kubernetes Service Account**: Creates a service account with the name format `cloudmart-{env}-eks-main-sa`, linked to an IAM role for AWS resource access
- **Kubernetes ConfigMap**: Creates a config map named `cloudmart-tables-config` containing DynamoDB table names for the application to use

## Deployment Process

1. The Terraform configuration connects to the EKS cluster using AWS credentials
2. It retrieves information about the cluster and IAM roles
3. It creates Kubernetes resources with appropriate annotations for IAM role association
4. The ConfigMap provides environment-specific configuration to the deployed applications

## Integration with CloudMart Application

This repository works in conjunction with the following repositories:

- [DevOps Bootcamp - Infrastructure](https://github.com/beastmp/msc-devops-bootcamp-infrastructure): Creates the underlying AWS resources
- [DevOps Bootcamp - Frontend](https://github.com/beastmp/msc-devops-bootcamp-frontend): React frontend application
- [DevOps Bootcamp - Backend](https://github.com/beastmp/msc-devops-bootcamp-backend): Node.js backend services

The deployment process typically follows this order:
1. Infrastructure (EKS cluster, IAM roles, DynamoDB)
2. Kubernetes resources (this repository)
3. Backend deployment
4. Frontend deployment

## Troubleshooting

### Common Issues

1. **EKS cluster not found**
   - Ensure the infrastructure repository has created the cluster
   - Check AWS credentials and region settings

2. **Service account creation failure**
   - Verify that the IAM role exists with the expected name
   - Check IAM permissions for the role

3. **ConfigMap not accessible by pods**
   - Ensure pods are in the same namespace as the ConfigMap
   - Check RBAC settings for service account

### Debugging Commands

```bash
# Check service account
kubectl get serviceaccount cloudmart-dev-eks-main-sa -n default -o yaml

# Check ConfigMap
kubectl get configmap cloudmart-tables-config -n default -o yaml

# View Kubernetes events
kubectl get events -n default
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please contact [beastmpdevelopment@gmail.com](mailto:beastmpdevelopment@gmail.com)

## Related Repositories

- [DevOps Bootcamp - Infrastructure](https://github.com/beastmp/msc-devops-bootcamp-infrastructure)
- [DevOps Bootcamp - Frontend](https://github.com/beastmp/msc-devops-bootcamp-frontend)
- [DevOps Bootcamp - Backend](https://github.com/beastmp/msc-devops-bootcamp-backend)
