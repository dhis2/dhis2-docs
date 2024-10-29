# Installation { #installation_on_linux_server } 
## Server setup { #install_server_setup } 
This guide covers manual DHIS2 installation on Ubuntu 22.04 or 24.04. DHIS2
uses PostgreSQL for data storage and runs on a Tomcat server. Additional
components like a proxy server (nginx or Apache) and monitoring tools (Munin or
Zabbix) are recommended for a more robust setup. While these components can run
on separate servers, this guide assumes a single-server configuration for
simplicity.

This guide provides a detailed outline for DHIS2 deployment, intended mainly as
a reference for general installation practices. Setup steps can vary depending
on factors like operating system, database choice, and other configurations.
Here, the term `invoke` refers to running a command directly in the terminal.

For this guide we assume that 8 Gb RAM is allocated for PostgreSQL and 8
GB RAM is allocated for Tomcat/JVM, and that a 64-bit operating system
is used. *If you are running a different configuration please adjust the
suggested values accordingly\!*

We recommend that the available memory is split roughly equally between the
database and the JVM. Remember to leave some of the physical memory to the
operating system for it to perform its tasks, for instance around 2 GB. The
steps marked as *optional*, like the step for performance tuning, can be done
at a later stage.

### Creating a user to run DHIS2 { #install_creating_user } 
DHIS2 on Tomcat should never be run as the `root` user. Instead, create a
standard user and use it to run the Tomcat instance to enhance security.,

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
sudo -u dhis mkdir /home/dhis/config
```

DHIS2 will look for an environment variable called `DHIS2_HOME` to
locate the DHIS2 configuration directory. This directory will be
referred to as `DHIS2_HOME` in this installation guide. We will define
the environment variable in a later step in the installation process.

If no environment variable `DHIS2_HOME` is found, the default 
configuration file location `/opt/dhis2` is used.

### Setting server timezone and locale { #install_setting_server_tz } 

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

Install PostgreSQL with below steps

```sh
# Create the file repository configuration:
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

# Update the package lists:
sudo apt update -y 

# install postgresql
sudo apt-get install -y postgresql-16 postgresql-16-postgis-3

# Ensure postgresql is started and enabled
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

Create a non-privileged database user called *dhis* by invoking:

```sh
sudo -u postgres createuser -SDRP dhis
```

Enter a secure password at the prompt.

> Note
>
> This database user and password will be used by your DHIS2 application to
> connect to the database. You will need to write down this user and password
> in the  `dhis.conf`  file at a later stage.

Create a database called `dhis2` owned by `dhis` by invoking:

```sh
sudo -u postgres createdb -O dhis dhis2
```

<!-- Return to your session by invoking `exit` You now have a PostgreSQL user -->
<!-- called *dhis* and a database called *dhis2*. -->

The *PostGIS* extension is needed for several GIS/mapping features to
work. DHIS2 will attempt to install the PostGIS extension during
startup. If the DHIS2 database user does not have permission to create
extensions you can create it from the console using the *postgres* user
with the following commands:

```sh
sudo -u postgres psql -c "create extension postgis;" dhis2
```

For adding trigram indexes and compounding it with primitive column types, two
extensions have to be created in the database for DHIS 2 verision 2.38 and
later. The extensions are already part of the default posgresql installation:

```sh
sudo -u postgres psql -c "create extension btree_gin;" dhis2
sudo -u postgres psql -c "create extension pg_trgm;" dhis2
```

<!-- Exit the console and return to your previous user with *\\q* followed by -->
<!-- *exit*. -->

### DHIS2 configuration { #install_database_configuration } 

The database connection information is provided to DHIS2 through a
configuration file called `dhis.conf`. Create this file and save it in
the `DHIS2_HOME` directory. As an example this location could be:

```sh
sudo -u dhis touch /home/dhis/config/dhis.conf
```

A configuration file for PostgreSQL corresponding to the above setup has
these properties:

Edit the file and add the content looking like below, 

```
sudo -u dhis vim /home/dhis/config/dhis.conf
```
 
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
```

### Java installation { #install_java_installation } 

| DHIS2 version | JDK recommended | JDK required |
|:--------------|:---------------:|:-------------|
| 2.41          | 17              | 17           |
| 2.40          | 17              | 11           |
| 2.38          | 11              | 11           |
| 2.35          | 11              | 8            |
| pre 2.35      | 8               | 8            |

The recommended Java JDK for DHIS2 2.40 and above is OpenJDK 17, its required for 2.41. 
```
sudo apt-get install -y openjdk-17-jdk
```
The recommended Java JDK for DHIS2 2.35 - 2.40 is OpenJDK 11. You can install it with the following command:
```
sudo apt-get install -y openjdk-11-jdk
```
For dhis2 versions below  v2.35, OpenJDK 8 is required. Install it with this command:
```
sudo apt-get install -y openjdk-8-jdk
```
Verify that your installation is correct by invoking:
```
java -version
```

### Tomcat and DHIS2 installation { #install_tomcat_dhis2_installation } 

To install the Tomcat servlet container we will utilize the Tomcat user
package by invoking:

```sh
sudo apt-get install -y tomcat9-user
```

This package lets us easily create a new Tomcat instance. The instance
will be created in the current directory. An appropriate location is the
home directory of the `dhis` user:

```sh
sudo tomcat9-instance-create /home/dhis/tomcat-dhis
sudo chown -R dhis:dhis /home/dhis/tomcat-dhis/
```

This will create an instance in a directory called `/home/dhis/tomcat-dhis`. Note
that the `tomcat9-user` package allows for creating any number of DHIS2
instances if that is desired.

Next edit the file `/home/dhis/tomcat-dhis/bin/setenv.sh` and add the lines below.

`sudo -u dhis vim /home/dhis/tomcat-dhis/bin/setenv.sh`

```sh
export JAVA_HOME='/usr/lib/jvm/java-11-openjdk-amd64/'
export JAVA_OPTS='-Xms4000m -Xmx7000m'
export DHIS2_HOME='/home/dhis/config'
```

* `JAVA_HOME` sets the location of the JDK installation.
* `JAVA_OPTS` passes parameters to the JVM.
    * `-Xms` sets the initial allocation of memory to the Java heap memory space.
    * `-Xmx` sets the maximum allocation of memory to the Java heap memory space. This should reflect how much memory you would like to allocate to the DHIS 2 software application on your server.
* `DHIS2_HOME` sets the location of the `dhis.conf` configuration file for DHIS 2.

Check that the path the Java binaries are correct as they might vary from system to system, e.g. on AMD systems you might see
`/java-11-openjdk-amd64`. Note that you should adjust these values to your environment.


The Tomcat configuration file is located in
`/home/dhis/tomcat-dhis/conf/server.xml`. The element which defines the connection
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
An example of how do download dhis2 version v40.3.0
```
wget https://releases.dhis2.org/40/dhis2-stable-40.3.0.war
```

Move the WAR file into the Tomcat `webapps` directory. We want to call the
WAR file `ROOT.war` in order to make it available at `localhost` directly
without a context path:
Using war file downloaded with above wget example: 

```sh
sudo mv dhis2-stable-40.3.0.war /home/dhis/tomcat-dhis/webapps/ROOT.war
```

DHIS2 should never be run as a privileged user.
After you have modified the `setenv.sh` file, modify the `startup.sh` script to
check and verify that the script has not been invoked as root.

`sudo -u dhis vim  /home/dhis/tomcat-dhis/bin/startup.sh`

```sh
#!/bin/sh
set -e

if [ "$(id -u)" -eq "0" ]; then
  echo "This script must NOT be run as root" 1>&2
  exit 1
fi

export CATALINA_BASE="/home/dhis/tomcat-dhis"
/usr/share/tomcat9/bin/startup.sh
echo "Tomcat started"
```

### Running DHIS2 { #install_running_dhis2 } 

DHIS2 can now be started by invoking:

```sh
sudo -u dhis /home/dhis/tomcat-dhis/bin/startup.sh
```

> :bulb: **Important**
> 
> The DHIS2 server should never be run as root or other privileged user.

DHIS2 can be stopped by invoking:

    sudo -u dhis /home/dhis/tomcat-dhis/bin/shutdown.sh

To monitor the behavior of Tomcat the log is the primary source of
information. The log can be viewed with the following command:

    tail -f /home/dhis/tomcat-dhis/logs/catalina.out

Assuming that the WAR file is called ROOT.war, you can now access your
DHIS2 instance at the following URL:

    http://localhost:8080

## File store configuration { #install_file_store_configuration } 

DHIS2 is capable of capturing and storing files. By default, files will
be stored on the local file system of the server which runs DHIS2 in a *files*
directory under the `DHIS2_HOME` external directory location. 

You can also configure DHIS2 to store files on cloud-based storage
providers. AWS S3 is the only supported provider currently. To enable
cloud-based storage you must define the following additional properties
in your `dhis.conf` file:

```properties
# File store provider. Currently 'filesystem' and 'aws-s3' are supported.
filestore.provider = 'aws-s3'

# Directory in external directory on local file system and bucket on AWS S3
filestore.container = files

# The following configuration is applicable to cloud storage only (AWS S3)

# Datacenter location. Optional but recommended for performance reasons.
filestore.location = eu-west-1

# Username / Access key on AWS S3
filestore.identity = xxxx

# Password / Secret key on AWS S3 (sensitive)
filestore.secret = xxxx
```

This configuration is an example reflecting the defaults and should be
changed to fit your needs. In other words, you can omit it entirely if
you plan to use the default values. If you want to use an external
provider the last block of properties needs to be defined, as well as the
*provider* property is set to a supported provider (currently only
AWS S3).

> **Note**
> 
> If you’ve configured cloud storage in dhis.conf, all files you upload
> or the files the system generates will use cloud storage.

For a production system the initial setup of the file store should be
carefully considered as moving files across storage providers while
keeping the integrity of the database references could be complex. Keep
in mind that the contents of the file store might contain both sensitive
and integral information and protecting access to the folder as well as
making sure a backup plan is in place is recommended on a production
implementation.

> **Note**
> 
> AWS S3 is the only supported provider but more providers are likely to 
> be added in the future, such as Google Cloud Store and Azure Blob Storage.
> Let us know if you have a use case for additional providers.

## Google service account configuration { #install_google_service_account_configuration } 

DHIS2 can connect to various Google service APIs. For instance, the
DHIS2 GIS component can utilize the Google Earth Engine API to load map
layers. In order to provide API access tokens you must set up a Google
service account and create a private key:

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

