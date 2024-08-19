
output "FIRST_PARTY_PUBLIC_DNS" {
  value = "${aws_instance.first_party.public_dns}"
}

output "THIRD_PARTY_PUBLIC_DNS" {
  value = "${aws_instance.third_party.public_dns}"
}

resource "local_file" "env" {
  content = <<-EOF
    FIRST_PARTY_PUBLIC_DNS=${aws_instance.first_party.public_dns}
    THIRD_PARTY_PUBLIC_DNS=${aws_instance.third_party.public_dns}
  EOF
  filename = "../.env"
}