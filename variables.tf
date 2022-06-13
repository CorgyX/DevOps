variable "env_code" {
  type        = string
  description = "Initial form of environment resources "
}

variable "environment" {
  description = "The environment the single project belongs to"
  default     = "dev"
}

variable "aws_region" {
  description = "aws_region"
  default     = "us-east-1"
}

variable "aws_vpc_main_cidr_block" {
  description = "aws_vpc_main_cidr_block"
  default     = "10.0.0.0/16"
}

variable "aws_subnet_public_cidr_block" {
  default = "local.public_cidr[count.index]"

}

variable "aws_subnet_private_cidr_block" {
  default     = "local.private_cidr[count.index]"
  description = "aws_subnet_private_cidr_block"

}

variable "aws_eip_nat" {
  default = "aws_eip_nat"
  
}

variable "aws_internet_gateway_main" {
  description = "aws_internet_gateway_main"
  default     = ""

}

variable "aws_route_table_public" {
  default = "aws_route_table_public"
}

variable "aws_route_table_private" {
  default = "aws_route_table_private"
}


variable "aws_route_table_association_public" {
  default = "aws_route_table_association_public"
}

variable "aws_route_table_association_private" {
  default = "aws_route_table_association_private"
}
