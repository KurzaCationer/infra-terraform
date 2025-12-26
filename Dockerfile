FROM alpine:latest

RUN addgroup -S terraform && adduser -S tf -G terraform

RUN apk add --no-cache \
    ca-certificates \
    openssh \
    coreutils \
    git \
    bash \
    curl \
    aws-cli \
    jq

COPY --from=hetznercloud/cli:latest /ko-app/hcloud /usr/local/bin/hcloud
COPY --from=hashicorp/terraform:latest /bin/terraform /usr/local/bin/terraform
COPY --from=alpine/kubectl:latest /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=alpine/helm:3 /usr/bin/helm /usr/local/bin/helm

RUN touch /config.toml && chown tf:terraform /config.toml

USER tf
WORKDIR /terraform-env

ENTRYPOINT ["bash"]