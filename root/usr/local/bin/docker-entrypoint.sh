#!/usr/bin/env bash

. /etc/profile
. /usr/local/bin/docker-entrypoint-functions.sh

MYUSER="${APPUSER}"
MYUID="${APPUID}"
MYGID="${APPGID}"

ConfigureUser
ConfigureSsmtp

if [ "$1" = 'php-fpm' ]; then
  DockLog "Fixing permissions on /var/www/html/default"
  chown -R "${MYUSER}" /var/www/html/default
  RunDropletEntrypoint
  DockLog "Loading custom environment"
  . /etc/profile
  DockLog "Starting app: ${1}"
  php-fpm -O -F
else
  DockLog "Running command: ${@}"
  exec "$@"
fi