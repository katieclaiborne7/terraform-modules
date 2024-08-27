resource "dbtcloud_job" "deployment" {
  for_each       = toset(["staging", "production"])
  environment_id = dbtcloud_environment.deployment[each.key].environment_id
  execute_steps  = [
    "dbt build --select ${local.build_selection}"
  ]
  name           = each.key == "staging" ? "Merge" : "Release"
  project_id     = dbtcloud_project.main.id
  self_deferring = local.self_deferral
  num_threads    = var.num_threads
  triggers = {
    "github_webhook" : false
    "git_provider_webhook" : false
    "schedule" : false
    "on_merge" : each.key == "staging" ? true : false
  }
}

resource "github_actions_variable" "dbt_cloud_production_deployment_job_id" {
  repository    = var.project_name
  variable_name = "dbt_cloud_production_deployment_job_id"
  value         = dbtcloud_job.deployment["production"].id
}

resource "dbtcloud_job" "continuous_integration" {
  environment_id = dbtcloud_environment.deployment["dev"].environment_id
  execute_steps  = [
    "dbt build --select ${local.build_selection} --exclude package:dbt_project_evaluator",
    "dbt build --select package:dbt_project_evaluator dbt_project_evaluator_exceptions"
  ]
  name                     = "Continuous integration"
  project_id               = dbtcloud_project.main.id
  deferring_environment_id = dbtcloud_environment.deployment["staging"].environment_id
  num_threads              = var.num_threads
  triggers = {
    "github_webhook" : true
    "git_provider_webhook" : true
    "schedule" : false
    "on_merge" : false
  }
}
