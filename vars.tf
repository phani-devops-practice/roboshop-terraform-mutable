//VPC
variable "PROJECT" {}
variable "ENV" {}
variable "VPC_CIDR" {}
variable "PRIVATE_SUBNET_CIDR" {}
variable "PUBLIC_SUBNET_CIDR" {}
variable "AZ" {}
variable "DEFAULT_VPC_ID" {}
variable "DEFAULT_VPC_CIDR" {}
variable "DEFAULT_VPC_RT" {}

// RDS
variable "RDS_ENGINE" {}
variable "RDS_ENGINE_VERSION" {}
variable "RDS_INSTANCE_CLASS" {}
variable "RDS_PG_FAMILY" {}
variable "RDS_PORT" {}

// DOCDB
variable "DOCDB_ENGINE" {}
variable "DOCDB_ENGINE_VERSION" {}
variable "DOCDB_INSTANCE_CLASS" {}
variable "DOCDB_PG_FAMILY" {}
variable "DOCDB_PORT" {}
variable "DOCDB_NUMBER_OF_NODES" {}

