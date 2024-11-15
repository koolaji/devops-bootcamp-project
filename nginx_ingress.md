1. Basic Routing and Path-Based Routing
Scenario: Route requests to different services based on URL paths, such as /api for a backend API and /frontend for a frontend UI.

Example:

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: basic-routing
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
      - path: /frontend
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
Explanation: This Ingress routes requests sent to example.com/api to api-service and those sent to example.com/frontend to frontend-service.

2. Domain-Based Routing (Virtual Hosting)
Scenario: Route traffic based on subdomains like api.example.com and www.example.com.

Example:
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
Explanation: Requests sent to api.example.com are routed to api-service, while those sent to www.example.com are routed to frontend-service.

3. TLS Termination and Redirects
Scenario: Secure the Ingress with TLS and redirect HTTP traffic to HTTPS.

Example:
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-example
  annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  tls:
  - hosts:
      - example.com
    secretName: example-tls
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
Explanation: This configuration enables HTTPS for example.com using the example-tls certificate and forces redirection from HTTP to HTTPS.

4. Rate Limiting
Scenario: Apply rate limiting, e.g., 10 requests per second per IP, to prevent abuse.

Example:
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rate-limit-example
  annotations:
    nginx.ingress.kubernetes.io/limit-rps: "10"
    nginx.ingress.kubernetes.io/limit-burst-multiplier: "2"
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
Explanation: Limits each client to 10 requests per second. The limit-burst-multiplier of 2 allows short bursts to exceed this rate.

5. Load Balancing and Weighted Traffic Splitting (Canary Releases)
Scenario: Route 90% of traffic to app-service and 10% to canary-service.

Example:
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: canary-release
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "10"
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80

Explanation: This configuration routes 90% of the traffic to app-service and 10% to canary-service for canary testing.

6. Basic Authentication
Scenario: Protect a specific endpoint with basic authentication.

Example:
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: auth-example
  annotations:
    nginx.ingress.kubernetes.io/auth-type: "basic"
    nginx.ingress.kubernetes.io/auth-secret: "basic-auth"
    nginx.ingress.kubernetes.io/auth-realm: "Authentication Required"
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /admin
        pathType: Prefix
        backend:
          service:
            name: admin-service
            port:
              number: 80
Explanation: Requests to example.com/admin require basic authentication using credentials stored in a Kubernetes secret named basic-auth.

7. Configuring Cross-Origin Resource Sharing (CORS)
Scenario: Allow requests from https://otherdomain.com to access resources on /api.

Example:
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: cors-example
  annotations:
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: "https://otherdomain.com"
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
Explanation: Allows requests from https://otherdomain.com to example.com/api to bypass CORS restrictions.

8. Custom Error Pages
Scenario: Redirect users to a custom 404 error page.

Example:
apiVersion: networking.k8s.io/v1
kind: ConfigMap
metadata:
  name: nginx-configuration
  namespace: ingress-nginx
data:
  custom-http-errors: "404,503"
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: custom-error-page
  annotations:
    nginx.ingress.kubernetes.io/default-backend: "error-backend"
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: main-service
            port:
              number: 80
---
apiVersion: v1
kind: Service
metadata:
  name: error-backend
spec:
  ports:
    - protocol: TCP
      port: 80
  selector:
    app: error-page
Explanation: This example redirects users to a custom service, error-backend, which provides a custom error page for 404 errors.

