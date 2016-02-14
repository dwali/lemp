#!/bin/bash

service php5-fpm restart
service nginx restart
tail -f /var/log/nginx/error.log
# nginx -g "daemon off;"
