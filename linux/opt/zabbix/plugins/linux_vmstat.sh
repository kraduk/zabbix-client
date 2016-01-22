#!/bin/bash

/usr/bin/vmstat  1 $(( $1 + 1 )) | tail -$1 | awk "{ a+=$ 1; b+=$ 2 } END { print \"- vm.runq  \" a/$1 \"\n- vm.blockq \"  b/$1 \"\n\" }"


