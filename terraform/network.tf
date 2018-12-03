resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
  assign_generated_ipv6_cidr_block = false
  enable_dns_support = true
}
data "aws_vpc" "vpc" {
  id = "${aws_vpc.vpc.id}"
}
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}
data "aws_availability_zones" "available" {}
resource "aws_subnet" "web_subnet" {
  count = "${var.number_of_instances}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block = "${cidrsubnet(data.aws_vpc.vpc.cidr_block, 8, count.index)}"
}
resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}
resource "aws_security_group" "web-sec" {
  name = "open 8080 and 3389 port"
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
    from_port	= 8080
    to_port	= 8080
    protocol	= "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }
  ingress {
    from_port	= 3389
    to_port	= 3389
    protocol	= "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }
  egress {
    from_port	= 0
    to_port	= 0
    protocol	= "-1"
    cidr_blocks	= ["0.0.0.0/0"]
  }
}
