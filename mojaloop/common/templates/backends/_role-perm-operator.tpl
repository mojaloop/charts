{{/*
Get MojaloopRole resourceKind.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopRole.resourceKind" -}}
  {{- default "MojaloopRole" (default .Values.global.rolePermOperator.mojaloopRole.resourceKind .Values.mojalooprole.resourceKind) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceListKind.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopRole.resourceListKind" -}}
  {{- default "MojaloopRoleList" (default .Values.global.rolePermOperator.mojaloopRole.resourceListKind .Values.mojalooprole.resourceListKind) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceGroup.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopRole.resourceGroup" -}}
  {{- default "mojaloop.io" (default .Values.global.rolePermOperator.mojaloopRole.resourceGroup .Values.mojalooprole.resourceGroup) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceVersion.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopRole.resourceVersion" -}}
  {{- default "v1" (default .Values.global.rolePermOperator.mojaloopRole.resourceVersion .Values.mojalooprole.resourceVersion) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceSingular.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopRole.resourceSingular" -}}
  {{- default "mojalooprole" (default .Values.global.rolePermOperator.mojaloopRole.resourceSingular .Values.mojalooprole.resourceSingular) -}}
{{- end -}}

{{/*
Get MojaloopRole resourcePlural.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopRole.resourcePlural" -}}
  {{- default "mojalooproles" (default .Values.global.rolePermOperator.mojaloopRole.resourcePlural .Values.mojalooprole.resourcePlural) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceKind.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopPermissionExclusion.resourceKind" -}}
  {{- default "MojaloopPermissionExclusion" (default .Values.global.rolePermOperator.mojaloopPermissionExclusion.resourceKind .Values.mojaloopPermissionExclusion.resourceKind) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceListKind.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopPermissionExclusion.resourceListKind" -}}
  {{- default "MojaloopPermissionExclusionsList" (default .Values.global.rolePermOperator.mojaloopPermissionExclusion.resourceListKind .Values.mojaloopPermissionExclusion.resourceListKind) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceGroup.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopPermissionExclusion.resourceGroup" -}}
  {{- default "mojaloop.io" (default .Values.global.rolePermOperator.mojaloopPermissionExclusion.resourceGroup .Values.mojaloopPermissionExclusion.resourceGroup) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceVersion.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopPermissionExclusion.resourceVersion" -}}
  {{- default "v1" (default .Values.global.rolePermOperator.mojaloopPermissionExclusion.resourceVersion .Values.mojaloopPermissionExclusion.resourceVersion) -}}
{{- end -}}

{{/*
Get MojaloopRole resourceSingular.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopPermissionExclusion.resourceSingular" -}}
  {{- default "mojaloop-permission-exclusion" (default .Values.global.rolePermOperator.mojaloopPermissionExclusion.resourceSingular .Values.mojaloopPermissionExclusion.resourceSingular) -}}
{{- end -}}

{{/*
Get MojaloopRole resourcePlural.
*/}}
{{- define "common.backends.rolePermOperator.mojaloopPermissionExclusion.resourcePlural" -}}
  {{- default "mojaloop-permission-exclusions" (default .Values.global.rolePermOperator.mojaloopPermissionExclusion.resourcePlural .Values.mojaloopPermissionExclusion.resourcePlural) -}}
{{- end -}}

{{/*
Get Mojaloop operatorApiSvc port.
*/}}
{{- define "common.backends.rolePermOperator.apiSvc.port" -}}
  {{- default 80 (default .Values.global.adminApiSvc.port .Values.adminApiSvc.port) -}}
{{- end -}}

{{/*
Get fully qualified Mojaloop operatorApiSvc host.
*/}}
{{- define "common.backends.rolePermOperator.apiSvc.host" -}}
  {{- default (include "common.backends.mojaloop.adminApiSvc.fullname" .) (default .Values.global.adminApiSvc.host .Values.adminApiSvc.host) -}}
{{- end -}}