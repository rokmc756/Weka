
weka cluster create wk4-worker01 wk4-worker02 wk4-worker03 wk4-worker04 wk4-worker05 --host-ips=192.168.1.141,192.168.1.142,192.168.1.143,192.168.1.144,192.168.1.145 -T infinite
weka cluster host net add  0 eth1 --netmask=24 --gateway=192.168.1.1
weka cluster host net add  1 eth1 --netmask=24 --gateway=192.168.1.1
weka cluster host net add  2 eth1 --netmask=24 --gateway=192.168.1.1
weka cluster host net add  3 eth1 --netmask=24 --gateway=192.168.1.1
weka cluster host net add  4 eth1 --netmask=24 --gateway=192.168.1.1
weka cluster drive add 0 /dev/nvme0n1 /dev/nvme0n2
weka cluster drive add 1 /dev/nvme0n1 /dev/nvme0n2
weka cluster drive add 2 /dev/nvme0n1 /dev/nvme0n2
weka cluster drive add 3 /dev/nvme0n1 /dev/nvme0n2
weka cluster drive add 4 /dev/nvme0n1 /dev/nvme0n2
weka cluster host cores 0 4 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 1 4 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 2 4 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 3 4 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 4 4 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host dedicate 0 on
weka cluster host dedicate 1 on
weka cluster host dedicate 2 on
weka cluster host dedicate 3 on
weka cluster host dedicate 4 on
weka cluster update --data-drives=3 --parity-drives=2
weka cluster hot-spare 0
weka cluster update --cluster-name=scb-weka-clu01
weka cluster host apply --all --force

