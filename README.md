# Lambda Terraform Repository

This repository contains Terraform code to deploy an AWS Lambda function with an alias, set up routing configuration for the alias, and obtain the Lambda URL.

## Prerequisites

Make sure you have the following prerequisites installed on your machine:

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)

Ensure that you have configured AWS CLI with the necessary credentials.

## Usage

1. Clone this repository:

    ```bash
    git clone https://github.com/jithinjudepaule/lambda-blue-green.git
    cd lambda-blue-green
    ```

2. Initialize Terraform:

    ```bash
    terraform init
    ```

3. Customize your deployment by modifying the `variables.tf` file.

4. Apply the Terraform configuration:

    ```bash
    terraform apply
    ```

   Confirm the changes when prompted.

5. Once the deployment is complete, the Lambda function, alias, and routing configuration will be created.



## Clean Up

To destroy the resources created by Terraform and clean up:

```bash
terraform destroy
