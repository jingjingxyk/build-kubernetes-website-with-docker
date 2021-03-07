#!/bin/env bash
set -eux
sh build-prepare.sh
sh build-calico-docs.sh
sh build-ceph-io-wiki.sh
sh build-istio-io-weiki.sh
sh build-kubernetes-tools.sh
sh build-nginx-quick-http3.sh
sh clean.sh

