FROM php:7.2-fpm

MAINTAINER Lisa Ridley "lisa@codementality.com"

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc make autoconf libc-dev pkg-config zlib1g-dev libicu-dev g++ \
    libbz2-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libgmp-dev \
    libpng-dev \
    libc-client-dev libkrb5-dev \
    libldap2-dev \
    librecode-dev \
    libmemcached-dev \
    libxslt-dev \
    libsnmp-dev \
    unzip \
    zip \
    mariadb-client \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-install pdo_mysql bcmath bz2 calendar gettext gmp intl ldap mbstring \
    && docker-php-ext-install zip pcntl phar recode shmop soap sockets sysvmsg sysvsem sysvshm wddx \
    && docker-php-ext-install opcache xsl \
    && docker-php-ext-install zip \
## PECL extensions
    && pecl install mcrypt-1.0.1 \
    && pecl install memcached \
    && pecl install xdebug \
    && rm -rf /var/lib/apt/lists/*

# Register the COMPOSER_HOME environment variable
# Add global binary directory to PATH and make sure to re-export it
# Allow Composer to be run as root
# Composer version
ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_VERSION 1.7.2
ENV COMPOSER_MEMORY_LIMIT=-1

# Setup the Composer installer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
# Install Composer
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && rm -rf /tmp/composer-setup.php \
# Install Prestissimo plugin for Composer -- allows for parallel processing of packages during install / update
    && composer global require "hirak/prestissimo:^0.3"

# Install Mailhog Sendmail support:
RUN apt-get update -qq && apt-get install -yq git golang-go \
    && mkdir -p /opt/go \
    && export GOPATH=/opt/go \
    && go get github.com/mailhog/mhsendmail \
    && rm -rf /var/lib/apt/lists/*

# Add php.ini base file
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Add entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/

# Make sure it's executable
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["php-fpm"]
