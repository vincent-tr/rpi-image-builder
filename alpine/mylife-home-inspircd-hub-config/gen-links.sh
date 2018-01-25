#!/bin/sh

cat /etc/inspircd/links.list | while read -r host
do
  echo "<link name=\"$host.&networkname;\" ipaddr=\"$host.&networkname;\" port=\"7000\" allowmask=\"*\" timeout=\"60\" sendpass=\"password\" recvpass=\"password\">"
done
