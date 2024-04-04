{{- define "apache-conf" }}
{{- if not .Values.conf.fake_shib }}
<Location /Shibboleth.sso>
    SetHandler shib-handler
    Satisfy Any
</Location>

<IfModule mod_shib>
    <Location /login >
        SetHandler None
        AuthType shibboleth
        ShibRequireSession On
        require valid-user
    </Location>
</IfModule>
{{- end }}

<VirtualHost *:80>
  {{- if .Values.apache.servername }}
  ServerName {{ .Values.apache.servername }}
  {{- end }}

  DocumentRoot "/var/lib/manuka/"

  WSGIDaemonProcess manuka python-path=/usr/local/lib/python3.10/site-packages processes=1 threads=2 user=www-data group=www-data display-name=%{GROUP}
  WSGIProcessGroup manuka
  WSGIScriptAlias / /var/lib/manuka/wsgi.py
  WSGIApplicationGroup %{GLOBAL}
  ErrorLogFormat "%{cu}t %M"
  ErrorLog /dev/stdout

  <Directory /var/lib/manuka>
    Options -Indexes +FollowSymLinks +MultiViews
    AllowOverride None
    Require all granted
  </Directory>

  Alias /robots.txt "/var/lib/manuka/robots.txt"

  CustomLog /dev/stdout combined
  ErrorLog /dev/stdout

  ServerSignature Off
  SetEnvIf X-Forwarded-Proto https HTTPS=1

</VirtualHost>
{{- end }}
