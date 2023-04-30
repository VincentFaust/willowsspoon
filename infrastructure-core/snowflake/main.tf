#snowflake terraform configuring database, schema, warehouse and grants 

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.62.0"
    }
  }
}
provider "snowflake" {
  alias = "sys_admin"
  role  = "SYSADMIN"

}
resource "snowflake_database" "db" {
  provider = snowflake.sys_admin
  name     = "SPOON_PRODUCTION"
}

resource "snowflake_warehouse" "warehouse" {
  provider = snowflake.sys_admin
  name     = "ANALYTICS"
}

resource "snowflake_warehouse" "warehouse_etl" {
  provider       = snowflake.sys_admin
  name           = "ETL"
  warehouse_size = "medium"
}

resource "snowflake_schema" "schema" {
  provider = snowflake.sys_admin
  database = snowflake_database.db.name
  name     = "RAW_SOURCE"
}

resource "snowflake_database_grant" "grant" {
  provider      = snowflake.sys_admin
  database_name = snowflake_database.db.name
  privilege     = "USAGE"

}

resource "snowflake_warehouse_grant" "grant" {
  provider       = snowflake.sys_admin
  warehouse_name = snowflake_warehouse.warehouse.name
  privilege      = "USAGE"
}

resource "snowflake_warehouse_grant" "grant_etl" {
  provider       = snowflake.sys_admin
  warehouse_name = snowflake_warehouse.warehouse.name
  privilege      = "USAGE"
}

resource "snowflake_schema_grant" "grant" {
  provider      = snowflake.sys_admin
  database_name = snowflake_database.db.name
  schema_name   = snowflake_schema.schema.name
  privilege     = "USAGE"
}
