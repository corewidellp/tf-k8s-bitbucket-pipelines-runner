Deploy Bitbucket Pipelines Runner with the required parameters only:

```hcl
module "bitbucket_runner" {
  source = "github.com/corewidellp/tf-k8s-bitbucket-pipelines-runner?ref=2.1.0"

  account_uuid = "your_bitbucket_account_uuid"
  runner_uuid  = "your_bitbucket_runner_uuid"

  oauth_client_credentials = {
    id     = "your_oauth_client_id"
    secret = "your_oauth_client_secret"
  }
}
```
