ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

# Install dependencies. Install these in a separate layer so that multiple aws cli versions can share the layer
RUN apk add --no-cache \
    py-pip musl-dev python2-dev openssl-dev jq gcc

ARG AWSCLI_VERSION
RUN pip install "awscli==${AWSCLI_VERSION}"

ENTRYPOINT [ "aws" ]
CMD [ "--help" ]