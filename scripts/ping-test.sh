for i in `seq 1 9`
do

    sudo ping -c 1 192.168.0.17$i
    sudo ping -c 1 192.168.1.17$i
    sudo ping -c 1 192.168.1.18$i
    sudo ping -c 1 192.168.1.19$i
    sudo ping -c 1 192.168.1.20$i
    sudo ping -c 1 192.168.1.21$i

done
