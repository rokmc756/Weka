/root/tools/install/wekadestroy -y -u -f 192.168.219.{181..185}

pdsh -w 192.168.0.[181-185] "umount /opt/weka/data/agent/tmpfss/cross-container-rpc-the-tmpfs"
pdsh -w 192.168.0.[181-185] "umount /opt/weka/data/agent/tmpfss/compute0-persistent-tmpfs"
pdsh -w 192.168.0.[181-185] "umount /opt/weka/data/agent/tmpfss/drives0-persistent-tmpfs"

pdsh -w 192.168.0.[181-185] "cd /root/weka-4.2.4; ./install.sh"

for i in {1..5}; do scp /root/tools/install/resources_generator.py 192.168.0.18$i:/tmp/resources_generator.py; done

/tmp/resources_generator.py --path /tmp --net <eth{1..N}>

pdsh -w 192.168.0.[181-185] 'weka local stop && weka local rm -f --all'
pdsh -w 192.168.0.[181-185] 'chmod 755 /tmp/resources_generator.py'
pdsh -w 192.168.0.[181-185] '/tmp/resources_generator.py  --path /tmp --net eth1'

pdsh -w 192.168.0.[181-185] 'weka local setup container --name drive0 --resources-path /tmp/drives0.json'
pdsh -w 192.168.0.[181-185] 'weka local setup container --name compute0 --resources-path /tmp/compute0.json'
pdsh -w 192.168.0.[181-185] 'weka local setup container --name frontend0 --resources-path /tmp/frontend0.json'

weka cluster create weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 \
weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 \
--host-ips=192.168.219.181:14000,192.168.219.182:14000,192.168.219.183:14000,192.168.219.184:14000,192.168.219.185:14000,192.168.219.181:15000,192.168.219.182:15000,192.168.219.183:15000,192.168.219.184:15000,192.168.219.185:15000,192.168.219.181:16000,192.168.219.182:16000,192.168.219.183:16000,192.168.219.184:16000,192.168.219.185:16000

# in this example, there are 2 drives per each drives container, note that you should adjust this
for i in {0..4}; do weka cluster drive add $i /dev/nvme0n1; weka cluster drive add $i /dev/nvme0n2; done;



# [--cloud-url https://api.home.rnd.weka.io # if that's an rnd cluster]
weka cloud enable

# weka cluster license payg ###
weka cluster license payg CAb8oUcHUAVSyeWtnWF7ZS 6l2ItpW2Zmk8maVK/Z6CFT06VToGfiPXmhZl9YD/wgQgChOYe5UTW8blsyHfpZXm

weka cluster start-io


# weka cluster create weka4-node01 weka4-node02 weka4-node03 weka4-node04 \
# weka4-node05 weka4-node06 weka4-node07 weka4-node08 weka4-node09 weka4-node10 \
# --host-ips=192.168.219.181,192.168.219.182,192.168.219.183,192.168.219.184,192.168.219.185,192.168.219.186,192.168.219.187,192.168.219.188,192.168.219.189,192.168.219.190

# for i in {0..1}; do weka cluster container cores $i 9 --only-compute-cores; done
#
# for i in {0..1}; do weka cluster container cores $i 5 --only-drives-cores; done

# for i in {2..4}; do weka cluster container cores $i 2 --only-frontend-cores; done

# for i in {0..9}; do weka cluster container net add $i eth1 --netmask 24; done

# weka cluster container net

# for i in {0..1}; do weka cluster drive add $i /dev/nvme0n{1..2}; done

# for i in {2..4}; do weka cluster container memory $i 7GB; done

# weka cluster container

# X weka cluster container failure-domain 0

# weka cluster update --data-drives=3 --parity-drives=2

# weka cluster hot-spare 1

# weka cluster update --cluster-name jclu01

# weka cluster container apply --all --force

# weka cloud enable

# weka clust





/root/tools/install/wekadestroy -f -u -y 192.168.219.{181..187}

pdsh -w 192.168.219.[181-187] "umount /opt/weka/data/agent/tmpfss/cross-container-rpc-the-tmpfs"

pdsh -w 192.168.219.[181-187] "cd /root/weka-4.2.7.64; ./install.sh"

pdsh -w 192.168.219.[181-187] "weka local stop && weka local rm -f --all"

# copy resource generator to servers
for i in {1..7}; do scp /root/tools/install/resources_generator.py 192.168.219.18$i:/tmp/resources_generator.py; done

#run resource generator
# pdsh -w weka4-node0[1-7] '/tmp/resources_generator.py  --path /tmp --net ens{4..6}'
pdsh -w 192.168.219.[181-187] 'chmod 755 /tmp/resources_generator.py'
pdsh -w 192.168.219.[181-187] '/tmp/resources_generator.py  --path /tmp --net eth0'

# create the different containers from the resource generator output files
pdsh -w 192.168.219.[181-187] 'weka local setup host --name drive0 --resources-path /tmp/drives0.json'
pdsh -w 192.168.219.[181-187] 'weka local setup host --name compute0 --resources-path /tmp/compute0.json'
pdsh -w 192.168.219.[181-187] 'weka local setup host --name frontend0 --resources-path /tmp/frontend0.json'

# FROM ONE SERVER

# connect to the cluster
ssh weka4-node01

# create the cluster

# weka cluster create CLUSTER-{0..5}:14000 CLUSTER-{0..5}:14200 CLUSTER-{0..5}:14300
# weka cluster create weka4-node0{1..7}:14000,weka4-node0{1..7}:14200,weka4-node0{1..7}:14400

# weka cluster create weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 weka4-node06 weka4-node07 \
# --host-ips=192.168.0.181:14000,192.168.0.182:14000,192.168.0.183:14000,192.168.0.184:14000,192.168.0.185:14000,192.168.0.186:14000,192.168.0.187:14000,192.168.0.181:14200,192.168.0.182:14200,192.168.0.183:14200,192.168.0.184:14200,192.168.0.185:14200,192.168.0.186:14200,192.168.0.187:14200,192.168.0.181:14300,192.168.0.182:14300,192.168.0.183:14300,192.168.0.184:14300,192.168.0.185:14300,192.168.0.186:14300,192.168.0.187:14300

weka cluster create weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 weka4-node06 weka4-node07 \
weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 weka4-node06 weka4-node07 \
weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 weka4-node06 weka4-node07 \
--host-ips=192.168.0.181:14000,192.168.0.182:14000,192.168.0.183:14000,192.168.0.184:14000,192.168.0.185:14000,192.168.0.186:14000,192.168.0.187:14000,192.168.0.181:14200,192.168.0.182:14200,192.168.0.183:14200,192.168.0.184:14200,192.168.0.185:14200,192.168.0.186:14200,192.168.0.187:14200,192.168.0.181:14300,192.168.0.182:14300,192.168.0.183:14300,192.168.0.184:14300,192.168.0.185:14300,192.168.0.186:14300,192.168.0.187:14300




for i in {0..7} ; do weka cluster drive add $i /dev/nvme0n1; done;
for i in {0..7} ; do weka cluster drive add $i /dev/nvme0n2; done;

weka cloud enable
# weka cluster license payg ####
weka cluster start-io


ip=`hostname -I | awk ‘{print $1}’; weka cluster create default{0..5} --host-ips=$ip:14000,$ip:16000,$ip:18000,$ip:20000,$ip:22000,$ip:24000

