# How to track / trackdown HangingIO's on clients in a cluster?
# First, check to see if there's a cache stopped on hostid<#> alert; that is probably the most common cause

# Need how to track down which client is actually having the hanging IO.
# Extract it from events and then identify the hostID from that.

# The problem is that a lot of the time the host with the hanging IO isn't the cause but the victim.
# So if there's a cache stopped, that's often the cause and when that host is rebooted the hanging IO goes away.

# weka debug fs old-ios -v
# then try
# weka debug fs resolve-inode <inode of old io>

# for NFS ,
# weka debug fs lsof <inode>

# (both of these have a snapview-id component
# would be cool to simulate or generate some hanging IO in a lab and work on that!)
# https://app.gitbook.com/o/-L7Tp-Uy9BMSCSCx0MlK/s/MX0sL8hdDPL59nm7aKhv/troubleshoot-events/hangingios

# Check a Management node in DOWN state is a clue about which client is wedged and may be causing problems.
# weka cluster process | grep -v UP

# The snap ID is in the verbose output of weka debug fs old-ios.  You'd add --snap-view-id to weka debug fs resolve-inode.
# That's very important bit to keep in there.  e.g.,
# weka debug fs resolve-inode 953279417316671488
# util:<ENOENT> [BucketId<919> FSId<0> SnapViewId<0> InodeContext<953279417316671488>]

# weka debug fs resolve-inode 953279417316671488 --snap-view-id 288
# medium:/data-preprocessed/mosaic/webcrawl/v1/20230221/115M/train/shard.08920.mds [BucketId<919> FSId<7> SnapViewId<99> InodeContext<953279417316671587>]

