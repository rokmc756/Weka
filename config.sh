weka cluster create weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 --host-ips=192.168.219.181,192.168.219.182,192.168.219.183,192.168.219.184,192.168.219.185 -T infinite
weka cluster host net add  0 eth1 --netmask=24 
weka cluster host net add  1 eth1 --netmask=24 
weka cluster host net add  2 eth1 --netmask=24 
weka cluster host net add  3 eth1 --netmask=24 
weka cluster host net add  4 eth1 --netmask=24 
weka cluster drive add 0 /dev/nvme0n1 /dev/nvme0n2
weka cluster drive add 1 /dev/nvme0n1 /dev/nvme0n2
weka cluster drive add 2 /dev/nvme0n1 /dev/nvme0n2
weka cluster drive add 3 /dev/nvme0n1 /dev/nvme0n2
weka cluster drive add 4 /dev/nvme0n1 /dev/nvme0n2
weka cluster host cores 0 5 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 1 5 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 2 5 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 3 5 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 4 5 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host dedicate 0 on
weka cluster host dedicate 1 on
weka cluster host dedicate 2 on
weka cluster host dedicate 3 on
weka cluster host dedicate 4 on
weka cluster update --data-drives=3 --parity-drives=2
weka cluster hot-spare 0
weka cluster update --cluster-name=wclu01
weka cluster host apply --all --force
