
/root/tools/install/wekadestroy -f -y -u 192.168.0.17{1..5}

pdsh -w 192.168.0.17[1-5] "umount -f -l /opt/weka/data/agent/tmpfss/cross-container-rpc-the-tmpfs"

pdsh -w 192.168.0.17[1-5] "cd /root/weka-4.2.9.29-hcsf ; ./install.sh"

pdsh -w 192.168.0.17[1-5] "weka status"

pdsh -w 192.168.0.17[1-5] "weka local stop default && weka local disable default && weka local rm -f default"

echo Running Resources generator on host rk8-node01
ssh rk8-node01 "/root/tools/install/resources_generator.py -f --path /tmp --net eth1/192.168.1.171/24 eth2/192.168.1.181/24 eth3/192.168.1.191/24  --compute-dedicated-cores 1 --drive-dedicated-cores 2 --frontend-dedicated-cores 1 --protocols-memory 0GiB --compute-memory 5GiB --minimal-memory --drives /dev/sdc /dev/sdd"

echo Running Resources generator on host rk8-node02
ssh rk8-node02 "/root/tools/install/resources_generator.py -f --path /tmp --net eth1/192.168.1.172/24 eth2/192.168.1.182/24 eth3/192.168.1.192/24  --compute-dedicated-cores 1 --drive-dedicated-cores 2 --frontend-dedicated-cores 1 --protocols-memory 0GiB --compute-memory 5GiB --minimal-memory --drives /dev/sdc /dev/sdd"

echo Running Resources generator on host rk8-node03
ssh rk8-node03 "/root/tools/install/resources_generator.py -f --path /tmp --net eth1/192.168.1.173/24 eth2/192.168.1.183/24 eth3/192.168.1.193/24  --compute-dedicated-cores 1 --drive-dedicated-cores 2 --frontend-dedicated-cores 1 --protocols-memory 0GiB --compute-memory 5GiB --minimal-memory --drives /dev/sdc /dev/sdd"

echo Running Resources generator on host rk8-node04
ssh rk8-node04 "/root/tools/install/resources_generator.py -f --path /tmp --net eth1/192.168.1.174/24 eth2/192.168.1.184/24 eth3/192.168.1.194/24  --compute-dedicated-cores 1 --drive-dedicated-cores 2 --frontend-dedicated-cores 1 --protocols-memory 0GiB --compute-memory 5GiB --minimal-memory --drives /dev/sdc /dev/sdd"

echo Running Resources generator on host rk8-node05
ssh rk8-node05 "/root/tools/install/resources_generator.py -f --path /tmp --net eth1/192.168.1.175/24 eth2/192.168.1.185/24 eth3/192.168.1.195/24  --compute-dedicated-cores 1 --drive-dedicated-cores 2 --frontend-dedicated-cores 1 --protocols-memory 0GiB --compute-memory 5GiB --minimal-memory --drives /dev/sdc /dev/sdd"


pdsh -w 192.168.0.17[1-5] "weka local setup container --name drives0 --resources-path /tmp/drives0.json --failure-domain \$(hostname)"

weka cluster create rk8-node01 rk8-node02 rk8-node03 rk8-node04 rk8-node05 --host-ips=192.168.0.171,192.168.0.172,192.168.0.173,192.168.0.174,192.168.0.175 -T infinite

pdsh -w 192.168.0.17[1-5] "weka status"

pdsh -w 192.168.0.17[1-5] "dd if=/dev/zero of=/dev/sdc bs=512 count=1; dd if=/dev/zero of=/dev/sdd bs=512 count=1"
pdsh -w 192.168.0.17[1-5] "wipefs --all --force /dev/sdc; wipefs --all --force /dev/sdd"

weka cluster drive add 0 /dev/sdc /dev/sdd
weka cluster drive add 1 /dev/sdc /dev/sdd
weka cluster drive add 2 /dev/sdc /dev/sdd
weka cluster drive add 3 /dev/sdc /dev/sdd
weka cluster drive add 4 /dev/sdc /dev/sdd

# not work - pdsh -w 192.168.0.17[1-5] "weka local setup host --name compute0 --join-ips 192.168.1.181,192.168.1.182,192.168.1.183,192.168.1.184,192.168.1.185 --resources-path /tmp/compute0.json --management-ips=\$(hostname -i)"
pdsh -w 192.168.0.17[1-5] "weka local setup host --name compute0 --resources-path /tmp/compute0.json --failure-domain \$(hostname) --management-ips=\$(hostname -i)"     # --> It works

# pdsh -w 192.168.0.17[1-5] "weka local stop compute0 && weka local rm -f compute0"
# pdsh -w 192.168.0.17[1-5] "weka local stop frontend0 && weka local rm -f frontend0"

# not work - pdsh -w 192.168.0.17[1-5] "weka local setup host --name frontend0 --join-ips 192.168.1.191,192.168.1.192,192.168.1.193,192.168.1.194,192.168.1.195 --resources-path /tmp/frontend0.json --management-ips=\$(hostname -i)"
pdsh -w 192.168.0.17[1-5] "weka local setup host --name frontend0 --resources-path /tmp/frontend0.json --failure-domain \$(hostname) --management-ips=\$(hostname -i)"   # --> It works

pdsh -w 192.168.17[1-5] "weka local resources -C drives0"
pdsh -w 192.168.17[1-5] "weka local resources -C compute0"
pdsh -w 192.168.17[1-5] "weka local resources -C frontend0"

weka cloud enable

weka cluster update --data-drives=3 --parity-drives=2
weka cluster hot-spare 1
weka cluster update --cluster-name=jack-kr-mcb01

# weka cluster license payg ####
weka cluster start-io
