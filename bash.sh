#!/bin/bash

sed -i "s|    server_name localhost;|    server_name ${APPURL};|" /etc/nginx/sites-available/non-ssl.conf
sed -i "s|    server_name www.localhost;|    server_name ${SUBAPPURL};|" /etc/nginx/sites-available/non-ssl.conf
sed -i "s|    return 301 http://localhost$request_uri;|    return 301 http://${APPURL}$request_uri;|" /etc/nginx/sites-available/non-ssl.conf
sed -i "s|    server_name localhost;|    server_name ${APPURL};|" /etc/nginx/sites-available/ssl.conf
sed -i "s|    server_name www.localhost;|    server_name ${SUBAPPURL};|" /etc/nginx/sites-available/ssl.conf
sed -i "s|    server_name localhost www.localhost;|    server_name ${APPURL} ${SUBAPPURL};|" /etc/nginx/sites-available/ssl.conf
sed -i "s|    return 301 https://localhost$request_uri;|    return 301 https://${APPURL}$request_uri;|" /etc/nginx/sites-available/ssl.conf
