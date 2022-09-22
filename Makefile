default: docker_build
include .env

# Note: 
#	Latest version of kubectl may be found at: https://github.com/kubernetes/kubernetes/releases
# 	Latest version of helm may be found at: https://github.com/kubernetes/helm/releases
#   Latest version of helm-secrets may be found at: https://github.com/jkroepke/helm-secrets/releases
#   Latest version of sops may be found at: https://github.com/mozilla/sops/releases
# 	Latest version of yq may be found at: https://github.com/mikefarah/yq/releases
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
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	  
docker_push:
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
