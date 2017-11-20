# NGINX PHP7.0

### In Short
This image is optimized for use with any basic **PHP7.0** website
+ **Nginx** as a fast and efficient webserver.
+ **PHP-FPM** as the FastCGI engine.
+ **Pushion** as the minimal Linux container for this image.

### Usage
**Only works with Docker-Compose**
This is a second stage image and should be used to build the final image for production/development.

In the final build stage make sure you added a `security.conf` with in the snippets folder in NGINX.
this file contains thinks like hide .files and file type you don't want people to look at.

### Dockerfile

+ Define the base image as **maxvanderschee/base**, an excellent minified Ubuntu 16.04 LTS Docker container.
+ Install and update the core components for this new container like Nginx, PHP-FPM.
+ Setup PHP-FPM, Nginx.
+ Expose Volumes and ports.
