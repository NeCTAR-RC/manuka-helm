{{- define "manuka-conf" }}
[DEFAULT]
terms_version={{ .Values.conf.terms_version }}
support_url={{ .Values.conf.support_url }}
default_target={{ .Values.conf.default_target }}
whitelist={{ join "," .Values.conf.whitelist }}
{{- if .Values.conf.fake_shib }}
fake_shib=True
{{- end }}
{{- if .Values.conf.transport_url }}
transport_url={{ .Values.conf.transport_url }}
{{- end }}
{{- if .Values.conf.notifier }}
notifier={{ .Values.conf.notifier }}
{{- end }}

{{- if .Values.conf.database.connection }}
[database]
connection={{ .Values.conf.database.connection }}
{{- end }}

[keystone]
auth_url={{ .Values.conf.keystone.auth_url }}v3/

[service_auth]
auth_url={{ .Values.conf.keystone.auth_url }}
username={{ .Values.conf.keystone.username }}
project_name={{ .Values.conf.keystone.project_name }}
user_domain_name=Default
project_domain_name=Default
auth_type=password

[swift]
default_quota_gb=10

[smtp]
from_email={{ .Values.conf.smtp.from_email }}

[oslo_messaging_rabbit]
{{- if .Values.conf.oslo_messaging_rabbit.ssl }}
ssl=True
{{- end }}
rabbit_quorum_queue=true
rabbit_transient_quorum_queue=true
rabbit_stream_fanout=true
rabbit_qos_prefetch_count=1

[oslo_policy]
policy_file=/etc/manuka/policy.yaml

[keystone_authtoken]
auth_url={{ .Values.conf.keystone.auth_url }}
www_authenticate_uri={{ .Values.conf.keystone.auth_url }}
username={{ .Values.conf.keystone.username }}
project_name={{ .Values.conf.keystone.project_name }}
user_domain_name=Default
project_domain_name=Default
auth_type=password
service_token_roles_required=True
{{- if .Values.conf.keystone.memcached_servers }}
memcached_servers={{ join "," .Values.conf.keystone.memcached_servers }}
{{- end }}

[freshdesk]
domain={{ .Values.conf.freshdesk.domain }}

[orcid]
sandbox={{ .Values.conf.orcid.sandbox }}

{{- end }}
