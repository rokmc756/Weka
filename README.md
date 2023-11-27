## WIP

~~~
[root@weka4-master install]# cd /opt/tools/install


./wekachecker 192.168.0.181 192.168.0.182 192.168.0.183 192.168.0.184 192.168.0.185 192.168.0.186 192.168.0.187

[root@weka4-master install]# ssh root@192.168.0.187 "sysctl -p /etc/sysctl.d/98-weka-sysctl.conf"
net.ipv4.conf.all.arp_filter = 1
net.ipv4.conf.default.arp_filter = 1
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.default.arp_announce = 2

# On weka4-master
echo "y" | ./wekadeploy.sh ../../tarballs/weka-4.2.1.tar weka4-master weka4-node01 weka4-node02 weka4-node03 weka4-node04 weka4-node05

# On weka4-master
ssh root@192.168.0.18[1-7] "firewall-cmd --zone=public --add-port=14100/tcp --add-port=14000/tcp --add-port=14050/tcp --permanent --add-port=8501/tcp --permanent && firewall-cmd --reload"

# On weka4-master
weka cluster create \
weka4-master.jtest.pivotal.io \
weka4-node01.jtest.pivotal.io \
weka4-node02.jtest.pivotal.io \
weka4-node03.jtest.pivotal.io \
weka4-node04.jtest.pivotal.io \
weka4-node05.jtest.pivotal.io

Hint: You can use
    `weka cluster drive add` to add the new containers' drives,
    `weka cluster container cores` to configure the new containers' processes,
    `weka cluster container net add` to configure the new containers' networking,
    `weka cluster container apply` to apply a new configuration on the containers.
and then start the cluster IO  by running `weka cluster start-io`

http://weka4-master.jtest.pivotal.io:14000/ui
--> change from admin:admin to admin:Changeme12!2


http://weka4-master.jtest.pivotal.io:9090 
--> admin:admin

weka-firstboot error
tail -f /var/log/message
Nov 27 22:42:34 weka4-master systemd[22106]: weka-firstboot.service: Failed to execute command: Permission denied
Nov 27 22:42:34 weka4-master systemd[22106]: weka-firstboot.service: Failed at step EXEC spawning /opt/wekabits/weka-install: Permission denied
Nov 27 22:42:34 weka4-master systemd[1]: weka-firstboot.service: Main process exited, code=exited, status=203/EXEC
Nov 27 22:42:34 weka4-master systemd[1]: weka-firstboot.service: Failed with result 'exit-code'.

# Added chmod 755 /opt/wekabits/weka-install in ks.cfg

~~~


~~~
[root@weka4-master install]# ./wekaconfig
Setting TERMINFO to /tmp/_MEIJSY1ji/terminfo
target host is weka4-master
collecting host data... please wait...
finding hosts...
Getting configuration info from hosts...
weka4-master: Unable to fetch HW info from reference host (self); aborting
This is normally due to ssh issues
~~~


~~~


~~~

~~~


~~~



~~~


~~~



~~~


~~~



~~~


~~~



~~~


~~~



~~~


~~~



~~~


~~~



~~~


~~~



~~~


~~~



~~~


~~~



~~~


~~~




~~~


~~~






