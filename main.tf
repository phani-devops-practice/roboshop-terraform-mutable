module "VPC" {
  source              = "github.com/phani-devops-practice/tf-module-vpc"
  PROJECT             = var.PROJECT
  ENV                 = var.ENV
  VPC_CIDR            = var.VPC_CIDR
  PRIVATE_SUBNET_CIDR = var.PRIVATE_SUBNET_CIDR
  PUBLIC_SUBNET_CIDR  = var.PUBLIC_SUBNET_CIDR
  AZ                  = var.AZ
  DEFAULT_VPC_ID        = var.DEFAULT_VPC_ID
  DEFAULT_VPC_CIDR      = var.DEFAULT_VPC_CIDR
  DEFAULT_VPC_RT        = var.DEFAULT_VPC_RT
}

