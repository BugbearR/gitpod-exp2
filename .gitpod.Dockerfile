FROM gitpod/workspace-full

USER root

COPY 99-xdebug.ini.tpl /tmp
COPY render_template.sh /tmp

RUN apt-get update -q \
    && apt-get install -y lsb-release php-dev \
    && apt-get clean \
    && git clone https://github.com/xdebug/xdebug.git \
    && cd xdebug \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && export X_PHP_INI_CONFD="$(php --ini | grep 'Scan for additional .ini files in: ' | sed -e 's/^[^:]*: //')" \
    && export X_PHP_LIB="$(php -i | grep '^extension_dir ' | sed -e 's/^.*=> //')" \
    && sh /tmp/render_template.sh /tmp/99-xdebug.ini.tpl > "$X_PHP_INI_CONFD"/99-xdebug.ini \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/*

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/
