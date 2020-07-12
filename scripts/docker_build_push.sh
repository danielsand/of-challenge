#!/usr/bin/env bash

docker build -t simple-service:vanilla .
docker tag simple-service:vanilla fiebre/simple-service:vanilla
docker push fiebre/simple-service:vanilla
