{{- define "apache-conf" }}
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


<VirtualHost *:80>
  ServerName {{ .Values.apache.server_name }}

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
  ErrorLog /dev/stderr

  ServerSignature Off
  SetEnvIf X-Forwarded-Proto https HTTPS=1

</VirtualHost>
{{- end }}
