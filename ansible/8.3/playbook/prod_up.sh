#!/usr/bin/env bash

docker run -dit --name centos7 docker.io/pycontribs/centos:7
docker exec -it centos7 bash -c 'yum install -y sudo'
docker run -dit --name centos8 docker.io/pycontribs/centos:8
docker exec -it centos8 bash -c 'yum install -y sudo'
docker run -dit --name ubuntu docker.io/pycontribs/ubuntu:latest