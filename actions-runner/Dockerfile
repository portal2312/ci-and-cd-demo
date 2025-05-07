FROM rockylinux:8

# Install dependencies
RUN dnf upgrade -y && \
    dnf install -y epel-release && \
    dnf install -y --allowerasing \
    # For Runner
    glibc glibc-langpack-en libicu libcurl openssl-libs krb5-libs zlib lttng-ust libunwind libuuid \
    # For utils
    curl git passwd sudo perl-Digest-SHA procps-ng \
    # For Python
    gcc openssl-devel bzip2-devel libffi-devel xz-devel make ncurses-devel gdbm-devel tk-devel readline-devel \
    # For Java
    java-1.8.0-openjdk-devel && \
    dnf clean all

# Set up non-root user
# - USER_UID: docker-compose volume default UID.
ARG USER_UID=1000
ARG USERNAME=runner
ARG RUNNER_VERSION

RUN useradd -m -u ${USER_UID} ${USERNAME} && \
    passwd -d ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers  && \
    mkdir -p /actions-runner && \
    chown -R ${USER_UID}:${USER_UID} /actions-runner

# Install Docker
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-rocky-linux-8
RUN dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    dnf install -y docker-ce docker-ce-cli containerd.io && \
    dnf clean all

RUN usermod -aG docker ${USERNAME}

# Set up Python 3.13.2
# RUN curl -O https://www.python.org/ftp/python/3.13.2/Python-3.13.2.tar.xz && \
#     tar -xf Python-3.13.2.tar.xz && \
#     cd Python-3.13.2 && \
#     ./configure --enable-optimizations && \
#     make altinstall && \
#     ln -s /usr/local/bin/python3.13 /usr/local/bin/python && \
#     rm -rf ../Python-3.13.2*

# Set up PostgreSQL 15 (aarch64)
# - `cat /etc/os-release`: Rocky-Linux-8, RHEL, RHEL8
# - `uname -m`: aarch64
# - GPG key base abs path: /etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-RHEL
RUN dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-aarch64/pgdg-redhat-repo-latest.noarch.rpm && \
    # HACK: Overwrite the GPG key file for "Bad GPG signature"
    curl -sSL https://apt.postgresql.org/pub/repos/yum/keys/PGDG-RPM-GPG-KEY-AARCH64-RHEL -o /etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-RHEL && rpm --import /etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-RHEL && \
    dnf -qy module disable postgresql && \
    dnf -y install postgresql15-server postgresql15-contrib && \
    echo "export PATH=$PATH:/usr/pgsql-15/bin" >> /etc/profile && \
    dnf clean all

# Set up NVM, Node, Yarn
ENV NVM_DIR=/home/${USERNAME}/.nvm
ENV NODE_VERSION=v22.14.0

WORKDIR /home/${USERNAME}
USER ${USERNAME}

SHELL ["/bin/bash", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash && \
    source ${NVM_DIR}/nvm.sh && \
    nvm install ${NODE_VERSION} && \
    nvm alias default ${NODE_VERSION} && \
    npm install -g npm corepack && \
    corepack enable && \
    yarn set version stable

# Set up UV
RUN curl -LsSf https://astral.sh/uv/0.7.2/install.sh | sh && \
    ~/.local/bin/uv python install 3.13.2

# Set up GitHub Actions Runner
# 1. Runner image: Linux
# 2. Architecture: ARM64 (Check: uname -m [aarch64(ARM), x64])
WORKDIR /actions-runner
COPY --chown=${USERNAME}:${USERNAME} entrypoint.sh /actions-runner/entrypoint.sh
RUN chmod +x /actions-runner/entrypoint.sh

RUN curl -o actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz && \
    echo "9cb778fffd4c6d8bd74bc4110df7cb8c0122eb62fda30b389318b265d3ade538  actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz" | shasum -a 256 -c && \
    tar xzf ./actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz && \
    rm ./actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz && \
    sudo ./bin/installdependencies.sh && \
    sudo dnf clean all

ENTRYPOINT ["/actions-runner/entrypoint.sh"]
