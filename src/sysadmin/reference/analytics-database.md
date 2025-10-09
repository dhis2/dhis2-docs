# Analytics database { #install_analytics_database } 

DHIS2 allows for utilizing a dedicated analytics database for analytics tables. The supported database systems are:

* [Apache Doris](https://doris.apache.org/)
* [ClickHouse](https://clickhouse.com/)

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
