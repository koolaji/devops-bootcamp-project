# Task 4: Docker Networking

## Objective
Understand the basics of container networking and how to connect containers so they can communicate.

---

## Tasks

### 4.1. The Default Bridge Network
*   **Objective:** See how Docker, by default, attaches containers to a `bridge` network, allowing them to communicate using their IP addresses.
*   **Instructions:**
    1.  Run two containers in the background (`-d` flag).
        ```bash
        docker run -dit --name net-test1 ubuntu:latest
        docker run -dit --name net-test2 ubuntu:latest
        ```
    2.  Find the IP address of the second container.
        ```bash
        docker inspect net-test2 | grep IPAddress
        ```
    3.  Attach to the first container and try to ping the second container using its IP address.
        ```bash
        docker exec -it net-test1 /bin/bash
        # You may need to install ping first: apt-get update && apt-get install -y iputils-ping
        ping <IP_ADDRESS_OF_NET_TEST2>
        exit
        ```
    4.  Clean up.
        ```bash
        docker rm -f net-test1 net-test2
        ```
    *   **Note:** Communication by IP address is not ideal, as IPs can change. The next task solves this.

### 4.2. User-Defined Bridge Networks
*   **Objective:** Create a custom bridge network. Containers on the same user-defined network can communicate using their service names as hostnames, thanks to Docker's built-in DNS.
*   **Instructions:**
    1.  Create a new network.
        ```bash
        docker network create my-app-network
        ```
    2.  Run two containers and attach them to the new network.
        ```bash
        docker run -dit --name app1 --network my-app-network ubuntu:latest
        docker run -dit --name app2 --network my-app-network ubuntu:latest
        ```
    3.  Attach to the first container and ping the second container *by its name*.
        ```bash
        docker exec -it app1 /bin/bash
        # Install ping: apt-get update && apt-get install -y iputils-ping
        ping app2
        exit
        ```
        *This works because Docker provides DNS resolution on user-defined networks.*
    4.  Clean up.
        ```bash
        docker rm -f app1 app2
        docker network rm my-app-network
        ```
