terraform {
  required_providers {
    dbtcloud = {
      source  = "dbt-labs/dbtcloud"
      version = "~> 0.3"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
