#!bin/bash

cat <<END > /etc/nginx/conf.d/default.conf

server {
        listen 80 default_server;

        server_name localhost;

        # Useful logs for debug.
        error_log       /var/log/nginx/error.log;
        rewrite_log     on;

        root path;
        index index.php;

        # PHP FPM configuration.
        location ~* \.php$ {
               fastcgi_pass                    127.0.0.1:9000;
               fastcgi_index                   index.php;
               fastcgi_split_path_info         ^(.+\.php)(.*)$;
               include                         /etc/nginx/fastcgi_params;
               fastcgi_param                   SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        }
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

if [ -z "$PHPFPM_PORT_9000_TCP_ADDR" ]; then
	echo >&2 '  Docker run php-fpm first , then --link php-fpm:phpfpm '
	exit 1
fi

sed -i 's/127.0.0.1:9000/'$PHPFPM_PORT_9000_TCP_ADDR':'$PHPFPM_PORT_9000_TCP_PORT'/g' /etc/nginx/conf.d/default.conf

SITE_ROOT=$(echo $NGINX_SITE_ROOT | sed 's/[\/&]/\\&/g')

sed -i 's/root path/root '$SITE_ROOT'/g' /etc/nginx/conf.d/default.conf


/usr/sbin/nginx -g 'daemon off;'