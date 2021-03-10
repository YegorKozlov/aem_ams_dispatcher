#!/bin/bash

docker build --rm --no-cache -t ams-dispatcher .
docker run --privileged --name ams-dispatcher --rm -p 80:80 ams-dispatcher
