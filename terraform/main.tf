resource "tfe_project" "jan25_marketing" {
  organization = var.organization
  name = "jan25-compliant-infra"
}

resource "tfe_workspace" "jan25_marketing" {
  name = "web-app1-dev"
  organization = var.organization
  auto_apply = false
  queue_all_runs = true
  working_directory = "terraform"
  project_id = tfe_project.jan25_marketing.id
}