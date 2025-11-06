# Docker Application Architecture Overview

This document provides a high-level overview of the multi-service application defined in `docker-compose.yaml`.

## Service Interaction Diagram

```mermaid
graph TD
    User(Browser) --> |HTTP/HTTPS (Port 80)| Nginx
    Nginx --> |Static Files| Frontend(React App)
    Nginx --> |/api/| Backend(Node.js API)
    Backend --> |PostgreSQL (Port 5432)| DB(PostgreSQL)
    Backend --> |Redis (Port 6379)| Redis(Redis Cache)
    Backend --> |Elasticsearch (Port 9200)| Elasticsearch(Elasticsearch)
    Worker(Node.js Worker) --> |PostgreSQL (Port 5432)| DB
    Worker --> |Redis (Port 6379)| Redis

    subgraph Monitoring
        Cadvisor --> Prometheus
        Prometheus --> Grafana
    end

    Nginx --- app-network
    Backend --- app-network
    Worker --- app-network
    DB --- app-network
    Redis --- app-network
    Elasticsearch --- app-network
    Cadvisor --- app-network
    Prometheus --- app-network
    Grafana --- app-network
```

## Component Breakdown

*   **Nginx:** Acts as the entry point for all external traffic. It serves the static frontend assets and reverse-proxies API requests to the `backend` service.
*   **Frontend (React App):** A single-page application (SPA) built with React. It makes API calls to the `backend` through the Nginx proxy.
*   **Backend (Node.js API):** The core API service. It interacts with the PostgreSQL database, Redis cache, and Elasticsearch.
*   **Worker (Node.js Worker):** A background process that can perform tasks, potentially interacting with the database and Redis.
*   **DB (PostgreSQL):** The primary relational database for the application, storing persistent data.
*   **Redis (Redis Cache):** An in-memory data store used for caching and potentially message queuing by the `backend` and `worker`.
*   **Elasticsearch:** A distributed search and analytics engine.
*   **Cadvisor:** Provides container resource usage and performance metrics.
*   **Prometheus:** A monitoring system that scrapes metrics from `cadvisor` and other services.
*   **Grafana:** A visualization tool used to create dashboards from Prometheus metrics.

## Networking

All application services communicate over the `app-network` Docker bridge network. The `Nginx` service is also exposed to the host machine on port `80` to allow external access.
