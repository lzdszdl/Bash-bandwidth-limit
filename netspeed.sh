#!/bin/bash
el=0;
gtkbps=0;
grkbps=0;
count=0;
hello=1;
while read usgband
do
	if [[ $count -eq 0 ]]
	then
		gtkbps=$usgband;
		count=$(( $count + 1 ));
		echo "gtkbps:$gtkbps:count:$count";
	else
		echo "entering else.."
		read
		
		grkbps=$usgband;
		echo "grkbps:$grkbps";
	fi
done < usage.txt


if [[ -z "$1" ]]; then
	echo
  echo usage: $0 network-interface
  echo
  echo e.g. $0 eth0
  echo
  exit
fi

#IF=$1

while true
do
	#echo "Entering if loop"
	#read
	if [ ! -f "/sys/class/net/$1/statistics/rx_bytes" ]
	then
		echo "$1:Connection does not exist..."
		echo "Tot TX:$gtkbps ; Tot RX:$grkbps "
		echo $el;
		sleep 1;
		clear;
		el=0;
	else
		el=1;	
	  
		R1=$(cat /sys/class/net/$1/statistics/rx_bytes)
  	T1=$(cat /sys/class/net/$1/statistics/tx_bytes)
    sleep 1
    R2=$(cat /sys/class/net/$1/statistics/rx_bytes)
    T2=$(cat /sys/class/net/$1/statistics/tx_bytes)
    TBPS=$(($T2 - $T1))
    RBPS=$(($R2 - $R1))
    TKBPS=$(($TBPS / 1024))
    RKBPS=$(($RBPS / 1024))
	if [[ $TKBPS -ge 1 ]]
	then
		gtkbps=$(($gtkbps + $TKBPS))
	fi
	if [[ $RKBPS -ge 1 ]]
	then
		grkbps=$(($grkbps + $RKBPS))
	fi
	clear
		echo "$gtkbps" > usage.txt
		echo "$grkbps" >> usage.txt

    echo "tx $1: $TKBPS kb/s rx $1: $RKBPS kb/s"
		echo "GTX total=$gtkbps kb ; GRX total=$grkbps kb"
	fi
done
