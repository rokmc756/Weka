

# Wipe the first 10 NVMe disks. Make sure you do not wipe the OS disk!
# Run as root - you will need the nvme-cli package/rpm installed to use this.
for f in 1 2 3 4 5 6 7 8 9 10
do
	echo $f
	nvme format /dev/nvme${f}n1 --ses=2
done


# Add the new hosts to the cluster, these are hosts with 2 NICS for HA
weka cluster host add prod-weka-server-31 --ip 10.1.3.171+10.1.3.195
weka cluster host add prod-weka-server-32 --ip 10.1.3.172+10.1.3.196
weka cluster host add prod-weka-server-33 --ip 10.1.3.173+10.1.3.197
weka cluster host add prod-weka-server-34 --ip 10.1.3.174+10.1.3.198
weka cluster host add prod-weka-server-35 --ip 10.1.3.175+10.1.3.199
weka cluster host add prod-weka-server-36 --ip 10.1.3.176+10.1.3.200
weka cluster host add prod-weka-server-37 --ip 10.1.3.177+10.1.3.201
weka cluster host add prod-weka-server-38 --ip 10.1.3.178+10.1.3.202

# Need to change HostId the new nodes will appear as new IDs, in our example 101 to 108

# Add drives on new hosts, in this case 10 new drives:
for i in {101..108}; do weka cluster drive add $i /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1 /dev/nvme6n1 /dev/nvme7n1 /dev/nvme8n1 /dev/nvme9n1 /dev/nvme10n1; done

# Add the cores with specific core-ids
for i in {101..108}; do weka cluster host cores $i 19 --frontend-dedicated-cores 4 --drives-dedicated-cores 5 --core-ids 2,3,4,5,6,7,10,11,12,13,14,8,9,15,16,17; done

# Add the network interfaces to the hosts (with optional netmask & gateway)
for i in {101..108}; do weka cluster host net add $i enp175s0f0 --netmask=22 --gateway=10.1.0.1 ; done
for i in {101..108}; do weka cluster host net add $i enp175s0f1 --netmask=22 --gateway=10.1.0.1 ; done

# Set the memory on each host (if it was manually configured)
for i in {101..108}; do weka cluster host memory $i 102GiB; done

# Set the backends host to dedicated (if this is true)
for i in {101...108}; do weka cluster host dedicate $i on; done

# Set the backends host failure domain (optional)
for i in {101...108}; do weka cluster host failure-domain $i --name rack2; done


# Scan for the drives
weka cluster drive scan

# Activate the hosts
weka cluster host activate

# Activate the drives.
weka cluster drive activate

