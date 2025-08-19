{{- define "jupiter-chart.chart" -}}
{{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end }}

{{/* Expand the chart name. */}}
{{- define "jupiter-chart.name" -}}
{{- default .Values.nameOverride .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "jupiter-chart.fullname" -}}
{{- if .Values.fullnameOverride -}}
  {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- if contains "RELEASE-NAME" .Release.Name -}}
    {{- default .Values.nameOverride .Chart.Name | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- $name := default .Values.nameOverride .Release.Name -}}
    {{- $name | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/* Chart labels. */}}
{{- define "jupiter-chart.labels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
helm.sh/chart: {{ include "jupiter-chart.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels. */}}
{{- define "jupiter-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Service account name. */}}
{{- define "jupiter-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "jupiter-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Given a dictionary of variable=value pairs, render a container env block.
Environment variables are sorted alphabetically
*/}}
{{- define "jupiter-chart.renderEnv" -}}
{{- if . }}
  {{- if kindIs "slice" . }}
    {{- toYaml . }}
  {{- else }}
    {{- $envVars := list }}
    {{- range $key, $val := . }}
      {{- $envVar := dict "name" $key }}
      {{- $valueType := printf "%T" $val }}
      {{- if eq $valueType "map[string]interface {}" }}
        {{- $envVar = merge $envVar $val }}
      {{- else if eq $valueType "string" }}
        {{- if hasPrefix $val "vault:" }}
          {{- $envVar = set $envVar "valueFrom" (dict "secretKeyRef" (dict "name" (printf "%s-%s" $.Values.vault.app (lower $key)) "key" "value")) }}
        {{- else }}
          {{- $envVar = set $envVar "value" $val }}
        {{- end }}
      {{- else }}
        {{- $envVar = set $envVar "value" (printf "%v" $val) }}
      {{- end }}
      {{- $envVars = append $envVars $envVar }}
    {{- end }}
    {{- toYaml $envVars }}
  {{- end }}
{{- end }}
{{- end }}
