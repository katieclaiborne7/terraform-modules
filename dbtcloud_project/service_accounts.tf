resource "google_service_account" "dbt_cloud" {
  for_each     = local.environments
  project      = "${local.gcp_project_root}-${each.key}"
  account_id   = "dbt-cloud"
  display_name = "dbt Cloud"
}

resource "google_service_account_key" "dbt_cloud" {
  for_each           = local.environments
  service_account_id = google_service_account.dbt_cloud[each.key].name
}
