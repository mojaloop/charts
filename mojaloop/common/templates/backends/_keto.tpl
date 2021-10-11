{{/*
Get fully qualified keto name.
*/}}
{{- define "common.backends.keto.fullname" -}}
  {{- if .Values.keto -}}
    {{- if .Values.keto.fullnameOverride -}}
      {{- .Values.keto.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
      {{- $name := default "keto" .Values.keto.nameOverride -}}
      {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
  {{- else -}}
    {{- $name := default "keto" .Values.keto.nameOverride -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end -}}

{{/*
Get keto read port.
*/}}
{{- define "common.backends.keto.readPort" -}}
  {{- default 4466 (default .Values.global.keto.readPort .Values.keto.readPort) -}}
{{- end -}}

{{/*
Get keto write port.
*/}}
{{- define "common.backends.keto.writePort" -}}
  {{- default 4467 (default .Values.global.keto.writePort .Values.keto.writePort) -}}
{{- end -}}

{{/*
Get keto read URL.
*/}}
{{- define "common.backends.keto.readURL" -}}
  {{- default "http://keto-read:80" (default .Values.global.keto.readURL .Values.keto.readURL) -}}
{{- end -}}

{{/*
Get keto write URL.
*/}}
{{- define "common.backends.keto.writeURL" -}}
  {{- default "http://keto-write:80" (default .Values.global.keto.writeURL .Values.keto.writeURL) -}}
{{- end -}}

{{/*
Get fully qualified keto host.
*/}}
{{- define "common.backends.keto.host" -}}
  {{- default (include "common.backends.keto.fullname" .) (default .Values.global.keto.host .Values.keto.host) -}}
{{- end -}}
