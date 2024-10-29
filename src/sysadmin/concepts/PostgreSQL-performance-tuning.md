Tuning PostgreSQL is required to achieve a high-performing system but is
optional in terms of getting DHIS2 to run. The various settings can be
specified in the postgresql.conf configuration file or, preferably, in a
specific file in the conf.d directory. The settings is based on allocating 8 GB
RAM to PostgreSQL and should be adjusted accordingly to the environment.

`sudo nano /etc/postgresql/12/main/postgresql.conf`

Set the following properties.

`jit = off`
This is important to set for postgresql versions 12 and greater. The jit
compiler functionality causes a significant slowdown on many DHIS2 specific
queries, eg Program Indicator queries. For versions 11 and below, the setting
is off by default.


`max_connections = 200`
Determines maximum number of connections which PostgreSQL will allow.


`shared_buffers = 3GB`
Determines how much memory should be allocated exclusively for PostgreSQL
caching. This setting controls the size of the kernel shared memory which
should be reserved for PostgreSQL. Should be set to around 40% of total memory
dedicated for PostgreSQL.


`work_mem = 24MB`
Determines the amount of memory used for internal sort and hash operations.
This setting is per connection, per query so a lot of memory may be consumed if
raising this too high. Setting this value correctly is essential for DHIS2
aggregation performance.


`maintenance_work_mem = 1GB`
Determines the amount of memory PostgreSQL can use for maintenance operations
such as creating indexes, running vacuum, adding foreign keys. Increasing this
value might improve performance of index creation during the analytics
generation processes.


`temp_buffers = 16MB`
Sets the maximum number of temporary buffers used by each database session.
These are session-local buffers used only for access to temporary tables.


`effective_cache_size = 8GB`
An estimate of how much memory is available for disk caching by the operating
system (not an allocation) and is used by PostgreSQL to determine whether a
query plan will fit into memory or not. Setting it to a higher value than what
is really available will result in poor performance. This value should be
inclusive of the shared_buffers setting. PostgreSQL has two layers of caching:
The first layer uses the kernel shared memory and is controlled by the
shared_buffers setting. PostgreSQL delegates the second layer to the operating
system disk cache and the size of available memory can be given with the
effective_cache_size setting.


`checkpoint_completion_target = 0.8`
Sets the memory used for buffering during the WAL write process. Increasing
this value might improve throughput in write-heavy systems.


`synchronous_commit = off`
Specifies whether transaction commits will wait for WAL records to be written
to the disk before returning to the client or not. Setting this to off will
improve performance considerably. It also implies that there is a slight delay
between the transaction is reported successful to the client and it actually
being safe, but the database state cannot be corrupted and this is a good
alternative for performance-intensive and write-heavy systems like DHIS2.


`wal_writer_delay = 10s`
Specifies the delay between WAL write operations. Setting this to a high value
will improve performance on write-heavy systems since potentially many write
operations can be executed within a single flush to disk.


`random_page_cost = 1.1`
SSD only. Sets the query planner's estimate of the cost of a
non-sequentially-fetched disk page. A low value will cause the system to prefer
index scans over sequential scans. A low value makes sense for databases
running on SSDs or being heavily cached in memory. The default value is 4.0
which is reasonable for traditional disks.


`max_locks_per_transaction = 96`
Specifies the average number of object locks allocated for each transaction.
This is set mainly to allow upgrade routines which touch a large number of
tables to complete.


`track_activity_query_size = 8192`
Specifies the number of bytes reserved to track the currently executing command
for each active session. Useful to view the full query string for monitoring of
   currently running queries.


`jit = off`
This setting turns the jit optimizer off. It should be set to off for
postgresql versions 12 and upwards. Many queries, particularly program
indicator queries, perform very badly with the default enabled jit setting.
Turning it off can improve response times by up to 100x with resulting
significant improvement in dashboard performance.

Restart PostgreSQL by invoking the following command:

`sudo systemctl restart postgresql`

