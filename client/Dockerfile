FROM rockylinux:8

# Set up NVM version
ARG NODE_VERSION=v22.14.0

RUN dnf update -y && \
    dnf install -y bash curl git && \
    dnf clean all

ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=$NODE_VERSION

# Set up Node (From NVM)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash && \
    bash -i -c "source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION"

# Set up Yarn (From corepack)
RUN bash -i -c "source $NVM_DIR/nvm.sh && \
    npm install -g npm corepack && \
    corepack enable && \
    yarn set version stable"

WORKDIR /app

COPY . .

# Install dependencies
RUN bash -i -c "source $NVM_DIR/nvm.sh && yarn install"

# Build
RUN bash -i -c "source $NVM_DIR/nvm.sh && yarn run build"

# https://vite.dev/config/server-options.html#server-port
EXPOSE 5173

# https://vite.dev/config/preview-options#preview-port
EXPOSE 4173

# set ENTRYPOINT for reloading nvm-environment
ENTRYPOINT ["bash", "-c", "source $NVM_DIR/nvm.sh && exec \"$@\"", "--"]

CMD ["yarn", "run", "preview"]
