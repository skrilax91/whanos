FROM jenkins/jenkins:lts

USER root
RUN apt-get update && apt-get -y install apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

# Install Docker
RUN mkdir -m 0755 -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update && apt-get -y install docker-ce docker-ce-cli containerd.io kubectl

# Install HELM
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

COPY helm/ /helm/


ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY ./configs/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
COPY ./images /images
COPY ./configs /jenkins
RUN chmod +x /jenkins/scripts/*.sh
ENV CASC_JENKINS_CONFIG /jenkins/config.yml