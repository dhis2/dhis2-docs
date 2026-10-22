# Run DHIS2 with embedded Tomcat { #install_embedded_tomcat }
<!-- Author: Morten (Morty) <netroms@gmail.com> -->

## Overview { #install_embedded_tomcat_overview }

From DHIS2 2.44, the release WAR includes Tomcat and can run directly with
`java -jar dhis.war`. You do not need to install or manage a separate servlet
container. The same WAR can also be deployed in a compatible external Tomcat.

Choose embedded Tomcat when you want to manage a Java process and its WAR
rather than a separate Tomcat installation. It is production ready with a
reverse proxy, which is required for production TLS termination. The
[deployment options](#install_install_approaches) also cover automated
installation with Ansible server-tools, manual external Tomcat and containers;
embedded mode does not replace those workflows.

| DHIS2 version | Embedded deployment support | Executable release WAR |
|---|---|---|
| 2.42 | Not supported | No |
| 2.43 | Not supported | No |
| 2.44 and later | Supported | Yes |

Although embedded Tomcat exists in the 2.42 and 2.43 source, their executable
builds do not start as released; use 2.44 or later for embedded mode, or
[external Tomcat](#getting_started_linux_manual_install) for older versions.

## Prerequisites { #install_embedded_tomcat_prerequisites }

- Java 17 JRE for DHIS2 2.44. Check the target release's requirements when upgrading.
- PostgreSQL with PostGIS and the required database extensions. Follow the
  [database setup](#install_postgresql_installation) and use versions supported
  by your DHIS2 release.
- A dedicated, non-root operating-system user, such as
  [`dhis`](#install_creating_user).
- A persistent DHIS2 home directory, here `/opt/dhis2`, with a `dhis.conf`
  containing the [database connection settings](#install_database_configuration).
  The `dhis` user must be able to read the configuration and write application
  files and logs in this directory.
- A reverse proxy with a trusted TLS certificate for production.

The examples use `/opt/dhis2/dhis.war`. Keep the WAR readable but not writable
by the service user. Adjust paths and memory allocation for your installation;
the example heap sizes are not production sizing recommendations.

## Getting an executable dhis.war { #install_embedded_tomcat_get_war }

Download a specific DHIS2 2.44 or later release WAR from
[releases.dhis2.org](https://releases.dhis2.org/) and save it as `dhis.war`.
Record the exact release version so upgrades are deliberate and reproducible.
Check that the WAR has an executable entry point:

```sh
unzip -p dhis.war META-INF/MANIFEST.MF | grep Main-Class
```

The manifest should contain
`Main-Class: org.springframework.boot.loader.launch.WarLauncher`.
A conventional, non-executable WAR cannot be started with `java -jar`.

## Starting and stopping DHIS2 { #install_embedded_tomcat_start }

Run as the dedicated `dhis` user, from the directory containing the WAR:

```sh
DHIS2_HOME=/opt/dhis2 java -Xms512m -Xmx1536m -jar dhis.war
```

DHIS2 listens on port 8080 at the root context by default. Open
`http://localhost:8080/` for a local check. First startup initializes the
database and installs bundled apps; upgrades may run database migrations.
Watch the logs and allow migrations to complete before assuming startup has
failed. A failed application startup exits with status 1.

Stop a foreground process with Ctrl-C. A SIGTERM, including `systemctl stop`,
shuts down embedded Tomcat, closes the Spring application context and removes
its temporary directory. This is orderly application cleanup, not a guarantee
that every in-flight request or background job will finish. Avoid force-killing
the JVM during normal operation.

## Configuration { #install_embedded_tomcat_configuration }

Application settings remain in `DHIS2_HOME/dhis.conf`; see the
[configuration reference](#install_dhis2_configuration_reference). Embedded
server settings are Java system properties or environment variables, not
`dhis.conf` entries:

| Java system property | Environment variable | Default |
|---|---|---|
| `server.port` | `SERVER_PORT` | `8080` |
| `server.servlet.context.path` | `SERVER_SERVLET_CONTEXT_PATH` | Root context |
| `server.forward-headers-strategy` | `SERVER_FORWARD_HEADERS_STRATEGY` | `none` |
| `server.tomcat.remoteip.internal-proxies` | `SERVER_TOMCAT_REMOTEIP_INTERNAL_PROXIES` | Tomcat's default internal proxy list |

A `-D` system property takes precedence over its corresponding environment
variable. For example, serve the application at `http://localhost:9090/dhis2/`:

```sh
DHIS2_HOME=/opt/dhis2 java -Xmx1536m -Dserver.port=9090 -Dserver.servlet.context.path=/dhis2 -jar dhis.war
```

To select port 9091 and the same context using environment variables:

```sh
DHIS2_HOME=/opt/dhis2 SERVER_PORT=9091 SERVER_SERVLET_CONTEXT_PATH=/dhis2 java -jar dhis.war
```

For embedded startup, the DHIS2 home lookup checks `-Ddhis2.home`, then
`DHIS2_HOME`, then `/opt/dhis2`, using the first valid directory. Set it
explicitly so the service uses the intended configuration and storage.

> **Important**
>
> Put JVM options before `-jar`, or use `JAVA_TOOL_OPTIONS`. Arguments after
> `-jar dhis.war`, such as `--server.port=9090`, are ignored. Embedded mode does
> not read `setenv.sh`, `JAVA_OPTS`, `CATALINA_OPTS` or `server.xml`.

Tomcat creates a temporary base directory under the JVM's `java.io.tmpdir`.
Use `-Djava.io.tmpdir=/path/to/writable/temp` before `-jar` if necessary, and
ensure the service user has write access and sufficient space.

Set `server.forward-headers-strategy=native` behind a trusted reverse proxy.
This enables Tomcat to honor `X-Forwarded-For`, `X-Forwarded-Proto`,
`X-Forwarded-Port` and `X-Forwarded-Host`. The default is `none`.
Tomcat's default internal proxy list includes loopback and private networks;
restrict it to your proxy addresses where appropriate using
`-Dserver.tomcat.remoteip.internal-proxies=<value>` or
`SERVER_TOMCAT_REMOTEIP_INTERNAL_PROXIES`. The value is either a regular
expression matching proxy IP addresses, such as `127\.0\.0\.1`, or a
comma-separated list of CIDR ranges, such as `127.0.0.1/32, 10.0.0.0/8`. An
empty value trusts no proxy. Quote the value on the command line. Do not trust
arbitrary client-supplied forwarded headers.

Embedded mode has no `server.xml` configuration for a bind address, TLS,
access logging or connector tuning such as thread counts and header limits.
It binds all interfaces. Use the reverse proxy for TLS, access logs and request
limits, and a firewall or private network to restrict backend access.

## Running as a systemd service { #install_embedded_tomcat_systemd }

Create `/etc/systemd/system/dhis2.service` with the following content. Replace
`/usr/bin/java` with the path to your Java 17 executable if different, and
adjust the WAR path, DHIS2 home and heap sizes.

```ini
[Unit]
Description=DHIS2 with embedded Tomcat
After=postgresql.service

[Service]
Type=simple
User=dhis
Environment=DHIS2_HOME=/opt/dhis2
ExecStart=/usr/bin/java -Xms512m -Xmx1536m -jar /opt/dhis2/dhis.war
SuccessExitStatus=143
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

`After=postgresql.service` orders startup after a local PostgreSQL service;
it does not configure or check a remote database. For a proxied deployment,
add the forwarded-header environment setting described in the next section
to `[Service]` before starting.

```sh
sudo systemctl daemon-reload
sudo systemctl enable dhis2
sudo systemctl start dhis2
sudo systemctl status dhis2
sudo journalctl -u dhis2 --no-pager -n 150
```

Stop the instance with:

```sh
sudo systemctl stop dhis2
```

## Reverse proxy and TLS { #install_embedded_tomcat_reverse_proxy }

A reverse proxy is required for production. Terminate TLS there, redirect
public HTTP traffic to HTTPS, and use the following location block in nginx's
HTTPS server. This example assumes nginx and DHIS2 run on the same host:

```nginx
location / {
    proxy_pass http://127.0.0.1:8080;
    proxy_http_version 1.1;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Port $server_port;
}
```

Also add this directive inside the location block to overwrite any
client-supplied forwarded host when native handling is enabled:

```nginx
proxy_set_header X-Forwarded-Host $http_host;
```

Keep `proxy_http_version 1.1` and `Host $http_host`: nginx defaults can produce
HTTP redirects or lose a nonstandard public port. Preserve the context path
when proxying; if DHIS2 runs under `/dhis2`, publish it under that same path.

Enable trusted forwarded-header handling before `-jar`:

```sh
DHIS2_HOME=/opt/dhis2 java -Dserver.forward-headers-strategy=native -jar dhis.war
```

Alternatively, add this line to the systemd unit's `[Service]` section, then
reload the unit and restart the service:

```ini
Environment=SERVER_FORWARD_HEADERS_STRATEGY=native
```

In `dhis.conf`, set the public URL and enable Secure cookies:

```properties
server.base.url = https://dhis2.example.org
server.https = on
```

Include the public port and context path in `server.base.url` when applicable,
for example `https://dhis2.example.org:8443/dhis2`. These settings do not create
a TLS listener or replace forwarded-header handling. Configure HSTS at the
proxy; enable subdomain coverage only if all affected subdomains use HTTPS.
Firewall the application port so only the trusted proxy can reach it, even
when the proxy is on the same machine. Do not expose port 8080 to the internet.

> **Note**
>
> Without native forwarded-header handling, the default OIDC callback can use
> `http://` even when `server.base.url` uses HTTPS. With `native` and trusted
> HTTPS proxy headers it uses `https://`. You can also set
> `oidc.provider.<id>.redirect_url` explicitly, for example
> `https://dhis2.example.org/dhis2/oauth2/code/<id>`; include the actual context
> path and register the same callback with the identity provider. See
> [OAuth2 and OIDC configuration](#install_oauth2_oidc_configuration).

## Logging { #install_embedded_tomcat_logging }

DHIS2 writes to the console and to `DHIS2_HOME/logs/dhis.log`, with additional
files for analytics, data exchange and other components. Under systemd,
console output goes to journald; there is no external Tomcat `catalina.out`.

For a custom Log4j configuration, pass
`-Dlog4j2.configurationFile=/opt/dhis2/log4j2.properties` before `-jar`.
A custom configuration replaces the default logging setup, so define any
required file appenders there. See [application logging](#install_application_logging).

## Security notes { #install_embedded_tomcat_security }

Run DHIS2 as a non-root user. Protect `dhis.conf`, signing keys and backups
from other users, and keep the WAR read-only to the service user. Tomcat is
bundled inside the WAR: apply Tomcat security fixes by upgrading DHIS2, not by
upgrading an operating-system Tomcat package.

If you enable the OAuth2 authorization server, configure a persistent signing
keystore. Without `oauth2.server.jwt.keystore.*`, a new signing key is generated
on every start: previously issued access tokens are rejected after a restart,
but stored refresh tokens continue to work. This applies to external Tomcat
as well as embedded mode.

Create a PKCS12 keystore using the JDK's `keytool`, replacing the password
placeholder with a strong secret and protecting the resulting file. For
PKCS12, use the same password for the store and key:

```sh
keytool -genkeypair -alias dhis2-oauth2-signing -keyalg RSA -keysize 2048 -storetype PKCS12 \
  -keystore /opt/dhis2/oauth2-signing.p12 -storepass '<keystore-password>' -keypass '<keystore-password>' \
  -dname CN=dhis2-oauth2-signing -validity 3650
```

Give only the service user the required read access, retain this keystore
across upgrades, and add to `dhis.conf`:

```properties
oauth2.server.jwt.keystore.path = /opt/dhis2/oauth2-signing.p12
oauth2.server.jwt.keystore.password = <keystore-password>
oauth2.server.jwt.keystore.alias = dhis2-oauth2-signing
oauth2.server.jwt.keystore.key-password = <keystore-password>
```

See [persistent signing keystores](#oauth2_keystore) for the authorization
server configuration and key rotation considerations.

## Upgrading and migrating from external Tomcat { #install_embedded_tomcat_upgrade }

1. Read the target release notes and any intervening upgrade requirements.
   Rehearse the upgrade against a restored backup before changing production.
2. Back up the database, DHIS2 home and any external file storage, and verify
   that the backup is available before starting the newer version.
3. Stop DHIS2, replace the WAR with the exact release you selected, and retain
   `dhis.conf`, application files and signing keys.
4. Start DHIS2 and watch the logs for successful Flyway migrations. Confirm
   that you can log in and access the expected data.
5. After a major upgrade, regenerate analytics tables in Data Administration.

> **Important**
>
> Database migrations are forward-only. Replacing the WAR with an older version
> is not a rollback; restore the pre-upgrade backup and matching application
> version instead.

When moving from external Tomcat, stop the old instance before starting the
embedded one and translate the deployment settings:

| External Tomcat setting | Embedded equivalent |
|---|---|
| `setenv.sh` JVM options, `JAVA_OPTS` or `CATALINA_OPTS` | Options before `-jar`, or `JAVA_TOOL_OPTIONS` |
| `server.xml` HTTP connector port | `-Dserver.port` or `SERVER_PORT` |
| `server.xml` TLS and proxy settings | TLS at the reverse proxy, plus `server.forward-headers-strategy=native` |
| `ROOT.war` or a named application context | Root by default, or `-Dserver.servlet.context.path=/dhis2` |
| `DHIS2_HOME` and `dhis.conf` | Keep the same persistent directory and application configuration |

Test public URLs, login, integrations and OIDC callbacks through the proxy
before directing users to the new deployment.

## Docker images { #install_embedded_tomcat_docker }

The released `dhis2/core` images run external Tomcat. The `dhis2/core-dev`
images for 2.43 and later use embedded Tomcat, but are development builds,
not the supported release-WAR workflow described here. For production
container deployment, see [dhis2/docker-deployment](https://github.com/dhis2/docker-deployment).

## Troubleshooting { #install_embedded_tomcat_troubleshooting }

| Symptom | Check |
|---|---|
| `no main manifest attribute` | The WAR is not executable. Use a 2.44 or later release WAR and check its manifest. |
| Port already in use | Stop the conflicting process or select a free `server.port` before `-jar`. |
| Port or context option has no effect | Do not put options after `-jar dhis.war`; check for a system property overriding the environment variable. |
| `dhis.conf` is not found | Check the DHIS2 home selection, file location and read permissions for the service user. |
| `/` returns 404 | With context `/dhis2`, open `/dhis2/` instead. |
| Startup exits with status 1 | Read the console or journal and `dhis.log`; check database credentials and database availability. |
| Redirects or OIDC callbacks use HTTP | Check the proxy headers, public Host, HTTP/1.1 upstream and `native` forwarded-header strategy, including trusted proxy addresses. |
| Access tokens fail after a restart | Configure and retain a persistent OAuth2 signing keystore. |
