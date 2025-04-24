FROM rockylinux:8

# Install dependencies
RUN dnf update -y && \
    dnf install -y \
    bash curl git passwd sudo perl-Digest-SHA procps-ng && \
    dnf clean all

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
# Options:
#   -u 1000: docker-compose volume default UID.
ARG USER_UID=1000
ARG USERNAME=appuser
ARG APP_WORKDIR=/app

# Set up user and directories
RUN useradd -m -u ${USER_UID} ${USERNAME} && \
    passwd -d ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir ${APP_WORKDIR} && \
    chown ${USERNAME}:${USERNAME} ${APP_WORKDIR}

USER ${USERNAME}
WORKDIR ${APP_WORKDIR}

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

# 의존성 설치를 위한 파일만 우선 복사
COPY --chown=${USERNAME}:${USERNAME} package.json yarn.lock ./
RUN source ${NVM_DIR}/nvm.sh && yarn install

# 전체 소스 복사
COPY --chown=${USERNAME}:${USERNAME} . .

RUN source ${NVM_DIR}/nvm.sh && yarn run build

# https://vite.dev/config/preview-options#preview-port
# https://vite.dev/config/server-options.html#server-port
EXPOSE 4173 5173

# set ENTRYPOINT for reloading nvm-environment
ENTRYPOINT ["bash", "-c", "source ${NVM_DIR}/nvm.sh && exec \"$@\"", "--"]
CMD ["yarn", "run", "preview"]
