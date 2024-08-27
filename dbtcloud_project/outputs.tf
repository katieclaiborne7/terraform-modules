output "service_token_secret_id" {
  value = google_secret_manager_secret.dbt_cloud_service_token.secret_id
  description = "Identifier of secret containing dbt Cloud service token"
}
