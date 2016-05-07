FROM ubuntu:latest
MAINTAINER Maxime AUBURTIN <maxime.auburtin@thunderfeather.com>

# We update the system
RUN apt-get update && apt-get upgrade -y 

# We install Apache 2 and its dependencies
RUN apt-get install -y apache2 curl php7.0 php7.0-curl php7.0-xml libapache2-mod-php7.0

# We install Rainloop
RUN cd /var/www && mkdir rainloop && cd rainloop && curl -s http://repository.rainloop.net/installer.php | php
RUN chown -R www-data:www-data /var/www 

# We install letsencrypt
# RUN apt-get install git && git clone https://github.com/letsencrypt/letsencrypt && cd letsencrypt && ./letsencrypt-auto --help

# We configure Apache
RUN a2enmod ssl 
RUN a2enmod rewrite
ADD ./config/apache2/999-rainloop.conf /etc/apache2/sites-available
ADD ./config/apache2/998-rainloop-ssl.conf /etc/apache2/sites-available
RUN a2dissite 000-default.conf 
RUN a2ensite 999-rainloop.conf && a2ensite 998-rainloop-ssl.conf

# We expose port 80 and 443
EXPOSE 80 443

# We run apache 2 and display log files
CMD service apache2 restart && tail -f /var/log/apache2/*.log

