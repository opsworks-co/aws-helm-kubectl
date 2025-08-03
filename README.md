# AWS Helm Kubectl Docker Image

This repository is discontiued, further work at https://github.com/Perun-Engineering/aws-helm-kubectl

Multi-architecture Docker image containing AWS CLI, Helm, Kubectl, and other commonly used Kubernetes tools.

## Supported Architectures

- `linux/amd64`
- `linux/arm64`

## Available Tags (Kubectl Versions)

- `1.29.13`
- `1.30.9`
- `1.31.5`
- `1.32.1`

## Components Versions

All current images include the following tools:

| Component | Version |
|-----------|---------|
| Alpine | 3.20.5 |
| Helm | 3.17.0 |
| AWS CLI | 2.23.0 |
| SOPS | 3.9.3 |
| Helm Secrets Plugin | 4.6.2 |
| Helm S3 Plugin | 0.16.2 |
| Helm Diff Plugin | 3.9.13 |
| Helmfile | 0.169.2 |

## Usage

Pull the specific kubectl version you need:
```bash
docker pull opsworksco/aws-helm-kubectl:1.31.4
