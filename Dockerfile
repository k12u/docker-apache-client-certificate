FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y apache2 php5 php5-sqlite php5-gd curl unzip && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && \
    a2enmod ssl && \
    curl -sS https://getcomposer.org/installer | php -- --filename=/usr/local/bin/composer

RUN cd /var/www \
    && rm -rf /var/www/html \
    && curl -sLO https://github.com/fguillot/kanboard/archive/master.zip \
    && unzip -qq master.zip \
    && rm -f *.zip \
    && mv kanboard-master html \
    && cd /var/www/html && composer --prefer-dist --no-dev --optimize-autoloader --quiet install \
    && chown -R www-data:www-data /var/www/html/data

RUN cd /var/www/html/plugins && \
    curl -sLO https://github.com/kanboard/plugin-client-certificate/archive/master.zip && \
    unzip -qq master.zip && \
    mv plugin-client-certificate-master ClientCertificate && \
    rm -f master.zip

COPY vhosts/default.conf /etc/apache2/sites-enabled/
COPY certs/ /etc/apache2/ssl/

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 443

CMD /usr/sbin/apache2ctl -D FOREGROUND
