#
# Installs a lot of dependencies for Composer, and PHP in general.
#

FROM php:7.1

# Add a lot of stuff to the installation, so we can install the PHP dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget bzip2 \
    zip unzip \
    sqlite3 \
    libcurl4-gnutls-dev \
    libsqlite3-0 libsqlite3-dev \
    libxml2 libxml2-dev \
    libxslt1.1 libxslt1-dev \
    libzip2 libzip-dev \
    zlib1g-dev

RUN docker-php-ext-install \
    curl mbstring xml json zip \
    pdo pdo_sqlite \
    dom simplexml

COPY bin/install-composer.sh /sbin/install-composer
RUN /sbin/install-composer

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
