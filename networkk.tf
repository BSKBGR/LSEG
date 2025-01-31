## -- CREATING VPC
resource "aws_vpc" "sps-vpc" {
    cidr_block = var.vpc_cidr_block # variable vpc_cidr_block{}
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_tag}-VPC" # variable var.vpc_tag{}
    }
}
 
## -- CREATING PUBLIC-SUBNET-1
resource "aws_subnet" "public-subnet1" {
    vpc_id = aws_vpc.sps-vpc.id
    cidr_block = var.public_sub_cidr_block1 # variable public_sub_cidr_block{}
    availability_zone = var.availability_zone_pub1 # variable availability_zone{}
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.vpc_tag}-VPC-PUB1-SUB"
    }
}
 
## -- CREATING PUBLIC-SUBNET-2
resource "aws_subnet" "public-subnet2" {
    vpc_id = aws_vpc.sps-vpc.id
    cidr_block = var.public_sub_cidr_block2 # variable public_sub_cidr_block{}
    availability_zone = var.availability_zone_pub2 # variable availability_zone{}
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.vpc_tag}-VPC-PUB2-SUB"
    }
}
 
## -- CREATING PRIVATE-SUBNET
resource "aws_subnet" "private-subnet" {
    vpc_id = aws_vpc.sps-vpc.id
    cidr_block = var.private_sub_cidr_block # variable private_sub_cidr_block{}
    availability_zone = var.availability_zone_priv
    tags = {
        Name = "${var.vpc_tag}-VPC-PRIV-SUB"
    }
}
 
## -- CREATING INTERNET GATEWAY AND ADDING IT TO MAIN VPC
resource "aws_internet_gateway" "sps-igw" {
    vpc_id = aws_vpc.sps-vpc.id
    tags = {
        Name = "${var.vpc_tag}-VPC-IGW"
    }
}
 
## -- CREATING ROUTE TABLE , ROUTE TABLE MUST BE CREATED FIRST
resource "aws_route_table" "sps-main-rt" {
    vpc_id = aws_vpc.sps-vpc.id
    tags = {
        Name = "${var.vpc_tag}-VPC-RT"
    }
}
 
## -- CREATED ROUTE TABLE WE MUST ATTACH IGW FOR INTERNET AND 0.0.0.0/0 FOR INTERNET IN/OUT TRAFFIC
resource "aws_route" "igw-pubip-rt" {
    route_table_id = aws_route_table.sps-main-rt.id
    gateway_id = aws_internet_gateway.sps-igw.id # --- igw
    destination_cidr_block = var.public_ip  # traffic going out # variable public_ip{} 0.0.0.0/0
}
 
## -- ANOTHER ROUTE TO PUBLIC subnt1 SUBNET
resource "aws_route_table_association" "public-route1" {
    route_table_id = aws_route_table.sps-main-rt.id
    subnet_id = aws_subnet.public-subnet1.id
   
}
 
## -- ANOTHER ROUTE TO PUBLIC subnet2 SUBNET
resource "aws_route_table_association" "public-route2" {
    route_table_id = aws_route_table.sps-main-rt.id
    subnet_id = aws_subnet.public-subnet2.id
   
}
 
## -- SECURITY-GROUPS
resource "aws_security_group" "sps-igw" {
    vpc_id = aws_vpc.sps-vpc.id # so to which VPC we created this SG, must put here
    name = "${var.sg_name}-SecurityGroup" # variable sg_name{}
    ingress {
        description = "Allow SSH Traffic"
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = [var.public_ip]
    }    
    ingress {
        description = "Allow HTTP Traffic"
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = [var.public_ip]
    }
    egress {
        description = "Allow all ports from Outboud"
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = [var.public_ip]
    }
    tags = {
         Name = "${var.vpc_tag}-VPC-SG"
    }
 
}