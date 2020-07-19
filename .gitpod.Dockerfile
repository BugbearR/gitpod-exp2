FROM gitpod/workspace-full

USER root

COPY 99-xdebug.ini.tpl /tmp
COPY render_template.sh /tmp

#    && git clone https://github.com/xdebug/xdebug.git -b 2.9.6 \

RUN apt-get update -q \
    && apt-get install -y lsb-release php7.4-dev php7.4-fpm \
    && curl -L https://github.com/xdebug/xdebug/archive/2.9.6.tar.gz -o /tmp/xdebug-2.9.6.tar.gz \
    && cd /tmp \
    && tar xf xdebug-2.9.6.tar.gz \
    && cd /tmp/xdebug-2.9.6 \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && export X_PHP_INI_CONFD="$(php --ini | grep 'Scan for additional .ini files in: ' | sed -e 's/^[^:]*: //')" \
    && export X_PHP_LIB="$(php -i | grep '^extension_dir ' | sed -e 's/^.*=> //')" \
    && sh /tmp/render_template.sh /tmp/99-xdebug.ini.tpl > "$X_PHP_INI_CONFD"/99-xdebug.ini \
    && apt-get clean \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/
