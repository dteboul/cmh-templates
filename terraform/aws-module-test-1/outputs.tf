#####################################################################
##
##      Created 7/12/18 by ucdpadmin. for aws-module-test-1
##
#####################################################################

output "default_vpc_id" {
  value = "${module.vpc.default_vpc_id}"
  description = "The ID of the VPC"
}

output "public_route_table_ids" {
  value = "${module.vpc.public_route_table_ids}"
  description = "List of IDs of public route tables"
}

output "intra_subnets" {
  value = "${module.vpc.intra_subnets}"
  description = "List of IDs of intra subnets"
}

output "vpc_main_route_table_id" {
  value = "${module.vpc.vpc_main_route_table_id}"
  description = "The ID of the main route table associated with this VPC"
}

output "default_vpc_instance_tenancy" {
  value = "${module.vpc.default_vpc_instance_tenancy}"
  description = "Tenancy of instances spin up within VPC"
}

output "default_vpc_cidr_block" {
  value = "${module.vpc.default_vpc_cidr_block}"
  description = "The CIDR block of the VPC"
}

output "igw_id" {
  value = "${module.vpc.igw_id}"
  description = "The ID of the Internet Gateway"
}

output "elasticache_subnet_group_name" {
  value = "${module.vpc.elasticache_subnet_group_name}"
  description = "Name of elasticache subnet group"
}

output "elasticache_subnets_cidr_blocks" {
  value = "${module.vpc.elasticache_subnets_cidr_blocks}"
  description = "List of cidr_blocks of elasticache subnets"
}

output "database_subnets_cidr_blocks" {
  value = "${module.vpc.database_subnets_cidr_blocks}"
  description = "List of cidr_blocks of database subnets"
}

output "public_subnets" {
  value = "${module.vpc.public_subnets}"
  description = "List of IDs of public subnets"
}

output "vgw_id" {
  value = "${module.vpc.vgw_id}"
  description = "The ID of the VPN Gateway"
}

output "nat_public_ips" {
  value = "${module.vpc.nat_public_ips}"
  description = "List of public Elastic IPs created for AWS NAT Gateway"
}

output "public_subnets_cidr_blocks" {
  value = "${module.vpc.public_subnets_cidr_blocks}"
  description = "List of cidr_blocks of public subnets"
}

output "private_subnets_cidr_blocks" {
  value = "${module.vpc.private_subnets_cidr_blocks}"
  description = "List of cidr_blocks of private subnets"
}

output "default_vpc_default_security_group_id" {
  value = "${module.vpc.default_vpc_default_security_group_id}"
  description = "The ID of the security group created by default on VPC creation"
}

output "private_route_table_ids" {
  value = "${module.vpc.private_route_table_ids}"
  description = "List of IDs of private route tables"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets}"
  description = "List of IDs of private subnets"
}

output "vpc_enable_dns_support" {
  value = "${module.vpc.vpc_enable_dns_support}"
  description = "Whether or not the VPC has DNS support"
}

output "intra_route_table_ids" {
  value = "${module.vpc.intra_route_table_ids}"
  description = "List of IDs of intra route tables"
}

output "elasticache_subnets" {
  value = "${module.vpc.elasticache_subnets}"
  description = "List of IDs of elasticache subnets"
}

output "vpc_enable_dns_hostnames" {
  value = "${module.vpc.vpc_enable_dns_hostnames}"
  description = "Whether or not the VPC has DNS hostname support"
}

output "default_security_group_id" {
  value = "${module.vpc.default_security_group_id}"
  description = "The ID of the security group created by default on VPC creation"
}

output "vpc_cidr_block" {
  value = "${module.vpc.vpc_cidr_block}"
  description = "The CIDR block of the VPC"
}

output "default_vpc_enable_dns_support" {
  value = "${module.vpc.default_vpc_enable_dns_support}"
  description = "Whether or not the VPC has DNS support"
}

output "default_vpc_default_route_table_id" {
  value = "${module.vpc.default_vpc_default_route_table_id}"
  description = "The ID of the default route table"
}

output "vpc_endpoint_dynamodb_pl_id" {
  value = "${module.vpc.vpc_endpoint_dynamodb_pl_id}"
  description = "The prefix list for the DynamoDB VPC endpoint."
}

output "vpc_endpoint_s3_pl_id" {
  value = "${module.vpc.vpc_endpoint_s3_pl_id}"
  description = "The prefix list for the S3 VPC endpoint."
}

output "redshift_subnet_group" {
  value = "${module.vpc.redshift_subnet_group}"
  description = "ID of redshift subnet group"
}

output "redshift_subnets" {
  value = "${module.vpc.redshift_subnets}"
  description = "List of IDs of redshift subnets"
}

output "default_vpc_main_route_table_id" {
  value = "${module.vpc.default_vpc_main_route_table_id}"
  description = "The ID of the main route table associated with this VPC"
}

output "default_vpc_enable_dns_hostnames" {
  value = "${module.vpc.default_vpc_enable_dns_hostnames}"
  description = "Whether or not the VPC has DNS hostname support"
}

output "default_vpc_default_network_acl_id" {
  value = "${module.vpc.default_vpc_default_network_acl_id}"
  description = "The ID of the default network ACL"
}

output "nat_ids" {
  value = "${module.vpc.nat_ids}"
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
}

output "elasticache_subnet_group" {
  value = "${module.vpc.elasticache_subnet_group}"
  description = "ID of elasticache subnet group"
}

output "redshift_subnets_cidr_blocks" {
  value = "${module.vpc.redshift_subnets_cidr_blocks}"
  description = "List of cidr_blocks of redshift subnets"
}

output "database_subnets" {
  value = "${module.vpc.database_subnets}"
  description = "List of IDs of database subnets"
}

output "vpc_instance_tenancy" {
  value = "${module.vpc.vpc_instance_tenancy}"
  description = "Tenancy of instances spin up within VPC"
}

output "default_route_table_id" {
  value = "${module.vpc.default_route_table_id}"
  description = "The ID of the default route table"
}

output "default_network_acl_id" {
  value = "${module.vpc.default_network_acl_id}"
  description = "The ID of the default network ACL"
}

output "vpc_endpoint_dynamodb_id" {
  value = "${module.vpc.vpc_endpoint_dynamodb_id}"
  description = "The ID of VPC endpoint for DynamoDB"
}

output "vpc_endpoint_s3_id" {
  value = "${module.vpc.vpc_endpoint_s3_id}"
  description = "The ID of VPC endpoint for S3"
}

output "natgw_ids" {
  value = "${module.vpc.natgw_ids}"
  description = "List of NAT Gateway IDs"
}

output "intra_subnets_cidr_blocks" {
  value = "${module.vpc.intra_subnets_cidr_blocks}"
  description = "List of cidr_blocks of intra subnets"
}

output "database_subnet_group" {
  value = "${module.vpc.database_subnet_group}"
  description = "ID of database subnet group"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
  description = "The ID of the VPC"
}

output "this_security_group_id" {
  value = "${module.security_group.this_security_group_id}"
  description = "The ID of the security group"
}

output "this_security_group_description" {
  value = "${module.security_group.this_security_group_description}"
  description = "The description of the security group"
}

output "this_security_group_name" {
  value = "${module.security_group.this_security_group_name}"
  description = "The name of the security group"
}

output "this_security_group_owner_id" {
  value = "${module.security_group.this_security_group_owner_id}"
  description = "The owner ID"
}

output "this_security_group_vpc_id" {
  value = "${module.security_group.this_security_group_vpc_id}"
  description = "The VPC ID"
}

