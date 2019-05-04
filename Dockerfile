FROM ubuntu
MAINTAINER nicolas.caen@gmail.com

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update \
  && apt install -y tzdata \
  && apt install -y apache2 \
  && apt install -y php7.2 \
  && apt install -y php-mysql \
  && apt install -y php-mbstring \
  && apt install -y php-dom \
  && apt install -y php-zip \
  && apt install -y curl \
  && apt install -y git \
  && apt install -y unzip \
  && apt-get clean

RUN a2enmod rewrite
COPY 000-default.conf /etc/apache2/sites-enabled/
RUN echo "Listen 8080" >> /etc/apache2/ports.conf
EXPOSE 8080

COPY site/ /var/www/
COPY site/.env.prod /var/www/.env
RUN chmod 777 -R /var/www/storage/

WORKDIR /var/www/

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN /usr/local/bin/composer install

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD /docker-entrypoint.sh