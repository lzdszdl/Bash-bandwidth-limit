#!/bin/bash
el=0;
gtkbps=0;
grkbps=0;
count=0;
netlimit=$1;

if [[ -z "$1" ]]; then
	echo
  echo e.g. $0 6
  echo
  exit
fi


while true 
do
	grkbps=$(cat usage.txt | awk 'NR%2==0 { print }');
	if [[ $grkbps -eq 0 ]]
	then
		echo "here is the usual suspect"
		continue
	fi
	limit=$(( $grkbps / 1024 ))
	if [[ $limit -ge $netlimit ]]
	then
		espeak  "Reaching your bandwdidth limit" &> /dev/null;
		sleep 1;
		echo "Your current total bandwidth usage=$limit MB."
		sleep 1
		clear;
	else
		echo "Your current total bandwidth usage=$limit MB:$grkbps KB: and Limit is $netlimit"
		sleep 1;
		clear;
	fi
done
