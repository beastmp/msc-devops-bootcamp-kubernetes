aws_region = "us-east-1"

# Organization and naming
org_name        = "beastmpdevelopment"
team_id         = "devops-bootcamp"
service_name    = "cloudmart"
component_role  = "main"
environment     = "dev"

# EKS cluster information
kubernetes_namespace = "default"

# DynamoDB table names
dynamodb_tables = {
  products = "cloudmart-dev-ddb-products-table"
  orders = "cloudmart-dev-ddb-orders-table"
  tickets = "cloudmart-dev-ddb-tickets-table"
}
