# Initializing Test Environment

Requirements

* AWS CLI
* Configure AWS CLI with `aws configure` and enter AWS access key
* Ensure SSH key is set up at `~/.ssh/id_rsa.pub` and `~/.ssh/id_rsa`. Otherwise, set it up with `ssh-keygen -t ed25519 -C "your_email@example.com"`

First step, initialize test infrastructure on AWS with terraform:

```
cd terraform/
terraform init
terraform apply
```

When completed, there will be 2 public DNS in the output that can be used, for example:

```
first_party_public_dns = "ec2-000-000-000-000.ap-southeast-1.compute.amazonaws.com"
third_party_public_dns = "ec2-000-000-000-000.ap-southeast-1.compute.amazonaws.com"
```
