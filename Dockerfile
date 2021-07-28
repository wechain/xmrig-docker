FROM ubuntu:20.04

RUN apt-get update && \
      apt-get -y install apt-utils sudo

RUN adduser --disabled-password --gecos '' docker && \
    adduser docker sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
CMD /bin/bash

RUN sudo DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata && \
    sudo apt-get -y install git build-essential cmake automake libtool autoconf

WORKDIR home/docker
RUN git clone https://github.com/xmrig/xmrig
WORKDIR xmrig
RUN mkdir build
WORKDIR scripts
RUN sudo apt-get install wget
RUN ./build_deps.sh
WORKDIR ../build
RUN cmake .. -DXMRIG_DEPS=scripts/deps
RUN make -j$(nproc)

RUN sudo apt-get -y install kmod msr-tools
RUN -v /lib/modules:/lib/modules

CMD sudo ./xmrig -o de.minexmr.com:443 -u 4AePnmc5NxmNWArsL3tLgF8hyMeqnzzNMLTY4tEc5DSdVKCEijp4m7sckeUFU5ACChgVhoFHHasi2DFDFGp1METwNPDMbDs -k --tls --rig-id "custom image"
