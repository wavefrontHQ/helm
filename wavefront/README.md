# Wavefront Collector for Kubernetes

[Wavefront](https://wavefront.com) is a cloud-native monitoring and analytics platform that provides 
three dimensional microservices observability with metrics, histograms and OpenTracing-compatible distributed tracing.

## Introduction

This chart will deploy the Wavefront Collector for Kubernetes and Wavefront Proxy to your
Kubernetes cluster.  You can use this chart to install multiple Wavefront Proxy releases,
though only one Wavefront Collector for Kubernetes per cluster should be used.

You can learn more about the Wavefront and Kubernetes integration [here](https://docs.wavefront.com/wavefront_kubernetes.html)

## Installation

**Helm 2**
```
helm install wavefront/wavefront --name wavefront --namespace wavefront \
    --set clusterName=<<K8s-CLUSTER-NAME>> \
    --set wavefront.url=https://<<YOUR_CLUSTER>>.wavefront.com \
    --set wavefront.token=<<YOUR_API_TOKEN>>
```

**Helm 3+**

_If not already done, create a namespace to install this chart_
```
kubectl create namespace wavefront

helm install wavefront wavefront/wavefront -n wavefront \
    --set clusterName=<<K8s-CLUSTER-NAME>> \
    --set wavefront.url=https://<<YOUR_CLUSTER>>.wavefront.com \
    --set wavefront.token=<<YOUR_API_TOKEN>>
```

## Configuration

The [values.yaml](./values.yaml) file contains information about all configuration
options for this chart.

The **requried** options are `clusterName`, `wavefront.url` and `wavefront.token`.
You will need to provide values for those options for a successful installation of the chart.


## Upgrading
### Upgrading from 1.0
Openshift support has been removed from the helm chart.  Use the Wavefront Openshift operator available [here](https://github.com/wavefrontHQ/wavefront-collector-for-kubernetes/tree/master/deploy/openshift) instead.

The `collector.kubernetesSource` parameter has been replaced with the `collector.useReadOnlyPort` option.
