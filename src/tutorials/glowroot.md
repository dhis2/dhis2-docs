# Using Glowroot { #glowroot_tutorial }

[Glowroot](https://glowroot.org/) is a lightweight Java Application Performance Monitor that can be very useful in providing insight into performance issues when running DHIS2.

This page intends to give a quick overview in order to help you get started using Glowroot.

- [Installation](#installation)
- [Usage](#usage-tips)

## Installation

Installation is quite straightforward, and is described in the Glowroot [wiki](https://github.com/glowroot/glowroot/wiki/Agent-Installation-(with-Embedded-Collector)).
We advise you to follow their instructions, which cover a variety of different environments.

For a basic setup you can get started with just a few simple steps:

### Download and unpack Glowroot

Select the latest version of Glowroot from their [releases](https://github.com/glowroot/glowroot/releases) page, and uncompress the package into the desired location.

> Example:
> ```
> # create a location to install glowroot. I will use /opt/glowroot
> mkdir -p /opt/glowroot
>
> # download the chosen version and uncompress
> cd /opt/glowroot
> wget https://github.com/glowroot/glowroot/releases/download/v0.13.6/glowroot-0.13.6-dist.zip
> unzip glowroot-0.13.6-dist.zip
>
> # there should now be a file called /opt/glowroot/glowroot.jar

> Note: make sure that the user who is running the DHIS2 service has write access to the glowroot install directory. E.g. If running DHIS2 under tomcat as `dhis` user:
> chown -R dhis: /opt/glowroot
> ```

### Set your DHIS2 service to use glowroot

Add `-javaagent:path/to/glowroot.jar` to your application servers' JVM args. This step is described well [here](https://github.com/glowroot/glowroot/wiki/Where-are-my-application-server's-JVM-args%3F).
You can then restart DHIS2 to start using glowroot. By default it will be accessable on `http://localhost:4000`. In most cases you will want to access this remotely...

### Set up external access to glowroot

If you want to access glowroot through a reverse proxy, such as nginx, you should configure it to redirect to the glowroot instance. 

For example, if running on nginx, on a host called `myserver.com` , and you want to access glowroot at `https://myserver.com/glowroot`  
In this case you need to set up a redirect in your nginx server configuration such as:

```
location /glowroot {
    proxy_pass    http://127.0.0.1:4000/glowroot;
}
```
In the example above, as glowroot is running the the `glowroot` context path, you would also need to set that in the glowroot configuration. This can be changed by creating (or editing) admin.json (in the same directory as glowroot.jar), e.g. in the `web` section:

```
{
  "web": {
    "contextPath": "/glowroot",
  }
}
```

### Set an admin password

Set up a password for the Admin account under **Administration** -> **Users** in the Glowroot UI


## Usage Tips

The Glowroot interface is quite intuitive, and you are encouraged to explore it, but here are a few tips regarding things to look for.

### Transactions tab

The `Transactions` tabs gives various real time information on the different APIs served by the application along with associated queries, response times, slow traces etc. An overview of the total API transactions will be shown on the left hand pane and on selecting individual API transaction type, a detailed breakdown of the slowtraces/response times/queries can be listed. Real time monitoring of this tab will help in identifying if any specific API is performing poorly. The corresponding Slow Trace for the API can be opened in the Slow Traces tab which gives detailed information of the specific API. `JVM Thread stats` and `Query stats` are useful if retrieved from a poorly performing API's slowtrace to understand if the issue is in a specific slow query or if there is high memory allocation etc.

### Errors tab

The `Errors` tab shows the exception stacktraces that has occurred during execution of any part of the system. Usually information from other tabs is required to get the complete picture.

### JVM tab

> **Caution**
>
> This tab should be used with caution as there are options to Force GC (Garbage Collection), or to take Heap dump or Thread dump. Using these unnecessarily will add extra pressure onto the JVM!

The `JVM` tab has certain sub sections that is useful to know the current state of the JVM. A useful area to check in the tab is the `Mbean tree` section. There are several configs exposed by Mbeans in DHIS2. Some of them are the connection pool configuration and it's current state. It shows the configuration of the connection pool like the maxPoolSize and other parameters as well as real-time state of the connection pool parameters like `numBusyConnections`, `numConnections`, `numIdleConnections` and so on which gives an idea of how the connection pool is behaving. If you notice that the `numBusyConnection` is equal to the `maxPoolSize` configuration, and if the database is not struggling for resources, it would be wise to increase the `maxPoolSize` dhis2 config so that the available connection pool is larger. 

### Reporting tab

The `Reporting` tab can be used to  export any metric for a specific date/time range. It supports exporting Metrics like Response Time (Average or Percentile) or Transaction count from the Transactions tab. It also supports explorting metrics related to the JVM tab which include Guages for the different memory spaces. In most cases, real time monitoring and analysis will suffice, but it would be good to assess whether any exporting of specific metrics are needed for future reference.

## Instrumentation

By default, glowroot will group all requests to an endpoint in one transaction group. This can be suboptimal in cases when you want to make optimisations to a specific flow and want to track the improvements. In these cases, glowroot can be instrumented to separate the requests into different transaction groups based on java method. That can be done in Configuration -> Instrumentation. 

### Example: separate GETs and POST's to /trackedEntityInstances

Fetching tracked entity instances can be slower than creating, so it can be useful to monitor these types of requests separately. The following configuration can be imported into glowroot to achieve that (`Instrumentation -> Import`).

```
{
  "className": "org.hisp.dhis.webapi.controller.event.TrackedEntityInstanceController",
  "methodName": "getTrackedEntityInstances",
  "methodParameterTypes": [
    ".."
  ],
  "captureKind": "other",
  "transactionType": "Web",
  "transactionNameTemplate": "/api/trackedEntityInstances: GET"
}
```

### Example: monitor asynchronous requests

Some asynchronous requests can not be monitored easily. One of those cases is tracker import using `/tracker` endpoint, with `async` parameter set to `true` ( applicable to 2.37 and up). That is because the initial request only returns a job id and doesn't wait for job to finish. To be able to monitor the internal process of tracker import, you import the following configuration (`Instrumentation -> Import). 

```
{
    "className": "org.hisp.dhis.tracker.report.DefaultTrackerImportService",
    "methodName": "importTracker",
    "methodParameterTypes": [
      ".."
    ],
    "captureKind": "transaction",
    "transactionType": "Web",
    "transactionNameTemplate": "/api/tracker: import",
    "alreadyInTransactionBehavior": "capture-new-transaction",
    "traceEntryMessageTemplate": "{{0}}",
    "traceEntryStackThresholdMillis": 1000,
    "traceEntryCaptureSelfNested": true,
    "timerName": "Timer"
  }  
```
