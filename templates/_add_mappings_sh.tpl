{{- define "add_mappings_sh" }}
#!/bin/bash

for idp in `curl {{ .Values.tuakiri.metadata_url }} | grep entityID= | grep -o entityID.* | cut -f2 -d '"'`
do
  manuka-manage add-domain-mapping {{ .Values.tuakiri.domain_id }} $idp
done
{{- if .Values.tuakiri.keycloak_alias }}

# OpenID Connect logins carry the alias of the identity provider that
# brokered them instead of an IdP entityID.
manuka-manage add-domain-mapping {{ .Values.tuakiri.domain_id }} {{ .Values.tuakiri.keycloak_alias }}
{{- end }}

{{- end }}
