module "VPC" {
  source                = "github.com/phani-devops-practice/tf-module-vpc"
  ENV                   = var.ENV
  PROJECT               = var.PROJECT
  VPC_CIDR              = var.VPC_CIDR
  PUBLIC_SUBNETS_CIDR   = var.PUBLIC_SUBNETS_CIDR
  PRIVATE_SUBNETS_CIDR  = var.PRIVATE_SUBNETS_CIDR
  AZ                    = var.AZ
  DEFAULT_VPC_ID        = var.DEFAULT_VPC_ID
  DEFAULT_VPC_CIDR      = var.DEFAULT_VPC_CIDR
  DEFAULT_VPC_RT        = var.DEFAULT_VPC_RT
}

module "RDS" {
  source              = "github.com/phani-devops-practice/tf-module-rds"
  ENV                 = var.ENV
  PROJECT             = var.PROJECT
  ENGINE              = var.RDS_ENGINE
  ENGINE_VERSION      = var.RDS_ENGINE_VERSION
  RDS_INSTANCE_CLASS  = var.RDS_INSTANCE_CLASS
  PG_FAMILY           = var.RDS_PG_FAMILY
  PRIVATE_SUBNET_IDS  = module.VPC.PRIVATE_SUBNET_IDS
  ALLOW_SG_CIDR       = module.VPC.PRIVATE_SUBNETS_CIDR
  VPC_ID              = module.VPC.VPC_ID
  RDS_PORT            = var.RDS_PORT
}

module "DOCDB" {
  source             = "github.com/phani-devops-practice/tf-module-docdb"
  ENV                = var.ENV
  PROJECT            = var.PROJECT
  ENGINE             = var.DOCDB_ENGINE
  ENGINE_VERSION     = var.DOCDB_ENGINE_VERSION
  INSTANCE_CLASS     = var.DOCDB_INSTANCE_CLASS
  PG_FAMILY          = var.DOCDB_PG_FAMILY
  PRIVATE_SUBNET_IDS = module.VPC.PRIVATE_SUBNET_IDS
  ALLOW_SG_CIDR      = module.VPC.PRIVATE_SUBNETS_CIDR
  VPC_ID             = module.VPC.VPC_ID
  PORT               = var.DOCDB_PORT
  NUMBER_OF_NODES    = var.DOCDB_NUMBER_OF_NODES
}