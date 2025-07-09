
# Connection Pool Configuration

## Introduction

In DHIS2, a database connection pool is used to manage database connections. Instead of opening and closing a new connection for every database request, which is an expensive process, connections are "borrowed" from the pool and "returned" to it when the request is complete. This significantly improves performance and resource management, especially under heavy load.

DHIS2 provides flexibility by supporting several connection pool implementations. You can choose the one that best fits your deployment needs, whether it's a built-in pool, a high-performance alternative, or an external solution.

Configuration for the connection pools is done in the `dhis.conf` file.

## Pool Types

DHIS2 supports three main database pool types:

*   **c3p0**: This is the default, mature, and highly configurable connection pool.
*   **HikariCP**: A very fast and lightweight connection pool known for its high performance.
*   **unpooled**: This option does not use a connection pool and creates a new connection for each request. It is primarily intended for use with an external connection pooler like [PgBouncer](https://www.pgbouncer.org/).

### Selecting a Pool Type

You can select the desired pool type by setting the `db.pool.type` property in your `dhis.conf` file.

**`dhis.conf` example:**

```properties
# To use HikariCP
db.pool.type = hikari

# To use c3p0 (default)
# db.pool.type = c3p0

# To use an external pooler
# db.pool.type = unpooled
```

If this property is not set, DHIS2 will default to `c3p0`.

## Configuration Parameters

The following sections detail the configuration parameters available for each pool type.

### Common Parameters

These parameters apply to all connection pool types.

| Key | Description | Default Value |
| --- | --- | --- |
| `connection.url` | The JDBC URL for the main DHIS2 database. | - |
| `connection.username` | The username for the database connection. | - |
| `connection.password` | The password for the database connection. (sensitive) | - |
| `connection.driver_class` | The JDBC driver class name. | `org.postgresql.Driver` |
| `connection.pool.max_size` | The maximum number of connections in the pool. | `80` |
| `connection.pool.test.query` | A query to be executed to test the validity of a connection. If not set, the JDBC driver's default is used. | - |

---

### c3p0 Connection Pool

These parameters apply only when `db.pool.type = c3p0`.

| Key | Description | Default Value |
| --- | --- | --- |
| `connection.pool.min_size` | The minimum number of connections a pool will maintain at any given time. | `5` |
| `connection.pool.initial_size` | The number of connections a pool will try to acquire upon startup. Should be between `min_size` and `max_size`. | `5` |
| `connection.pool.acquire_incr` | The number of connections to acquire at a time when the pool is exhausted. | `5` |
| `connection.pool.acquire_retry_attempts` | The number of times to try acquiring a new connection before giving up. A value <= 0 means keep trying indefinitely. | `30` |
| `connection.pool.acquire_retry_delay` | The delay in milliseconds between connection acquisition attempts. | `1` |
| `connection.pool.max_idle_time` | The time in seconds a connection can remain pooled but unused before being discarded. 0 means idle connections never expire. | `7200` |
| `connection.pool.max_idle_time_excess_con` | The time in seconds that connections in excess of `min_size` should be permitted to remain idle before being culled. 0 means no enforcement. | `0` |
| `connection.pool.idle.con.test.period` | If this is a number greater than 0, DHIS2 will test all idle, pooled connections every this many seconds. | `0` |
| `connection.pool.test.on.checkin` | If true, a connection's validity is tested asynchronously when it is returned to the pool. | `on` |
| `connection.pool.test.on.checkout` | If true, a connection's validity is tested when it is borrowed from the pool. | `off` |
| `connection.pool.num.helper.threads` | The number of helper threads used by c3p0 for internal tasks. | `3` |

---

### HikariCP Connection Pool

These parameters apply only when `db.pool.type = hikari`.

| Key | Description | Default Value |
| --- | --- | --- |
| `connection.pool.timeout` | The maximum number of milliseconds a client will wait for a connection from the pool. | `30000` (30s) |
| `connection.pool.validation_timeout` | The maximum number of milliseconds that the pool will wait for a connection to be validated as alive. | `5000` (5s) |
| `connection.pool.min_idle` | The minimum number of idle connections to maintain in the pool. | `10` |
| `connection.pool.keep_alive_time_seconds`| The interval in seconds to keep idle connections alive. Does not reset idle timeout. | `120` (2 mins) |
| `connection.pool.max_lifetime_seconds` | The maximum lifetime of a connection in the pool in seconds. An in-use connection will not be retired. | `1800` (30 mins) |
| `connection.pool.warn_max_age` | The leak detection threshold in milliseconds. Logs a message if a connection is out of the pool for longer than this value. `0` disables it. Must be >= 2000ms. | `0` |

---

## Analytics Connection Pool

DHIS2 can be configured to use a separate database for analytics queries. This analytics database can have its own connection pool settings, which allows for fine-tuning performance for analytical workloads independently of the main transactional database.

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
*   `analytics.connection.pool.test.query`
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



Restart the servlet container for these changes to take effect. 