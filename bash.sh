#!/bin/bash

#extra step just to be sure
echo "Changing owner of website"
chown container:container /var/www/app -R
