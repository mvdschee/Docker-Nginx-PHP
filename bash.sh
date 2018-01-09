#!/bin/bash

# Extra step just to be sure
echo "Changing owner of website"
chown container:container /var/www/app -R

# Split VIRTUAL_HOST in to multiple items if it is set up this way
IFS=',' read -r -a array <<< ${VIRTUAL_HOST}

#ssl configuration
if [ "$VIRTUAL_PROTO" = https ]; then
  echo "https for people with sensitive skin"
  mv /etc/nginx/https.conf /etc/nginx/conf.d/default.conf
  sed -i "s|    ssl_certificate /etc/nginx/certs/localhost/fullchain.pem;|    ssl_certificate /etc/nginx/certs/${array[0]}/fullchain.pem;|" /etc/nginx/conf.d/default.conf
  sed -i "s|    ssl_certificate_key /etc/nginx/certs/localhost/key.pem;|    ssl_certificate_key /etc/nginx/certs/${array[0]}/key.pem;|" /etc/nginx/conf.d/default.conf
  sed -i "s|    ssl_trusted_certificate /etc/nginx/certs/localhost/chain.pem;|    ssl_trusted_certificate /etc/nginx/certs/${array[0]}/chain.pem;|" /etc/nginx/conf.d/default.conf
else
  echo "https not enabled"
  mv /etc/nginx/http.conf /etc/nginx/conf.d/default.conf
fi
