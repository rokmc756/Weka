for i in `seq 1 5`
do
    sudo ping -c 1 192.168.0.14$i
    sudo ping -c 1 192.168.1.14$i
    sudo ping -c 1 192.168.2.14$i
done
