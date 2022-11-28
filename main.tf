module "VPC" {
  source      = "github.com/phani-devops-practice/tf-module-vpc"
  PROJECT     = var.PROJECT
  ENV         = var.ENV
  VPC_CIDR    = var.VPC_CIDR
}

