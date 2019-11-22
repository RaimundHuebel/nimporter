###
# Dockerfile for Nimporter-Project.
#
# @example Build
# ```bash
#   # Build Docker-Image ...
#   $ cd .nimporter-dev   # == this-folder
#   $ docker build --tag "nimporter/dev-system:1.0" ./
#
#   # List installed Docker-Images ...
#   $ docker images -a
#
#   # User Docker-Container
#   $ docker run --help
#   $ docker run -it --rm nimporter-dev infinte
#   $ docker run -it --rm nimporter-dev console
#   $ docker run -it --rm nimporter-dev cli
#   $ docker run -it --rm nimporter-dev /bin/bash
#   $ docker run -it --rm nimporter-dev -u root console
#
#   # Remove Docker-Image/Container from local Registry ...
#   $ docker rm  nimporter-dev-00
#   $ docker rmi nimporter-dev
# ```
#
# @see https://hub.docker.com/r/nimlang/nim
# @see https://docs.docker.com/
# @see https://docs.docker.com/get-started/
# @see https://docs.docker.com/engine/reference/builder/
# @see https://medium.freecodecamp.org/docker-entrypoint-cmd-dockerfile-best-practices-abc591c30e21?gi=b30cfa1f96fa
#
# @author Raimund Hübel <raimund.huebel@googlemail.com>
###

FROM nimlang/nim:1.0.2

LABEL author="raimund.huebel@googlemail.com"
LABEL maintainer="raimund.huebel@googlemail.com"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="nimporter-dev"
LABEL org.label-schema.description="Dev-Environment based on Docker for Nimporter."
LABEL org.label-schema.url="https://github.com/RaimundHuebel/nimporter"
LABEL org.label-schema.docker.cmd="docker run -v `pwd`:/usr/src/app nimporter-dev"

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD        [ "console" ]

COPY docker-entrypoint-debian.sh /docker-entrypoint.sh

RUN  true \
 &&  echo "[INFO] setup base system" \
 &&    apt-get update --yes \
 &&    apt-get install --yes make upx-ucl vim wget curl \
 &&  echo "[INFO] cleanup base system" \
 &&    apt-get autoremove --yes \
 &&    apt-get clean --yes \
 &&    rm -rf /var/lib/apt/lists/* \
 &&    rm -rf /root/.cache/ \
 &&  echo "[INFO] configure docker-container-environment" \
 &&    chmod +x docker-entrypoint.sh \
 &&  echo "[INFO] create user: dev" \
 &&    useradd --create-home --home-dir=/home/dev dev \
 &&  echo "[INFO] setup user-dir: /home/dev" \
 &&    mkdir -p      /home/dev/.cache /home/dev/.nimble \
 &&    chown dev:dev /home/dev/.cache /home/dev/.nimble \
 &&    chmod 0777    /home/dev/.cache /home/dev/.nimble

WORKDIR /home/dev
USER dev
