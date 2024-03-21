ARG VERSION=22.04
FROM ubuntu:${VERSION} AS base
LABEL net.clxssyy.email="mpc63@uakron.edu"

# Install dependencies for building the product
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    g++ \
    git \
    wget \
    gpg \
    libarchive-dev && \
    rm -rf /var/lib/apt/lists/* && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update && \
    apt-get install -y cmake

WORKDIR /app

# Clone the product repository
RUN git clone https://github.com/Clxssyy/docker-example-product .

# Build the product
RUN cmake . && make

# Create a new image with just the product to reduce the size
FROM ubuntu:${VERSION}

# Install the dependencies for the product
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libarchive13 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=base /app/decompressor /app/decompressor

# Run the product
ENTRYPOINT ["./decompressor"]

