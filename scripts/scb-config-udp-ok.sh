weka cluster create wk4-worker01 wk4-worker02 wk4-worker03 wk4-worker04 wk4-worker05 --host-ips=192.168.1.141,192.168.1.142,192.168.1.143,192.168.1.144,192.168.1.145 -T infinite

pdsh -w 192.168.0.14[1-5] "dd if=/dev/zero of=/dev/sdc bs=512 count=1; dd if=/dev/zero of=/dev/sdd bs=512 count=1"
pdsh -w 192.168.0.14[1-5] "wipefs --all --force /dev/sdc; wipefs --all --force /dev/sdd"

weka cluster drive add 0 /dev/sdc /dev/sdd
weka cluster drive add 1 /dev/sdc /dev/sdd
weka cluster drive add 2 /dev/sdc /dev/sdd
weka cluster drive add 3 /dev/sdc /dev/sdd
weka cluster drive add 4 /dev/sdc /dev/sdd

weka cluster host cores 0 4 --compute-dedicated-cores 1 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 1 4 --compute-dedicated-cores 1 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 2 4 --compute-dedicated-cores 1 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 3 4 --compute-dedicated-cores 1 --frontend-dedicated-cores 1 --drives-dedicated-cores 2
weka cluster host cores 4 4 --compute-dedicated-cores 1 --frontend-dedicated-cores 1 --drives-dedicated-cores 2

weka cluster host dedicate 0 on
weka cluster host dedicate 1 on
weka cluster host dedicate 2 on
weka cluster host dedicate 3 on
weka cluster host dedicate 4 on

weka cluster update --data-drives=3 --parity-drives=2
weka cluster hot-spare 0
weka cluster update --cluster-name=wclu01
weka cluster host apply --all --force


weka cluster host net add 0 eth1 --ips 192.168.1.141 --netmask=24 --gateway=192.168.1.1
weka cluster host net add 0 eth2 --ips 192.168.2.141 --netmask=24 --gateway=192.168.2.1
weka cluster host net add 0 eth3 --ips 192.168.2.151 --netmask=24 --gateway=192.168.2.1

weka cluster host net add 1 eth1 --ips 192.168.1.142 --netmask=24 --gateway=192.168.1.1
weka cluster host net add 2 eth1 --ips 192.168.1.143 --netmask=24 --gateway=192.168.1.1
weka cluster host net add 3 eth1 --ips 192.168.1.144 --netmask=24 --gateway=192.168.1.1
weka cluster host net add 4 eth1 --ips 192.168.1.145 --netmask=24 --gateway=192.168.1.1

weka cluster host net add 1 eth2 --ips 192.168.2.142 --netmask=24 --gateway=192.168.2.1
weka cluster host net add 2 eth2 --ips 192.168.2.143 --netmask=24 --gateway=192.168.2.1
weka cluster host net add 3 eth2 --ips 192.168.2.144 --netmask=24 --gateway=192.168.2.1
weka cluster host net add 4 eth2 --ips 192.168.2.145 --netmask=24 --gateway=192.168.2.1

weka cluster host net add 1 eth3 --ips 192.168.2.152 --netmask=24 --gateway=192.168.2.1
weka cluster host net add 2 eth3 --ips 192.168.2.153 --netmask=24 --gateway=192.168.2.1
weka cluster host net add 3 eth3 --ips 192.168.2.154 --netmask=24 --gateway=192.168.2.1
weka cluster host net add 4 eth3 --ips 192.168.2.155 --netmask=24 --gateway=192.168.2.1

weka cluster host apply --all --force

weka cluster start-io

# It's working fine with ethernet mode
