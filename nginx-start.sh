#!bin/bash

cat <<END > /etc/nginx/conf.d/default.conf

server {
        listen 80 default_server;

        server_name localhost;

        # Useful logs for debug.
        error_log       /var/log/nginx/error.log;
        rewrite_log     on;

        root path;
        index index.html index.htm index.php;
}
END

cat <<END > /etc/nginx/nginx.conf
	user  nginx;
	worker_processes  1;

	pid        /var/run/nginx.pid;

	events {
	    worker_connections  1024;
	}

	http {
	    include       /etc/nginx/mime.types;
	    default_type  application/octet-stream;

	    sendfile       on;
	    tcp_nopush     on;
	    tcp_nodelay    on;

	    keepalive_timeout  65;

	    gzip on;
		gzip_disable "msie6";
		gzip_min_length 256;
		gzip_comp_level 4;
		gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

	    include /etc/nginx/conf.d/*.conf;
}
END

if [ -z "$NGINX_SITE_ROOT" ]; then
	echo >&2 '  Did you forget to add -e NGINX_SITE_ROOT=... ?'
	exit 1
fi

sed -i 's/root path/'$NGINX_SITE_ROOT'/g' /etc/nginx/conf.d/default.conf

/usr/sbin/nginx -g 'daemon off;'