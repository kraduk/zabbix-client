#!/bin/bash

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/home/cscott/bin


suf=`date '+%s'`
fn=/tmp/zabbix-ns.$suf


netstat -anp  > $fn

# outbound

awk '  { 
 if ( $6 == "ESTABLISHED" && $7 ~ /.+\/httpd/ &&  $4 ~ /(212.74.99.1|10.44.10.1)(17|18|19|20)/ && $ 5 !~ /127.0.0.1/ ) 
   {
    print $ 5
   }
  }'  $fn  | 
  sed -e "s/::ffff://" -e "s/:.*//"  | 
  sort -n  | 
  grep "[0-9]" | 
  uniq -dc | 
  sort -rn |  
  head -5 | 
  awk '
    BEGIN { 
      a=1;
     } 
    { 
      print "- tcp.topx.out[httpd," a "] " $1; 
      a++;
    } 
   END { 
    for (; a <= 5; a++)
      {
        print "- tcp.topx.out[httpd,"a"] 0";
      } 
  }'


# inbound 

awk '{ 
  if (  $6 == "ESTABLISHED" && $7 ~ /.+\/httpd/ &&  $4 ~ /212.74.99.11(6|50)/ && $ 5 !~ /127.0.0.1/ ) 
   {
     print $ 5
   } 
  }'  $fn | 
  sed -e "s/::ffff://" -e "s/:.*//"  | 
  sort -n  | 
  grep "[0-9]" |
  uniq -dc | 
  sort -nr | 
  head -5 | 
  awk '
   BEGIN { 
      a=1;
     } 
     {
      print "- tcp.topx.in[httpd,"a"] " $1; 
      a++;
     }
   END {
    for (; a <= 5; a++)
      {
        print "- tcp.topx.in[httpd,"a"] 0";
      } 
   }'


# all

awk '{
   if ( $6 == "ESTABLISHED" && $7 ~ /.+\/httpd/   && $ 5 !~ /127.0.0.1/ ) 

    { 
     print $ 5
    }
  }' $fn | 
  sed -e "s/::ffff://" -e "s/:.*//"  | 
  sort -n  |  
  grep "[0-9]" | 
  uniq -dc | 
  sort -rn | 
  head -5 |
  awk '
   BEGIN {
      a=1;
     }
     {
      print "- tcp.topx[httpd,"a"] " $1;
      a++;
     }
   END {
    for (; a <= 5; a++)
      {
        print "- tcp.topx[httpd,"a"] 0";
      }
   }'


awk 'BEGIN {
     a = 0 ;
     }
     {
       if ( $ 5 ~ /62.24.248.129:(443|80)/ && $ 6 == "ESTABLISHED" ) 
        a++;
     }
     END {
      print "- net.tcp.established.outgoing.num[ipusage] " a;
    }' $fn


awk 'BEGIN {
     a = 0 ;
     }
     {
       if ( $ 5 ~ /:5190/ && $ 6 == "ESTABLISHED" ) 
        a++;
     }
     END {
      print "- net.tcp.established.outgoing.num[5190] " a;
    }' $fn

awk 'BEGIN {
     a = 0 ;
     }
     {
       if ( $ 5 ~ /:9051/ &&  $ 6 == "ESTABLISHED" ) 
         a++;
     }
     END {
      print "- net.tcp.established.outgoing.num[9051] " a;
    }' $fn

# webservices.opalonline.co.uk
awk 'BEGIN {
     a = 0 ;
     }
     {
       if ( $ 5 ~ /62.24.248.131:(443|80)/ && $ 6 == "ESTABLISHED" ) 
        a++;
     }
     END {
      print "- net.tcp.established.outgoing.num[webservices_opal] " a;
    }' $fn

# selfcare.webservices.opalonline.co.uk
awk 'BEGIN {
     a = 0 ;
     }
     {
       if ( $ 5 ~ /62.24.248.160:(443|80)/ && $ 6 == "ESTABLISHED" ) 
        a++;
     }
     END {
      print "- net.tcp.established.outgoing.num[selfcare_opal] " a;
    }' $fn


rm $fn

