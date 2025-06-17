# Exercises

1. test the pre-requisites
2. build and run the app in docker locally
3. configure and bootstrap an aws s3 backend for terraform
4. configure and spin up an ecs cluster in aws sandbox
5. change the app and manually redeploy
6. clean up
7. Establish trust between github and aws for this repo
8. enable and run the github actions pipeline provided
9. clean up via pipeline

Each exercise assumes you are starting from the root folder.
NB replace `{profile-name}` with your aws profile name before running aws-vault commands

## 1. test the pre-requisites
Make sure everything is working correctly:

```sh
brew doctor
terraform --version
aws --version
docker context ls
docker version
aws-vault exec {profile-name} -- aws sts get-caller-identity 
```

## 2. build and run the app in docker locally

To build:
```sh
cd node/
docker compose up -d --build
```
Visit [http://localhost:3000](http://localhost:3000) and check the resonse is "Hello world!"

Clean up:
```sh
docker compose down
```

## 3. configure and bootstrap an aws s3 backend for terraform

cd to the root of your bootstrap repo clone

Follow the Getting started steps (1 to 4) in that repo's readme.md

## 4. configure and spin up an ecs cluster in aws sandbox

- After a weekend, check your state bucket still exists! If not, follow exercise 3 again, the sandbox is cleared down every week.
  
```sh
aws-vault exec {profile-name} -- aws s3 ls
```

- Follow the spin up steps in the [iac readme](../iac/readme.md)
- Visit the site on the load balancer url provided in the output

## 5. change the app and manually redeploy

```sh
cd /node
```

Add the following to the index.js file, before the app.listen block

```js
app.get("/universe", (req, res) => {
  res.send("Hello Universe!");
});
```

Manually redeploy using terraform

```sh
cd ../iac
aws-vault exec {profile-name} -- terraform plan
aws-vault exec {profile-name} -- terraform apply
```

Visit the site on the load balancer url provided and add `/universe` to see the new message
  
### Discussion topic

What does it feel like to do this? should we be doing things manually all the time? Why or why not?

## 6. Clean up

Locally run terraform to remove all the resources

```sh
  cd iac/
  aws-vault exec {profile-name} -- terraform destroy
```

## 7. Establish trust between github and aws for this repo

Check that the github idp provider is in place: replace the placeholders first and then run

```sh
aws-vault exec {your.profile} -- aws iam get-open-id-connect-provider --open-id-connect-provider-arn arn:aws:iam::{sandbox.account.number}:oidc-provider/token.actions.githubusercontent.com
```

Follow the steps in [github_aws section](../github_aws/readme.md).

## 8. enable and run the github actions pipeline provided

- Set up a github secret in your remote repo for the ARN of your S3 bucket in `BUCKET_TF_STATE`
- Set up a github environment variable in your remote repo to store your `OWNER` value
- Create a new github branch and check it out locally
- Move the workflow templates into a new `.github/workflows` folder at the root level
- git add and commit and push to your remote branch
- Create a pull request and approve / merge to main
- View the pipeline run in github.com
- Visit the site on the load balancer url provided

## 9. clean up via pipeline

- Manually disable the terraform change management pipeline in github.com
- Manually run the clean up / Nuke pipeline in github.com

- Locally check the resources have all been removed by running a plan again. There should be at least 40 resources it would like to add.
```sh
cd iac/
aws-vault exec {profile-name} -- terraform plan
```
