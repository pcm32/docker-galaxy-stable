#!/bin/bash
set -x -e

ANSIBLE_REPO=galaxyproject/ansible-galaxy-extras
ANSIBLE_RELEASE=14c60b66f10326c7d158627b004d58e38ca503e4

GALAXY_RELEASE=release_18.05
GALAXY_REPO=galaxyproject/galaxy

DOCKER_ADDITIONAL_BUILD_ARGS=""
#"--no-cache"

# For using latest simply leave this variable empty or set to ":latest". This should be the case on the master branch.
TAG=":18.05"

docker pull postgres

docker build $DOCKER_ADDITIONAL_BUILD_ARGS --build-arg ANSIBLE_REPO=$ANSIBLE_REPO --build-arg ANSIBLE_RELEASE=$ANSIBLE_RELEASE -t quay.io/bgruening/galaxy-base$TAG ./galaxy-base/
docker build $DOCKER_ADDITIONAL_BUILD_ARGS --build-arg GALAXY_REPO=$GALAXY_REPO --build-arg GALAXY_RELEASE=$GALAXY_RELEASE -t quay.io/bgruening/galaxy-init$TAG ./galaxy-init/

# Build the Galaxy web-application container
docker build $DOCKER_ADDITIONAL_BUILD_ARGS -t quay.io/bgruening/galaxy-web$TAG ./galaxy-web/

docker build $DOCKER_ADDITIONAL_BUILD_ARGS --build-arg ANSIBLE_REPO=$ANSIBLE_REPO --build-arg ANSIBLE_RELEASE=$ANSIBLE_RELEASE -t quay.io/bgruening/galaxy-proftpd$TAG ./galaxy-proftpd

# Build the postgres container
docker build $DOCKER_ADDITIONAL_BUILD_ARGS -t quay.io/bgruening/galaxy-postgres$TAG ./galaxy-postgres

# The SLURM cluster
docker build $DOCKER_ADDITIONAL_BUILD_ARGS -t quay.io/bgruening/galaxy-slurm$TAG ./galaxy-slurm

# we build a common HTCondor and derive from that laster
docker build -t quay.io/bgruening/galaxy-htcondor-base$TAG ./galaxy-htcondor-base
docker build -t quay.io/bgruening/galaxy-htcondor$TAG ./galaxy-htcondor
docker build -t quay.io/bgruening/galaxy-htcondor-executor$TAG ./galaxy-htcondor-executor

docker build -t quay.io/bgruening/galaxy-grafana$TAG ./galaxy-grafana
