# this lookup will fail if the idp provider is not present 
# but there is only one allowed per account so we should not create it here
data "aws_iam_openid_connect_provider" "github" {
  arn = "arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "github_role_policy_document" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_organisation}/${var.github_repo}:*"]
    }
  }
}

data "aws_iam_policy" "admin_access_policy" {
  name = var.policy_name
}