# AWS CLI Docker images

Images for running [the AWS CLI](https://aws.amazon.com/cli/).

## Build

```docker build --build-arg ALPINE_VERSION=3.11.2 --build-arg AWSCLI_VERSION=1.17.13 -t leonyork/awscli .```

## Test

```docker run leonyork/awscli --version```