FROM nginx
MAINTAINER ChengWei <chengwei@theqwan.com>


COPY nginx-start.sh /nginx-start.sh

CMD ["bash", "/nginx-start.sh"]