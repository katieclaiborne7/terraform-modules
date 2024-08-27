resource "google_secret_manager_secret" "dbt_cloud_service_account_key" {
  for_each  = local.environments
  project   = "${local.gcp_project_root}-${each.key}"
  secret_id = "dbt-cloud-service-account-key"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "dbt_cloud_service_account_key" {
  for_each    = local.environments
  secret      = google_secret_manager_secret.dbt_cloud_service_account_key[each.key].id
  secret_data = base64decode(google_service_account_key.dbt_cloud[each.key].private_key)
}

resource "google_secret_manager_secret" "dbt_cloud_service_token" {
  project   = "${local.gcp_project_root}-production"
  secret_id = "dbt-cloud-service-token"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "dbt_cloud_service_token" {
  secret      = google_secret_manager_secret.dbt_cloud_service_token.id
  secret_data = dbtcloud_service_token.main.token_string
}
