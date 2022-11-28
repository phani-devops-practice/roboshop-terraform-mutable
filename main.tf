module "VPC" {
  source                = "github.com/phani-devops-practice/tf-module-vpc"
  PROJECT               = var.PROJECT
  ENV                   = var.ENV
  VPC_CIDR              = var.VPC_CIDR
  PUBLIC_SUBNET_CIDR   = var.PUBLIC_SUBNET_CIDR
  PRIVATE_SUBNET_CIDR  = var.PRIVATE_SUBNET_CIDR
  AZ                    = var.AZ
  DEFAULT_VPC_ID        = var.DEFAULT_VPC_ID
  DEFAULT_VPC_CIDR      = var.DEFAULT_VPC_CIDR
  DEFAULT_VPC_RT        = var.DEFAULT_VPC_RT
  PUBLIC_ZONE_ID        = var.PUBLIC_ZONE_ID
  PRIVATE_ZONE_ID       = var.PRIVATE_ZONE_ID
}

module "RDS" {
  source             = "github.com/phani-devops-practice/tf-module-rds"
  PROJECT            = var.PROJECT
  ENV                = var.ENV
  VPC_ID             = module.VPC.VPC_ID
  PRIVATE_SUBNET_IDS = module.VPC.PRIVATE_SUBNET_IDS
  ENGINE             = var.RDS_ENGINE
  ENGINE_VERSION     = var.RDS_ENGINE_VERSION
  RDS_INSTANCE_CLASS = var.RDS_INSTANCE_CLASS
  PG_FAMILY          = var.RDS_PG_FAMILY
  ALLOW_SG_CIDR      = module.VPC.PRIVATE_SUBNET_CIDR
  RDS_PORT           = var.RDS_PORT
}

module "DOCDB" {
  source              = "github.com/phani-devops-practice/tf-module-docdb"
  ENV                 = var.ENV
  PROJECT             = var.PROJECT
  ENGINE              = var.DOCDB_ENGINE
  ENGINE_VERSION      = var.DOCDB_ENGINE_VERSION
  INSTANCE_CLASS      = var.DOCDB_INSTANCE_CLASS
  PG_FAMILY           = var.DOCDB_PG_FAMILY
  PRIVATE_SUBNET_IDS  = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID              = module.VPC.VPC_ID
  PORT                = var.DOCDB_PORT
  ALLOW_SG_CIDR       = module.VPC.PRIVATE_SUBNET_CIDR
  NUMBER_OF_NODES     = var.DOCDB_NUMBER_OF_NODES
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
  VPC_ID             = module.VPC.VPC_ID
  PORT               = var.ELASTICACHE_PORT
  ALLOW_SG_CIDR      = module.VPC.PRIVATE_SUBNET_CIDR
  NUMBER_OF_NODES    = var.ELASTICACHE_NUMBER_OF_NODES
}

module "RABBITMQ" {
  source             = "github.com/phani-devops-practice/tf-module-rabbitmq"
  ENV                = var.ENV
  PROJECT            = var.PROJECT
  PRIVATE_SUBNET_IDS = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID             = module.VPC.VPC_ID
  PORT               = var.RABBITMQ_PORT
  ALLOW_SG_CIDR      = module.VPC.PRIVATE_SUBNET_CIDR
  INSTANCE_TYPE      = var.RABBITMQ_INSTANCE_TYPE
  WORKSTATION_IP     = var.WORKSTATION_IP
}

module "LB" {
  source             = "github.com/phani-devops-practice/tf-module-mutable-lb"
  ENV                = var.ENV
  PROJECT            = var.PROJECT
  PRIVATE_SUBNET_IDS = module.VPC.PRIVATE_SUBNET_IDS
  PUBLIC_SUBNET_IDS  = module.VPC.PUBLIC_SUBNET_IDS
  VPC_ID             = module.VPC.VPC_ID
  ALLOW_SG_CIDR      = module.VPC.PRIVATE_SUBNET_CIDR
  PUBLIC_ZONE_ID     = var.PUBLIC_ZONE_ID
  PRIVATE_ZONE_ID    = var.PRIVATE_ZONE_ID
}

module "FRONTEND" {
  source               = "github.com/phani-devops-practice/tf-module-mutable-app"
  ENV                  = var.ENV
  PROJECT              = var.PROJECT
  PRIVATE_SUBNET_IDS   = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID               = module.VPC.VPC_ID
  ALLOW_SG_CIDR        = module.VPC.PRIVATE_SUBNET_CIDR
  PORT                 = 80
  COMPONENT            = "frontend"
  INSTANCE_TYPE        = "t2.micro"
  WORKSTATION_IP       = var.WORKSTATION_IP
  INSTANCE_COUNT       = var.INSTANCE_COUNT["FRONTEND"]["COUNT"]
  LB_ARN               = module.LB.PUBLIC_LB_ARN
  LB_TYPE              = "public"
  PRIVATE_LB_DNS       = module.LB.PRIVATE_LB_DNS
  PRIVATE_ZONE_ID      = var.PRIVATE_ZONE_ID
  PRIVATE_LISTENER_ARN = module.LB.PRIVATE_LISTENER_ARN
}

module "CATALOGUE" {
  source               = "github.com/phani-devops-practice/tf-module-mutable-app"
  ENV                  = var.ENV
  PROJECT              = var.PROJECT
  PRIVATE_SUBNET_IDS   = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID               = module.VPC.VPC_ID
  ALLOW_SG_CIDR        = module.VPC.PRIVATE_SUBNET_CIDR
  PORT                 = 8080
  COMPONENT            = "catalogue"
  INSTANCE_TYPE        = "t2.micro"
  WORKSTATION_IP       = var.WORKSTATION_IP
  INSTANCE_COUNT       = var.INSTANCE_COUNT["CATALOGUE"]["COUNT"]
  LB_ARN               = module.LB.PRIVATE_LB_ARN
  LB_TYPE              = "private"
  PRIVATE_LB_DNS       = module.LB.PRIVATE_LB_DNS
  PRIVATE_ZONE_ID      = var.PRIVATE_ZONE_ID
  PRIVATE_LISTENER_ARN = module.LB.PRIVATE_LISTENER_ARN
}

module "USER" {
  source               = "github.com/phani-devops-practice/tf-module-mutable-app"
  ENV                  = var.ENV
  PROJECT              = var.PROJECT
  PRIVATE_SUBNET_IDS   = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID               = module.VPC.VPC_ID
  ALLOW_SG_CIDR        = module.VPC.PRIVATE_SUBNET_CIDR
  PORT                 = 8080
  COMPONENT            = "user"
  INSTANCE_TYPE        = "t2.micro"
  WORKSTATION_IP       = var.WORKSTATION_IP
  INSTANCE_COUNT       = var.INSTANCE_COUNT["USER"]["COUNT"]
  LB_ARN               = module.LB.PRIVATE_LB_ARN
  LB_TYPE              = "private"
  PRIVATE_LB_DNS       = module.LB.PRIVATE_LB_DNS
  PRIVATE_ZONE_ID      = var.PRIVATE_ZONE_ID
  PRIVATE_LISTENER_ARN = module.LB.PRIVATE_LISTENER_ARN
}

module "CART" {
  source               = "github.com/phani-devops-practice/tf-module-mutable-app"
  ENV                  = var.ENV
  PROJECT              = var.PROJECT
  PRIVATE_SUBNET_IDS   = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID               = module.VPC.VPC_ID
  ALLOW_SG_CIDR        = module.VPC.PRIVATE_SUBNET_CIDR
  PORT                 = 8080
  COMPONENT            = "cart"
  INSTANCE_TYPE        = "t2.micro"
  WORKSTATION_IP       = var.WORKSTATION_IP
  INSTANCE_COUNT       = var.INSTANCE_COUNT["CART"]["COUNT"]
  LB_ARN               = module.LB.PRIVATE_LB_ARN
  LB_TYPE              = "private"
  PRIVATE_LB_DNS       = module.LB.PRIVATE_LB_DNS
  PRIVATE_ZONE_ID      = var.PRIVATE_ZONE_ID
  PRIVATE_LISTENER_ARN = module.LB.PRIVATE_LISTENER_ARN
}

module "SHIPPING" {
  source               = "github.com/phani-devops-practice/tf-module-mutable-app"
  ENV                  = var.ENV
  PROJECT              = var.PROJECT
  PRIVATE_SUBNET_IDS   = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID               = module.VPC.VPC_ID
  ALLOW_SG_CIDR        = module.VPC.PRIVATE_SUBNET_CIDR
  PORT                 = 8080
  COMPONENT            = "shipping"
  INSTANCE_TYPE        = "t2.micro"
  WORKSTATION_IP       = var.WORKSTATION_IP
  INSTANCE_COUNT       = var.INSTANCE_COUNT["SHIPPING"]["COUNT"]
  LB_ARN               = module.LB.PRIVATE_LB_ARN
  LB_TYPE              = "private"
  PRIVATE_LB_DNS       = module.LB.PRIVATE_LB_DNS
  PRIVATE_ZONE_ID      = var.PRIVATE_ZONE_ID
  PRIVATE_LISTENER_ARN = module.LB.PRIVATE_LISTENER_ARN
}

module "PAYMENT" {
  source               = "github.com/phani-devops-practice/tf-module-mutable-app"
  ENV                  = var.ENV
  PROJECT              = var.PROJECT
  PRIVATE_SUBNET_IDS   = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID               = module.VPC.VPC_ID
  ALLOW_SG_CIDR        = module.VPC.PRIVATE_SUBNET_CIDR
  PORT                 = 8080
  COMPONENT            = "payment"
  INSTANCE_TYPE        = "t2.micro"
  WORKSTATION_IP       = var.WORKSTATION_IP
  INSTANCE_COUNT       = var.INSTANCE_COUNT["PAYMENT"]["COUNT"]
  LB_ARN               = module.LB.PRIVATE_LB_ARN
  LB_TYPE              = "private"
  PRIVATE_LB_DNS       = module.LB.PRIVATE_LB_DNS
  PRIVATE_ZONE_ID      = var.PRIVATE_ZONE_ID
  PRIVATE_LISTENER_ARN = module.LB.PRIVATE_LISTENER_ARN
}

module "DISPATCH" {
  source               = "github.com/phani-devops-practice/tf-module-mutable-app"
  ENV                  = var.ENV
  PROJECT              = var.PROJECT
  PRIVATE_SUBNET_IDS   = module.VPC.PRIVATE_SUBNET_IDS
  VPC_ID               = module.VPC.VPC_ID
  ALLOW_SG_CIDR        = module.VPC.PRIVATE_SUBNET_CIDR
  PORT                 = 8080
  COMPONENT            = "dispatch"
  INSTANCE_TYPE        = "t2.micro"
  WORKSTATION_IP       = var.WORKSTATION_IP
  INSTANCE_COUNT       = var.INSTANCE_COUNT["DISPATCH"]["COUNT"]
  LB_ARN               = module.LB.PRIVATE_LB_ARN
  LB_TYPE              = "private"
  PRIVATE_LB_DNS       = module.LB.PRIVATE_LB_DNS
  PRIVATE_ZONE_ID      = var.PRIVATE_ZONE_ID
  PRIVATE_LISTENER_ARN = module.LB.PRIVATE_LISTENER_ARN
}
