data "aws_availability_zones" "available" {}

locals {
  vpc_cidr       = "10.0.0.0/16"
  azs            = slice(data.aws_availability_zones.available.names, 0, 3)
  name           = "dev-cluster"
  container_name = "dbt_container"
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "~> 5.0"
  name               = "my-vpc"
  cidr               = local.vpc_cidr
  azs                = local.azs
  public_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  private_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 40)]
  enable_nat_gateway = true
  single_nat_gateway = true
}

module "ecs" {
  source       = "terraform-aws-modules/ecs/aws"
  version      = "5.2.1"
  cluster_name = local.name
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 1
      }
    }
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "allow inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_ecs_task_definition" "dbt_task" {
  family = "dbt_task"
  container_definitions = jsonencode([{
    name      = local.container_name,
    image     = "784153138185.dkr.ecr.us-east-2.amazonaws.com/dbt-repo:latest",
    essential = true,
    secrets = [
      { name = "DBT_ENV_SECRET_PASSWORD", valueFrom = data.aws_secretsmanager_secret.my_secret.arn }
    ],
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-group"         = "/ecs/dbt_task",
        "awslogs-region"        = "us-east-2",
        "awslogs-stream-prefix" = "ecs"
      }
    },
    portMappings = [{
      containerPort = 80,
      hostPort      = 80
    }],
  }])
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "4096"
  memory                   = "8192"
}

resource "aws_ecs_service" "dbt_service" {
  name            = "dbt_service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.dbt_task.arn
  desired_count   = 0

  launch_type = "FARGATE"

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.allow_all.id]
    assign_public_ip = true
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.us-east-2.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = module.vpc.private_subnets

  security_group_ids  = [aws_security_group.allow_all.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.us-east-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = module.vpc.private_subnets

  security_group_ids  = [aws_security_group.allow_all.id]
  private_dns_enabled = true
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/dbt_task"
}
