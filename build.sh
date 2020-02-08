#!/usr/bin/env sh
#######################################################################
# Build, test and push the images
# Creates multiple versions so that there's some choice about versions
# to use
#######################################################################
set -eux

# Number of releases to go back from the latest version
number_of_awscli_releases=3
number_of_alpine_releases=3

# Creates tags of the form {AWSCLI_VERSION}-alpine-{ALPINE_VERSION} (e.g. 2.9.2-alpine-3.11.0)
# First gets the last $number_of_alpine_releases alpine tags where the tag looks like a version number (there were some odd tags that look like dates)
# For each of those tags gets the last $number_of_awscli_releases of non-release candidate versions of the AWS CLI and builds an image
docker run leonyork/docker-tags library/alpine \
    | grep -E '^[0-9.]\.[0-9.]+$' \
    | tail -n $number_of_alpine_releases \
    | xargs -I{ALPINE_VERSION} -n1 \
        sh -c "docker run leonyork/pypi-releases awscli \
        | grep -E '^[0-9.]\.[0-9.]+$' \
        | tail -n $number_of_awscli_releases \
        | xargs -I{AWSCLI_VERSION} -n1 sh build-image.sh {ALPINE_VERSION} {AWSCLI_VERSION} {AWSCLI_VERSION}-alpine{ALPINE_VERSION} || exit 255" || exit 255

# Creates tags of the form {AWSCLI_VERSION}-alpine (e.g. 2.9.2-alpine)
# Gets the last $number_of_awscli_releases of non-release candidate versions of the aws cli and creates an image using the latest alpine image
docker run leonyork/pypi-releases awscli \
        | grep -E '^[0-9.]\.[0-9.]+$' \
        | tail -n $number_of_awscli_releases \
        | xargs -I{AWSCLI_VERSION} -n1 sh build-image.sh latest {AWSCLI_VERSION} {AWSCLI_VERSION}-alpine || exit 255

# Generates the latest tag
awscli_latest_version=`docker run leonyork/pypi-releases awscli | tail -n 1`
sh build-image.sh latest $awscli_latest_version latest