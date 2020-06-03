{{/* Generate http metrics */}}
{{- define "metrics.http" }}
    - name: requestsize
      instanceName: requestsize.instance.{{ .Release.Namespace }}
      type: HISTOGRAM
      sample:
        expDecay:
          reservoirSize: 1024
          alpha: 0.015
    - name: requestcount
      instanceName: requestcount.instance.{{ .Release.Namespace }}
      type: DELTA_COUNTER
    - name: requestduration
      instanceName: requestduration.instance.{{ .Release.Namespace }}
      type: HISTOGRAM
      sample:
        expDecay:
          reservoirSize: 1024
          alpha: 0.015
    - name: responsesize
      instanceName: responsesize.instance.{{ .Release.Namespace }}
      type: HISTOGRAM
      sample:
        expDecay:
          reservoirSize: 1024
          alpha: 0.015
{{- end }}
