
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
