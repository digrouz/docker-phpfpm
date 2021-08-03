# docker-phpfpm
Install php-fpm into a Linux container

![php](https://php.net/images/logo.php)

## Description

PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation with some additional features useful for sites of any size, especially busier sites.

These features include:
* Adaptive process spawning (NEW!)
* Basic statistics (ala Apache's mod_status) (NEW!)
* Advanced process management with graceful stop/start
* Ability to start workers with different uid/gid/chroot/environment and different php.ini (replaces safe_mode)
* Stdout & stderr logging
* Emergency restart in case of accidental opcode cache destruction
* Accelerated upload support
* Support for a "slowlog"
* Enhancements to FastCGI, such as fastcgi_finish_request() - a special function to finish request & flush all data while continuing to do something time-consuming (video converting, stats processing, etc.)
... and much more.

It was not designed with virtual hosting in mind (large amounts of pools) however it can be adapted for any usage model.


http://php.net/manual/en/install.fpm.php

## Usage

    docker create --name=php-fpm  \
      -v /etc/localtime:/etc/localtime:ro \
      -v <path to webroot>:/www \
      -v <path to fpm config>:/etc/php5/fpm.d \
      -v <path to fpm logs>:/var/log/php5 \
      -e DOCKUID=<UID default:10001> \
      -e DOCKGID=<GID default:10001> \
      -e DOCKMAIL=<mail address> \
      -e DOCKRELAY=<smtp relay> \
      -e DOCKMAILDOMAIN=<originating mail domain> \
      -p 9000:9000 digrouz/docker-phpfpm
      
## Environment Variables

When you start the `php-fpm` image, you can adjust the configuration of the `php-fpm` instance by passing one or more environment variables on the `docker run` command line.

### `DOCKUID`

This variable is not mandatory and specifies the user id that will be set to run the application. It has default value `10001`.

### `DOCKGID`

This variable is not mandatory and specifies the group id that will be set to run the application. It has default value `10001`.

### `DOCKRELAY`

This variable is not mandatory and specifies the smtp relay that will be used to send email. Do not specify any if mail notifications are not required.

### `DOCKMAIL`

This variable is not mandatory and specifies the mail that has to be used to send email. Do not specify any if mail notifications are not required.

### `DOCKMAILDOMAIN`

This variable is not mandatory and specifies the address where the mail appears to come from for user authentication. Do not specify any if mail notifications are not required.


