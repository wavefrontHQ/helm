# Wavefront Operator Helm Chart

[Helm](https://helm.sh/) is a package manager for Kubernetes. You can use Helm for installing Wavefront packages in your Kubernetes cluster.

Available Wavefront packages:
- [Wavefront Collector for Kubernetes](./wavefront/)
- [Wavefront Operator](./wavefront-operator/)

## Installation

### Add the Wavefront Repo
```
helm repo add wavefront 'https://raw.githubusercontent.com/wavefrontHQ/helm/master/'
helm repo update
```
