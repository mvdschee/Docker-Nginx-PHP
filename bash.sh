#!/usr/bin/env bash
sed -i "s|    server_name localhost;|    server_name ${appname};|" /etc/nginx/sites-available/non-ssl.conf
sed -i "s|    server_name localhost;|    server_name ${appname};|" /etc/nginx/sites-available/ssl.conf
