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
