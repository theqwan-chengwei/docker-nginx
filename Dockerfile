FROM nginx
MAINTAINER ChengWei <chengwei@theqwan.com>

# disable https
RUN rm /etc/nginx/conf.d/example_ssl.conf

COPY nginx-start.sh /nginx-start.sh

CMD ["bash", "/nginx-start.sh"]