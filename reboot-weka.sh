#!/bin/bash

root_pass="changeme"

for i in $(seq 1 5)
do

    sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@192.168.1.21$i "reboot"

done

