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

# Source environment variables
cd ${PARENT_DIR}
source env.sh

# Rename context
kubectl config delete-context mgw-cluster-one || true
kubectl config delete-context mgw-cluster-two || true
kubectl config rename-context gke_${PROJECT_ID}_${LOCATION_ONE}_${CLUSTER_ONE_NAME} mgw-cluster-one
kubectl config rename-context gke_${PROJECT_ID}_${LOCATION_TWO}_${CLUSTER_TWO_NAME} mgw-cluster-two
kubectl config use-context mgw-cluster-one

cd ${PARENT_DIR}/02_-_app
make build/docker

# Create Kustomize configuration
cd ${PARENT_DIR}/03_-_kubernetes/app

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

# Deploy Gateway

cd ${PARENT_DIR}/03_-_kubernetes/gateway

cp public-app-route-accounting.yaml.orig public-app-route-accounting.yaml
cp public-app-route-consumer.yaml.orig public-app-route-consumer.yaml

sed -i '' "s|DOMAIN|accounting.${DOMAIN}|g" ./public-app-route-accounting.yaml
sed -i '' "s|DOMAIN|consumer.${DOMAIN}|g" ./public-app-route-consumer.yaml

kubectl apply -f ./ --context mgw-cluster-one

echo "Retrieving Gateway address ..."
GATEWAY_ADDRESS=$(kubectl get gateways.gateway.networking.k8s.io external-https -o=jsonpath="{.status.addresses[0].value}" -n gateway-infra --context mgw-cluster-one)
while [ -z "$GATEWAY_ADDRESS" ]; do
  GATEWAY_ADDRESS=$(kubectl get gateways.gateway.networking.k8s.io external-https -o=jsonpath="{.status.addresses[0].value}" -n gateway-infra --context mgw-cluster-one)
done
echo "Gateway address provisioned: ${GATEWAY_ADDRESS}"

# Patching the environment variables on cluster one
kubectl -n accounting set env deployment/acc-demo-app \
  AUDIENCE=accounting \
  NAMESPACE=accounting \
  CLUSTER=${CLUSTER_ONE_NAME} \
  REGION=${LOCATION_ONE} \
  --context mgw-cluster-one

kubectl -n consumer set env deployment/cons-demo-app \
  AUDIENCE=consumer \
  NAMESPACE=consumer \
  CLUSTER=${CLUSTER_ONE_NAME} \
  REGION=${LOCATION_ONE} \
  --context mgw-cluster-one

# Patching the environment variables on cluster two
kubectl -n accounting set env deployment/acc-demo-app \
  AUDIENCE=accounting \
  NAMESPACE=accounting \
  CLUSTER=${CLUSTER_TWO_NAME} \
  REGION=${LOCATION_TWO} \
  --context mgw-cluster-two

kubectl -n consumer set env deployment/cons-demo-app \
  AUDIENCE=consumer \
  NAMESPACE=consumer \
  CLUSTER=${CLUSTER_TWO_NAME} \
  REGION=${LOCATION_TWO} \
  --context mgw-cluster-two

# Manual config

echo "##############################################################################################"
echo "Please update your DNS records with the following details:"
echo "- Add a CNAME record for *.${DOMAIN}, data: ${CNAME_RECORD}"
echo "- Add an A-record for accounting.${DOMAIN}, data: ${GATEWAY_ADDRESS}"
echo "- Add an A-record for consumer.${DOMAIN}, data: ${GATEWAY_ADDRESS}"
echo "##############################################################################################"
