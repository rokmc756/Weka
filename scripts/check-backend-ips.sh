# It's essentially fixed by setting the weka local resources join-ips  so exporting and importing would've worked too.
# For Future Me (and Slack searching), here's a handy command to check the backend_endpoint IP addresses again after fixing them; poke around in local :
#
for CONTAINER in drives0 compute0 frontend0 ; do for BACKEND in dnode0{1..6} ; do ssh $BACKEND "sudo weka local resources --json --container $CONTAINER" | jq -cr .backend_endpoints[] | sed s/^/${BACKEND}:${CONTAINER}/; done ; done

