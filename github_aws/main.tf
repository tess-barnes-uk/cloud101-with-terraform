# create trust policy / assume role
# beware, the role name has a max of 64 characters so ensure that the your org and repo names are short enough!
resource "aws_iam_role" "github_action_role" {
  name               = "GHAction_AssumeRole_${var.github_organisation}_${var.github_repo}"
  assume_role_policy = data.aws_iam_policy_document.github_role_policy_document.json
}

# attach permissions role custom or built in 
# (something smaller than admin access ideally but able to deploy all your ecr and ecs resources)
resource "aws_iam_role_policy_attachment" "github_role_admin_policy_attach" {
  role       = aws_iam_role.github_action_role.name
  policy_arn = data.aws_iam_policy.admin_access_policy.arn
}