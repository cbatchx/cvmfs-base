#!/bin/bash

# Stop autofs
service autofs stop

# Make config
cat > /etc/cvmfs/default.local <<EOF
CVMFS_REPOSITORIES=${CVMFS_REPOSITORIES:-cernvm-prod.cern.ch}
CVMFS_HTTP_PROXY=${CVMFS_HTTP_PROXY:-"DIRECT"}
EOF

echo "/etc/cvmfs/default.local is now: "
cat /etc/cvmfs/default.local

# Setup cvmfs
cvmfs_config setup

# Test
cvmfs_config probe

# Run inotifywait to track access
inotifywait -m /cvmfs/*
