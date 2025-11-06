# Docker Homework Assignment

## Objective
Apply your knowledge of Docker and Docker Compose to add a new service to the existing application stack.

---

## Your Task: Add a Redis Commander Service

**Redis Commander** is a simple web-based UI for managing Redis databases. Your task is to add it to the `docker-compose.yaml` file so you can easily inspect the Redis cache used by the backend and worker services.

### Requirements

1.  **Modify `docker-compose.yaml`:**
    *   Add a new service named `redis-commander`.
    *   Use the official Docker image: `rediscommander/redis-commander:latest`.
    *   Configure the service to connect to our existing `redis` service. You will need to set the `REDIS_HOSTS` environment variable. The value should be `local:redis:6379` (this is the format Redis Commander expects).
    *   Expose the Redis Commander UI on your host machine at port `8081`. The service runs on port `8081` inside the container.
    *   Make sure the `redis-commander` service is on the `app-network` so it can communicate with the `redis` service.
    *   Add a `depends_on` condition to ensure `redis-commander` starts after the `redis` service is running.

2.  **Update the `.env` file:**
    *   The `docker-compose.yaml` file is missing the `POSTGRES_PASSWORD` environment variable. Create a `.env` file in the `docker` directory and add the following line:
        ```
        POSTGRES_PASSWORD=mysecretpassword
        ```

3.  **Verification:**
    *   Run `docker-compose up --build -d` from the `docker` directory.
    *   Open your web browser and navigate to `http://localhost:8081`.
    *   You should see the Redis Commander interface and be able to connect to the `redis` service to view its keys.

### Submission
*   Submit your modified `docker-compose.yaml` file.
*   Include a brief explanation of the changes you made and why they were necessary.

---

## Bonus Challenge (Optional)

Modify the `backend` or `worker` service to actually *use* Redis. For example, the `backend` could cache API responses in Redis for 60 seconds. This would involve adding a Redis client library to the `backend`'s `package.json` and updating its `src/app.js` file.
