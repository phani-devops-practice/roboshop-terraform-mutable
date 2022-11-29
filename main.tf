module "VPC" {
  source               = "github.com/phani-devops-practice/tf-module-vpc"
  ENV                  = var.ENV
  PROJECT              = var.PROJECT
  VPC_CIDR             = var.VPC_CIDR
  PUBLIC_SUBNET_CIDR   = var.PUBLIC_SUBNET_CIDR
  PRIVATE_SUBNET_CIDR  = var.PRIVATE_SUBNET_CIDR
  AZ                   = var.AZ
  DEFAULT_VPC_ID       = var.DEFAULT_VPC_ID
  DEFAULT_VPC_CIDR     = var.DEFAULT_VPC_CIDR
  DEFAULT_VPC_RT       = var.DEFAULT_VPC_RT
}

module "RDS" {
  source               = "github.com/phani-devops-practice/tf-module-rds"
  PROJECT              = var.PROJECT
  ENV                  = var.ENV
  VPC_ID               = module.VPC.VPC_ID
  ENGINE               = var.RDS_ENGINE
  ENGINE_VERSION       = var.RDS_ENGINE_VERSION
  RDS_INSTANCE_CLASS   = var.RDS_INSTANCE_CLASS
  PG_FAMILY            = var.RDS_PG_FAMILY
  PRIVATE_SUBNET_IDS   = module.VPC.PRIVATE_SUBNET_IDS
  RDS_PORT             = var.RDS_PORT
  ALLOW_SG_CIDR        = module.VPC.PRIVATE_SUBNET_CIDR
}




