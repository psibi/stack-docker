FROM ubuntu:18.04

################################################################################
# Haskell system dependencies (basically never changes)

RUN apt-get update && \
    apt-get install -yq --no-install-suggests --no-install-recommends --force-yes -y -qq \
            netbase git ca-certificates xz-utils build-essential curl wget unzip libgmp-dev

################################################################################
# Download a specific Stack version

RUN curl https://github.com/commercialhaskell/stack/releases/download/v2.7.1/stack-2.7.1-linux-x86_64.tar.gz \
    --silent -L \
    -o stack.tar.gz && \
    tar zxf stack.tar.gz && mv stack-2.7.1-linux-x86_64/stack /usr/bin/

################################################################################
# Switch to work dir

ADD . /build-workdir
WORKDIR /build-workdir

################################################################################
# Install the right GHC version and update package index

RUN pwd && stack setup && stack update

################################################################################
# Install the snapshot and system dependencies

RUN apt-get install -y libz-dev libicu-dev libtinfo-dev libpq-dev
RUN stack build --only-snapshot -j1 --test --no-run-tests
WORKDIR /
RUN rm -rf /build-workdir
