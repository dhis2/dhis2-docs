# DHIS2 configuration reference (dhis.conf) {#install_dhis2_configuration_reference}

This section describes the configuration of the DHIS2 system through the
`dhis.conf` configuration file, followed by the configuration parameters stored
in the database (system settings).


The following describes the full set of configuration options for the
`dhis.conf` configuration file. The configuration file should be placed in a
directory which is pointed to by a `DHIS2_HOME` environment variable.  On linux
systems, if the `DHIS2_HOME` environment variable is not explicitly set, it
defaults to the directory `/opt/dhis2/`.

> **Note**
>
> You should not attempt to use this configuration file directly, rather use it
> as a reference for the available configuration options. Many of the
> properties are optional.

```properties
# ----------------------------------------------------------------------
# Database connection for PostgreSQL [Mandatory]
# ----------------------------------------------------------------------

# Hibernate SQL dialect
connection.dialect = org.hibernate.dialect.PostgreSQLDialect

# JDBC driver class
connection.driver_class = org.postgresql.Driver

# Database connection URL
connection.url = jdbc:postgresql:dhis2

# Database username
connection.username = dhis

# Database password (sensitive)
connection.password = xxxx

# Max size of connection pool (default: 40)
connection.pool.max_size = 40

# ----------------------------------------------------------------------
# Database connection for PostgreSQL [Optional]
# ----------------------------------------------------------------------

# Minimum number of Connections a pool will maintain at any given time (default: 5).
connection.pool.min_size=5

# Number of Connections a pool will try to acquire upon startup. Should be between minPoolSize and maxPoolSize
connection.pool.initial_size=5

#Determines how many connections at a time will try to acquire when the pool is exhausted.
connection.pool.acquire_incr=5

#Seconds a Connection can remain pooled but unused before being discarded. Zero means idle connections never expire. (default: 7200)
connection.pool.max_idle_time=7200

#Number of seconds that Connections in excess of minPoolSize should be permitted to remain idle in the pool before being culled (default: 0)
connection.pool.max_idle_time_excess_con=0

#If this is a number greater than 0, dhis2 will test all idle, pooled but unchecked-out connections, every this number of seconds. (default: 0)
connection.pool.idle.con.test.period=0

#If on, an operation will be performed at every connection checkout to verify that the connection is valid. (default: false)
connection.pool.test.on.checkout=false

#If on, an operation will be performed asynchronously at every connection checkin to verify that the connection is valid. (default: on)
connection.pool.test.on.checkin=on

#Defines the query that will be executed for all connection tests. Ideally this config is not needed as postgresql driver already provides an efficient test query. The config is exposed simply for evaluation, do not use it unless there is a reason to.
connection.pool.preferred.test.query=select 1

#Configure the number of helper threads used by dhis2 for jdbc operations. (default: 3)
connection.pool.num.helper.threads=3

# Database connection pool type, supported types are 'c3p0' (default), 'hikari', 'unpooled'
db.pool.type = c3p0

# ----------------------------------------------------------------------
# Server [Mandatory]
# ----------------------------------------------------------------------

# Base URL to the DHIS 2 instance
# The server.base.url setting refers to the URL at which the system is accessed by end users over the network.
server.base.url = https://play.dhis2.org/dev 

# Enable secure settings if system is deployed on HTTPS, can be 'off', 'on'
server.https = off
# It is strongly recommended to enable the `server.https` setting and deploying DHIS 2 with an encrypted HTTPS protocol. This setting will enable e.g. secure cookies. HTTPS deployment is required when this setting is enabled

# ----------------------------------------------------------------------
# System [Optional]
# ----------------------------------------------------------------------

# System identifier
system.id = hmis1.country.org

# System mode for database read operations only, can be 'off', 'on'
system.read_only_mode = off

# Session timeout in seconds, default is 3600
system.session.timeout = 3600

# SQL view protected tables, can be 'on', 'off'
system.sql_view_table_protection = on

# SQL view write enabled, can be 'on', 'off'
system.sql_view_write_enabled = off

# Disable server-side program rule execution, can be 'on', 'off'
system.program_rule.server_execution = on

# Remote servers which the server is allowed to call, hostnames should end with '/', default is empty
system.remote_servers_allowed = https://server1.org/,https://server2.org/

# ----------------------------------------------------------------------
# Encryption [Optional]
# ----------------------------------------------------------------------

# Encryption password (sensitive)
encryption.password = xxxx

# ----------------------------------------------------------------------
# File store [Optional]
# ----------------------------------------------------------------------

# File store provider, currently 'filesystem' and 'aws-s3' are supported
filestore.provider = filesystem

# Directory / bucket name, folder below DHIS2_HOME on file system, 'bucket' on AWS S3
filestore.container = files

# URL where the S3 compatible API can be accessed (only for provider 's3')
filestore.endpoint = http://minio:9000 

# Datacenter location (not required)
filestore.location = eu-west-1

# Public identity / username
filestore.identity = dhis2-id

# Secret key / password (sensitive)
filestore.secret = xxxx

# ----------------------------------------------------------------------
# LDAP [Optional]
# ----------------------------------------------------------------------

# LDAP server URL
ldap.url = ldaps://300.20.300.20:636

# LDAP manager user distinguished name
ldap.manager.dn = cn=JohnDoe,ou=Country,ou=Admin,dc=hisp,dc=org

# LDAP manager user password (sensitive)
ldap.manager.password = xxxx

# LDAP entry distinguished name search base
ldap.search.base = dc=hisp,dc=org

# LDAP entry distinguished name filter
ldap.search.filter = (cn={0})

# ----------------------------------------------------------------------
# Node [Optional]
# ----------------------------------------------------------------------

# Node identifier, optional, useful in clusters
node.id = 'node-1'

# ----------------------------------------------------------------------
# Monitoring [Optional]
# ----------------------------------------------------------------------

# DHIS2 API monitoring
monitoring.api.enabled = on

# JVM monitoring
monitoring.jvm.enabled = on

# Database connection pool monitoring
monitoring.dbpool.enabled = on

# Hibernate monitoring, do not use in production
monitoring.hibernate.enabled = off

# Uptime monitoring
monitoring.uptime.enabled = on

# CPU monitoring
monitoring.cpu.enabled = on

# ----------------------------------------------------------------------
# Redis [Optional]
# ----------------------------------------------------------------------

# Redis enabled
redis.enabled = true

# Redis host name
redis.host = localhost

# Redis port
redis.port = 6379

# Redis password
redis.password = xxxx

# Use SSL for connections to Redis, can be 'on', 'off' (default)
redis.use.ssl = off

# ----------------------------------------------------------------------
# Analytics [Optional]
# ----------------------------------------------------------------------

# Analytics database JDBC driver class
analytics.connection.driver_class = org.postgresql.Driver

# Analytics database connection URL
analytics.connection.url = jdbc:postgresql:analytics

# Analytics database username
analytics.connection.username = analytics

# Analytics database password
analytics.connection.password = xxxx

# Analytics unlogged tables. Can be 'on' (default), 'off'. On will improve analytics geeneration performance at the cost of no replication.
analytics.table.unlogged = on

# ----------------------------------------------------------------------
# System telemetry [Optional]
# ----------------------------------------------------------------------

# System monitoring URL
system.monitoring.url = 

# System monitoring username
system.monitoring.username = 

# System monitoring password (sensitive)
system.monitoring.password = xxxx

# ----------------------------------------------------------------------
# System update notifications [Optional]
# ----------------------------------------------------------------------

# System update notifications, such as new DHIS 2 releases becoming available
system.update_notifications_enabled = on

# ----------------------------------------------------------------------
# Logging [Optional]
# ----------------------------------------------------------------------

# Max size for log files, default is 100MB
logging.file.max_size = 200MB

# Max number of rolling log archive files, default is 0
logging.file.max_archives = 1

# ----------------------------------------------------------------------
# Log levels [Optional]
# ----------------------------------------------------------------------

# DHIS 2 log level (level can be TRACE, DEBUG, INFO, WARN, ERROR)
logging.level.org.hisp.dhis = INFO

# Spring log level (refers to Java class package names)
logging.level.org.springframework = INFO

# ----------------------------------------------------------------------
# App Hub [Optional]
# ----------------------------------------------------------------------

# Base URL to the DHIS2 App Hub service
apphub.base.url = https://apps.dhis2.org"
# Base API URL to the DHIS2 App Hub service, used for app updates
apphub.api.url = https://apps.dhis2.org/api

# ----------------------------------------------------------------------
# Sessions [Optional]
# ----------------------------------------------------------------------

# Number of possible concurrent sessions across different clients per user
max.sessions.per_user = 10
```

Note that the configuration file supports environment variables. This
means that you can set certain properties as environment variables and
have them resolved, e.g. like this where `DB\_PASSWD` is the
name of the environment variable:

```properties
connection.password = ${DB_PASSWD}
```

Note that this file contains the password for your DHIS2 database in clear
text so it needs to be protected from unauthorized access. To do this, 
invoke the following command which ensures only the *dhis* user is allowed to read it:

```sh
chmod 600 dhis.conf
```

## Encryption configuration { #install_encryption_configuration } 

DHIS2 allows for encryption of data. Enabling it requires some extra
setup. To provide security to the encryption algorithm you will have to set a
password (key) in the `dhis.conf` configuration file through the
*encryption.password* property:

```properties
encryption.password = xxxx
```

The *encryption.password* property is the password (key) used when encrypting
and decrypting data in the database.

If an encryption password is not defined in `dhis.conf`, a default password will be
used. Note that using the default password does not offer any added security due to 
the open source nature of DHIS 2.

Note that the password must not be changed once it has been set and data has been encrypted, as the data can then no longer be decrypted by the application.

The password must be at least **24 characters long**. A mix of numbers 
and lower- and uppercase letters is recommended. The encryption password 
must be kept secret.

> **Important**
>
> It is not possible to recover encrypted data if the encryption password is lost or changed. If the password is lost, so is the encrypted data. Conversely, the encryption provides no security if 
> the password is compromised. Hence, great consideration should be given to storing the password in a safe place.

Note that since the encryption key is stored in the `dhis.conf` configuration file and not
within the database, when moving a database between server environments thorugh a dump and restore, the encryption key must be the same across environments to allow DHIS 2 to
decrypt database content.

Note that encryption support depends on the *Java Cryptography Extension* (JCE) policy files to be available. These are included in all versions of OpenJDK and Oracle JDK 8 Update 144 or later.


## System configuration { #install_system_configuration } 

This section covers various system configuration properties.

```properties
system.read_only_mode = on | off
```

Sets the system in read-only mode. This is useful when you run DHIS 2 on a read-only replica database, to avoid DHIS 2 performing database write operations. Can be `on` or `off`. Default is `off`.

```properties
system.session.timeout = (seconds)
```

Sets the user session timeout in seconds. Default is 3600 seconds (1 hour).

```properties
system.sql_view_table_protection = on | off
```

Enables or disables the sensitive database table protection for SQL views. This will prohibit database tables with sensitive data to be queried through SQL views. Disabling is not recommended. Can be `on` or `off`. Default is `on`.

```properties
system.system.sql_view_write_enabled = on | off
```

Enables or disables write permissions for SQL views. This will prohibit SQL view performing underlying writes (query can be a select which requires write permission). Enabling is not recommended. Can be `on` or `off`. Default is `off`.

```properties
system.program_rule.server_execution = on | off
```

Enables or disables execution of server-side program rules. This refers to program rules which have actions for assigning values, sending messages or scheduling messages to be sent. Can be `on` or `off`. Default is `on`.
