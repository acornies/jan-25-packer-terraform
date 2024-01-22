data "tfe_oauth_client" "oauth_client" {
  organization = var.organization
  name         = "GitHub.com"
}

resource "tfe_project" "jan25_marketing" {
  organization = var.organization
  name         = "jan25-compliant-infra"
}

resource "tfe_workspace" "jan25_marketing" {
  name              = "web-app1-dev"
  organization      = var.organization
  auto_apply        = false
  queue_all_runs    = true
  working_directory = "terraform"
  project_id        = tfe_project.jan25_marketing.id
  vcs_repo {
    identifier = "acornies/jan-25-packer-terraform"
    oauth_token_id = data.tfe_oauth_client.oauth_client.oauth_token_id
  }
}

resource "tfe_variable_set" "jan25_marketing" {
  name          = "HCP Creds"
  description   = "HCP Client ID and Secret"
  organization  = var.organization
}

resource "tfe_workspace_variable_set" "jan25_marketing" {
  variable_set_id = tfe_variable_set.jan25_marketing.id
  workspace_id    = tfe_workspace.jan25_marketing.id
}

resource "tfe_variable" "hcp_client_id" {
  key             = "HCP_CLIENT_ID"
  value           = var.HCP_CLIENT_ID
  category        = "env"
  sensitive = true
  variable_set_id = tfe_variable_set.jan25_marketing.id
}

resource "tfe_variable" "hcp_secret_id" {
  key             = "HCP_CLIENT_SECRET"
  value           = var.HCP_CLIENT_SECRET
  category        = "env"
  sensitive = true
  variable_set_id = tfe_variable_set.jan25_marketing.id
}
