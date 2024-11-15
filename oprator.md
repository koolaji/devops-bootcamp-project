# Famous Kubernetes Operators with Sample Usage

---

### 1. **Prometheus Operator**

The **Prometheus Operator** makes it easier to deploy and manage Prometheus instances and related components (like Alertmanager) in Kubernetes.

#### Key Features:
- **Custom Resources**: Defines resources like `Prometheus`, `PrometheusRule`, and `Alertmanager`.
- **Self-healing**: Ensures Prometheus instances and related components are always running as expected.
- **Upgrades**: Simplifies the upgrade process for Prometheus.

#### Sample Usage:
```yaml
## Prometheus Operator in Kubernetes

### Overview:
The Prometheus Operator helps manage Prometheus instances in Kubernetes. It ensures that Prometheus is automatically configured, scaled, and maintained based on the CRDs.

### Example YAML to Deploy Prometheus:
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: prometheus
spec:
  replicas: 2
  serviceAccountName: prometheus
  resources:
    requests:
      memory: "400Mi"
      cpu: "500m"
    limits:
      memory: "1Gi"
      cpu: "1"
```
For more details, refer to the [Prometheus Operator Documentation](https://github.com/prometheus-operator/prometheus-operator).

---

### 2. **Cert-Manager Operator**

The **Cert-Manager Operator** automates the management and issuance of TLS certificates in Kubernetes, integrating with multiple certificate authorities.

#### Key Features:
- **Certificate Management**: Automates the creation, renewal, and management of certificates.
- **Integrates with multiple CA**: Works with Let's Encrypt, HashiCorp Vault, and others.
- **Self-healing**: Ensures certificates are renewed before expiry.

#### Sample Usage:
```yaml
## Cert-Manager Operator in Kubernetes

### Overview:
The Cert-Manager Operator automates the lifecycle of TLS certificates in Kubernetes, including issuing, renewing, and storing them securely.

### Example YAML to Deploy Cert-Manager:
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-cert
spec:
  secretName: example-cert-tls
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  dnsNames:
    - example.com
    - www.example.com
```
For more details, refer to the [Cert-Manager Documentation](https://cert-manager.io/docs/).

---

### 3. **MongoDB Operator**

The **MongoDB Operator** simplifies the management of MongoDB clusters in Kubernetes, handling operations such as backups, scaling, and upgrades.

#### Key Features:
- **Custom Resources**: Defines resources like `MongoDB`, `MongoDBUser`, and `MongoDBBackup`.
- **Self-healing**: Ensures MongoDB clusters are always in a healthy state.
- **Backup and Restore**: Provides automated backups and restores for MongoDB.

#### Sample Usage:
```yaml
## MongoDB Operator in Kubernetes

### Overview:
The MongoDB Operator helps manage MongoDB clusters in Kubernetes. It simplifies database operations such as scaling, backups, and upgrades.

### Example YAML to Deploy MongoDB:
apiVersion: mongodb.com/v1
kind: MongoDB
metadata:
  name: my-mongo-cluster
spec:
  members: 3
  type: ReplicaSet
  version: 4.2.8
  statefulSet:
    spec:
      template:
        spec:
          containers:
            - name: mongo
              image: mongo:4.2.8
              ports:
                - containerPort: 27017
```
For more details, refer to the [MongoDB Operator Documentation](https://github.com/mongodb/mongodb-kubernetes-operator).

---

### 4. **Kong Ingress Controller Operator**

The **Kong Ingress Controller Operator** is a Kubernetes operator that manages the Kong Ingress Controller in Kubernetes clusters. It integrates with Kubernetes' native Ingress resources, providing API Gateway capabilities.

#### Key Features:
- **API Gateway**: Exposes services and APIs securely to external clients.
- **Custom Resources**: Defines resources like `KongIngress`, `KongConsumer`, and `KongPlugin`.
- **Load Balancing**: Provides advanced traffic routing and load balancing.

#### Sample Usage:
```yaml
## Kong Ingress Controller Operator in Kubernetes

### Overview:
The Kong Ingress Controller Operator manages the Kong Ingress Controller deployment and configures API Gateway functionalities.

### Example YAML to Deploy Kong Ingress Controller:
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kong-ingress-controller
spec:
  replicas: 2
  selector:
    matchLabels:
      app: kong
  template:
    metadata:
      labels:
        app: kong
    spec:
      containers:
        - name: kong
          image: kong/kubernetes-ingress-controller:latest
          ports:
            - containerPort: 8000
            - containerPort: 8443
```
For more details, refer to the [Kong Ingress Controller Documentation](https://docs.konghq.com/kubernetes-ingress-controller/latest/).

---

### 5. **Elasticsearch Operator**

The **Elasticsearch Operator** automates the deployment and management of Elasticsearch clusters in Kubernetes. It simplifies tasks such as scaling, backups, and upgrades.

#### Key Features:
- **Custom Resources**: Defines resources like `Elasticsearch`, `ElasticsearchCluster`, and `ElasticsearchSnapshot`.
- **Scaling**: Easily scale Elasticsearch nodes based on demand.
- **Backups**: Automates backup and recovery of Elasticsearch data.

#### Sample Usage:
```yaml
## Elasticsearch Operator in Kubernetes

### Overview:
The Elasticsearch Operator helps deploy and manage Elasticsearch clusters with built-in scaling and backup capabilities.

### Example YAML to Deploy Elasticsearch:
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: my-elasticsearch
spec:
  version: 7.10.0
  nodeSets:
    - name: default
      count: 3
      config:
        node.store.allow_mmap: false
      podTemplate:
        spec:
          containers:
            - name: elasticsearch
              image: docker.elastic.co/elasticsearch/elasticsearch:7.10.0
              resources:
                requests:
                  memory: "2Gi"
                  cpu: "1"
                limits:
                  memory: "4Gi"
                  cpu: "2"
```
For more details, refer to the [Elasticsearch Operator Documentation](https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html).

---

### 6. **ArgoCD Operator**

The **ArgoCD Operator** automates the management of ArgoCD instances in Kubernetes. ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes.

#### Key Features:
- **GitOps**: Syncs Kubernetes resources with Git repositories.
- **Custom Resources**: Defines resources like `Application` and `ApplicationSet`.
- **Automatic Syncing**: Continuously synchronizes the deployed resources with the desired state in Git.

#### Sample Usage:
```yaml
## ArgoCD Operator in Kubernetes

### Overview:
The ArgoCD Operator simplifies the deployment and management of ArgoCD instances and applications in Kubernetes.

### Example YAML to Deploy ArgoCD:
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
spec:
  project: default
  source:
    repoURL: 'https://github.com/my-org/my-app'
    targetRevision: HEAD
    path: kubernetes
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```
For more details, refer to the [ArgoCD Documentation](https://argo-cd.readthedocs.io/).
