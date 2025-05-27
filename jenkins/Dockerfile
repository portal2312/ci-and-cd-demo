FROM jenkins/jenkins:lts

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends docker.io sudo \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'jenkins ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    usermod -aG docker jenkins

USER jenkins
