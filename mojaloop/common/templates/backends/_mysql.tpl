{{/*
Get fully qualified mysql name.
*/}}
{{- define "common.backends.mysql.fullname" -}}
  {{- if .Values.mysql -}}
    {{- if .Values.mysql.fullnameOverride -}}
      {{- .Values.mysql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
      {{- $name := default "mysql" .Values.mysql.nameOverride -}}
      {{ printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
    {{- end -}}
  {{- else -}}
    {{- $name := default "mysql" .Values.mysql.nameOverride -}}
    {{ printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
  {{- end -}}
{{- end -}}

{{/*
Get mysql port.
*/}}
{{- define "common.backends.mysql.port" -}}
  {{- default 3306 (default .Values.global.mysql.port .Values.mysql.port) -}}
{{- end -}}


{{/*
Get fully qualified mysql host.
*/}}
{{- define "common.backends.mysql.host" -}}
  {{- default (include "common.backends.mysql.fullname" .) (default .Values.global.mysql.host .Values.mysql.host) -}}
{{- end -}}

{{/*
Get mysql user.
*/}}
{{- define "common.backends.mysql.user" -}}
  {{- default "nouser" (default .Values.global.mysql.user .Values.mysql.user) -}}
{{- end -}}

{{/*
Get mysql database.
*/}}
{{- define "common.backends.mysql.database" -}}
  {{- default "nodatabase" (default .Values.global.mysql.database .Values.mysql.database) -}}
{{- end -}}

{{/*
Get fully qualified mysql secret.name
*/}}
{{- define "common.backends.mysql.secret.name" -}}
  {{- default (include "common.backends.mysql.fullname" .) (default .Values.global.mysql.secret.name .Values.mysql.secret.name) -}}
{{- end -}}

{{/*
Get fully qualified mysql secret.key
*/}}
{{- define "common.backends.mysql.secret.key" -}}
  {{- default (include "common.backends.mysql.fullname" .) (default .Values.global.mysql.secret.key .Values.mysql.secret.key) -}}
{{- end -}}
