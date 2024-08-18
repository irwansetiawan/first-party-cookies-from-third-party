
output "FIRST_PARTY_PUBLIC_DNS" {
  value = "${aws_instance.first_party.public_dns}"
}

output "THIRD_PARTY_PUBLIC_DNS" {
  value = "${aws_instance.third_party.public_dns}"
}
