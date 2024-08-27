variable "project_name" {
  type = string
  description = "Name of project and repository, in lowercase."
  validation {
    condition = lower(var.project_name) == var.project_name
    error_message = "Project name should be lowercase."
  }
}

variable "organization_name" {
  type = string
  description = "Name of GitHub organization"
}

variable "github_installation_id" {
  type = number
  description = "Identifier of dbt Cloud GitHub app installation"
}

variable "project_subdirectory" {
  type = string
  description = "Subdirectory of project"
  default = "dbt"
}

variable "num_threads" {
  type = string
  description = "Number of threads to use during invocations"
}

variable "environments" {
  type = list
  description = "List of project environments"
  default = ["dev", "staging", "production"]
}

variable "gcp_project_prefix" {
  type = string
  description = "Prefix of Google Cloud projects"
}

variable "starter_mode" {
  type = bool
  description = "Indicator for whether to initialize jobs with full builds"
  default = false
}

variable "region" {
  type = string
  description = "Google Cloud region in which to store secrets"
}
