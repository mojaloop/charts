{{/*
Get fully qualified reporting-db name.
*/}}
{{- define "common.backends.reporting-db.fullname" -}}
  {{- if .Values.reporting-db -}}
    {{- if .Values.reporting-db.fullnameOverride -}}
      {{- .Values.reporting-db.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
      {{- $name := default "reporting-db" .Values.reporting-db.nameOverride -}}
      {{ printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
    {{- end -}}
  {{- else -}}
    {{- $name := default "reporting-db" .Values.reporting-db.nameOverride -}}
    {{ printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
  {{- end -}}
{{- end -}}

{{/*
Get reporting-db port.
*/}}
{{- define "common.backends.reporting-db.port" -}}
  {{- default 3306 (default .Values.global.reporting-db.port .Values.reporting-db.port) -}}
{{- end -}}


{{/*
Get fully qualified reporting-db host.
*/}}
{{- define "common.backends.reporting-db.host" -}}
  {{- default (include "common.backends.reporting-db.fullname" .) (default .Values.global.reporting-db.host .Values.reporting-db.host) -}}
{{- end -}}

{{/*
Get reporting-db user.
*/}}
{{- define "common.backends.reporting-db.user" -}}
  {{- default "nouser" (default .Values.global.reporting-db.user .Values.reporting-db.user) -}}
{{- end -}}

{{/*
Get reporting-db database.
*/}}
{{- define "common.backends.reporting-db.database" -}}
  {{- default "nodatabase" (default .Values.global.reporting-db.database .Values.reporting-db.database) -}}
{{- end -}}

{{/*
Get fully qualified reporting-db secret.name
*/}}
{{- define "common.backends.reporting-db.secret.name" -}}
  {{- default (include "common.backends.reporting-db.fullname" .) (default .Values.global.reporting-db.secret.name .Values.reporting-db.secret.name) -}}
{{- end -}}

{{/*
Get fully qualified reporting-db secret.key
*/}}
{{- define "common.backends.reporting-db.secret.key" -}}
  {{- default (include "common.backends.reporting-db.fullname" .) (default .Values.global.reporting-db.secret.key .Values.reporting-db.secret.key) -}}
{{- end -}}
