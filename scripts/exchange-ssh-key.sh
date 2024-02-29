#!/bin/bash
#example how to achieve on aws cluster

arr=( 192.168.0.141 192.168.0.142 192.168.0.143 192.168.0.144 192.168.0.145 )

for backend_ip in "${arr[@]}"
do
	echo "$backend_ip"
	echo "Host *
	User root
	IdentityFile ~/.ssh/weka_dev_ssh_key
	StrictHostKeyChecking=no
	PubkeyAcceptedKeyTypes=+ssh-rsa	
	" | ssh ec2-user@$backend_ip -T "sudo cat > ~/.ssh/config"
	scp ~/.ssh/weka_dev_ssh_key ec2-user@$backend_ip:~/.ssh/weka_dev_ssh_key
	ssh ec2-user@$backend_ip "sudo mv ~/.ssh/config /root/.ssh/config && sudo mv ~/.ssh/weka_dev_ssh_key /root/.ssh/weka_dev_ssh_key && sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys && sudo chown root:root /root/.ssh/config && sudo chmod 400 /root/.ssh/config"

done

