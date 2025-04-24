FROM rockylinux:8

# Install dependencies
RUN dnf update -y && \
    dnf install -y epel-release && \
    dnf install -y --allowerasing \
    # Install dependencies for Runner
    glibc glibc-langpack-en libicu libcurl openssl-libs krb5-libs zlib lttng-ust libunwind libuuid \
    # Install dependencies for utils
    bash curl git passwd sudo perl-Digest-SHA procps-ng && \
    dnf clean all

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
# Options:
#   -u 1000: docker-compose volume default UID.
ARG USER_UID=1000
ARG USERNAME=appuser
ARG RUNNER_WORKDIR=/home/${USERNAME}/actions-runner

# Set up user and directories
RUN useradd -m -u ${USER_UID} ${USERNAME} && \
    passwd -d ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir ${RUNNER_WORKDIR} && \
    chown ${USERNAME}:${USERNAME} ${RUNNER_WORKDIR}

# USER 변경 전에 entrypoint.sh 복사 및 권한 설정
COPY --chown=${USERNAME}:${USERNAME} entrypoint.sh ${RUNNER_WORKDIR}
RUN chmod +x ${RUNNER_WORKDIR}/entrypoint.sh

USER ${USERNAME}
WORKDIR ${RUNNER_WORKDIR}

# Set up NVM, Node, Yarn
ENV NVM_DIR=/home/${USERNAME}/.nvm
ENV NODE_VERSION=v22.14.0
SHELL ["/bin/bash", "-c"]

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash && \
    source ${NVM_DIR}/nvm.sh && \
    nvm install ${NODE_VERSION} && \
    nvm alias default ${NODE_VERSION} && \
    npm install -g npm corepack && \
    corepack enable && \
    yarn set version stable

# Set up GitHub Actions Runner
# 1. Runner image: Linux
# 2. Architecture: ARM64 (Check: uname -m [aarch64(ARM), x64])
RUN curl -o actions-runner-linux-arm64-2.323.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-arm64-2.323.0.tar.gz && \
    echo "9cb778fffd4c6d8bd74bc4110df7cb8c0122eb62fda30b389318b265d3ade538  actions-runner-linux-arm64-2.323.0.tar.gz" | shasum -a 256 -c && \
    tar xzf ./actions-runner-linux-arm64-2.323.0.tar.gz && \
    rm ./actions-runner-linux-arm64-2.323.0.tar.gz && \
    sudo ./bin/installdependencies.sh && \
    sudo dnf clean all

ENTRYPOINT ["./entrypoint.sh"]
