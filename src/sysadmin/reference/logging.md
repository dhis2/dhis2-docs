# Application logging { #install_application_logging } 

This section covers application logging in DHIS2.

## Log files

The DHIS2 application log output is directed to multiple files and locations.
First, log output is sent to standard output. The Tomcat servlet container
usually outputs standard output to a file under "logs":

```properties

<tomcat-dir>/logs/catalina.out

```

Second, log output is written to a "logs" directory under the DHIS2 home
directory as defined by the `DHIS2_HOME` environment variables. There is a main
log file for all output, and separate log files for various background
processes. The main file includes the background process logs as well. The log
files are capped at 50 Mb and log content is continuously appended.
```properties

<DHIS2_HOME>/logs/dhis.log    
<DHIS2_HOME>/logs/dhis-analytics-table.log
<DHIS2_HOME>/logs/dhis-data-exchange.log
<DHIS2_HOME>/logs/dhis-data-sync.log

```

## Log configuration

To override the default log configuration you can specify a Java system
property with the name `log4j2.configurationFile` and a value pointing to the
[Log4j version 2](https://logging.apache.org/log4j/2.x/manual/configuration.html)
configuration file at the file system like this:

```properties
-Dlog4j2.configurationFile=/home/dhis/config/log4j2.properties
```

Java system properties can be set e.g. through the *JAVA\_OPTS* environment
variable or in the tomcat startup script.

A second approach to overriding the log configuration is to specify logging
properties in the `dhis.conf` configuration file. The supported properties are:

```properties
# Max size for log files, default is '100MB'
logging.file.max_size = 250MB

# Max number of rolling log archive files, default is 0
logging.file.max_archives = 2
```

DHIS2 will eventually phase out logging to standard out / catalina.out and as a
result it is recommended to rely on the logs under `DHIS2_HOME`.

DHIS2 will provide the following context values:

* `sessionId`: Current user's session ID
* `xRequestID`: An alphanumeric ID as send by the `X-Request-ID` HTTP header
  for the currently processed request; empty if not provided

To use the context variables in the log add them using `-X{<name>}` to your log
pattern as in this example:

    * %-5p %d{ISO8601} %m (%F [%t]) %X{sessionId} %X{xRequestID}%n

## Log level configuration

To set the log level of individual packages you can specify properties on the
format  `logging.level.{package-names}` in `dhis.conf`. For example, to set the
log level for the entire Spring Framework to DEBUG and up, you can specify:

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

## Changelog { #install_changelog } 

DHIS2 writes entries to changelogs when certain entities were changed in the
system. The entities fall within two categories: _Aggregate_ and _tracker_. The
_aggregate_ category includes changes to aggregate data values. The _tracker_
category includes changes to tracked entity attribute values and event data values.

The changelog for both categories are enabled by default. You can control
whether to enable or disable the changelog by category through the `dhis.conf`
configuration file using the properties described below. Property options are
`on` (default) and `off`.

The benefit of the changelog is the ability to see changes which have been
performed to the data. The benefits of disabling the changelog is a minor
performance improvement by avoiding the cost of writing changelog items to the
database, and less database storage used. It is recommended to enable
changelog, and great care should be taken if disabling it.

```properties
# Aggregate changelog, can be 'on' (default), 'off'
changelog.aggregate = on

# Tracker changelog, can be 'on' (default), 'off'
changelog.tracker = on
```
