module "mwaa" {
  source = "aws-ia/mwaa/aws"

  name                 = var.name
  airflow_version      = "2.5.1"
  environment_class    = "mw1.small"
  create_s3_bucket     = false
  source_bucket_arn    = aws_s3_bucket.this.arn
  dag_s3_path          = "dags"
  requirements_s3_path = "dependencies/requirements.txt"

  logging_configuration = {
    dag_processing_logs = {
      enabled   = true
      log_level = "INFO"
    }

    scheduler_logs = {
      enabled   = true
      log_level = "INFO"
    }

    task_logs = {
      enabled   = true
      log_level = "INFO"
    }

    webserver_logs = {
      enabled   = true
      log_level = "INFO"
    }

    worker_logs = {
      enabled   = true
      log_level = "INFO"
    }
  }

  airflow_configuration_options = {
    "core.load_default_connections" = "false"
    "core.load_examples"            = "false"
    "webserver.dag_default_view"    = "tree"
    "webserver.dag_orientation"     = "TB"
  }

  min_workers        = 1
  max_workers        = 2
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  webserver_access_mode = "PUBLIC_ONLY"
  source_cidr           = ["10.1.0.0/16"]

} 
