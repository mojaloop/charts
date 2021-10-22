{{/*
Get fully qualified mongodb name.
*/}}
{{- define "common.backends.mongodb.fullname" -}}
  {{- if .Values.mongodb -}}
    {{- if .Values.mongodb.fullnameOverride -}}
      {{- .Values.mongodb.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
      {{- $name := default "mongodb" .Values.mongodb.nameOverride -}}
      {{ printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
    {{- end -}}
  {{- else -}}
    {{- $name := default "mongodb" .Values.mongodb.nameOverride -}}
    {{ printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
  {{- end -}}
{{- end -}}

{{/*
Get mongodb port.
*/}}
{{- define "common.backends.mongodb.port" -}}
  {{- default 3306 (default .Values.global.mongodb.port .Values.mongodb.port) -}}
{{- end -}}


{{/*
Get fully qualified mongodb host.
*/}}
{{- define "common.backends.mongodb.host" -}}
  {{- default (include "common.backends.mongodb.fullname" .) (default .Values.global.mongodb.host .Values.mongodb.host) -}}
{{- end -}}

{{/*
Get mongodb user.
*/}}
{{- define "common.backends.mongodb.user" -}}
  {{- default "nouser" (default .Values.global.mongodb.user .Values.mongodb.user) -}}
{{- end -}}

{{/*
Get mongodb database.
*/}}
{{- define "common.backends.mongodb.database" -}}
  {{- default "nodatabase" (default .Values.global.mongodb.database .Values.mongodb.database) -}}
{{- end -}}

{{/*
Get fully qualified mongodb secret.name
*/}}
{{- define "common.backends.mongodb.secret.name" -}}
  {{- default (include "common.backends.mongodb.fullname" .) (default .Values.global.mongodb.secret.name .Values.mongodb.secret.name) -}}
{{- end -}}

{{/*
Get fully qualified mongodb secret.key
*/}}
{{- define "common.backends.mongodb.secret.key" -}}
  {{- default (include "common.backends.mongodb.fullname" .) (default .Values.global.mongodb.secret.key .Values.mongodb.secret.key) -}}
{{- end -}}
