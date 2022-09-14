#!/bin/bash
#$1 - IP address - 192.168.0.10 or 192.168.0.11
#$2 - port 3333 or 3334
#$3 - ptyUSBx

#check if needed sudo is used
if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi
for i in {0..20}
do
#   ls /dev/ptyUSB$i
   if [ -e !/dev/ptyUSB$i ] ; then {
        echo $i
   }
    else {
     break
    }
    fi

done
echo "first free port"
echo $i

socat -d -d pty,link=/dev/ptyUSB$i,mode=777,waitslave,ignoreeof,b115200,echo=0,raw TCP:$1:5001,forever &
#store pid number of socat process, will be killed once read terminal will be closed
last_pid=$!

gnome-terminal --wait -e "cat /dev/$3" -t "COM read "$1":"$2 --hide-menubar
#close used socat connection
sudo kill -KILL $last_pid
