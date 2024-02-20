#!/bin/bash

usage() {
	echo "Usage: $0 [--no-parallel]"
	echo "  Use --no-parallel to prevent parallel execution"
	exit 1
}

para() {
	TF=$1; shift
	echo $*
	$* &
	#[ !$TF ] && { echo para waiting; wait; }
	[ $TF == "FALSE" ] && { echo para waiting; wait; }
}

PARA="TRUE"

# parse args
if [ $# != 0 ]; then
	if [ $# != 1 ]; then
		usage
	elif [ $1 == "--no-parallel" ]; then
		PARA="FALSE"
	else
		echo "Error: unknown command line switch - $1"
		usage
	fi
fi

echo starting - PARA is $PARA

# ------------------ custom script below --------------

echo Stopping weka on weka4-node01
para ${PARA} scp -p ./resources_generator.py weka4-node01:/tmp/
para ${PARA} ssh weka4-node01 "sudo weka local stop; sudo weka local rm -f default"
echo Stopping weka on weka4-node02
para ${PARA} scp -p ./resources_generator.py weka4-node02:/tmp/
para ${PARA} ssh weka4-node02 "sudo weka local stop; sudo weka local rm -f default"
echo Stopping weka on weka4-node03
para ${PARA} scp -p ./resources_generator.py weka4-node03:/tmp/
para ${PARA} ssh weka4-node03 "sudo weka local stop; sudo weka local rm -f default"
echo Stopping weka on weka4-node04
para ${PARA} scp -p ./resources_generator.py weka4-node04:/tmp/
para ${PARA} ssh weka4-node04 "sudo weka local stop; sudo weka local rm -f default"
echo Stopping weka on weka4-node05
para ${PARA} scp -p ./resources_generator.py weka4-node05:/tmp/
para ${PARA} ssh weka4-node05 "sudo weka local stop; sudo weka local rm -f default"

wait
echo Running Resources generator on host weka4-node01
para ${PARA} ssh weka4-node01 sudo /tmp/resources_generator.py -f --path /tmp --net eth1/192.168.1.181/24 eth2/192.168.2.181/24 --compute-dedicated-cores 3 --drive-dedicated-cores 3 --frontend-dedicated-cores 1
echo Running Resources generator on host weka4-node02
para ${PARA} ssh weka4-node02 sudo /tmp/resources_generator.py -f --path /tmp --net eth1/192.168.1.182/24 eth2/192.168.2.182/24 --compute-dedicated-cores 3 --drive-dedicated-cores 3 --frontend-dedicated-cores 1
echo Running Resources generator on host weka4-node03
para ${PARA} ssh weka4-node03 sudo /tmp/resources_generator.py -f --path /tmp --net eth1/192.168.1.183/24 eth2/192.168.2.183/24 --compute-dedicated-cores 3 --drive-dedicated-cores 3 --frontend-dedicated-cores 1
echo Running Resources generator on host weka4-node04
para ${PARA} ssh weka4-node04 sudo /tmp/resources_generator.py -f --path /tmp --net eth1/192.168.1.184/24 eth2/192.168.2.184/24 --compute-dedicated-cores 3 --drive-dedicated-cores 3 --frontend-dedicated-cores 1
echo Running Resources generator on host weka4-node05
para ${PARA} ssh weka4-node05 sudo /tmp/resources_generator.py -f --path /tmp --net eth1/192.168.1.185/24 eth2/192.168.2.185/24 --compute-dedicated-cores 3 --drive-dedicated-cores 3 --frontend-dedicated-cores 1
wait
echo Starting Drives container on server weka4-node01
para ${PARA} ssh weka4-node01 "sudo weka local setup container --name drives0 --resources-path /tmp/drives0.json"
echo Starting Drives container on server weka4-node02
para ${PARA} ssh weka4-node02 "sudo weka local setup container --name drives0 --resources-path /tmp/drives0.json"
echo Starting Drives container on server weka4-node03
para ${PARA} ssh weka4-node03 "sudo weka local setup container --name drives0 --resources-path /tmp/drives0.json"
echo Starting Drives container on server weka4-node04
para ${PARA} ssh weka4-node04 "sudo weka local setup container --name drives0 --resources-path /tmp/drives0.json"
echo Starting Drives container on server weka4-node05
para ${PARA} ssh weka4-node05 "sudo weka local setup container --name drives0 --resources-path /tmp/drives0.json"

wait

sudo weka cluster create weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05 --host-ips=192.168.2.181+192.168.1.181,192.168.2.182+192.168.1.182,192.168.2.183+192.168.1.183,192.168.1.184+192.168.2.184,192.168.2.185+192.168.1.185 -T infinite
echo Starting Compute container 0 on host weka4-node01
para ${PARA} ssh weka4-node01 sudo weka local setup container --name compute0 --resources-path /tmp/compute0.json --join-ips=192.168.2.181,192.168.1.181,192.168.2.182,192.168.1.182,192.168.2.183,192.168.1.183,192.168.1.184,192.168.2.184,192.168.2.185,192.168.1.185 --management-ips=192.168.2.181,192.168.1.181
echo Starting Compute container 0 on host weka4-node02
para ${PARA} ssh weka4-node02 sudo weka local setup container --name compute0 --resources-path /tmp/compute0.json --join-ips=192.168.2.181,192.168.1.181,192.168.2.182,192.168.1.182,192.168.2.183,192.168.1.183,192.168.1.184,192.168.2.184,192.168.2.185,192.168.1.185 --management-ips=192.168.2.182,192.168.1.182
echo Starting Compute container 0 on host weka4-node03
para ${PARA} ssh weka4-node03 sudo weka local setup container --name compute0 --resources-path /tmp/compute0.json --join-ips=192.168.2.181,192.168.1.181,192.168.2.182,192.168.1.182,192.168.2.183,192.168.1.183,192.168.1.184,192.168.2.184,192.168.2.185,192.168.1.185 --management-ips=192.168.2.183,192.168.1.183
echo Starting Compute container 0 on host weka4-node04
para ${PARA} ssh weka4-node04 sudo weka local setup container --name compute0 --resources-path /tmp/compute0.json --join-ips=192.168.2.181,192.168.1.181,192.168.2.182,192.168.1.182,192.168.2.183,192.168.1.183,192.168.1.184,192.168.2.184,192.168.2.185,192.168.1.185 --management-ips=192.168.1.184,192.168.2.184
echo Starting Compute container 0 on host weka4-node05
para ${PARA} ssh weka4-node05 sudo weka local setup container --name compute0 --resources-path /tmp/compute0.json --join-ips=192.168.2.181,192.168.1.181,192.168.2.182,192.168.1.182,192.168.2.183,192.168.1.183,192.168.1.184,192.168.2.184,192.168.2.185,192.168.1.185 --management-ips=192.168.2.185,192.168.1.185
wait

para ${PARA} sudo weka cluster drive add 0 /dev/nvme0n1 /dev/nvme0n2 /dev/nvme0n3 /dev/nvme0n4 /dev/nvme0n5 /dev/nvme0n6 
para ${PARA} sudo weka cluster drive add 1 /dev/nvme0n1 /dev/nvme0n2 /dev/nvme0n3 /dev/nvme0n4 /dev/nvme0n5 /dev/nvme0n6 
para ${PARA} sudo weka cluster drive add 2 /dev/nvme0n1 /dev/nvme0n2 /dev/nvme0n3 /dev/nvme0n4 /dev/nvme0n5 /dev/nvme0n6 
para ${PARA} sudo weka cluster drive add 3 /dev/nvme0n1 /dev/nvme0n2 /dev/nvme0n3 /dev/nvme0n4 /dev/nvme0n5 /dev/nvme0n6 
para ${PARA} sudo weka cluster drive add 4 /dev/nvme0n1 /dev/nvme0n2 /dev/nvme0n3 /dev/nvme0n4 /dev/nvme0n5 /dev/nvme0n6 


wait
sudo weka cluster update --data-drives=3 --parity-drives=2
sudo weka cluster hot-spare 0
sudo weka cluster update --cluster-name=wclu01

echo Starting Front container on host weka4-node01
para ${PARA} ssh weka4-node01 sudo weka local setup container --name frontend0 --resources-path /tmp/frontend0.json --join-ips=192.168.2.181,192.168.1.181,192.168.2.182,192.168.1.182,192.168.2.183,192.168.1.183,192.168.1.184,192.168.2.184,192.168.2.185,192.168.1.185 --management-ips=192.168.2.181,192.168.1.181
echo Starting Front container on host weka4-node02
para ${PARA} ssh weka4-node02 sudo weka local setup container --name frontend0 --resources-path /tmp/frontend0.json --join-ips=192.168.2.181,192.168.1.181,192.168.2.182,192.168.1.182,192.168.2.183,192.168.1.183,192.168.1.184,192.168.2.184,192.168.2.185,192.168.1.185 --management-ips=192.168.2.182,192.168.1.182
echo Starting Front container on host weka4-node03
para ${PARA} ssh weka4-node03 sudo weka local setup container --name frontend0 --resources-path /tmp/frontend0.json --join-ips=192.168.2.181,192.168.1.181,192.168.2.182,192.168.1.182,192.168.2.183,192.168.1.183,192.168.1.184,192.168.2.184,192.168.2.185,192.168.1.185 --management-ips=192.168.2.183,192.168.1.183
echo Starting Front container on host weka4-node04
para ${PARA} ssh weka4-node04 sudo weka local setup container --name frontend0 --resources-path /tmp/frontend0.json --join-ips=192.168.2.181,192.168.1.181,192.168.2.182,192.168.1.182,192.168.2.183,192.168.1.183,192.168.1.184,192.168.2.184,192.168.2.185,192.168.1.185 --management-ips=192.168.1.184,192.168.2.184
echo Starting Front container on host weka4-node05
para ${PARA} ssh weka4-node05 sudo weka local setup container --name frontend0 --resources-path /tmp/frontend0.json --join-ips=192.168.2.181,192.168.1.181,192.168.2.182,192.168.1.182,192.168.2.183,192.168.1.183,192.168.1.184,192.168.2.184,192.168.2.185,192.168.1.185 --management-ips=192.168.2.185,192.168.1.185

wait
echo Configuration process complete
