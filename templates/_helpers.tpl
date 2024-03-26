{{/*
Expand the name of the chart.
*/}}
{{- define "manuka.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "manuka.fullname" -}}
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
{{- define "manuka.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "manuka.labels" -}}
helm.sh/chart: {{ include "manuka.chart" . }}
{{ include "manuka.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "manuka.selectorLabels" -}}
app.kubernetes.io/name: {{ include "manuka.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "manuka.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "manuka.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Vault annotations
*/}}
{{- define "manuka.vaultAnnotations" -}}
vault.hashicorp.com/role: "{{ .Values.vault.role }}"
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/agent-pre-populate-only: "true"
vault.hashicorp.com/agent-inject-status: "update"
{{- if not .Values.conf.fake_shib }}
vault.hashicorp.com/agent-inject-secret-backendcert.pem: "{{ .Values.vault.shibcert }}"
vault.hashicorp.com/agent-inject-template-backendcert.pem: |
  {{ print "{{- with secret \"" .Values.vault.shibcert "\" -}}" }}
  {{ print "{{ .Data.data.cert }}" }}
  {{ print "{{- end -}}" }}
vault.hashicorp.com/agent-inject-secret-backendkey.pem: "{{ .Values.vault.shibcert }}"
vault.hashicorp.com/agent-inject-template-backendkey.pem: |
  {{ print "{{- with secret \"" .Values.vault.shibcert "\" -}}" }}
  {{ print "{{ .Data.data.key }}" }}
  {{ print "{{- end -}}" }}
{{- end }}
vault.hashicorp.com/secret-volume-path-secrets.conf: /etc/manuka/manuka.conf.d
vault.hashicorp.com/agent-inject-secret-secrets.conf: "{{ .Values.vault.settings_secret }}"
vault.hashicorp.com/agent-inject-template-secrets.conf: |
  {{ print "{{- with secret \"" .Values.vault.settings_secret "\" -}}" }}
{{- if not .Values.conf.transport_url }}
  {{ print "[DEFAULT]" }}
  {{ print "transport_url={{ .Data.data.transport_url }}" }}
{{- end }}
{{- if not .Values.conf.database.connection }}
  {{ print "[database]" }}
  {{ print "connection={{ .Data.data.database_connection }}" }}
{{- end }}
  {{ print "[flask]" }}
  {{ print "secret_key={{ .Data.data.flask_secret_key }}" }}
  {{ print "[orcid]" }}
  {{ print "key={{ .Data.data.orcid_key }}" }}
  {{ print "secret={{ .Data.data.orcid_secret }}" }}
  {{ print "[keystone_authtoken]" }}
  {{ print "password={{ .Data.data.keystone_password }}" }}
  {{ print "[keystone]" }}
  {{ print "authenticate_password={{ .Data.data.keystone_authenticate_password }}" }}
  {{ print "[service_auth]" }}
  {{ print "password={{ .Data.data.keystone_password }}" }}
  {{ print "[freshdesk]" }}
  {{ print "key={{ .Data.data.freshdesk_key }}" }}
  {{ print "{{- end -}}" }}
{{- end }}
