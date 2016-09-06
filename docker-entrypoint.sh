#!/bin/sh
set -e
local MYUSER="wwwuser"
local MYGID="10001"
local MYUID="10001"

#Managing group
if [ -n "${DOCKGID}" ]; then
  MYGID="${DOCKGID}"
fi
if ! /bin/grep -q "${MYUSER}" /etc/group; then
  /usr/sbin/addgroup -S -g "${MYGID}" "${MYUSER}"
fi

#Managing user
if [ -n "${DOCKUID}" ]; then
  MYUID="${DOCKUID}"
fi
if ! /bin/grep -q "${MYUSER}" /etc/passwd; then
  /usr/sbin/adduser -S -D -H -G "${MYUSER}" -u "${MYUID}" "${MYUSER}"
fi

if [ "$1" = 'php-fpm' ]; then
    exec /sbin/su-exec "${MYUSER}" /usr/bin/php-fpm --fpm-config /etc/php5/php-fpm.conf -F "$@"
fi

exec "$@"
