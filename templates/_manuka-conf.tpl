{{- define "manuka-conf" }}
[DEFAULT]
# Expose oslo.messaging's RPC server ping endpoint so the worker
# startup probe (nectar-health-probe rpc-ping) can call it.
rpc_ping_enabled=true
# Same value manuka sets in code; stated here so external tools such
# as nectar-health-probe see the right exchange from config alone.
control_exchange=manuka
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

[sentry]
environment={{ .Values.conf.sentry.environment }}

[flask]
session_cookie_secure={{ .Values.conf.flask.session_cookie_secure }}

[oidc]
enabled={{ .Values.conf.oidc.enabled }}
{{- if .Values.conf.oidc.issuer }}
issuer={{ .Values.conf.oidc.issuer }}
{{- end }}
client_id={{ .Values.conf.oidc.client_id }}
{{- if .Values.conf.oidc.redirect_url }}
redirect_url={{ .Values.conf.oidc.redirect_url }}
{{- end }}
{{- if .Values.conf.oidc.scopes }}
scopes={{ join "," .Values.conf.oidc.scopes }}
{{- end }}
use_userinfo_endpoint={{ .Values.conf.oidc.use_userinfo_endpoint }}
session_timeout={{ .Values.conf.oidc.session_timeout }}
link_timeout={{ .Values.conf.oidc.link_timeout }}
eppn_autolink_max_age_days={{ .Values.conf.oidc.eppn_autolink_max_age_days }}
deny_on_identity_drift={{ .Values.conf.oidc.deny_on_identity_drift }}
prompt_saml_users={{ .Values.conf.oidc.prompt_saml_users }}
{{- if .Values.conf.oidc.post_logout_redirect_url }}
post_logout_redirect_url={{ .Values.conf.oidc.post_logout_redirect_url }}
{{- end }}
{{- if .Values.conf.oidc.fake }}
fake=True
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

[oslo_messaging_notifications]
driver = messagingv2

[oslo_policy]
policy_file=/etc/manuka/policy.yaml

[oslo_middleware]
enable_proxy_headers_parsing={{ .Values.conf.oslo_middleware.enable_proxy_headers_parsing }}

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
default_redirect_url={{ .Values.conf.orcid.default_redirect_url }}
{{- end }}
