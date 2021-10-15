#!/bin/bash

set -o errexit

DOCKER_TAG=$(echo $GITHUB_SHA | cut -c1-7)
DOCKER_FILE=Dockerfile

DOCKER_IMAGE=$DOCKER_REGISTRY/$DOCKER_USERNAME/$DOCKER_REPOSITORY:$DOCKER_TAG

docker build -t $DOCKER_IMAGE -f $DOCKER_FILE .
docker push $DOCKER_IMAGE

exit 0
