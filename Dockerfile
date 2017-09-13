#
# Installs a lot of dependencies for Composer, and PHP in general.
#

FROM php:7.1

# Add a lot of stuff to the installation, so we can install the PHP dependencies
RUN apt-get update \
    && apt-get install -y \
        git \
        wget bzip2 \
        zip unzip \
        sqlite3 \
        libc6-dev \
        libcurl4-gnutls-dev \
        libsqlite3-0 libsqlite3-dev \
        libxml2 libxml2-dev \
        libmcrypt4 libmcrypt-dev \
        libxslt1.1 libxslt1-dev \
        libzip2 libzip-dev \
        zlib1g-dev \
    && docker-php-ext-install \
        curl mbstring xml json zip \
        pdo pdo_sqlite \
        dom simplexml \
        mcrypt \
    && docker-php-source delete \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install xdebug-2.5.0 \
    && docker-php-ext-enable xdebug

COPY bin/install-composer.sh /sbin/install-composer
RUN /sbin/install-composer

# Add Composer binaries to path
ENV PATH=$PATH:/usr/share/composer/vendor/bin

# Disable interaction globally and forcefully set home
ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_HOME=/usr/share/composer

# Install PHPUnit and PHP_CodeSniffer
RUN composer global require \
    --no-progress --no-suggest \
    phpunit/phpunit \
    squizlabs/php_codesniffer

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
