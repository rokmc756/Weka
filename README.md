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
* Virtual Machines including on Cloud
* Weka 4.2.1 iso built based on Rocky Linux 8.4

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
## Prepareing OS
* Configure Yum / Local & EPEL Repostiory
## Download / configure / run Weka Data Platform
#### 1) Clone Ansible Playbook of Weka
```
$ git clone https://github.com/rokmc756/Weka
```

#### 2) Configure Inventory
```
$ vi ansible-hosts
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[workers]
rk8-node01 ansible_ssh_host=192.168.0.171
rk8-node02 ansible_ssh_host=192.168.0.172
rk8-node03 ansible_ssh_host=192.168.0.173
rk8-node04 ansible_ssh_host=192.168.0.174
rk8-node05 ansible_ssh_host=192.168.0.175

[clients]
ubt22-client01 ansible_ssh_host=192.168.0.61
ubt22-client02 ansible_ssh_host=192.168.0.62
ubt22-client03 ansible_ssh_host=192.168.0.63
```
#### 3) Download Weka Data Platform Software binary
```
$ wget -P . --auth-no-challenge https://xxxxxxxxxxxxxxxx:@get.weka.io/dist/v1/pkg/weka-4.2.9.28.tar
$ mv weka-4.2.9.28.tar roles/weka/files
```

#### 4) Configure variables for informations to deploy Weka Data Platform
```
$ vi group_vars/all.yml
ansible_ssh_pass: "changeme"
ansible_become_pass: "changeme"
weka:
  cluster_name: jack-kr-weka-mcb
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
      ipaddr0: "192.168.0."
      ipaddr1: "192.168.1.17"
      ipaddr2: "192.168.1.18"
      ipaddr3: "192.168.1.19"
      ipaddr4: "192.168.1.20"
      ipaddr5: "192.168.1.21"
      data_plane: netdev1
  obs: true
  fs: true
  protocol:
    nfs: true
    s3: false
    smb: false
  client:
    wekafs: true
    nfs: true
    smb: false
    s3: false
    net:
      type: "virtual"               # or physical
      cores: 1
      ipaddr0: "192.168.0.6"
      ipaddr1: "192.168.1.6"
      ipaddr2: "192.168.1.7"
      ipaddr3: "192.168.1.8"
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
#### 5) Upload Weka Software Software Binary
```
$ make upload
```
#### 6) Deploy Weka Data Platform Software Binary
```
$ vi install.yml
---
- hosts: all
  become: yes
  vars:
    print_debug: true
  roles:
    - { role: init-hosts }
    - { role: weka }
    - { role: wekafs }
    - { role: obs }
    - { role: smb }
    - { role: nfs }
    - { role: s3 }

$ make install
```
#### 7) Destroy Weka Data Platform Software
```
$ vi uninstall.yml
- hosts: all
  become: yes
  vars:
    print_debug: true
  roles:
    - { role: s3 }
    - { role: nfs }
    - { role: smb }
    - { role: obs }
    - { role: wekafs }
    - { role: weka }
    - { role: init-hosts }

$ make uninstall
```

## Video Demo to deploy Weka Data Platform
00 - How to initialize linux hosts to prepare deploying Weka Data Platform 4.x\
[![Video Label]((http://img.youtube.com/vi/5o82n1r_5Gc?/0.jpg)](https://youtu.be/5o82n1r_5Gc?si=H3bF9iixSfESsPFl)

01 - Upload and Install Weka Software Binary 1\
[![Video Label]((http://img.youtube.com/vi/3ycJiYpm1SI/0.jpg)](https://youtu.be/3ycJiYpm1SI?si=UgACMlRbEMdHQXwU)

01 - Upload and Install Weka Software Binary 2\
[![Video Label]((http://img.youtube.com/vi/YtPkZyiDUEw/0.jpg)](https://youtu.be/YtPkZyiDUEw?si=mpiSY20vx8CjnGVU)

02 - Deploy Weka Multi Container Backend Cluster\
[![Video Label]((http://img.youtube.com/vi/1TBoCOItN7Y/0.jpg)](https://youtu.be/1TBoCOItN7Y?si=Z6cVffR1PoU9_80v)

03 - Create Weka Filesystem\
[![Video Label]((http://img.youtube.com/vi/URcm2rLN9L0/0.jpg)](https://youtu.be/URcm2rLN9L0?si=tCPSH-HJxe-gzsF2)

04 - Create S3 Backends Cluster\
[![Video Label]((http://img.youtube.com/vi/bk8rzx3HU5U/0.jpg)](https://youtu.be/bk8rzx3HU5U?si=3JTwXmBI7RYGXthH)

05 - Destroy S3 Backends Cluster\
[![Video Label]((http://img.youtube.com/vi/wR3_4LdWZY0/0.jpg)](https://youtu.be/wR3_4LdWZY0?si=_GGCg09jEQ5Omx17)

06 - Create NFS Backends Cluster\
[![Video Label]((http://img.youtube.com/vi/Uh_MJL-wD9o/0.jpg)](https://youtu.be/Uh_MJL-wD9o?si=MfjVNVcTbLMWEi7x)

07 - Destroy NFS Backends Cluster\
[![Video Label]((http://img.youtube.com/vi/9uob3-jG1u8/0.jpg)](https://youtu.be/9uob3-jG1u8?si=OYyF9tEJOGurkw91)





## Planning
Need to modify and add weka role for Baremetal
