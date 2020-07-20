FROM gitpod/workspace-mysql

USER root

COPY xdebug/99-xdebug.ini.tpl /tmp
COPY xdebug/render_template.sh /tmp
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
    && sh /tmp/render_template.sh /tmp/99-xdebug.ini.tpl > /etc/php/7.4/cli/conf.d/99-xdebug.ini \
    && sh /tmp/render_template.sh /tmp/99-xdebug.ini.tpl > /etc/php/7.4/fpm/conf.d/99-xdebug.ini \
    && mkdir -m 0755 /var/log/php \
    && chown gitpod:gitpod /var/log/php \
    && mkdir -m 0755 /run/php \
    && chown gitpod:gitpod /run/php \
    && apt-get clean \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

COPY php/cli/php.ini /etc/php/7.4/cli/
COPY php/fpm/php.ini /etc/php/7.4/fpm/
COPY php/fpm/php-fpm.conf /etc/php/7.4/fpm/
COPY php/fpm/pool.d/www.conf /etc/php/7.4/fpm/pool.d/
COPY nginx/fastcgi_params /etc/nginx/
COPY nginx/nginx.conf /etc/nginx/

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/
