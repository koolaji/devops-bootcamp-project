1. Basic Routing and Path-Based Routing
Scenario: Route requests to different services based on URL paths, such as /api for a backend API and /frontend for a frontend UI.

Example:
```yaml
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
```
Explanation: This Ingress routes requests sent to example.com/api to api-service and those sent to example.com/frontend to frontend-service.

2. Domain-Based Routing (Virtual Hosting)
Scenario: Route traffic based on subdomains like api.example.com and www.example.com.

Example:
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
Explanation: Requests sent to api.example.com are routed to api-service, while those sent to www.example.com are routed to frontend-service.

3. TLS Termination and Redirects
Scenario: Secure the Ingress with TLS and redirect HTTP traffic to HTTPS.

Example:
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
```
Explanation: This configuration enables HTTPS for example.com using the example-tls certificate and forces redirection from HTTP to HTTPS.

4. Rate Limiting
Scenario: Apply rate limiting, e.g., 10 requests per second per IP, to prevent abuse.

Example:
```yaml
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
```
Explanation: Limits each client to 10 requests per second. The limit-burst-multiplier of 2 allows short bursts to exceed this rate.

5. Load Balancing and Weighted Traffic Splitting (Canary Releases)
Scenario: Route 90% of traffic to app-service and 10% to canary-service.

Example:
```yaml
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
```
Explanation: This configuration routes 90% of the traffic to app-service and 10% to canary-service for canary testing.

6. Basic Authentication
Scenario: Protect a specific endpoint with basic authentication.

Example:
```yaml
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
```
Explanation: Requests to example.com/admin require basic authentication using credentials stored in a Kubernetes secret named basic-auth.

7. Configuring Cross-Origin Resource Sharing (CORS)
Scenario: Allow requests from https://otherdomain.com to access resources on /api.

Example:
```yaml
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
```
Explanation: Allows requests from https://otherdomain.com to example.com/api to bypass CORS restrictions.

8. Custom Error Pages
Scenario: Redirect users to a custom 404 error page.

Example:
```yaml
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
```
Explanation: This example redirects users to a custom service, error-backend, which provides a custom error page for 404 errors.

9.MinIO as a CDN Cache
Scenario: Use MinIO as a backend for static asset caching. Nginx will cache content served by MinIO and deliver it directly to clients on subsequent requests.

Setup Overview:

MinIO will act as the object storage for static files.
Nginx Ingress will route requests and cache static content for faster delivery.
Cache control settings are configured to control cache duration.
Example Configuration:

MinIO Deployment (if not already deployed)
Deploy MinIO to store static assets.
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minio-cdn-cache
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/proxy-cache: "true"
    nginx.ingress.kubernetes.io/proxy-cache-key: "$scheme$request_method$host$request_uri"
    nginx.ingress.kubernetes.io/proxy-cache-valid: "200 1h"  # Cache successful responses for 1 hour
    nginx.ingress.kubernetes.io/proxy-cache-valid: "404 1m"  # Cache 404 responses for 1 minute
    nginx.ingress.kubernetes.io/proxy-hide-headers: "X-Accel-Expires"
spec:
  rules:
  - host: cdn.example.com
    http:
      paths:
      - path: /assets
        pathType: Prefix
        backend:
          service:
            name: minio-service
            port:
              number: 9000
````
10. Keycloak Authentication for Securing Access
Scenario: Secure a specific endpoint with Keycloak as an OpenID Connect provider for authentication.

Example:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: keycloak-auth-ingress
  annotations:
    nginx.ingress.kubernetes.io/auth-url: "https://keycloak.example.com/auth/realms/myrealm/protocol/openid-connect/auth"
    nginx.ingress.kubernetes.io/auth-response-headers: "Authorization"
    nginx.ingress.kubernetes.io/auth-signin: "https://keycloak.example.com/auth/realms/myrealm/protocol/openid-connect/auth"
    nginx.ingress.kubernetes.io/auth-method: "GET"
spec:
  rules:
  - host: secure.example.com
    http:
      paths:
      - path: /secure
        pathType: Prefix
        backend:
          service:
            name: secure-service
            port:
              number: 80
```
Explanation: This example sets up Keycloak as an external OpenID Connect provider for authenticating access to secure.example.com/secure. Users are redirected to Keycloak for authentication before accessing the backend service.

11. WebSocket Support
Scenario: Enable WebSocket communication for a service, which is essential for applications requiring real-time updates, like chat or live data feeds.

Example:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: websocket-ingress
  annotations:
    nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
    nginx.ingress.kubernetes.io/enable-websocket: "true"
spec:
  rules:
  - host: websocket.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: websocket-service
            port:
              number: 8080
```
Explanation: This configuration enables WebSocket support by setting timeouts and enabling WebSocket handling at the Nginx Ingress level.
12. Custom Nginx Configuration Using ConfigMap
Scenario: Apply custom Nginx settings, such as modifying client body size or timeout values, for specific services.

Example:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-configuration
  namespace: ingress-nginx
data:
  proxy-body-size: "10m"         # Max upload size
  client-max-body-size: "10m"
  proxy-connect-timeout: "30"    # Connection timeout
  proxy-read-timeout: "30"       # Read timeout
```
13. Enabling Access Logs for Specific Paths
Scenario: Enable detailed access logging for monitoring traffic on specific endpoints or services.

Example:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: access-log-example
  annotations:
    nginx.ingress.kubernetes.io/enable-access-log: "true"
spec:
  rules:
  - host: logging.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: log-service
            port:
              number: 80
```
Explanation: By enabling enable-access-log, the Nginx Ingress logs requests for this service, which is helpful for auditing and debugging traffic patterns.

14. Rewrite URL Paths
Scenario: Modify incoming URLs to a backend-friendly format before reaching the service, useful for legacy apps or backend requirements.

Example:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rewrite-path-example
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: "/new-path"
spec:
  rules:
  - host: rewrite.example.com
    http:
      paths:
      - path: /old-path
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
```
Explanation: Requests to rewrite.example.com/old-path are rewritten as rewrite.example.com/new-path before reaching the backend, which allows legacy URLs to be supported transparently.
