# Use Debian base
FROM --platform=linux/amd64 debian:bullseye

# Set environment variables to avoid interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install required tools (excluding ca-certificates-java which breaks on ARM)
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    autoconf \
    automake \
    libtool \
    unzip \
    default-jdk \
    maven \
    python3 \
    python3-pip \
    ant && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install protobuf 2.5.0 manually with ARM64 compatibility patch
WORKDIR /opt
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.bz2 && \
    tar -xvjf protobuf-2.5.0.tar.bz2 && \
    cd protobuf-2.5.0 && \
    sed -i '/#elif defined(__x86_64__)/a #elif defined(__aarch64__)\\n#define GOOGLE_PROTOBUF_ARCH_ARM64' src/google/protobuf/stubs/platform_macros.h && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# Set Java path
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Clone and build the Boa compiler
WORKDIR /opt/boa
RUN git clone https://github.com/boalang/compiler.git . && \
    ant

# Default to interactive shell
CMD ["/bin/bash"]