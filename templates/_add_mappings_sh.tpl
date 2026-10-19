{{- define "add_mappings_sh" }}
#!/bin/bash

for idp in `curl {{ .Values.tuakiri.metadata_url }} | grep entityID= | grep -o entityID.* | cut -f2 -d '"'`
do
  manuka-manage add-domain-mapping {{ .Values.tuakiri.domain_id }} $idp
done

{{- end }}
