# Docker Setup and Fundamentals

## Docker Concepts Overview

![Docker Concepts](Screenshots/1.Docker_Concepts.png)

### Understanding the Flow

The Docker workflow consists of three main stages:

1. **Docker Pull & Run**
   - Pull images from Docker Hub
   - Run containers

2. **Docker Image Build Workflow**
   - Create custom images using Dockerfile
   - Build → Run → Push to Docker Hub

3. **Docker Compose**
   - Manage multi-container applications
   - Define services, networks, volumes

---

### Dockerfile Key Instructions

- FROM → Base image
- RUN → Execute commands
- COPY → Copy files
- WORKDIR → Set working directory
- ENV → Environment variables
- EXPOSE → Define ports
- CMD / ENTRYPOINT → Container startup command

---

### Advanced Concepts

- Multi-stage builds → optimized images
- .dockerignore → exclude unnecessary files
- Build stages → build + package separation


---

### Steps Performed

1. Logged into AWS Console
2. Selected **Mumbai region**
3. Navigated to EC2 service
4. Created an EC2 instance:
   - Instance Type: t3.medium
   - Storage: 30 GB
   - OS: Amazon Linux

### EC2 instance created
![EC2](Screenshots/2.EC2_instance_created.png)

---

### Why Docker?

Docker allows us to:
- Run applications in isolated containers
- Ensure consistency across environments
- Simplify deployment process

---

### Steps Performed

```bash
sudo dnf update -y
sudo dnf install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
```

### Docker Installed

![ssh](Screenshots/3.Connected_to_the_instance_using_ssh.png)
![Update_Packages](Screenshots/4.Update_packages.png)
![Install_Docker](Screenshots/5.1.Install_Docker.png)
![Docker_Installed](Screenshots/5.3.Docker_Installed.png)
![Enable_Start_Useradd](Screenshots/6.Enable_Start_useradd_to_docker-group.png)

### Verify Docker installation
```bash
docker version
docker images (shows no images initially)
```

![docker_version](Screenshots/7.test_docker.png)


### Run a test container
```bash
docker run hello-world (no images in local, so it pulls from the docker library)
docker images (new hello-worls image is created)
```

![run_hellow-world](Screenshots/8.Create_hellow-world_image.png)

---

### List and remove containers

```bash
docker ps (lists running containers)
docker ps -a (lists all container running and exited)
docker ps -aq (lists all container ids)
docker rm $(docker ps -aq) --> removes all containers
```

![list and remove docker containers](Screenshots/9.%20list_and_remove_containers.png)

### List and remove images
```bash
docker images --> lists all images
docker images -q --> lists all image ids
docker rmi $(docker images -q)
```

![list and remove docker images](Screenshots/10.%20list_and_remove_images.png)

---






## Author
Ramesh Mahipathi
