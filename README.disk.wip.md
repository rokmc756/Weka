## WIP
# On weka4-master
ssh root@192.168.0.18[1-7] "firewall-cmd --zone=public --add-port=14100/tcp --add-port=14000/tcp --add-port=14050/tcp --permanent --add-port=8501/tcp --permanent && firewall-cmd --reload"

# Added chmod 755 /opt/wekabits/weka-install in ks.cfg
~~~


###########  New way to install  ###############

~~~
[root@localhost ~]# vi split-part.sh
#!/bin/bash
#

if [ $# -eq 0 ]
then
  echo "Input the device"
  exit
fi

dd if=/dev/zero of=/dev/vdb bs=1M

NUM_PARTITIONS=7
PARTITION_SIZE="+1G"

SED_STRING="o"
TAIL="p
w
q
"

NEW_LINE="
"
LETTER_n="n"
EXTENDED_PART_NUM=4
TGTDEV=$1

SED_STRING="$SED_STRING$NEW_LINE"
for i in $(seq $NUM_PARTITIONS)
do
  if [ $i -lt $EXTENDED_PART_NUM ]
  then
    SED_STRING="$SED_STRING$LETTER_n$NEW_LINE$NEW_LINE$NEW_LINE$NEW_LINE$PARTITION_SIZE$NEW_LINE"
  fi
  if [ $i -eq $EXTENDED_PART_NUM ]
  then
    SED_STRING="$SED_STRING$LETTER_n$NEW_LINE$NEW_LINE$NEW_LINE$NEW_LINE"
    SED_STRING="$SED_STRING$LETTER_n$NEW_LINE$NEW_LINE$PARTITION_SIZE$NEW_LINE"
  fi
  if [ $i -gt $EXTENDED_PART_NUM ]
  then
    SED_STRING="$SED_STRING$LETTER_n$NEW_LINE$NEW_LINE$PARTITION_SIZE$NEW_LINE"
  fi
done
SED_STRING="$SED_STRING$TAIL"

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${TGTDEV}
  $SED_STRING
EOF



[root@localhost ~]# chmod 755 split-part.sh

[root@localhost ~]# scp split-part.sh root@xx.xx.xx.xx

[root@localhost ~]# ./split-part.sh /dev/vdb
~~~ snip
Device     Boot    Start      End  Sectors Size Id Type
/dev/vdb1           2048  2099199  2097152   1G 83 Linux
/dev/vdb2        2099200  4196351  2097152   1G 83 Linux
/dev/vdb3        4196352  6293503  2097152   1G 83 Linux
/dev/vdb4        6293504 20971519 14678016   7G  5 Extended
/dev/vdb5        6295552  8392703  2097152   1G 83 Linux
/dev/vdb6        8394752 10491903  2097152   1G 83 Linux
/dev/vdb7       10493952 12591103  2097152   1G 83 Linux
/dev/vdb8       12593152 14690303  2097152   1G 83 Linux



~~~


~~~

[root@localhost ~]# pdsh -w weka4-node0[2-5] "/root/split-part.sh /dev/vdb"

[root@localhost ~]# pdsh -w weka4-node0[1-5] "fdisk -l /dev/vdb"


# On KVH Hosts
[root@lab ~]# vi create-vdisk.sh
#!/bin
#

IMG_DIR="/var/lib/libvirt/images"
IMG_SIZE="2G"

for h in $(seq 1 5)
do
    # echo $host
    for vd in $(echo "vdd vde vdf vdg vdh vdi")
    do
        qemu-img create -f raw $IMG_DIR/weka4-node0$h-ext-vdisk0$h-$vd $IMG_SIZE
        dd if=/dev/zero of=$IMG_DIR/weka4-node0$h-ext-vdisk0$h-$vd bs=1M count=2048 status=progress
        virsh attach-disk weka4-node0$h $IMG_DIR/weka4-node0$h-ext-vdisk0$h-$vd $vd --cache none
    done
done

[root@lab ~]# sh create-vdisk.sh
~~ snip
Formatting '/var/lib/libvirt/images/weka4-node05-ext-vdisk05-vdi', fmt=raw size=2147483648
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 3.05379 s, 703 MB/s
error: Failed to attach disk
error: internal error: No more available PCI slots



[root@localhost ~]# pdsh -w weka4-node0[1-5] "fdisk -l | grep '/dev/vd' | grep -v vda | grep -v vdb | grep -v vdc" | wc -l
~~ snip
weka4-node03: Disk /dev/vdd: 2 GiB, 2147483648 bytes, 4194304 sectors
~~ snip

~~~

~~~

[root@localhost ~]# vi create-one-part.sh
#!/bin/bash
#

for vd in $(echo "vdd vde vdf vdg")
do
    fdisk /dev/$vd <<EOF
n
p
1


w
EOF

done

[root@localhost ~]# scp create-one-part.sh root@192.168.0.184:/root/
[root@localhost ~]# pdsh -w weka4-node0[2-5] "sh /root/create-one-part.sh"
[root@localhost ~]# pdsh -w weka4-node0[2-5] "fdisk -l | grep -v vda | grep -v vdb | grep -v vdc"

~~~


~~~

[root@localhost ~]# cat config-network.sh
#!/bin/bash

# for i in {0..7}
for i in {0..4}
do

    # weka cluster host dedicate weka4-node0$i on
    weka cluster container dedicate $i on

    # add network NICs
    # e.g., weka cluster host net add $i eth1
    # weka cluster host net add $i NETDEV
    weka cluster container net add $i enp1s0

    # add the nvme drives; e.g., /dev/nvme0n1, etc.
    # weka cluster drive add $i /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
    weka cluster drive add $i /dev/vdd1 /dev/vde1 /dev/vdf1 /dev/vdg1

    # Disk /dev/vdd: 2 GiB, 2147483648 bytes, 4194304 sectors
    # Disk /dev/vde: 2 GiB, 2147483648 bytes, 4194304 sectors
    # Disk /dev/vdf: 2 GiB, 2147483648 bytes, 4194304 sectors
    # Disk /dev/vdg: 2 GiB, 2147483648 bytes, 4194304 sectors

    # set host cores
    # weka cluster host cores $i 19 --frontend-dedicated-cores 1 --drives-dedicated-cores 6
    weka cluster container cores $i 1 --frontend-dedicated-cores 1 --drives-dedicated-cores 0

done

[root@localhost ~]# sh config-network.sh
error: The network device enp1s0 is already used on HostId<0>
error: Can not provision /dev/vdd1: Expecting a disk and not a partition

#
[root@localhost ~]# cat partd-create-one-part.sh
#!/bin/bash
#

for vd in $(echo "vdd vde vdf vdg")
do

    dd if=/dev/zero of=/dev/$vd bs=512 count=1
    parted -s -a optimal -- /dev/$vd mkpart primary 1MiB -2048s

done

[root@localhost ~]# sh partd-create-one-part.sh
1+0 records in
1+0 records out
512 bytes copied, 0.00237399 s, 216 kB/s
Error: /dev/vdd: unrecognised disk label
~~ snip

[root@localhost ~]# pdsh -w weka4-node0[2-5] "sh /root/partd-create-one-part.sh"

~~~

~~~
[root@localhost ~]# cat parted-create-one-part.sh
#!/bin/bash
#

for vd in $(echo "vdd vde vdf vdg")
do

    dd if=/dev/zero of=/dev/$vd bs=512 count=1
    # parted /dev/$vd --script -- mkpart primary 0% 100%
    parted -s /dev/$vd mklabel msdos
    parted -s -a optimal -- /dev/$vd mkpart primary 0% 100%

done

[root@localhost ~]# pdsh -w weka4-node0[2-5] "sh /root/parted-create-one-part.sh"
~~ snip
weka4-node02: 512 bytes copied, 0.000486147 s, 1.1 MB/s
weka4-node05: 1+0 records in
weka4-node05: 1+0 records out
weka4-node05: 512 bytes copied, 0.00319784 s, 160 kB/s
weka4-node03: 1+0 records in
weka4-node03: 1+0 records out
weka4-node03: 512 bytes copied, 0.00406354 s, 126 kB/s

[root@localhost ~]# pdsh -w weka4-node0[2-5] "fdisk -l | grep -v vda | grep -v vdb | grep -v vdc"

[root@localhost ~]# sh config-network.sh
error: The network device enp1s0 is already used on HostId<0>
error: Can not provision /dev/vdd1: Expecting a disk and not a partition
~~~


~~~
[root@localhost ~]# cat parted-create-one-part.sh
#!/bin/bash
#

for vd in $(echo "vdd vde vdf vdg")
do

    dd if=/dev/zero of=/dev/$vd bs=512 count=1
    # parted /dev/$vd --script -- mkpart primary 0% 100%
    parted -s /dev/$vd mklabel gpt
    # parted -s -a optimal -- /dev/$vd mkpart primary 0% 100%
    parted -s /dev/$vd unit mib mkpart primary 1 100%
    parted -s /dev/$vd set 1 lvm on

done

pdsh -w weka4-node0[2-5] "sh /root/parted-create-one-part.sh"
weka4-node02: 1+0 records in
weka4-node02: 1+0 records out

[root@localhost ~]# sh config-network.sh
error: Can not provision /dev/vdd1: Expecting a disk and not a partition
~~~

https://access.redhat.com/solutions/2777871
https://blog.christophersmart.com/2019/12/18/kvm-guests-with-emulated-ssd-and-nvme-drives/
https://futurewei-cloud.github.io/ARM-Datacenter/qemu/nvme-of-tcp-vms/
https://blog.frankenmichl.de/2018/02/13/add-nvme-device-to-vm/
https://qemu-project.gitlab.io/qemu/system/devices/nvme.html
https://www.baeldung.com/linux/qemu-from-terminal
https://www.cyberciti.biz/faq/how-to-add-disk-image-to-kvm-virtual-machine-with-virsh-command/
https://blog.vmsplice.net/2011/04/how-to-pass-qemu-command-line-options.html
https://unix.stackexchange.com/questions/495703/qemu-commandline-arguments-to-lib-virt-are-not-accepted-unable-to-save-xml-fil
https://unix.stackexchange.com/questions/235414/libvirt-how-to-pass-qemu-command-line-args
https://qemu-project.gitlab.io/qemu/system/devices/nvme.html
https://forum.proxmox.com/threads/qemu-can-we-add-emulated-nvme-devices-to-guests.78752/
https://github.com/manishrma/nvme-qemu
https://zonedstorage.io/docs/getting-started/zns-device
