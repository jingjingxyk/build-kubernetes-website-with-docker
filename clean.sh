#!/bin/env bash
set -eux

sudo  sh -c '/bin/echo -e "\ny\ny"'  |  docker system prune -a
