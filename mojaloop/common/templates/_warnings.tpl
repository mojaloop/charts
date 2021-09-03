{{/* vim: set filetype=mustache: */}}
{{/*
Warning about using rolling tag.
Usage:
{{ include "moja.common.warnings.rollingTag" .Values.path.to.the.imageRoot }}
*/}}
{{- define "moja.common.warnings.rollingTag" -}}

{{- if and (contains "mojaloop/" .repository) (not (.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .repository }}:{{ .tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}

{{- end -}}
