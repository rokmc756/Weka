#!/bin/bash
#

arr=( 192.168.0.141 192.168.0.141 192.168.0.141 192.168.0.141 192.168.0.141 )

for backend_ip in "${arr[@]}"
do
	echo "$backend_ip"
	ssh root$backend_ip "sudo umount /mnt/weka"
done

