# Connection Pool Configuration

## Introduction

In DHIS2, a database connection pool is used to manage database connections. Instead of opening and closing a new session for every database request, which is an expensive process, connections to existing sessions are "borrowed" from the pool and "returned" when the request is complete. This significantly improves performance and resource management, especially under heavy load.

DHIS2 provides flexibility by supporting several connection pool implementations. You can choose the one that best fits your deployment needs, whether it's a built-in pool, a high-performance alternative, or an external solution.

Configuration for the connection pools is done in the `dhis.conf` file.

## Pool Types

DHIS2 supports the following database pool types:

*  **[HikariCP](https://github.com/brettwooldridge/HikariCP)**: This is a well-maintained connection pool known for its high performance. Starting from v43, HikariCP replaces C3P0 as the default database pool.
*  **[C3P0](https://www.mchange.com/projects/c3p0/)**: This is the default connection pool prior to v43. Starting from v43, C3P0 is deprecated and the default pool is HikariCP. Server administrators are encouraged to follow the [migration guide](#migrating-to-hikaricp) to migrate to HikariCP as soon as possible.
* **Unpooled**: This option does not use a connection pool and creates a new connection for each request. It is primarily intended for use with an external connection pooler like [PgBouncer](https://www.pgbouncer.org/).

### Selecting a Pool Type

You can select the desired pool type by setting the `db.pool.type` property in your `dhis.conf` file.

**`dhis.conf` example:**

```properties
# To use HikariCP (default >= v43)
db.pool.type = hikari

# To use c3p0 (default < v43)
# db.pool.type = c3p0

# To use an external pooler
# db.pool.type = unpooled
```

Prior to v43, if this property is not set, DHIS2 defaults to `c3p0`. Starting from v43, the property defaults to `hikari`.

## Configuration Parameters

The following sections detail the configuration parameters available for each pool type.

### Common Parameters

These parameters apply to all connection pool types.

| Key                                    | Description                                                                                                                  | Default Value           |
|----------------------------------------|------------------------------------------------------------------------------------------------------------------------------|-------------------------|
| `connection.url`                       | The JDBC URL for the main DHIS2 database.                                                                                    | -                       |
| `connection.username`                  | The username for the database connection.                                                                                    | -                       |
| `connection.password`                  | The password for the database connection. (sensitive)                                                                        | -                       |
| `connection.driver_class`              | The JDBC driver class name.                                                                                                  | `org.postgresql.Driver` |
| `connection.pool.max_size`             | The maximum number of connections in the pool.                                                                               | `80`                    |
| `connection.pool.preferred.test.query` | A query to be executed to test the validity of a connection. If not set, the JDBC driver's default is used.                  |
| `connection.pool.max_idle_time`        | The time in seconds a connection can remain pooled but unused before being discarded. 0 means idle connections never expire. | `7200`                  |

---

### C3P0 Connection Pool

These parameters apply only when `db.pool.type = c3p0`.

| Key                                        | Description                                                                                                                                  | Default Value |
|--------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| `connection.pool.min_size`                 | The minimum number of connections a pool will maintain at any given time.                                                                    | `5`           |
| `connection.pool.initial_size`             | The number of connections a pool will try to acquire upon startup. Should be between `min_size` and `max_size`.                              | `5`           |
| `connection.pool.acquire_incr`             | The number of connections to acquire at a time when the pool is exhausted.                                                                   | `5`           |
| `connection.pool.acquire_retry_attempts`   | The number of times to try acquiring a new connection before giving up. A value <= 0 means keep trying indefinitely.                         | `30`          |
| `connection.pool.acquire_retry_delay`      | The delay in milliseconds between connection acquisition attempts.                                                                           | `1`           |
| `connection.pool.max_idle_time_excess_con` | The time in seconds that connections in excess of `min_size` should be permitted to remain idle before being culled. 0 means no enforcement. | `0`           |
| `connection.pool.idle.con.test.period`     | If this is a number greater than 0, DHIS2 will test all idle, pooled connections every this many seconds.                                    | `0`           |
| `connection.pool.test.on.checkin`          | If true, a connection's validity is tested asynchronously when it is returned to the pool.                                                   | `on`          |
| `connection.pool.test.on.checkout`         | If true, a connection's validity is tested when it is borrowed from the pool.                                                                | `off`         |
| `connection.pool.num.helper.threads`       | The number of helper threads used by c3p0 for internal tasks.                                                                                | `3`           |

---

### HikariCP Connection Pool

These parameters apply only when `db.pool.type = hikari`.

| Key                                       | Description                                                                                                                                                     | Default Value    | Version |
|-------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|---------|
| `connection.pool.timeout`                 | The maximum number of milliseconds a client will wait for a connection from the pool. Lowest acceptable connection timeout is 250 ms.                           | `30000` (30s)    | 2.36+   |
| `connection.pool.validation_timeout`      | The maximum number of milliseconds that the pool will wait for a connection to be validated as alive.                                                           | `5000` (5s)      | 2.36+   |
| `connection.pool.min_idle`                | The minimum number of idle connections to maintain in the pool.                                                                                                 | `10`             | 43+     |
| `connection.pool.keep_alive_time_seconds` | The interval in seconds to keep idle connections alive. Does not reset idle timeout.                                                                            | `120` (2 mins)   | 43+     |
| `connection.pool.max_lifetime_seconds`    | The maximum lifetime of a connection in the pool in seconds. An in-use connection will not be retired.                                                          | `1800` (30 mins) | 43+     |
| `connection.pool.warn_max_age`            | The leak detection threshold in milliseconds. Logs a message if a connection is out of the pool for longer than this value. `0` disables it. Must be >= 2000ms. | `0`              | 42.1+   |

---

## Analytics Connection Pool

DHIS2 can be configured to use a separate database for analytics queries. This analytics database can have its own connection pool settings, which allows for fine-tuning performance for analytical workloads independently of the main transactional database. This feature is available from version `2.41`.

All connection pool parameters for the analytics database are prefixed with `analytics.`. For example, `connection.pool.max_size` becomes `analytics.connection.pool.max_size`.

**`dhis.conf` example for an analytics database with a HikariCP pool:**

```properties
analytics.database = POSTGRESQL
analytics.connection.url = jdbc:postgresql://analytics-db-host:5432/dhis2
analytics.connection.username = dhis
analytics.connection.password = secret

# Use hikari for analytics pool, independent of the main pool type
# Note: As of now, the analytics pool uses the same pool type as the main DB pool.
# The main db.pool.type will be used.

# Specific pool settings for analytics
analytics.connection.pool.max_size = 100
analytics.connection.pool.min_idle = 20
```

The following keys can be configured for the analytics pool, corresponding to their main database counterparts:

*   `analytics.connection.url`
*   `analytics.connection.username`
*   `analytics.connection.password`
*   `analytics.connection.driver_class`
*   `analytics.connection.pool.max_size`
*   `analytics.connection.pool.preferred.test.query`
*   `analytics.connection.pool.timeout`
*   `analytics.connection.pool.validation_timeout`
*   `analytics.connection.pool.acquire_incr`
*   `analytics.connection.pool.acquire_retry_attempts`
*   `analytics.connection.pool.acquire_retry_delay`
*   `analytics.connection.pool.max_idle_time`
*   `analytics.connection.pool.min_size`
*   `analytics.connection.pool.initial_size`
*   `analytics.connection.pool.test.on.checkin`
*   `analytics.connection.pool.test.on.checkout`
*   `analytics.connection.pool.max_idle_time_excess_con`
*   `analytics.connection.pool.idle.con.test.period`
*   `analytics.connection.pool.num.helper.threads`
*   `analytics.connection.pool.min_idle` (v43+)
*   `analytics.connection.pool.keep_alive_time_seconds` (v43+)
*   `analytics.connection.pool.max_lifetime_seconds` (v43+)

## Migrating to HikariCP

HikariCP is simple to configure, well-maintained, arguably outperforms C3P0, and benefits from an active open-source community. For these reasons, beginning from v43, HikariCP is the default connection pool. C3P0 is deprecated and will eventually be removed from DHIS2. As such, server administrators should migrate from C3P0 to HikariCP as soon as possible. The subsequent steps apply to your installation if either (a) the `db.pool.type` property in the `dhis.conf` is undefined and you running a DHIS2 version older than v43, or (b) the `db.pool.type` property is set to `c3p0`.

1. Set the `db.pool.type` property to `hikari`.
2. If `connection.pool.initial_size` is set and you are on at least DHIS2 v43, then remove the property and emulate it by setting the `connection.pool.min_idle` property.
3. If `connection.pool.max_idle_time_excess_con` is set, replace it with the `connection.pool.max_idle_time` property.
4. Remove any remaining [C3P0-specific parameters](#c3p0-connection-pool). Internally, HikariCP works differently from C3P0 so many C3P0 settings cannot be translated to HikariCP settings. 
5. DHIS2 leaves the connection timeout unconfigured for the C3P0 pool type which leads to requests waiting indefinitely when the database connection pool is exhausted. This is considered bad practice so DHIS2 configures the connection timeout for the HikariCP pool type to 30 seconds by default. A slow DHIS2 implementation ought to have its connection timeout cautiously left to the default value. After migration, the administrator should watch the DHIS2 server log for connection timeout errors during periods of high activity. If connection timeout errors do occur, then it is recommended that the administrator resolves the performance issues that are causing database connection requests to time out. However, while discouraged, the administrator can set the `connection.pool.timeout` property to increase the connection timeout value in order to mitigate the timeout errors.
