# Helm Chart Exploration - Retail UI

# Step-01: Goals & Prerequisites

## Goals

In this section, we will learn:

- How to pull an OCI Helm chart and explore its source code
- How `values.yaml` connects with the `templates/` directory
- How Helm renders Kubernetes YAML manifests
- How to lint Helm charts before deployment
- How to understand Helm charts like source code instead of treating them as a black box

---

## Prerequisites

Ensure the following are available:

- Helm v3.8+ (OCI support enabled)
- Kubernetes cluster (optional for rendering)
- `tree`, `find`, `grep`, or `rg` (ripgrep) utilities
- Previous custom values file

Example:

```text
values-ui.yaml
```

---

# Step-02: Pull & Unpack the Chart (OCI → Local Folder)

## Create Workspace

```bash
mkdir -p charts && cd charts
```

---

## Pull OCI Chart from AWS Public ECR

```bash
helm pull oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 \
  --untar
```

### What this command does

- Pulls the Helm chart from OCI registry
- Downloads the chart locally
- Extracts (`--untar`) the chart contents into a folder

---

## Verify Extracted Folder

```bash
ls -la
```

---

## Optional: Install tree Utility

### Ubuntu / Debian

```bash
sudo apt install tree -y
```

### macOS

```bash
brew install tree
```

---

## View Folder Structure

```bash
tree -a || true
```

---

# Expected Folder Structure

```text
retail-store-sample-ui-chart
├── .helmignore
├── Chart.yaml
├── README.md
├── templates
│   ├── _helpers.tpl
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── istio-gateway.yaml
│   ├── istio-virtualservice.yaml
│   ├── NOTES.txt
│   ├── pdb.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml
```

---

## Rename Folder for Simplicity

```bash
mv retail-store-sample-ui-chart ui
```

This is optional, but helps keep paths shorter during exploration.

---

# Step-03: Quick Tour — What Each File Does

Helm charts follow a common directory structure.

Understanding this structure is important for debugging and customizing Helm deployments.

---

## Chart.yaml

Contains chart metadata.

Example details:
- Chart name
- Description
- Chart version
- Application version
- Chart type

---

## values.yaml

Contains default configuration values used by the chart.

These values are applied unless overridden using:
- `-f values.yaml`
- `--set key=value`

---

## .helmignore

Similar to `.gitignore`.

Defines files/folders excluded during chart packaging.

---

## templates/

Contains Kubernetes YAML templates rendered by Helm.

---

## Common Template Files

### deployment.yaml

Defines:
- Pods
- ReplicaSets
- Container configuration

Usually references many `.Values.*` variables.

---

### service.yaml

Defines Kubernetes Service configuration.

Example:
- ClusterIP
- NodePort
- LoadBalancer

---

### ingress.yaml

Defines Ingress resources and ALB annotations.

---

### configmap.yaml

Stores application configuration rendered from Helm values.

---

### _helpers.tpl

Contains reusable Helm helper templates.

Typically used for:
- Labels
- Naming conventions
- Common annotations

---

### NOTES.txt

Post-install instructions displayed after Helm install completes.

---

### Other Optional Templates

| File | Purpose |
|---|---|
| hpa.yaml | Horizontal Pod Autoscaler |
| pdb.yaml | Pod Disruption Budget |
| serviceaccount.yaml | Service Account |
| tests/* | Helm test hooks |
| istio-* | Istio integrations |

---

## Important Learning Tip

Open:
- `values.yaml`
- `templates/`

side-by-side.

While reading templates, trace how:

```text
.Values.*
```

maps back into:

```text
values.yaml
```

This is one of the most important Helm skills.

---

# Step-04: Discover the Available Knobs (Chart Defaults)

## View Default Values from OCI Registry

```bash
helm show values oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 | less
```

This helps discover:
- Configurable parameters
- Feature flags
- Resource settings
- Ingress settings
- Application configuration

---

## View Local values.yaml

```bash
cat ui/values.yaml
```

---

## Optional Discovery Commands

### View Chart Metadata

```bash
helm show chart oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0
```

---

### View Chart README

```bash
helm show readme oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0
```

---

# Step-05: Lint & Render (No Cluster Needed)

One major benefit of Helm is that templates can be validated locally before deployment.

---

## Navigate to Charts Directory

```bash
cd 12-03-Helm-Chart-Explore/charts
```

---

## Lint Helm Chart

```bash
helm lint ui
```

### Purpose of Linting

Helm lint checks for:
- Syntax errors
- Template problems
- Invalid chart structure
- Common best practice violations

---

## Render Templates Locally (Default Values)

```bash
helm template ui ./ui | less
```

This generates the final Kubernetes YAML manifests without deploying them.

---

## Render using Custom Values

```bash
helm template ui ./ui -f ../retailstore-apps/values-ui.yaml | less
```

---

## Render with Debug Output

```bash
helm template ui ./ui -f ../retailstore-apps/values-ui.yaml --debug | less
```

---

## Goal of Rendering

The goal is to:
- View final Kubernetes YAML
- Verify Helm substitutions
- Validate custom values
- Troubleshoot rendered manifests

This is heavily used in production CI/CD pipelines.

---

# Step-06: (Optional) Install Locally From the Unpacked Chart

Instead of installing from OCI registry, we can install directly from the local chart source.

This is useful while:
- Developing charts
- Testing changes
- Debugging templates

---

## Navigate to Charts Directory

```bash
cd 12-03-Helm-Chart-Explore/charts
```

---

## Install Local Helm Chart

```bash
helm install ui-local ./ui -f ../retailstore-apps/values-ui.yaml
```

---

## Verify Resources

```bash
helm status ui-local --show-resources

kubectl get pods,svc,ing
```

---

# Step-07: Quick Value Change (Theme → orange)

In this section, we modify Helm values and verify how changes appear in rendered manifests.

---

# A) Edit the Value

Update:

```text
../retailstore-apps/values-ui.yaml
```

to:

```yaml
app:
  theme: orange
```

---

# B) Re-render Locally (No Cluster Needed)

```bash
helm template ui ./ui -f ../retailstore-apps/values-ui.yaml | less
```

---

## Search for Theme Usage

```bash
helm template ui ./ui -f ../retailstore-apps/values-ui.yaml | grep -ni theme
```

This helps identify:
- Where values are injected
- Which templates consume the values
- How Helm renders the final YAML

---

# C) (Optional) Apply to Running Release

## Upgrade Existing Release

```bash
helm upgrade --install ui-local ./ui -f ../retailstore-apps/values-ui.yaml
```

---

## Verify Effective Values

```bash
helm get values ui-local --all
```

---

## Search Theme Value

```bash
helm get values ui-local --all | grep theme
```

---

## Verify Pods

```bash
kubectl get pods
```

---

# Restart Pods if Needed

Sometimes value changes inside:
- ConfigMaps
- Environment variables

do not automatically restart pods.

Manually restart the deployment:

```bash
kubectl rollout restart deploy -l app.kubernetes.io/instance=ui-local
```

---

## Verify Restarted Pods

```bash
kubectl get pods
```

---

# Step-08: Helm Tests (If the Chart Ships Them)

Some Helm charts include test hooks under:

```text
templates/tests/*
```

In this chart:

```text
templates/tests/test-connection.yaml
```

exists.

---

## Run Helm Test

```bash
helm test ui-local
```

---

## What Helm Test Does

Helm test:
- Creates temporary test pods
- Verifies application connectivity
- Checks release health

Tests run only after the release is installed successfully.

---

# Step-09: Uninstall ui-local Helm Release

## Remove Local Release

```bash
helm uninstall ui-local
```

This removes all Kubernetes resources created by the release.

---

# Step-10: Handy Reference Commands (Cheat-Sheet)

## Pull & Extract OCI Chart

```bash
helm pull oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 \
  --untar
```

---

## Show Chart Metadata

```bash
helm show chart oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0
```

---

## Show Default Values

```bash
helm show values oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0
```

---

## Show Chart README

```bash
helm show readme oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0
```

---

## Lint Local Chart

```bash
helm lint ui
```

---

## Render Local Templates

```bash
helm template ui ./ui -f ../retailstore-apps/values-ui.yaml --debug
```

---

## Install from Local Source

```bash
helm install ui-local ./ui -f ../retailstore-apps/values-ui.yaml
```

---

## View Installed Resources

```bash
helm status ui-local --show-resources
```

---

## Author
Ramesh