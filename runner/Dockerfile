FROM rockylinux:8

ARG RUNNER_CHECKSUM
ARG RUNNER_VERSION
ARG RUNNER_NODE_VERSION
ENV RUNNER_NODE_VERSION=${RUNNER_NODE_VERSION}

# Install dependencies
RUN dnf upgrade -y && \
    dnf install -y epel-release && \
    dnf install -y --allowerasing \
    # For Runner
    glibc glibc-langpack-en libicu libcurl openssl-libs krb5-libs zlib lttng-ust libunwind libuuid \
    # For utils
    curl git passwd sudo perl-Digest-SHA procps-ng \
    # For Python
    gcc openssl-devel bzip2-devel libffi-devel xz-devel make ncurses-devel gdbm-devel tk-devel readline-devel libpq \
    # For uv
    ca-certificates \
    # For Java
    java-1.8.0-openjdk-devel && \
    dnf clean all

# Set up non-root user
# - USER_UID: docker-compose volume default UID.
ARG USER_UID=1000
ARG USERNAME=runner

RUN useradd -m -u ${USER_UID} ${USERNAME} && \
    passwd -d ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers  && \
    mkdir -p /runner && \
    chown -R ${USER_UID}:${USER_UID} /runner

# Install Docker
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-rocky-linux-8
RUN dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    dnf install -y docker-ce docker-ce-cli containerd.io && \
    dnf clean all

RUN usermod -aG docker ${USERNAME}

# Set up UV
# - https://docs.astral.sh/uv/configuration/environment/#uv_install_dir
# - https://docs.astral.sh/uv/guides/integration/docker/#using-uv-in-docker
ENV UV_INSTALL_DIR=/usr/local/bin
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Set up NVM
USER ${USERNAME}
ENV NVM_DIR=/home/${USERNAME}/.nvm

# https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-in-docker
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash && \
    source "${NVM_DIR}/nvm.sh" && \
    nvm install ${RUNNER_NODE_VERSION} && \
    nvm alias default ${RUNNER_NODE_VERSION} && \
    npm install -g npm corepack && \
    corepack enable

# Support non-interactive shell
ENV PATH=${NVM_DIR}/versions/node/${RUNNER_NODE_VERSION}/bin:${PATH}
ENV NODE_PATH=${NVM_DIR}/versions/node/${RUNNER_NODE_VERSION}/lib/node_modules

WORKDIR /home/${USERNAME}

# Set up GitHub Actions Runner
# 1. Runner image: Linux
# 2. Architecture: ARM64 (Check: uname -m [aarch64(ARM), x64])
ENV RUNNER_WORKDIR=/runner

WORKDIR ${RUNNER_WORKDIR}

COPY --chown=${USERNAME}:${USERNAME} entrypoint.sh ${RUNNER_WORKDIR}/entrypoint.sh
RUN chmod +x ${RUNNER_WORKDIR}/entrypoint.sh

RUN curl -o actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz && \
    echo "${RUNNER_CHECKSUM}  actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz" | shasum -a 256 -c && \
    tar xzf ./actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz && \
    rm ./actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz && \
    sudo ./bin/installdependencies.sh && \
    sudo dnf clean all

ENTRYPOINT ["/runner/entrypoint.sh"]
