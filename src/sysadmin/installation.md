# Installation { #installation } 

The installation chapter provides information on how to install DHIS2 in
various contexts, including online central server, and offline local
network.

## Introduction { #install_introduction } 

DHIS2 runs on all platforms for which there exists a Java JDK, which includes most popular operating
systems such as Windows, Linux and Mac. DHIS2 runs on the PostgreSQL
database system. DHIS2 is packaged as a standard Java Web Archive
(WAR-file) and thus runs on any Servlet containers such as Tomcat and
Jetty.

The DHIS2 team recommends Ubuntu 18.04 LTS operating system, PostgreSQL
database system and Tomcat Servlet container as the preferred
environment for server installations.

This chapter provides a guide for setting up the above technology stack.
It should however be read as a guide for getting up and running and not
as an exhaustive documentation for the mentioned environment. We refer
to the official Ubuntu, PostgreSQL and Tomcat documentation for in-depth
reading.

The `dhis2-tools` Ubuntu package automates many of the tasks described in
the guide below and is recommended for most users, especially those who
are not familiar with the command line or administration of servers. It
is described in detail in a separate chapter in this guide.

## Server specifications { #install_server_specifications } 

DHIS2 is a database intensive application and requires that your server
has an appropriate amount of RAM, number of CPU cores and a fast disk.
These recommendations should be considered as rules-of-thumb and not
exact measures. DHIS2 scales linearly on the amount of RAM and number of
CPU cores so the more you can afford, the better the application will perform.

- *RAM:* At least 2 GB for a small instance, 12 GB for a medium instance, 64 GB or more for a large instance.
- *CPU cores:* 4 CPU cores for a small instance, 8 CPU cores for a medium instance, 16 CPU cores or more for a large instance.
- *Disk:* SSD is recommeded as storage device. Minimum
  read speed is 150 Mb/s, 200 Mb/s is good, 350 Mb/s or better is
  ideal. At least 100 GB storage space is recommended, but
  will depend entirely on the amount of data which is contained in the
  data value tables. Analytics tables require a significant amount of
  storage space. Plan ahead and ensure that your server can be upgraded
  with more disk space as needed.

## Software requirements { #install_software_requirements } 

Later DHIS2 versions require the following software versions to operate.

- An operating system for which a Java JDK or JRE version 17 exists. Linux is recommended.
- Java JDK. OpenJDK is recommended.  


Table: DHIS2 compatibility

| DHIS2 version | JDK recommended | JDK required | Tomcat required |
|---------------|-----------------|--------------|-----------------|
| 2.42          | 17              | 17           | 10              |
| 2.41          | 17              | 17           | 8.5.50          |
| 2.40          | 17              | 11           | 8.5.50          |
| 2.39          | 11              | 11           | 8.5.50          |
| 2.38          | 11              | 11           |
| 2.35          | 11              | 8            |
| pre 2.35      | 8               | 8            |


- PostgreSQL database version 9.6 or later. A later PostgreSQL version such as version 14 is recommended.
- PostGIS database extension version 2.2 or later.
- Tomcat servlet container version 10 for 2.42, 8.5.50 or later for lower versions, or other Servlet API
  3.1 compliant servlet containers.
- Cluster setup only (optional): Redis data store version 4 or later. 

## Server setup { #install_server_setup } 

This section describes how to set up a server instance of DHIS2 on
Ubuntu 18.04 64 bit with PostgreSQL as database system and Tomcat as
Servlet container. This guide is not meant to be a step-by-step guide
per se, but rather to serve as a reference to how DHIS2 can be deployed
on a server. There are many possible deployment strategies, which will
differ depending on the operating system and database you are using, and
other factors. The term *invoke* refers to executing a given command in
a terminal.

For this guide we assume that 8 Gb RAM is allocated for PostgreSQL and 8
GB RAM is allocated for Tomcat/JVM, and that a 64-bit operating system
is used. *If you are running a different configuration please adjust the
suggested values accordingly\!*

We recommend that the available memory
is split roughly equally between the database and the JVM. Remember to
leave some of the physical memory to the operating system for it to
perform its tasks, for instance around 2 GB. The steps marked as
*optional*, like the step for performance tuning, can be done at a later
stage.

### Creating a user to run DHIS2 { #install_creating_user } 

You should create a dedicated user for running DHIS2.

> **Important**
>
> You should not run the DHIS2 server as a privileged user such as root.

Create a new user called dhis by invoking:

```sh
sudo useradd -d /home/dhis -m dhis -s /bin/false
```

Then to set the password for your account invoke:

```sh
sudo passwd dhis
```

Make sure you set a strong password with at least 15 random characters.

### Creating the configuration directory { #install_creating_config_directory } 

Start by creating a suitable directory for the DHIS2 configuration
files. This directory will also be used for apps, files and log files.
An example directory could be:

```sh
sudo mkdir /home/dhis/config
sudo chown dhis:dhis /home/dhis/config
```

DHIS2 will look for an environment variable called `DHIS2_HOME` to
locate the DHIS2 configuration directory. This directory will be
referred to as `DHIS2_HOME` in this installation guide. We will define
the environment variable in a later step in the installation process.

If no environment variable `DHIS2_HOME` is found, the default 
configuration file location `/opt/dhis2` is used.

### Setting server time zone and locale { #install_setting_server_tz } 

It may be necessary to reconfigure the time zone of the server to match
the time zone of the location which the DHIS2 server will be covering.
If you are using a virtual private server, the default time zone may not
correspond to the time zone of your DHIS2 location. You can easily
reconfigure the time zone by invoking the below and following the
instructions.

```sh
sudo dpkg-reconfigure tzdata
```

PostgreSQL is sensitive to locales so you might have to install your
locale first. To check existing locales and install new ones (e.g.
Norwegian):

```sh
locale -a
sudo locale-gen nb_NO.UTF-8
```

### PostgreSQL installation { #install_postgresql_installation } 

Install PostgreSQL by invoking:

```sh
sudo apt-get install -y postgresql-12 postgresql-12-postgis-3
```

Create a non-privileged user called *dhis* by invoking:

```sh
sudo -u postgres createuser -SDRP dhis
```

Enter a secure password at the prompt. Create a database by invoking:

```sh
sudo -u postgres createdb -O dhis dhis2
```

Return to your session by invoking `exit` You now have a PostgreSQL user
called *dhis* and a database called *dhis2*.

The *PostGIS* extension is needed for several GIS/mapping features to
work. DHIS 2 will attempt to install the PostGIS extension during
startup. If the DHIS 2 database user does not have permission to create
extensions you can create it from the console using the *postgres* user
with the following commands:

```sh
sudo -u postgres psql -c "create extension postgis;" dhis2
```

For adding trigram indexes and compounding it with primitive column types, two extensions have to be created in the database for DHIS 2 verision 2.38 and later. The extensions are already part of the default posgresql installation:

```sh
sudo -u postgres psql -c "create extension btree_gin;" dhis2
sudo -u postgres psql -c "create extension pg_trgm;" dhis2
```

Exit the console and return to your previous user with *\\q* followed by
*exit*.

### PostgreSQL performance tuning { #install_postgresql_performance_tuning } 

Tuning PostgreSQL is required to achieve a high-performing system but
is optional in terms of getting DHIS2 to run. The various settings can be
specified in the `postgresql.conf` configuration file or, preferably, in a specific
file in the `conf.d` directory. The settings is based on allocating 8 GB RAM to
PostgreSQL and should be adjusted accordingly to the environment.

```sh
sudo nano /etc/postgresql/12/main/postgresql.conf
```

Set the following properties.

```properties
jit = off
```

This is important to set for postgresql versions 12 and greater.  The jit compiler 
functionality causes a significant slowdown on many DHIS2 specific queries, eg 
Program Indicator queries.  For versions 11 and below, the setting is off by default.

```properties
max_connections = 200
```

Determines maximum number of connections which PostgreSQL will allow.

```properties
shared_buffers = 3GB
```

Determines how much memory should be allocated exclusively for
PostgreSQL caching. This setting controls the size of the kernel shared
memory which should be reserved for PostgreSQL. Should be set to around
40% of total memory dedicated for PostgreSQL.

```properties
work_mem = 24MB
```

Determines the amount of memory used for internal sort and hash
operations. This setting is per connection, per query so a lot of memory
may be consumed if raising this too high. Setting this value correctly
is essential for DHIS2 aggregation performance.

```properties
maintenance_work_mem = 1GB
```

Determines the amount of memory PostgreSQL can use for maintenance
operations such as creating indexes, running vacuum, adding foreign
keys. Increasing this value might improve performance of index creation
during the analytics generation processes.

```properties
temp_buffers = 16MB
```

Sets the maximum number of temporary buffers used by each database 
session. These are session-local buffers used only for access to temporary 
tables. 

```properties
effective_cache_size = 8GB
```

An estimate of how much memory is available for disk caching by the
operating system (not an allocation) and is used by PostgreSQL to
determine whether a query plan will fit into memory or not. Setting it
to a higher value than what is really available will result in poor
performance. This value should be inclusive of the `shared_buffers`
setting. PostgreSQL has two layers of caching: The first layer uses the
kernel shared memory and is controlled by the shared\_buffers setting.
PostgreSQL delegates the second layer to the operating system disk cache
and the size of available memory can be given with the
`effective_cache_size` setting.

```properties
checkpoint_completion_target = 0.8
```

Sets the memory used for buffering during the WAL write process.
Increasing this value might improve throughput in write-heavy systems.

```properties
synchronous_commit = off
```

Specifies whether transaction commits will wait for WAL records to be
written to the disk before returning to the client or not. Setting this
to off will improve performance considerably. It also implies that there
is a slight delay between the transaction is reported successful to the
client and it actually being safe, but the database state cannot be
corrupted and this is a good alternative for performance-intensive and
write-heavy systems like DHIS2.

```properties
wal_writer_delay = 10s
```

Specifies the delay between WAL write operations. Setting this to a high
value will improve performance on write-heavy systems since potentially
many write operations can be executed within a single flush to disk.

```properties
random_page_cost = 1.1
```

*SSD only.* Sets the query planner's estimate of the cost of a non-sequentially-fetched disk page. A low value will cause the system to prefer index scans over sequential scans. A low value makes sense for databases running on SSDs or being heavily cached in memory. The default value is 4.0 which is reasonable for traditional disks.

```properties
max_locks_per_transaction = 96
```

Specifies the average number of object locks allocated for each transaction. This is set mainly to allow upgrade routines which touch a large number of tables to complete.

```properties
track_activity_query_size = 8192
```

Specifies the number of bytes reserved to track the currently executing command for each active session. Useful to view the full query string for monitoring of currently running queries.

```properties
jit = off
```

This setting turns the jit optimizer off.  It should be set to off for postgresql versions 12 and upwards.  Many queries, particularly program indicator queries, perform very badly with the default enabled jit setting.  Turning it off can improve response times by up to 100x with resulting significant improvement in dashboard performance.

Restart PostgreSQL by invoking the following command:

```sh
sudo systemctl restart postgresql
```

### Java installation { #install_java_installation } 

The recommended Java JDK for DHIS 2 is OpenJDK 17 (for version 2.40 and later). You can install it with the following command:

```
sudo apt-get install -y openjdk-17-jdk
```

Verify that your installation is correct by invoking:

```
java -version
```

### DHIS2 configuration { #install_database_configuration } 

The database connection information is provided to DHIS2 through a
configuration file called `dhis.conf`. Create this file and save it in
the `DHIS2_HOME` directory. As an example this location could be:

```sh
/home/dhis/config/dhis.conf
```

A configuration file for PostgreSQL corresponding to the above setup has
these properties:

```properties
# ----------------------------------------------------------------------
# Database connection
# ----------------------------------------------------------------------

# JDBC driver class
connection.driver_class = org.postgresql.Driver

# Database connection URL
connection.url = jdbc:postgresql:dhis2

# Database username
connection.username = dhis

# Database password
connection.password = xxxx
		
# ----------------------------------------------------------------------
# Server
# ----------------------------------------------------------------------

# Enable secure settings if deployed on HTTPS, default 'off', can be 'on'
# server.https = on

# Server base URL
# server.base.url = https://server.com
```

It is strongly recommended to enable the `server.https` setting and deploying DHIS 2 with an encrypted HTTPS protocol. This setting will enable e.g. secure cookies. HTTPS deployment is required when this setting is enabled.

The `server.base.url` setting refers to the URL at which the system is accessed by end users over the network.

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

### Tomcat and DHIS2 installation { #install_tomcat_dhis2_installation } 

To install the Tomcat servlet container we will utilize the Tomcat user
package by invoking:

```sh
sudo apt-get install -y tomcat8-user
```

This package lets us easily create a new Tomcat instance. The instance
will be created in the current directory. An appropriate location is the
home directory of the `dhis` user:

```sh
sudo tomcat8-instance-create /home/dhis/tomcat-dhis
sudo chown -R dhis:dhis /home/dhis/tomcat-dhis/
```

This will create an instance in a directory called `tomcat-dhis`. Note
that the `tomcat8-user` package allows for creating any number of DHIS2
instances if that is desired.

Next edit the file `tomcat-dhis/bin/setenv.sh` and add the lines below.

* `JAVA_HOME` sets the location of the JDK installation.
* `JAVA_OPTS` passes parameters to the JVM.
    * `-Xms` sets the initial allocation of memory to the Java heap memory space.
    * `-Xmx` sets the maximum allocation of memory to the Java heap memory space. This should reflect how much memory you would like to allocate to the DHIS 2 software application on your server.
* `DHIS2_HOME` sets the location of the `dhis.conf` configuration file for DHIS 2.

Check that the path the Java binaries are correct as they might vary from system to system, e.g. on AMD systems you might see
`/java-11-openjdk-amd64`. Note that you should adjust these values to your environment.

```sh
JAVA_HOME='/usr/lib/jvm/java-11-openjdk-amd64/'
JAVA_OPTS='-Xms4000m -Xmx7000m'
DHIS2_HOME='/home/dhis/config'
```

The Tomcat configuration file is located in
`tomcat-dhis/conf/server.xml`. The element which defines the connection
to DHIS is the *Connector* element with port 8080. You can change the
port number in the Connector element to a desired port if necessary. 
The `relaxedQueryChars` attribute is necessary to allow certain characters 
in URLs used by the DHIS2 front-end.

```xml
<Connector port="8080" protocol="HTTP/1.1"
  connectionTimeout="20000"
  redirectPort="8443"
  relaxedQueryChars="[]" />
```

The next step is to download the DHIS2 WAR file and place it into the
_webapps_ directory of Tomcat. You can download DHIS2 WAR files from the following location: 

```sh
https://releases.dhis2.org/
```

Move the WAR file into the Tomcat `webapps` directory. We want to call the
WAR file `ROOT.war` in order to make it available at `localhost` directly
without a context path:

```sh
mv dhis.war tomcat-dhis/webapps/ROOT.war
```

DHIS2 should never be run as a privileged user. After you have modified
the `setenv.sh file`, modify the startup script to check and verify that the
script has not been invoked as root.

```sh
#!/bin/sh
set -e

if [ "$(id -u)" -eq "0" ]; then
  echo "This script must NOT be run as root" 1>&2
  exit 1
fi

export CATALINA_BASE="/home/dhis/tomcat-dhis"
/usr/share/tomcat8/bin/startup.sh
echo "Tomcat started"
```

### Running DHIS2 { #install_running_dhis2 } 

DHIS2 can now be started by invoking:

    sudo -u dhis tomcat-dhis/bin/startup.sh

> **Important**
> 
> The DHIS2 server should never be run as root or other privileged user.

DHIS2 can be stopped by invoking:

    sudo -u dhis tomcat-dhis/bin/shutdown.sh

To monitor the behavior of Tomcat the log is the primary source of
information. The log can be viewed with the following command:

    tail -f tomcat-dhis/logs/catalina.out

Assuming that the WAR file is called ROOT.war, you can now access your
DHIS2 instance at the following URL:

    http://localhost:8080

## File store configuration { #install_file_store_configuration } 

DHIS2 is capable of capturing and storing files. By default, files will be stored on the local file
system of the server which runs DHIS2 in a *files* directory under the `DHIS2_HOME` external
directory location. The directory *files* can be changed via the `filestore.container` property in
the `dhis.conf`.

You can also configure DHIS2 to store files on cloud-based storage providers. AWS S3 or S3
compatible object stores are currently supported.

To enable storage in AWS S3 you must define the following additional properties in your `dhis.conf`
file:

```properties
# File store provider. Currently 'filesystem' (default), 'aws-s3' and 's3' are supported.
filestore.provider = aws-s3

# Directory in external directory on local file system or bucket in AWS S3 or S3 API
filestore.container = files

# The following configuration is applicable to cloud storage only (provider 'aws-s3' or 's3')

# Datacenter location. Optional but recommended for performance reasons.
filestore.location = eu-west-1

# Username / Access key for AWS S3 or S3 APIs
filestore.identity = xxxx

# Password / Secret key for AWS S3 or S3 APIs (sensitive)
filestore.secret = xxxx
```

To enable storage in an S3 compatible object store you must define the following additional
properties in your `dhis.conf` file:

```properties
# File store provider. Currently 'filesystem' (default), 'aws-s3' and 's3' are supported.
filestore.provider = s3

# Directory in external directory on local file system or bucket in AWS S3
filestore.container = files

# The following configuration is applicable to cloud storage only (provider 'aws-s3' or 's3')

# URL where the S3 compatible API can be accessed (only for provider 's3')
filestore.endpoint = http://minio:9000 

# Datacenter location. Optional but recommended for performance reasons.
filestore.location = eu-west-1

# Username / Access key for AWS S3 or S3 APIs
filestore.identity = xxxx

# Password / Secret key for AWS S3 or S3 APIs (sensitive)
filestore.secret = xxxx
```

> **Note**
> 
> If you’ve configured cloud storage in dhis.conf, all files you upload
> or the files the system generates will use cloud storage.

These configurations are examples and should be changed to fit your needs.
For a production system the initial setup of the file store should be
carefully considered as moving files across storage providers while
keeping the integrity of the database references could be complex. Keep
in mind that the contents of the file store might contain both sensitive
and integral information and protecting access to the folder as well as
making sure a backup plan is in place is recommended on a production
implementation.

> **Note**
> 
> AWS S3 and S3 compatible object stores are the only supported cloud providers but more providers
> could be added. Let us know if you have a use case for additional providers.

## Google service account configuration { #install_google_service_account_configuration } 

DHIS2 can connect to various Google service APIs. For instance, the
DHIS2 Maps app can utilize the Google Earth Engine API to load Earth Engine map
layers. There are 2 ways to obtain the Google API key.

### Set it up yourself

Set up a Google service account and create a private key:

  - Create a Google service account. Please consult the [Google identify
    platform](https://developers.google.com/identity/protocols/OAuth2ServiceAccount#overview)
    documentation.

  - Visit the [Google cloud console](https://console.cloud.google.com)
    and go to API Manager \> Credentials \> Create credentials \>
    Service account key. Select your service account and JSON as key
    type and click Create.

  - Rename the JSON key to *dhis-google-auth.json*.

After downloading the key file, put the `dhis-google-auth.json` file in
the `DHIS2_HOME` directory (the same location as the `dhis.conf` file).
As an example this location could be:

    /home/dhis/config/dhis-google-auth.json

### Send an email to set up the Google Earth Engine API key

If you only intend to use the key for the Google Earth Engine map layers,
you can simply send an email. See the [Google Earth Engine API key documentation](https://docs.dhis2.org/en/topics/tutorials/google-earth-engine-sign-up.html).

## Bing Maps API key { #install_bing_maps_api_key }

To enable use of Bing Maps basemap layers, you need to set up the Bing Maps API key. See [Bing Maps API key documentation](https://www.microsoft.com/en-us/maps/bing-maps/create-a-bing-maps-key) for information on setting up the key.

## OpenID Connect (OIDC) configuration { #install_oidc_configuration } 

DHIS2 supports the OpenID Connect (OIDC) identity layer for single sign-in (SSO). OIDC is a standard authentication protocol that lets users sign in with an identity provider (IdP) such as for example Google. After users have successfully signed in to their IdP, they will be automatically signed in to DHIS2.

This section provides general information about using DHIS2 with an OIDC provider, as well as complete configuration examples.

The DHIS2 OIDC 'authorization code' authentication flow:

1. A user attempts to log in to DHIS2 and clicks the OIDC provider button on the login page.

2. DHIS2 redirects the browser to the IdP's login page.

3. If not already logged in, the user is prompted for credentials. When successfully authenticated, the IdP responds with a redirect back to the DHIS2 server. The redirect includes a unique authorization code generated for the user.

4. The DHIS2 server internally sends the user's authorization code back to the IdP server along with its own client id and client secret credentials.

5. The IdP returns an ID token back to the DHIS2 server. DHIS2 server performs validation of the token.

6. The DHIS2 server looks up the internal DHIS2 user with the mapping claims found in the ID token (defaults to email), authorizes the user and completes the login process.

### Requirements for using OIDC with DHIS2:

#### IdP server account

You must have an admin account on an online identity provider (IdP) or on a standalone server that are supported by DHIS2.

The following IdPs are currently supported and tested:

* Google
* Azure AD
* WSO2
* Okta (See separate tutorial: [here](#configure-openid-connect-with-okta))

There is also a **generic provider** config which can support "any" OIDC compatible provider.

#### DHIS2 user account

You must explicitly create the users in the DHIS2 server before they can log in with the identity provider. Importing them from an external directory such as Active Directory is currently not supported. Provisioning and management of users with an external identity store is not supported by the OIDC standard.

#### IdP claims and mapping of users

To sign in to DHIS2 with OIDC, a given user must be provisioned in the IdP and then mapped to a pre created user account in DHIS2. OIDC uses a method that relies on claims to share user account attributes with other applications. Claims include user account attributes such as email, phone number, name, etc. DHIS2 relies on a IdP claim to map user accounts from the IdP to those in the DHIS2 server. By default, DHIS2 expects the IdP to pass the _email_ claim. Depending on your IdP, you may need to configure DHIS2 to use a different IdP claim.

If you are using Google or Azure AD as an IdP, the default behavior is to use the _email_ claim to map IdP identities to DHIS2 user accounts.

> **Note**
>
> In order for a DHIS2 user to be able to log in with an IdP, the user profile checkbox: *External authentication only OpenID or LDAP* must be checked and *OpenID* field must match the claim (mapping claim) returned by the IdP. Email is the default claim used by both Google and Azure AD.

### Configure the Identity Provider for OIDC

This topic provides general information about configuring an identity provider (IdP) to use OIDC with DHIS2. This is one step in a multi-step process. Each IdP has slightly different ways to configure it. Check your IdP's own documentation for how to create and configure an OIDC application. Here we refer to the DHIS2 server as the OIDC "application".

#### Redirect URL

All IdPs will require a redirect URL to your DHIS2 server. 
You can construct it using the following pattern:

```
(protocol):/(your DHIS2 host)/oauth2/code/PROVIDER_KEY
```

Example when using Google IdP:

```
https://mydhis2-server.org/oauth2/code/google
```

External links to instructions for configuring your IdP:

* [Google](https://developers.google.com/identity/protocols/oauth2/openid-connect)
* [Azure AD tutorial](https://medium.com/xebia-engineering/authentication-and-authorization-using-azure-active-directory-266980586ab8)


### Example setup for Google

1. Register an account and sign in. For example, for Google, you can go to the Google [developer console](https://console.developers.google.com).
2. In the Google developer dashboard, click 'create a new project'.
3. Follow the instructions for creating an OAuth 2.0 client ID and client secret.
4. Set your "Authorized redirect URL" to: `https://mydhis2-server.org/oauth2/code/google`
5. Copy and keep the "client id" and "client secret" in a secure place.

> **Tip**
>
> When testing on a local DHIS2 instance running for example on your laptop, you can use localhost as the redirect URL, like this: `https://localhost:8080/oauth2/code/google`
> *Remember to also add the redirect URL in the Google developer console*

#### Google dhis.conf example:
```properties

# Enables OIDC login
oidc.oauth2.login.enabled = on

# Client id, given to you in the Google developer console
oidc.provider.google.client_id = my client id

# Client secret, given to you in the Google developer console
oidc.provider.google.client_secret = my client secret

# [Optional] Authorized redirect URI, the same as set in the Google developer console 
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public url, like the example below.
oidc.provider.google.redirect_url = https://mydhis2-server.org/oauth2/code/google

# [Optional] Where to redirect after logging out.
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public url, like the example below. 
oidc.logout.redirect_url = https://mydhis2-server.org

```

### Example setup for Azure AD

Make sure your Azure AD account in the Azure portal is configured with a redirect URL like: `(protocol):/(host)/oauth2/code/PROVIDER_KEY`. 
To register your DHIS2 server as an "application" in the Azure portal, follow these steps:

> **Note**
>
> PROVIDER_KEY is the "name" part of the configuration key, example: "oidc.provider.PROVIDER_KEY.tenant = My Azure SSO"
> If you have multiple Azure providers you want to configure, you can use this name form: (azure.0), (azure.1) etc.
> Redirect URL example: https://mydhis2-server.org/oauth2/code/azure.0

1. Search for and select *App registrations*.
2. Click *New registration*.
3. In the *Name* field, enter a descriptive name for your DHIS2 instance.
4. In the *Redirect URI* field, enter the redirect URL as specified above.
5. Click *Register*.

#### Azure AD dhis.conf example:
```properties

# Enables OIDC login
oidc.oauth2.login.enabled = on

# First provider (azure.0):

# Alias, or name that will show on the login button in the DHIS2 login screen.
oidc.provider.azure.0.tenant = organization name

# Client id, given to you in the Azure portal
oidc.provider.azure.0.client_id = my client id

# Client secret, given to you in the Azure portal
oidc.provider.azure.0.client_secret = my client secret

# [Optional] Authorized redirect URI, the as set in Azure portal 
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public url, like the example below.
oidc.provider.azure.0.redirect_url = https://mydhis2-server.org/oauth2/code/azure.0

# [Optional] Where to redirect after logging out.
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public URL, like the example below.
oidc.logout.redirect_url = https://mydhis2-server.org

# [Optional], defaults to 'email'
oidc.provider.azure.0.mapping_claim = email

# [Optional], defaults to 'on'
oidc.provider.azure.0.support_logout = on


# Second provider (azure.1):

oidc.provider.azure.1.tenant = other organization name
...
```

### Generic providers

The generic provider can be used to configure "any" standard OIDC provider which are compatible with "Spring Security".

In the example below we will configure the Norwegian governmental _HelseID_ OIDC provider using the provider key `helseid`.

The defined provider will appear as a button on the login page with the provider key as the default name, 
or the value of the `display_alias` if defined. The provider key is arbitrary and can be any alphanumeric string, 
except for the reserved names used by the specific providers (`google`, `azure.0,azure.1...`, `wso2`).

> **Note**
> The generic provider uses the following hardcoded configuration defaults:
> **(These are not possible to change)**
> * Client Authentication, `ClientAuthenticationMethod.BASIC`: [rfc](https://tools.ietf.org/html/rfc6749#section-2.3)
> * Authenticated Requests, `AuthenticationMethod.HEADER`: [rfc](https://tools.ietf.org/html/rfc6750#section-2) 

#### Generic (helseid) dhis.conf example:

```properties

# Enables OIDC login
oidc.oauth2.login.enabled = on

# Required variables:
oidc.provider.helseid.client_id = CLIENT_ID
oidc.provider.helseid.client_secret = CLIENT_SECRET
oidc.provider.helseid.mapping_claim = helseid://claims/identity/email
oidc.provider.helseid.authorization_uri = https://helseid.no/connect/authorize
oidc.provider.helseid.token_uri = https://helseid.no/connect/token
oidc.provider.helseid.user_info_uri = https://helseid.no/connect/userinfo
oidc.provider.helseid.jwk_uri = https://helseid.no/.well-known/openid-configuration/jwks
oidc.provider.helseid.end_session_endpoint = https://helseid.no/connect/endsession
oidc.provider.helseid.scopes = helseid://scopes/identity/email

# [Optional] Authorized redirect URI, the as set in Azure portal 
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public url, like the example below.
oidc.provider.helseid.redirect_url = https://mydhis2-server.org/oauth2/code/helseid

# [Optional], defaults to 'on'
oidc.provider.helseid.enable_logout = on

# [Optional] Where to redirect after logging out.
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public URL, like the example below.
oidc.logout.redirect_url = https://mydhis2-server.org

# [Optional] PKCE support, see: https://oauth.net/2/pkce/), default is 'false'
oidc.provider.helseid.enable_pkce = on

# [Optional] Extra variables appended to the request. 
# Must be key/value pairs like: "KEY1 VALUE1,KEY2 VALUE2,..."
oidc.provider.helseid.extra_request_parameters = acr_values lvl4,other_key value2

# [Optional] This is the alias/name displayed on the login button in the DHIS2 login page
oidc.provider.helseid.display_alias = HelseID

# [Optional] Link to an url for a logo. (Can use absolute or relative URLs)
oidc.provider.helseid.logo_image = ../security/btn_helseid.svg
# [Optional] CSS padding for the logo image
oidc.provider.helseid.logo_image_padding = 0px 1px
```

### JWT bearer token authentication

Authentication with *JWT bearer tokens* can be enabled for clients which API-based when OIDC is configured. 
The DHIS2 Android client is such a type of client and have to use JWT authentication if OIDC login is enabled.

> **Note**
>
> DHIS2 currently only supports the OAuth2 authorization code grant flow for authentication with JWT, (also known as "three-legged OAuth")
> DHIS2 currently only supports using Google as an OIDC provider when using JWT tokens


### Requirements
* Configure your Google OIDC provider as described above 
* Disable the config parameter ```oauth2.authorization.server.enabled``` by setting it to 'off'
* Enable the config parameter ```oidc.jwt.token.authentication.enabled``` by setting it to 'on'
* Generate an Android OAuth2 client_id as described [here](https://developers.google.com/identity/protocols/oauth2/native-app#creatingcred)

### JWT authentication example

The following `dhis.conf` section shows an example of how to enable JWT authentication for an API-based client.

```properties

# Enables OIDC login
oidc.oauth2.login.enabled = on

# Minimum required config variables:
oidc.provider.google.client_id = my_client_id
oidc.provider.google.client_secret = my_client_secret

# Enable JWT support
oauth2.authorization.server.enabled = off
oidc.jwt.token.authentication.enabled = on

# Define client 1 using JWT tokens
oidc.provider.google.ext_client.0.client_id = JWT_CLIENT_ID

# Define client 2 using JWT tokens
oidc.provider.google.ext_client.1.client_id = JWT_CLIENT_ID

```

> **Note**
>
> [Check out our tutorial for setting up Okta as a generic OIDC provider.](../../../topics/tutorials/configure-oidc-with-okta.md)

### Connecting a single identity provider account to multiple DHIS2 accounts

DHIS2 has the ability to map a single identity provider account to multiple DHIS2 accounts. API calls are available to list the linked accounts and also switch between then.

When this option is selected, the `openid` database field in the `userinfo` table does not need to be unique.  When presented with an `openid` value from the identity provider, DHIS2 will log in the user that most recently logged in.

The following `dhis.conf` section shows how to enable linked accounts.

```properties
# Enable a single OIDC account to log in as one of several DHIS2 accounts
linked_accounts.enabled = on
```

For instructions on how to list linked accounts and switch between them, see [*Switching between user accounts connected to the same identity provider account* in the Users chapter of the developer documentation.](../../../develop/using-the-api/dhis-core-version-master/users.html#switching-between-user-accounts-connected-to-the-same-identity-provider-account)

## LDAP configuration { #install_ldap_configuration } 

DHIS2 is capable of using an LDAP server for authentication of users.
For LDAP authentication it is required to have a matching user in the
DHIS2 database per LDAP entry. The DHIS2 user will be used to represent
authorities / user roles.

To set up LDAP authentication you need to configure the LDAP server URL,
a manager user and an LDAP search base and search filter. This
configuration should be done in the DHIS 2 configuration file `dhis.conf`. 
LDAP users, or entries, are identified by distinguished names 
(DN from now on). An example configuration looks like this:

```properties
# LDAP server URL
ldap.url = ldaps://domain.org:636

# LDAP manager entry distinguished name
ldap.manager.dn = cn=johndoe,dc=domain,dc=org

# LDAP manager entry password
ldap.manager.password = xxxx

# LDAP base search
ldap.search.base = dc=domain,dc=org

# LDAP search filter
ldap.search.filter = (cn={0})
```

The LDAP configuration properties are explained below:

- *ldap.url:* The URL of the LDAP server for which to authenticate
  against. Using SSL/encryption is strongly recommended in order to
  make authentication secure. As example URL is
  *ldaps://domain.org:636*, where ldaps refers to the protocol,
  *domain.org* refers to the domain name or IP address, and *636*
  refers to the port (636 is default for LDAPS).
- *ldap.manager.dn:* An LDAP manager user is required for binding to
  the LDAP server for the user authentication process. This property
  refers to the DN of that entry. I.e. this is not the user which will
  be authenticated when logging into DHIS2, rather the user which
  binds to the LDAP server in order to do the authentication.
- *ldap.manager.password:* The password for the LDAP manager user.
- *ldap.search.base:* The search base, or the distinguished name of
  the search base object, which defines the location in the directory
  from which the LDAP search begins.
- *ldap.search.filter:* The filter for matching DNs of entries in the
  LDAP directory. The {0} variable will be substituted by the DHIS2
  username, or alternatively, the LDAP identifier defined for the user
  with the supplied username.

DHIS2 will use the supplied username / password and try to authenticate
against an LDAP server entry, then look up user roles / authorities from
a corresponding DHIS2 user. This implies that a user must have a
matching entry in the LDAP directory as well as a DHIS2 user in order to
log in.

During authentication, DHIS2 will try to bind to the LDAP server using
the configured LDAP server URL and the manager DN and password. Once the
binding is done, it will search for an entry in the directory using the
configured LDAP search base and search filter.

The {0} variable in the configured filter will be substituted before
applying the filter. By default, it will be substituted by the supplied
username. You can also set a custom LDAP identifier on the relevant
DHIS2 user account. This can be done through the DHIS2 user module user
interface in the add or edit screen by setting the "LDAP identifier"
property. When set, the LDAP identifier will be substituted for the {0}
variable in the filter. This feature is useful when the LDAP common name
is not suitable or cannot for some reason be used as a DHIS2 username.

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

## Read replica database configuration { #install_read_replica_configuration } 

DHIS 2 allows for utilizing read only replicas of the master database
(the main DHIS 2 database). The purpose of read replicas is to enhance
the performance of database read queries and scale out the capacity
beyond the constraints of a single database. Read-heavy operations such
as analytics and event queries will benefit from this.

The configuration requires that you have created one or more replicated
instances of the master DHIS 2 database. PostgreSQL achieves this
through a concept referred to as *streaming replication*. Configuring
read replicas for PostgreSQL is not covered in this guide.

Read replicas can be defined in the `dhis.conf` configuration file. You
can specify up to 5 read replicas per DHIS 2 instance. Each read replica
is denoted with a number between 1 and 5. The JDBC connection URL must
be defined per replica. The username and password can be specified; if
not, the username and password for the master database will be used
instead.

The configuration for read replicas in `dhis.conf` looks like the below.
Each replica is specified with the configuration key *readN* prefix,
where N refers to the replica number.

```properties
# Read replica 1 configuration

# Database connection URL, username and password
read1.connection.url = jdbc:postgresql://127.0.0.11/dbread1
read1.connection.username = dhis
read1.connection.password = xxxx

# Read replica 2 configuration

# Database connection URL, username and password
read2.connection.url = jdbc:postgresql://127.0.0.12/dbread2
read2.connection.username = dhis
read2.connection.password = xxxx

# Read replica 3 configuration

# Database connection URL, fallback to master for username and password
read3.connection.url = jdbc:postgresql://127.0.0.13/dbread3
```

Note that you must restart your servlet container for the changes to
take effect. DHIS 2 will automatically distribute the load across the
read replicas. The ordering of replicas has no significance.

## Web server cluster configuration { #install_web_server_cluster_configuration } 

This section describes how to set up the DHIS 2 application to run in a
cluster.

### Clustering overview { #install_cluster_configuration_introduction } 

Clustering is a common technique for improving system scalability and
availability. Clustering refers to setting up multiple web servers such
as Tomcat instances and have them serve a single application. Clustering
allows for *scaling out* an application in the sense that new servers
can be added to improve performance. It also allows for *high
availability* as the system can tolerate instances going down without
making the system inaccessible to users.

There are a few aspects to configure in order to run DHIS 2
in a cluster.

* A Redis data store must be installed and connection information must 
be provided for each DHIS 2 application instance in`dhis.conf`.

* DHIS 2 instances and servers must share the same *files* folder used for 
apps and file uploads, either through the *AWS S3 cloud filestorage* option 
or a shared network drive.

* DHIS 2 instance cache invalidation must be enabled.

* A load balancer such as nginx should be configured to distribute Web requests
across the cluster instances.

### DHIS 2 instance cache invalidation with Redis { #install_cluster_cache_invalidation_redis }

DHIS 2 can invalidate the various instance's caches by listening for events sent and emitted from a Redis server, when configured to do so.

This is considered the easiest and preferred way to enable cache invalidation, if you already plan to use [Redis for
shared data store cluster configuration](#install_cluster_configuration_redis), it will share this Redis server for both purposes.

#### Prerequisites

* Redis server

#### Redis configuration

No specific configuration in Redis is needed for DHIS 2 cache invalidation to work.

When you chose to enable shared data store cluster configuration with Redis, you will share the Redis host/port
configuration with the cache invalidation system. In other words you can only have **one** shared Redis server configured.

#### DHIS 2 configuration

The following properties must be specified in the DHIS 2 `dhis.conf` configuration file:

```properties
# Cache invalidation config

redis.cache.invalidation.enabled = on

# Shared Redis configuration
redis.host = REDIS_HOST
redis.port = REDIS_PORT
redis.password = PASSWORD (Optional, only if enabled on Redis server)
redis.use.ssl = true (Optional, only if enabled on Redis server) 
```

### Redis shared data store cluster configuration { #install_cluster_configuration_redis } 

In a cluster setup, a Redis server is required and will handle
shared user sessions, application cache and cluster node leadership.

For optimum performance, *Redis Keyspace events* for _generic commands_ 
and _expired events_ need to be enabled in the Redis Server. If you are 
using a cloud platform-managed Redis server (like *AWS ElastiCache for Redis* 
or *Azure Cache for Redis*), you will have to enable keyspace event notifications 
using the respective cloud console interfaces. If you are setting up a standalone 
Redis server, enabling keyspace event notifications can be done in the 
*redis.conf* file by adding or uncommenting the following line:

```
notify-keyspace-events Egx
```

DHIS2 will connect to Redis if the *redis.enabled* configuration
property in `dhis.conf` is set to *on* along with the following properties:

- *redis.host*: Specifies where the redis server is running. Defaults to *localhost*. Mandatory.

- *redis.port*: Specifies the port in which the redis server is listening. Defaults to *6379*. Optional.

- *redis.password*: Specifies the authentication password. If a password is not required it can be left blank.

- *redis.use.ssl*: Specifies whether the Redis server has SSL enabled. Defaults to false. Optional. Defaults to *false*.

When Redis is enabled, DHIS2 will automatically assign one of the
running instances as the leader of the cluster. The leader instance will
be used to execute jobs or scheduled tasks that should be run
exclusively by one instance. Optionally you can configure the
*leader.time.to.live.minutes* property in `dhis.conf` to set up how
frequently the leader election needs to occur. It also gives an
indication of how long it would take for another instance to take over
as the leader after the previous leader has become unavailable. The
default value is 2 minutes. Note that assigning a leader in the cluster
is only done if Redis is enabled. An example snippet of the `dhis.conf`
configuration file with Redis enabled and leader election time
configured is shown below.

```properties
# Redis Configuration

redis.enabled = on

# Shared Redis configuration
redis.host = REDIS_HOST
redis.port = REDIS_PORT
redis.password = PASSWORD (Optional, only if enabled on Redis server)
redis.use.ssl = true (Optional, only if enabled on Redis server)

# Optional, defaults to 2 minutes
leader.time.to.live.minutes=4 
```

### Files folder configuration

DHIS 2 will store several types of files outside the application itself,
such as apps, files saved in data entry and user avatars. When deployed
in a cluster, the location of these files must be shared across all instances.
On the local filesystem, the location is:

```
{DHIS2_HOME}/files
```

Here, `DHIS2_HOME` refers to the location of the DHIS 2 configuration file
as specified by the DHIS 2 environment variable, and `files` is the file
folder immediately below.

There are two ways to achieve a shared location:

* Use the *AWS S3 cloud filestorage* option. Files will be stored in an
S3 bucket which is automatically shared by all DHIS 2 instances in the cluster.
See the *File store configuration* section for guidance.
* Set up a shared folder which is shared among all DHIS 2 instances and
servers in the cluster. On Linux this can be achieved with *NFS* (Network File System)
which is a distributed file system protocol. Note that only the `files` 
subfolder under `DHIS2_HOME` should be shared, not the parent folder. 

### Load balancer configuration { #install_load_balancing } 

With a cluster of Tomcat instances set up, a common approach for routing
incoming web requests to the backend instances participating in the
cluster is using a *load balancer*. A load balancer will make sure that
load is distributed evenly across the cluster instances. It will also
detect whether an instance becomes unavailable, and if so, stop routine
requests to that instance and instead use other available instances.

Load balancing can be achieved in multiple ways. A simple approach is
using *nginx*, in which case you will define an *upstream* element which
enumerates the location of the backend instances and later use that
element in the *proxy* location block.

```text
http {

  # Upstream element with sticky sessions

  upstream dhis_cluster {
    ip_hash;
    server 193.157.199.131:8080;
    server 193.157.199.132:8080;
  }

  # Proxy pass to backend servers in cluster

  server {
    listen 80;

    location / {
      proxy_pass   http://dhis_cluster/;
    }
  }
}  
```

DHIS 2 keeps server-side state for user sessions to a limited degree.
Using "sticky sessions" is a simple approach to avoid replicating the
server session state by routing requests from the same client to the
same server. The *ip\_hash* directive in the upstream element ensures
this.

Note that several instructions have been omitted for brevity in the
above example. Consult the reverse proxy section for a detailed guide.

## ActiveMQ Artemis configuration { #webapi_artemis_configuration } 

By default DHIS2 will start an embedded instance of ActiveMQ Artemis when booting up. For most use-cases, you do not need to do anything. If you have an existing ActiveMQ Artemis service you want to use instead of the embedded instance you can change the default configuration in your `dhis.conf` file with the configuration properties in the following table.

| Property                  | Value (default first) | Description                                                  |
| ------------------------- | --------------------- | ------------------------------------------------------------ |
| artemis.mode                 | EMBEDDED \| NATIVE    | The default `EMBEDDED` mode starts up an internal AMQP service when the DHIS2 instance is starting up. If you want to connect to an external AMQP service, set the mode to `NATIVE`. |
| artemis.host                 | 127.0.0.1             | Host to bind to.                                             |
| artemis.port                 | 15672                 | If mode is `EMBEDDED`, the embedded server will bind to this port. If mode is `NATIVE`, the client will use this port to connect. |
| artemis.username             | guest                 | Username to connect to if using `NATIVE` mode.               |
| artemis.password             | guest                 | Password to connect to if using `NATIVE` mode.               |
| artemis.embedded.persistence | off \| on         | If mode is `EMBEDDED`, this property controls persistence of the internal queue. |


## Monitoring

DHIS 2 can export Prometheus compatible metrics for monitoring DHIS2 instances. The DHIS2 monitoring infrastructure is designed to expose metrics related to the application runtime and other application-related information.

Infrastructure related metrics (such as host metrics, Tomcat or Postgres) are not directly exposed by the application monitoring engine and they have to be collected separately. The metrics currently exposed by the application are:

- DHIS 2 API (response time, number of calls, etc.)
- JVM (Heap size, Garbage collection, etc.)
- Hibernate (Queries, cache, etc)
- C3P0 Database pool
- Application uptime
- CPU

Monitoring can be enabled in `dhis.conf` with the following properties (default is `off` for all properties):

```properties
monitoring.api.enabled = on
monitoring.jvm.enabled = on
monitoring.dbpool.enabled = on
monitoring.hibernate.enabled = off
monitoring.uptime.enabled = on
monitoring.cpu.enabled = on
```

The recommended approach for collecting and visualizing these metrics is through Prometheus and Grafana. 

For more information, see the [monitoring infrastructure](https://github.com/dhis2/wow-backend/blob/master/guides/monitoring.md) page and the [Prometheus and Grafana install](#monitoring) chapter.

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

```properties
metadata.sync.remote_servers_allowed = https://server1.org/,https://server2.org/
```

Sets the allowed list of servers to be called in relation to the [metadata pull](#webapi_sync_metadata_pull) functionality. It accepts comma-separated values, and it's recommended that each server end with a `/` for enhanced security. Default value is empty.


## Reverse proxy configuration { #install_reverse_proxy_configuration } 

A reverse proxy is a proxy server that acts on behalf of a server. Using
a reverse proxy in combination with a servlet container is optional but
has many advantages:

  - Requests can be mapped and passed on to multiple servlet containers.
    This improves flexibility and makes it easier to run multiple
    instances of DHIS2 on the same server. It also makes it possible to
    change the internal server setup without affecting clients.

  - The DHIS2 application can be run as a non-root user on a port
    different than 80 which reduces the consequences of session
    hijacking.

  - The reverse proxy can act as a single SSL server and be configured
    to inspect requests for malicious content, log requests and
    responses and provide non-sensitive error messages which will
    improve security.

### Basic nginx setup { #install_basic_nginx_setup } 

We recommend using [nginx](http://www.nginx.org) as a reverse proxy due to
its low memory footprint and ease of use. To install invoke the
following:

    sudo apt-get install -y nginx

nginx can now be started, reloaded and stopped with the following
commands:

    sudo /etc/init.d/nginx start
    sudo /etc/init.d/nginx reload
    sudo /etc/init.d/nginx stop

Now that we have installed nginx we will now continue to configure
regular proxying of requests to our Tomcat instance, which we assume
runs at `http://localhost:8080`. To configure nginx you can open the
configuration file by invoking:

    sudo nano /etc/nginx/nginx.conf

nginx configuration is built around a hierarchy of blocks representing
http, server and location, where each block inherits settings from parent
blocks. The following snippet will configure nginx to proxy pass
(redirect) requests from port 80 (which is the port nginx will listen on
by default) to our Tomcat instance. Include the following configuration
in nginx.conf:

```text
http {
  gzip on; # Enables compression, incl Web API content-types
  gzip_types
	"application/json;charset=utf-8" application/json
	"application/javascript;charset=utf-8" application/javascript text/javascript
	"application/xml;charset=utf-8" application/xml text/xml
	"text/css;charset=utf-8" text/css
	"text/plain;charset=utf-8" text/plain;

  server {
	listen               80;
	client_max_body_size 10M;

	# Proxy pass to servlet container

	location / {
	  proxy_pass                http://localhost:8080/;
	  proxy_redirect            off;
	  proxy_set_header          Host               $host;
	  proxy_set_header          X-Real-IP          $remote_addr;
	  proxy_set_header          X-Forwarded-For    $proxy_add_x_forwarded_for;
	  proxy_set_header          X-Forwarded-Proto  http;
	  proxy_buffer_size         128k;
	  proxy_buffers             8 128k;
	  proxy_busy_buffers_size   256k;
	  proxy_cookie_path         ~*^/(.*) "/$1; SameSite=Lax";
	}
  }
}
```

You can now access your DHIS2 instance at *http://localhost*. Since the
reverse proxy has been set up we can improve security by making Tomcat
only listen for local connections. In */conf/server.xml* you can add an
*address* attribute with the value *localhost* to the Connector element
for HTTP 1.1 like this:

```xml
<Connector address="localhost" protocol="HTTP/1.1" />
```

### Enabling SSL with nginx { #install_enabling_ssl_on_nginx } 

In order to improve security it is recommended to configure the server
running DHIS2 to communicate with clients over an encrypted connection
and to identify itself to clients using a trusted certificate. This can
be achieved through SSL which is a cryptographic communication protocol
running on top of TCP/IP. First, install the required *openssl* library:

    sudo apt-get install -y openssl

To configure nginx to use SSL you will need a proper SSL certificate
from an SSL provider. The cost of a certificate varies a lot depending
on encryption strength. An affordable certificate from [Rapid SSL
Online](http://www.rapidsslonline.com) should serve most purposes. To
generate the CSR (certificate signing request) you can invoke the
command below. When you are prompted for the *Common Name*, enter the
fully qualified domain name for the site you are
    securing.

    openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr

When you have received your certificate files (.pem or .crt) you will
need to place it together with the generated server.key file in a
location which is reachable by nginx. A good location for this can be
the same directory as where your nginx.conf file is located.

Below is an nginx server block where the certificate files are named
server.crt and server.key. Since SSL connections usually occur on port
443 (HTTPS) we pass requests on that port (443) on to the DHIS2 instance
running on `http://localhost:8080`. The first server block will rewrite
all requests connecting to port 80 and force the use of HTTPS/SSL. This
is also necessary because DHIS2 is using a lot of redirects internally
which must be passed on to use HTTPS. Remember to replace
*\<server-ip\>* with the IP of your server. These blocks should replace
the one from the previous section.

```text
http {
  gzip on; # Enables compression, incl Web API content-types
  gzip_types
	"application/json;charset=utf-8" application/json
	"application/javascript;charset=utf-8" application/javascript text/javascript
	"application/xml;charset=utf-8" application/xml text/xml
	"text/css;charset=utf-8" text/css
	"text/plain;charset=utf-8" text/plain;

  # HTTP server - rewrite to force use of SSL

  server {
	listen     80;
	rewrite    ^ https://<server-url>$request_uri? permanent;
  }

  # HTTPS server

  server {
	listen               443 ssl;
	client_max_body_size 10M;

	ssl                  on;
	ssl_certificate      server.crt;
	ssl_certificate_key  server.key;

	ssl_session_cache    shared:SSL:20m;
	ssl_session_timeout  10m;

	ssl_protocols              TLSv1 TLSv1.1 TLSv1.2;
	ssl_ciphers                RC4:HIGH:!aNULL:!MD5;
	ssl_prefer_server_ciphers  on;

	# Proxy pass to servlet container

	location / {
	  proxy_pass                http://localhost:8080/;
	  proxy_redirect            off;
	  proxy_set_header          Host               $host;
	  proxy_set_header          X-Real-IP          $remote_addr;
	  proxy_set_header          X-Forwarded-For    $proxy_add_x_forwarded_for;
	  proxy_set_header          X-Forwarded-Proto  https;
	  proxy_buffer_size         128k;
	  proxy_buffers             8 128k;
	  proxy_busy_buffers_size   256k;
	  proxy_cookie_path         ~*^/(.*) "/$1; SameSite=Lax";
	}
  }
}
```

Note the last `https` header value which is required to inform the
servlet container that the request is coming over HTTPS. In order for
Tomcat to properly produce `Location` URL headers using HTTPS you also need
to add two other parameters to the Connector in the Tomcat `server.xml` file:

```xml
<Connector scheme="https" proxyPort="443" />
```

### Enabling caching with nginx { #install_enabling_caching_ssl_nginx } 

Requests for reports, charts, maps and other analysis-related resources
will often take some time to respond and might utilize a lot of server
resources. In order to improve response times, reduce the load on the
server and hide potential server downtime we can introduce a cache proxy
in our server setup. The cached content will be stored in directory
/var/cache/nginx, and up to 250 MB of storage will be allocated. Nginx
will create this directory automatically.

```text
http {
  ..
  proxy_cache_path  /var/cache/nginx  levels=1:2  keys_zone=dhis:250m  inactive=1d;


  server {
	..

	# Proxy pass to servlet container and potentially cache response

	location / {
	  proxy_pass                http://localhost:8080/;
	  proxy_redirect            off;
	  proxy_set_header          Host               $host;
	  proxy_set_header          X-Real-IP          $remote_addr;
	  proxy_set_header          X-Forwarded-For    $proxy_add_x_forwarded_for;
	  proxy_set_header          X-Forwarded-Proto  https;
	  proxy_buffer_size         128k;
	  proxy_buffers             8 128k;
	  proxy_busy_buffers_size   256k;
	  proxy_cookie_path         ~*^/(.*) "/$1; SameSite=Lax";
	  proxy_cache               dhis;
	}
  }
}
```

> **Important**
> 
> Be aware that a server side cache shortcuts the DHIS2 security
> features in the sense that requests which hit the server side cache
> will be served directly from the cache outside the control of DHIS2
> and the servlet container. This implies that request URLs can be
> guessed and reports retrieved from the cache by unauthorized users.
> Hence, if you capture sensitive information, setting up a server side
> cache is not recommended.

### Rate limiting with nginx { #install_rate_limiting } 

Certain web API calls in DHIS 2, like the `analytics` APIs, are compute intensive. As a result it is favorable to rate limit these APIs in order to allow all users of the system to utilize a fair share of the server resources. Rate limiting can be achieved with `nginx`. There are numerous approaches to achieving rate limiting and this is intended to document the nginx-based approach.

The below nginx configuration will rate limit the `analytics` web API, and has the following elements at the *http* and *location* block level (the configuration is shortened for brevity):

```text
http {
  ..
  limit_req_zone $binary_remote_addr zone=limit_analytics:10m rate=5r/s;

  server {
    ..
        
    location ~ ^/api/(\d+/)?analytics(.*)$ {
      limit_req    zone=limit_analytics burst=20;
      proxy_pass   http://localhost:8080/api/$1analytics$2$is_args$args;
      ..
    }
  }
}
```

The various elements of the configuration can be described as:

- *limit_req_zone $binary_remote_addr*: Rate limiting is done per request IP.
- *zone=limit_analytics:20m*: A rate limit zone for the analytics API which can hold up to 10 MB of request IP addresses.
- *rate=20r/s*: Each IP is granted 5 requests per second.
- *location ~ ^/api/(\d+/)?analytics(.\*)$*: Requests for the analytics API endpoint are rate limited.
- *burst=20*: Bursts of up to 20 requests will be queued and serviced at a later point; additional requests will lead to a `503`.

For a full explanation please consult the [nginx documentation](https://www.nginx.com/blog/rate-limiting-nginx/).

### Making resources available with nginx { #install_making_resources_available_with_nginx } 

In some scenarios it is desirable to make certain resources publicly
available on the Web without requiring authentication. One example is
when you want to make data analysis related resources in the web API
available in a Web portal. The following example will allow access to
charts, maps, reports, report table and document resources through basic
authentication by injecting an *Authorization* HTTP header into the
request. It will remove the Cookie header from the request and the
Set-Cookie header from the response in order to avoid changing the
currently logged in user. It is recommended to create a user for this
purpose given only the minimum authorities required. The Authorization
value can be constructed by Base64-encoding the username appended with a
colon and the password and prefix it "Basic ", more precisely "Basic
base64\_encode(username:password)". It will check the HTTP method used
for requests and return *405 Method Not Allowed* if anything but GET is
detected.

It can be favorable to set up a separate domain for such public users
when using this approach. This is because we don't want to change the
credentials for already logged in users when they access the public
resources. For instance, when your server is deployed at somedomain.com,
you can set a dedicated subdomain at api.somedomain.com, and point URLs
from your portal to this subdomain.

```text
http {
  ..
  
  server {
    listen       80;
    server_name  api.somedomain.com;

    location ~ ^/(api/(charts|chartValues|reports|reportTables|documents|maps|organisationUnits)|dhis-web-commons/javascripts|images|dhis-web-commons-ajax-json|dhis-web-mapping|dhis-web-visualizer) {
    if ($request_method != GET) {
        return 405;
      }

      proxy_pass         http://localhost:8080;
      proxy_redirect     off;
      proxy_set_header   Host               $host;
      proxy_set_header   X-Real-IP          $remote_addr;
      proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto  http;
      proxy_set_header   Authorization      "Basic YWRtaW46ZGlzdHJpY3Q=";
      proxy_set_header   Cookie             "";
      proxy_hide_header  Set-Cookie;
    }
  }
}
```


### Block specific Android App versions with nginx { #install_block_android_versions } 

In some scenarios the system administrator might want to block certain Android clients based on its DHIS2 App version. For example, if the users on the field have not updated their Android App version to a specific one and the system administrator wants to block their access to force an update; or completely the opposite scenario when the system administrator wants to block new versions of the App as they have not been yet tested. This can be easily implemented by using specific *User-Agent* rules in the `nginx` configuration file.

```text
http {
  
  server {
    listen       80;
    server_name  api.somedomain.com;
    
    # Block the latest Android App as it has not been tested
    if ( $http_user_agent ~ 'com\.dhis2/1\.2\.1/2\.2\.1/' ) {
        return 403;
    }
    
    # Block Android 4.4 (API is 19) as all users should have received new tablets
    if ( $http_user_agent ~ 'com\.dhis2/.*/.*/Android_19' ) {
        return 403;
    }
  }
}
```

> **Note**
> For the implementation of the method described above note the following: 
> * Before version 1.1.0 the *User-Agent* string was not being sent.
> * From version 1.1.0 to 1.3.2 the *User-Agent* followed the pattern Dhis2/AppVersion/AppVersion/Android_XX
> * From version 2.0.0 and above the *User-Agent* follows the pattern com.dhis2/SdkVersion/AppVersion/Android_XX
> * Android_XX refers to the Android API level i.e. the Android version as listed [here](https://developer.android.com/studio/releases/platforms).
> * nginx uses [PCRE](http://www.pcre.org/) for Regular Expression matching .

## DHIS2 configuration reference (dhis.conf) { #install_dhis2_configuration_reference } 

The following describes the full set of configuration options for the `dhis.conf` configuration file. The configuration file should be placed in a directory which is pointed to by a `DHIS2_HOME` environment variable.

> **Note**
>
> You should not attempt to use this configuration file directly, rather use it as a reference for the available configuration options. Many of the properties are optional.

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
# Database connection pool [Optional]
# ----------------------------------------------------------------------

# Deprecated since v43. Minimum number of Connections a pool will maintain at any given time (default: 5).
connection.pool.min_size = 5

# Deprecated since v43. Number of connections a pool will try to acquire upon startup. Should be between minPoolSize and maxPoolSize.
connection.pool.initial_size = 5

# Deprecated since v43. Determines how many connections at a time will try to acquire when the pool is exhausted.
connection.pool.acquire_incr = 5

# Seconds a Connection can remain pooled but unused before being discarded. Zero means idle connections never expire. (default: 7200)
connection.pool.max_idle_time = 7200

# Deprecated since v43. Number of seconds that connections in excess of minPoolSize is permitted to remain idle in the pool before being culled (default: 0)
connection.pool.max_idle_time_excess_con = 0

# Deprecated since v43. If greater than 0, dhis2 will test all idle, pooled but unchecked-out connections, every this number of seconds. (default: 0)
connection.pool.idle.con.test.period = 0

# Deprecated since v43. If on, an operation will be performed at every connection checkout to verify that the connection is valid. (default: false)
connection.pool.test.on.checkout = false

# Deprecated since v43. If on, an operation will be performed asynchronously at every connection checkin to verify that the connection is valid. (default: on)
connection.pool.test.on.checkin = on

# Determines the query that will be executed for all connection tests
connection.pool.preferred.test.query = select 1

# Deprecated since v43. Determines the number of helper threads used by dhis2 for jdbc operations. (default: 3)
connection.pool.num.helper.threads = 3

# Minimum number of idle connections to maintain (default: 10)
connection.pool.min_idle = 10

# Interval to keep idle connections alive. Does not reset idle timeout (default: 2 minutes)
connection.pool.keep_alive_time_seconds = 120

# Connection max lifetime. An in-use connection will never be retired, only when it is idle will
# it be removed. (default: 30 minutes).
connection.pool.max_lifetime_seconds =  1800

# Database datasource pool type. Supported pool types are: hikari (default), c3p0 (deprecated), unpooled
db.pool.type = hikari

# ----------------------------------------------------------------------
# Server [Mandatory]
# ----------------------------------------------------------------------

# Base URL to the DHIS 2 instance
server.base.url = https://play.dhis2.org/dev 

# Enable secure settings if system is deployed on HTTPS, can be 'off', 'on'
server.https = off

# ----------------------------------------------------------------------
# System [Optional]
# ----------------------------------------------------------------------

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
metadata.sync.remote_servers_allowed = https://server1.org/,https://server2.org/

# ----------------------------------------------------------------------
# Encryption [Optional]
# ----------------------------------------------------------------------

# Encryption password (sensitive)
encryption.password = xxxx

# ----------------------------------------------------------------------
# File store [Optional]
# ----------------------------------------------------------------------

# File store provider. Currently 'filesystem' (default), 'aws-s3' and 's3' are supported.
filestore.provider = filesystem

# Directory / bucket name, folder below DHIS2_HOME on file system, 'bucket' in AWS S3
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
# Analytics database [Optional]
# ----------------------------------------------------------------------

# Analytics database JDBC driver class
analytics.connection.driver_class = org.postgresql.Driver

# Analytics database connection URL
analytics.connection.url = jdbc:postgresql:analytics

# Analytics database username
analytics.connection.username = analytics

# Analytics database password
analytics.connection.password = xxxx

# ----------------------------------------------------------------------
# Analytics database [Optional]
# ----------------------------------------------------------------------

# Analytics unlogged tables. Can be 'on' (default), 'off'.
analytics.table.unlogged = on

# Dimensions to skip indexes for analytics tables
# analytics.table.skip_index = EC40NXmsTVu,gtuVl6NbXQV,LFsZ8v5v7rq,\
                yY2bQYqNt0o,eLwL77Z9E7R,WnouSiGrbgy,\
                veGzholzPQm,qzsxBXFf5yb,SooXFOUnciJ

# Period type columns to skip for analytics tables
# analytics.table.skip_column = weeklywednesday,weeklythursday,weeklysaturday,\
                weeklysunday,biweekly,quarterlynov,\
                sixmonthlyapril,financialapril,financialjuly

# ----------------------------------------------------------------------
# System telemetry [Optional]
# ----------------------------------------------------------------------

# System monitoring URL
system.monitoring.url = 

# System monitoring username
system.monitoring.username = dhis

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
apphub.base.url = https://apps.dhis2.org

# Base API URL to the DHIS2 App Hub service, used for app updates
apphub.api.url = https://apps.dhis2.org/api

# ----------------------------------------------------------------------
# Sessions [Optional]
# ----------------------------------------------------------------------

# Number of possible concurrent sessions across different clients per user
max.sessions.per_user = 10

# ----------------------------------------------------------------------
# Metadata Model Consistency [Optional]
# ----------------------------------------------------------------------
# The maximum number of category options in a single category
metadata.categories.max_options = 31

# The maximum number of categories per category combo
metadata.categories.max_per_combo = 5

# The maximum for the product of the number of options of the categories in a category combo
# Must always be >= metadata.categories.max_options
metadata.categories.max_combinations = 500

# ----------------------------------------------------------------------
# Route API [Optional]
# ----------------------------------------------------------------------
#
# Remote servers allowed to call from the route endpoint. Default is any HTTPS URL. Wildcards are allowed. 
# e.g. route.remote_servers_allowed = https://server1.com/,https://server2.com/,https://192.168.*.*
route.remote_servers_allowed = https://*
```

## Changelog { #install_changelog } 

DHIS2 writes entries to changelogs when certain entities were changed in the system. The entities fall within two categories: _Aggregate_ and _tracker_. The _aggregate_ category includes changes to aggregate data values. The _tracker_ category includes changes to program instances, program temporary ownership items, tracked entity attribute values and tracked entity data values.

The changelog for both categories are enabled by default. You can control whether to enable or disable the changelog by category through the `dhis.conf` configuration file using the properties described below. Property options are `on` (default) and `off`.

The benefit of the changelog is the ability to see changes which have been performed to the data. The benefits of disabling the changelog is a minor performance improvement by avoiding the cost of writing changelog items to the database, and less database storage used. It is recommended to enable changelog, and great care should be taken if disabling it.

```properties
# Aggregate changelog, can be 'on', 'off'
changelog.aggregate = on

# Tracker changelog, can be 'on', 'off'
changelog.tracker = on
```

## Application logging { #install_application_logging } 

This section covers application logging in DHIS 2.

### Log files

The DHIS2 application log output is directed to multiple files and locations. First, log output is sent to standard output. The Tomcat servlet container usually outputs standard output to a file under "logs":

    <tomcat-dir>/logs/catalina.out

Second, log output is written to a "logs" directory under the DHIS2 home directory as defined by the `DHIS2_HOME` environment variables. There is a main log file for all output, and separate log files for various
background processes. The main file includes the background process logs as well. The log files are capped at 50 Mb and log content is continuously appended.

    <DHIS2_HOME>/logs/dhis.log    
    <DHIS2_HOME>/logs/dhis-analytics-table.log
    <DHIS2_HOME>/logs/dhis-data-exchange.log
    <DHIS2_HOME>/logs/dhis-data-sync.log

### Log configuration

To override the default log configuration you can specify a Java system
property with the name `log4j2.configurationFile` and a value pointing to the
[Log4j version 2](https://logging.apache.org/log4j/2.x/manual/configuration.html)
configuration file at the file system like this:

```properties
-Dlog4j2.configurationFile=/home/dhis/config/log4j2.properties
```

Java system properties can be set e.g. through the *JAVA\_OPTS* environment variable or in the tomcat startup script.

A second approach to overriding the log configuration is to specify logging properties in the `dhis.conf` configuration file. The supported properties are:

```properties
# Max size for log files, default is '100MB'
logging.file.max_size = 250MB

# Max number of rolling log archive files, default is 0
logging.file.max_archives = 2
```

DHIS2 will eventually phase out logging to standard out / catalina.out and as a result it is recommended to rely on the logs under `DHIS2_HOME`.

DHIS2 will provide the following context values:

* `sessionId`: Current user's session ID
* `xRequestID`: An alphanumeric ID as send by the `X-Request-ID` HTTP header for the currently processed request; empty if not provided

To use the context variables in the log add them using `-X{<name>}` to your log pattern as in this example:

    * %-5p %d{ISO8601} %m (%F [%t]) %X{sessionId} %X{xRequestID}%n

### Log level configuration

To set the log level of individual packages you can specify properties on the format  `logging.level.{package-names}` in `dhis.conf`. For example, to set the the log level for the entire Spring Framework to DEBUG and up, you can specify:

```
logging.level.org.springframework = DEBUG
```
To set the log level to DEBUG for the DHIS2 services, you can specify:

```
logging.level.org.hisp.dhis = DEBUG
```

Common log levels are `DEBUG`, `INFO`, `WARN` and `ERROR`.

> **Note**
> 
> Log level configuration is not supported for the embedded DHIS2 Jetty version.

## Working with the PostgreSQL database { #install_working_with_the_postgresql_database } 

Common operations when managing a DHIS2 instance are dumping and restoring databases. Note that when making backups of the DHIS 2 database, it is good practice to exclude tables which are generated by the system, such as the resource and analytics tables. To make a dump (copy) of your database to a file,  you can invoke the following command.

```bash
pg_dump {database} -U {user} -T "_*" -T "analytics*"  -f {filename}
```
In the following example, the database name is `dhis2`, the user is `dhis` and the output filename is `dhis2.sql`:

```bash
pg_dump dhis2 -U dhis -T "analytics*" -T "_*" -f dhis2.sql
```

It is good practice to compress the output file with `gzip`, which can be done like this:

```bash
pg_dump dhis2 -U dhis -T "analytics*" -T "_*" | gzip > dhis2.sql.gz
```

To restore the database copy on another system, you first need to create an empty database as described in the installation section. You also need to `gunzip` the copy if you created a compressed version. To restore the copy you can invoke the following command:

```bash
psql -d dhis2 -U dhis -f dhis2.sql
```

To restore a compressed database copy, without having to extract it first:

```bash
gunzip -c dhis2.sql.gz | psql -d dhis2 -U dhis
```

