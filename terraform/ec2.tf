
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

resource "aws_key_pair" "main" {
  key_name   = "first-party-cookies"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "first_party" {
  ami = data.aws_ami.this.id
  vpc_security_group_ids = [ aws_security_group.main.id ]
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
  key_name = aws_key_pair.main.key_name

  connection {
    type        = "ssh"
    host        = aws_instance.first_party.public_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sudo systemctl start nginx",
      "sudo chown ec2-user:ec2-user /usr/share/nginx/html",
      "sudo rm -r /usr/share/nginx/html/*",
    ]
  }

  provisioner "file" {
    source      = "../src/first-party/"
    destination = "/usr/share/nginx/html"
  }
}

resource "aws_instance" "third_party" {
  ami = data.aws_ami.this.id
  vpc_security_group_ids = [ aws_security_group.main.id ]
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
  key_name = aws_key_pair.main.key_name

  connection {
    type        = "ssh"
    host        = aws_instance.third_party.public_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sudo systemctl start nginx",
      "sudo chown ec2-user:ec2-user /usr/share/nginx/html",
      "sudo rm -r /usr/share/nginx/html/*",
    ]
  }

  provisioner "file" {
    source      = "../src/third-party/"
    destination = "/usr/share/nginx/html"
  }
}

output "FIRST_PARTY_PUBLIC_DNS" {
  value = "${aws_instance.first_party.public_dns}"
}

output "THIRD_PARTY_PUBLIC_DNS" {
  value = "${aws_instance.third_party.public_dns}"
}
