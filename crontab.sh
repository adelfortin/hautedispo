#!/bin/bash
# ---------------------#
# Desc.   :
# Date    :
# Version :
# ---------------------#

# set variables
LOCAL_DIR=/path/to/local/directory
REMOTE_USER=username
REMOTE_HOST_A=example.com
REMOTE_HOST_B=example.com
REMOTE_DIR=/path/to/remote/directory

# synchronize local and remote directories using rsync and ssh
ssh $REMOTE_USER@$REMOTE_HOST_A "ssh $REMOTE_USER@$REMOTE_HOST_B 'cd $REMOTE_DIR; /path/to/your/sync.sh'"

# output log message
echo "Directory synchronized at $(date)"
