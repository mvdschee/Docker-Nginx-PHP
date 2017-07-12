FROM maxvanderschee/base

LABEL maintainer "m.v.d.schee@ewake.nl"

# Env
ENV CONF non-ssl.conf
ENV APPURL localhost.nl
ENV SUBAPPURL www.localhost.nl

# Install core packages for nginx and php7.0.
RUN add-apt-repository ppa:certbot/certbot
RUN apt-get update -q
RUN apt-get install -y nginx php7.0 php7.0-fpm certbot
RUN apt-get clean -q && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup nginx config
WORKDIR /etc/nginx/
RUN rm nginx.conf
COPY nginx.conf nginx.conf
COPY non-ssl.conf sites-available/non-ssl.conf
COPY ssl.conf sites-available/ssl.conf

RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/${CONF} /etc/nginx/sites-enabled/${CONF}

# Configure Nginx - enable gzip
RUN sed -i 's|# gzip_types|  gzip_types|' /etc/nginx/nginx.conf

# Setup security to nginx
RUN echo 'fastcgi_param  HTTP_PROXY         "";' >> /etc/nginx/fastcgi.conf
RUN rm /etc/php/7.0/fpm/pool.d/www.conf
COPY www.conf /etc/php/7.0/fpm/pool.d/www.conf

# Setup Php service
RUN mkdir -p /run/php/
RUN touch /run/php/php7.0-fpm.sock
RUN mkdir -p /etc/service/php-fpm
RUN touch /etc/service/php-fpm/run
RUN chmod +x /etc/service/php-fpm/run
RUN echo '#!/bin/bash \n\
    exec /usr/sbin/php-fpm7.0 -F' >> /etc/service/php-fpm/run
RUN echo "opcache.enable=1" >> /etc/php/7.0/fpm/php.ini
RUN echo "cgi.fix_pathinfo=1" >> /etc/php/7.0/fpm/php.ini

# Setup Nginx service
RUN mkdir -p /etc/service/nginx
RUN touch /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run
RUN echo '#!/bin/bash \n\
    exec /usr/sbin/nginx -g "daemon off;"' >>  /etc/service/nginx/run

# Configure nginx file for domain
WORKDIR /root
COPY bash.sh bash.sh
RUN bash /root/bash.sh

# Secure docker form application exploitation
RUN chown container:container /var/www -R

# Setup ssl deployment
RUN openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# Expose configuration and content volumes
VOLUME /etc/letsencrypt/archive /var/www/app

# Public ports
EXPOSE 80 443
