#!/bin/bash


sudo /usr/bin/pdns_control show \* |
 tr ',' '\n' |
 awk '/latency|cache|answers|queries/ { gsub(/=/," ",$ 0); print "- pdns."$ 0 }' | 
 /usr/bin/zabbix_sender -c /etc/zabbix/agentd.conf -r -i - 
