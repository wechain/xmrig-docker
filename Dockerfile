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

CMD sudo ./xmrig -o de.minexmr.com:443 -u 4AePnmc5NxmNWArsL3tLgF8hyMeqnzzNMLTY4tEc5DSdVKCEijp4m7sckeUFU5ACChgVhoFHHasi2DFDFGp1METwNPDMbDs -k --tls --rig-id "custom image"
