
{{/* vim: set filetype=mustache: */}}
{{/*
Validate Redis&trade; required passwords are not empty.

Usage:
{{ include "moja.common.validations.values.redis.passwords" (dict "secret" "secretName" "subchart" false "context" $) }}
Params:
  - secret - String - Required. Name of the secret where redis values are stored, e.g: "redis-passwords-secret"
  - subchart - Boolean - Optional. Whether redis is used as subchart or not. Default: false
*/}}
{{- define "moja.common.validations.values.redis.passwords" -}}
  {{- $enabled := include "moja.common.redis.values.enabled" . -}}
  {{- $valueKeyPrefix := include "moja.common.redis.values.keys.prefix" . -}}
  {{- $standarizedVersion := include "moja.common.redis.values.standarized.version" . }}

  {{- $existingSecret := ternary (printf "%s%s" $valueKeyPrefix "auth.existingSecret") (printf "%s%s" $valueKeyPrefix "existingSecret") (eq $standarizedVersion "true") }}
  {{- $existingSecretValue := include "moja.common.utils.getValueFromKey" (dict "key" $existingSecret "context" .context) }}

  {{- $valueKeyRedisPassword := ternary (printf "%s%s" $valueKeyPrefix "auth.password") (printf "%s%s" $valueKeyPrefix "password") (eq $standarizedVersion "true") }}
  {{- $valueKeyRedisUseAuth := ternary (printf "%s%s" $valueKeyPrefix "auth.enabled") (printf "%s%s" $valueKeyPrefix "usePassword") (eq $standarizedVersion "true") }}

  {{- if and (not $existingSecretValue) (eq $enabled "true") -}}
    {{- $requiredPasswords := list -}}

    {{- $useAuth := include "moja.common.utils.getValueFromKey" (dict "key" $valueKeyRedisUseAuth "context" .context) -}}
    {{- if eq $useAuth "true" -}}
      {{- $requiredRedisPassword := dict "valueKey" $valueKeyRedisPassword "secret" .secret "field" "redis-password" -}}
      {{- $requiredPasswords = append $requiredPasswords $requiredRedisPassword -}}
    {{- end -}}

    {{- include "moja.common.validations.values.multiple.empty" (dict "required" $requiredPasswords "context" .context) -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for enabled redis.

Usage:
{{ include "moja.common.redis.values.enabled" (dict "context" $) }}
*/}}
{{- define "moja.common.redis.values.enabled" -}}
  {{- if .subchart -}}
    {{- printf "%v" .context.Values.redis.enabled -}}
  {{- else -}}
    {{- printf "%v" (not .context.Values.enabled) -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right prefix path for the values

Usage:
{{ include "moja.common.redis.values.key.prefix" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether redis is used as subchart or not. Default: false
*/}}
{{- define "moja.common.redis.values.keys.prefix" -}}
  {{- if .subchart -}}redis.{{- else -}}{{- end -}}
{{- end -}}

{{/*
Checks whether the redis chart's includes the standarizations (version >= 14)

Usage:
{{ include "moja.common.redis.values.standarized.version" (dict "context" $) }}
*/}}
{{- define "moja.common.redis.values.standarized.version" -}}

  {{- $standarizedAuth := printf "%s%s" (include "moja.common.redis.values.keys.prefix" .) "auth" -}}
  {{- $standarizedAuthValues := include "moja.common.utils.getValueFromKey" (dict "key" $standarizedAuth "context" .context) }}

  {{- if $standarizedAuthValues -}}
    {{- true -}}
  {{- end -}}
{{- end -}}
