#!/bin/bash

# not required as docker-compose does same thing
sudo docker run --name jenkins-blueocean --restart=on-failure --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.414.2

# get the first admin password from its stored location in jenkins
sudo docker exec jenkins_server_container cat /var/jenkins_home/secrets/initialAdminPassword  


sudo cat /var/lib/docker/volumes/$(echo "${PWD##*/}")_jenkins-data/_data/secrets/initialAdminPassword

sudo cat /var/lib/docker/volumes/$(echo "${PWD##*/}")_jenkins-data/_data/secrets/master.key

sudo sudo docker exec -it jenkins_server_container bash

sudo docker run -d --rm --name=agent1 -p 22:22 \
-e "JENKINS_AGENT_SSH_PUBKEY=[your-public-key]" \
jenkins/ssh-agent:alpine-jdk17

# build node agent
sudo docker build -f Dockerfile.node_agent .  -t tonynabil21/jenkins_nodejs_agent
sudo docker push tonynabil21/jenkins_nodejs_agent
