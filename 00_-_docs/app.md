# Demo Application

The codebase contains a small demo application that exposes two different endpoints:
- /v1/appinfo
- /v1/healthcheck

Functionally there isn't much happening here, but it's just to show an application with multiple endpoints and how they can serve traffic to a Gateway deployed across multiple clusters.

**Disclaimer**

Structure and coding of this application was heavily influenced by the book [Let's Go Further](https://lets-go-further.alexedwards.net/), written by Alex Edwards.

## Build image

There is a Makefile available that can help you build an image and push it to artifact registry.  The Terraform configuration creates an `.envrc` file in the app-directory with the name of the Artifact Registry repository and the image name.  So it's essential to build the infrastructure layer first.  This file is added to `.gitignore`, as it contains information specific to the Google Cloud environment.  

## Runtime

The application is exposed on port 4000 and exposes the following endpoints:
- /v1/healthcheck
- /v1/appinfo

Functionally the application is pretty pointless, but the goal here is not to demonstrate writing applications in Go, but use it as a means to demonstrate multi-cluster deployments and endpoints.

## Build

Before building the image, ensure that the `.envrc`-file exists and contains the correct value for `IMAGE_NAME`. 

```shell
make build/docker
```