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
