FROM ubuntu:latest
MAINTAINER Maxime AUBURTIN <maxime.auburtin@thunderfeather.com>

# We install the required packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y apache2 curl php7.0 php7.0-curl php7.0-xml libapache2-mod-php7.0

# We install Rainloop
RUN cd /var/www && mkdir rainloop && cd rainloop && curl -s http://repository.rainloop.net/installer.php | php
RUN chown -R www-data:www-data /var/www 

# We copy the Apache site configuration
ADD ./config/apache2/999-rainloop.conf /etc/apache2/sites-available
RUN a2dissite 000-default.conf && a2ensite 999-rainloop.conf

# We expose port 80
EXPOSE 80

# We run apache 2 and display log files
CMD service apache2 start && tail -f /var/log/apache2/*.log

