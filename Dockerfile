FROM ubuntu
MAINTAINER nicolas.caen@gmail.com

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update \
  && apt install -y tzdata \
  && apt install -y apache2 \
  && apt install -y php7.2 \
  && apt-get clean

COPY 000-default.conf /etc/apache2/sites-enabled/

EXPOSE 80
COPY site/ /var/www/
RUN chmod 777 -R /var/www/storage/
WORKDIR /var/www/
RUN php artisan optimize

CMD /usr/sbin/apache2ctl -D FOREGROUND