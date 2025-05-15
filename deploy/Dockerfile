FROM rockylinux:8

# Set up environment variables
ARG NEXUS_HOST=http://nexus:8081
ARG NEXUS_PASSWORD
ARG NEXUS_USER=admin
ARG NEXUS_REPO
ENV NEXUS_HOST=${NEXUS_HOST}
ENV NEXUS_PASSWORD=${NEXUS_PASSWORD}
ENV NEXUS_USER=${NEXUS_USER}
ENV NEXUS_REPO=${NEXUS_REPO}

RUN dnf update -y && \
    dnf install -y sudo openssh-server openssh-clients curl tar procps-ng && \
    dnf clean all

# Set up SSH configuration
EXPOSE 22
RUN sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
RUN rm -f /var/run/nologin /etc/nologin
RUN ssh-keygen -A

# Create a non-root user
ARG USER_UID=1000
ARG USERNAME=appuser
ARG USER_WORKDIR=/app

RUN useradd -m -u ${USER_UID} ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers  && \
    mkdir -p ${USER_WORKDIR} && \
    chown -R ${USER_UID}:${USER_UID} ${USER_WORKDIR}

# Set up a non-root user workspace
WORKDIR ${USER_WORKDIR}
USER ${USERNAME}

# Initial a non-root user SSH authorized_keys
RUN mkdir -p ~/.ssh && chmod 700 ~/.ssh && \
    touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys

# Support a non-root user non-interactive shell
RUN echo "export NEXUS_HOST=${NEXUS_HOST}" >> /home/${USERNAME}/.bash_profile
RUN echo "export NEXUS_PASSWORD=${NEXUS_PASSWORD}" >> /home/${USERNAME}/.bash_profile
RUN echo "export NEXUS_USER=${NEXUS_USER}" >> /home/${USERNAME}/.bash_profile
RUN echo "export NEXUS_REPO=${NEXUS_REPO}" >> /home/${USERNAME}/.bash_profile

# Set up deploy scripts
COPY --chown=${USERNAME}:${USERNAME} deploy_from_nexus.sh ${USER_WORKDIR}/deploy_from_nexus.sh
RUN chmod +x ${USER_WORKDIR}/deploy_from_nexus.sh

# Set up entrypoint script
COPY --chown=${USERNAME}:${USERNAME} entrypoint.sh ${USER_WORKDIR}/entrypoint.sh
RUN chmod +x ${USER_WORKDIR}/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
