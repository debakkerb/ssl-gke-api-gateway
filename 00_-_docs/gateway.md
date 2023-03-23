# MultiClusterGateway

![Architecture diagram](./images/architecture.png)

As described in the architectural diagram, the application is deployed in two separate namespaces, on both clusters.  By implementing namespace sameness, it's possible to create a logical grouping of application across different clusters.

## Fleet

To be able to use a MultiClusterGateway, it's important that all clusters are registered to the same fleet and have the following features enabled:
- multiclusteringress
- multiclusterservicediscovery

## Service and ServiceExport

For each `Service`, a `ServiceExport`-resource has to be created.  This allows the Gateway controller to create a corresponding `ServiceImport`-resource on the other cluster(s), so that service endpoints are discoverable between clusters.  It can then send traffic to both endpoints.

It's important to note that the Gateway doesn't use the `Service`-resource to route traffic. It's merely used as a logical grouping of Pods to send traffic to.  The Gateway will ultimate result in an HTTPS Load Balancer that uses container native load balancing to send traffic to the underlying pods.

## Gateway

```yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: external-https
  namespace: gateway-infra
  annotations:
    networking.gke.io/certmap: certificate-map
spec:
  gatewayClassName: gke-l7-gxlb-mc
  listeners:
    - name: https
      port: 443
      protocol: HTTPS
      allowedRoutes:
        kinds:
          - kind: HTTPRoute
        namespaces:
          from: Selector
          selector:
            matchExpressions:
              - key: kubernetes.io/metadata.name
                operator: In
                values:
                  - consumer
                  - accounting
```

The Gateway resource is deployed in a dedicated Namespace on the config cluster (`cluster-zone-one` in this scenario).  It only accepts HTTPS traffic and will only send traffic to either the `consumer`-namespace or `accounting`-namespace.

## Routing

```yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: accounting-external
  namespace: accounting
spec:
  hostnames:
    - "DOMAIN"
  parentRefs:
    - name: external-https
      namespace: gateway-infra
      kind: Gateway
  rules:
      - backendRefs:
        - group: net.gke.io
          kind: ServiceImport
          name: acc-demo-app
          port: 8080
```

For each endpoint, an `HTTPRoute` is created that will only route traffic for their respective domain.  The `parentRefs`-block indicates to which Gateway it will attach.  It's possible to configure multiple `backendRefs`, but in this example we're only using one.  As a `backendRef`, we use the `ServiceImport` resource created earlier.

## Healthcheck

By default, the platform healthcheck will use `/` as the endpoint.  The application however exposes a custom healthpoint (`/v1/healthcheck`), so you have to create an additional `HealthCheckPolicy` to ensure that the correct endpoint is checked:

```yaml
apiVersion: networking.gke.io/v1
kind: HealthCheckPolicy
metadata:
  namespace: accounting
  name: accounting-app-healthcheck
spec:
  default:
    config:
      type: HTTP
      httpHealthCheck:
        port: 4000
        requestPath: /v1/healthcheck
        host: acc-demo-app
        portSpecification: USE_FIXED_PORT
    logConfig:
      enabled: true
  targetRef:
    group: net.gke.io
    kind: ServiceImport
    name: acc-demo-app
```