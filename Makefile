default: docker_build
include .env

# Latest version of alpine may be found at: https://hub.docker.com/_/alpine
# Latest version of python may be found at: https://hub.docker.com/_/python
# Latest version of kubectl may be found at: https://github.com/kubernetes/kubernetes/releases
# Latest version of helm may be found at: https://github.com/kubernetes/helm/releases
# Latest version of helm-secrets may be found at: https://github.com/jkroepke/helm-secrets/releases
# Latest version of sops may be found at: https://github.com/mozilla/sops/releases
# Latest version of aws-cli may be found at: https://github.com/aws/aws-cli/tags
# Latest version of helmfile may be found at: https://github.com/helmfile/helmfile/releases
# Latest version of helm-s3 may be found at: https://github.com/hypnoglow/helm-s3/releases
# Latest version of helm-diff may be found at: https://github.com/databus23/helm-diff/releases

VARS:=$(shell sed -ne 's/ *\#.*$$//; /./ s/=.*$$// p' .env )
$(foreach v,$(VARS),$(eval $(shell echo export $(v)="$($(v))")))
DOCKER_IMAGE ?= opsworksco/aws-helm-kubectl
DOCKER_TAG ?= `git rev-parse --abbrev-ref HEAD`

docker_build:
	@docker buildx build \
	  --build-arg KUBE_VERSION=$(KUBE_VERSION) \
	  --build-arg HELM_VERSION=$(HELM_VERSION) \
	  --build-arg SOPS_VERSION=${SOPS_VERSION} \
	  --build-arg HELM_SECRETS_VERSION=${HELM_SECRETS_VERSION} \
	  --build-arg HELM_S3_VERSION=${HELM_S3_VERSION} \
	  --build-arg HELMFILE_VERSION=${HELMFILE_VERSION} \
	  --build-arg AWS_CLI_VERSION=${AWS_CLI_VERSION} \
	  --build-arg HELM_DIFF_VERSION=${HELM_DIFF_VERSION} \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
