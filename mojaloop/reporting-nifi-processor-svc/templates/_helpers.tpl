{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper main image name
*/}}
{{- define "reporting-nifi-processor-svc.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "reporting-nifi-processor-svc.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "reporting-nifi-processor-svc.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "reporting-nifi-processor-svc.serviceAccountName" -}}
{{- if .Values.sts.serviceAccount.create -}}
    {{ default (printf "%s" (include "common.names.fullname" .)) .Values.sts.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.sts.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "reporting-nifi-processor-svc.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}


{{/*
Form the Zookeeper Server part of the URL. If zookeeper is installed as part of this chart, use k8s service discovery,
else use user-provided server name
*/}}
{{- define "zookeeper.server" }}
{{- if .Values.zookeeper.enabled -}}
{{- printf "%s-zookeeper" .Release.Name }}
{{- else -}}
{{- printf "%s" .Values.zookeeper.url }}
{{- end -}}
{{- end -}}

{{/*
Form the Zookeeper URL and port. If zookeeper is installed as part of this chart, use k8s service discovery,
else use user-provided name and port
*/}}
{{- define "zookeeper.url" }}
{{- $port := .Values.zookeeper.port | toString }}
{{- if .Values.zookeeper.enabled -}}
{{- printf "%s-zookeeper:%s" .Release.Name $port }}
{{- else -}}
{{- printf "%s:%s" .Values.zookeeper.url $port }}
{{- end -}}
{{- end -}}
