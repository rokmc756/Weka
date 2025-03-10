## What is Weka Data Platform and How it's Architecture looks like?
The WEKA filesystem (WekaFS™) redefines storage solutions with its software-only approach, compatible with standard AMD or Intel x86-based servers and NVMe SSDs. It eliminates the need for specialized hardware, allowing easy integration of technological advancements without disruptive upgrades. WekaFS addresses common storage challenges by removing performance bottlenecks, making it suitable for environments requiring low latency, high performance, and cloud scalability.
Use cases span various sectors, including AI/ML, Life Sciences, Financial Trading, Engineering DevOps, EDA, Media Rendering, HPC, and GPU pipeline acceleration. Combining existing technologies and engineering innovations, WekaFS delivers a powerful, unified solution that outperforms traditional storage systems, efficiently supporting various workloads.
WekaFS is a fully distributed parallel filesystem leveraging NVMe Flash for file services. Integrated tiering seamlessly expands the namespace to and from HDD object storage, simplifying data management. The intuitive GUI allows easy administration of exabytes of data without specialized storage training.
WekaFS stands out with its unique architecture, overcoming legacy systems’ scaling and file-sharing limitations. Supporting POSIX, NFS, SMB, S3, and GPUDirect Storage, it offers a rich enterprise feature set, including snapshots, clones, tiering, cloud-bursting, and more.
Benefits include high performance across all IO profiles, scalable capacity, robust security, hybrid cloud support, private/public cloud backup, and cost-effective flash-disk combination. WekaFS ensures a cloud-like experience, seamlessly transitioning between on-premises and cloud environments.
![alt text](https://raw.githubusercontent.com/rokmc756/Weka/main/roles/weka/images/weka_architecture.webp)
WekaFS functionality running in its RTOS within the Linux container (LXC) is comprised of the following software components:
* **File services (frontend)**: Manages multi-protocol connectivity.
* **File system computing and clustering (backend)**: Manages data distribution, data protection, and file system metadata services.
* **SSD drive agent**: Transforms the SSD into an efficient networked device.
* **Management process**: Manages events, CLI, statistics, and call-home capability.
* **Object connector**: Read and write to the object store.

By bypassing the kernel, WekaFS achieves faster, lower-latency performance, portable across bare-metal, VM, containerized, and cloud environments. Efficient resource consumption minimizes latency and optimizes CPU usage, offering flexibility in shared or dedicated environments.

![alt text](https://raw.githubusercontent.com/rokmc756/Weka/main/roles/weka/images/wekafs_storage_architecture.webp)

WekaFS design departs from traditional NAS solutions, introducing multiple filesystems within a global namespace that share the same physical resources. Each filesystem has its unique identity, allowing customization of snapshot policies, tiering, role-based access control (RBAC), quota management, and more. Unlike other solutions, filesystem capacity adjustments are dynamic, enhancing scalability without disrupting I/O.
The WEKA system offers a robust, distributed, and highly scalable storage solution, allowing multiple application servers to access shared filesystems efficiently and with solid consistency and POSIX compliance.

## What is this Ansible Playbook for Weka Data Platform?
It is ansible playbook to deploy Weka Data Platform conveniently and quickly on Virtual Machines and Cloud Infrastructure.
It provide also configure NFS, S3, SMB and WekaFS and it's Client to connect from client to Weka Data Platform when deploying it.
The main purpose of this project is actually very simple. Because there are many jobs to deploy different kind of Weka Data Platform
versions and reproduce issues & test features as a support engineer. I just want to spend less time for it.

If you are working with Weka Data Platfrom such as Developer, Administrator, Field Engineer you could also utilize it very conviently as saving time.

## Where is this ansible playbook from and how is it changed?
It's originated by itself.

## VMware Internal Architecture for Weka
![alt text](https://raw.githubusercontent.com/rokmc756/Weka/main/roles/weka/images/weka_vmware_architecture.png)

## Supported Weka Data Platform Versions
* Weka 4.2.1 and higher version

## Supported Platform and OS
* Virtual Machines including on VMWare or Private Cloud
* Weka 4.2.1 iso and built based on Rocky Linux 8.4
* Rocky Linux 8.x
* Rocky Linux 9.x

## Prerequisite
* MacOS or Fedora/CentOS/RHEL should have installed ansible as ansible host.
* Supported OS for ansible target host should be prepared with package repository configured such as yum, dnf and apt

## Prepare ansible host to run vmware-postgres ansible playbook
* MacOS
```
$ xcode-select --install
$ brew install ansible
$ brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
```
* Fedora/CentOS/RHEL
```
$ sudo yum install ansible
```

## Prepareing OS Environment
* Configure Yum / Local & EPEL Repostiory
* CPU Number : 10
* RAM : 32GiB
* Disk : /dev/sda (150GiB), /dev/sdb (150GiB), /dev/nvme0n1(20GiB), /dev/nvme0n2 (20GiB)
* Network : 6 vNICs ( Configure with scripts/weka-netconfig.sh with hostname is xx-node0x
* IPs : 192.168.0.171-5, 192.168.1.171-5, 192.168.1.181-5, 192.168.1.191-5, 192.168.1.201-5, 192.168.1.211-5
* Netmask: 255.255.255.0
* Gateway : 192.168.0.17x, 192.168.1.21x


## Download / configure / run Weka Data Platform
#### 1) Clone Ansible Playbook of Weka
```
$ git clone https://github.com/rokmc756/Weka
```

#### 2) Configure Inventory
```
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[control]
rk9-node01 ansible_ssh_host=192.168.1.211

[workers]
rk9-node01 ansible_ssh_host=192.168.1.211
rk9-node02 ansible_ssh_host=192.168.1.212
rk9-node03 ansible_ssh_host=192.168.1.213
rk9-node04 ansible_ssh_host=192.168.1.214
rk9-node05 ansible_ssh_host=192.168.1.215

[clients]
rk9-node06 ansible_ssh_host=192.168.0.216
```
#### 3) Download Weka Data Platform Software binary
```
$ wget -P . --auth-no-challenge https://xxxxxxxxxxxxxxxx:@get.weka.io/dist/v1/pkg/weka-4.2.9.28.tar
$ mv weka-4.2.9.28.tar roles/weka/files
```

#### 4) Configure Variable to Define the Name, Port, Core IDs, Size of Memory and Numbers of CPU Cores and so on for Drives/Compute/Frontend Containers
```yaml
$ vi roles/weka/var/main.yml
~~ snip
# Total_cores sholud be same as number of virtual network adpaters hold by a SCB default container for DPDK in Virtual Environment
# total_cores: "{{ container.drives.cores|int + container.compute.cores|int + container.frontend.cores|int }}"
container:
   total_cores: "4"
   spare_memory: "8GiB"
   weka_huge_page_memory: "1.4GiB"
   default:
     name: "default"              # name: "jack-kr-scb" - It's very strange that there are network errors, SYNC, DOWN not UP in case that container name is not default.
     mem_size: "9GiB"
     port: 14000
   drives:
     name: "drives0"
     cores: "1"
     memory: "2.5GiB"             # 2.3GiB default, 0 means automatical allocation
     core_ids: "1,2"
     data: "3"
     parity: "2"
     hotspare: "0"                # 0 means automaical allocation
     devices: "/dev/nvme0n1 /dev/nvme0n2"
     port: "14000"
     options:
   compute:
     name: "compute0"
     cores: "1"
     memory: "3.5GiB"             # 3.3GiB default, 0 means automatical allocation
     core_ids: "3,4"
     port: "14200"
     options:                     # "--allow-mix-setting"
   frontend:
     name: "frontend0"
     cores: "1"
     memory: "2.5GiB"             # 2.3 GiB default
     core_ids: "8"
     port: "14400"
     options:                     # "--allow-mix-setting"
   envoy:
     name: envoy
   protocol:
     memory: "0GiB"
~~ snip
```

#### 5) Configure Global Variables to Deploy Weka Data Platform
$ vi group_vars/all.yml
```
~~ snip
_weka:
  cluster_name: jack-kr-weka
  major_version: "4"
  minor_version: "2"
  build_version: "9"
  patch_version: ".28"
  download_url: "get.weka.io/dist/v1/pkg"
  download: false
  base_path: /root
  admin_user: admin
  admin_default_pass: admin
  admin_change_pass: "Changeme12!@"
  bin_type: tar
  host_num: "{{ groups['workers'] | length }}"
  nvme: true
  net:
    conn: "dpdk"                    # dpdk or udp
    gateway: "192.168.0.1"
    ha1: 1
    ha2: 2
  backend:
    scb: false
    mcb: true
    net:
      type: "virtual"               # or physical
      ipaddr0: "192.168.0.17"
      ipaddr1: "192.168.1.17"
      ipaddr2: "192.168.1.18"
      ipaddr3: "192.168.1.19"
      ipaddr4: "192.168.1.20"
      ipaddr5: "192.168.1.21"
      ipaddr6: "192.168.2.17"
      data_plane: netdev2
  obs: true
  fs: true
  protocol:
    smb: true
    nfs: false
    s3: false
  client:
    smb: true
    nfs: false
    s3: false
    wekafs: true
    net:
      type: "virtual"               # or physical
      cores: 1
      ipaddr0: "192.168.0.17"
      ipaddr1: "192.168.1.17"
      ipaddr2: "192.168.1.18"
      ipaddr3: "192.168.1.19"
      ipaddr4: "192.168.1.20"
      ipaddr5: "192.168.1.21"
      ipaddr6: "192.168.2.17"
  ext_storage:
    net:
      ipaddr0: "192.168.0."
      ipaddr1: "192.168.1."
      ipaddr2: "192.168.2."
  tools:                                       # git clone https://github.com/weka/tools; cd tools ; git checkout v1.3.8
    name: tools
    major_version: 1
    minor_version: 3
    patch_version: 8
    download: false
    bin_type: tar.gz
  wsa:
    download_url: "get.weka.io/api/v1/wsa/4.2.9.28/"
  wma:
    download_url: "get.weka.io/api/v1/wms/1.2.2/"
~~ snip
```

#### 6) Configure Temp Setup File
```
$ vi setup-temp.yml.tmp
---
- hosts: all
  become: yes
  vars:
    print_debug: true
  roles:
    - temp
```

#### 7) Configure Makefile
~~~
~~ snip
# For All Roles
%:
        @cat Makefile.tmp  | sed -e 's/temp/${*}/g' > Makefile.${*}
        @cat setup-temp.yml.tmp | sed -e 's/    - temp/    - ${*}/g' > setup-${*}.yml
        @make -f Makefile.${*} r=${r} s=${s} c=${c} USERNAME=${USERNAME}
        @rm -f setup-${*}.yml Makefile.${*}
~~ snip
~~~


## YouTube Video Demo to Deploy Weka Data Platform
* Links has been generated by https://githubvideo.com

### 00 - How to initialize linux hosts to prepare deploying Weka Data Platform 4.x
~~~
$ make hosts r=init s=all
~~~
[![YouTube](http://i.ytimg.com/vi/5o82n1r_5Gc/hqdefault.jpg)](https://www.youtube.com/watch?v=5o82n1r_5Gc)

### 01 - Upload and Install Weka Software Binary 1
~~~
$ make weka r=upload s=bin
~~~
[![YouTube](http://i.ytimg.com/vi/3ycJiYpm1SI/hqdefault.jpg)](https://www.youtube.com/watch?v=3ycJiYpm1SI)

### 02 - Upload and Install Weka Software Binary and Remove Default Conteinrs
~~~
$ make weka r=setup s=bin
$ make weka r=remove s=default
~~~
[![YouTube](http://i.ytimg.com/vi/YtPkZyiDUEw/hqdefault.jpg)](https://www.youtube.com/watch?v=YtPkZyiDUEw)

### 03 - Deploy Weka Multi Container Backend Cluster
~~~
$ vi group_vars/all.yml
~~ snip
_weka:
~~ snip
  net:
    conn: "dpdk"                    # dpdk or udp
    gateway: "192.168.0.1"
    ha1: 1
    ha2: 2
  backend:
    scb: false
    mcb: true
~~ snip

$ make weka r=deploy s=mcb
$ make weka r=change s=passwd
~~~

### 04 - Deploy Weka Single Container Backend Cluster
~~~
$ vi group_vars/all.yml
~~ snip
_weka:
~~ snip
  net:
    conn: "dpdk"                    # dpdk or udp
    gateway: "192.168.0.1"
    ha1: 1
    ha2: 2
  backend:
    scb: true
    mcb: false
~~ snip

$ make weka r=deploy s=scb
$ make weka r=change s=passwd
~~~

### 05 - Start and Stop Weka IO Operation
~~~
$ make weka r=start s=io
$ make weka r=stop s=io
~~~
[![YouTube](http://i.ytimg.com/vi/1TBoCOItN7Y/hqdefault.jpg)](https://www.youtube.com/watch?v=1TBoCOItN7Y)

### 06 - Create and Delete Weka Filesystem and Client
~~~
$ make wekafs r=create s=fs
$ make wekafs r=setup s=client

$ make wekafs r=delete s=fs
$ make wekafs r=remove s=client
~~~
[![YouTube](http://i.ytimg.com/vi/URcm2rLN9L0/hqdefault.jpg)](https://www.youtube.com/watch?v=URcm2rLN9L0)

### 07 - Create S3 Backends Cluster
~~~
$ make s3 r=deploy s=backend
$ make s3 r=setup s=client
~~~
[![YouTube](http://i.ytimg.com/vi/bk8rzx3HU5U/hqdefault.jpg)](https://www.youtube.com/watch?v=bk8rzx3HU5U)

### 08 - Destroy S3 Backends Cluster
~~~
$ make s3 r=remove s=client
$ make s3 r=destroy s=backend
~~~
[![YouTube](http://i.ytimg.com/vi/wR3_4LdWZY0/hqdefault.jpg)](https://www.youtube.com/watch?v=wR3_4LdWZY0)

### 09 - Create NFS Backends Cluster
~~~
$ make nfs r=deploy s=backend
$ make nfs r=setup s=client
~~~
[![YouTube](http://i.ytimg.com/vi/Uh_MJL-wD9o/hqdefault.jpg)](https://www.youtube.com/watch?v=Uh_MJL-wD9o)

### 10 - Destroy NFS Backends Cluster
~~~
$ make nfs r=remove s=client
$ make nfs r=destroy s=backend
~~~
[![YouTube](http://i.ytimg.com/vi/9uob3-jG1u8/hqdefault.jpg)](https://www.youtube.com/watch?v=9uob3-jG1u8)

### 11 - Create SMB Backends Cluster
~~~
$ make smb r=deploy s=backend
$ make smb r=setup s=client
~~~
[![YouTube](http://i.ytimg.com/vi/-teDTpbS3bI/hqdefault.jpg)](https://www.youtube.com/watch?v=-teDTpbS3bI)

### 12 - Destroy SMB Backend Cluster
~~~
$ make smb r=remove s=client
$ make smb r=destroy s=backend
~~~
[![YouTube](http://i.ytimg.com/vi/SwoobVV5Ess/hqdefault.jpg)](https://www.youtube.com/watch?v=SwoobVV5Ess)

### 13 - Deploy Object Store
~~~
$ make obs r=deploy s=tier
~~~
[![YouTube](http://i.ytimg.com/vi/Fv0qhIy4L1A/hqdefault.jpg)](https://www.youtube.com/watch?v=Fv0qhIy4L1A)

### 14 - Destroy Object Store
~~~
$ make obs r=destroy s=tier
~~~
[![YouTube](http://i.ytimg.com/vi/1_4Kl5GonkY/hqdefault.jpg)](https://www.youtube.com/watch?v=1_4Kl5GonkY)

### 15 - Force Destroy MCB Containers
~~~
$ make weka r=destroy s=mcb c=force
~~~

### 16 - Force Destroy MCB Containers
~~~
$ make weka r=destroy s=mcb c=force
~~~

### 17 - Destroy Weka Software Instance
~~~
$ make weka r=destroy s=bin
~~~

## Planning
- [x] Configure NTP
- [ ] Configuring WekaFS Persistent and Stateless Clients both
- [ ] Disable Numa Balancing
- [ ] Enable Swap
- [ ] Configure to Disable SELinux and Firewalld
- [ ] Need to imporove algorithm which network adapters should be allocated into drives,compute,frontend containers in set-virt-net-facts.yml
- [ ] Need to modify and add weka role for Baremetal

