# Task 1: Core Concepts

## Objective
Understand the fundamental building blocks of Docker: images and containers.

*   **Image:** An image is a lightweight, standalone, executable package that includes everything needed to run a piece of software, including the code, a runtime, libraries, environment variables, and config files. Images are immutable.
*   **Container:** A container is a running instance of an image. You can create, start, stop, move, or delete containers.

---

## Tasks

### 1.1. Pull an Image
*   **Task:** Download the `ubuntu:latest` image from Docker Hub.
*   **Command:**
    ```bash
    docker pull ubuntu:latest
    ```
*   **Verification:** List the images on your machine.
    ```bash
    docker images
    ```

### 1.2. Run a Container
*   **Task:** Run a container from the `ubuntu:latest` image. The `-it` flags allow you to interact with the container's shell.
*   **Command:**
    ```bash
    docker run -it --name my-first-container ubuntu:latest /bin/bash
    ```
*   **Note:** Your terminal prompt will change, indicating you are now inside the container.

### 1.3. Interact with the Container
*   **Task:** Inside the container, run some basic Linux commands.
*   **Commands:**
    ```bash
    # See the directory listing
    ls /

    # Print the hostname
    hostname

    # Exit the container
    exit
    ```

### 1.4. Manage Container Lifecycle
*   **Task:** View and manage your container from your host machine.
*   **Commands:**
    ```bash
    # See all containers (including stopped ones)
    docker ps -a

    # Start the container again
    docker start my-first-container

    # Attach to the running container's shell
    docker attach my-first-container
    # (You'll need to 'exit' again)

    # Stop the container
    docker stop my-first-container

    # Remove the container
    docker rm my-first-container
    ```
