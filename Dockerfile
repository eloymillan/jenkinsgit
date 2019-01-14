FROM jenkins/jenkins:lts

### install docker, docker-compose, docker-machine
### see: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
### see: https://docs.docker.com/engine/installation/linux/linux-postinstall/
### see: https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/

USER root

# prerequisites for docker
RUN apt-get update \
    && apt-get -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

# docker repos
RUN apt-get update && \
apt-get -y install apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
apt-get update 

# install docker-ce
RUN apt-get -y install docker-ce

# set permissions in docker.sock
RUN touch /var/run/docker.sock \
    chgrp jenkins /var/run/docker.sock

# docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# give jenkins docker rights
RUN usermod -aG docker jenkins

USER jenkins