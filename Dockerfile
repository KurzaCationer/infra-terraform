FROM debian:12-slim

ARG TARGETARCH
ARG TARGETVARIANT
# https://developer.hashicorp.com/terraform/install
ARG TERRAFORM_VERSION=1.14.3
# https://storage.googleapis.com/kubernetes-release/release/stable.txt
ARG KUBECTL_VERSION=v1.31.0
# https://github.com/hetznercloud/cli/releases/
ARG HCLOUD_VERSION=v1.58.0

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    git \
    curl \
    bash \
    coreutils \
    unzip \
    wget \
    gnupg \
    openssh-client \
    jq \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt update && \
    apt install terraform=${TERRAFORM_VERSION}-1 packer --no-install-recommends -y && \
    rm -rf /var/lib/apt/lists/*

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm -rf ./kubectl

RUN curl -LO https://github.com/hetznercloud/cli/releases/download/${HCLOUD_VERSION}/hcloud-linux-${TARGETARCH}${TARGETVARIANT}.tar.gz && \
    tar -C /usr/local/bin --no-same-owner -xzf hcloud-linux-${TARGETARCH}${TARGETVARIANT}.tar.gz hcloud && \
    rm -rf ./hcloud-linux-${TARGETARCH}${TARGETVARIANT}.tar.gz

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN useradd -ms /bin/bash terraform-user

USER terraform-user

WORKDIR /terraform-env

ENTRYPOINT ["bash"]