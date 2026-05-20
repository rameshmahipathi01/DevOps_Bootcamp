#  RetailStore Application with Persistent Dataplane running on AWS EKS using Helm

# Architecture Diagrams

## Retail Store Application with Persistent Dataplane running on Kubernetes Cluster

This architecture demonstrates a complete microservices-based Retail Store Application deployed on Amazon EKS using Helm.

The application consists of multiple services:

| Service | Technology |
|---|---|
| UI | SpringBoot |
| Catalog | Go |
| Cart | SpringBoot |
| Checkout | NodeJS |
| Orders | SpringBoot |

---

# Persistent Dataplane Components

The application also includes self-hosted persistence components running inside Kubernetes.

| Component | Technology |
|---|---|
| Catalog Database | MySQL |
| Cart Database | DynamoDB Local |
| Checkout Cache | Redis |
| Orders Database | PostgreSQL |
| Orders Messaging | RabbitMQ |

---

# Key Architecture Highlights

- All workloads run inside Kubernetes cluster
- Persistent services are self-hosted within EKS
- Helm is used for deployment automation
- Ingress is exposed using AWS Load Balancer Controller (ALB)
- Each microservice has its own Helm chart
- Services communicate internally using Kubernetes networking

---

# Step-00: Download and Review Helm Charts

## Download Charts

```bash
cd retailstore-charts

./download-and-untar-helm-charts.sh
```

This script:
- Pulls Helm charts from OCI registry
- Downloads all required service charts
- Extracts charts locally

---

# Expected Helm Charts

```text
retail-store-sample-cart-chart
retail-store-sample-catalog-chart
retail-store-sample-checkout-chart
retail-store-sample-orders-chart
retail-store-sample-ui-chart
```

---

# Review Chart Structure

Each chart typically contains:

```text
Chart.yaml
templates/
values.yaml
```

---

# Step-01: Goals & Prerequisites

# Goals

In this section, we will:

- Deploy the complete Retail Store application using Helm
- Deploy Catalog, Cart, Checkout, Orders, and UI services
- Use custom values files for each service
- Expose the UI using AWS ALB Ingress
- Verify inter-service communication
- Enable application logging for troubleshooting

---

# Prerequisites

Ensure the following are available:

- Amazon EKS cluster
- kubectl configured
- Helm v3.8+
- OCI support enabled
- AWS Load Balancer Controller installed
- IRSA configured properly

---

# Required Files

Inside:

```text
12-05-Helm-Retail-Store/retailstore-apps/
```

ensure the following files exist:

```text
values-catalog.yaml
values-cart.yaml
values-checkout.yaml
values-orders.yaml
values-ui.yaml
install-retail-apps.sh
uninstall-retail-apps.sh
```

---

# Step-02: Install (Script — Recommended)

## Navigate to Application Directory

```bash
cd 12-05-Helm-Retail-Store/retailstore-apps
```

---

## Grant Execute Permission

```bash
chmod +x install-retail-apps.sh
```

---

## Execute Installation Script

```bash
./install-retail-apps.sh
```

---

# What the Script Does

The script installs services in order:

```text
catalog → cart → checkout → orders → ui
```

using:
- Helm charts version `1.3.0`
- Custom values files

This is the recommended deployment approach.

---

# Step-03: (Manual) Install Each Service

Use this method if you want to understand each Helm command individually.

---

# Authenticate to AWS Public ECR

```bash
aws ecr-public get-login-password --region us-east-1 \
| helm registry login -u AWS --password-stdin public.ecr.aws
```

---

# Change Directory

```bash
cd retailstore-apps
```

---

# Install Catalog Service

```bash
helm install catalog oci://public.ecr.aws/aws-containers/retail-store-sample-catalog-chart \
  --version 1.3.0 \
  -f values-catalog.yaml
```

---

# Install Cart Service

```bash
helm install cart oci://public.ecr.aws/aws-containers/retail-store-sample-cart-chart \
  --version 1.3.0 \
  -f values-cart.yaml
```

---

# Install Checkout Service

```bash
helm install checkout oci://public.ecr.aws/aws-containers/retail-store-sample-checkout-chart \
  --version 1.3.0 \
  -f values-checkout.yaml
```

---

# Install Orders Service

```bash
helm install orders oci://public.ecr.aws/aws-containers/retail-store-sample-orders-chart \
  --version 1.3.0 \
  -f values-orders.yaml
```

---

# Install UI Service

```bash
helm install ui oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 \
  -f values-ui.yaml
```

---

# Important Note About UI

The UI chart:
- Creates Ingress resources
- Exposes application externally
- Uses AWS Load Balancer Controller
- Creates ALB automatically

---

# Step-04: Verify Deployments & Resources

# List Helm Releases

```bash
helm list
```

---

# Verify Kubernetes Resources

```bash
kubectl get pods

kubectl get svc

kubectl get ingress
```

---

# View Helm Release Resources

```bash
helm status ui --show-resources

helm status catalog --show-resources

helm status cart --show-resources

helm status checkout --show-resources

helm status orders --show-resources
```

This helps verify:
- Deployments
- StatefulSets
- Services
- Ingress resources
- ConfigMaps

---

# Verify AWS Load Balancer Controller Logs

```bash
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller -f
```

---

# Important Observation

ALB provisioning usually takes:

```text
2–6 minutes
```

during the initial deployment.

---

# Step-05: Access the UI (ALB HTTP)

## Get Ingress Details

```bash
kubectl get ingress ui
```

Copy the ALB DNS name from the output.

---

# Access Application in Browser

```text
http://<ALB-DNS-NAME>
```

---

# Access Topology Endpoint

```text
http://<ALB-DNS-NAME>/topology
```

The topology endpoint helps visualize:
- Microservices
- Service dependencies
- Application flow

---

# Step-06: Verify Application Logs

Application logs help verify:
- Traffic flow
- Service communication
- Errors and failures
- Application health

---

# UI Logs

```bash
kubectl logs -f deploy/ui

kubectl logs -l app.kubernetes.io/instance=ui -f --tail=200
```

---

# Catalog Logs

```bash
kubectl logs -f deploy/catalog

kubectl logs -l app.kubernetes.io/instance=catalog -f --tail=200
```

---

# Cart Logs

```bash
kubectl logs -f deploy/cart-carts

kubectl logs -l app.kubernetes.io/instance=cart -f --tail=200
```

---

# Checkout Logs

```bash
kubectl logs -f deploy/checkout

kubectl logs -l app.kubernetes.io/instance=checkout -f --tail=200
```

---

# Orders Logs

```bash
kubectl logs -f deploy/orders

kubectl logs -l app.kubernetes.io/instance=orders -f --tail=200
```

---

# Step-07: Enable Extensive Logging

Sometimes default logging is minimal.

We can increase logging verbosity dynamically using environment variables.

This is useful for:
- Debugging
- Tracing requests
- Understanding service flow
- Troubleshooting failures

---

# Cart Microservice Logging (SpringBoot)

## Enable DEBUG Logging

```bash
kubectl set env deployment/cart-carts LOGGING_LEVEL_ROOT=DEBUG

kubectl rollout status deployment/cart-carts

kubectl logs -l app.kubernetes.io/instance=cart -f --tail=200
```

---

## Rollback to INFO Logging

```bash
kubectl set env deployment/cart-carts LOGGING_LEVEL_ROOT=INFO

kubectl rollout status deployment/cart-carts

kubectl logs -l app.kubernetes.io/instance=cart -f --tail=200
```

---

# UI Microservice Logging (SpringBoot)

## Enable DEBUG Logging

```bash
kubectl set env deployment/ui LOGGING_LEVEL_ROOT=DEBUG

kubectl rollout status deployment/ui

kubectl logs -l app.kubernetes.io/instance=ui -f --tail=200
```

---

## Rollback to INFO Logging

```bash
kubectl set env deployment/ui LOGGING_LEVEL_ROOT=INFO

kubectl rollout status deployment/ui

kubectl logs -l app.kubernetes.io/instance=ui -f --tail=200
```

---

# Why Logging Changes Trigger Rollouts

Changing environment variables updates the Pod template.

Kubernetes automatically:
- Creates new ReplicaSet
- Restarts Pods
- Applies updated environment variables

---

# Step-08: Uninstall Retail Store Application

# Script-Based Cleanup

```bash
cd 12-05-Helm-Retail-Store/retailstore-apps

./uninstall-retail-apps.sh
```

---

# Manual Cleanup

```bash
helm uninstall ui orders checkout cart-carts catalog
```

---

# What Cleanup Removes

This removes:
- Deployments
- Services
- Ingress resources
- StatefulSets
- ConfigMaps
- Helm releases

from the Kubernetes cluster.