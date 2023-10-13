# Wavefront HPA Adapter for Kubernetes

[Wavefront](https://wavefront.com) is a high-performance streaming analytics platform for monitoring and optimizing your environment and applications.

## Introduction

This chart will deploy the [Wavefront HPA Adapter](https://github.com/wavefrontHQ/wavefront-kubernetes-adapter) to your Kubernetes cluster.

You can learn more about the Wavefront and Kubernetes integration [here](https://docs.wavefront.com/wavefront_kubernetes.html).

## Installation

**Helm 3+**

_If not already done, create a namespace to install this chart_
```
helm repo add wavefront https://wavefronthq.github.io/helm/

helm repo update

kubectl create namespace wavefront-adapter

helm install wavefront-adapter wavefront/wavefront-hpa-adapter --namespace wavefront-adapter \
    --set wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.token=<YOUR_API_TOKEN>
```

**Helm 2**
```
helm install wavefront/wavefront-hpa-adapter --name wavefront-adapter --namespace wavefront-adapter \
    --set wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.token=<YOUR_API_TOKEN>
```

## Configuration

The [values.yaml](./values.yaml) file contains information about all configuration
options for this chart.

The **requried** options are `wavefront.url` and `wavefront.token`.
You will need to provide values for those options for a successful installation of the chart.

## Parameters

The following tables lists the configurable parameters of the Wavefront chart and their default values.

| Parameter | Description | Default |
| --- | --- | --- |
| `wavefront.url` | Wavefront URL for your cluster | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.token` | Wavefront API Token | `YOUR_API_TOKEN` |
| `wavefront.secret.tokenFromSecret` | Name of the secret where the api token is stored | `nil` |
| `image.repository` | Wavefront HPA adapter image registry and name | `wavefronthq/wavefront-hpa-adapter` |
| `image.tag` | Wavefront HPA adapter image tag | `{TAG_NAME}` |
| `image.pullPolicy` | Wavefront HPA adapter image pull policy | `IfNotPresent` |
| `adapter.metricPrefix` | Metrics under this prefix are exposed via the custom metrics API | `kubernetes` |
| `adapter.metricRelistInterval` | Interval at which to fetch the list of custom metric names from Wavefront | `10m` |
| `adapter.apiClientTimeout` | API client timeout | `10s` |
| `adapter.logLevel` | Min logging level (info, debug, trace) | `info` |
| `adapter.rules` | Static configuration for external metrics [see more](https://github.com/wavefrontHQ/wavefront-kubernetes-adapter/blob/master/docs/introduction.md#static-configuration-file) | `nil` |
| `resources` | Define node labels for pod assignment | `nil` |
| `priorityClassName` | Specify a priority class | `nil` |
| `nodeSelector` | Define a nodeSelector | `nil` |
| `tolerations` | Define node taints to tolerate | `nil` |
| `resources` | Define node/pod affinities | `nil` |
