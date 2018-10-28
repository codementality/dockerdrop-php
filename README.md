# Dockerdrop PHP 7.2 Image

## Overview
This rep contains the php 7.2 image for DockerDrop built using the official PHP-FPM 7.2 image.

It has Composer version 1.7.2 installed with the Prestissimo plugin for Composer version 0.30.

It also has mhmailsend installed, and PHP is configured to use it for outgoing mail.  This is designed to work with the image `mailhog/mailhog:latest`.

## PHP Extensions

This image contains numerous php extensions including:

* iconv
* gd (configured --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/)
* imap (configured --with-kerberos --with-imap-ssl)
* pdo_mysql
* bcmath
* bz2
* calendar
* gettext
* gmp
* intl
* ldap
* mbstring
* zip
* pcntl
* phar
* recode
* shmop
* soap
* sockets
* sysvmsg
* sysvsem
* sysvshm
* wddx
* opcache
* xsl
* zip

And the following PECL extensions:

* mcrypt (version 1.0.1)
* memcached
* xdebug
