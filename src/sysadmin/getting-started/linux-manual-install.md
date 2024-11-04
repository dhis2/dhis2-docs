# Installation { #installation_on_linux_server } 
## Server setup { #install_server_setup } 
This guide explains how to manually install DHIS2 on Ubuntu 22.04 or 24.04,
using PostgreSQL for data storage and Tomcat as the server. It also suggests
using a proxy (like nginx or Apache) and monitoring tools (like Munin or
Zabbix) for enhanced performance. Although all components can be hosted
separately, this guide focuses on a simple, single-server setup.

This guide is intended mainly as a reference for general installation
practices. Setup steps can vary depending on factors like operating system,
database choice, and other configurations. Here, the term `invoke` refers to
running a command directly in the terminal.

We recommend that the available memory is split roughly equally between the
database and the JVM. Remember to leave some of the physical memory to the
operating system for it to perform its tasks, for instance around 2 GB. The
steps marked as *optional*, like the step for performance tuning, can be done
at a later stage.

The [dhis2-server-tools](https://github.com/dhis2/dhis2-server-tools) automates
installation described in the guide and is recommended for production setups. 
It is described in detail in [QuickStart Section](#getting_started_quick_start)
section.

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

```bash
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

> **Note**
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
Check [PostgreSQL Performance Tuning](#install_postgresql_performance_tuning) for optimization parameters.

<!-- Exit the console and return to your previous user with *\\q* followed by -->
<!-- *exit*. -->
### Java installation { #install_java_installation } 

| DHIS2 version | JDK recommended | JDK required | Installation
|:--------------|:---------------:|:-------------|:----------------------------------------| 
| 2.41          | 17              | 17           |`sudo apt-get install -y openjdk-17-jdk` |
| 2.40          | 17              | 11           |`sudo apt-get install -y openjdk-11-jdk` |
| 2.38          | 11              | 11           |`sudo apt-get install -y openjdk-11-jdk` |
| 2.35          | 11              | 8            |`sudo apt-get install -y openjdk-11-jdk` |
| pre 2.35      | 8               | 8            |` sudo apt-get install -y openjdk-8-jdk` |

The recommended Java JDK for DHIS2 2.40 and above is OpenJDK 17, its required for 2.41. 
```
sudo apt-get install -y openjdk-17-jdk
```
The recommended Java JDK for DHIS2 2.35 - 2.40 is OpenJDK 11. Install it by invoking command below, 
```
sudo apt-get install -y openjdk-11-jdk
```
For dhis2 versions below 2.35, OpenJDK 8 is required. Install it by invoking command below, 
```
sudo apt-get install -y openjdk-8-jdk
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

If you only intend to use the key for the Google Earth Engine map layers, you
can simply send an email. See the [Google Earth Engine API key documentation](https://docs.dhis2.org/en/topics/tutorials/google-earth-engine-sign-up.html).

## Bing Maps API key { #install_bing_maps_api_key }

To enable use of Bing Maps basemap layers, you need to set up the Bing Maps API
key. See [Bing Maps API key documentation](https://www.microsoft.com/en-us/maps/bing-maps/create-a-bing-maps-key)
for information on setting up the key.

