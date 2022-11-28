module "VPC" {
  source                = "github.com/phani-devops-practice/tf-module-vpc"
  PROJECT               = var.PROJECT
  ENV                   = var.ENV
  VPC_CIDR              = var.VPC_CIDR
  PUBLIC_SUBNET_CIDR   = var.PUBLIC_SUBNET_CIDR
  PRIVATE_SUBNET_CIDR  = var.PRIVATE_SUBNET_CIDR
  AZ                    = var.AZ
}


