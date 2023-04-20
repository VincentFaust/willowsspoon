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
  name     = "SPOON_ANALYTICS_PRODUCTION"
}
resource "snowflake_warehouse" "name" {
  provider       = snowflake.sys_admin
  name           = "ANALYTICS_PRODUCTION"
  warehouse_size = "medium"
  auto_suspend   = 60
}
