{{/* Generate rule for http metrics */}}
{{- define "rule.http" }}
# rule to dispatch to handler wavefront-handler
apiVersion: "config.istio.io/v1alpha2"
kind: rule
metadata:
  name: wavefront-http-rule
  namespace: {{ .Values.adapter.istioNamespace }}
spec:
  match: context.protocol == "http"
  actions:
  - handler: wavefront-handler.{{ .Values.adapter.istioNamespace }}
    instances:
    - requestsize.instance.{{ .Release.Namespace }}
    - requestcount.instance.{{ .Release.Namespace }}
    - requestduration.instance.{{ .Release.Namespace }}
    - responsesize.instance.{{ .Release.Namespace }}
{{- end }}
