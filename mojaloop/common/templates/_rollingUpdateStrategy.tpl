{{- define "common.rollingUpdateStrategy" -}}
strategy:
   type: RollingUpdate
   rollingUpdate:
     maxUnavailable: {{ (.Values.rollingUpdate).maxUnavailable | default "25%" }}
     maxSurge: {{ (.Values.rollingUpdate).maxSurge | default "25%" }}
{{- end -}}
