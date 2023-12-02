#!/usr/bin/env bash
set -e

docker run --cap-add CHECKPOINT_RESTORE --cap-add SYS_ADMIN -d --rm -p 8069:8069 --name spring-petclinic springframework/spring-petclinic:checkpoint
