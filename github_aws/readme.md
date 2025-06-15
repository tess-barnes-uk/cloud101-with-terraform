# Set up a trust relationship between this repo and the github idp provider in aws

## Moving parts

1. github idp oidc provider in the aws account (one per account, should be provided by account owner)
2. iam role & trust policy linking to provider as principal, allowing assumption of another role & permission set
3. iam role with permission set to be assumed

## Setting this up

- Check that the github idp has been added: replace the placeholders for profile and account number and then run:

```sh
aws-vault exec {your.profile} -- aws iam get-open-id-connect-provider --open-id-connect-provider-arn arn:aws:iam::{sandbox.account.number}:oidc-provider/token.actions.githubusercontent.com
```

- create `var.auto.tfvars` in the github_aws folder to contain your version of the local variables values. See the [values definition file](./variables.tf) for more details

```hcl
owner = "your.name"
github_organisation = "your.github.org"
github_repo = "this.repo.name"
policy_name = "chosen.policy.name"
account_id = 012345678901
```

- Locally run terraform in the github_aws folder

```sh
aws-vault exec {your.profile} -- terraform init
aws-vault exec {your.profile} -- terraform validate
aws-vault exec {your.profile} -- terraform plan
aws-vault exec {your.profile} -- terraform apply
```

## Cleaning this up

**After main deployment workflow is disabled** locally run terraform in the github_aws folder 

```sh
aws-vault exec {your.profile} -- terraform destroy
```
