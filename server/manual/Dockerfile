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
RUN make -C tmp ${TARGET} \
    vpncmd


FROM alpine

RUN apk --update add \
    readline

ARG TARGET
WORKDIR /usr/local/${TARGET}

RUN CONFIG_NAME=${TARGET/vpn/vpn_} && \
    mkdir config && \
    ln -s config/$CONFIG_NAME.config $CONFIG_NAME.config && \
    mkdir config/backup.$CONFIG_NAME.config && \
    ln -s config/backup.$CONFIG_NAME.config backup.$CONFIG_NAME.config &&\
    ln -s config/lang.config lang.config

COPY --from=builder /usr/local/src/SoftEtherVPN/build .

ENV LD_LIBRARY_PATH /usr/local/${TARGET}
ENV TARGET ${TARGET}
CMD /usr/local/$TARGET/$TARGET execsvc