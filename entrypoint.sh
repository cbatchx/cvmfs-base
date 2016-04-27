#!/bin/bash
set -e

: ${CVMFS_REPOSITORIES:=cernvm-prod.cern.ch}
: ${CVMFS_HTTP_PROXY:="DIRECT"}


# Make config
cat > /etc/cvmfs/default.local <<EOF
CVMFS_REPOSITORIES=$CVMFS_REPOSITORIES
CVMFS_HTTP_PROXY=$CVMFS_HTTP_PROXY
EOF

echo "/etc/cvmfs/default.local is now: "
cat /etc/cvmfs/default.local

# Unmount old stuff
cvmfs_config umount

# Setup cvmfs
cvmfs_config setup
# Stop autofs
service autofs stop

# Mounting
IFS=","
for r in $CVMFS_REPOSITORIES
do
    echo "Mounting $r"
    mkdir -p /cvmfs/$r
    mount -t cvmfs $r /cvmfs/$r
done

# Test
cvmfs_config probe

# Run inotifywait to track access and to do something :)
inotifywait -m /cvmfs/*