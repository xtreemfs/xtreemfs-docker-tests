#!/bin/bash

# usage: ./test-distributions.sh [ all| [distribution]* ]
# default: ./test.distibutions.sh all

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
CONTAINER_NAME="test-container"

# prepare distribution dirs
if [[ "$1" == "all" || "$1" == "" ]]; then
   DISTRIBUTION_DIRS=$(ls $DIR | grep "xtreemfs-")
else
   for i in $*; do DISTRIBUTION_DIRS="$DISTRIBUTION_DIRS xtreemfs-$i"; done
fi

#run containers
for DISTRIBUTION_DIR in $DISTRIBUTION_DIRS; do

   # build docker image
   docker build -t xtreemfs/$DISTRIBUTION_DIR $DIR/$DISTRIBUTION_DIR
   
   # run docker container
   docker run --name=$CONTAINER_NAME --privileged xtreemfs/$DISTRIBUTION_DIR ./test.sh

   #remove container and image
   docker rm $CONTAINER_NAME 
   docker rmi xtreemfs/$DISTRIBUTION_DIR
done
