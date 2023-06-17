#snowflake terraform configuring database, schema, warehouse and grants 

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.66.2"
    }
  }
}
provider "snowflake" {
  alias    = "sys_admin"
  role     = "SYSADMIN"
  username = "tf-snow"
}

resource "snowflake_database" "raw" {
  provider = snowflake.sys_admin
  name     = "SPOON_RAW"
}

resource "snowflake_database" "dev" {
  provider = snowflake.sys_admin
  name     = "SPOON_DEV"
}

resource "snowflake_database" "ci" {
  provider = snowflake.sys_admin
  name     = "SPOON_CI"
}

resource "snowflake_database" "prod" {
  provider = snowflake.sys_admin
  name     = "SPOON_PROD"
}


resource "snowflake_schema" "schema_raw" {
  provider = snowflake.sys_admin
  database = snowflake_database.raw.name
  name     = "RAW"
}

resource "snowflake_schema" "schema_dev" {
  provider = snowflake.sys_admin
  database = snowflake_database.dev.name
  name     = "STAGING"
}

resource "snowflake_schema" "schema_prod" {
  provider = snowflake.sys_admin
  database = snowflake_database.prod.name
  name     = "STAGING"
}

resource "snowflake_database_grant" "grant_raw" {
  provider      = snowflake.sys_admin
  database_name = snowflake_database.raw.name
  privilege     = "USAGE"
}

resource "snowflake_database_grant" "grant_dev" {
  provider      = snowflake.sys_admin
  database_name = snowflake_database.dev.name
  privilege     = "USAGE"
}

resource "snowflake_database_grant" "grant_ci" {
  provider      = snowflake.sys_admin
  database_name = snowflake_database.ci.name
  privilege     = "USAGE"
}

resource "snowflake_database_grant" "grant_prod" {
  provider      = snowflake.sys_admin
  database_name = snowflake_database.prod.name
  privilege     = "USAGE"
}

resource "snowflake_schema_grant" "grant_schema_raw" {
  provider      = snowflake.sys_admin
  database_name = snowflake_database.raw.name
  schema_name   = snowflake_schema.schema_raw.name
}

resource "snowflake_schema_grant" "grant_schema_dev" {
  provider      = snowflake.sys_admin
  database_name = snowflake_database.dev.name
  schema_name   = snowflake_schema.schema_dev.name
}

resource "snowflake_schema_grant" "grant_schema_prod" {
  provider      = snowflake.sys_admin
  database_name = snowflake_database.prod.name
  schema_name   = snowflake_schema.schema_prod.name

}
