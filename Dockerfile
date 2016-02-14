FROM debian:8.3

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y install git nginx php5 php5-cli php5-mysql pwgen php5-fpm php5-mcrypt php5-gd vim software-properties-common apt-utils wget

# install mariadb server
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
RUN add-apt-repository 'deb [arch=amd64] http://mirror.vpsfree.cz/mariadb/repo/10.1/debian jessie main'
RUN apt-get update && apt-get install -y mariadb-server
ADD mysql_my.cnf /etc/mysql/conf.d/my.cnf

# nginx configuration
RUN rm -rf /etc/nginx/sites-available/* && rm -rf /etc/nginx/sites-enabled/*
ADD nginx_default.conf /etc/nginx/sites-available/default.conf
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

RUN mkdir /www

# Add volumes for MySQL
VOLUME  ["/etc/mysql", "/var/lib/mysql", "/www" ]

# expose http, https, mysql ports
EXPOSE 80 443 3306

ADD run.sh /run.sh
RUN chmod 755 /run.sh

WORKDIR /
CMD ["./run.sh"]
