# Wavefront Operator for Kubernetes

[Wavefront](https://wavefront.com) is a cloud-native monitoring and analytics platform that provides
three dimensional microservices observability with metrics, histograms and OpenTracing-compatible distributed tracing.

## Introduction

This chart will deploy the [Wavefront Operator for Kubernetes](https://github.com/wavefrontHQ/wavefront-operator-for-kubernetes/tree/main), which is used to deploy 
Wavefront Collector for Kubernetes and Wavefront Proxy to your
Kubernetes cluster.

You can learn more about the Wavefront and Kubernetes integration [here](https://docs.wavefront.com/wavefront_kubernetes.html)

## Installation

**Helm 3+**

_If not already done, create a namespace to install this chart_
```
kubectl create namespace wavefront
```

_If not already done, create a wavefront secret by providing `YOUR_WAVEFRONT_TOKEN`_
```
kubectl create -n wavefront secret generic wavefront-secret --from-literal token=YOUR_WAVEFRONT_TOKEN
```

_If not already done, add chart repo by running_
```
helm repo add wavefront-v2beta https://projects.registry.vmware.com/chartrepo/tanzu_observability
helm repo update
```

_Install Wavefront Operator for Kubernetes_
```
helm install wavefront-v2beta wavefront-v2beta/wavefront-v2beta --namespace wavefront
```

## Custom Resource Configuration

The [wavefront-basic.yaml](./examples/wavefront-basic.yaml) file contains information about basic configuration
options for the Wavefront Operator for Kubernetes.

_Apply Custom Resource Configuration_
```
kubectl apply -f wavefront-basic.yaml
```

The **requried** fields are `clusterName` and `wavefrontUrl`.
You will need to provide values for those options for a successful creation of operator custom resource.

