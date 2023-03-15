# ssl-gke-api-gateway

The purpose of this demo is to showcase a multi-cluster deployment and exposing deployments via a MultiClusterGateway, protected by a Google-managed SSL certificate.

![architecture diagram, incl. load balancer and 2 gke clusters](./00_-_docs/images/architecture.png)

## Instructions

Before we dive into the configuration of the individual resources, let's talk about how to create everything in your environment.  Follow these instructions to create your Google Cloud environment and deploy the application to the GKE clusters.

```shell
# Initialise Terraform configuration
terraform init -reconfigure -upgrade

# Apply Terraform configuration
terraform apply -auto-approve

# Set environment variables
export PROJECT_ID=$(terraform output -json | jq -r .project_id.value)
export CLUSTER_ONE_NAME=$(terraform output -json | jq -r .cluster_one_name.value)
export CLUSTER_TWO_NAME=$(terraform output -json | jq -r .cluster_two_name.value)
export LOCATION_ONE=$(terraform output -json | jq -r .cluster_one_location.value)
export LOCATION_TWO=$(terraform output -json | jq -r .cluster_two_location.value)

# Download Kubernetes credentials
$(terraform output -json | jq -r .cluster_one_credentials.value)
$(terraform output -json | jq -r .cluster_two_credentials.value)

# Rename context
kubectl config rename-context gke_${PROJECT_ID}_${LOCATION_ONE}_${CLUSTER_ONE_NAME} cluster-one
kubectl config rename-context gke_${PROJECT_ID}_${LOCATION_TWO}_${CLUSTER_TWO_NAME} cluster-two
```