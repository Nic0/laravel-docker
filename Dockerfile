FROM composer:1.6.5 as build
WORKDIR /app
COPY site /app
RUN composer install

FROM php:7.2-apache
RUN docker-php-ext-install pdo pdo_mysql

EXPOSE 8080
COPY --from=build /app /var/www/
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY site/.env.prod /var/www/.env
RUN chmod 777 -R /var/www/storage/
RUN echo "Listen 8080" >> /etc/apache2/ports.conf
RUN chown -R www-data:www-data /var/www/ \
    && a2enmod rewrite