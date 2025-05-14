FROM rockylinux:8

RUN dnf update -y && \
    dnf install -y sudo openssh-server openssh-clients curl tar procps-ng && \
    dnf clean all

# Set up non-root user
ARG USER_UID=1000
ARG USERNAME=appuser
ARG USER_WORKDIR=/app

RUN useradd -m -u ${USER_UID} ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers  && \
    mkdir -p ${USER_WORKDIR} && \
    chown -R ${USER_UID}:${USER_UID} ${USER_WORKDIR}

# Set up SSH
EXPOSE 22
RUN sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
RUN rm -f /var/run/nologin /etc/nologin
RUN ssh-keygen -A

# Set up workspace
WORKDIR ${USER_WORKDIR}
USER ${USERNAME}

COPY --chown=${USERNAME}:${USERNAME} entrypoint.sh ${USER_WORKDIR}/entrypoint.sh
RUN chmod +x ${USER_WORKDIR}/entrypoint.sh

COPY --chown=${USERNAME}:${USERNAME} deploy_from_nexus.sh ${USER_WORKDIR}/deploy_from_nexus.sh
RUN chmod +x ${USER_WORKDIR}/deploy_from_nexus.sh

ENTRYPOINT ["/app/entrypoint.sh"]
