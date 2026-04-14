# Configuring DHIS2 with Apache Doris

## Introduction

[Apache Doris](https://doris.apache.org/) is a high-performance, real-time analytical database. It is designed to execute complex analytical queries against large datasets with sub-second response times, making it well-suited for OLAP (Online Analytical Processing) workloads.

DHIS2 can leverage Apache Doris as a dedicated analytics database. When configured, DHIS2 exports its analytics tables to Doris, offloading heavy analytical queries from PostgreSQL. This separation allows PostgreSQL to focus on transactional operations (data entry, metadata management) while Doris handles the read-intensive analytics workload.

The performance benefits can be significant for large DHIS2 deployments where analytics queries against PostgreSQL become slow due to data volume. Doris uses a columnar storage format and a massively parallel processing (MPP) architecture, which are optimized for the kind of aggregation and filtering operations that DHIS2 analytics queries perform.

> **Note:** Apache Doris support requires DHIS2 version **2.43** or later and Apache Doris version **3.14** or later.

## How DHIS2 and Apache Doris interact

The integration between DHIS2 and Apache Doris involves bidirectional communication:

1. **DHIS2 → Doris**: DHIS2 connects to Doris to create and populate analytics tables and to execute analytics queries.
2. **Doris → PostgreSQL**: During the analytics table generation process, some SQL queries join tables stored in Doris with tables that remain in the PostgreSQL database. To perform these joins, Doris must be able to connect back to PostgreSQL.

Doris achieves this through its [multi-catalog](https://doris.apache.org/docs/lakehouse/database) feature. At startup, DHIS2 automatically creates a JDBC catalog in Doris that points to the PostgreSQL database. This catalog uses the PostgreSQL connection credentials from `dhis.conf` (`connection.url`, `connection.username`, `connection.password`), so the PostgreSQL host must be reachable from the Doris nodes.

## Prerequisites

- A running DHIS2 instance (version 2.43 or later) with a PostgreSQL database.
- A running Apache Doris cluster (version 3.14 or later). Refer to the [Apache Doris documentation](https://doris.apache.org/docs/install/cluster-deployment/standard-deployment) for installation guidance.
- The PostgreSQL JDBC driver jar (e.g., `postgresql-42.7.8.jar`) must be available on the Doris FE node in the JDBC drivers directory. The default location is `${DORIS_HOME}/jdbc_drivers`. This can be changed by setting `jdbc_drivers_dir` in the Doris FE configuration file (`fe.conf`). This driver is required for the JDBC catalog that Doris uses to connect to PostgreSQL.
- Network connectivity:
    - **DHIS2 → Doris**: The DHIS2 server must be able to reach the Doris FE node on port `9030` (the MySQL protocol port).
    - **Doris → PostgreSQL**: The Doris FE node must be able to reach the PostgreSQL server on port `5432`.

## Preparing Apache Doris

Before configuring DHIS2, the following steps must be completed on the Doris side.

### FE configuration

The Doris FE configuration file (`fe.conf`) must include the following setting to ensure table names are treated as case-insensitive:

```properties
lower_case_table_names = 1
```

Restart the Doris FE node after modifying `fe.conf`.

### Create the analytics database

Connect to Doris using the MySQL client and create the database that DHIS2 will use for analytics tables:

```sql
create database dhis2;
```

> **Note:** The database name must match the database name in the `analytics.connection.url` property in `dhis.conf`.

### PostgreSQL hostname

The `connection.url` property in `dhis.conf` contains the PostgreSQL hostname as seen from the DHIS2 server. This same hostname is passed to Doris when creating the JDBC catalog. If PostgreSQL is configured as `localhost` in `dhis.conf`, Doris will not be able to resolve it since `localhost` would refer to the Doris node itself. Ensure the PostgreSQL hostname in `connection.url` is resolvable and reachable from the Doris FE node.

## DHIS2 Configuration

Apache Doris is configured in the DHIS2 configuration file, `dhis.conf`. This file is typically located at `/opt/dhis2/dhis.conf` or in the `DHIS2_HOME` directory.

Add the following properties to `dhis.conf`:

```properties
# Enable Apache Doris as the analytics database
analytics.database = doris

# JDBC connection URL for the Doris FE node (MySQL protocol)
analytics.connection.url = jdbc:mysql://<hostname>:9030/<database>?useLegacyDatetimeCode=false&useUnicode=true&characterEncoding=UTF-8&useSSL=false

# Doris database credentials
analytics.connection.username = <username>
analytics.connection.password = <password>

# Connection pool validation timeout (milliseconds)
analytics.connection.pool.validation_timeout = 10000
```

### Property reference

| Property | Description |
|---|---|
| `analytics.database` | Must be set to `doris`. |
| `analytics.connection.url` | JDBC connection URL. Doris uses the MySQL wire protocol, so the URL uses the `jdbc:mysql://` prefix. The default FE query port is `9030`. |
| `analytics.connection.username` | Username for the Doris database. |
| `analytics.connection.password` | Password for the Doris database. |
| `analytics.connection.pool.validation_timeout` | Timeout in milliseconds for connection pool validation checks. |

### Connection URL parameters

The recommended URL parameters are:

| Parameter | Value | Description |
|---|---|---|
| `useLegacyDatetimeCode` | `false` | Ensures correct handling of date and time values. |
| `useUnicode` | `true` | Enables Unicode character support. |
| `characterEncoding` | `UTF-8` | Sets the character encoding to UTF-8. |
| `useSSL` | `false` | Disables SSL for the JDBC connection. Set to `true` if your Doris cluster is configured with SSL. |

### Example

Below is a complete example of the Doris-related properties in `dhis.conf`, connecting to a Doris FE node at `192.168.1.50`:

```properties
analytics.database = doris
analytics.connection.url = jdbc:mysql://192.168.1.50:9030/dhis2?useLegacyDatetimeCode=false&useUnicode=true&characterEncoding=UTF-8&useSSL=false
analytics.connection.username = dhis
analytics.connection.password = StrongPassword123
analytics.connection.pool.validation_timeout = 10000
```

After modifying `dhis.conf`, restart DHIS2 for the changes to take effect.

## Verification


If the JDBC catalog creation fails, verify that:

- The Doris FE node can reach the PostgreSQL server on port `5432`.
- The PostgreSQL credentials in `dhis.conf` are valid.
- The PostgreSQL JDBC driver jar is present in the Doris JDBC drivers directory.
