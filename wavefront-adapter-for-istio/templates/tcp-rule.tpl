{{/* Generate rule for tcp metrics */}}
{{- define "rule.tcp" }}
# rule to dispatch tcp metrics to handler wavefront-handler
apiVersion: "config.istio.io/v1alpha2"
kind: rule
metadata:
  name: wavefront-tcp-rule
  namespace: {{ .Values.adapter.istioNamespace }}
spec:
  match: context.protocol == "tcp"
  actions:
  - handler: wavefront-handler.{{ .Values.adapter.istioNamespace }}
    instances:
    - tcpsentbytes.instance.{{ .Release.Namespace }}
    - tcpreceivedbytes.instance.{{ .Release.Namespace }}
---
# rule to dispatch tcp connection open metric to handler wavefront-handler
apiVersion: "config.istio.io/v1alpha2"
kind: rule
metadata:
  name: wavefront-tcp-connection-open-rule
  namespace: {{ .Values.adapter.istioNamespace }}
spec:
  match: context.protocol == "tcp" && connection.event == "open"
  actions:
  - handler: wavefront-handler.{{ .Values.adapter.istioNamespace }}
    instances:
    - tcpconnectionsopened.instance.{{ .Release.Namespace }}
---
# rule to dispatch tcp connection close metric to handler wavefront-handler
apiVersion: "config.istio.io/v1alpha2"
kind: rule
metadata:
  name: wavefront-tcp-connection-close-rule
  namespace: {{ .Values.adapter.istioNamespace }}
spec:
  match: context.protocol == "tcp" && connection.event == "close"
  actions:
  - handler: wavefront-handler.{{ .Values.adapter.istioNamespace }}
    instances:
    - tcpconnectionsclosed.instance.{{ .Release.Namespace }}
{{- end }}

