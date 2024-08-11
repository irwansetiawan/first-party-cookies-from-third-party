# Initializing Test Environment

Requirements

* AWS CLI
* Configure AWS CLI with `aws configure` and enter AWS access key
* Ensure SSH key is set up at `~/.ssh/id_rsa.pub` and `~/.ssh/id_rsa`. Otherwise, set it up with `ssh-keygen -t ed25519 -C "your_email@example.com"`

First step, initialize and apply infrastructure on AWS with terraform:

```
npm run tf:init
npm run tf:apply
```

When completed, there will be 2 public DNS in the output, for example:

```
FIRST_PARTY_PUBLIC_DNS = "ec2-000-000-000-000.ap-southeast-1.compute.amazonaws.com"
THIRD_PARTY_PUBLIC_DNS = "ec2-000-000-000-000.ap-southeast-1.compute.amazonaws.com"
```

Add the 2 domains into `.env` (remove the whitespaces before and after the `=` sign)

Run watch command to start development, the updated files will be automatically updated to the remote servers:

```
npm run watch
```
