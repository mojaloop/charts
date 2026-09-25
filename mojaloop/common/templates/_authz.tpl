{{/*
  Keying a route's backend for the IAM.

  A route names, per backend, the permission prefix that backend's operations
  answer under. A backend serving an API describes it in its own OpenAPI
  document, which the IAM reads from it. A surface with no API to describe —
  a single-page application, an API admitted or refused as a unit — is one
  permission over its whole mount: the chart names that one operation and
  writes its document here, and the route names that document.

    authz:
      service: ""          # the permission prefix; the deployment's to say
      operationId: view    # only for a surface with no API of its own
      title: Mojaloop Portal Roles UI
      summary: Opens the role administration view

  Usage, with the name of the Service the route sends to:
    metadata:
      {{- include "common.authz.annotations" (dict "backend" $name "authz" .Values.authz) | nindent 2 }}

    {{ include "common.authz.document" (dict "context" . "backend" $name "authz" .Values.authz) }}
*/}}
{{- define "common.authz.annotations" -}}
{{- with .authz }}
{{- if .service }}
annotations:
  iam.mojaloop.io/{{ $.backend }}.service: {{ .service | quote }}
  {{- if .operationId }}
  iam.mojaloop.io/{{ $.backend }}.schema: {{ $.backend | quote }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "common.authz.document" -}}
{{- with .authz }}
{{- if and .service .operationId }}
apiVersion: mojaloop.io/v1
kind: AuthzDocument
metadata:
  name: {{ $.backend }}
  namespace: {{ $.context.Release.Namespace | quote }}
spec:
  document:
    openapi: 3.1.0
    info:
      title: {{ required "authz.title is required" .title | quote }}
      version: '1.0'
    servers:
      - url: /
    paths:
      /:
        get:
          operationId: {{ .operationId | quote }}
          summary: {{ required "authz.summary is required: it is what an operator reads when granting this" .summary | quote }}
          x-authz:
            scopedBy: []
          responses:
            '200':
              description: The surface
{{- end }}
{{- end }}
{{- end }}
