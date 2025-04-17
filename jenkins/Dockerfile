FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y docker.io sudo

RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN usermod -aG docker jenkins

USER jenkins
