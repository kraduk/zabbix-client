#!/usr//bin/perl -w
#
#  Arranged by LenR, 09/09/2010, stolen from a google search (that admitted it was also stolen) and modified for zabbix
#
use Data::Dumper;
$command = '/usr/sbin/nfsstat -3';
#$zs = 'echo /usr/bin/zabbix_sender -v -z 10.44.19.38 -p 10051 -c /etc/zabbix/zabbix_agentd.conf -k znfs3c.';

my  @output = `$command`;

  $res{totcalls} = $output[0]; # First line contains total calls
  $res{totcalls} =~ s/Version 3\D+(\d+)\D+/$1/g;
  $line = 1;
  while($line < $#output)
  {
  @fields = split /\s+/,$output[$line]; # First field names on one line
  $output[$line+1] =~ s/\d+%//g; # Get rid of percentage values
  @values = split /\s+/,$output[$line+1]; # On next line field values
  for($field=0;$field <= $#fields;$field++)
  {
#  print "$zs$fields[$field] -o $values[$field]\n";
#  $rc = system("$zs$fields[$field] -o $values[$field]\n");
  print "- znfs3c.$fields[$field] $values[$field]\n";
  $res{$fields[$field]} = $values[$field];
  }
  $line+=2;
  }

