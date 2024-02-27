
# https://www.notion.so/wekaio/How-to-change-IP-on-an-Multi-Container-Backend-c8f5e35ae94644a4a3557ee9c4837c5e?pvs=4

weka local resources  -C drives0 net remove ens9f1np1

weka alerts

weka local resources -C drives0 --stable

weka local resources -C drives0 net add ens9f1np1 --ips 10.33.0.130 --gateway 10.33.0.128 --netmask 28

weka local resources -C drives0 --stable

weka local resources -C drives0

weka local resources -C drives0 apply
