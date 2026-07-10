module "aft" {
  source  = "aws-ia/control_tower_account_factory/aws"
  version = "1.20.1"

  ct_management_account_id    = var.ct_management_account_id
  log_archive_account_id      = var.log_archive_account_id
  audit_account_id            = var.audit_account_id
  aft_management_account_id   = var.ct_management_account_id

  ct_home_region              = "us-east-1"
  tf_backend_secondary_region = "us-west-2"

  vcs_provider                           = "github"
  account_request_repo_name              = "gracig/aft-account-requests"
  account_request_repo_branch            = "main"
  account_customizations_repo_name       = "gracig/aft-account-customizations"
  account_customizations_repo_branch     = "main"
  global_customizations_repo_name        = "gracig/aft-global-customizations"
  global_customizations_repo_branch      = "main"
  aft_framework_repo_url                 = "https://github.com/aws-ia/terraform-aws-control_tower_account_factory.git"
  aft_framework_repo_git_ref             = "1.20.1"

  terraform_version      = "1.15.8"
  terraform_distribution = "oss"
}
