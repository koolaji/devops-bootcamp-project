1. HAProxy Load Balancer YAML
This example shows HAProxy deployed in Kubernetes, configured to load balance across multiple backend services.
```yaml
# Deploy HAProxy as a load balancer
apiVersion: apps/v1
kind: Deployment
metadata:
  name: haproxy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: haproxy
  template:
    metadata:
      labels:
        app: haproxy
    spec:
      containers:
      - name: haproxy
        image: haproxy:2.4
        ports:
          - containerPort: 80
        volumeMounts:
          - name: haproxy-config
            mountPath: /usr/local/etc/haproxy/haproxy.cfg
            subPath: haproxy.cfg
      volumes:
      - name: haproxy-config
        configMap:
          name: haproxy-config
---
# ConfigMap for HAProxy configuration
apiVersion: v1
kind: ConfigMap
metadata:
  name: haproxy-config
data:
  haproxy.cfg: |
    frontend http_front
        bind *:80
        default_backend app_backend

    backend app_backend
        balance roundrobin
        server app1 <POD_IP_1>:8080 check
        server app2 <POD_IP_2>:8080 check
---
# LoadBalancer Service to expose HAProxy externally
apiVersion: v1
kind: Service
metadata:
  name: haproxy-service
spec:
  type: LoadBalancer
  selector:
    app: haproxy
  ports:
    - port: 80
      targetPort: 80
```
Architecture:

HAProxy acts as a load balancer that can be deployed on Kubernetes clusters to handle traffic distribution for backend services.
It uses a frontend-backend model where the frontend listens for incoming requests and routes them to backend servers, which can be Kubernetes pods or services.
HAProxy ConfigMap stores configuration details, enabling dynamic configuration changes without redeploying the HAProxy container.
YAML Explanation:

haproxy-deployment.yaml:
Deployment creates a single HAProxy pod using the haproxy:2.4 image.
ConfigMap (defined separately) specifies the HAProxy configuration, detailing frontend and backend configurations for balancing traffic.
Service of type LoadBalancer exposes HAProxy, allowing external traffic to reach HAProxy and, in turn, the application pods.

2. MetalLB for Bare-Metal Load Balancing
For Kubernetes on bare metal, MetalLB provides a network load balancing solution. Here’s how to set up MetalLB and configure a LoadBalancer service.
```yaml
# Install MetalLB in the metallb-system namespace
apiVersion: v1
kind: Namespace
metadata:
  name: metallb-system
---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: metallb-system
  name: controller
spec:
  replicas: 1
  selector:
    matchLabels:
      component: controller
  template:
    metadata:
      labels:
        component: controller
    spec:
      containers:
      - name: controller
        image: metallb/controller:v0.9.3
---
# Define IP pool for MetalLB
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example-address-pool
  namespace: metallb-system
spec:
  addresses:
    - 192.168.1.240-192.168.1.250  # IP range for external services
---
# Layer 2 Advertisement
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
---
# Define a LoadBalancer service to use MetalLB
apiVersion: v1
kind: Service
metadata:
  name: metallb-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
```

Architecture:

MetalLB enables load balancing in bare-metal or self-hosted environments by assigning external IPs to services.
In Layer 2 Mode, MetalLB announces service IPs via ARP within the network, making the service externally accessible.
IP Address Pool: MetalLB assigns IP addresses from a specified pool, making it ideal for environments lacking cloud-native load balancers.
YAML Explanation:

metallb-config.yaml:
Namespace and Deployment: Deploys MetalLB in the metallb-system namespace.
IPAddressPool defines the range of IP addresses MetalLB can use to allocate to LoadBalancer services.
L2Advertisement configures MetalLB in Layer 2 mode.
Service configuration (type: LoadBalancer) enables MetalLB to assign an IP to the service, making it accessible externally.

3. AWS ALB Ingress Controller
This setup demonstrates AWS ALB as a layer 7 load balancer, handling HTTP/HTTPS requests. It includes an Ingress resource with annotations for the AWS Load Balancer Controller.
```yaml
# Install AWS Load Balancer Controller in the kube-system namespace
apiVersion: v1
kind: Namespace
metadata:
  name: kube-system
---
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: kube-system
  name: aws-load-balancer-controller
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: aws-load-balancer-controller
  template:
    metadata:
      labels:
        app.kubernetes.io/name: aws-load-balancer-controller
    spec:
      containers:
      - name: aws-load-balancer-controller
        image: amazon/aws-alb-ingress-controller:v2.2.0
---
# Define an Ingress resource to use with ALB
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: alb-ingress
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing  # Public-facing ALB
    alb.ingress.kubernetes.io/target-type: ip          # Target pods directly
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: example-service
            port:
              number: 80
```
Architecture:

AWS ALB provides a managed load-balancing solution for Kubernetes, ideal for HTTP/HTTPS (layer 7) routing.
AWS Load Balancer Controller: This controller dynamically provisions ALBs based on Kubernetes Ingress resources, simplifying routing for applications deployed in AWS.
Target Groups: ALB forwards traffic to specific pods within target groups, managing health checks and scaling.
YAML Explanation:

alb-ingress.yaml:
Ingress defines the routing rules and annotations to create an ALB.
Annotations:
alb.ingress.kubernetes.io/scheme: internet-facing specifies an ALB accessible over the Internet.
alb.ingress.kubernetes.io/target-type: ip directs traffic to individual pod IPs.
Listener ports (HTTP 80 and HTTPS 443) define the entry points for incoming traffic
