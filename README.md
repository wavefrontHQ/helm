# Wavefront Helm Charts

[Helm](https://helm.sh/) is a package manager for Kubernetes. You can use Helm for installing Wavefront packages in your Kubernetes cluster.

Available Wavefront packages:
- [Wavefront Collector for Kubernetes](./wavefront/)
- [Wavefront HPA Adapter for Kubernetes](./wavefront-hpa-adapter/)
- [Wavefront Storage Adapter for Prometheus](./prometheus-storage-adapter/)
- [Wavefront Adapter for Istio](./wavefront-adapter-for-istio/)

## Installation

### Add the Wavefront Repo
```
helm repo add wavefront https://wavefronthq.github.io/helm/
helm repo update
```
### Install a chart
Follow the steps within the packages listed above to install the relevant chart.
