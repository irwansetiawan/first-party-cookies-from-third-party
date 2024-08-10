
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
    sudo yum install nginx -y
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
