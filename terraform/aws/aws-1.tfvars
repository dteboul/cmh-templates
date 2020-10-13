# Manually generated TFVars file

# Shared
vpc_id = "vpc-6c51be09"
sec_group = "ucdev_secgroup_nva"
availability_zone = "us-east-1d"

# Web node
jke-web_ami = "ami-06c4cb11"
jke-web_key_name = "ucdev-aws-nva"
jke-web_aws_instance_type = "t2.medium"
jke-web_name = "jke-web-tf"

# DB node
jke-db_ami = "ami-06c4cb11"
jke-db_key_name = "ucdev-aws-nva"
jke-db_aws_instance_type = "t2.medium"
jke-db_name = "jke-db-tf"

# UCD
ucd_password = "ec11ipse"
ucd_server_url = "http://icdemo3.cloudy-demos.com:9080"
agent_name = "cmh-test-agent"
ucd_user = "admin"
