#!/bin/bash

. /opt/zabbix/plugins/oracle/ora.env 

export ORACLE_BASE ORACLE_HOME ORACLE_SID PATH

su oracle -c 'asmcmd iostat' | awk 'BEGIN { print "{\"data\":[" }  { gsub(/\//,"",$1);  if ( p !=NULL ) print "{ \"{#ASM_IO}\":\""p"\" },"  ; p=$1"_"$2 } END { print "{ \"{#ASM_IO}\":\""$1"_"$2"\"}\n]}"  }'
