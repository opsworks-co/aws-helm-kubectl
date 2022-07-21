ARG BUILDPLATFORM
FROM ${BUILDPLATFORM}python:3.9-alpine

ARG AWSCLI_VERSION
ARG KUBE_VERSION
ARG HELM_VERSION
ARG SOPS_VERSION
ARG HELM_SECRETS_VERSION
ARG TARGETOS
ARG TARGETARCH

RUN apk -U upgrade \
    && apk add --no-cache groff ca-certificates bash git openssh gettext jq yq make cmake gcc libc-dev libffi-dev openssl-dev \
    && wget -q -O- "https://github.com/aws/aws-cli/archive/refs/tags/${AWSCLI_VERSION}.tar.gz" | tar -xz \
    && cd aws-cli-${AWSCLI_VERSION} \
    && python -m pip install --upgrade pip \
    && python -m pip install setuptools-rust \
    && python setup.py build  \
    && python setup.py install \
    && cd .. && rm -rf aws-cli-${AWSCLI_VERSION} \
    && apk del make cmake gcc \
    && wget -q https://dl.k8s.io/release/v${KUBE_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -O /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -O - | tar -xzO ${TARGETOS}-${TARGETARCH}/helm > /usr/local/bin/helm \
    && wget -q https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.${TARGETOS}.${TARGETARCH} -O /usr/local/bin/sops \
    && chmod +x /usr/local/bin/helm /usr/local/bin/kubectl /usr/local/bin/sops \
    && mkdir /config \
    && chmod g+rwx /config /root \
    && helm repo add "stable" "https://charts.helm.sh/stable" --force-update \
    && helm plugin install https://github.com/jkroepke/helm-secrets --version v${HELM_SECRETS_VERSION} \
    && kubectl version --client \
    && helm version \
    && aws --version

WORKDIR /config

CMD bash
