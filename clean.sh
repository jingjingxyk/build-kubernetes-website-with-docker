#!/bin/env bash
set -eux

sudo  sh -c '/bin/echo -e "\ny"'  |  docker system prune -a
