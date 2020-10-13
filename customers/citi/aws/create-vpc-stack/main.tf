#####################################################################
##
##      Created 1/11/19 by slightly_more_obscure_admin. for create-vpc-stack
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

#########################################################
# Build network
#########################################################
resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "${var.network_name_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.network_name_prefix}-gateway"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags {
    Name = "${var.network_name_prefix}-subnet"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags {
    Name = "${var.network_name_prefix}-subnet2"
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1d"

  tags {
    Name = "${var.network_name_prefix}-subnet3"
  }
}

resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "${var.network_name_prefix}-route-table"
  }
}

resource "aws_route_table_association" "primary" {
  subnet_id      = "${aws_subnet.subnet1.id}"
  route_table_id = "${aws_route_table.default.id}"
}

resource "aws_route_table_association" "secondary" {
  subnet_id      = "${aws_subnet.subnet2.id}"
  route_table_id = "${aws_route_table.default.id}"
}

resource "aws_route_table_association" "tertiary" {
  subnet_id      = "${aws_subnet.subnet3.id}"
  route_table_id = "${aws_route_table.default.id}"
}

resource "aws_security_group" "application" {
  name        = "${var.network_name_prefix}-security-group-application"
  description = "Security group which applies to lamp application server"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9080
    to_port     = 9080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.network_name_prefix}-security-group-application"
  }
}

module "camtags" {
  source = "./Modules/camtags"
}
