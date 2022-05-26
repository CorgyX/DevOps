terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
  region = var.aws_region
  }

}

resource "aws_vpc" "main" {
  variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

tags = {
  Name = "${aws_vpc.main}-aws_vpc.main.id"
}

locals {
  public_cidr  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_cidr = ["10.0.2.0/24", "10.0.3.0/24"]
}

resource "aws_subnet" "public" {
  count = length(local.public_cidr) 

  vpc_id     = aws_vpc.main.id
  cidr_block = local.public_cidr[count.index]

  tags = {
    Name = "public${count.index}"
  }
}


resource "aws_subnet" "private" {
  count = length(local.private_cidr)

  vpc_id     = aws_vpc.main.id
  cidr_block = local.private_cidr[count.index]

  tags = {
    Name = "private${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main${aws_vpc.main.id}"
  }
}

resource "aws_eip" "nat" {
# here if I replace count, I am not sure with what value have to be in lenght().
  count = lenght(aws_eip.nat)

  vpc = true
}

resource "aws_nat_gateway" "main" {
  count = lenght(aws_subnet.public)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "main${count.index}"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public${aws_internet_gateway.main.id}"
  }
}

resource "aws_route_table" "private" {
  count = lenght(aws_nat_gateway.main)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "private${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count = lenght(aws_route_table)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
  
  tags = {
    Name = "public${count.index}"
  }
  
}

resource "aws_route_table_association" "private" {
  count = lenght(aws_route_table.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
  
   tags = {
    Name = "private${count.index}"
  }
  
}
