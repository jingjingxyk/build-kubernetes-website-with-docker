#!/bin/env bash
set -eux

sudo  sh -c '/bin/echo -e "y\ny\n"'  |  docker system prune -a
docker images
df -HT
