#!/bin/bash

if [ $# -ne 1 ]; then
  echo 1>&2 "Usage: $0 HELM_CHART_DIR"
  exit 3
fi

helm_chart_dir=$1

echo "Running: helm repo update"
helm repo list && helm repo update || true

echo 'Running: helm plugin uninstall'
helm plugin remove secrets

echo 'Running: helm plugin install'
helm plugin install https://github.com/futuresimple/helm-secrets

echo 'Running: helm repo add'
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo add appuio https://charts.appuio.ch

echo 'Running: helm dependency update'
helm dependency update ${helm_chart_dir}
