# AWS Helm Kubectl Docker Image

Multi-architecture Docker image containing AWS CLI, Helm, Kubectl, and other commonly used Kubernetes tools.

## Supported Architectures

- `linux/amd64`
- `linux/arm64`

## Available Tags (Kubectl Versions)



## Components Versions

All current images include the following tools:

| Component | Version |
|-----------|---------|
| Helm |  |
| AWS CLI |  |
| SOPS |  |
| Helm Secrets Plugin |  |
| Helm S3 Plugin |  |
| Helm Diff Plugin |  |
| Helmfile |  |

Please check release notes for previous images components versions.

## Usage

Pull the specific kubectl version you need:
```bash
docker pull opsworksco/aws-helm-kubectl:1.31.3
