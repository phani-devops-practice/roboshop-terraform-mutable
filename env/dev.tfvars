// VPC
ENV                  = "dev"
PROJECT              = "roboshop"
VPC_CIDR             = "10.50.0.0/16"
PUBLIC_SUBNET_CIDR   = ["10.50.0.0/24", "10.50.1.0/24"]
PRIVATE_SUBNET_CIDR  = ["10.50.2.0/24", "10.50.3.0/24"]
AZ                   = ["us-east-1a", "us-east-1b"]
DEFAULT_VPC_ID       = "vpc-0ea60a247fdfddb3a"
DEFAULT_VPC_CIDR     = "172.31.0.0/16"
DEFAULT_VPC_RT       = "rtb-02eb032c1772c8036"