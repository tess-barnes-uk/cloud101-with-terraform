# IAC for Cloud 101 ecs space

## Handling variables

You will need to create `vars.auto.tfvars` in the iac folder. It should contain

-  `docker_host = "unix:///Users/your-local-user/.rd/docker.sock"` tweaked to contain your own local value. There is a default value which will work for many people in [variables.tf](./variables.tf).
-  `owner = "yourname"` There is no default. this is to ensure that your resources are tagged correctly in the sandbox and will act as a prefix to some resource names, keep it short if you can.
-  `ecr_repository = "a meaningful name"` there is no default. This needs to sit next to everyone elses images, how can we easily make it unique?.

## Backend you will need to configure

This should replace the block in [providers.tf](./providers.tf). NB. no variables will work in this block, it needs to be raw strings. 

You will need to update it with your output values for bucket and kms_key_id arn from your copy of [s3 backend bootstrap](https://github.com/tess-barnes-uk/terraform-bootstrap-sandbox).

```hcl
terraform {
  backend "s3" {
    bucket         = "your-own-persistent-state-bucket-name"
    key            = "cloud101/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-2:123456789123:key/your-own-kms-key-id"
    use_lockfile = true
  }
}
```

## Commands to run

```sh
aws-vault exec {profile-name} -- terraform init
```

```sh
aws-vault exec {profile-name} -- terraform validate
```

```sh
aws-vault exec {profile-name} -- terraform plan
```

```sh
aws-vault exec {profile-name} -- terraform apply
# interactive, you will have to review the suggested changes and type yes
```

## Troubleshooting

You _shouldn't_ see any errors but if you do, there are runbooks and other resources to help troubleshoot, including ECS issues.

```text
ResourceInitializationError: unable to pull secrets or registry auth: The task cannot pull registry auth from Amazon ECR: There is a connection issue between the task and Amazon ECR. Check your task network configuration. RequestError: send request failed caused by: Post "https://api.ecr.eu-west-2.amazonaws.com/": dial tcp 3.8.169.253:443: i/o timeout
```

[More about ResourceInitializationError](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/resource-initialization-error.html)

[Useful runbook](https://eu-west-2.console.aws.amazon.com/systems-manager/automation/execute/AWSSupport-TroubleshootECSTaskFailedToStart?region=eu-west-2#)

[Runbook docs](https://docs.aws.amazon.com/systems-manager-automation-runbooks/latest/userguide/automation-aws-troubleshootecstaskfailedtostart.html)

[Ideas for fixing VPC / ECR / Task connection errors](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/verify-connectivity.html#fix-vpc-endpoints)
