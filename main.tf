terraform {
  backend "s3" {}

  required_providers {
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "3.2.0"
    }
  }
}

provider "random" {}

resource "random_uuid" "secret" {}

output "JWT_SECRET" {
  sensitive = true
  value     = random_uuid.secret.result
}
