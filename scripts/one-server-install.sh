# This script follows the steps described in the Weka System Installation Process Using the CLI
# https://docs.weka.io/v/3.13/install/bare-metal/using-cli

# Enviornment variables
    WNAME="hpe" && echo "Cluster name: "$WNAME
    WIP="10.10.10.10" && echo "Dataplane IP: "$WIP

# Stage 1: Installation of the Weka Software on Each Host
    wget --auth-no-challenge https://vmxO9lFLWAxH9SWH:@get.weka.io/dist/v1/pkg/weka-3.13.5.tar
    tar -xvf weka-3.13.5.tar
    cd weka-3.13.5.tar && sudo sh install.sh

# Stage 1.1 Remove default container created by install.sh
    sudo weka local stop default && sudo weka local rm default --force

# Stage 1.2 Setup cluster containers and sleep 30
    echo "Creating containers"
    sudo weka local setup host --name default --memory 10GiB
    sudo weka local setup host --name default1 --base-port 14200 --no-frontends --memory 15GiB
    sudo weka local setup host --name default2 --base-port 14300 --no-frontends --memory 15GiB
    sudo weka local setup host --name default3 --base-port 14400 --no-frontends --memory 15GiB
    sudo weka local setup host --name default4 --base-port 14500 --no-frontends --memory 15GiB
    sudo weka local setup host --name default5 --base-port 14600 --no-frontends --memory 15GiB
    sudo weka local setup host --name default6 --base-port 14700 --no-frontends --memory 15GiB
    echo "Sleeping for 30 second waiting for containers to start"
    sleep 30

# Stage 2: Formation of a Cluster from the containers
    echo "Forming cluster"
    sudo weka cluster create host{1..7} --host-ips="$WIP":14000,"$WIP":14200,"$WIP":14300,"$WIP":14400,"$WIP":14500,"$WIP":14600,"$WIP":14700

# Stage 3: Naming the Cluster (optional)
    echo "Naming cluster"
    sudo weka cluster update --cluster-name $WNAME

# Stage 4: Enabling Cloud Event Notifications (optional)
    echo "Enabling cloud notifications"
    weka cloud enable
    sleep 5

# Stage 5: Setting hosts as dedicated to the cluster (Optional)
    # weka cluster host dedicate

# Stage 6: Configuration of Networking
    echo "Congifuring network"
    # for i in {0..3}; do sudo weka cluster host net add 0 ib"$i" --netmask=24; done
    sudo weka cluster host net add 0 ib2 --netmask=24
    sudo weka cluster host net add 1 ib1 --netmask=24
    sudo weka cluster host net add 2 ib1 --netmask=24
    sudo weka cluster host net add 3 ib0 --netmask=24
    sudo weka cluster host net add 4 ib0 --netmask=24
    sudo weka cluster host net add 5 ib3 --netmask=24
    sudo weka cluster host net add 6 ib3 --netmask=24

# Stage 7: Configuration of SSDs
    echo "Configuring SSDs"
    sudo weka cluster drive add 1 /dev/nvme2n1
    sudo weka cluster drive add 2 /dev/nvme3n1
    sudo weka cluster drive add 3 /dev/nvme0n1
    sudo weka cluster drive add 4 /dev/nvme1n1
    sudo weka cluster drive add 5 /dev/nvme5n1
    sudo weka cluster drive add 6 /dev/nvme6n1

# Stage 8: Configuration of CPU Resources
    echo "Configuring CPU resources"
    
    sudo weka cluster host cores 0 4 --frontend-dedicated-cores 4 --cores-ids 123,124,125,126
    sudo weka cluster host cores 1 4 --drives-dedicated-cores 1 --no-frontends --cores-ids 24,25,26,27
    sudo weka cluster host cores 2 4 --drives-dedicated-cores 1 --no-frontends --cores-ids 28,29,30,31
    sudo weka cluster host cores 3 4 --drives-dedicated-cores 1 --no-frontends --cores-ids 56,57,58,59
    sudo weka cluster host cores 4 4 --drives-dedicated-cores 1 --no-frontends --cores-ids 60,61,62,63
    sudo weka cluster host cores 5 4 --drives-dedicated-cores 1 --no-frontends --cores-ids 88,89,90,91
    sudo weka cluster host cores 6 4 --drives-dedicated-cores 1 --no-frontends --cores-ids 92,93,94,95

# Stage 9: Configuration of Memory (optional)
    # weka cluster host memory <host-id> <capacity-memory>

# Stage 10: Configuration of Failure Domains (optional)
    echo "Configuring failure domains"
    sudo weka cluster host failure-domain 0 --name fd0
    sudo weka cluster host failure-domain 1 --name fd0
    sudo weka cluster host failure-domain 2 --name fd1
    sudo weka cluster host failure-domain 3 --name fd2
    sudo weka cluster host failure-domain 4 --name fd3
    sudo weka cluster host failure-domain 5 --name fd4
    sudo weka cluster host failure-domain 6 --name fd5

# Stage 11: Configuration of Weka System Protection Scheme (optional)
    echo "Configuring system protection scheme"
    sudo weka cluster update --data-drives=4 --parity-drives=2

# Stage 12: Configuration of Hot Spare (optional)
    echo "Configuring hot spares"
    sudo weka cluster hot-spare 1

# Stage 13: Applying Hosts Configuration; sleep 60
    echo "Applying host configuration"
    sudo weka cluster host apply --all --force
    echo "Sleeping for 60 seconds waiting for containers to restart"
    sleep 60

# Stage 14: Running the Start IO Command; sleep 2
    echo "Starting IO"
    # optimization
    sudo weka debug jrpc config_override_key key=clusterInfo.rdmaEnabled value=true
    sudo weka debug jrpc config_override_key key=clusterInfo.rdmaServerEnabled value=true
    sudo weka cluster start-io
    sleep 2

# Stage 14.1: Additional settings
    echo "Applying additional settings"
    weka alerts mute OfedVersions 365d
    weka debug traces retention set --server-max 2GB
    weka debug traces retention set --client-max 2GB

# Stage 14.2: Create default group & filesystem
    echo "Creating default group & 5TiB filesystem"
    sudo weka fs group create default
    sudo weka fs create default default 5TiB
    # sudo mkdir /mnt/weka && sudo chmod 777 /wmnt/weka
    sudo mount -t wekafs default /mnt/weka

# Set admin password and login
    echo "Setup complete. Welcome to Weka"
    weka user passwd --username admin --current-password admin Weka.io123
    weka user login admin Weka.io123
    weka cluster host
