resource "dbtcloud_project" "main" {
  name                     = title(var.project_name)
  dbt_project_subdirectory = var.project_subdirectory
}

resource "github_actions_variable" "dbt_cloud_project_id" {
  repository    = var.project_name
  variable_name = "dbt_cloud_project_id"
  value         = dbtcloud_project.main.id
}

resource "dbtcloud_repository" "main" {
  project_id             = dbtcloud_project.main.id
  remote_url             = "git@github.com:${var.organization_name}/${var.project_name}.git"
  github_installation_id = var.github_installation_id
  git_clone_strategy     = "github_app"
}

resource "dbtcloud_project_repository" "main" {
  project_id    = dbtcloud_project.main.id
  repository_id = dbtcloud_repository.main.repository_id
}

resource "dbtcloud_bigquery_credential" "main" {
  project_id  = dbtcloud_project.main.id
  dataset     = "dbt_cloud"
  num_threads = var.num_threads
}

resource "dbtcloud_service_token" "main" {
  name = title(var.project_name)
  service_token_permissions {
    permission_set = "account_admin"
    all_projects   = false
    project_id     = dbtcloud_project.main.id
  }
}
