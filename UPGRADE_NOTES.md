## From `v1.x` to `v2.x`

Module from `v2.0` has changed Kubernetes Terraform provider version, which isn't compatible with older versions. After the module version is upgraded, re-init the module to upgrade the provider version. Upgrade the Kubernetes Terraform provider version at the project level:

```hcl
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
  }
}
```

Upgrade project dependencies:

```bash
terraform init --upgrade
```

Apply the changes to make sure the state of the resources is up-to-date with the new provider version:

```bash
terraform apply
```
