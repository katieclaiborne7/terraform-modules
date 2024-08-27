resource "dbtcloud_global_connection" "main" {
  for_each = local.environments
  name     = each.key == "dev" ? "Development" : title(each.key)
  bigquery = {
    gcp_project_id              = "${local.gcp_project_root}-${each.key}"
    private_key_id              = jsondecode(google_secret_manager_secret_version.dbt_cloud_service_account_key[each.key].secret_data)["private_key_id"]
    private_key                 = jsondecode(google_secret_manager_secret_version.dbt_cloud_service_account_key[each.key].secret_data)["private_key"]
    client_email                = google_service_account.dbt_cloud[each.key].email
    client_id                   = jsondecode(google_secret_manager_secret_version.dbt_cloud_service_account_key[each.key].secret_data)["client_id"]
    auth_uri                    = "https://accounts.google.com/o/oauth2/auth"
    token_uri                   = "https://oauth2.googleapis.com/token"
    auth_provider_x509_cert_url = "https://www.googleapis.com/oauth2/v1/certs"
    client_x509_cert_url        = "https://www.googleapis.com/robot/v1/metadata/x509/${replace(google_service_account.dbt_cloud[each.key].email, "@", "%40")}"
  }
}

resource "dbtcloud_environment" "deployment" {
  for_each          = local.environments
  dbt_version       = "versionless"
  name              = each.key == "dev" ? "Continuous integration" : title(each.key)
  project_id        = dbtcloud_project.main.id
  type              = "deployment"
  connection_id     = dbtcloud_global_connection.main[each.key].id
  credential_id     = dbtcloud_bigquery_credential.main.credential_id
  deployment_type   = each.key == "dev" ? null : each.key
  use_custom_branch = each.key == "production" ? true : false
  custom_branch     = each.key == "production" ? "main" : null

  lifecycle {
    ignore_changes = [custom_branch]
  }
}

resource "github_actions_variable" "dbt_cloud_production_environment_id" {
  repository    = var.project_name
  variable_name = "dbt_cloud_production_environment_id"
  value         = dbtcloud_environment.deployment["production"].environment_id
}

resource "dbtcloud_environment" "development" {
  dbt_version   = "versionless"
  name          = "Development"
  project_id    = dbtcloud_project.main.id
  connection_id = dbtcloud_global_connection.main["dev"].id
  type          = "development"
}
