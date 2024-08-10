terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_vpc" "main" {
  tags = { Name = "first-party-cookies" }
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_subnet" "main" {
  tags = { Name = "first-party-cookies" }
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "main" {
  tags = { Name = "first-party-cookies" }
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_internet_gateway" "main" {
  tags = { Name = "first-party-cookies" }
  vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.first_party_cookies.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.first_party_cookies.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.first_party_cookies.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_security_group" "first_party_cookies" {
  name        = "first_party_cookies"
  description = "first_party_cookies inbound traffic"
  vpc_id      = aws_vpc.main.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_key_pair" "first-party-cookies" {
  key_name   = "first-party-cookies"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "test" {
  ami = data.aws_ami.this.id
  vpc_security_group_ids = [ aws_security_group.first_party_cookies.id ]
  subnet_id = aws_subnet.main.id
  instance_type = "t4g.nano"
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.005
    }
  }
  tags = {
    Name = "first-party-cookies"
  }
  key_name = aws_key_pair.first-party-cookies.key_name
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1 -y 
    sudo systemctl enable nginx
    sudo systemctl start nginx
    echo "<h1>Hello, World!</h1>" > /usr/share/nginx/html/index.html
  EOF
}

output "public_dns" {
  value = "${aws_instance.test.public_dns}"
}

output "public_ip" {
  value = "${aws_instance.test.public_ip}"
}
