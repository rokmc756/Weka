# 1. Form a cluster
# Hostnames separated by spaces
weka cluster create  asgsds01-ib asgsds02-ib asgsds03-ib asgsds04-ib asgsds05-ib asgsds06-ib asgsds07-ib asgsds08-ib --host-ips=10.50.0.1,10.50.0.2,10.50.0.3,10.50.0.4,10.50.0.5,10.50.0.6,10.50.0.7,10.50.0.8

# 2. Created a cluster name
weka cluster update --cluster-name=customer1

# 3. Create a parity
weka cluster update --data-drives=4 --parity-drives=2

# 4. Add Host cores
weka cluster host cores 0 16 --frontend-dedicated-cores=1 --drives-dedicated-cores=8
weka cluster host cores 1 16 --frontend-dedicated-cores=1 --drives-dedicated-cores=8
weka cluster host cores 2 16 --frontend-dedicated-cores=1 --drives-dedicated-cores=8
weka cluster host cores 3 16 --frontend-dedicated-cores=1 --drives-dedicated-cores=8
weka cluster host cores 4 16 --frontend-dedicated-cores=1 --drives-dedicated-cores=8
weka cluster host cores 5 16 --frontend-dedicated-cores=1 --drives-dedicated-cores=8
weka cluster host cores 6 16 --frontend-dedicated-cores=1 --drives-dedicated-cores=8
weka cluster host cores 7 16 --frontend-dedicated-cores=1 --drives-dedicated-cores=8

# 5. Add disks
# Assign drives to cluster (ie. /dev/nvme0n1, etc.)
for i in {0..7}; do weka cluster drive add $i /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1;done

# 6. Add Networking
weka cluster default-net set --range 10.0.50.10-200 --gateway=10.0.50.254 --netmask=24
weka cluster host net add 0 --device=enp24s0 --ips-type=POOL
weka cluster host net add 1 --device=enp24s0 --ips-type=POOL
weka cluster host net add 2 --device=enp24s0 --ips-type=POOL
weka cluster host net add 3 --device=enp24s0 --ips-type=POOL
weka cluster host net add 4 --device=enp24s0 --ips-type=POOL
weka cluster host net add 5 --device=enp24s0 --ips-type=POOL
weka cluster host net add 6 --device=enp24s0 --ips-type=POOL
weka cluster host net add 7 --device=enp24s0 --ips-type=POOL

# 7. Dedicate hosts if applicable
for i in {0..7} ; do weka cluster host dedicate $i on;done

# 8. Enable cloud
weka cloud enable

# 9. Scan drives
weka cluster drive scan

# 10. Activate the host into the cluster
weka cluster host activate

# 11. Activate drive
weka cluster drive activate

# 12. Start IO
weka cluster start-io

