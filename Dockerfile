ARG ALPINE_VERSION=3.16
ARG BUILDPLATFORM

ARG KUBE_VERSION
ARG HELM_VERSION
ARG SOPS_VERSION
ARG HELM_SECRETS_VERSION
ARG AWS_CLI_VERSION
ARG TARGETOS
ARG TARGETARCH

FROM python:3.10.8-alpine${ALPINE_VERSION} as builder

RUN apk add --no-cache git unzip groff build-base libffi-dev cmake
RUN echo "git clone --single-branch --depth 1 -b ${AWS_CLI_VERSION} https://github.com/aws/aws-cli.git"
RUN git clone --single-branch --depth 1 -b ${AWS_CLI_VERSION} https://github.com/aws/aws-cli.git

WORKDIR aws-cli
RUN python -m venv venv
RUN . venv/bin/activate
RUN scripts/installers/make-exe
RUN unzip -q dist/awscli-exe.zip
RUN aws/install --bin-dir /aws-cli-bin
RUN /aws-cli-bin/aws --version

# reduce image size: remove autocomplete and examples
RUN rm -rf /usr/local/aws-cli/v2/current/dist/aws_completer /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index /usr/local/aws-cli/v2/current/dist/awscli/examples
RUN find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete

# build the final image
FROM ${BUILDPLATFORM}alpine:${ALPINE_VERSION}
COPY --from=builder /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=builder /aws-cli-bin/ /usr/local/bin/

RUN apk -U upgrade \
    && apk add --no-cache ca-certificates bash git openssh gettext jq yq \
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
