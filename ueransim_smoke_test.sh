#!usr/bin/env bash

echo ip addr
ping -I uesimtun0 -c 1 google.com 
# traceroute -i uesimtun0 google.com
curl --interface uesimtun0 https://www.google.com

if  [ $? -eq 0 ]
then
   echo "successful test"
   exit
else
   echo "test failed" 
fi
