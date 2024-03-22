# Get DHCP
nmcli con add con-name conn1 type ethernet ifname eth0 ipv4.method auto
nmcli con add con-name conn2 type ethernet ifname eth1 ipv4.method auto
nmcli con add con-name conn3 type ethernet ifname eth2 ipv4.method auto

ENDIP=$(hostname | cut -d 0 -f 2)

#
nmcli con modify conn1 ipv4.method manual ipv4.address 192.168.0.14$ENDIP/24
nmcli con modify conn1 ipv4.gateway 192.168.0.1

nmcli con modify conn2 ipv4.method manual ipv4.address 192.168.1.14$ENDIP/24
nmcli con modify conn2 ipv4.gateway 192.168.1.14$ENDIP

nmcli connection modify conn1 802-3-ethernet.mtu 9000
nmcli connection modify conn2 802-3-ethernet.mtu 9000

nmcli con modify conn3 ipv4.method manual ipv4.address 192.168.1.$(( 14$ENDIP + 10 ))/24
nmcli con modify conn3 ipv4.gateway 192.168.1.141

nmcli connection modify conn1 ipv4.dns 192.168.0.100,192.168.0.90,8.8.8.8,168.126.63.1 ipv4.dns-search jtest.weka.io
nmcli connection modify conn2 ipv4.dns 192.168.0.100,192.168.0.90,8.8.8.8,168.126.63.1 ipv4.dns-search jtest.weka.io
nmcli connection modify conn3 ipv4.dns 192.168.0.100,192.168.0.90,8.8.8.8,168.126.63.1 ipv4.dns-search jtest.weka.io

nmcli connection modify conn2 ipv4.routes "192.168.1.0/24 table=100" ipv4.routing-rules "priority 101 from 192.168.1.14$ENDIP table 100"
nmcli connection modify conn3 ipv4.routes "192.168.1.0/24 table=200" ipv4.routing-rules "priority 102 from 192.168.1.$(( 14$ENDIP + 10 )) table 200"

nmcli connection modify conn1 ipv6.method "disabled"
nmcli connection modify conn2 ipv6.method "disabled"
nmcli connection modify conn3 ipv6.method "disabled"
nmcli connection modify conn3 802-3-ethernet.mtu 9000

#
nmcli con up conn1
nmcli con up conn2
nmcli con up conn3
