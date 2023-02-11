FROM jenkins/jenkins:lts

USER root
RUN apt-get update && apt-get -y install apt-transport-https ca-certificates curl software-properties-common

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY ./configs/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
COPY ./images /images
COPY ./configs /jenkins
ENV CASC_JENKINS_CONFIG /jenkins/config.yml