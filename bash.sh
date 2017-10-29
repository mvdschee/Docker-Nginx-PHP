#!/bin/bash

# Extra step just to be sure
echo "Changing owner of website"
chown container:container /var/www/app -R

#ssl configuration
if [ "$VIRTUAL_PROTO" = https ]; then
  sed -i "s|    ssl_certificate /etc/nginx/cert/localhost/fullchain.pem;|    ssl_certificate /etc/nginx/cert/${VIRTUAL_HOST}/fullchain.pem;|" /etc/nginx/conf.d/default.conf
  sed -i "s|    ssl_certificate_key /etc/nginx/cert/localhost/privkey.pem;|    ssl_certificate_key /etc/nginx/cert/${VIRTUAL_HOST}/privkey.pem;|" /etc/nginx/conf.d/default.conf
  sed -i "s|    ssl_trusted_certificate /etc/nginx/cert/localhost/chain.pem;|    ssl_trusted_certificate /etc/nginx/cert/${VIRTUAL_HOST}/chain.pem;|" /etc/nginx/conf.d/default.conf
else
  echo "Nothing to configure"
fi
