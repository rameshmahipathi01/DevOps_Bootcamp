# Day 01 - Project Overview & Microservices Architecture

## Course
**Ultimate DevOps Real-World Project Implementation (AWS)**  
Instructor: Kalyan Reddy Daida 

---

## Objective of Day 01
- Understand the real-world project we will build
- Understand the Project overview, architecture, tools used and project flow
- Explore applications components and dependencies
- Get familiar with course repositories and resources

---

## Project Overview

The project is a **Retail Store Sample Application**, designed as a **real-world cloud-native microservices system**.

---

### Key Highlights:
- Full-stack e-commerce application
- Built using multiple programming languages:
  - Java (Spring Boot)
  - Node.js
  - Go
- Designed using **microservices architecture**
- Production-grade design with real-world patterns

---

##  Microservices Architecture
The application consists of **10 containers**, including:

### Microservices (5 Services)
- Catalog Service (Go)
- Cart Service (Java Spring Boot)
- Checkout Service (Node.js)
- Orders Service (Java Spring Boot)
- UI Service (Java Spring Boot)


### 🗄️ Databases (3)
- MySQL / MariaDB (Relational DB)
- PostgreSQL (Relational DB)
- DynamoDB (NoSQL)


### ⚡ Caching Layer (1)
- Redis


### 📩 Messaging System (1)
- RabbitMQ / AWS SQS


---


## Architecture Understanding

### Component Flow
- User interacts with **UI Service**
- UI communicates with backend microservices via APIs
- Each microservice:
  - Handles specific business logic
  - Communicates with its own database
- Services interact with:
  - Redis (caching)
  - Messaging system (async communication)

---


## Why This Project?

This project is designed for real-world DevOps learning:

- Multi-language microservices architecture
- Integration with databases, cache, and messaging
- Ready for:
  - Docker
  - Kubernetes
  - CI/CD pipelines
- Production-like complexity and tools covered


---

## Technologies Covered

### Cloud & Containers
- AWS (EKS, VPC, IAM)
- Docker
- Kubernetes

### Infrastructure as Code
- Terraform
- Helm

### CI/CD & GitOps
- GitHub Actions
- ArgoCD

### Observability
- Prometheus & Grafana
- AWS X-Ray


---

## Important Repositories

- Main Course Repo  
  https://github.com/stacksimplify/devops-real-world-project-implementation-on-aws  

- Retail Store Application  
  https://github.com/stacksimplify/retail-store-sample-app-aws  

- CI/CD Repository  
  https://github.com/stacksimplify/aws-devops-github-actions-ecr-argocd3  

- Course Images  
  https://stacksimplify.github.io/course-image-previews/courses/aws-devops  


---


## Author
Ramesh Mahipathi

