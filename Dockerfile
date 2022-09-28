# Dockerfile for building Marian image
# Written by Abdullah Alrajeh, Sep 2022
# Use: docker build -t marian .

FROM nvidia/cuda:10.2-devel-ubuntu18.04
LABEL description="GPU-based Marian"

# You need to uncomment these lines if you run it inside KACST 
#ENV http_proxy=http://USERNAME:PASSWORD@proxy.kacst.edu.sa:8080
#ENV https_proxy=http://USERNAME:PASSWORD@proxy.kacst.edu.sa:8080

# Install some necessary tools.
RUN apt-get update && apt-get install -y \
                git \
                wget \
                build-essential \
                libboost-system-dev \
                libprotobuf10 \
                protobuf-compiler \
                libprotobuf-dev \
                openssl \
                libssl-dev \
                libgoogle-perftools-dev

# Install CMAKE v3.24.2
RUN wget https://github.com/Kitware/CMake/releases/download/v3.24.2/cmake-3.24.2-linux-x86_64.tar.gz
RUN tar vxzf cmake-3.24.2-linux-x86_64.tar.gz

# Install Marian
RUN git clone https://github.com/marian-nmt/marian
ENV MARIANPATH /marian
WORKDIR $MARIANPATH
RUN mkdir -p build
WORKDIR $MARIANPATH/build
RUN /cmake-3.24.2-linux-x86_64/bin/cmake -DCOMPILE_SERVER=on $MARIANPATH && make -j

# Run Marian server
ENTRYPOINT ["./marian-server", "-p", "18080", "-m","/model/model.npz", "-v", "/model/vocab.src.yml", "/model/vocab.trg.yml", "-d", "0", "0"]
