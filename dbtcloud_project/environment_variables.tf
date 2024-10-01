resource "dbtcloud_environment_variable" "project_evaluator_enabled" {
  name       = "DBT_PROJECT_EVALUATOR_ENABLED"
  project_id = dbtcloud_project.main.id
  environment_values = {
    "Production" : "false",
    "Staging" : "false"
  }
  depends_on = [
    dbtcloud_environment.deployment,
  ]
}

resource "dbtcloud_environment_variable" "project_evaluator_severity" {
  name       = "DBT_PROJECT_EVALUATOR_SEVERITY"
  project_id = dbtcloud_project.main.id
  environment_values = {
    "Continuous integration" : "error",
    "Development" : "error"
  }
  depends_on = [
    dbtcloud_environment.deployment,
    dbtcloud_environment.development,
  ]
}
