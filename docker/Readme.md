# DevOps Learning Tasks

## Task 1: Understanding Copy-on-Write (CoW) Mechanism
1. **Objective**: Learn how the Copy-on-Write (CoW) mechanism works in containers.
2. **Instructions**:
   - Create a Docker container from an existing image.
     ```bash
     docker run -it --name cow-test ubuntu:latest /bin/bash
     ```
   - Inside the container, create a new file and modify it.
     ```bash
     echo "Hello, World!" > /tmp/hello.txt
     ```
   - Check the layers using another terminal.
     ```bash
     docker diff cow-test
     ```
   - Delete the file and observe the size.
     ```bash
     rm /tmp/hello.txt
     ```
3. **Expected Outcome**: Understanding how CoW creates new layers and the implications of file deletions.

## Task 2: Exploring Mount Namespace (mnt)
1. **Objective**: Explore how the Mount namespace isolates mount points.
2. **Instructions**:
   - Create a Docker container with a mounted volume.
     ```bash
     docker run -it -v /host/path:/container/path --name mnt-test ubuntu:latest /bin/bash
     ```
   - Inside the container, create and delete files within the mounted volume.
     ```bash
     touch /container/path/testfile
     rm /container/path/testfile
     ```
   - Observe the isolation of mount points between the host and the container.
     ```bash
     ls /host/path
     ```
3. **Expected Outcome**: Understanding how mount points are isolated within containers.

## Task 3: Process ID Namespace (pid)
1. **Objective**: Learn about process isolation using PID namespaces.
2. **Instructions**:
   - Run a Docker container and check the processes running inside it.
     ```bash
     docker run -it --name pid-test ubuntu:latest /bin/bash
     ps aux
     ```
   - Compare the process IDs inside the container with those on the host.
     ```bash
     docker top pid-test
     ```
3. **Expected Outcome**: Understanding how PID namespaces isolate processes within containers.

## Task 4: Network Namespace (net)
1. **Objective**: Understand network isolation in containers.
2. **Instructions**:
   - Run two Docker containers and connect them using a Docker network.
     ```bash
     docker network create my-network
     docker run -it --network my-network --name net-test1 ubuntu:latest /bin/bash
     docker run -it --network my-network --name net-test2 ubuntu:latest /bin/bash
     ```
   - Test network communication between the containers.
     ```bash
     # In net-test1 container
     ping net-test2
     ```
   - Observe how network devices and stacks are isolated.
     ```bash
     ifconfig
     ```
3. **Expected Outcome**: Understanding network isolation and communication in containers.

## Task 5: Inter-process Communication Namespace (ipc)
1. **Objective**: Explore IPC namespace isolation.
2. **Instructions**:
   - Create a Docker container and set up shared memory and message queues.
     ```bash
     docker run -it --ipc=shareable --name ipc-test1 ubuntu:latest /bin/bash
     docker run -it --ipc=container:ipc-test1 --name ipc-test2 ubuntu:latest /bin/bash
     ```
   - Communicate between processes using these IPC mechanisms.
     ```bash
     # In ipc-test1 container
     echo "Message from ipc-test1" > /dev/shm/ipcfile
     # In ipc-test2 container
     cat /dev/shm/ipcfile
     ```
3. **Expected Outcome**: Understanding how IPC namespaces isolate inter-process communication.

## Task 6: UNIX Time-sharing System Namespace (UTS)
1. **Objective**: Learn about UTS namespace isolation.
2. **Instructions**:
   - Run a Docker container and change its hostname.
     ```bash
     docker run -it --name uts-test --hostname container-hostname ubuntu:latest /bin/bash
     hostname
     ```
   - Observe how the hostname change affects the container and not the host.
     ```bash
     # On the host
     hostname
     ```
3. **Expected Outcome**: Understanding hostname and NIS domain name isolation in containers.

## Task 7: User ID Namespace (user)
1. **Objective**: Understand user and group ID isolation.
2. **Instructions**:
   - Run a Docker container with a specific user and group ID.
     ```bash
     docker run -it --user 1000:1000 --name user-test ubuntu:latest /bin/bash
     ```
   - Perform operations inside the container and observe the isolation of user and group IDs.
     ```bash
     id
     touch /tmp/user-test-file
     ls -l /tmp/user-test-file
     ```
3. **Expected Outcome**: Understanding user and group ID isolation in containers.

## Task 8: Time Namespace
1. **Objective**: Learn about time isolation in containers.
2. **Instructions**:
   - Run a Docker container and change its system time.
     ```bash
     docker run -it --name time-test --privileged ubuntu:latest /bin/bash
     date -s "2023-01-01 00:00:00"
     date
     ```
   - Observe how the time change affects the container and not the host.
     ```bash
     # On the host
     date
     ```
3. **Expected Outcome**: Understanding time isolation in containers.

## Task 9: Cgroup Namespace
1. **Objective**: Explore control group isolation.
2. **Instructions**:
   - Run a Docker container and limit its resources using cgroups.
     ```bash
     docker run -it --memory="512m" --cpus="1" --name cgroup-test ubuntu:latest /bin/bash
     ```
   - Monitor resource usage and observe how cgroups enforce resource limits.
     ```bash
     top
     free -m
     ```
3. **Expected Outcome**: Understanding how cgroups isolate and limit resources in containers.

## Additional Resources
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

Happy learning!

