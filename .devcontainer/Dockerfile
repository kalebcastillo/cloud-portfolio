# Cloud Portfolio DevContainer
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ARG NODE_VERSION=22
ARG PYTHON_VERSION=3.11
ARG TERRAFORM_VERSION=1.9.8
ARG PNPM_VERSION=9.14.4

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    unzip \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-dev \
    python3-pip \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm
RUN npm install -g pnpm@${PNPM_VERSION}

# Set Python as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1

# Install Python packages
RUN pip install --no-cache-dir \
    pytest \
    pytest-cov \
    requests \
    black \
    flake8 \
    azure-cli \
    awscli

# Install Terraform
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
