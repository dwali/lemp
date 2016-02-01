FROM debian:jessie

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y install git php5 php5-mysql pwgen php5-fpm php5-mcrypt php5-gd vim software-properties-common apt-utils

# install nginx
RUN echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list.d/nginx.list
RUN apt-key adv --fetch-keys "http://nginx.org/keys/nginx_signing.key"
RUN apt-get update && apt-get -y install nginx openssl ca-certificates

# install mariadb server
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
RUN add-apt-repository 'deb [arch=amd64] http://mirror.vpsfree.cz/mariadb/repo/10.1/debian jessie main'
RUN apt-get update && apt-get install -y mariadb-server

# Add image configuration and scripts
#ADD run.sh /run.sh
#RUN chmod 755 /*.sh
ADD mysql_my.cnf /etc/mysql/conf.d/my.cnf

# nginx configuration
ADD nginx_default.conf /etc/nginx/conf.d/default.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
#ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
#RUN chmod 755 /*.sh

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

RUN mkdir /www

# Add volumes for MySQL
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/www" ]

# expose http, https, mysql ports
EXPOSE 80 443 3306

CMD ["nginx", "-g", "daemon off;"]
