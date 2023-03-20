# Infrastructure

The Terraform code deploys a number of resources.  I'm not going to explain all of them, I'm just going to pull out the ones that are important to understand.

**DISCLAIMER**

This codebase isn't a demonstration on how to properly use modules and how to make them more generic.  In some areas I made the decision to hardcode certain features (for example deploying clusters in two different subnets) to make it a bit easier.

The modules being used here were heavily influenced by the [Cloud Foundation Fabric modules](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric), developed by Google.  

## Networking

The network contains 2 subnets, each in a different region. This is to demonstrate load balancing across 2 different regions, for 2 separate clusters.  The regions that are being used are `europe-west1` and `europe-west4`.  If you want to use different regions, simply update the following variables in your `terraform.tfvars`:
- `region_one`
- `region_two`

## GKE

As mentioned in the architectural diagram, the code creates two separate, zonal, GKE clusters.  It's possible to make these regional, or move them to different zones/regions, by updating the following variables:
- `cluster_one_location`
- `cluster_two_location`

Sandbox-mode is enabled by default.  One of the requirements is that you have to have at least 1 nodepool where Sandbox-mode is disabled, because GKE needs to be able to schedule certain pods.  I'm taking care of that in the GKE-module itself, to make this a bit easier.

##  