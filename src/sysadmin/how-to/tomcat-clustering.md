# Web server cluster configuration { #install_web_server_cluster_configuration } 

This section describes how to set up the DHIS 2 application to run in a
cluster.

# Clustering overview { #install_cluster_configuration_introduction } 

Clustering is a common technique for improving system scalability and
availability. Clustering refers to setting up multiple web servers such
as Tomcat instances and have them serve a single application. Clustering
allows for *scaling out* an application in the sense that new servers
can be added to improve performance. It also allows for *high
availability* as the system can tolerate instances going down without
making the system inaccessible to users.

There are a few aspects to configure in order to run DHIS 2
in a cluster.

* A Redis data store must be installed and connection information must 
be provided for each DHIS 2 application instance in`dhis.conf`.

* DHIS 2 instances and servers must share the same *files* folder used for 
apps and file uploads, either through the *AWS S3 cloud filestorage* option 
or a shared network drive.

* DHIS 2 instance cache invalidation must be enabled.

* A load balancer such as nginx should be configured to distribute Web requests
across the cluster instances.

## DHIS 2 instance cache invalidation with Redis { #install_cluster_cache_invalidation_redis }

DHIS 2 can invalidate the various instance's caches by listening for events sent and emitted from a Redis server, when configured to do so.

This is considered the easiest and preferred way to enable cache invalidation, if you already plan to use [Redis for
shared data store cluster configuration](#install_cluster_configuration_redis), it will share this Redis server for both purposes.

### Prerequisites

* [ Install ](https://docs.kipkurgat.com/server-admin/how-to-guides/installing-redis.html) Redis server

### Redis configuration

No specific configuration in Redis is needed for DHIS 2 cache invalidation to work.

When you chose to enable shared data store cluster configuration with Redis, you will share the Redis host/port
configuration with the cache invalidation system. In other words you can only have **one** shared Redis server configured.

### DHIS 2 configuration

The following properties must be specified in the DHIS 2 `dhis.conf` configuration file:

```properties
# Cache invalidation config

redis.cache.invalidation.enabled = on

# Shared Redis configuration
redis.host = REDIS_HOST
redis.port = REDIS_PORT
redis.password = PASSWORD (Optional, only if enabled on Redis server)
redis.use.ssl = true (Optional, only if enabled on Redis server) 
```

## Redis shared data store cluster configuration { #install_cluster_configuration_redis } 

In a cluster setup, a Redis server is required and will handle
shared user sessions, application cache and cluster node leadership.

For optimum performance, *Redis Keyspace events* for _generic commands_ 
and _expired events_ need to be enabled in the Redis Server. If you are 
using a cloud platform-managed Redis server (like *AWS ElastiCache for Redis* 
or *Azure Cache for Redis*), you will have to enable keyspace event notifications 
using the respective cloud console interfaces. If you are setting up a standalone 
Redis server, enabling keyspace event notifications can be done in the 
*redis.conf* file by adding or uncommenting the following line:

```
notify-keyspace-events Egx
```

DHIS2 will connect to Redis if the *redis.enabled* configuration
property in `dhis.conf` is set to *on* along with the following properties:

- *redis.host*: Specifies where the redis server is running. Defaults to *localhost*. Mandatory.

- *redis.port*: Specifies the port in which the redis server is listening. Defaults to *6379*. Optional.

- *redis.password*: Specifies the authentication password. If a password is not required it can be left blank.

- *redis.use.ssl*: Specifies whether the Redis server has SSL enabled. Defaults to false. Optional. Defaults to *false*.

When Redis is enabled, DHIS2 will automatically assign one of the
running instances as the leader of the cluster. The leader instance will
be used to execute jobs or scheduled tasks that should be run
exclusively by one instance. Optionally you can configure the
*leader.time.to.live.minutes* property in `dhis.conf` to set up how
frequently the leader election needs to occur. It also gives an
indication of how long it would take for another instance to take over
as the leader after the previous leader has become unavailable. The
default value is 2 minutes. Note that assigning a leader in the cluster
is only done if Redis is enabled. An example snippet of the `dhis.conf`
configuration file with Redis enabled and leader election time
configured is shown below.

```properties
# Redis Configuration

redis.enabled = on

# Shared Redis configuration
redis.host = REDIS_HOST
redis.port = REDIS_PORT
redis.password = PASSWORD (Optional, only if enabled on Redis server)
redis.use.ssl = true (Optional, only if enabled on Redis server)

# Optional, defaults to 2 minutes
leader.time.to.live.minutes=4 
```

### Files folder configuration

DHIS 2 will store several types of files outside the application itself,
such as apps, files saved in data entry and user avatars. When deployed
in a cluster, the location of these files must be shared across all instances.
On the local filesystem, the location is:

```
{DHIS2_HOME}/files
```

Here, `DHIS2_HOME` refers to the location of the DHIS 2 configuration file
as specified by the DHIS 2 environment variable, and `files` is the file
folder immediately below.

There are two ways to achieve a shared location:

* Use the *AWS S3 cloud filestorage* option. Files will be stored in an
S3 bucket which is automatically shared by all DHIS 2 instances in the cluster.
See the *File store configuration* section for guidance.
* Set up a shared folder which is shared among all DHIS 2 instances and
servers in the cluster. On Linux this can be achieved with *NFS* (Network File System)
which is a distributed file system protocol. Note that only the `files` 
subfolder under `DHIS2_HOME` should be shared, not the parent folder. 

## Load balancer configuration { #install_load_balancing } 

With a cluster of Tomcat instances set up, a common approach for routing
incoming web requests to the backend instances participating in the
cluster is using a *load balancer*. A load balancer will make sure that
load is distributed evenly across the cluster instances. It will also
detect whether an instance becomes unavailable, and if so, stop routine
requests to that instance and instead use other available instances.

Load balancing can be achieved in multiple ways. A simple approach is
using *nginx*, in which case you will define an *upstream* element which
enumerates the location of the backend instances and later use that
element in the *proxy* location block.

```text
http {

  # Upstream element with sticky sessions

  upstream dhis_cluster {
    ip_hash;
    server 193.157.199.131:8080;
    server 193.157.199.132:8080;
  }

  # Proxy pass to backend servers in cluster

  server {
    listen 80;

    location / {
      proxy_pass   http://dhis_cluster/;
    }
  }
}  
```

DHIS 2 keeps server-side state for user sessions to a limited degree.
Using "sticky sessions" is a simple approach to avoid replicating the
server session state by routing requests from the same client to the
same server. The *ip\_hash* directive in the upstream element ensures
this.

Note that several instructions have been omitted for brevity in the
above example. Consult the reverse proxy section for a detailed guide.
