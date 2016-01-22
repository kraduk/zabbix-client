#!/bin/bash


/usr/sbin/unbound-control stats_noreset | gawk -F= '

BEGIN { a=b=0 }

/^histogram.000000.000001/  { 
	for ( i=0 ; i<17; i++ ) 
	{  
		a+=$NF 
		getline 
	} 
	print "- unbound.histogram.less.16",a 
}

/histogram.000000.131072/,/histogram.000004/ { 
        gsub(/histogram./,"",$1)
	print "- unbound.histogram["$ 1"]", $NF 
}

/histogram\.000008/ { 
	for ( i=0 ; i<16; i++ ) 
	{  
		b+=$2
		getline 
	}
	print "- unbound.histogram.more.8s", b 
}

/^(unwanted|num|total|mem)/ { 
	print "- unbound."$ 1, $ 2
}

/^thread[0-9]+.num.queries/ {
        gsub(/thread/,"",$1)
        gsub(/.num.queries/,"",$1)
	print "- unbound.thread.num.queries["$1"]", $2
}
 
/^thread[0-9]+.recursion.time.median/ {
        gsub(/thread/,"",$1)
        gsub(/.recursion.time.median/,"",$1)
	print "- unbound.recursion.time.median["$1"]", $2
}'
