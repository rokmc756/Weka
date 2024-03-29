#
# weka debug buckets restart --all
#
# It’s the same thing that happens during a start IO :man-shrugging:
#
# Well weka cluster stop-io sounds like something you do when you are ready to stop IO.
# debug buckets restart --all sounds like something you do when the cluster is already wedged,
# which takes the scary factor to :100:.
#
# It actually gracefully restarts all the buckets 8 at a time and (by default) won't
# proceed unless everything is perfect.
#
# Something wasn't perfect during the 5 attempts of me using it so I just restarted the compute containers instead.
