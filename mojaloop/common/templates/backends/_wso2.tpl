{{/*
Get fully qualified keto name.
*/}}
{{- define "common.backends.wso2.fullname" -}}
  {{- if .Values.wso2 -}}
    {{- if .Values.wso2.fullnameOverride -}}
      {{- .Values.wso2.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
      {{- $name := default "wso2" .Values.wso2.nameOverride -}}
      {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
  {{- else -}}
    {{- $name := default "wso2" .Values.wso2.nameOverride -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end -}}

{{/*
Get wso2 identity-server host.
*/}}
{{- define "common.backends.wso2.identityServer.host" -}}
  {{- default "localhost" (default .Values.global.wso2.identityServer.host .Values.wso2.identityServer.host) -}}
{{- end -}}

{{/*
Get wso2 identity-server port.
*/}}
{{- define "common.backends.wso2.identityServer.port" -}}
  {{- default 4467 (default .Values.global.wso2.identityServer.port .Values.wso2.identityServer.port) -}}
{{- end -}}

{{/*
Get wso2 identity-server username.
*/}}
{{- define "common.backends.wso2.identityServer.username" -}}
  {{- default "admin" (default .Values.global.wso2.identityServer.username .Values.wso2.identityServer.username) -}}
{{- end -}}

{{/*
Get wso2 identity-server password.
*/}}
{{- define "common.backends.wso2.identityServer.password" -}}
  {{- default "admin" (default .Values.global.wso2.identityServer.password .Values.wso2.identityServer.password) -}}
{{- end -}}

{{/*
Get wso2 identity-server secretName (contains username and password).
*/}}
{{- define "common.backends.wso2.identityServer.secretName" -}}
  {{- default "wso2-is-admin-creds" (default .Values.global.wso2.identityServer.secretName .Values.wso2.identityServer.secretName) -}}
{{- end -}}

{{/*
Get wso2 user list url.
*/}}
{{- define "common.backends.wso2.identityServer.userListURL" -}}
  {{- default "http://wso2-identity-server.local:9443/scim2/Users" (default .Values.global.wso2.identityServer.userListURL .Values.wso2.identityServer.userListURL) -}}
{{- end -}}

{{/*
Get wso2 introspection url.
*/}}
{{- define "common.backends.wso2.identityServer.introspectionURL" -}}
  {{- default "https://wso2-identity-server.local:9443/oauth2/introspect" (default .Values.global.wso2.identityServer.introspectionURL .Values.wso2.identityServer.introspectionURL) -}}
{{- end -}}
