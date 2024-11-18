# Team Project: Deploying Zabbix, Prometheus, and EFK on Kubernetes

## Tasks Overview

### 1. Install RKE2 in Air-Gap Mode
- Install RKE2 in an air-gapped environment with one master node and four worker nodes.
- Configure local host storage for Persistent Volumes.
- **Documentation Reference:**
  - [RKE2 Air-Gap Installation Guide](https://docs.rke2.io/install/airgap/)

### 2. Deploy Rancher on Kubernetes
- Deploy Rancher on the RKE2 cluster using Helm in air-gapped mode.
- Expose Rancher UI using a NodePort or Ingress.
- **Documentation Reference:**
  - [Rancher Air-Gap Installation Guide](https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/other-installation-methods/air-gap-installation)

### 3. Deploy Zabbix
- Deploy Zabbix Server, Web Frontend, and Agent.
- Configure monitoring for Kubernetes nodes using Zabbix Agents.
- Create alert rules and demonstrate their functionality.
- Use local host storage for the Zabbix database.
- **Documentation Reference:**
  - [Zabbix Helm Chart](https://github.com/zabbix-community/helm-charts)

### 4. Deploy Prometheus
- Deploy Prometheus using Helm and configure it to scrape metrics from Kubernetes components.
- Integrate Prometheus with Grafana for visualizing metrics.
- Set up alerting rules using Alertmanager.
- Use local host storage for Prometheus and Alertmanager data.
- **Documentation Reference:**
  - [Prometheus Helm Chart](https://github.com/prometheus-community/helm-charts)
  - [Grafana Helm Chart](https://github.com/grafana/helm-charts)

### 5. Deploy EFK Stack
- Deploy Fluentd as a DaemonSet to collect logs from Kubernetes nodes and Pods.
- Set up Elasticsearch for log storage with local host storage as Persistent Volumes.
- Configure Kibana to visualize logs and demonstrate querying functionality.
- **Documentation Reference:**
  - [EFK Setup for Kubernetes](https://kubernetes.io/docs/tasks/debug/debug-cluster/logging-elasticsearch-kibana/)

### 6. Team Collaboration and Documentation
- Divide responsibilities among team members for each tool.
- Document the following:
  - Steps for installation and configuration.
  - Challenges faced and solutions implemented.
  - Screenshots of monitoring dashboards and log visualizations.
- Prepare a final report or presentation for the project.

---

## Expected Deliverables
1. Functional Rancher UI and RKE2 cluster.
2. Fully deployed and configured Zabbix, Prometheus, and EFK stack with local host storage.
3. Comprehensive documentation of the process.
4. Optional live demonstration of the setup.
