data "aws_caller_identity" "this" {}
data "aws_ecr_authorization_token" "this" {}
data "aws_region" "this" {}
locals { ecr_address = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.this.name) }

provider "docker" {
  host = var.docker_host
  registry_auth {
    address  = local.ecr_address
    password = data.aws_ecr_authorization_token.this.password
    username = data.aws_ecr_authorization_token.this.user_name
  }
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 1.6.0"

  repository_force_delete = true
  repository_name         = var.ecr_repository
  repository_lifecycle_policy = jsonencode({
    rules = [{
      action       = { type = "expire" }
      description  = "Delete old images"
      rulePriority = 1
      selection = {
        countNumber = 3
        countType   = "imageCountMoreThan"
        tagStatus   = "any"
      }
    }]
  })
}

resource "docker_image" "exampleimage" {
  name = format("%v:%v", module.ecr.repository_url, formatdate("YYYY-MM-DD'T'hh-mm-ss", timestamp()))
  build { context = "../node" } # Path
}

resource "docker_registry_image" "exampleimage" {
  keep_remotely = false
  name          = resource.docker_image.exampleimage.name
}