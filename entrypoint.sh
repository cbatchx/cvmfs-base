#!/bin/bash

# Stop autofs
service autofs stop

# Make config
cat > /etc/cvmfs/default.local <<EOF
CVMFS_REPOSITORIES=atlas.cern.ch,atlas-condb.cern.ch,grid.cern.ch,cernvm-prod.cern.ch
CVMFS_HTTP_PROXY="DIRECT"
EOF

cat > /etc/fstab <<EOF
atlas.cern.ch       /cvmfs/atlas.cern.ch cvmfs allow_other 0 0
atlas-condb.cern.ch /cvmfs/atlas-condb.cern.ch cvmfs allow_other 0 0
grid.cern.ch        /cvmfs/grid.cern.ch cvmfs allow_other 0 0
cernvm-prod.cern.ch /cvmfs/cernvm-prod.cern.ch cvmfs allow_other 0 0
EOF



# Setup cvmfs
cvmfs_config setup




# Test
cvmfs_config probe

# Run inotifywait to track access
inotifywait -m /cvmfs/*