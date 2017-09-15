#!/bin/bash

DIR=/etc/letsencrypt/archive

#non-ssl
echo "Changing non-ssl nginx config"

sed -i "s|    server_name localhost;|    server_name ${APPURL};|" /etc/nginx/sites-available/non-ssl.conf
sed -i "s|    server_name www.localhost;|    server_name ${SUBAPPURL};|" /etc/nginx/sites-available/non-ssl.conf
sed -i "s|    return 301 http://localhost$request_uri;|    return 301 http://${APPURL}$request_uri;|" /etc/nginx/sites-available/non-ssl.conf

#ssl
echo "Changing ssl nginx config"

sed -i "s|    server_name localhost;|    server_name ${APPURL};|" /etc/nginx/sites-available/ssl.conf
sed -i "s|    server_name www.localhost;|    server_name ${SUBAPPURL};|" /etc/nginx/sites-available/ssl.conf
sed -i "s|    server_name localhost www.localhost;|    server_name ${APPURL} ${SUBAPPURL};|" /etc/nginx/sites-available/ssl.conf
sed -i "s|    return 301 https://localhost$request_uri;|    return 301 https://${APPURL}$request_uri;|" /etc/nginx/sites-available/ssl.conf

#extra step just to be sure
echo "Changing owner of website"

chown container:container /var/www/app -R

#ssl configuration
echo "Configure SSL"

if [ "$CONF" = "ssl.conf" ]; then
  echo "ENV SSL true"
  if [ -d "$DIR/$APPURL" ];then
    echo "Cert already there"
    sed -i "s|    ssl_certificate /etc/letsencrypt/live/${APPURL}/fullchain.pem;|    ssl_certificate /etc/letsencrypt/live/${APPURL}/fullchain.pem;|" /etc/nginx/sites-available/ssl.conf
    sed -i "s|    ssl_certificate_key /etc/letsencrypt/live/${APPURL}/privkey.pem;|    ssl_certificate_key /etc/letsencrypt/live/${APPURL}/privkey.pem;|" /etc/nginx/sites-available/ssl.conf
    sed -i "s|    ssl_trusted_certificate /etc/letsencrypt/live/${APPURL}/chain.pem;|    ssl_trusted_certificate /etc/letsencrypt/live/${APPURL}/chain.pem;|" /etc/nginx/sites-available/ssl.conf
  else
    echo "Adding cert"
    letsencrypt certonly -a webroot --webroot-path=/var/www/app -d  ${APPURL} -d ${SUBAPPURL}
    sed -i "s|    ssl_certificate /etc/letsencrypt/live/${APPURL}/fullchain.pem;|    ssl_certificate /etc/letsencrypt/live/${APPURL}/fullchain.pem;|" /etc/nginx/sites-available/ssl.conf
    sed -i "s|    ssl_certificate_key /etc/letsencrypt/live/${APPURL}/privkey.pem;|    ssl_certificate_key /etc/letsencrypt/live/${APPURL}/privkey.pem;|" /etc/nginx/sites-available/ssl.conf
    sed -i "s|    ssl_trusted_certificate /etc/letsencrypt/live/${APPURL}/chain.pem;|    ssl_trusted_certificate /etc/letsencrypt/live/${APPURL}/chain.pem;|" /etc/nginx/sites-available/ssl.conf
  fi
else
  echo "Nothing to configure"
fi
