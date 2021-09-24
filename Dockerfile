FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y install \
    build-essential \
    cmake \
    automake \
    libtool \
    autoconf \
    wget \
    kmod \
    msr-tools \
    git \
    sudo

RUN adduser --disabled-password --gecos '' docker && \
    adduser docker sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER docker
CMD /bin/bash

WORKDIR /home/docker
RUN git clone https://github.com/xmrig/xmrig
RUN mkdir ./xmrig/build
WORKDIR ./xmrig
RUN sed -i -E "s/DonateLevel = [0-9]/DonateLevel = 0/g" src/donate.h
WORKDIR ./xmrig/build
RUN ./build_deps.sh
WORKDIR ../build
RUN cmake .. -DXMRIG_DEPS=scripts/deps
RUN make -j$(nproc)

ARG arg_pool=sg.minexmr.com:443
ENV pool=${arg_pool}
ARG arg_wallet_address=865kjopGVkABniUeparZntDDNDP3eMrVz1UFvBXSuTjb8ZfYTyQSt9GRsVeBFXhFCwK7zmqvh7a4dCrwSyo3r9GGNstLLR2
ENV wallet_address=${arg_wallet_address}
ARG arg_rig_id="my xmrig miner"
ENV rig_id=${arg_rig_id}


CMD sudo ./xmrig -o ${pool} -u ${wallet_address} -k --tls --rig-id ${rig_id}
