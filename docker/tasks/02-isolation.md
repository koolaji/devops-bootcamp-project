# Task 2: Container Isolation

## Objective
Explore how Docker uses Linux namespaces and Control Groups (cgroups) to achieve container isolation and resource management.

---

## Tasks

### 2.1. Process ID (PID) Namespace
*   **Objective:** See how PID namespaces provide containers with their own isolated process trees.
*   **Instructions:**
    1.  Run a container.
        ```bash
        docker run -it --name pid-test ubuntu:latest /bin/bash
        ```
    2.  Inside the container, view the processes. Notice that the `bash` process has `PID 1`.
        ```bash
        ps aux
        ```
    3.  From another terminal on your host, use `docker top` to see the same processes from the host's perspective, with their actual host PIDs.
        ```bash
        docker top pid-test
        ```
    4.  Clean up the container.
        ```bash
        docker rm -f pid-test
        ```

### 2.2. UNIX Time-sharing System (UTS) Namespace
*   **Objective:** Understand how the UTS namespace isolates the hostname.
*   **Instructions:**
    1.  Run a container with a specific hostname.
        ```bash
        docker run -it --rm --name uts-test --hostname my-container-hostname ubuntu:latest /bin/bash
        ```
    2.  Inside the container, check the hostname. It will be `my-container-hostname`.
        ```bash
        hostname
        ```
    3.  On the host, the hostname remains unchanged.
        ```bash
        hostname
        ```

### 2.3. User ID (USER) Namespace
*   **Objective:** Understand how user and group IDs can be mapped between the host and the container for better security.
*   **Instructions:**
    1.  Run a container with a specific user and group ID.
        ```bash
        docker run -it --rm --user 1000:1000 --name user-test ubuntu:latest /bin/bash
        ```
    2.  Inside the container, check the user ID.
        ```bash
        id
        ```
    3.  Try to create a file in a privileged directory. This should fail.
        ```bash
        touch /etc/test-file
        ```

### 2.4. Control Groups (cgroups)
*   **Objective:** See how cgroups are used to limit a container's resource usage.
*   **Instructions:**
    1.  Run a container with memory and CPU limits.
        ```bash
        docker run -it --rm --memory="512m" --cpus="0.5" ubuntu:latest /bin/bash
        ```
    2.  Inside the container, you can try running a process that consumes resources to see the limits in action.
    3.  **Note:** Observing these limits often requires more advanced tools, but this demonstrates the syntax for applying them.
