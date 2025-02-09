
for i in `seq 1 5`
do

    sudo ping -c 1 192.168.0.17$i
    sudo ping -c 1 192.168.1.17$i
    sudo ping -c 1 192.168.1.18$i
    sudo ping -c 1 192.168.1.19$i
    sudo ping -c 1 192.168.1.20$i
    sudo ping -c 1 192.168.1.21$i


    nc -vz 192.168.0.17$i 22
    nc -vz 192.168.1.17$i 22
    nc -vz 192.168.1.18$i 22
    nc -vz 192.168.1.19$i 22
    nc -vz 192.168.1.20$i 22
    nc -vz 192.168.1.21$i 22


    # ssh-keyscan 192.168.0.17$i >/dev/null 2>&1
    # ssh-keyscan 192.168.1.21$i >/dev/null 2>&1
    # ssh-keyscan 192.168.2.17$i >/dev/null 2>&1

done

