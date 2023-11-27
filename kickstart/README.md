## Build NFS Server

OS : Rocky Linux 9.

~~~
[root@localhost ~]#  hostnamectl set-hostname rk9-pxe
[root@localhost ~]# systemctl stop firewalld
[root@localhost ~]#  systemctl disable firewalld

[root@localhost ~]#  vi /etc/sysconfig/selinux
~~ snip
SELINUX=disabled
SELINUXTYPE= can take one of these three values:
targeted - Targeted processes are protected,
minimum - Modification of targeted policy. Only selected processes are protected.
mls - Multi Level Security protection.
# SELINUXTYPE=targeted
~~ snip

[root@rk9-pxe ~]#  yum update -y
[root@rk9-pxe ~]#  reboot
~~~

~~~
[root@rk9-pxe ~]#  yum install -y nfs-utils
[root@rk9-pxe ~]# vi /etc/idmapd.conf
[General]
~~ snip
Domain = [jtest.pivotal.io](http://jtest.pivotal.io/)
~~ snip

[root@rk9-pxe ~]#  vi /etc/fstab
~~ snip
192.168.0.101:/extra-usb-storage /nfs-share nfs rw,hard,bg,intr,rw,tcp,rsize=65536,wsize=65536 0 0
~~ snip

[root@rk9-pxe ~]# mount -a
~~~

~~~
[root@lab ISOs]# cd /extra-usb-storage/ISOs
[root@lab ISOs]#  curl -vvv -O https://mirror.navercorp.com/rocky/9.3/isos/x86_64/Rocky-9-latest-x86_64-dvd.iso
[root@lab ISOs]#  curl -vvv -O https://mirror.navercorp.com/rocky/8.9/isos/x86_64/Rocky-8.9-x86_64-dvd1.iso
~~~

~~~
[root@rk9-pxe ~]# dnf install tftp-server -y
[root@rk9-pxe ~]# cp /usr/lib/systemd/system/tftp.service /etc/systemd/system/tftp-server.service
[root@rk9-pxe ~]# cp /usr/lib/systemd/system/tftp.socket /etc/systemd/system/tftp-server.socket

[root@rk9-pxe ~]# vi /etc/systemd/system/tftp-server.service
[Unit]
Description=Tftp Server

# Requires=tftp.socket
Requires=tftp-server.socket
Documentation=man:in.tftpd

[Service]
ExecStart=/usr/sbin/in.tftpd -s /var/lib/tftpboot
StandardInput=socket

[Install]
WantedBy=multi-user.target
Also=tftp.socket
~~~

~~~
[root@rk9-pxe ~]# vi /etc/systemd/system/tftp-server.socket
[Unit]
Description=Tftp Server Activation Socket

[Socket]
ListenDatagram=69
BindIPv6Only=both

[Install]
WantedBy=sockets.target

[root@rk9-pxe ~]# systemctl start tftp-server

[root@rk9-pxe ~]# systemctl status tftp-server

[root@rk9-pxe ~]# systemctl enable tftp-server
~~~

~~~
[root@rk9-pxe ~]# dnf install syslinux -y
[root@rk9-pxe ~]# cp /usr/share/syslinux/menu.c32 /var/lib/tftpboot/
[root@rk9-pxe ~]# cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
[root@rk9-pxe ~]# cp /usr/share/syslinux/ldlinux.c32 /var/lib/tftpboot/
[root@rk9-pxe ~]# cp /usr/share/syslinux/libutil.c32 /var/lib/tftpboot/
[root@rk9-pxe ~]# mkdir /var/lib/tftpboot/pxelinux.cfg

[root@rk9-pxe ~]# vi /var/lib/tftpboot/pxelinux.cfg/default
prompt 0
timeout 150
ontimeout local

LABEL local
MENU LABEL Boot Local Disk
localboot 0

LABEL Rocky Linux 8.9
MENU LABEL Rocky Linux 8.9 Install
KERNEL /Linux/Rocky/8.9/vmlinuz
APPEND initrd=/Linux/Rocky/8.9/initrd.img inst.repo=ftp://192.168.0.99/pub/Linux/Rocky/8.9

LABEL Rocky Linux 9.3
MENU LABEL Rocky Linux 9.3 Install
KERNEL /Linux/Rocky/9.3/vmlinuz
APPEND initrd=/Linux/Rocky/9.3/initrd.img inst.repo=ftp://192.168.0.99/pub/Linux/Rocky/9.3
~~~

~~~
[root@lab ISOs]# cd /extra-usb-storage/nfs-share

[root@lab nfsshare]# mkdir -p /extra-usb-storage/nfsshare/ftp-root/pub/Linux/Rocky/8.9
[root@lab nfsshare]# mkdir -p /extra-usb-storage/nfsshare/ftp-root/pub/Linux/Rocky/9.3
[root@lab ISOs]# cd /extra-usb-storage/ISOs
[root@lab ISOs]# mount -o loop Rocky-9-latest-x86_64-dvd.iso /mnt/
[root@lab ISOs]# mount -o loop Rocky-9-latest-x86_64-dvd.iso /mnt/
[root@lab ISOs]# rsync -arv /mnt/* /extra-usb-storage/nfsshare/ftp-root/pub/Linux/9.3/

[root@lab ISOs]# umount /mnt
[root@lab ISOs]# mount -o loop Rocky-8.9-x86_64-dvd1.iso /mnt/
[root@lab ISOs]# rsync -arv /mnt/* /extra-usb-storage/nfsshare/ftp-root/pub/Linux/8.9/
~~~

~~~
[root@rk9-pxe ~]# dnf install vsftpd -y
[root@rk9-pxe ~]# vi /etc/vsftpd/vsftpd.conf

~~ snip
anonymous_enable=YES
local_enable=NO

write_enable=NO
anon_upload_enable=NO
anon_root=/nfs-dir/nfsshare/ftp-root
no_anon_password=YES

chroot_local_user=YES
hide_ids=YES
local_root=/nfs-dir/nfsshare/ftp-root
~~ snip

[root@rk9-pxe ftp-root]# systemctl enable vsftpd
[root@rk9-pxe ftp-root]# systemctl start vsftpd
~~~

~~~
[root@rk9-pxe ~]#  mkdir -p /var/lib/tftpboot/Linux/Rocky/8.9
[root@rk9-pxe ~]#  mkdir -p /var/lib/tftpboot/Linux/Rocky/9.3
[root@rk9-pxe ~]# cp /nfs-dir/nfsshare/ftp-root/pub/Linux/Rocky/8.9/images/pxeboot/initrd.img /var/lib/tftpboot/Linux/Rocky/8.9/
[root@rk9-pxe ~]# cp /nfs-dir/nfsshare/ftp-root/pub/Linux/Rocky/8.9/images/pxeboot/vmlinuz /var/lib/tftpboot/Linux/Rocky/8.9/
[root@rk9-pxe ~]#  cp /nfs-dir/nfsshare/ftp-root/pub/Linux/Rocky/9.3/images/pxeboot/vmlinuz /var/lib/tftpboot/Linux/Rocky/9.3/
[root@rk9-pxe ~]#  cp /nfs-dir/nfsshare/ftp-root/pub/Linux/Rocky/9.3/images/pxeboot/initrd.img /var/lib/tftpboot/Linux/Rocky/9.3/

[root@rk9-pxe ~]# systemctl restart vsftpd
[root@rk9-pxe ~]# systemctl restart tftp-server

[root@lab ~]# firewall-cmd --add-service=tftp --perm
success
[root@lab ~]# firewall-cmd --reload
~~~

## Build DHCP Server for PXE Boot
~~~
[root@rk9-pxe ~]# dnf install dhcp-server -y

[root@rk9-pxe ~]# cat /etc/dhcp/dhcpd.conf
~~ snip
dhcpd_interface = "eth0";
subnet 192.168.0.0 netmask 255.255.255.0 {
option routers 192.168.0.1;
option subnet-mask 255.255.255.0;
range dynamic-bootp 192.168.0.180 192.168.0.220;
default-lease-time 3600;
max-lease-time 7200;
##### pxe setting #####
allow booting;
allow bootp;
next-server 192.168.0.99;    # DHCP and PXE Server IP address should be specified
filename "pxelinux.0";
}

[root@rk9-pxe ~]# systemctl enable dhcpd
[root@rk9-pxe ~]# systemctl start dhcpd

~~~
# Configure Kickstart configuration file
~~~
[root@rk9-pxe ~]# openssl passwd -6 changeme
$6$by53Zw0bD64htr69$cvYjYmALCSoSSVXw69PGyuCIzki6dqQ2sG7NaFSSGxkp/fEkykBxPU6NGcVG/ku9wVEbPeRRde.KT/0MZB2lE.

[root@rk9-pxe 8.9]# vi/nfs-dir/nfsshare/ftp-root/pub/Linux/Rocky/8.9/ks.cfg
#version=RHEL8
#Use graphical install
graphical

#Add a line
url --url="[ftp://192.168.0.99/Linux/Rocky/8.9/BaseOS](ftp://192.168.0.99/Linux/Rocky/8.9/BaseOS)"

#Modify
repo --name="AppStream" --baseurl=ftp://192.168.0.99/Linux/Rocky/8.9/AppStream"
%packages
@^minimal-environment
%end

#Keyboard layouts
keyboard --xlayouts='kr'

#System language
lang ko_KR.UTF-8

#Network information
#network --bootproto=dhcp --device=ens33 --ipv6=auto --activate
#network --bootproto=dhcp --device=ens34 --onboot=off --ipv6=auto
network  --hostname=installtest

#Use CDROM installation media - It should be uncommented to prventing CD boot
#cdrom
#Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda

#Partition clearing information
clearpart --none --initlabel

#Disk partitioning information
part pv.111 --fstype="lvmpv" --ondisk=sda --size=50749
part /boot --fstype="xfs" --ondisk=sda --size=450
volgroup rl --pesize=4096 pv.111
logvol / --fstype="xfs" --size=48700 --name=root --vgname=rl
logvol swap --fstype="swap" --size=2048 --name=swap --vgname=rl

#System timezone
timezone Asia/Seoul --isUtc

#Root password
rootpw --iscrypted $6$by53Zw0bD64htr69$cvYjYmALCSoSSVXw69PGyuCIzki6dqQ2sG7NaFSSGxkp/fEkykBxPU6NGcVG/ku9wVEbPeRRde.KT/0MZB2lE.

%addon com_redhat_kdump --disable --reserve-mb='auto'
%end
%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

[root@rk9-pxe 8.9]# chmod 755 ks.cfg
~~~

## Build PXE
## Build TFTP Server
## Build FTP Server
## BUILD DHCP Server
## Network install Weka 4.2 by Kickstart

## References
https://access.redhat.com/discussions/894393
https://github.com/insidero/centos-kickstart-asknetwork-script
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-statlists
https://adam.younglogic.com/2017/10/vm-ip-virsh/
