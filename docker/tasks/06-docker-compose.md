# Task 6: Multi-Service Applications with Docker Compose

## Objective
Learn how to use `docker-compose` to define and run a multi-container application.

---

## What is Docker Compose?
Docker Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services. Then, with a single command, you create and start all the services from your configuration.

---

## Tasks

### 6.1. Analyze the `docker-compose.yaml` File
*   **Task:** Review the `docker-compose.yaml` file in the `docker/` directory. It defines our entire application stack.
*   **Key Sections:**
    *   `services`: Each subsection is a container (e.g., `nginx`, `backend`, `db`).
    *   `build`: Specifies the directory containing the `Dockerfile` to build the service's image.
    *   `image`: Specifies a pre-built image to pull from a registry.
    *   `ports`: Maps ports from the host to the container (`HOST:CONTAINER`).
    *   `volumes`: Mounts host paths or named volumes into the container.
    *   `environment`: Sets environment variables inside the container.
    *   `depends_on`: Defines startup order dependencies between services.
    *   `networks`: Configures which networks the services connect to.

### 6.2. Analyze the `nginx.conf` Reverse Proxy
*   **Task:** Review the NGINX configuration at `docker/nginx/nginx.conf`. This is the glue that connects our frontend and backend.
    ```nginx
    server {
        listen 80;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
            try_files $uri /index.html;
        }

        location /api/ {
            proxy_pass http://backend:5000;
        }
    }
    ```
*   **How it Works:**
    *   The `location /` block tells NGINX to serve the static files (our React app) from the `/usr/share/nginx/html` directory inside the container. `try_files` is important for single-page applications.
    *   The `location /api/` block is a **reverse proxy**. It tells NGINX that any request starting with `/api` should be forwarded to the `backend` service on port `5000`. This is how our frontend can talk to our backend without needing to know its IP address.

### 6.3. Run the Application
*   **Task:** Launch the entire application stack.
*   **Instructions:**
    1.  Navigate to the `docker/` directory.
        ```bash
        cd /opt/devops-bootcamp-project/docker
        ```
    2.  You will need a `.env` file to specify the `POSTGRES_PASSWORD`.
        ```bash
        echo "POSTGRES_PASSWORD=mysecretpassword" > .env
        ```
    3.  Build and run the services in the background (`-d` flag).
        ```bash
        docker-compose up --build -d
        ```
    4.  Check the status of the running containers.
        ```bash
        docker-compose ps
        ```
*   **Verification:**
    *   Open your web browser and navigate to `http://localhost`. You should see the React frontend.
    *   The frontend should display a message fetched from the backend API.

### 6.4. Stop the Application
*   **Task:** Stop and remove the containers, networks, and volumes.
*   **Command:**
    ```bash
    docker-compose down
    ```
