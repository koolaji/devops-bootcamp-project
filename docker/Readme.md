# Docker & Containerization: A Practical Guide

Welcome to the Docker module! This guide is designed to take you from the fundamental concepts of containerization to deploying a multi-service application using Docker Compose.

This module is divided into several sections, each with specific tasks. It is recommended to follow them in order.

## Curriculum

### 1. Core Concepts
*   **Objective:** Understand the building blocks of Docker.
*   **Tasks:** Learn about images, containers, and the container lifecycle.
*   **[Go to Task 1](./tasks/01-core-concepts.md)**

### 2. Container Isolation: Namespaces & Cgroups
*   **Objective:** Explore how Docker uses Linux namespaces and Control Groups (cgroups) to achieve container isolation and resource management.
*   **Tasks:** Hands-on exercises for PID, Network, Mount, and other namespaces.
*   **[Go to Task 2](./tasks/02-isolation.md)**

### 3. Docker Storage: Images, Layers, and Volumes
*   **Objective:** Understand how Docker manages data.
*   **Tasks:** Investigate the Copy-on-Write (CoW) mechanism and learn how to persist data using volumes.
*   **[Go to Task 3](./tasks/03-storage.md)**

### 4. Docker Networking
*   **Objective:** Learn how containers communicate with each other and the outside world.
*   **Tasks:** Create and manage Docker networks and connect containers.
*   **[Go to Task 4](./tasks/04-networking.md)**

### 5. Building Images: The Dockerfile
*   **Objective:** Learn how to write your own Dockerfiles to create custom images.
*   **Tasks:** Write Dockerfiles for the frontend and backend applications, and learn best practices for caching and image size.
*   **[Go to Task 5](./tasks/05-dockerfile.md)**

### 6. Multi-Service Applications with Docker Compose
*   **Objective:** Learn how to define, run, and manage multi-container Docker applications.
*   **Tasks:** Analyze the provided `docker-compose.yaml`, understand how the services interact, and deploy the entire application stack.
*   **[Go to Task 6](./tasks/06-docker-compose.md)**

---

## Homework Assignment
After completing all the tasks, you will be ready to tackle the final homework assignment. This project will challenge you to apply everything you've learned to extend and debug the multi-service application.

*   **[Go to Homework](./homework/assignment.md)**

## Prerequisites
*   A working installation of Docker and Docker Compose.
*   Basic familiarity with the command line.