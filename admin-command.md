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
