for i in `seq 1 5`; do ssh root@192.168.17$i "shutdown -h now" ;done
for i in `seq 1 3`; do ssh root@192.168.6$i "shutdown -h now" ;done
ssh root@192.168.0.90 "shutdown -h now"
ssh root@192.168.0.199 "shutdown -h now"