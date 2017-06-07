#!/bin/bash

APPURL=''
sed -i "s|    server_name localhost;|    server_name ${APPURL};|" /etc/nginx/sites-available/non-ssl.conf
sed -i "s|    server_name localhost;|    server_name ${APPURL};|" /etc/nginx/sites-available/ssl.conf
