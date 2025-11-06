# Kubernetes Homework Assignment

## Objective
Deploy a multi-tier web application on Kubernetes and expose it to the internet using an Ingress. This will test your understanding of Deployments, Services, and Ingress resources.

---

## The Application: "Podinfo"

For this assignment, you will use `podinfo`, a popular, lightweight web application made for Kubernetes demonstrations. It has two components:

*   **`frontend`:** The web UI.
*   **`backend`:** An API that the frontend communicates with.

You will deploy both components and route traffic to them using a single hostname.

---

## Your Tasks

### 1. Create a Namespace
*   Create a new namespace for this project called `homework`. All subsequent resources should be created in this namespace.

### 2. Deploy the Backend
*   Create a Kubernetes `Deployment` for the backend.
    *   Name: `backend-deployment`
    *   Image: `stefanprodan/podinfo`
    *   Replicas: `2`
*   Create a `ClusterIP` Service to expose the backend deployment within the cluster.
    *   Name: `backend-service`
    *   Target Port: `9898` (the port `podinfo` listens on)

### 3. Deploy the Frontend
*   Create a Kubernetes `Deployment` for the frontend.
    *   Name: `frontend-deployment`
    *   Image: `stefanprodan/podinfo`
    *   Replicas: `2`
    *   **Important:** You need to tell the frontend where to find the backend. Set the following environment variable in the Deployment spec:
        *   Name: `PODINFO_UI_API`
        *   Value: `http://backend-service:9898`
*   Create a `ClusterIP` Service to expose the frontend deployment.
    *   Name: `frontend-service`
    *   Target Port: `9898`

### 4. Create an Ingress
*   Create an `Ingress` resource to route external traffic to your services.
    *   Name: `podinfo-ingress`
    *   Use a hostname of your choice (e.g., `podinfo.example.com`). You will need to configure your local `/etc/hosts` file to point this hostname to your Ingress Controller's IP address to test this.
    *   **Routing Rules:**
        *   Traffic to the path `/` should go to the `frontend-service`.
        *   Traffic to the path `/api/` should go to the `backend-service`.

### 5. Verification
*   Apply all your YAML manifests to the `homework` namespace.
*   Check that all your Pods are running.
*   Modify your `/etc/hosts` file to point your chosen hostname to your Ingress Controller's external IP.
*   Open a web browser and navigate to your hostname (e.g., `http://podinfo.example.com`).
*   You should see the `podinfo` UI, and it should successfully fetch data from the backend API.

---

## Submission
*   Submit a single YAML file named `homework.yaml` that contains all the Kubernetes resources you created (Namespace, Deployments, Services, and Ingress), separated by `---`.
*   Include a brief `README.md` explaining how to apply the manifest and how to test the application.
