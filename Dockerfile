FROM alpine as builder

RUN apk --update add \
    build-base \
    cmake \
    git \
    ncurses-dev \
    openssl-dev \
    readline-dev \
    zlib-dev

WORKDIR /usr/local/src
RUN git clone https://github.com/SoftEtherVPN/SoftEtherVPN.git && \
    cd SoftEtherVPN && \
    git submodule update --init --recursive

WORKDIR /usr/local/src/SoftEtherVPN
RUN ./configure && \
    make -C tmp hamcore-archive-build

ARG TARGET
RUN make -C tmp ${TARGET}