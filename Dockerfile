FROM ubuntu:20.04 AS builder

ARG ARCH
ARG ABI

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && apt-get install -y autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev git

RUN bash -c "mkdir /riscv-gnu-toolchain && cd / && git clone --depth=1 https://github.com/riscv/riscv-gnu-toolchain && \
    cd /riscv-gnu-toolchain && \
    git submodule update --init --recursive --progress qemu && \
    git submodule update --init --recursive --progress --depth=1 --recommend-shallow \ 
    "

RUN cd /riscv-gnu-toolchain && ./configure --prefix=/opt/riscv --with-arch=$ARCH --with-abi=$ABI && make
#RUN cd /riscv-gnu-toolchain && make

FROM ubuntu:20.04 AS runtime

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && apt-get install -y libexpat1 libmpfr6 && rm -r /var/lib/apt/lists/*

COPY --from=builder /opt/riscv /opt/riscv

#RUN /opt/riscv/bin/riscv32-unknown-elf-gcc -v
