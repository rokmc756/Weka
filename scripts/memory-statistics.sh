# systems with lots of memory sometimes cause hung IOs" but up until now, I didn't really understand it completely,
# or what the suggested course of action should be for customers.
# I think we need to put a RHEL-like section on docs.weka.

# The default values are sub-optimal for some high performance computing workloads on large memory systems and can
# result in multiple-tens of gigabytes of memory needed to be written back to storage when applications are running.
# Reducing these values from their defaults will restrict the total amount of dirty pages in memory and start
# background flushing sooner.

# https://access.redhat.com/solutions/6770711
# Performance tuning for GFS2 filesystems on hosts with large memory
# My cluster has large spikes in I/O activity when it comes to flushing data back to storage.
# GFS2 journal log flushing causes long pauses and or stalls for my application’s ability to write to filesystem as
# dirty data is written back to the underlying disk.

# How can change the default values for vm.dirty_ratio and vm.dirty_background_ratio in the page cache to smooth
# out page cache flushing during heavy writing to the filesystem?

# RHEL-Performance-tuning-for-filesystems-on-hosts-with-large-memory.pdf
# you see similar issues with zfs fs's fwiw - param tweaking should have a formula somewhere for it to calculate the
# "as close to optimal" settings

# it doesn't make sense to cache 100GB of data before writing to disk (?).

# there should be some set "min" to run with in order to create deltas
# set the high water limit on caching lower?
#
# those parameters are likely heavily dependent upon the workload that is running.
# I have seen the defaults cause problems in the past, but it has been rare. Maybe that is different now w/ increasing

# Need a weka tuned profile.
# set weka_nosuck==true

# Might already be a profile that fits https://github.com/redhat-performance/tuned/tree/master/profiles
# you could use sysparams combined with workload mgr to make dynamic adjustments

# Tuned daemon is dynamic but tested when it first came out and it hurt performance. I'm sure its better now but was
# happy with applying the static profiles.
# And....TI may be getting bit by this issue. There is a client with 4 TB of memory and are seeing cache flush issues.

# Take me back to the days of 64k...please.
# I am curious if they have a comically high high watermark

# 10-40% of 4TB is... wow... a lot of dirty data.

