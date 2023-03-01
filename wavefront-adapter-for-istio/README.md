# Wavefront by VMware Adapter for Istio

Wavefront by VMware Adapter for Istio is an adapter for [Istio](https://istio.io)
to publish metrics to [Wavefront by VMware](https://www.wavefront.com/).

## Introduction

This chart will deploy the [Wavefront by VMware Adapter for Istio](https://github.com/vmware/wavefront-adapter-for-istio/) into kubernetes cluster.

## Prerequisites

To deploy this adapter, you will need a cluster with the following setup.

* Kubernetes v1.15+
* Istio v1.4, v1.5 or v1.6
* Helm v3.2+

**Note:** From Istio v1.5.x onwards `Mixer` is disabled by default. Enable `Mixer` with the following step:

##### Istio v1.5.x
```console
istioctl manifest apply --set values.prometheus.enabled=true --set values.telemetry.v1.enabled=true --set values.telemetry.v2.enabled=false --set components.citadel.enabled=true --set components.telemetry.enabled=true
```

##### Istio v1.6.x
```console
istioctl install --set values.prometheus.enabled=true --set values.telemetry.v1.enabled=true --set values.telemetry.v2.enabled=false --set components.citadel.enabled=true --set components.telemetry.enabled=true
```

## Installation

**Helm 3+**

_If not already done, create a namespace to install this chart_
```
helm repo add wavefront https://wavefronthq.github.io/helm/

helm repo update

kubectl create namespace wavefront-istio

helm install wavefront-adapter-for-istio wavefront/wavefront-adapter-for-istio --namespace wavefront-istio \
    --set wavefront.wavefront.url=https://<YOUR_CLUSTER>.wavefront.com \
    --set wavefront.wavefront.token=<YOUR_API_TOKEN>
```

## Configuration

The [values.yaml](https://raw.githubusercontent.com/wavefrontHQ/helm/master/wavefront-adapter-for-istio/values.yaml) file contains information about all configuration
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
