FROM rockylinux:8

# ------------------------------------------------------------------------------
# Requirements
# ------------------------------------------------------------------------------
# Install dependencies
RUN dnf update -y && \
    # Install dependencies for Runner
    dnf install -y epel-release && \
    dnf install -y --allowerasing glibc glibc-langpack-en libicu libcurl openssl-libs krb5-libs zlib lttng-ust libunwind libuuid && \
    # Install dependencies for App
    dnf install -y bash curl git passwd sudo perl-Digest-SHA procps-ng && \
    dnf clean all

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
# Options:
#   -u 1000: docker-compose volume default UID.
ARG USER_UID=1000
ARG USERNAME=appuser
ARG RUNNER_WORKDIR=/home/${USERNAME}/actions-runner
ARG APP_WORKDIR=/app

# Set up the appuser
RUN useradd -m -u ${USER_UID} ${USERNAME} && passwd -d ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ------------------------------------------------------------------------------
# Set up Runner
# ------------------------------------------------------------------------------
RUN mkdir ${RUNNER_WORKDIR} && \
    chown -R ${USERNAME}:${USERNAME} ${RUNNER_WORKDIR}
WORKDIR ${RUNNER_WORKDIR}
USER ${USERNAME}

# NOTE: Runner image and Architecture
# 1. Check your architecture: uname -m (aarch64(ARM), x64)
# 2. Then, choice architecture, then download.
RUN curl -o actions-runner-linux-arm64-2.323.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-arm64-2.323.0.tar.gz
RUN echo "9cb778fffd4c6d8bd74bc4110df7cb8c0122eb62fda30b389318b265d3ade538  actions-runner-linux-arm64-2.323.0.tar.gz" | shasum -a 256 -c
RUN tar xzf ./actions-runner-linux-arm64-2.323.0.tar.gz && \
    rm ./actions-runner-linux-arm64-2.323.0.tar.gz

# HACK: Libicu's dependencies is missing for Dotnet Core 6.0
RUN sudo ./bin/installdependencies.sh && sudo dnf clean all
RUN ./config.sh \
    --url https://github.com/portal2312/ci-and-cd-demo \
    --token ACRCVIQMK34D5RZVU2TQFHLIBHDVG \
    --name ci-and-cd-demo-runner \
    --labels self-hosted \
    --work _work \
    --unattended \
    --replace

# ------------------------------------------------------------------------------
# Set up app build environment
# ------------------------------------------------------------------------------
ARG NODE_VERSION=v22.14.0
ENV NVM_DIR=/home/${USERNAME}/.nvm
ENV NODE_VERSION=${NODE_VERSION}

# Set up Node by NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash && \
    bash -i -c "source ${NVM_DIR}/nvm.sh && \
    nvm install ${NODE_VERSION} && \
    nvm alias default ${NODE_VERSION}"

# Set up Yarn by corepack
RUN bash -i -c "source ${NVM_DIR}/nvm.sh && \
    npm install -g npm corepack && \
    corepack enable && \
    yarn set version stable"

# ------------------------------------------------------------------------------
# App install dependencies and build
# ------------------------------------------------------------------------------
USER root
RUN mkdir ${APP_WORKDIR}
WORKDIR ${APP_WORKDIR}
COPY . .
RUN chown -R ${USERNAME}:${USERNAME} ${APP_WORKDIR}
USER ${USERNAME}

# Install dependencies
RUN bash -i -c "source ${NVM_DIR}/nvm.sh && yarn install"

# Build
RUN bash -i -c "source ${NVM_DIR}/nvm.sh && yarn run build"

# https://vite.dev/config/server-options.html#server-port
EXPOSE 5173

# https://vite.dev/config/preview-options#preview-port
EXPOSE 4173

# set ENTRYPOINT for reloading nvm-environment
ENTRYPOINT ["bash", "-c", "source ${NVM_DIR}/nvm.sh && exec \"$@\"", "--"]

# ------------------------------------------------------------------------------
# Run
# ------------------------------------------------------------------------------
# Production app
# WORKDIR ${APP_WORKDIR}
# CMD ["yarn", "run", "preview"]

# Runner
WORKDIR ${RUNNER_WORKDIR}
CMD ["./run.sh"]
