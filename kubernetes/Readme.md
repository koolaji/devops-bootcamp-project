# Kubernetes: From Concepts to Deployment

Welcome to the Kubernetes module! This guide provides a structured path to understanding the core components of Kubernetes, focusing on networking, storage, and application deployment patterns.

## Curriculum

### 1. Kubernetes Networking Fundamentals
*   **Objective:** Understand the fundamental networking model in Kubernetes, including Pod-to-Pod and Service communication.
*   **[Go to Task 1](./tasks/01-networking-concepts.md)**

### 2. Exposing Applications: Services
*   **Objective:** Learn how to expose your applications within the cluster and to the outside world using different types of Services, including ClusterIP, NodePort, and LoadBalancer.
*   **[Go to Task 2](./tasks/02-services-loadbalancer.md)**

### 3. Advanced Routing: Ingress & NGINX Ingress Controller
*   **Objective:** Manage external access to services in a cluster using Ingress. This task covers the setup and configuration of the NGINX Ingress Controller.
*   **[Go to Task 3](./tasks/03-ingress-nginx.md)**

### 4. Persistent Storage: CSI
*   **Objective:** Understand how Kubernetes handles persistent storage for stateful applications using the Container Storage Interface (CSI).
*   **[Go to Task 4](./tasks/04-storage-csi.md)**

### 5. Advanced Traffic Management: API Gateways
*   **Objective:** Explore the role of API Gateways in a Kubernetes environment for managing, securing, and observing API traffic.
*   **[Go to Task 5](./tasks/05-api-gateways.md)**

### 6. Automation & Extensibility: The Operator Pattern
*   **Objective:** Learn about the Operator pattern, which allows you to extend Kubernetes' capabilities to manage complex, stateful applications automatically.
*   **[Go to Task 6](./tasks/06-operators.md)**

---

## Homework Assignment
After completing all the tasks, you will be ready for the final homework assignment. This project will challenge you to deploy a multi-tier application and expose it correctly using the concepts you've learned.

*   **[Go to Homework](./homework/assignment.md)**

## Prerequisites
*   Access to a Kubernetes cluster (e.g., Minikube, Kind, or a cloud-provided cluster).
*   `kubectl` installed and configured to connect to your cluster.
*   Basic understanding of Docker and containerization concepts.
