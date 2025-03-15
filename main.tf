terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  required_version = ">= 1.2.0"
}

provider "aws" {}

# Get IAM role ARN from role name
data "aws_iam_role" "service_account_role" {
  name = local.service_account_role_name
}

# Get EKS cluster data
data "aws_eks_cluster" "cluster" {
  name = local.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = local.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

# ----------------------------------------------------------
# Local Variables for Naming Conventions
# ----------------------------------------------------------
locals {
  common_tags = {
    Organization = var.org_name
    Team         = var.team_id
    Service      = var.service_name
    Environment  = var.environment
    ManagedBy    = "terraform"
  }

  # Clean name components for consistent naming
  clean = {
    org     = lower(replace(replace(var.org_name, " ", "-"), "_", "-"))
    team    = lower(replace(replace(var.team_id, " ", "-"), "_", "-"))
    service = lower(replace(replace(var.service_name, " ", "-"), "_", "-"))
    env     = lower(replace(replace(var.environment, " ", "-"), "_", "-"))
  }

  # Naming formats
  levels = {
    service = "${local.clean.service}-${local.clean.env}"
    team    = "${local.clean.team}-${local.clean.service}-${local.clean.env}"
    org     = "${local.clean.org}-${local.clean.team}-${local.clean.service}-${local.clean.env}"
  }

  formats = {
    component_role = "${local.levels.service}-%s-%s-%s"    # format-module-component_role-component
    platform       = "${local.levels.service}-%s-%s-%s-%s" # format-module-component_role-platform-component
  }

  module_keys = {
    config    = "cfg"
    eks       = "eks"
  }

  # Component keys for naming
  component_keys = {
    cluster         = "cluster"
    service_account = "sa"
    config_map      = "cm"
    sa_role         = "role-sa"
  }

  eks_cluster_name          = format(local.formats.component_role, local.module_keys.eks, var.component_role, local.component_keys.cluster)
  service_account_name      = format(local.formats.component_role, local.module_keys.eks, var.component_role, local.component_keys.service_account)
  service_account_role_name = format(local.formats.component_role, local.module_keys.eks, var.component_role, local.component_keys.sa_role)
  config_map_name           = format(local.formats.component_role, local.module_keys.config, "tables", local.component_keys.config_map)
}

# Create service account with IAM role annotation
resource "kubernetes_service_account" "app_service_account" {
  metadata {
    name        = local.service_account_name
    namespace   = var.kubernetes_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.service_account_role.arn
    }
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "eks.amazonaws.com/iam-role"   = local.service_account_role_name
      "env"                          = var.environment
    }
  }
}

# Create ConfigMap for DynamoDB tables
resource "kubernetes_config_map" "dynamodb_config" {
  metadata {
    name      = local.config_map_name
    namespace = var.kubernetes_namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/part-of"    = var.service_name
      "env"                          = var.environment
    }
  }

  data = {
    DYNAMODB_PRODUCTS_TABLE = var.dynamodb_tables.products
    DYNAMODB_ORDERS_TABLE   = var.dynamodb_tables.orders
    DYNAMODB_TICKETS_TABLE  = var.dynamodb_tables.tickets
  }
}