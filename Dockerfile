FROM debian:bullseye-slim
USER root
RUN echo "deb http://ftp.fi.debian.org/debian/ bullseye main non-free" > /etc/apt/sources.list.d/ftp.fi.debian.org.list && \
apt update && apt upgrade -y \
&& apt install nginx -y && apt clean \
&& rm -rf /var/www/* \
&& mkdir -p /var/www/company.com/img/
COPY ./index.html /var/www/company.com/
ADD ./img.jpg /var/www/company.com/img/
RUN useradd yar && groupadd bar \
&& usermod -a -G bar yar \
&& chmod -R 754 /var/www/company.com/ \
&& chown -R yar:bar /var/www/company.com/ && \
sed -i 's/var\/www\/html/\/var\/www\/company.com/g' /etc/nginx/sites-enabled/default &&\
sed -i 's/user www-data;/user  yar;/g' /etc/nginx/nginx.conf
ENTRYPOINT ["nginx", "-g", "daemon off;"]