FROM ubuntu:18.04

# Install basic tools
RUN apt-get update && apt-get install -y \
    build-essential \
    openjdk-8-jdk \
    ant \
    wget \
    git \
    unzip \
    autoconf \
    libtool \
    pkg-config \
    curl

# Install protobuf 2.5.0
WORKDIR /opt
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.bz2 \
    && tar -xvjf protobuf-2.5.0.tar.bz2 \
    && cd protobuf-2.5.0 \
    && ./configure \
    && make -j$(nproc) \
    && make install

# Add protobuf to PATH
ENV PATH="/usr/local/bin:$PATH"

# Clone Boa repo
WORKDIR /boa
RUN git clone https://github.com/boalang/compiler.git . \
    && ant

CMD ["/bin/bash"]
