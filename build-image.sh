#!/usr/bin/env sh
#######################################################################
# Build, test and push an image
# First argument is the alpine version to use
# Second argument is the awscli version to use
# Third argument is the image tag
#######################################################################

if [ -z "$1" ]
then
    echo "You must specify the version of the docker image alpine to use"
    exit 1
fi

if [ -z "$2" ]
then
    echo "You must specify the tersion of awscli to use"
    exit 1
fi

if [ -z "$3" ]
then
    echo "You must specify the image tag to use"
    exit 1
fi

set -eux
export ALPINE_VERSION=$1;
export AWSCLI_VERSION=$2;
export IMAGE_TAG=$3;
# Don't log this as there is so too much logging
docker-compose build > /dev/null

# Test that it's working by making sure we can get the version
docker-compose run awscli --version

# Push to the docker registry
docker-compose push

# Remove any images left around
docker-compose down --rmi all 2> /dev/null