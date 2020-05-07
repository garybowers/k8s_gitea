FROM debian:buster-slim

ARG GITEA_VER=1.11.4

ENV DEBIAN_FRONTEND=noninteractive
ENV GITEA_WORK_DIR=/var/lib/gitea/

RUN apt-get update -y && \
    apt-get install -y ca-certificates wget git tig curl && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN adduser --gecos '' --shell /bin/bash --disabled-password git && \
    usermod -a -G root git

RUN mkdir -p /var/lib/gitea/custom && \
    mkdir -p /var/lib/gitea/data && \
    mkdir -p /var/lib/gitea/log && \
    mkdir -p /var/lib/gitea/repos && \
    mkdir /etc/gitea && \
    chmod -R 750 /var/lib/gitea/ && \
    chown -R git /var/lib/gitea && \
    chmod 770 /etc/gitea

ENV GITEA_VER $GITEA_VER
RUN wget -O gitea https://dl.gitea.io/gitea/${GITEA_VER}/gitea-${GITEA_VER}-linux-amd64 && \
    chmod +x gitea && \
    mv gitea /usr/local/bin/gitea

USER git

EXPOSE 3000/tcp 2222/tcp

VOLUME /var/lib/gitea/custom /var/lib/gitea/log /var/lib/gitea/data /var/lib/gitea/repos
ENTRYPOINT ["/usr/local/bin/gitea","web"]
