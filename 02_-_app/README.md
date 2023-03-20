## Application

The application deployed on both cluster is a simple app that exposes two endpoints:
- /v1/healthcheck
- /v1/cluster-info

The goal of this demo is not to have a fully working application, but to easily demonstrate MultiClusterGateway on GKE.  For that reason I wanted to make the codebase as simple as possible, as exposing multiple microservices didn't add much value in this case.

