#!/usr/bin/env bash

# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

PARENT_DIR=$(pwd)

# Switch to Terraform directory
cd ${PARENT_DIR}/01_-_infrastructure

# Initialise Terraform configuration
terraform init -reconfigure -upgrade

# Apply Terraform configuration
terraform apply -auto-approve

# Get the kubernetes credentials
$(terraform output -json | jq -r .cluster_one_credentials.value)
$(terraform output -json | jq -r .cluster_two_credentials.value)

# Rename context
kubectl config delete-context mgw-cluster-one
kubectl config delete-context mgw-cluster-two
kubectl config rename-context gke_${PROJECT_ID}_${LOCATION_ONE}_${CLUSTER_ONE_NAME} mgw-cluster-one
kubectl config rename-context gke_${PROJECT_ID}_${LOCATION_TWO}_${CLUSTER_TWO_NAME} mgw-cluster-two
kubectl config use-context mgw-cluster-one

# Source environment variables
cd ${PARENT_DIR}
source env.sh

cd ${PARENT_DIR}/02_-_app
make build/docker

# Create Kustomize configuration
cd ${PARENT_DIR}/03_-_kubernetes/

# Update configuration files so they contain the updated fields
cp overlays/accounting/kustomization.yaml.orig overlays/accounting/kustomization.yaml
cp overlays/consumer/kustomization.yaml.orig overlays/consumer/kustomization.yaml

sed -i '' "s|IMAGE_NAME|${IMAGE_NAME}|g" ./overlays/accounting/kustomization.yaml
sed -i '' "s|IMAGE_TAG|${IMAGE_TAG}|g" ./overlays/accounting/kustomization.yaml
sed -i '' "s|SERVICE_ACCOUNT|${ACCOUNTING_APP_IDENTITY}|g" ./overlays/accounting/kustomization.yaml

sed -i '' "s|IMAGE_NAME|${IMAGE_NAME}|g" ./overlays/consumer/kustomization.yaml
sed -i '' "s|IMAGE_TAG|${IMAGE_TAG}|g" ./overlays/consumer/kustomization.yaml
sed -i '' "s|SERVICE_ACCOUNT|${ACCOUNTING_APP_IDENTITY}|g" ./overlays/consumer/kustomization.yaml

# Deploy resources to both clusters
kubectl apply -k ./ --context mgw-cluster-one
kubectl apply -k ./ --context mgw-cluster-two

