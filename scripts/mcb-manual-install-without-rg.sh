/root/tools/install/wekadestroy -y -u -f 192.168.0.{141..145}

pdsh -w 192.168.0.[141-145] "umount /opt/weka/data/agent/tmpfss/cross-container-rpc-the-tmpfs"

pdsh -w 192.168.0.[141-145] "umount /opt/weka/data/agent/tmpfss/compute0-persistent-tmpfs"

pdsh -w 192.168.0.[141-145] "umount /opt/weka/data/agent/tmpfss/drives0-persistent-tmpfs"

pdsh -w 192.168.0.[141-145] "cd /root/weka-4.2.7.64; ./install.sh"

pdsh -w 192.168.0.[141-145] "weka local stop && weka local rm -f --all"

# pdsh -w 192.168.0.[141-145] "weka local setup container --name drives0 --base-port 14000 --cores 2 --core-ids 1,2 --only-drives-cores --net eth1,eth2 --failure-domain `hostname` --memory 0"
pdsh -w 192.168.0.[141-145] "weka local setup container --name drives0 --base-port 14000 --cores 2 --core-ids 1,2 --only-drives-cores --net eth1 --failure-domain `hostname` --memory 0"

# pdsh -w 192.168.0.[141-145] "weka local setup container --name compute0 --base-port 15000 --cores 4 --core-ids 3,4,5,6 --only-compute-cores --net=eth3,eth4,eth5,eth6 --memory 60GiB --failure-domain `hostname`"
# pdsh -w 192.168.0.[141-145] "weka local setup container --name compute0 --base-port 15000 --cores 4 --core-ids 3,4,5 --only-compute-cores --memory 11GiB --failure-domain `hostname`"
pdsh -w 192.168.0.[141-145] "weka local setup container --name compute0 --base-port 15000 --cores 3 --core-ids 3,4,5 --only-compute-cores --net=eth1 --memory 11GiB --failure-domain `hostname`"

# pdsh -w 192.168.0.[141-145] "weka local setup container --name frontend0 --base-port 16000 --cores 1 --core-ids 6 --only-frontend-cores --net=eth7 --memory 0"
# pdsh -w 192.168.0.[141-145] "weka local setup container --name frontend0 --base-port 16000 --cores 1 --core-ids 6 --only-frontend-cores --memory 0"
pdsh -w 192.168.0.[141-145] "weka local setup container --name frontend0 --base-port 16000 --cores 1 --core-ids 6 --only-frontend-cores --net=eth1 --memory 0"

# ? Needed?
for i in {0..4}; do weka cluster container net add $i eth1 --netmask=24 --gateway=192.168.219.1; done


weka cluster create weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 \
weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 \
--host-ips=192.168.219.141:14000,192.168.219.182:14000,192.168.219.183:14000,192.168.219.184:14000,192.168.219.145:14000,192.168.219.141:15000,192.168.219.182:15000,192.168.219.183:15000,192.168.219.184:15000,192.168.219.145:15000,192.168.219.141:16000,192.168.219.182:16000,192.168.219.183:16000,192.168.219.184:16000,192.168.219.145:16000

for i in {0..4}; do weka cluster drive add $i /dev/nvme0n1; weka cluster drive add $i /dev/nvme0n2; done

weka cloud enable # [--cloud-url https://api.home.rnd.weka.io # if that's an rnd cluster]

weka cluster license payg ###

weka cluster start-io

