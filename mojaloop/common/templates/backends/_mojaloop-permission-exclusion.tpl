{{/*
Get MojaloopRole resourceKind.
*/}}
{{- define "common.backends.mojaloopPermissionExclusion.resourceKind" -}}
  {{- default "MojaloopPermissionExclusion" (default .Values.global.mojaloopPermissionExclusion.resourceKind .Values.mojaloopPermissionExclusion.resourceKind) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceListKind.
*/}}
{{- define "common.backends.mojaloopPermissionExclusion.resourceListKind" -}}
  {{- default "MojaloopPermissionExclusionsList" (default .Values.global.mojaloopPermissionExclusion.resourceListKind .Values.mojaloopPermissionExclusion.resourceListKind) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceGroup.
*/}}
{{- define "common.backends.mojaloopPermissionExclusion.resourceGroup" -}}
  {{- default "mojaloop.io" (default .Values.global.mojaloopPermissionExclusion.resourceGroup .Values.mojaloopPermissionExclusion.resourceGroup) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceVersion.
*/}}
{{- define "common.backends.mojaloopPermissionExclusion.resourceVersion" -}}
  {{- default "v1" (default .Values.global.mojaloopPermissionExclusion.resourceVersion .Values.mojaloopPermissionExclusion.resourceVersion) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceSingular.
*/}}
{{- define "common.backends.mojaloopPermissionExclusion.resourceSingular" -}}
  {{- default "mojaloop-permission-exclusion" (default .Values.global.mojaloopPermissionExclusion.resourceSingular .Values.mojaloopPermissionExclusion.resourceSingular) -}}
{{- end -}}

{{/*
Get MojaloopRole resourcePlural.
*/}}
{{- define "common.backends.mojaloopPermissionExclusion.resourcePlural" -}}
  {{- default "mojaloop-permission-exclusions" (default .Values.global.mojaloopPermissionExclusion.resourcePlural .Values.mojaloopPermissionExclusion.resourcePlural) -}}
{{- end -}}
