# vim:set ft=dockerfile:
FROM alpine:latest
MAINTAINER DI GREGORIO Nicolas <nicolas.digregorio@gmail.com>

### Environment variables
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    TIMEZONE='Europe/Brussels' \
    PHP_MEMORY_LIMIT='2048M' \
    MAX_UPLOAD='50' \
    PHP_MAX_FILE_UPLOAD='2048M' \
    PHP_MAX_POST='2048M' \ 
    FPM_PM='dynamic' \
    FPM_PM_MAX_CHILDREN='20' \
    FPM_PM_START_SERVERS='3' \
    FPM_PM_MIN_SPARE_SERVERS='2' \
    FPM_PM_MAX_SPARE_SERVERS='5' \
    FPM_PM_MAX_REQUESTS='1000' \ 
    XCACHE_SIZE='1024M' \
    XCACHE_VAR_SIZE='1024M' \
    PHP_MBSTRING_HTTP_INPUT='pass' \
    PHP_MBSTRING_HTTP_OUTPUT='pass' \ 
    PHP_CGI_FIX_INFOPATH='1' \
    PHP_ENV_PATH='/usr/local/bin:/usr/bin:/bin' \
    PHP_RAW_POST_DATA='-1'

### Install Application
RUN apk upgrade --no-cache && \
    apk add --no-cache --virtual=run-deps \
      su-exec \
      ssmtp \
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
    sed -i "s|;*env\[PATH\].*=.*/usr/local/bin:/usr/bin:/bin|env\[PATH\] = ${PHP_ENV_PATH}|g" /etc/php5/php-fpm.conf && \
    sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php5/php-fpm.conf && \
    sed -i "s|;*listen\s*=\s*/||g" /etc/php5/php-fpm.conf && \
    sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php5/php.ini && \
    sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php5/php.ini && \
    sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php5/php.ini && \
    sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${MAX_UPLOAD}|i" /etc/php5/php.ini && \
    sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php5/php.ini && \
    sed -i "s|;*mbstring.http_input =.*|mbstring.http_input = ${PHP_MBSTRING_HTTP_INPUT}|i" /etc/php5/php.ini && \
    sed -i "s|;*mbstring.http_output =.*|mbstring.http_output = ${PHP_MBSTRING_HTTP_OUTPUT}|i" /etc/php5/php.ini && \
    sed -i "s|;*cgi.fix_pathinfo.*=.*|cgi.fix_pathinfo = ${PHP_CGI_FIX_INFOPATH}|i" /etc/php5/php.ini && \
    sed -i "s|;always_populate_raw_post_data.*=.*|always_populate_raw_post_data = ${PHP_RAW_POST_DATA}|i" /etc/php5/php.ini && \
    sed -i "s|pm =.*|pm = ${FPM_PM}|i" /etc/php5/php-fpm.conf && \
    sed -i "s|pm.max_children =.*|pm.max_children = ${FPM_PM_MAX_CHILDREN}|i" /etc/php5/php-fpm.conf && \
    sed -i "s|pm.start_servers =.*|pm.start_servers = ${FPM_PM_START_SERVERS}|i" /etc/php5/php-fpm.conf && \
    sed -i "s|pm.min_spare_servers =.*|pm.min_spare_servers = ${FPM_PM_MIN_SPARE_SERVERS}|i" /etc/php5/php-fpm.conf && \
    sed -i "s|pm.max_spare_servers =.*|pm.max_spare_servers = ${FPM_PM_MAX_SPARE_SERVERS}|i" /etc/php5/php-fpm.conf && \
    sed -i "s|pm.max_requests =.*|pm.max_requests = ${FPM_PM_MAX_REQUESTS}|i" /etc/php5/php-fpm.conf && \
    sed -i "s|pm.max_requests =.*|pm.max_requests = ${FPM_PM_MAX_REQUESTS}|i" /etc/php5/php-fpm.conf && \
    sed -i "s|user =.*|;user = wwwuser|i" /etc/php5/php-fpm.conf && \
    sed -i "s|group =.*|;group = wwwuser|i" /etc/php5/php-fpm.conf && \
    sed -i "s|;*extension=.*|extension=xcache.so|i" /etc/php5/conf.d/xcache.ini && \
    sed -i "s|xcache.size =.*|xcache.size = ${XCACHE_SIZE}|i" /etc/php5/conf.d/xcache.ini && \
    sed -i "s|xcache.var_size =.*|xcache.var_size = ${XCACHE_VAR_SIZE}|i" /etc/php5/conf.d/xcache.ini && \
    rm -rf /tmp/* \
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
