terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
#  access_key = "${var.access_key}"
#  secret_key = "${var.secret_key}"
#  region     = "us-east-1"
  version = "~> 1.8"
}


data "aws_subnet" "subnet" {
  vpc_id = "vpc-6c51be09"
  availability_zone = "us-east-1a"
}
