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

EXPOSE 80
EXPOSE 443

# Install dependencies
RUN dnf upgrade -y && \
    dnf install -y epel-release && \
    dnf install -y --allowerasing \
    # For Runner
    glibc glibc-langpack-en libicu libcurl openssl-libs krb5-libs zlib lttng-ust libunwind libuuid \
    # For utils
    curl git openssh-clients openssh-server passwd perl-Digest-SHA procps-ng sudo \
    # For Python
    gcc openssl-devel bzip2-devel libffi-devel xz-devel make ncurses-devel gdbm-devel tk-devel readline-devel \
    # For uv
    ca-certificates \
    # For Java
    java-1.8.0-openjdk-devel \
    # For Nginx
    nginx && \
    dnf clean all

# Set up Python 3.13.2
RUN curl -O https://www.python.org/ftp/python/3.13.2/Python-3.13.2.tar.xz && \
    tar -xf Python-3.13.2.tar.xz && \
    cd Python-3.13.2 && \
    ./configure --enable-optimizations && \
    make altinstall && \
    ln -s /usr/local/bin/python3.13 /usr/local/bin/python && \
    rm -rf ../Python-3.13.2*

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
