Deploy Bitbucket Pipelines Runner with configured runner version, Docker-in-Docker version, and node selector:

```hcl
module "bitbucket_runner" {
  source = "github.com/corewidellp/tf-k8s-bitbucket-pipelines-runner?ref=2.1.0"

  account_uuid   = "your_bitbucket_account_uuid"
  runner_uuid    = "your_bitbucket_runner_uuid"
  dind_version   = "29.7.1"
  runner_version = "6.0.7"

  oauth_client_credentials = {
    id     = "your_oauth_client_id"
    secret = "your_oauth_client_secret"
  }

  node_selector = {
    node-pool-name = "cicd"
  }
}
```
