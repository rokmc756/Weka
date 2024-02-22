

# /usr/bin/bash

# NOTE this is an experimental feature, and this script may not be correct
# you should manually verify that it will do what you want/expect

echo Running Resources generator on host cst7
scp -p ./resources_generator.py cst7:/tmp/
ssh cst7 "sudo weka local stop; sudo weka local rm -f default"
ssh cst7 sudo /tmp/resources_generator.py -f --path /tmp --net ens1f1np1/10.0.94.116/16 ens1f0np0/10.0.98.116/16 --compute-dedicated-cores 35 --drive-dedicated-cores 6 --frontend-dedicated-cores 2 --compute-memory 150GiB
echo Starting Drives container on host cst7
ssh cst7 "sudo weka local setup host --name drives0 --resources-path /tmp/drives0.json"
echo Running Resources generator on host cst8
scp -p ./resources_generator.py cst8:/tmp/
ssh cst8 "sudo weka local stop; sudo weka local rm -f default"
ssh cst8 sudo /tmp/resources_generator.py -f --path /tmp --net ens1f1np1/10.0.94.117/16 ens1f0np0/10.0.98.117/16 --compute-dedicated-cores 35 --drive-dedicated-cores 6 --frontend-dedicated-cores 2 --compute-memory 150GiB
echo Starting Drives container on host cst8
ssh cst8 "sudo weka local setup host --name drives0 --resources-path /tmp/drives0.json"
echo Running Resources generator on host weka83
scp -p ./resources_generator.py weka83:/tmp/
ssh weka83 "sudo weka local stop; sudo weka local rm -f default"
ssh weka83 sudo /tmp/resources_generator.py -f --path /tmp --net ens2f0np0/10.0.94.83/16 ens1f0np0/10.0.98.83/16 --compute-dedicated-cores 35 --drive-dedicated-cores 6 --frontend-dedicated-cores 2 --compute-memory 150GiB
echo Starting Drives container on host weka83
ssh weka83 "sudo weka local setup host --name drives0 --resources-path /tmp/drives0.json"
echo Running Resources generator on host weka84
scp -p ./resources_generator.py weka84:/tmp/
ssh weka84 "sudo weka local stop; sudo weka local rm -f default"
ssh weka84 sudo /tmp/resources_generator.py -f --path /tmp --net ens2f0np0/10.0.94.84/16 ens1f0np0/10.0.98.84/16 --compute-dedicated-cores 35 --drive-dedicated-cores 6 --frontend-dedicated-cores 2 --compute-memory 150GiB
echo Starting Drives container on host weka84
ssh weka84 "sudo weka local setup host --name drives0 --resources-path /tmp/drives0.json"
echo Running Resources generator on host weka85
scp -p ./resources_generator.py weka85:/tmp/
ssh weka85 "sudo weka local stop; sudo weka local rm -f default"
ssh weka85 sudo /tmp/resources_generator.py -f --path /tmp --net ens2f0np0/10.0.94.85/16 ens1f0np0/10.0.98.85/16 --compute-dedicated-cores 35 --drive-dedicated-cores 6 --frontend-dedicated-cores 2 --compute-memory 150GiB
echo Starting Drives container on host weka85
ssh weka85 "sudo weka local setup host --name drives0 --resources-path /tmp/drives0.json"

sudo weka cluster create cst7 cst8 weka83 weka84 weka85 --host-ips=10.0.98.116+10.0.94.116,10.0.98.117+10.0.94.117,10.0.94.83+10.0.98.83,10.0.94.84+10.0.98.84,10.0.98.85+10.0.94.85 -T infinite

echo Starting Compute container on host cst7
ssh cst7 sudo weka local setup container --name compute0 --resources-path /tmp/compute0.json --join-ips=10.0.98.116,10.0.94.116,10.0.98.117,10.0.94.117,10.0.94.83,10.0.98.83,10.0.94.84,10.0.98.84,10.0.98.85,10.0.94.85
echo Starting Compute container on host cst8
ssh cst8 sudo weka local setup container --name compute0 --resources-path /tmp/compute0.json --join-ips=10.0.98.116,10.0.94.116,10.0.98.117,10.0.94.117,10.0.94.83,10.0.98.83,10.0.94.84,10.0.98.84,10.0.98.85,10.0.94.85
echo Starting Compute container on host weka83
ssh weka83 sudo weka local setup container --name compute0 --resources-path /tmp/compute0.json --join-ips=10.0.98.116,10.0.94.116,10.0.98.117,10.0.94.117,10.0.94.83,10.0.98.83,10.0.94.84,10.0.98.84,10.0.98.85,10.0.94.85
echo Starting Compute container on host weka84
ssh weka84 sudo weka local setup container --name compute0 --resources-path /tmp/compute0.json --join-ips=10.0.98.116,10.0.94.116,10.0.98.117,10.0.94.117,10.0.94.83,10.0.98.83,10.0.94.84,10.0.98.84,10.0.98.85,10.0.94.85
echo Starting Compute container on host weka85
ssh weka85 sudo weka local setup container --name compute0 --resources-path /tmp/compute0.json --join-ips=10.0.98.116,10.0.94.116,10.0.98.117,10.0.94.117,10.0.94.83,10.0.98.83,10.0.94.84,10.0.98.84,10.0.98.85,10.0.94.85

sudo weka cluster drive add 0 /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
sudo weka cluster drive add 1 /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
sudo weka cluster drive add 2 /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
sudo weka cluster drive add 3 /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
sudo weka cluster drive add 4 /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1

sudo weka cluster update --data-drives=3 --parity-drives=2
sudo weka cluster hot-spare 0
sudo weka cluster update --cluster-name=test

echo Starting Front container on host cst7
ssh cst7 sudo weka local setup container --name frontend0 --resources-path /tmp/frontend0.json --join-ips=10.0.98.116,10.0.94.116,10.0.98.117,10.0.94.117,10.0.94.83,10.0.98.83,10.0.94.84,10.0.98.84,10.0.98.85,10.0.94.85
echo Starting Front container on host cst8
ssh cst8 sudo weka local setup container --name frontend0 --resources-path /tmp/frontend0.json --join-ips=10.0.98.116,10.0.94.116,10.0.98.117,10.0.94.117,10.0.94.83,10.0.98.83,10.0.94.84,10.0.98.84,10.0.98.85,10.0.94.85
echo Starting Front container on host weka83
ssh weka83 sudo weka local setup container --name frontend0 --resources-path /tmp/frontend0.json --join-ips=10.0.98.116,10.0.94.116,10.0.98.117,10.0.94.117,10.0.94.83,10.0.98.83,10.0.94.84,10.0.98.84,10.0.98.85,10.0.94.85
echo Starting Front container on host weka84
ssh weka84 sudo weka local setup container --name frontend0 --resources-path /tmp/frontend0.json --join-ips=10.0.98.116,10.0.94.116,10.0.98.117,10.0.94.117,10.0.94.83,10.0.98.83,10.0.94.84,10.0.98.84,10.0.98.85,10.0.94.85
echo Starting Front container on host weka85
ssh weka85 sudo weka local setup container --name frontend0 --resources-path /tmp/frontend0.json --join-ips=10.0.98.116,10.0.94.116,10.0.98.117,10.0.94.117,10.0.94.83,10.0.98.83,10.0.94.84,10.0.98.84,10.0.98.85,10.0.94.85
echo Configuration process complete


