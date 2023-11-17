#!/bin/sh

# This script is to prevent skaffold from logging an irritating warning when it doesn't find the docker binary.
# Skaffold actually doesn't need docker to deploy a Helm chart but for some of its other features.
# Skaffold tests the docker installation using the command `docker context inspect --format {{.Endpoints.docker.Host}}`.

echo unix:///docker/is/disabled
