# Multi-Arch Docker build on Amazon Linux -> Push to Docker Hub

Create and push a single tag that contains AMD64 + ARM64 images for your Retail Store UI microservice, using Buildx + QEMU on an x86_64 (amd64) EC2 with Amazon Linux VM—and publish to Docker Hub.

## Step-01: What we'll do
1. Host sanity check /
2. Install Docker Engine and enable Buildx /
3. Install binfmt/QEMU for cross-arch builds /
4. Create a containerized Buildx builder (multi-arch) /
5. Log in to Docker Hub /
6. Build & push a multi-platform manifest (linux/amd64,linux/arm64) /
7. Verify manifest and run containers /
8. Access the app in your browser on ports 8888 /

### Problem: How to build Multi-Platform Docker Images?
![multi-platform-docker-image](screenshots/01-Multi-Platform-Docker-Images-Problem.png)

### Solution: How to build Multi-Platform Docker Images?
![solution](screenshots/02-Multi-Platform-Docker-Images-Solution.png)


## Step-02: Host sanity check
```bash
cat /etc/os-release | sed -n '1,6p'     # Amazon Linux 
uname -m                                 # expect: x86_64
```
![host-sanity-check](screenshots/03-host-sanity-check.png)

## Step-03: Install Docker Engine (on Amazon Linux)
```bash
# Install Docker Engine
sudo dnf update -y
sudo dnf install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
docker --version

# Exit and Relogin
exit and relogin

# Run Test container
docker run hello-world
```
![hello-world](screenshots/04-hellow-world.png)

## Step-04: Ensure Buildx/BuildKit is available
```bash
export DOCKER_BUILDKIT=1
docker buildx version
```
![buildx](screenshots/05-buildx-and-qemu.png)

## Step-05: Install binfmt/QEMU emulators (cross-arch)
```bash
# Reinstall QEMU binfmt handlers
docker run --privileged --rm tonistiigi/binfmt --install all

# OR explicitly for arm64 + amd64
docker run --privileged --rm tonistiigi/binfmt --install arm64,amd64
```
![binfit-qemu](screenshots/06-binfit-qemu.png)

## Step-06 Create a containerized Buildx builder (multi-arch capable)
```bash
# Create a new multiarch builder that uses BuildKit in a container
docker buildx create --name multiarch --driver docker-container --use

# Bootstrap to detect all supported platforms
docker buildx inspect --bootstrap

# List Buildx Builders
docker buildx ls
```
![multi-arch builder](screenshots/07-multi-arch.png)

## Step-07: Docker Hub login & variables
```bash
# ---- CONFIG (edit these) ----
export DOCKERHUB_USER="your-dockerhub-username"     # CHANGE
export DH_REPO="retail-ui-multiarch"             # repo name under your namespace
export TAG="1.0.0"                                  # image tag


# UPDATED TO MY ENVIRONMENT
export DOCKERHUB_USER="stacksimplify"     # CHANGE
export DH_REPO="retail-ui-multiarch"             # repo name under your namespace
export TAG="1.0.0"                                  # image tag

# ---- DERIVED ----
export IMAGE="${DOCKERHUB_USER}/${DH_REPO}:${TAG}"
echo $IMAGE

# Login to Docker Hub (will prompt for password or PAT)
docker login -u "${DOCKERHUB_USER}"
```
![docker-hub-login](screenshots/08-multi-arch-image.png)

## Step-08 Download Retail-store repo and Dockerfile
```bash
# Create a Folder
mkdir demo-multiarch
cd demo-multiarch

# Download the Application Source
wget https://github.com/aws-containers/retail-store-sample-app/archive/refs/tags/v1.3.0.zip

# Unzip Application Source
unzip v1.3.0.zip

# Change Directory to UI Source folder
cd retail-store-sample-app-1.3.0/src/ui
cat Dockerfile
```
![repo-and-dockerfile](screenshots/09-download-repo-and-dockerfile.png)

## Step-09: Build & push multi-platform image (AMD64 + ARM64)
```bash
DOCKER_BUILDKIT=1 docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t "${IMAGE}" \
  --push .
```


## Step-10: Verify the pushed manifest
```bash
docker buildx imagetools inspect "${IMAGE}"
# Look for entries for linux/amd64 and linux/arm64
```


## AMD64: Run and test the containers
```bash
# List Docker Containers
docker ps

# Run Docker Container using new Docker Image 
docker run --name myapp1-amd64 -p 8888:8080 -d ${IMAGE}

# List Docker Images
docker images

# List Docker Containers
docker ps

# Access in browser
http://<EC2-Public-IP>:8888
```

---
## Author
Ramesh Mahipathi