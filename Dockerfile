FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y apache2 curl unzip git software-properties-common && \
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && \
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/apache2 && \
    apt-get update && \
    apt-get -y install php5.6 php5.6-sqlite php5.6-mbstring php5.6-dom php5.6-xml php5.6-simplexml php5.6-gd && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && \
    a2enmod ssl && \
    curl -sS https://getcomposer.org/installer | php -- --filename=/usr/local/bin/composer

RUN cd /var/www \
    && rm -rf /var/www/html \
    && git clone https://github.com/kanboard/kanboard.git \
    && mv kanboard html \
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
