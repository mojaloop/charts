{{/*
Get fully qualified keto name.
*/}}
{{- define "common.backends.oathkeeper.fullname" -}}
  {{- if .Values.oathkeeper -}}
    {{- if .Values.oathkeeper.fullnameOverride -}}
      {{- .Values.oathkeeper.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
      {{- $name := default "oathkeeper" .Values.oathkeeper.nameOverride -}}
      {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
  {{- else -}}
    {{- $name := default "oathkeeper" .Values.oathkeeper.nameOverride -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end -}}

{{/*
Get oathkeeper proxy port.
*/}}
{{- define "common.backends.oathkeeper.proxy.port" -}}
  {{- default 4455 .Values.oathkeeper.service.proxy.port -}}
{{- end -}}

{{/*
Get oathkeeper API port.
*/}}
{{- define "common.backends.oathkeeper.api.port" -}}
  {{- default 4456 .Values.oathkeeper.service.api.port -}}
{{- end -}}

{{/*
Get proxy service URL
*/}}
{{- define "common.backends.oathkeeper.proxy.ServiceURL" -}}
  {{- printf "http://%s-proxy:$s" (include "common.backends.oathkeeper.fullname" .) (include "common.backends.oathkeeper.proxy.port" .) -}}
{{- end -}}