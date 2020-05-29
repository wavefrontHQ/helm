# Wavefront by VMware Adapter for Istio

Wavefront by VMware Adapter for Istio is an adapter for [Istio](https://istio.io)
to publish metrics to [Wavefront by VMware](https://www.wavefront.com/).

## Introduction

This chart will deploy the [Wavefront by VMware Adapter for Istio](https://github.com/vmware/wavefront-adapter-for-istio/) into kubernetes cluster.

## Installation

**Helm 3+**

```
helm install wavefront-adapter-for-istio wavefront/wavefront-adapter-for-istio \
    --set wavefront.wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.wavefront.token=<YOUR_API_TOKEN>
```

## Configuration

The [values.yaml](./values.yaml) file contains information about all configuration
options for this chart.

The options `wavefront.wavefront.url` and `wavefront.wavefront.token` are **required** if the `proxy.enabled` is set to `true` or `adapter.useProxy` is set to `false`.


## Parameters

The following tables lists the configurable parameters of the Wavefront by VMware Adapter for Istio chart and their default values.

| Parameter | Description | Default |
| --- | --- | --- |
| `wavefront.wavefront.url` | Wavefront URL for your cluster | `https://YOUR_CLUSTER.wavefront.com` |
| `wavefront.wavefront.token` | Wavefront API Token | `YOUR_API_TOKEN` |
| `image.repository` | Istio adapter image registry and name | `vmware/wavefront-adapter-for-istio` |
| `image.tag` | istio adapter image tag | `{TAG_NAME}` |
| `image.pullPolicy` | Istio adapter image pull policy | `Always` |
| `adapter.useProxy` | Use a Wavefront Proxy to send metrics through if set to false, we assume direct ingestion | `true` |
| `adapter.proxyAddress` | Non-default Wavefront Proxy address to use, should only be set when `proxy.enabled` is false | `nil` |
| `adapter.logLevel` | The log level (one of error, warn, info, debug, or none) | `info` |
| `adapter.istioNamespace` | Namespace into which Istio is installed | `istio-system` |
| `proxy.enabled` | Setup and enable Wavefront proxy to send metrics through | `true` |
| `metrics.flushInterval` | How often to force a metrics flush | `5s` |
| `metrics.source` | The source tag for all metrics handled by this adapter | `istio` |
| `metrics.prefix` | The prefix to prepend all metrics handled by the adapter | `istio` |
| `metrics.http` | Flag to enable/disable http metrics collection | `true` |
| `metrics.tcp` | Flag to enable/disable tcp metrics collection | `true` |
