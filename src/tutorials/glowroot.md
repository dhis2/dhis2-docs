# Using Glowroot

[Glowroot](https://glowroot.org/) is a lightweight Java Application Performance Monitor that can be very useful in providing insight into performance issues when running DHIS2.

This page intends to give a quick overview in order to help you get started using Glowroot.

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
> ```
> chown -R dhis: /opt/glowroot

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

### Errors tab

### JVM tab

### Reporting tab