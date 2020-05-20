# Wavefront by VMware Adapter for Istio

Wavefront by VMware Adapter for Istio is an adapter for [Istio](https://istio.io)
to publish metrics to [Wavefront by VMware](https://www.wavefront.com/).

## Introduction

This chart will deploy the [Wavefront by VMware Adapter for Istio](https://github.com/vmware/wavefront-adapter-for-istio/) into kubernetes cluster.

## Installation

**Helm 3+**

Install Wavefront by VMware Adapter for Istio by following any one of the options:- 


**Option 1:** Direct ingestion

```
helm install wavefront-istio-adapter wavefront/wavefront-istio-adapter \
    --set credentials.direct.server=https://<YOUR_CLUSTER>.wavefront.com \
    --set credentials.direct.token=<YOUR_API_TOKEN>
```

**Option 2:** Wavefront Proxy

```
helm install wavefront-istio-adapter wavefront/wavefront-istio-adapter \
    --set credentials.proxy.address=<PROXY_HOST:PORT>
```

## Configuration

The [values.yaml](./values.yaml) file contains information about all configuration
options for this chart.

The **requried** options for direct ingestion approach are `credentials.direct.server` and `credentials.direct.token`.
The **required** options for proxy ingestion approach are `credentials.proxy.address`
You will need to provide values for those options for a successful installation of the chart.

## Parameters

The following tables lists the configurable parameters of the Wavefront by VMware Adapter for Istio chart and their default values.

| Parameter | Description | Default |
| --- | --- | --- |
| `credentials.direct.server` | Wavefront URL for your cluster | `https://YOUR_CLUSTER.wavefront.com` |
| `credentials.direct.token` | Wavefront API Token | `YOUR_API_TOKEN` |
| `credentials.proxy.address` | Wavefront proxy address with port | `PROXY_HOST:PORT` |
| `namespaces.istio` | Namespace into which Istio is installed | `istio-system` |
| `namespaces.adapter` | Namespace into which Wavefront Istio adapter need to be installed | `wavefront-istio` |
| `metrics.flushInterval` | How often to force a metrics flush | `5s` |
| `metrics.source` | The source tag for all metrics handled by this adapter | `istio` |
| `metrics.prefix` | The prefix to prepend all metrics handled by the adapter | `istio` |
| `metrics.http` | Flag to enable/disable http metrics collection | `true` |
| `metrics.tcp` | Flag to enable/disable tcp metrics collection | `true` |
| `logs.level` | The log level (one of error, warn, info, debug, or none) | `info` |
