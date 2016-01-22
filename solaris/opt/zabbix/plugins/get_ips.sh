#!/bin/bash

/sbin/ip addr show | awk '/^[0-9]/ {printf("\n%s ",$ 2)} /inet/ {printf("%s ",$ 2)}'

echo -e "\n"


netstat -rn | awk '{printf("%s\n", $0)}'

