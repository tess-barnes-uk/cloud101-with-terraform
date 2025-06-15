variable "owner" {
  type        = string
  description = "Ensures appropriate sandbox tagging, this should be your name. There is no default"
}

variable "github_organisation" {
  type        = string
  description = "Github organisation calling for idp integration. Beware max length of 64 characters when it Will be used in \"GHAction_AssumeRole_{var.github_organisation}_{var.github_repo}\""
}

variable "github_repo" {
  type        = string
  description = "Github repo calling for idp integration. Beware max length of 64 characters when it Will be used in \"GHAction_AssumeRole_{var.github_organisation}_{var.github_repo}\""
}

variable "account_id" {
  type        = string
  description = "AWS account id"
}

variable "policy_name" {
  type        = string
  description = "IAM policy name to apply to the new role"
}