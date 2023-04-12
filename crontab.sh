#!/bin/bash

# set variables
LOCAL_DIR=/path/to/local/directory
REMOTE_USER=username
REMOTE_HOST=example.com
REMOTE_DIR=/path/to/remote/directory

# synchronize local and remote directories using rsync and ssh
rsync -avz --delete --exclude='.git/' -e ssh $LOCAL_DIR/ $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/

# output log message
echo "Directory synchronized at $(date)"
