for i in `seq 1 1`
do
    ssh root@192.168.1.21$i "mount -l | grep -E 'nfs|smb|wekafs'"
done

# for i in `find ./ -name "*2023-03-21*.csv"`; do grep --with-filename -E 'FATAL\:|ERROR\:' $i; done

