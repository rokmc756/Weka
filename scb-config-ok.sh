# weka cluster create rk8-node01 rk8-node02 rk8-node03 rk8-node04 rk8-node05 --host-ips=192.168.1.171,192.168.1.212,192.168.1.193,192.168.1.184,192.168.1.215 -T infinite

weka cluster create rk8-node01 rk8-node02 rk8-node03 rk8-node04 rk8-node05 --host-ips=192.168.1.211,192.168.1.212,192.168.1.213,192.168.1.214,192.168.1.215 -T infinite

weka cluster host net add  0 ens193 --ips 192.168.1.171 --netmask=24 
weka cluster host net add  0 ens224 --ips 192.168.1.181 --netmask=24 
weka cluster host net add  0 ens225 --ips 192.168.1.191 --netmask=24 
weka cluster host net add  0 ens256 --ips 192.168.1.201 --netmask=24 
weka cluster host net add  0 ens257 --ips 192.168.1.211 --netmask=24
# weka cluster host net add  0 ens257 --netmask=24 --gateway=192.168.1.1

weka cluster host net add  1 ens193 --ips 192.168.1.172 --netmask=24 
weka cluster host net add  1 ens224 --ips 192.168.1.182 --netmask=24 
weka cluster host net add  1 ens225 --ips 192.168.1.192 --netmask=24 
weka cluster host net add  1 ens256 --ips 192.168.1.202 --netmask=24 
weka cluster host net add  1 ens257 --ips 192.168.1.212 --netmask=24
# weka cluster host net add  1 ens257 --netmask=24 --gateway=192.168.1.1

weka cluster host net add  2 ens193 --ips 192.168.1.173 --netmask=24 
weka cluster host net add  2 ens224 --ips 192.168.1.183 --netmask=24 
weka cluster host net add  2 ens225 --ips 192.168.1.193 --netmask=24 
weka cluster host net add  2 ens256 --ips 192.168.1.203 --netmask=24 
weka cluster host net add  2 ens257 --ips 192.168.1.213 --netmask=24 
# weka cluster host net add  2 ens257 --netmask=24 --gateway=192.168.1.1

weka cluster host net add  3 ens193 --ips 192.168.1.174 --netmask=24 
weka cluster host net add  3 ens224 --ips 192.168.1.184 --netmask=24 
weka cluster host net add  3 ens225 --ips 192.168.1.194 --netmask=24 
weka cluster host net add  3 ens256 --ips 192.168.1.204 --netmask=24 
weka cluster host net add  3 ens257 --ips 192.168.1.214 --netmask=24

# weka cluster host net add  3 ens257 --netmask=24 --gateway=192.168.1.1
# weka cluster host net add  4 ens193 --netmask=24 
# weka cluster host net add  4 ens224 --netmask=24 
# weka cluster host net add  4 ens225 --netmask=24 
# weka cluster host net add  4 ens256 --netmask=24 
# weka cluster host net add  4 ens257 --netmask=24 --gateway=192.168.1.1


# weka cluster drive add 0 /dev/nvme0n1 /dev/nvme0n2 
# weka cluster drive add 1 /dev/nvme0n1 /dev/nvme0n2 
# weka cluster drive add 2 /dev/nvme0n1 /dev/nvme0n2 
# weka cluster drive add 3 /dev/nvme0n1 /dev/nvme0n2 
# weka cluster drive add 4 /dev/nvme0n1 /dev/nvme0n2 

weka cluster drive add 0 /dev/sdb /dev/sdc
weka cluster drive add 1 /dev/sdb /dev/sdc
weka cluster drive add 2 /dev/sdb /dev/sdc
weka cluster drive add 3 /dev/sdb /dev/sdc
weka cluster drive add 4 /dev/sdb /dev/sdc

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
weka cluster update --cluster-name=jack-kr-scb
weka cluster host apply --all --force

