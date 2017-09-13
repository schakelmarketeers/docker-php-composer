#!/usr/bin/env bash

wget -O /tmp/composer-setup.php https://getcomposer.org/installer

EXPECTED_SIGNATURE=$( wget -q -O - https://composer.github.io/installer.sig )
ACTUAL_SIGNATURE=$( sha384sum /tmp/composer-setup.php | awk '{print $1}' )

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm /tmp/composer-setup.php
    exit 1
fi

echo 'Checksums match!'

php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm /tmp/composer-setup.php
