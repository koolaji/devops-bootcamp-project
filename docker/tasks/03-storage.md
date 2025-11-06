# Task 3: Docker Storage

## Objective
Understand how Docker manages image layers (Copy-on-Write) and how to persist data using volumes.

---

## Tasks

### 3.1. Understanding Copy-on-Write (CoW)
*   **Objective:** See how Docker's CoW mechanism works. When you modify a file in a container, Docker doesn't change the base image. Instead, it creates a new layer on top of the image and writes the changes there.
*   **Instructions:**
    1.  Run a new container.
        ```bash
        docker run -it --name cow-test ubuntu:latest /bin/bash
        ```
    2.  Inside the container, create a file.
        ```bash
        echo "Hello Docker" > /hello.txt
        ```
    3.  From another terminal on your host, use `docker diff` to see the changes. `C` means changed, `A` means added.
        ```bash
        docker diff cow-test
        ```
        *You will see the `A /hello.txt` entry.*
    4.  Clean up the container.
        ```bash
        docker rm -f cow-test
        ```

### 3.2. Persisting Data with Volumes
*   **Objective:** Learn how to use volumes to store data outside the container's lifecycle. This is the correct way to handle persistent data like databases or user uploads.
*   **Instructions:**
    1.  Create a named volume.
        ```bash
        docker volume create my-app-data
        ```
    2.  Run a container and mount the volume into it. The `-v` flag syntax is `volume-name:/path/in/container`.
        ```bash
        docker run -it --rm --name volume-test -v my-app-data:/data ubuntu:latest /bin/bash
        ```
    3.  Inside the container, create a file inside the mounted volume directory.
        ```bash
        echo "This data is persistent" > /data/important.txt
        exit
        ```
    4.  Run a *new* container and mount the *same* volume.
        ```bash
        docker run -it --rm --name volume-test-2 -v my-app-data:/data ubuntu:latest /bin/bash
        ```
    5.  Inside the new container, view the contents of the file. The data is still there!
        ```bash
        cat /data/important.txt
        exit
        ```
    6.  Clean up the volume.
        ```bash
        docker volume rm my-app-data
        ```
