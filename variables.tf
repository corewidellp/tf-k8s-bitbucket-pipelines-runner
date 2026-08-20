variable "name_prefix" {
  type        = string
  default     = ""
  nullable    = false
  description = "Name prefix for all the resources created by the module"
}

variable "namespace" {
  type        = string
  default     = "bitbucket-runner"
  nullable    = false
  description = "Namespace to install the Bitbucket Pipelines Runner"
}

variable "create_namespace" {
  type        = bool
  default     = true
  nullable    = false
  description = "Indicates creation of a dedicated namespace for Bitbucket Pipelines Runner resources"
}

variable "oauth_client_credentials" {
  type = object({
    id     = string
    secret = string
  })
  nullable    = false
  sensitive   = true
  description = <<DESCRIPTION
OAuth client credentials
  id - OAuth client ID
  secret - OAuth client secret
DESCRIPTION
}

variable "account_uuid" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Bitbucket account UUID"
}

variable "repository_uuid" {
  type        = string
  default     = ""
  nullable    = false
  sensitive   = true
  description = "Bitbucket repository UUID"
}

variable "runner_uuid" {
  type        = string
  nullable    = false
  description = "Bitbucket Pipelines Runner UUID"
}

variable "runner_version" {
  type        = string
  default     = null
  nullable    = true
  description = "Bitbucket Pipelines Runner Docker image version. Not specified by default, equals the latest available at the moment of the deployment"
}

variable "dind_version" {
  type        = string
  default     = "20.10.5"
  nullable    = false
  description = "Docker-in-Docker image version"
}

variable "requested_resources" {
  type = object({
    memory = optional(number, 64)
    cpu    = optional(number, 250)
  })
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
Requested resources for the runner
  memory - Requested RAM value for the runner, `Mi`
  cpu - Requested CPU value for the runner, `m`
DESCRIPTION
}

variable "node_selector" {
  type        = map(any)
  default     = {}
  nullable    = false
  description = "Node selector labels to assign to Bitbucket Pipelines Runner. `.` in the domain names are escaped automatically"
}
