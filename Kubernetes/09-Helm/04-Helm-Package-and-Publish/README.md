# Package & Publish Retail UI Helm Chart (ECR Private)

# Step-01: Introduction

In this demo, we will learn how to:

- Package a Helm chart
- Publish a Helm chart to Amazon ECR Private
- Install Helm charts directly from ECR
- Verify deployed resources
- Understand chart versioning and image tag handling
- Add custom release metadata using ConfigMaps

This workflow is commonly used in enterprise CI/CD pipelines where organizations maintain private Helm registries.

---

# Key Topics Covered

- Updating chart metadata (`Chart.yaml`)
- Packaging Helm charts (`.tgz`)
- Publishing charts to Amazon ECR Private
- Installing charts from OCI registries
- Understanding `.Chart.Version`
- Creating release metadata ConfigMaps
- Verifying Helm releases and Kubernetes resources

---

# Pre-requisite Item

## Create Workspace

```bash
mkdir -p charts && cd charts
```

---

## Pull Helm Chart from AWS Public ECR

```bash
helm pull oci://public.ecr.aws/aws-containers/retail-store-sample-ui-chart \
  --version 1.3.0 \
  --untar
```

This downloads and extracts the Helm chart locally.

---

## Verify Extracted Files

```bash
ls -la
```

---

## Rename Folder for Simplicity

```bash
mv retail-store-sample-ui-chart ui
```

---

## Optional: Install tree Utility

### Amazon Linux

```bash
sudo dnf install tree -y
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

# Step-02: Update Chart Metadata

Edit:

```text
ui/Chart.yaml
```

---

## Updated Chart.yaml

```yaml
apiVersion: v2
name: retail-store-sample-ui-chart
description: Retail Store UI Helm Chart
type: application
version: 1.3.1
```

---

# Explanation of Important Fields

| Field | Purpose |
|---|---|
| apiVersion | Helm chart API version |
| name | Chart name |
| description | Chart description |
| type | application or library |
| version | Helm chart version |

---

## Important Note

Always increment the chart version before releasing a new Helm package.

Example:

```text
1.3.0 → 1.3.1
```

This helps:
- Track releases
- Manage upgrades
- Maintain version history

---

# Step-03: Add Release Info ConfigMap

In this step, we create a custom Kubernetes ConfigMap that stores Helm release metadata.

This is useful for:
- Auditing
- Troubleshooting
- Deployment tracking
- Observability

---

## Create New Template File

Create:

```text
templates/release-info.yaml
```

---

## release-info.yaml

```yaml
{{- if .Values.releaseInfo.enabled }}
apiVersion: v1
kind: ConfigMap

metadata:
  name: {{ include "ui.fullname" . }}-release-info

  labels:
    {{- include "ui.labels" . | nindent 4 }}

data:
  chartName: "{{ .Chart.Name }}"
  chartVersion: "{{ .Chart.Version }}"
  appVersion: "{{ .Chart.AppVersion }}"
  releaseName: "{{ .Release.Name }}"
  releaseNamespace: "{{ .Release.Namespace }}"
  releaseRevision: "{{ .Release.Revision }}"
  releaseTime: "{{ now | date "2006-01-02T15:04:05Z07:00" }}"
{{- end }}
```

---

# What This Template Does

This template dynamically creates a ConfigMap containing:
- Chart name
- Chart version
- App version
- Release name
- Namespace
- Revision number
- Deployment timestamp

These values are automatically populated by Helm during deployment.

---

# Add Default Values

Edit:

```text
ui/values.yaml
```

Add:

```yaml
releaseInfo:
  enabled: false
```

---

# Add Override Values

Edit:

```text
retailstore-apps/values-ui.yaml
```

Add:

```yaml
releaseInfo:
  enabled: true
```

---

# Why Use Enabled Flags?

Enabled flags help:
- Conditionally create resources
- Enable/disable features dynamically
- Reuse the same chart across environments

This is a common Helm design pattern.

---

# Step-04: End-to-End Workflow

In this section, we will:
1. Create ECR Private repository
2. Package Helm chart
3. Push Helm chart to ECR

---

# Set Environment Variables

```bash
REGION=us-east-1

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

REGISTRY="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"
```

---

## Verify Variables

```bash
echo $REGION

echo $ACCOUNT_ID

echo $REGISTRY
```

---

# Login to Amazon ECR

```bash
aws ecr get-login-password --region "$REGION" \
| helm registry login -u AWS --password-stdin "$REGISTRY"
```

This authenticates Helm with Amazon ECR OCI registry.

---

# Create ECR Repository

```bash
aws ecr create-repository \
  --repository-name retail-store-sample-ui-chart \
  --region "$REGION" || true
```

---

# Why Use `|| true`?

This prevents failure if:
- Repository already exists

Useful in automation pipelines.

---

# Package Helm Chart

```bash
cd charts

helm package ./ui
```

Expected output:

```text
retail-store-sample-ui-chart-1.3.1.tgz
```

---

# What is `.tgz`?

Helm packages charts into compressed tar archives.

Example:

```text
chart-name-version.tgz
```

This package is what gets published to repositories.

---

# Push Chart to Amazon ECR (OCI Registry)

```bash
helm push retail-store-sample-ui-chart-1.3.1.tgz oci://"$REGISTRY"
```

---

# Important OCI Registry Note

When pushing:
- Push only to registry root
- Do NOT append repository suffix manually

Helm automatically manages OCI repository paths internally.

---

# Verify Chart in ECR

```bash
aws ecr describe-images \
  --repository-name retail-store-sample-ui-chart \
  --region "$REGION" \
  --query 'imageDetails[].imageTags'
```

This confirms:
- Chart package exists
- OCI artifact was uploaded successfully

---

# Step-05: Install Chart from ECR Private

## Install Helm Release

```bash
helm install retail-ui \
  oci://"$REGISTRY"/retail-store-sample-ui-chart \
  --version 1.3.1 \
  -f ../retailstore-apps/values-ui.yaml
```

---

# What Happens During Installation?

Helm:
- Pulls chart from private ECR
- Applies values from `values-ui.yaml`
- Renders templates
- Deploys Kubernetes resources
- Creates release metadata ConfigMap

---

# Upgrade Existing Release

```bash
helm upgrade --install retail-ui \
  oci://"$REGISTRY"/retail-store-sample-ui-chart \
  --version 1.2.5 \
  -f ../retailstore-apps/values-ui.yaml
```

---

# Step-06: Important Note on Deployment & Image Tags

Inside the Deployment template:

```yaml
image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.Version }}"
```

---

# Understanding the Logic

This means:

| Condition | Result |
|---|---|
| image.tag provided | Uses provided tag |
| image.tag missing | Uses `.Chart.Version` |

---

# Why This Matters

If chart version changes:
- Container image version may also change automatically

This can create unexpected deployments if not managed properly.

---

# Best Practice

Always explicitly define:
- `image.repository`
- `image.tag`

inside values files.

---

# Example values-ui.yaml

```yaml
image:
  repository: public.ecr.aws/aws-containers/retail-store-sample-ui
  pullPolicy: IfNotPresent
  tag: 1.3.0
```

---

# Why Explicit Image Tags Are Important

Benefits:
- Predictable deployments
- Safer upgrades
- Easier rollback
- Better CI/CD control

---

# Step-07: Verify Resources

## List Helm Releases

```bash
helm list
```

---

## View Release Resources

```bash
helm status retail-ui --show-resources
```

This displays:
- Deployments
- Services
- Ingress
- ConfigMaps
- Other Helm-managed resources

---

## Verify Pods & Services

```bash
kubectl get pods,svc
```

---

# Verify Release Info ConfigMap

## List ConfigMaps

```bash
kubectl get cm
```

---

## View ConfigMap YAML

```bash
kubectl get cm retail-ui-release-info -o yaml
```

---

## Describe ConfigMap

```bash
kubectl describe cm retail-ui-release-info
```

This helps verify:
- Chart metadata
- Release metadata
- Deployment timestamp
- Revision information

---

# Step-08: Cleanup

## Uninstall Helm Release

```bash
helm uninstall retail-ui
```

This removes:
- Deployments
- Services
- ConfigMaps
- Ingress resources
- Other Helm-managed objects

---

# Step-09: Cleanup ECR Repository (Optional)

To completely remove the Helm chart repository from ECR:

```bash
aws ecr delete-repository \
  --repository-name retail-store-sample-ui-chart \
  --region "$REGION" \
  --force
```

---

# What `--force` Does

This deletes:
- Repository
- All chart versions
- OCI artifacts inside the repository

Use carefully in production environments.