FROM ghcr.io/actions/actions-runner:2.310.2

# installs updates and build packages
RUN sudo apt-get update -y \
    && sudo apt-get upgrade -y \
    && sudo apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    shellcheck \
    unzip

# install terraform 1.6.2
RUN curl -o /tmp/terraform_1.6.2_linux_amd64.zip -L https://releases.hashicorp.com/terraform/1.6.2/terraform_1.6.2_linux_amd64.zip
RUN sudo unzip /tmp/terraform_1.6.2_linux_amd64.zip -d /usr/bin

# install awscli 2.10
RUN curl -o /tmp/awscliv2.zip -L https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    && sudo unzip /tmp/awscliv2.zip \
    && sudo ./aws/install

# install go 1.21.3
RUN curl -o /tmp/go1.21.3.linux-amd64.tar.gz -L https://go.dev/dl/go1.21.3.linux-amd64.tar.gz \
    && sudo tar -xzvf /tmp/go1.21.3.linux-amd64.tar.gz -C /usr/bin

ENV GOROOT /usr/bin/go
ENV PATH="${PATH}:${GOROOT}/bin"

# install trivy 0.18.3
RUN curl -o /tmp/trivy_0.18.3_Linux-64bit.tar.gz -L https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.tar.gz \
    && sudo tar -xzvf /tmp/trivy_0.18.3_Linux-64bit.tar.gz -C /usr/bin

