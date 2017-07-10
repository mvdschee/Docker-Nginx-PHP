# NGINX PHP7.0

### In Short
This image is optimized for use with any basic **PHP7.0** website
+ **Nginx** as a fast and efficient webserver.
+ **PHP-FPM** as the FastCGI engine.
+ **Pushion** as the minimal Linux container for this image.
+ **Let's Encrypt** as the certificate authority.

### Usage
**Only works with Docker-Compose**
This is a second stage image and should be used to build the final image for production/development.

### Dockerfile

+ Define the base image as **maxvanderschee/base**, an excellent minified Ubuntu 16.04 LTS Docker container.
+ Install and update the core components for this new container like Nginx, PHP-FPM, Certbot.
+ Setup PHP-FPM, Nginx.
+ Expose Volumes and ports.

### Updated
10 july 2017
