#!/bin/bash

if [ "$1" = "-w" ] && [ "$2" -gt "0" ] && [ "$3" = "-c" ] && [ "$4" -gt "0" ]; then
	# Total bandwidth average in last 2/10/40 seconds, in 6/7/8 field 
	OUTPUT=`/usr/lib64/nagios/plugins/speedtest.py --bytes` 
	[[ "$5" = "-d" ]]&&echo -e "DEBUG:	|$OUTPUT| \n$Download|$Upload" 

	# Grep download and upload speed, where it is always in Mbit/s, and convert to Kbit/s
	Download=`python -c "print \`echo "$OUTPUT"|grep Mbyte|head -1|awk {'print $2'}\` * 1000"|cut -d. -f1`
	Upload=`python -c "print \`echo "$OUTPUT"|grep Mbyte|tail -1|awk {'print $2'}\` * 1000"|cut -d. -f1`



	[[ "$5" = "-d" ]]&&echo "DEBUG:	$Download|$Upload" 
        if [ "$Download" -le "$4" ]; then
                echo "CRITICAL! Speedtest.net Download: $Download KByte/s, Upload: $Upload KByte/s|Speedtest.net=$Download KB;;;; $Upload KB;;;;"
                exit 2
        elif [ "$Download" -le "$2" ]; then
                echo "WARNING! Speedtest.net Download: $Download KByte/s, Upload: $Upload KByte/s|Speedtest.net=$Download KB;;;; $Upload KB;;;;"
                exit 1
        else
                echo "OK! Speedtest.net Download: $Download KByte/s, Upload: $Upload KByte/s|Speedtest.net=$Download KB;;;; $Upload KB;;;;"
                exit 0
        fi
else		# If inputs are not as expected, print help. 
	sName="`echo $0|awk -F '/' '{print $NF}'`"
        echo -e "\n\n\t\t### $sName Version 2.0###\n"
        echo -e "# Usage:\t$sName -w <warnlevel> -c <critlevel>"
        echo -e "\t\t= warnlevel and critlevel is percentage value without %\n"
	echo "# EXAMPLE:\t/usr/lib64/nagios/plugins/$sName -w 1000 -c 1500"
        echo -e "\nBy Nestor 2015\n\n"
        exit 3
fi
