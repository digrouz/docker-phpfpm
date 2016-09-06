# vim:set ft=dockerfile:
FROM alpine:latest
MAINTAINER DI GREGORIO Nicolas <nicolas.digregorio@gmail.com>

### Environment variables
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    TIMEZONE='Europe/Brussels' \
    PHP_MEMORY_LIMIT='512M' \
    MAX_UPLOAD='50' \
    PHP_MAX_FILE_UPLOAD='1024M' \
    PHP_MAX_POST='1024M' 

### Install Application
RUN apk upgrade --no-cache && \
    apk add --no-cache --virtual=run-deps \
      su-exec \
      php5-apcu \
      php5-bcmath \
      php5-bz2 \
      php5-ctype \
      php5-curl \
      php5-dom \ 
      php5-ftp \
      php5-gd \
      php5-gettext \
      php5-iconv \
      php5-intl \
      php5-json \
      php5-memcache \
      php5-mcrypt \
      php5-mysql \
      php5-mysqli \
      php5-odbc \
      php5-opcache \
      php5-openssl \
      php5-pcntl \
      php5-pdo \
      php5-pdo_dblib \
      php5-pdo_odbc \
      php5-pdo_mysql \
      php5-pdo_pgsql \
      php5-pdo_sqlite \
      php5-phar \
      php5-pgsql \
      php5-posix \
      php5-soap \
      php5-sqlite3 \
      php5-xcache \
      php5-xmlreader \
      php5-xmlrpc \
      php5-zip \
      php5-zlib \
      php5-fpm && \
    sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php5/php-fpm.conf && \
    sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php5/php-fpm.conf && \
    sed -i "s|;*listen\s*=\s*/||g" /etc/php5/php-fpm.conf && \
    sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php5/php.ini && \
    sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php5/php.ini && \
    sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" /etc/php5/php.ini && \
    sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php5/php.ini && \
    sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php5/php.ini && \
    sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= 0|i" /etc/php5/php.ini && \
    rm -rf /opt/sickrage/.git* \
           /tmp/* \
           /var/cache/apk/*  \
           /var/tmp/*
    
# Expose volumes
VOLUME ["/www","/etc/php5/fpm.d"]

# Expose ports
EXPOSE 9000

### Running User: not used, managed by docker-entrypoint.sh
#USER wwwuser

### Start php-fpm
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]
