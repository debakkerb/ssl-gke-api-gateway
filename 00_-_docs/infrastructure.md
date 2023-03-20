# Infrastructure

The Terraform code deploys a number of resources.  I'm not going to explain all of them, I'm just going to pull out the ones that are important to understand.

**DISCLAIMER**

This codebase isn't a demonstration on how to properly use modules and how to make them more generic.  In some areas I made the decision to hardcode certain features (for example deploying clusters in two different subnets) to make it a bit easier on myself and also to clearly demonstrate what is happening, without adding a ton of generic configs that I'm not using.

The modules being used here were heavily influenced by the [Cloud Foundation Fabric modules](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric), developed by Google.  Please use this repository if you are looking for modules that demonstrate best practices.

## Networking

The network contains 2 subnets, each in a different region. This is to demonstrate load balancing across 2 different regions, for 2 separate clusters.  The regions that are being used are `europe-west1` and `europe-west4`.  If you want to use different regions, simply update the following variables in your `terraform.tfvars`:
- `region_one`
- `region_two`

If you update these variables, make sure to update the locations of both clusters as well, as they have to correspond to the regions being used for the subnets.

## GKE

As mentioned in the architectural diagram, the code creates two separate, zonal, GKE clusters.  It's possible to make these regional, or move them to different zones/regions, by updating the following variables:
- `cluster_one_location`
- `cluster_two_location`

The nodes on the cluster have private IP addresses, but the control plane is exposed over a public IP address.  If you want to avoid this and use a private IP address for the control plane as well, update your `terraform.tfvars`-file and use the following configuration:

```hcl
private_cluster_config = {
  enable_private_endpoint = true
}
```

##  Fleet configuration

In order for the Gateway API to work, your clusters have to be part of a fleet and the following features have to be enabled:
- multiclusteringress
- multiclusterservicediscovery

In [`gke_fleet.tf`](../01_-_infrastructure/gke_fleet.tf) you can see that some IAM permissions are created for robot service accounts.  

## Certificates

As we are using wildcard-certificates, we need to go down the path of DNS authorization, for our self-managed TLS certificates.  All Terraform resources to create a wildcard certificate are configured in [`certificates.tf`](../01_-_infrastructure/certificates.tf)

Once the installer finishes, it will output the CNAME record you need to create on your DNS domain.  You will also have to create two separate A-records for both the `accounting` and `consumer` deployments.  They have to point to the public IP address of the Gateway.
