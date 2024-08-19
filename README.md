# Third Party Context

This repository aims to establish a testing environment for interactions between two distinct parties:
* First-party: The URL that a user visits.
* Third-party: A URL invoked from within the first-party context, typically in the form of a script or tracking pixel.

With the rise of privacy features in major web browsers, third-party entities face significant limitations. This test environment empowers developers to evaluate third-party capabilities within various browser contexts.

# Initializing Test Environment

## Prerequisites

Before you begin, ensure you have the following:
* **AWS CLI**: The Amazon Web Services Command Line Interface.
* **AWS Configuration**: Run `aws configure` to set up your AWS access key.
* **SSH Key**: Verify that your SSH key is located at `~/.ssh/id_rsa.pub` and `~/.ssh/id_rsa`. If you do not have an SSH key, generate one using:
    ```
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```

## Setup Instructions

1. **Build the source code**: Start by building the source code:

    ```
    npm run build
    ```

2. **Initialize AWS**: Initialize the test infrastructure on AWS using Terraform:

    ```
    npm run tf:init
    npm run tf:apply
    ```

3. **Output Verification**: Upon successful execution, you will receive two public DNS addresses in the output, and will be automatically written to `.env`, for example:

    ```
    FIRST_PARTY_PUBLIC_DNS=ec2-000-000-000-000.ap-southeast-1.compute.amazonaws.com
    THIRD_PARTY_PUBLIC_DNS=ec2-000-000-000-000.ap-southeast-1.compute.amazonaws.com
    ```

4. **Start Development**: To initiate the development process, run the watch command. This will ensure that any changes made to the files are automatically synchronized with the remote servers:

    ```
    npm run watch
    ```

5. **Open in Browser**:
    * Copy the value of `FIRST_PARTY_PUBLIC_DNS` and paste in your browser. Ignore any security warning and accept the self-signed certificate.
    * Your third-party calls from first-party context will also be blocked by default. To accept the self-signed certificate for the third-party domain, copy and paste the value of `THIRD_PARTY_PUBLIC_DNS` in a separate tab and accept its certificate.
