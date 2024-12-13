# AWS Helm Kubectl Docker Image

Multi-architecture Docker image containing AWS CLI, Helm, Kubectl, and other commonly used Kubernetes tools.

## Supported Architectures

- `linux/amd64`
- `linux/arm64`

## Available Tags (Kubectl Versions)

${KUBE_LIST}

## Components Versions

All current images include the following tools:

| Component | Version |
|-----------|---------|
| Alpine | ${ALPINE_VERSION} |
| Helm | ${HELM_VERSION} |
| AWS CLI | ${AWS_CLI_VERSION} |
| SOPS | ${SOPS_VERSION} |
| Helm Secrets Plugin | ${HELM_SECRETS_VERSION} |
| Helm S3 Plugin | ${HELM_S3_VERSION} |
| Helm Diff Plugin | ${HELM_DIFF_VERSION} |
| Helmfile | ${HELMFILE_VERSION} |

Please check release notes for previous images components versions.

## Usage

Pull the specific kubectl version you need:
```bash
docker pull opsworksco/aws-helm-kubectl:1.31.4
