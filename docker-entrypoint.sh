#!/bin/bash

/usr/bin/php /var/www/artisan migrate
/usr/sbin/apache2ctl -D FOREGROUND