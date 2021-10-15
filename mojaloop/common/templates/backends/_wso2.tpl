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
Get wso2 introspection url.
*/}}
{{- define "common.backends.wso2.introspectionURL" -}}
  {{- default 4467 (default .Values.global.wso2.introspectionURL .Values.wso2.introspectionURL) -}}
{{- end -}}
