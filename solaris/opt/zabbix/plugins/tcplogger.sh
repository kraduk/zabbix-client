#!/bin/bash

. /etc/profile

netstat -an | awk  '{if ( $4 !~ /.*(22|80|443)$/ && $6 ~ /(ESTABLISHED|TIME_WAIT|FIN_WAIT).*/ &&  $1 == "tcp" &&  $5 !~ /.*(127.0.0.1|10.44.19.(3|5)8).*/ ) print  $5}'  | sort -u > /var/log/tcp.log


