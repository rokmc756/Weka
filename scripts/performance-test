
[ On Weka Nodes ]
weka stats list-types --show-internal
weka stats realtime -s cpu

* python
watch ‘weka stats realtime -s -cpu -v’

* WEKA BE – Compute Throughput & Utilization**
watch "weka stats realtime -s -cpu -v | grep COMPUTE"

* WEKA BE – Drive Throughput & CPU**
watch "weka stats realtime -s -cpu -v | grep DRIVE"

* WEKA BE – Front End Throughput**
watch "weka stats realtime -s -cpu -v | grep FRONTEND"

* WEKA Client – Front End Throughput**
watch "weka stats realtime -s -cpu -v -F mode=client"

weka stats --stat ops.READ_BYTES,ops.WRITE_BYTES --interval 600 --start-time -1w

[ On clients ]
- Write
fio --name=1m --size=1G --rw=write --ioengine=posixaio --direct=1 --filename_format="/mnt/weka/FIO\$jobnum" --nrfiles=1 --iodepth=1 --time_based --runtime=150 --numjobs=32 --bs=1m
fio --name=1m --size=1G --rw=write --ioengine=posixaio --direct=1 --filename_format="/mnt/weka/FIO\$jobnum" --nrfiles=1 --iodepth=1 --time_based --runtime=150 --numjobs=64 --bs=1m

fio --name=1m --size=1G --rw=write --ioengine=posixaio --direct=1 --filename_format="/mnt/weka/FIO\$jobnum" --nrfiles=1 --iodepth=1 --time_based --runtime=150 --numjobs=64 --bs=1m
fio --name=1m --size=1G --rw=write --ioengine=posixaio --direct=1 --filename_format="/mnt/weka/FIO\$jobnum" --nrfiles=1 --iodepth=1 --time_based --runtime=150 --numjobs=32 --bs=1m

- Read
fio --name=1m --size=1G --rw=read --ioengine=posixaio --direct=1 --filename_format="/mnt/weka/FIO\$jobnum" --nrfiles=1 --iodepth=1 --time_based --runtime=150 --numjobs=32 --bs=1m
fio --name=1m --size=1G --rw=read --ioengine=posixaio --direct=1 --filename_format="/mnt/weka/FIO\$jobnum" --nrfiles=1 --iodepth=1 --time_based --runtime=150 --numjobs=32 --bs=1m

fio --name=1m --size=1G --rw=read --ioengine=posixaio --direct=1 --filename_format="/mnt/weka/FIO\$jobnum" --nrfiles=1 --iodepth=1 --time_based --runtime=150 --numjobs=64 --bs=1m

