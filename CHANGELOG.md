All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v2.1.0 - 2026-08-17

### Added

* option to control the runner version with a `runner_version` variable (not specified by default, equals the latest available at the moment of the deployment)

## v2.0.0 - 2026-03-12

> **NOTE** Make sure that other modules in the project support the new (major) Kubernetes Terraform provider version, see the *Upgrade Notes* section

### Changed

* minimal Kubernetes Terraform provider version to `v3.0`
* minimal Terraform required version to `1.3` to optimize the processing of the optional object variables

## v1.1.1 - 2026-02-03

**(Last version compatible with Kubernetes Terraform provider v2.0)**

### Changed

* set the `backoff_limit` (`backoffLimit`) parameter for the K8s Job that manages the runner Pods to the maximal possible value `2147483647`

### Fixed

* K8s runner Pod recreation failures, caused by runner Job hitting the default `backoff_limit` (`6`)

## v1.1.0 - 2025-08-22

### Added

* option to supply node selector labels with a `node_selector` variable
* `nullable` parameter to all variables

## v1.0.2 - 2025-06-23

### Fixed

* Terraform not waiting for backed-off pod by disabling `wait_for_completion` job parameter

## v1.0.1 - 2023-12-21

### Changed

* the way to call the `repository_uuid` variable for checking the condition to fix issue with the configuration validation

## v1.0.0 - 2023-04-17

First stable version

### Added

* Docker-based Bitbucket Pipelines Runner
* an option to create an additional namespace for Bitbucket Pipelines Runner or use an already existing one
