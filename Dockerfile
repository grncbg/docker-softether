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


FROM alpine

RUN apk --update add \
    readline

ARG TARGET
WORKDIR /usr/local/${TARGET}

COPY --from=builder /usr/local/src/SoftEtherVPN/build .

ENV LD_LIBRARY_PATH /usr/local/${TARGET}
ENV TARGET ${TARGET}
CMD /usr/local/$TARGET/$TARGET execsvc