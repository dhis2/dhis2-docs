## Postgresql tips and recipes

This section contains advice on postgresql database server tuning, performing backups and working with read replicas.

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

Restart PostgreSQL by invoking the following command:

```sh
sudo systemctl restart postgresql
```

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

## Working with the PostgreSQL database { #install_working_with_the_postgresql_database } 

Common operations when managing a DHIS2 instance are dumping and restoring databases. Note that when making backups of the DHIS 2 database, it is good practise to exclude tables which are generated by the system, such as the resource and analytics tables. To make a dump (copy) of your database to a file,  you can invoke the following command.

```bash
pg_dump {database} -U {user} -T "_*" -T "analytics*"  -f {filename}
```
In the following example, the database name is `dhis2`, the user is `dhis` and the output filename is `dhis2.sql`:

```bash
pg_dump dhis2 -U dhis -T "analytics*" -T "_*" -f dhis2.sql
```

It is good practice to compress the If you want to compress the output file with `gzip`, which can be done like this:

```bash
pg_dump dhis2 -U dhis -T "analytics*" -T "_*" | gzip > dhis2.sql.gz
```

To restore the database copy on another system, you first need to create an empty database as described in the installation section. You also need to `gunzip` the copy if you created a compressed version. To restore the copy you can invoke the following command:

```bash
psql -d dhis2 -U dhis -f dhis2.sql
```
