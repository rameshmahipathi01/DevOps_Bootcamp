# Docker Setup

## Create EC2 instance

1. Login to AWS account
2. Select Mumbai region
3. Go to EC2 instances
4. Create EC2 instance with t3.medium size and 30 GB volume

### EC2 instance created
![EC2](Screenshots/2.EC2_instance_created.png)

---

## Install Docker on EC2 instance

Steps:
1. Connect to the EC2 instance using SSH
2. sudo dnf update -y
3. sudo dnf install docker -y
4. sudo systemctl enable docker
5. sudo systemctl start docker
6. sudo usermod -aG docker ec2-user

### Docker Installed

![ssh](Screenshots/3.Connected_to_the_instance_using_ssh.png)
![Update_Packages](Screenshots/4.Update_packages.png)
![Install_Docker](Screenshots/5.1.Install_Docker.png)
![Docker_Installed](Screenshots/5.3.Docker_Installed.png)
![Enable_Start_Useradd](Screenshots/6.Enable_Start_useradd_to_docker-group.png)

### Test Docker

docker version
docker images (shows no images initially)
![docker_version](Screenshots/7.test_docker.png)


#### Run a test container
docker run hello-world (no images in local, so it pulls from the docker library)
docker images (new hello-worls image is created)

![run_hellow-world](Screenshots/8.Create_hellow-world_image.png)





## Author
Ramesh Mahipathi
