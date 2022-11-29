// VPC
variable "ENV" {}
variable "PROJECT" {}
variable "VPC_CIDR" {}
variable "PUBLIC_SUBNET_CIDR" {}
variable "PRIVATE_SUBNET_CIDR" {}
variable "AZ" {}
variable "DEFAULT_VPC_ID" {}
variable "DEFAULT_VPC_CIDR" {}
variable "DEFAULT_VPC_RT" {}

// RDS
variable "RDS_ENGINE" {}
variable "RDS_ENGINE_VERSION" {}
variable "RDS_INSTANCE_CLASS" {}
variable "RDS_PG_FAMILY" {}
variable "PRIVATE_SUBNET_IDS" {}
variable "RDS_PORT" {}
variable "ALLOW_SG_CIDR" {}


