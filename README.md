# Docker-nginx

FROM Official build of Nginx.

customize /etc/nginx/nginx.conf, /etc/nginx/conf.d/default.conf.

##### Use:

    docker run -p 8000:80 -v /path/to/file:/path/to/file -e NGINX_SITE_ROOT=/path/to/file --link php-fpm_5.2:phpfpm -d chengweisdocker/docker-nginx:phpfpm

