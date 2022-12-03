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

module "ELASTICACHE" {
  source             = "github.com/phani-devops-practice/tf-module-elasticache"
  ENV                = var.ENV
  PROJECT            = var.PROJECT
  ENGINE             = var.ELASTICACHE_ENGINE
  ENGINE_VERSION     = var.ELASTICACHE_ENGINE_VERSION
  INSTANCE_CLASS     = var.ELASTICACHE_INSTANCE_CLASS
  PG_FAMILY          = var.ELASTICACHE_PG_FAMILY
  PRIVATE_SUBNET_IDS = module.VPC.PRIVATE_SUBNET_IDS
  ALLOW_SG_CIDR      = module.VPC.PRIVATE_SUBNETS_CIDR
  VPC_ID             = module.VPC.VPC_ID
  PORT               = var.ELASTICACHE_PORT
  NUMBER_OF_NODES    = var.ELASTICACHE_NUMBER_OF_NODES
}

module "RABBITMQ" {
  source               = "github.com/phani-devops-practice/tf-module-rabbitmq"
  ENV                  = var.ENV
  PROJECT              = var.PROJECT
  INSTANCE_TYPE        = var.RABBITMQ_INSTANCE_TYPE
  PRIVATE_SUBNET_IDS   = module.VPC.PRIVATE_SUBNET_IDS
  ALLOW_SG_CIDR        = module.VPC.PRIVATE_SUBNETS_CIDR
  VPC_ID               = module.VPC.VPC_ID
  PORT                 = var.RABBITMQ_PORT
  WORKSTATION_IP       = var.WORKSTATION_IP
}

module "LB" {
  source             = "github.com/phani-devops-practice/tf-module-mutable-lb"
  ENV                = var.ENV
  PROJECT            = var.PROJECT
  PUBLIC_SUBNET_IDS  = module.VPC.PUBLIC_SUBNET_IDS
  PRIVATE_SUBNET_IDS = module.VPC.PRIVATE_SUBNET_IDS
  ALLOW_SG_CIDR      = module.VPC.PRIVATE_SUBNETS_CIDR
  VPC_ID             = module.VPC.VPC_ID
}

module "FRONTEND" {
  source               = "github.com/phani-devops-practice/tf-module-mutable-app"
  ENV                  = var.ENV
  PRIVATE_SUBNET_IDS   = module.VPC.PRIVATE_SUBNET_IDS
  ALLOW_SG_CIDR        = module.VPC.PRIVATE_SUBNETS_CIDR
  VPC_ID               = module.VPC.VPC_ID
  PORT                 = 80
  WORKSTATION_IP       = var.WORKSTATION_IP
  COMPONENT            = "frontend"
  INSTANCE_TYPE        = "t3.micro"
  INSTANCE_COUNT       = var.INSTANCE_COUNT["FRONTEND"]["COUNT"]
  LB_ARN               = module.LB.PUBLIC_LB_ARN
}