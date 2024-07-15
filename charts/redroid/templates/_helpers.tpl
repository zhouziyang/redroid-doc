{{/*
Expand the name of the chart.
*/}}
{{- define "redroid.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "redroid.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "redroid.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "redroid.labels" -}}
helm.sh/chart: {{ include "redroid.chart" . }}
{{ include "redroid.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "redroid.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redroid.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "redroid.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "redroid.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "redroid.imagePullSecrets" -}}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
- name: {{ . }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Return the proper redroid image
*/}}
{{- define "redroid.image" -}}
{{- $repositoryName := .Values.redroid.image.repository -}}
{{- $tag := .Values.redroid.image.tag | toString -}}
{{- if .Values.global.imageRegistry }}
    {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
{{- else -}}
    {{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
PVC for Data partition
*/}}
{{- define "redroid.pvc" -}}
{{ .Values.persistence.existingClaim | default (include "redroid.fullname" .) }}
{{- end -}}

