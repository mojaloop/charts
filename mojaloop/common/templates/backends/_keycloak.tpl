{{/*
Get fully qualified keto name.
*/}}
{{- define "common.backends.keycloak.fullname" -}}
  {{- if .Values.keycloak -}}
    {{- if .Values.keycloak.fullnameOverride -}}
      {{- .Values.keycloak.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
      {{- $name := default "wso2" .Values.keycloak.nameOverride -}}
      {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
  {{- else -}}
    {{- $name := default "wso2" .Values.keycloak.nameOverride -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end -}}

{{/*
Get keycloak url.
*/}}
{{- define "common.backends.keycloak.url" -}}
  {{- default "http://keycloak:8080" (default .Values.global.keycloak.url .Values.keycloak.url) -}}
{{- end -}}

{{/*
Get keycloak username.
*/}}
{{- define "common.backends.keycloak.user" -}}
  {{- default "admin" (default .Values.global.keycloak.user .Values.keycloak.user) -}}
{{- end -}}

{{/*
Get keycloak password.
*/}}
{{- define "common.backends.keycloak.password" -}}
  {{- default "admin" (default .Values.global.keycloak.password .Values.keycloak.password) -}}
{{- end -}}

{{/*
Get keycloak realm.
*/}}
{{- define "common.backends.keycloak.realm" -}}
  {{- default "master" (default .Values.global.keycloak.realm .Values.keycloak.realm) -}}
{{- end -}}

{{/*
Get keycloak secret.name
*/}}
{{- define "common.backends.keycloak.secret.name" -}}
  {{- default "keycloak-admin-creds" (default .Values.global.keycloak.secret.name .Values.keycloak.secret.name) -}}
{{- end -}}

{{/*
Get keycloak secret.key
*/}}
{{- define "common.backends.keycloak.secret.key" -}}
  {{- default "password" (default .Values.global.keycloak.secret.key .Values.keycloak.secret.key) -}}
{{- end -}}

