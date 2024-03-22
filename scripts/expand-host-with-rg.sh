[ On extand hosts ]

$ /root/tools/install/resources_generator.py -f --path /tmp --net ens1f0np0/10.0.98.117/16 --net ens1f1np1/10.0.94.117/16 \
--compute-dedicated-cores 15 --drive-dedicated-cores 6 --frontend-dedicated-cores 1 --protocols-memory 0GiB



$ weka local setup container --name drives0 --resources-path /tmp/drives0.json --failure-domain cst8 \
--management-ips=10.0.98.117 --join-ips=10.0.94.111,10.0.94.112,10.0.94.113,10.0.98.114,10.0.98.115,10.0.98.117

$ weka local setup container --name compute0 --resources-path /tmp/compute0.json --failure-domain cst8 \
--management-ips=10.0.98.117 --join-ips=10.0.94.111,10.0.94.112,10.0.94.113,10.0.98.114,10.0.98.115,10.0.98.117

$ weka local setup container --name frontend0 --resources-path /tmp/frontend0.json --failure-domain cst8 \
--management-ips=10.0.98.117 --join-ips=10.0.94.111,10.0.94.112,10.0.94.113,10.0.98.114,10.0.98.115,10.0.98.117


[ On Weka node ]
$ weka cluster container
CONTAINER ID  HOSTNAME  CONTAINER  IPS          STATUS  RELEASE  FAILURE DOMAIN  CORES  MEMORY    LAST FAILURE  UPTIME
~~ snip
33            cst8      drives0    10.0.98.117  UP      4.2.0    cst8            6      8.95 GB                 0:03:41h
34            cst8      compute0   10.0.98.117  UP      4.2.0    cst8            15     76.37 GB                0:03:07h
35            cst8      frontend0  10.0.98.117  UP      4.2.0    cst8            1      1.47 GB                 0:02:30h


#
$ dd if=/dev/zero of=/dev/nvme0n1 bs=1k count=10000
$ dd if=/dev/zero of=/dev/nvme1n1 bs=1k count=10000
$ dd if=/dev/zero of=/dev/nvme2n1 bs=1k count=10000
$ dd if=/dev/zero of=/dev/nvme3n1 bs=1k count=10000
$ dd if=/dev/zero of=/dev/nvme4n1 bs=1k count=10000

$ nvme format /dev/nvme0n1 -f
$ nvme format /dev/nvme1n1 -f
$ nvme format /dev/nvme2n1 -f
$ nvme format /dev/nvme3n1 -f
$ nvme format /dev/nvme4n1 -f

#
$ weka cluster drive add 33 /dev/nvme0n1
$ weka cluster drive add 33 /dev/nvme1n1
$ weka cluster drive add 33 /dev/nvme2n1
$ weka cluster drive add 33 /dev/nvme3n1
$ weka cluster drive add 33 /dev/nvme4n1

