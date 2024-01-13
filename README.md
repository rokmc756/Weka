## What is Weka Data Platform and How is it's Architecture
The WEKA filesystem (WekaFS™) redefines storage solutions with its software-only approach, compatible with standard AMD or Intel x86-based servers and NVMe SSDs. It eliminates the need for specialized hardware, allowing easy integration of technological advancements without disruptive upgrades. WekaFS addresses common storage challenges by removing performance bottlenecks, making it suitable for environments requiring low latency, high performance, and cloud scalability.
Use cases span various sectors, including AI/ML, Life Sciences, Financial Trading, Engineering DevOps, EDA, Media Rendering, HPC, and GPU pipeline acceleration. Combining existing technologies and engineering innovations, WekaFS delivers a powerful, unified solution that outperforms traditional storage systems, efficiently supporting various workloads.
WekaFS is a fully distributed parallel filesystem leveraging NVMe Flash for file services. Integrated tiering seamlessly expands the namespace to and from HDD object storage, simplifying data management. The intuitive GUI allows easy administration of exabytes of data without specialized storage training.
WekaFS stands out with its unique architecture, overcoming legacy systems’ scaling and file-sharing limitations. Supporting POSIX, NFS, SMB, S3, and GPUDirect Storage, it offers a rich enterprise feature set, including snapshots, clones, tiering, cloud-bursting, and more.
Benefits include high performance across all IO profiles, scalable capacity, robust security, hybrid cloud support, private/public cloud backup, and cost-effective flash-disk combination. WekaFS ensures a cloud-like experience, seamlessly transitioning between on-premises and cloud environments.
![alt text](https://raw.githubusercontent.com/rokmc756/Weka/main/roles/weka/images/weka_architecture.webp)
WekaFS functionality running in its RTOS within the Linux container (LXC) is comprised of the following software components:
File services (frontend): Manages multi-protocol connectivity.
File system computing and clustering (backend): Manages data distribution, data protection, and file system metadata services.
SSD drive agent: Transforms the SSD into an efficient networked device.
Management process: Manages events, CLI, statistics, and call-home capability.
Object connector: Read and write to the object store.
By bypassing the kernel, WekaFS achieves faster, lower-latency performance, portable across bare-metal, VM, containerized, and cloud environments. Efficient resource consumption minimizes latency and optimizes CPU usage, offering flexibility in shared or dedicated environments.
![alt text](https://raw.githubusercontent.com/rokmc756/Weka/main/roles/weka/images/wekafs_storage_architecture.webp)
WekaFS design departs from traditional NAS solutions, introducing multiple filesystems within a global namespace that share the same physical resources. Each filesystem has its unique identity, allowing customization of snapshot policies, tiering, role-based access control (RBAC), quota management, and more. Unlike other solutions, filesystem capacity adjustments are dynamic, enhancing scalability without disrupting I/O.
The WEKA system offers a robust, distributed, and highly scalable storage solution, allowing multiple application servers to access shared filesystems efficiently and with solid consistency and POSIX compliance.

## What is this ansible playbook for Weka Data Platform?
It is ansible playbook to deploy Weka Data Platform conveniently and quickly on Baremetal, Virtual Machines and Cloud Infrastructure.\
It provide also configure WekaFS and Client Software to connect from client to Weka Data Platform when deploying it.\
The main purpose of this project is actually very simple. Because there are many jobs to install different kind of Weka Data Platform\
versions and reproduce issues & test features as a support engineer. I just want to spend less time for it.\

If you are working with Weka Data Platfrom  such as Developer, Administrator, Field Engineer or Database Administrator\
you could also utilize it very conviently as saving time.

## Where is this ansible playbook from and how is it changed?
It's originated by itself.

## Supported Weka Data Platform Versions
* Weka 4.2.1 and higher version
## Supported Platform and OS
* Virtual Machines including on Cloud
* Baremetal
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
```
$ git clone https://github.com/rokmc756/Weka
$ cd Weka
$ vi Makefile
~~ snip
ANSIBLE_HOST_PASS="changeme"    # It should be changed with password of user in ansible host that vmware-postgres would be run.
ANSIBLE_TARGET_PASS="changeme"  # It should be changed with password of sudo user in managed nodes that vmware-postgres would be installed.
~~ snip
```

#### 2) Configure inventory
```
$ vi ansible-hosts
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[workers]
weka4-node01 ansible_ssh_host=192.168.0.181
weka4-node02 ansible_ssh_host=192.168.0.182
weka4-node03 ansible_ssh_host=192.168.0.183
weka4-node04 ansible_ssh_host=192.168.0.184
weka4-node05 ansible_ssh_host=192.168.0.185

[clients]
weka4-node06 ansible_ssh_host=192.168.0.186
weka4-node07 ansible_ssh_host=192.168.0.187
```
#### 3) Download Weka Data Platform binary
```
$ wget -P . --auth-no-challenge https://xxxxxxxxxxxxxxxx:@get.weka.io/dist/v1/pkg/weka-4.2.7.64.tar
$ mv weka-4.2.7.64.tar roles/weka/files
```

#### 4) Configure variables for
```
$ vi roles/weka/vars/main.yml
weka:
  major_version: 4
  minor_version: 2
  build_version: 7
  patch_version: 64
  base_path: /root
  bin_type: tar
  admin_user: admin
  admin_default_pass: admin
  admin_change_pass: "Changeme12!@"
  download: false
wekafs:
  group: default
  fs: default
  size: 5GiB
cpu_cores:
  container_max_id: "{{ groups['workers'] | length -1 }}"
  container_num: 3
  drives_num: 1
  compute_num: 2
  frontends_num: 0
drives:
  data: 3
  parity: 2
~~ snip
```
#### 5) Deploy Weka Data Platform 
```
$ vi install-hosts.yml
---
- hosts: all
  become: yes
  vars:
    print_debug: true
    install_pkgs: true
    deploy_weka: false
    create_wekafs: true
    config_client: false
  roles:
    - { role: init-hosts }
    - { role: weka }

$ make install
```
#### 6) Destroy Weka Data Platform
```
$ vi uninstall-hosts.yml
- hosts: all
  become: yes
  vars:
    print_debug: true
    uninstall_pkgs: true
    delete_wekafs: true
    unconfig_client: false
    destroy_weka: false
  roles:
    - { role: weka }
    - { role: init-hosts }

$ make uninstall
```

## Planning
xxxx\
xxxx\
xxxx
