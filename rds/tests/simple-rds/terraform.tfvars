aws_region   = "ap-southeast-1"
vpc_cidr     = "10.1.0.0/24"
project_name = "spacelift-rds-test"
subnets = {
  "data-subnet-1a" = {
    cidr_block              = "10.1.0.80/28"
    availability_zone       = "ap-southeast-1a"
    map_public_ip_on_launch = false
    name                    = "data-subnet-a"
    tier                    = "private-database"
  },
  "data-subnet-1b" = {
    cidr_block              = "10.1.0.96/28"
    availability_zone       = "ap-southeast-1b"
    map_public_ip_on_launch = false
    name                    = "data-subnet-b"
    tier                    = "private-database"
  }
}
db_allocated_storage = "10"
db_name              = "test123"
db_engine_type       = "postgres"
db_engine_version    = "16.3"
db_instance_class    = "db.t3.micro"
db_username          = "postgres"
db_password          = "postgres"
db_storage_type      = "gp2"