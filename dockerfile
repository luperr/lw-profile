FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies in one layer with cleanup
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        git \
        unzip \
        gnupg \
        lsb-release \
        && rm -rf /var/lib/apt/lists/*

# Install Go
ARG GO_VERSION=1.25.3
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-arm64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-arm64.tar.gz && \
    rm go${GO_VERSION}.linux-arm64.tar.gz

# Set Go environment variables (persists across layers)
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/go
ENV GOPROXY=https://proxy.golang.org,direct


# Install Terraform (meets requirement: >= 1.12)
ARG TERRAFORM_VERSION=1.8.0
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    terraform --version

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip && \
    aws --version

# Install Hugo (latest stable version)
ARG HUGO_VERSION=0.152.2
RUN wget -q https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-arm64.tar.gz && \
    tar -xzf hugo_extended_${HUGO_VERSION}_linux-arm64.tar.gz && \
    mv hugo /usr/local/bin/hugo && \
    rm hugo_extended_${HUGO_VERSION}_linux-arm64.tar.gz && \
    chmod +x /usr/local/bin/hugo 

# Set working directory
WORKDIR /app

# Copy Hugo configuration and content
COPY hugo.toml .
COPY content/ ./content/
COPY themes/ ./themes/
COPY assets/ ./assets/
COPY archetypes/ ./archetypes/

# Copy Terraform configuration
COPY terraform/ ./terraform/

# Expose Hugo server port
EXPOSE 1313

# Default command: run Hugo server in watch mode
# Bind to 0.0.0.0 to allow access from macOS host
CMD ["hugo", "server", "--bind", "0.0.0.0", "--disableFastRender"]