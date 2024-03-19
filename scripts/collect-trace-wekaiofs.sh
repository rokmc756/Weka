
pdsh -w 192.168.0.17[1-5] "yum install -y trace-cmd"

# trace-cmd start -p function # or function_graph

duration=60  # Second

# fn=wekafs_prepare_upgrade
for fn in `trace-cmd list -f wekafsio | awk '{print $1}'`
do
    # or function
    trace-cmd record -p function_graph -l ${fn} -o ./${fn}_$(hostname)-$(date +%Y-%m-%d-%H-%M-%S)-${duration}.out sleep ${duration}
done

trace-cmd stop
trace-cmd clear

# trace-cmd show -f _add_container_rk8-node01-2024-03-19-16-52-42-5.out
# https://www.baeldung.com/linux/check-kernel-module-usage
