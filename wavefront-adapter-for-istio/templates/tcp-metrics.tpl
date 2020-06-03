{{/* Generate tcp metrics */}}
{{- define "metrics.tcp" }}
    - name: tcpsentbytes
      instanceName: tcpsentbytes.instance.{{ .Release.Namespace }}
      type: HISTOGRAM
      sample:
        expDecay:
          reservoirSize: 1024
          alpha: 0.015
    - name: tcpreceivedbytes
      instanceName: tcpreceivedbytes.instance.{{ .Release.Namespace }}
      type: HISTOGRAM
      sample:
        expDecay:
          reservoirSize: 1024
          alpha: 0.015
    - name: tcpconnectionsopened
      instanceName: tcpconnectionsopened.instance.{{ .Release.Namespace }}
      type: HISTOGRAM
      sample:
        expDecay:
          reservoirSize: 1024
          alpha: 0.015
    - name: tcpconnectionsclosed
      instanceName: tcpconnectionsclosed.instance.{{ .Release.Namespace }}
      type: HISTOGRAM
      sample:
        expDecay:
          reservoirSize: 1024
          alpha: 0.015
{{- end }}
