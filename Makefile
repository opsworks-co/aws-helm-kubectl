default: docker_build
include .env

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
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	  
docker_push:
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
