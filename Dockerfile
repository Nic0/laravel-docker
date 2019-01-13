FROM ubuntu
MAINTAINER nicolas.caen@gmail.com

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update \
  && apt install -y tzdata \
  && apt install -y apache2 \
  && apt install -y php7.2 \
  && apt install -y php-mysql \
  && apt-get clean

RUN a2enmod rewrite
COPY 000-default.conf /etc/apache2/sites-enabled/

EXPOSE 80
COPY site/ /var/www/
RUN chmod 777 -R /var/www/storage/
WORKDIR /var/www/
RUN php artisan optimize
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD /docker-entrypoint.sh