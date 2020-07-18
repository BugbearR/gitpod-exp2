FROM gitpod/workspace-full

USER root

RUN apt-get update \
    && apt-get install -y lsb-release \
    && apt-get clean \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/*

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/
