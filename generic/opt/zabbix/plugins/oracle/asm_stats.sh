#!/bin/bash

. /opt/zabbix/plugins/oracle/ora.env 


l=`su oracle -c 'asmcmd ls' | sed -e "s/\///"`


su oracle -c 'asmcmd iostat --suppressheader --io -e -t --region ' | awk '
 {
  print "- asm.iostat.read["$1"_"$2"]", $3 \
	"\n- asm.iostat.write["$1"_"$2"]", $4 \
	"\n- asm.iostat.coldwrite["$1"_"$2"]", $6 \
	"\n- asm.iostat.coldread["$1"_"$2"]", $5 \
	"\n- asm.iostat.hotwrite["$1"_"$2"]", $8 \
	"\n- asm.iostat.hotread["$1"_"$2"]", $7 \
	"\n- asm.iostat.write.error["$1"_"$2"]", $10 \
	"\n- asm.iostat.read.error["$1"_"$2"]", $9 \
	"\n- asm.iostat.read_time["$1"_"$2"]", $11 \
	"\n- asm.iostat.write_time["$1"_"$2"]", $12 \

}'
su oracle -c 'asmcmd lsdg --suppressheader'  | awk '{ gsub(/\//,"",$NF); print "- asm.total["$NF"]", $7"\n- asm.free["$NF"]", $8}'

for a in `echo $l`
do
su oracle -c "asmcmd du --suppressheader $a" | 
	 awk "BEGIN { p=0} 
	{  print \"- asm.usage[$a]\", $ 1 ; p=1 } 
	END {if ( p == 0 ) print \"- asm.usage[$a] 0 \" } "




done

