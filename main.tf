terraform {
  backend "s3" {}

  required_providers {
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "3.2.0"
    }
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "random" {}
provider "aws" {}

data "aws_region" "current" {}

resource "random_uuid" "secret" {}

resource "random_pet" "name" {

}

resource "aws_ssm_parameter" "secret" {
  name        = "/jwt_secret/${random_pet.name.id}/value"
  description = "JWT secret value"
  type        = "SecureString"
  value       = random_uuid.secret.result
}

output "JWT_SECRET" {
  value = {
    type   = "ssm"
    arn    = aws_ssm_parameter.secret.arn
    key    = aws_ssm_parameter.secret.name
    region = data.aws_region.current.name
  }
}
