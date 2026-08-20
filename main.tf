locals {
  name_prefix        = var.name_prefix != "" ? "${var.name_prefix}-" : ""
  namespace          = var.create_namespace ? kubernetes_namespace_v1.bitbucket_runner[0].metadata[0].name : var.namespace
  runner_version_tag = var.runner_version == null || var.runner_version == "" ? "" : ":${var.runner_version}"

  env_variables = {
    ACCOUNT_UUID      = "{${var.account_uuid}}"
    RUNNER_UUID       = "{${var.runner_uuid}}"
    WORKING_DIRECTORY = "/tmp"
  }

  env_from_secret = {
    OAUTH_CLIENT_ID     = "oauthClientId"
    OAUTH_CLIENT_SECRET = "oauthClientSecret"
  }

  volume_mounts = {
    tmp               = "/tmp"
    docker-containers = "/var/lib/docker/containers"
    var-run           = "/var/run"
  }
}

resource "kubernetes_namespace_v1" "bitbucket_runner" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret_v1" "bitbucket_runner_credentials" {
  type = "Opaque"

  metadata {
    name      = "${local.name_prefix}bitbucket-runner-oauth-credentials"
    namespace = local.namespace

    labels = {
      accountUuid    = var.account_uuid
      repositoryUuid = var.repository_uuid
      runnerUuid     = var.runner_uuid
    }
  }

  data = {
    oauthClientId     = var.oauth_client_credentials.id
    oauthClientSecret = var.oauth_client_credentials.secret
  }
}

resource "kubernetes_job_v1" "bitbucket_runner" {
  wait_for_completion = false

  metadata {
    name      = "${local.name_prefix}bitbucket-runner"
    namespace = local.namespace
  }

  spec {
    backoff_limit = 2147483647

    selector {
      match_labels = {}
    }

    template {
      metadata {
        labels = {
          accountUuid    = var.account_uuid
          repositoryUuid = var.repository_uuid
          runnerUuid     = var.runner_uuid
        }
      }

      spec {
        restart_policy = "OnFailure"
        node_selector  = var.node_selector

        container {
          name  = "runner"
          image = "docker-public.packages.atlassian.com/sox/atlassian/bitbucket-pipelines-runner${local.runner_version_tag}"

          dynamic "env" {
            for_each = nonsensitive(var.repository_uuid) == "" ? local.env_variables : merge(
              local.env_variables, {
                REPOSITORY_UUID = "{${var.repository_uuid}}"
              }
            )

            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env" {
            for_each = local.env_from_secret

            content {
              name = env.key

              value_from {
                secret_key_ref {
                  name = kubernetes_secret_v1.bitbucket_runner_credentials.metadata[0].name
                  key  = env.value
                }
              }
            }
          }

          resources {
            requests = {
              memory = "${var.requested_resources.memory}Mi"
              cpu    = "${var.requested_resources.cpu}m"
            }
          }

          dynamic "volume_mount" {
            for_each = local.volume_mounts

            content {
              name       = volume_mount.key
              mount_path = volume_mount.value
              read_only  = volume_mount.key == "docker-containers"
            }
          }
        }

        container {
          name  = "docker-in-docker"
          image = "docker:${var.dind_version}-dind"

          security_context {
            privileged = true
          }

          dynamic "env" {
            for_each = nonsensitive(var.repository_uuid) == "" ? local.env_variables : merge(
              local.env_variables, {
                REPOSITORY_UUID = "{${var.repository_uuid}}"
              }
            )

            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "volume_mount" {
            for_each = local.volume_mounts

            content {
              name       = volume_mount.key
              mount_path = volume_mount.value
            }
          }
        }

        dynamic "volume" {
          for_each = local.volume_mounts

          content {
            name = volume.key
            empty_dir {}
          }
        }
      }
    }
  }
}
