# Wavefront Remote Storage Adapter for Prometheus

[Wavefront](https://wavefront.com) is a high-performance streaming analytics platform for monitoring and optimizing your environment and applications.

## Introduction

This chart will deploy the [Prometheus Storage Adapter](https://github.com/wavefrontHQ/prometheus-storage-adapter) and the [Wavefront Proxy](https://docs.wavefront.com/proxies.html) to your Kubernetes cluster.

## Installation
### Helm 3+

_If not already done, create a namespace to install this chart_
```
kubectl create namespace prom-adapter

helm install prom-adapter wavefront/prometheus-storage-adapter --namespace prom-adapter \
    --set wavefront.wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.wavefront.token=<YOUR_API_TOKEN>
```

### Helm 2
```
helm install wavefront/prometheus-storage-adapter --name prom-adapter --namespace prom-adapter \
    --set wavefront.wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.wavefront.token=<YOUR_API_TOKEN>
```

## Configuration

The [values.yaml](./values.yaml) file contains information about all configuration
options for this chart.

The options `wavefront.wavefront.url` and `wavefront.wavefront.token` are **required** if the proxy is deployed as part of this chart (defaults to true).

## Parameters

The following tables lists the configurable parameters of the Wavefront chart and their default values.

| Parameter | Description | Default |
| --- | --- | --- |
| `wavefront.wavefront.url` | Wavefront URL for your cluster | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.wavefront.token` | Wavefront API Token | `YOUR_API_TOKEN` |
| `image.repository` | storage adapter image registry and name | `wavefronthq/prometheus-storage-adapter` |
| `image.tag` | storage adapter image tag | `{TAG_NAME}` |
| `image.pullPolicy` | storage adapter image pull policy | `IfNotPresent` |
| `proxy.enabled` | Setup and enable Wavefront proxy to send metrics through | `true` |
| `adapter.listenPort` | Metrics under this prefix are exposed via the custom metrics API | `1234` |
| `adapter.proxyHost` | Non-default Wavefront proxy address to use, should only be set when proxy.enabled is false | `nil` |
| `adapter.proxyPort` | The Wavefront proxy port | `2878` |
| `adapter.enableDebug` | Whether to enable debug logging | `false` |
| `adapter.prefix` | Prefix for metric names. If omitted, no prefix is added. | `nil` |
| `adapter.tags` | A comma separated list of tags to be added to each point tag. Specified as "tag1=value1,tag2=value2..." | `nil` |
