### CNI (Container Network Interface)  
Kubernetes uses CNI (Container Network Interface) plugins to implement its networking model. A variety of CNI plugins are available, each offering different networking solutions for pods.  
A. Flannel  
Architecture:  

Flannel provides an overlay network, allowing Pods to communicate across nodes.  
It uses VXLAN, UDP, or other encapsulation methods to tunnel Pod traffic across nodes.  
Flannel DaemonSet runs on every node, handling the network bridge and ensuring Pod IPs are routable.  
How it works:

Each node gets a subnet of IPs (usually from a larger IP pool).  
Flannel assigns an IP from the node's subnet when a pod is created on a node.  
Flannel ensures communication between Pods on different nodes by encapsulating traffic within an overlay network.  
Use cases:

It is a simple networking setup that is great for small to medium clusters.  
Suitable for flat, non-hierarchical communication among Pods.  
Doce[https://mvallim.github.io/kubernetes-under-the-hood/documentation/kube-flannel.html]


B. Calico  
Architecture:  

Calico offers both network policy enforcement and an overlay network (or can operate without an overlay using BGP).  
It uses BGP (Border Gateway Protocol) to create a high-performance network with IP routing.  
Calico supports both Layer 3 networking (with routing) and Layer 2 (with overlay using VXLAN).  
How it works:  

Calico assigns a unique IP to each Pod.  
Pods can communicate across nodes either using routing (without encapsulation) or using VXLAN tunneling.  
Supports network policies for controlling traffic flow between Pods based on labels and namespaces.  
Use cases:  

Large-scale clusters that require high-performance networking.  
Organizations needing network policy enforcement and segmentation.  
Docs [https://www.tigera.io/video/tigera-calico-fundamentals/]

C. Weave Net
Architecture:

Weave Net provides a multi-host network for Kubernetes clusters.
It also uses an overlay network and supports both VXLAN and host-gateway methods.
Weave automatically assigns IP addresses to Pods and ensures communication between them, regardless of the node location.
How it works:

Pods in different nodes communicate via the Weave network, with encrypted traffic between nodes.
Weave automatically handles IP allocation and network routing.
It provides network encryption by default, offering secure Pod-to-Pod communication.
Use cases:

Ideal for clusters with multi-cloud or hybrid-cloud configurations.
Suitable when secure and encrypted communication is necessary.

D. Cilium
Architecture:

Cilium is a container networking project that uses eBPF (extended Berkeley Packet Filter) for high-performance networking and security.
It provides Layer 7 load balancing, network visibility, and segmentation.
Cilium can be used with Kubernetes Network Policies for fine-grained access control.
How it works:

Cilium allows Pods to communicate through L3/L4 and L7 policies.
It uses eBPF for dynamic, kernel-based packet processing, which ensures scalability and performance.
It provides API-level visibility to allow service mesh features for microservices.
Use cases:

High-performance clusters requiring network visibility and segmentation at L7.
Suitable for microservices architectures and service meshes (e.g., Istio).
