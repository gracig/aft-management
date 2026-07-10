variable "ct_management_account_id" {
  description = "Management (root) account ID"
  type        = string
}

variable "log_archive_account_id" {
  description = "Log Archive account ID (aws-cloudtrail-admin in this lab)"
  type        = string
}

variable "audit_account_id" {
  description = "Audit account ID (aws-config-aggregator in this lab)"
  type        = string
}
