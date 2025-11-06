# Task 5: Building Images: The Dockerfile

## Objective
Learn to write a `Dockerfile` to create a custom Docker image for an application. We will focus on best practices for security, size, and build speed.

---

## The Anatomy of a Dockerfile
A `Dockerfile` is a text document that contains all the commands a user could call on the command line to assemble an image.

-   `FROM`: Specifies the base image.
-   `WORKDIR`: Sets the working directory for subsequent instructions.
-   `COPY`: Copies files from the host into the container.
-   `RUN`: Executes a command during the build process (e.g., installing dependencies).
-   `EXPOSE`: Informs Docker that the container listens on the specified network ports at runtime.
-   `CMD`: Provides the default command to execute when the container starts.

---

## Tasks

### 5.1. Analyze the Backend Dockerfile
*   **Task:** Review the `Dockerfile` located in `docker/backend/Dockerfile`.
    ```dockerfile
    # Use a lightweight Node.js image as the base image
    FROM node:14-alpine

    # Set the working directory
    WORKDIR /app

    # Copy package.json and yarn.lock to leverage Docker cache
    COPY package.json yarn.lock* ./

    # Install dependencies
    RUN yarn install --frozen-lockfile

    # Copy the rest of your application files
    COPY . .

    # Expose the port your app runs on
    EXPOSE 5000

    # Command to run your application
    CMD ["node", "src/app.js"]
    ```
*   **Questions for Understanding:**
    1.  Why do we copy `package.json` and `yarn.lock` *before* copying the rest of the code?
        *   **Answer:** This leverages Docker's layer caching. The `RUN yarn install` command creates a layer that is only rebuilt if `package.json` or `yarn.lock` changes. This saves a lot of time during development, as you don't need to reinstall all dependencies every time you change a source code file.
    2.  What is the purpose of `node:14-alpine`?
        *   **Answer:** It's a small, lightweight base image for Node.js, which results in a smaller final image size.

### 5.2. Analyze the Frontend Dockerfile (Multi-stage Build)
*   **Task:** Review the `Dockerfile` located in `docker/frontend/Dockerfile`. This is a multi-stage build, which is a powerful technique for creating small, secure production images.
    ```dockerfile
    # Stage 1: Build the React app
    FROM registry.docker.ir/node:16 AS builder
    WORKDIR /app

    COPY package.json ./
    RUN yarn install --frozen-lockfile || yarn install
    COPY . .
    RUN yarn build

    # Stage 2: Serve the React app with NGINX
    FROM nginx:latest
    COPY --from=builder /app/build /usr/share/nginx/html
    EXPOSE 80
    ```
*   **Questions for Understanding:**
    1.  What is the purpose of the first stage (`AS builder`)?
        *   **Answer:** The first stage uses a Node.js image to install all the development dependencies and build the React application into static HTML, CSS, and JavaScript files.
    2.  What is the purpose of the second stage?
        *   **Answer:** The second stage uses a very small, production-ready `nginx` image. It copies *only* the static build artifacts from the first stage. The final image doesn't contain any of the Node.js development dependencies, making it much smaller and more secure.
