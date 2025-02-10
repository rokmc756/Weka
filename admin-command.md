## Examples Commands
~~~
$ weka local ps
$ weka local stop
$ weka local rm default -f
~~~


## Check Weka Contaniners
~~~
$ weka local resources -C drives0
$ weka local resources -C compute0
$ weka local resources -C frontend0
~~~


## Checking Commands
~~~
$ weka cluster drive scan ?
$ weka cluster container activate ?
$ weka cluster drive activate ?
~~~


## Set Version and Start Local Container
~~~
$ weka version set 4.2.9.29-hcsf
$ weka local start
~~~


## S3
~~~
$ weka s3 cluster containers list

$ weka s3 policy detach <user>
$ weka s3 sts assume-role
$ weka s3 sts assume-role <--access-key access-key> [--secret-key secret-key] [--policy-file policy-file] <--duration duration>
$ Access-Key: JR9O0U6V42KLPFQDO2Z3
$ Secret-Key: wM0QMWuQ04WHlByj2SlEyuNrWoliMaCoVPmRsKbH
$ Session-Token: eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3NLZXkiOiJKUjlPMFU2VjQyS0xQRlFETz

$ weka s3 policy remove
$ weka s3 policy remove <policy-name>
$ weka s3 policy add
$ weka s3 policy add <policy-name> <policy-file>
$ weka s3 policy list
$ weka s3 policy show <policy-name>
$ weka s3 service-account list
$ weka s3 service-account add
$ weka s3 service-account add <policy-file>
$ weka s3 service-account show <access-key>
$ weka s3 service-account remove <access-key>

$ weka s3 bucket create {{ item.name }} --fs-name {{ item.fs }}
Need to check the meaning of --fs-name exactly especailly which bucket is relevant with

$ weka s3 bucket create s3-bucket01 --fs-name s3-fs01
error: An error occurred (InvalidBucketState) when calling the CreateBucket operation:
Unable to create bucket because the folder path already exists and contains data objects.
Use Weka-CLI --existing-path <path> for explicit path selection


$ weka s3 bucket destroy {{ item.name }} -f
$ weka s3 bucket policy unset {{ item.name }}


###############################################################################################################################
# Arguments
###############################################################################################################################
# default-fs-name   S3 default filesystem name
# config-fs-name    S3 config  filesystem name
~~~


## NFS
~~~
# Need to check if fs exists?
# weka fs
#
# Need to check which is correct?
# weka nfs global-config set --config-fs  jtest-fs01
# weka nfs global-config set --config-fs ""

# $ weka nfs global-config set --mountd-port <mountd-port>
# The mountd service receives requests from clients to mount to the NFS server.
# When working with interface groups (with allow-manage-gids=on),
# it is possible to set it explicitly, rather than have it randomly selected on each server startup.
# This allows an easier setup of the firewalls to allow that port.
# Use the following command to set and view the mountd configuration:
# weka nfs global-config set --mountd-port <mountd-port> and weka nfs global-config show.

# Need to check if DNS is needed
# weka nfs rules add dns jtest-client-group01 weka4-node07.jtest.pivotal.io
# weka nfs rules delete dns jtest-client-group01 weka4-node07.jtest.pivotal.io

# Need to check if it's OK when running playbook
# weka nfs interface-group
# NAME         SUBNET MASK    GATEWAY      TYPE  STATUS  IPS
                            PORTS                                                                                            ALLOW MANAGE GIDS
# jtest-nfs01  255.255.255.0  192.168.0.1  NFS   OK      192.168.0.221, 192.168.0.222, 192.168.0.223, 192.168.0.224, 192.168.0.225, 192.168.0.226, 192.168.0.227, 192.168.0.228, 192.168.0.229, 192.168.0.230  [     host_uid: f62e2a1b-704e-01b5-5baa-2b225f4a4084,host_id: HostId<0>,port: eth0,status: OK ]  True
#
# Need to check if it's OK when running playbook
# weka nfs permission
# FILESYSTEM  GROUP  PATH  TYPE  SQUASHING  ANONYMOUS UID  ANONYMOUS GID  OBS DIRECT  MANAGE GIDS  MOUNT OPTIONS  PRIVILEGED PORT  SUPPORTED VERSIONS

# Need to check if it's OK when running playbook
# weka nfs clients show
# HOSTID  CLIENT IP  IDLE TIME  NFSV3 OPS  NFSV4 OPS  NFSV4 OPEN OPS  NFSV4 CLOSE OPS
~~~


## NFS
~~~
# Need to check if fs exists for nfs backends
# $ weka fs
# FILESYSTEM ID  FILESYSTEM NAME  USED SSD  AVAILABLE SSD  USED TOTAL  AVAILABLE TOTAL  THIN PROVISIONED  THIN PROVISIONED MINIMUM SSD  THIN PROVISIONED MAXIMUM SSD

# For MCB
# $ weka cluster process | grep FRONTEND
# 1           weka4-node01  default    192.168.219.181  UP      4.2.7.64  FRONTEND    UDP      1    1.47 GB  0:07:26h
# 21          weka4-node02  default    192.168.219.182  UP      4.2.7.64  FRONTEND    UDP      1    1.47 GB  0:07:26h
# 41          weka4-node03  default    192.168.219.183  UP      4.2.7.64  FRONTEND    UDP      1    1.47 GB  0:07:21h
# 61          weka4-node04  default    192.168.219.184  UP      4.2.7.64  FRONTEND    UDP      1    1.47 GB  0:07:26h
# 81          weka4-node05  default    192.168.219.185  UP      4.2.7.64  FRONTEND    UDP      1    1.47 GB  0:07:16h

# $ weka nfs global-config set --mountd-port <mountd-port>
# The mountd service receives requests from clients to mount to the NFS server.
# When working with interface groups (with allow-manage-gids=on),
# it is possible to set it explicitly, rather than have it randomly selected on each server startup.
# This allows an easier setup of the firewalls to allow that port.
# Use the following command to set and view the mountd configuration:
# weka nfs global-config set --mountd-port <mountd-port> and weka nfs global-config show.

# For DNS?
# weka nfs rules add dns jtest-client-group01 weka4-node07.jtest.pivotal.io
# weka nfs rules delete dns jtest-client-group01 weka4-node07.jtest.pivotal.io

# Need to check if it's OK?
# $ weka nfs interface-group
# NAME         SUBNET MASK    GATEWAY      TYPE  STATUS  IPS
                            PORTS                                                                                            ALLOW MANAGE GIDS
# jtest-nfs01  255.255.255.0  192.168.0.1  NFS   OK      192.168.0.221, 192.168.0.222, 192.168.0.223, 192.168.0.224, 192.168.0.225, 192.168.0.226, 192.168.0.227, 192.168.0.228, 192.168.0.229, 192.168.0.230  [     host_uid: f62e2a1b-704e-01b5-5baa-2b225f4a4084,host_id: HostId<0>,port: eth0,status: OK ]  True
# $ weka nfs permission
# FILESYSTEM  GROUP  PATH  TYPE  SQUASHING  ANONYMOUS UID  ANONYMOUS GID  OBS DIRECT  MANAGE GIDS  MOUNT OPTIONS  PRIVILEGED PORT  SUPPORTED VERSIONS

# Need to check if it exists?
# $ weka nfs clients show
# HOSTID  CLIENT IP  IDLE TIME  NFSV3 OPS  NFSV4 OPS  NFSV4 OPEN OPS  NFSV4 CLOSE OPS
~~~

## NFS
~~~
$ weka nfs permission add nfs jtest-client-group01 --path /xxxx/xxx \
$ --permission-type 0777 --squash squash --anon-uid anon-uid --anon-gid anon-gid \
$ --obs-direct obs-direct --manage-gids manage-gids --privileged-port privileged-port \
$ --supported-versions 3

$ weka nfs permission delete <filesystem> <group> [--path path]
~~~

## NFS
~~~
$ weka nfs permission add nfs jtest-client-group01 --path /xxxx/xxx --permission-type 0777 --squash squash --anon-uid anon-uid --anon-gid anon-gid \
$ --obs-direct obs-direct --manage-gids manage-gids --privileged-port privileged-port \
$ --supported-versions 3
$ weka nfs permission delete <filesystem> <group> [--path path]
~~~


## NFS
~~~
$ weka nfs global-config set --config-fs jtest-default-fs01
$ weka nfs global-config show
~~~


## Deploy OBS
~~~

################################################################################
# Mount the jtest-obs-fs02 filesystem on the backends and clients if you have them.
# Backends

# Clients (replace ip with one of your backends)
# sudo mkdir /mnt/jtest-obs-fs02
# [root@weka4-node01 ~]# mount -t wekafs -o net=udp 192.168.0.181/jtest-obs-fs02 /mnt/jtest-obs-fs02
# wekafs_mount_helper: Mounting 192.168.0.181/jtest-obs-fs02 on /mnt/jtest-obs-fs02
# Basing mount on container default
# error: A backend weka container is already running.
#
#At this point weka does not support mixing backend and stateless client containers on the same host.
#If you’re sure the currently running containers are not in use anymore, you can stop and delete them by running ‘weka local stop’ and ‘weka local rm’.
#Please note that running these commands on backend hosts could cause data loss.


# Mount the jtest-s3fs01 filesystem on the backends and clients if you have them.
# Backends
#
# sudo mkdir /mnt/jtest-obs-fs02
# sudo chmod 777 /mnt/jtest-obs-fs02

# sudo chown root:root /mnt/jtest-obs-fs02
# sudo mount -t wekafs -o mode=udp jtest-obs-fs02 /mnt/jtest-obs-fs02


# https://www.notion.so/wekaio/How-to-pause-and-resume-OBS-detach-operation-18af0d88c1f24c6caa0c2326cf5ac26a?pvs=4
# How to pause and resume OBS detach operation
# Starting weka 3.5.6 we can use manhole to pause and resume OBS detach operation.
# The example below run on cluster with six hosts with single compute node on each host and container name is default_3.5.6
# Create or update file name buckets in /opt/weka/data/<container name>/current/faults/ with the following information: all:stall_migrate
# for i in $(cat my_hosts); do ssh $i 'sudo sh -c "echo all:stall_migrate >> /opt/weka/data/default_3.5.6/current/faults/buckets"' ; done
# for i in $(cat my_hosts); do ssh $i 'cat /opt/weka/data/default_3.5.6/current/faults/buckets' ; done

# Run “bucket_reload_manual_overrides” manhole on all compute node slots
# for i in $(cat my_hosts); do for s in  {1..1}; do sudo weka local -e WEKA_USERNAME=admin -e WEKA_PASSWORD=XXXX run manhole -H$i -s$s bucket_reload_manual_overrides; done ; done
# for i in $(cat my_hosts); do ssh $i 'sudo sed -i 's/all:stall_migrate//g' /opt/weka/data/default_3.5.6/current/faults/buckets' ; done

# Verify in traces using #MANUAL_OVERRIDE that the command completed successfully
# !https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e2da22c4-d061-46a0-8c7f-64e0d65cb704/image-20200123-083310.png
# Using weka cluster tasks command you will see the detach operation is not progressing.
# In order to resume detach operation you will need to clear “all:stall_migrate” from the buckets file and run the manhole command again

# for i in $(cat my_hosts); do ssh $i 'cat /opt/weka/data/default_3.5.6/current/faults/buckets' ; done
# for i in $(cat my_hosts); do for s in  {1..1}; do sudo weka local -e WEKA_USERNAME=admin -e WEKA_PASSWORD=XXXXXX run manhole -H$i -s$s bucket_reload_manual_overrides; done ; done

# Verify in traces using #MANUAL_OVERRIDE that the command completed successfully

# mount -t wekafs -o net=udp 192.168.0.181:/jtest-obs-fs01 /mnt/jtest-obs-fs01
# wekafs_mount_helper: Mounting 192.168.0.181:/jtest-obs-fs01 on /mnt/jtest-obs-fs01
# Basing mount on container drives0
# error: A backend weka container is already running.
#
#At this point weka does not support mixing backend and stateless client containers on the same host.
#If you’re sure the currently running containers are not in use anymore, you can stop and delete them by running ‘weka local stop’ and ‘weka local rm’.
#Please note that running these commands on backend hosts could cause data loss.

# weka fs tier s3 -v --name=jtest-obs-tier01
#UID                                   OBS ID  OBS NAME     OBS BUCKET ID  OBS BUCKET NAME   SITE   UPLOAD  DOWNLOAD  REMOVE  NODES UP  NODES DOWN  NODES UNKNOWN  LAST ERRORS  PROTOCOL  HOSTNAME                         PORT  BUCKET            AUTH METHOD    REGION          ACCESS KEY ID         SECRET KEY  STATUS  UPTIME    DOWNLOAD BANDWIDTH  UPLOAD BANDWIDTH   REMOVE BANDWIDTH   ERRORS TIMEOUT  PREFETCH MB  MAX CONCURRENT DOWNLOADS  MAX CONCURRENT UPLOADS  MAX CONCURRENT REMOVALS  MAX EXTENTS PER UPLOAD  MAX DATA UPLOAD SIZE  UPLOAD TAGS
#ce27d195-b405-9049-7b54-c526e26c21a1  4       jtest-obs01  3              jtest-obs-tier01  LOCAL  UP      UP        UP      80        0           0                           HTTPS     s3.ap-northeast-2.amazonaws.com  443   jack-kr-bucket02  AWSSignature4  ap-northeast-2  changeme              changeme  UP      0:40:06h  _mbps: 4294967295   _mbps: 4294967295  _mbps: 4294967295  300             0            64                        64                      64                                                                     Disabled

# Follow up
# We can only track progress of the 64MB blobs. These are now completed for pgen_genomes.
# To see progress of this part of the migration:
# weka debug jrpc filesystems_get_obs_usage filesystem=<filesystemname>

# weka debug jrpc filesystems_get_obs_usage filesystem=pgen_genomes
# weka debug jrpc filesystems_get_obs_usage filesystem=pgen_genomes

# weka fs tier obs
# ID        NAME            NUM OF BUCKETS  UPLOAD BUCKETS UP  DOWNLOAD BUCKETS UP  REMOVE BUCKETS UP
# ObsId<0>  default-local   0               0                  0                    0
# ObsId<1>  default-remote  0               0                  0                    0
# ObsId<4>  jtest-obs01     1               1                  1                    1

# [root@cst2 ~]# weka fs tier location /mnt/jtest-obs-fs02
# PATH                 FILE TYPE  FILE SIZE  CAPACITY IN SSD (WRITE-CACHE)  CAPACITY IN SSD (READ-CACHE)  CAPACITY IN OBJECT STORAGE  CAPACITY IN REMOTE STORAGE
# /mnt/jtest-obs-fs02  directory  0 B        0 B                            0 B                           0 B                         0 B


# Where ever this command is ran it must be mounted to Weka. <path> is the full path of the file.
# fetch      Fetch object-stored files to SSD storage
# weka fs tier fetch /mnt/jtest-obs-fs02

# weka fs tier location /mnt/jtest-obs-fs02/1.txt
# PATH                       FILE TYPE  FILE SIZE  CAPACITY IN SSD (WRITE-CACHE)  CAPACITY IN SSD (READ-CACHE)  CAPACITY IN OBJECT STORAGE  CAPACITY IN REMOTE STORAGE
# /mnt/jtest-obs-fs02/1.txt  regular    0 B        0 B                            0 B                           0 B                         0 B
# weka fs tier fetch /mnt/jtest-obs-fs02/1.txt
~~~

## OBS
~~~
# $ weka user login admin Changeme1234
#
# $ weka fs
# FILESYSTEM ID  FILESYSTEM NAME  USED SSD  AVAILABLE SSD  USED TOTAL  AVAILABLE TOTAL  THIN PROVISIONED  THIN PROVISIONED MINIMUM SSD  THIN PROVISIONED MAXIMUM SSD
# 0              jtest-fs01       20.47 KB  7.51 GB        20.47 KB    7.51 GB          False

# Checking
# Command: weka fs tier s3 add
# weka fs tier obs add jtest-obs-tier01
# weka fs tier obs update jtest-obs-tier01
# weka fs tier ops
# weka fs tier obs delete jtest-obs-tier01
~~~


## Destroy OBS
~~~
#
# - debug: msg={{ "Disable object store" }}

# $ weka s3 bucket create name jtest-bucket01 --policy public --policy-json
# Cannot pass option "policy-json" for command "weka s3 bucket create" without its value, please make sure to pass a value and check that the format is correct if a value was passed


# $ weka user login admin Changeme12\!\@
# +------------------------------+
# | Login completed successfully |
# +------------------------------+

# $ weka s3 bucket create jtest-bucket01 --policy public
# error: Internal error: core.exception.RangeError: Index/key not found
# in FileSystemRow[RawTypedIdentifier!("FSId", uint, 4294967295u, 4294967295u, FMT(""), false)] :
# FSId<4294967295>

# $ weka fs
# FILESYSTEM ID  FILESYSTEM NAME  USED SSD  AVAILABLE SSD  USED TOTAL  AVAILABLE TOTAL  THIN PROVISIONED  THIN PROVISIONED MINIMUM SSD  THIN PROVISIONED MAXIMUM SSD
# 0              jtest-fs01       20.47 KB  7.51 GB        20.47 KB    7.51 GB          False

# $ weka s3 bucket create jtest-bucket01 --policy public --fs-name jtest-fs01
# error: Could not find a running S3 container to run the command in

# $ weka s3 bucket create jtest-bucket01 --policy public --fs-name jtest-fs01 --fs-id 0
# error: Only one of fs-name or fs-id can be used

#
#- name:  Delete WekaFS attached into Object Store
#  shell: |
#    weka fs delete s3fs -f
# register: delete_s3fs
#  ignore_errors: true
#  when: inventory_hostname in hostvars[groups['workers'][0]]['ansible_hostname']
#- debug: msg={{ delete_s3fs }}
~~~

## Destroy OBS 2
~~~

# error: Operation not allowed. test-snap01 in obs-new-fs01 is currently synchronizing, please try again later.
# weka fs snapshot delete obs-new-fs01 test-snap01 -f
#
# error: Snapshot test-snap01 in filesystem obs-new-fs01 is being deleted.
#
# weka fs snapshot
# SNAPSHOT ID  FILESYSTEM    NAME         ACCESS POINT              IS WRITABLE  CREATION TIME        LOCAL OBJECT STATUS  LOCAL OBJECT PROGRESS  REMOTE OBJECT STATUS  REMOTE OBJECT PROGRESS  IS BEING REMOVED
# 14          obs-new-fs01  test-snap01  @GMT-2024.03.24-12.23.59  False        2024-03-24T21:23:59  UPLOADING            6%                     NONE                  N/A
# True

# Above error could be fixed after reconfiguring tiering correctly. In jack's case, wrong port 9000 was configured mistakenly for minio s3
# weka fs tier release
# weka fs tier release --non-existing error
# weka fs tier release --non-existing warn
# weka fs tier release --non-existing ignore

# weka fs snapshot download obs-new-fs01 /mnt
# error: Operation is forbidden: Incremental snapshot download is not supported on this version
~~~

