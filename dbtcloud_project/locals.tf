locals {
  environments = toset(var.environments)
  gcp_project_root = "${var.gcp_project_prefix}-${var.project_name}"

  build_selection = var.starter_mode == true ? "*" : "state:modified+"
  self_deferral   = var.starter_mode == true ? false : true
}
