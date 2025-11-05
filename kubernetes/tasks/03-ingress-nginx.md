# Task 3: Advanced Routing with Ingress

## Objective
Understand how to manage external access to services in a Kubernetes cluster using an Ingress Controller. This guide provides an overview of different controllers and then dives deep into practical examples using the popular NGINX Ingress Controller.

---

## Part 1: What is an Ingress Controller?

An Ingress Controller is a component in the cluster that is responsible for managing external access to the services, typically for HTTP(S) traffic. It reads the `Ingress` resource definitions you create and configures an underlying proxy (like NGINX or Envoy) to route traffic accordingly.

While Kubernetes supports many Ingress Controllers, some of the most popular are:

| **Controller** | **Key Features** | **Best For** |
| :--- | :--- | :--- |
| **NGINX** | Most widely used, feature-rich, extensive documentation. | Standard web applications and general-purpose routing. |
| **Traefik** | Automatic service discovery, modern UI, Let's Encrypt integration. | Microservices and dynamic environments. |
| **Istio (Gateway)** | Part of a service mesh, provides advanced traffic management, security, and observability. | Complex microservices, security-focused applications. |
| **Contour** | Uses the Envoy proxy, high-performance, and lightweight. | High-performance applications, environments using Envoy. |

---

## Part 2: Practical Examples with the NGINX Ingress Controller

The NGINX Ingress Controller uses Kubernetes annotations on the `Ingress` resource to unlock powerful routing capabilities. Below are common scenarios and their configurations.

### 1. Basic Path-Based Routing
*   **Scenario:** Route requests to different services based on the URL path (e.g., `/api` for the backend and `/` for the frontend).
*   **Example:**
    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: basic-routing-ingress
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /$2
    spec:
      rules:
      - host: myapp.example.com
        http:
          paths:
          - path: /api(/|$)(.*)
            pathType: Prefix
            backend:
              service:
                name: backend-api-service
                port:
                  number: 80
          - path: /(|/)(.*)
            pathType: Prefix
            backend:
              service:
                name: frontend-ui-service
                port:
                  number: 80
    ```

### 2. Host-Based Routing (Virtual Hosting)
*   **Scenario:** Route traffic based on the domain name (e.g., `api.example.com` and `www.example.com`).
*   **Example:**
    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: domain-based-routing
    spec:
      rules:
      - host: api.example.com
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: api-service
                port:
                  number: 80
      - host: www.example.com
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend-service
                port:
                  number: 80
    ```

### 3. TLS Termination
*   **Scenario:** Secure your Ingress with a TLS certificate and redirect all HTTP traffic to HTTPS.
*   **Example:**
    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: tls-example
      annotations:
        nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    spec:
      tls:
      - hosts:
          - myapp.example.com
        secretName: myapp-tls-secret # This secret contains your TLS cert and key
      rules:
      - host: myapp.example.com
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: app-service
                port:
                  number: 80
    ```

### 4. Rate Limiting
*   **Scenario:** Protect a service from abuse by limiting the number of requests per second from a single IP.
*   **Example:**
    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: rate-limit-example
      annotations:
        nginx.ingress.kubernetes.io/limit-rps: "10" # Requests per second
        nginx.ingress.kubernetes.io/limit-burst-multiplier: "2"
    spec:
      rules:
      - host: myapp.example.com
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: app-service
                port:
                  number: 80
    ```

### 5. Canary Releases (Traffic Splitting)
*   **Scenario:** Route a small percentage of traffic (e.g., 10%) to a new version of your application (`canary-service`) while the majority of traffic goes to the stable version.
*   **Example:**
    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: canary-release-ingress
      annotations:
        nginx.ingress.kubernetes.io/canary: "true"
        nginx.ingress.kubernetes.io/canary-weight: "10" # 10% of traffic
    spec:
      rules:
      - host: myapp.example.com
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: stable-app-service # The main service gets 90%
                port:
                  number: 80
    ---
    # A separate Ingress is needed for the canary service
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: main-ingress
    spec:
      rules:
      - host: myapp.example.com
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: canary-app-service # The canary service gets 10%
                port:
                  number: 80
    ```

### 6. Basic Authentication
*   **Scenario:** Protect an endpoint (e.g., `/admin`) with a username and password.
*   **Example:**
    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: auth-example
      annotations:
        nginx.ingress.kubernetes.io/auth-type: "basic"
        nginx.ingress.kubernetes.io/auth-secret: "basic-auth-secret" # A secret containing user:password
        nginx.ingress.kubernetes.io/auth-realm: "Authentication Required"
    spec:
      rules:
      - host: myapp.example.com
        http:
          paths:
          - path: /admin
            pathType: Prefix
            backend:
              service:
                name: admin-service
                port:
                  number: 80
    ```