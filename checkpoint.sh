#!/usr/bin/env bash
set -e

case $(uname -m) in
    arm64)   url="https://cdn.azul.com/zulu/bin/zulu17.44.55-ca-crac-jdk17.0.8.1-linux_aarch64.tar.gz" ;;
    *)       url="https://cdn.azul.com/zulu/bin/zulu17.44.55-ca-crac-jdk17.0.8.1-linux_x64.tar.gz" ;;
esac

echo "Using CRaC enabled JDK $url"

./mvnw clean package -DskipTests=true
docker build -t springframework/spring-petclinic:builder --build-arg CRAC_JDK_URL=$url .
docker run -d --privileged --rm --name=spring-petclinic --ulimit nofile=1024 -p 8069:8069 -v /$(pwd)/target://opt/mnt -e FLAG=$1 springframework/spring-petclinic:builder
echo "Please wait during creating the checkpoint..."
sleep 10
docker commit --change='ENTRYPOINT ["/opt/app/entrypoint.sh"]' $(docker ps -qf "name=spring-petclinic") springframework/spring-petclinic:checkpoint
docker kill $(docker ps -qf "name=spring-petclinic")
