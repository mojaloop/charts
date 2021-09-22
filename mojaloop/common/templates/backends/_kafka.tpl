{{/*
Get fully qualified kafka name.
*/}}
{{- define "common.kafka.fullname" -}}
  {{- if .Values.kafka -}}
    {{- if .Values.kafka.fullnameOverride -}}
      {{- .Values.kafka.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
      {{- $name := default "kafka" .Values.kafka.nameOverride -}}
      {{ printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
    {{- end -}}
  {{- else -}}
    {{- $name := default "kafka" .Values.kafka.nameOverride -}}
    {{ printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
  {{- end -}}
{{- end -}}

{{/*
Get kafka port.
*/}}
{{- define "common.kafka.port" -}}
  {{- if .Values.kafka -}}
    {{- if .Values.kafka.port -}}
        {{- default 9092 .Values.kafka.port -}}
    {{- else -}}
      {{- if .Values.global -}}
        {{- if .Values.global.kafka -}}
          {{- if .Values.global.kafka.port -}}
            {{- default 9092 .Values.global.kafka.port -}}
          {{- else -}}
            {{- print "9092" -}}
          {{- end -}}
        {{- else -}}
          {{- print "9092" -}}
        {{- end -}}
      {{- else -}}
        {{- print "9092" -}}  
      {{- end -}}
    {{- end -}}
  {{- else -}}
    {{- if .Values.global -}}
      {{- if .Values.global.kafka -}}
        {{- if .Values.global.kafka.port -}}
          {{- default 9092 .Values.global.kafka.port -}}
        {{- else -}}
          {{- print "9092" -}}
        {{- end -}}
      {{- else -}}
        {{- print "9092" -}}
      {{- end -}}
    {{- else -}}
      {{- print "9092" -}}  
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Get fully qualified kafka host.
*/}}
{{- define "common.kafka.host" -}}
  {{- if .Values.kafka -}}
    {{- if .Values.kafka.host -}}
      {{ printf "%s" .Values.kafka.host }}
    {{- else -}}
      {{- if .Values.global -}}
        {{- if .Values.global.kafka -}}
          {{- if .Values.global.kafka.host -}}
            {{- printf "%s" .Values.global.kafka.host -}}
          {{- else -}}
            {{- printf "%s" (include "common.kafka.fullname" .) -}}
          {{- end -}}
        {{- else -}}
          {{- printf "%s" (include "common.kafka.fullname" .) -}}  
        {{- end -}}
      {{- else -}}
        {{- printf "%s" (include "common.kafka.fullname" .) -}}  
      {{- end -}}
    {{- end -}}
  {{- else -}}
    {{- if .Values.global -}}
      {{- if .Values.global.kafka -}}
        {{- if .Values.global.kafka.host -}}
          {{- printf "%s" .Values.global.kafka.host -}}
        {{- else -}}
          {{- printf "%s" (include "common.kafka.fullname" .) -}}
        {{- end -}}
      {{- else -}}
        {{- printf "%s" (include "common.kafka.fullname" .) -}}  
      {{- end -}}
    {{- else -}}
      {{- printf "%s" (include "common.kafka.fullname" .) -}}  
    {{- end -}}
  {{- end -}}
{{- end -}}
