#!/bin/bash
. /opt/zabbix/plugins/oracle/ora.env 

su oracle -c "asmcmd ls -l $1/ "



