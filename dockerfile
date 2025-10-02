FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        wget \
        git \
        vim \
        nano \
        ca-certificates \
        && rm -rf /var/lib/apt/lists/*