#!/bin/bash

. /opt/zabbix/plugins/oracle/ora.env 

export ORACLE_BASE ORACLE_HOME ORACLE_SID PATH

su oracle -c 'asmcmd ls' | awk 'BEGIN { print "{\"data\":[" }  { gsub(/\//,"",$1);  if ( p !=NULL ) print "{ \"{#ASM}\":\""p"\" },"  ; p=$1 } END { print "{ \"{#ASM}\":\""$0"\"}\n]}"  }'
