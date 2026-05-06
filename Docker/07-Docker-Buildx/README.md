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


### Solution: How to build Multi-Platform Docker Images?



## Step-02: Host sanity check
```bash
cat /etc/os-release | sed -n '1,6p'     # Amazon Linux 
uname -m                                 # expect: x86_64
```


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


## Step-04: Ensure Buildx/BuildKit is available
```bash
export DOCKER_BUILDKIT=1
docker buildx version
```

## Step-05: Install binfmt/QEMU emulators (cross-arch)
```bash
# Reinstall QEMU binfmt handlers
docker run --privileged --rm tonistiigi/binfmt --install all

# OR explicitly for arm64 + amd64
docker run --privileged --rm tonistiigi/binfmt --install arm64,amd64
```