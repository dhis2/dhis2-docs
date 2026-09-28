# Analytics database { #install_analytics_database } 

DHIS2 allows for utilizing a dedicated analytics database for analytics tables. The supported database systems are:

* [Apache Doris](https://doris.apache.org/)
* [ClickHouse](https://clickhouse.com/)


## How it works { #analytics_database_how_it_works }

DHIS2 always uses PostgreSQL as its primary database. Metadata, data entry, tracker data and all other transactional operations continue to be handled by PostgreSQL, whether or not an analytics database is configured.

When an analytics database is configured, the analytics tables are moved out of PostgreSQL and into the analytics database:

1. **Analytics table generation** reads the transactional data from PostgreSQL, transforms it, and writes the resulting analytics tables into the analytics database. Some of the queries which build these tables join data in the analytics database with tables which remain in PostgreSQL. The analytics database must therefore be able to connect back to the PostgreSQL server, in addition to DHIS2 being able to connect to both.
2. **Analytics queries**, such as those made by the Data Visualizer and Maps apps, and by the analytics Web API endpoints, are executed against the analytics database rather than against PostgreSQL.

The effect is to move the read-intensive analytical workload off the PostgreSQL server, allowing it to be dedicated to transactional operations. For large databases, where analytics queries against PostgreSQL become slow due to data volume, this can significantly improve query performance.

> **Note**
>
> The analytics database is populated by analytics table generation only. It is not kept in sync with PostgreSQL in real time. Until analytics table generation has been run, the analytics tables will contain no data, and data captured after the most recent run will not appear in analytics until the next run.

Because the contents of the analytics database are derived entirely from the PostgreSQL database, the analytics database does not need to be backed up. It can be rebuilt at any time by running analytics table generation again.

Not all analytics tables are moved to the analytics database, and some analytics features are unavailable when one is in use. See [Limitations](#analytics_database_limitations) below.

## Limitations { #analytics_database_limitations }

When a dedicated analytics database is enabled, some analytics features are not available, because they depend on capabilities which exist only in PostgreSQL.

* **Spatial features**: features which rely on the PostGIS extension of PostgreSQL are not supported. For the Maps app, this means that event layers are currently not supported when using an analytics database.
* **Outlier detection**: outlier detection analytics are not supported. The analytics tables which support outlier detection cannot be generated in the analytics database, and analytics table generation will fail if it is attempted. Analytics table generation must therefore be run with the **Skip generation of outlier data** option enabled, both when started manually from the Data Administration app and when scheduled through the Scheduler app.
* **Subexpressions**: indicators which use [subexpressions](#indicator_subexpressions) are not supported. Support for subexpressions in the analytics database is being added, and is expected in a 2.43 patch release.

> **Important**
>
> The DHIS2 user interface does not currently hide or disable the features listed above when an analytics database is in use. Unsupported features remain visible and selectable, and will typically fail with a generic error message rather than an explanation that the feature is unavailable. Server administrators should therefore make implementers and users aware of these limitations.

Tracked entity analytics continue to use PostgreSQL as the underlying analytics database. These analytics tables are not exported to the analytics database, and queries against them are served by PostgreSQL. No configuration is required, but the PostgreSQL database will still carry the query load for tracked entity analytics.

## Configuration

The analytics database is configured in the `dhis.conf` configuration file.

### Apache Doris

Apache Doris is a highly scalable data warehouse for real-time analytics. Refer to the [documentation portal](https://doris.apache.org) for installation and configuration guidance.

Apache Doris uses the MySQL communication protocol and JDBC driver, and is designed with a backend/front-end architecture which separates query coordination from data storage.

The connection URL pattern is `jdbc::mysql://<hostname-or-ip>:<port>/<database-name>?<property>=<value>`.

```properties
# Analytics database management system
analytics.database = doris

# Analytics database connection URL
analytics.connection.url = jdbc:mysql://192.168.1.180:9030/analytics?useUnicode=true&characterEncoding=UTF-8

# Analytics database username
analytics.connection.username = dhis

# Analytics database password
analytics.connection.password = xxxx
```

### ClickHouse

ClickHouse is a highly scalable data warehouse for real-time analytics. Refer to the [documentation portal](https://clickhouse.com/docs) for installation and configuration guidance.

The connection URL pattern is `jdbc::clickhouse://<hostname-or-ip>:<port>/<database-name>`.

```properties
# Analytics database management system
analytics.database = clickhouse

# Analytics database connection URL
analytics.connection.url = jdbc:clickhouse://92.168.1.100:8123/analytics

# Analytics database username
analytics.connection.username = dhis

# Analytics database password
analytics.connection.password = admin
```
