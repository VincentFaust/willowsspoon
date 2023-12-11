locals {
  name = "dbt-repo"
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name                 = local.name
  repository_type                 = "private"
  repository_image_tag_mutability = "MUTABLE"

  create_lifecycle_policy = "true"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        "rulePriority" : 1,
        "description" : "delete all untagged images"
        "selection" : {
          "tagStatus" : "untagged",
          "countType" : "imageCountMoreThan",
          "countNumber" : 1
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}
