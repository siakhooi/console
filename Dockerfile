FROM ubuntu:26.04
ARG IMAGE_TAG
LABEL org.opencontainers.image.url="https://github.com/siakhooi/console" \
      org.opencontainers.image.source="https://github.com/siakhooi/console" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.authors="Siak Hooi" \
      org.opencontainers.image.base.name="siakhooi/console:${IMAGE_TAG}" \
      org.opencontainers.image.title="siakhooi/console:${IMAGE_TAG}" \
      org.opencontainers.image.description="docker image to troubleshoot docker services in a docker network"

ARG JQ_VERSION=1.8.1
ARG YQ_VERSION=4.52.4

RUN apt update \
 && apt upgrade -y \
 && apt install -y --no-install-recommends \
        curl wget gnupg \
        iputils-ping \
        bind9-dnsutils \
        mariadb-client \
        postgresql-client \
        default-jdk \
        python3-venv \
        kafkacat \
        netcat-openbsd \
 && rm -rf /var/lib/apt/lists/*

ADD --chown=root:root --chmod=755 https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-amd64 /usr/local/bin/jq
ADD --chown=root:root --chmod=755 https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 /usr/local/bin/yq

RUN python3 -m venv /root/.venv \
 && . /root/.venv/bin/activate \
 && pip install cqlsh \
 && echo "source /root/.venv/bin/activate" >> /root/.bashrc

RUN curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor \
 && echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list \
 && apt update \
 && apt install -y mongodb-mongosh \
 && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
