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
WORKDIR ./xmrig/scripts
RUN ./build_deps.sh
WORKDIR ../build
RUN cmake .. -DXMRIG_DEPS=scripts/deps
RUN make -j$(nproc)

ARG arg_pool=de.minexmr.com:443
ENV pool=${arg_pool}
ARG arg_wallet_address=4AePnmc5NxmNWArsL3tLgF8hyMeqnzzNMLTY4tEc5DSdVKCEijp4m7sckeUFU5ACChgVhoFHHasi2DFDFGp1METwNPDMbDs
ENV wallet_address=${arg_wallet_address}
ARG arg_rig_id="my xmrig miner"
ENV rig_id=${arg_rig_id}
ARG arg_donate_level=1
ENV donate_level=${arg_donate_level}

CMD sudo ./xmrig --donate-level ${donate_level} -o ${pool} -u ${wallet_address} -k --tls --rig-id ${rig_id}
