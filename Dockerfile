FROM debian:bookworm-slim

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y glusterfs-client openssh-server \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 22

COPY entrypoint.sh /

RUN mkdir -p /run/sshd
RUN groupadd -r kadalu && useradd -r -g kadalu -m kadalu

ENTRYPOINT ["/entrypoint.sh"]
