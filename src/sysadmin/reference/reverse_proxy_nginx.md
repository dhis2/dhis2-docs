## Reverse proxy configuration { #install_reverse_proxy_configuration } 

A reverse proxy is a proxy server that acts on behalf of a server. Using
a reverse proxy in combination with a servlet container is optional but
has many advantages:

  - Requests can be mapped and passed on to multiple servlet containers.
    This improves flexibility and makes it easier to run multiple
    instances of DHIS2 on the same server. It also makes it possible to
    change the internal server setup without affecting clients.

  - The DHIS2 application can be run as a non-root user on a port
    different than 80 which reduces the consequences of session
    hijacking.

  - The reverse proxy can act as a single SSL server and be configured
    to inspect requests for malicious content, log requests and
    responses and provide non-sensitive error messages which will
    improve security.

### Basic nginx setup { #install_basic_nginx_setup } 

We recommend using [nginx](http://www.nginx.org) as a reverse proxy due to
its low memory footprint and ease of use. To install invoke the
following:

    sudo apt-get install -y nginx

nginx can now be started, reloaded and stopped with the following
commands:

    sudo /etc/init.d/nginx start
    sudo /etc/init.d/nginx reload
    sudo /etc/init.d/nginx stop

Now that we have installed nginx we will now continue to configure
regular proxying of requests to our Tomcat instance, which we assume
runs at `http://localhost:8080`. To configure nginx you can open the
configuration file by invoking:

    sudo nano /etc/nginx/nginx.conf

nginx configuration is built around a hierarchy of blocks representing
http, server and location, where each block inherits settings from parent
blocks. The following snippet will configure nginx to proxy pass
(redirect) requests from port 80 (which is the port nginx will listen on
by default) to our Tomcat instance. Include the following configuration
in nginx.conf:

```text
http {
  gzip on; # Enables compression, incl Web API content-types
  gzip_types
	"application/json;charset=utf-8" application/json
	"application/javascript;charset=utf-8" application/javascript text/javascript
	"application/xml;charset=utf-8" application/xml text/xml
	"text/css;charset=utf-8" text/css
	"text/plain;charset=utf-8" text/plain;

  server {
	listen               80;
	client_max_body_size 10M;

	# Proxy pass to servlet container

	location / {
	  proxy_pass                http://localhost:8080/;
	  proxy_redirect            off;
	  proxy_set_header          Host               $host;
	  proxy_set_header          X-Real-IP          $remote_addr;
	  proxy_set_header          X-Forwarded-For    $proxy_add_x_forwarded_for;
	  proxy_set_header          X-Forwarded-Proto  http;
	  proxy_buffer_size         128k;
	  proxy_buffers             8 128k;
	  proxy_busy_buffers_size   256k;
	  proxy_cookie_path         ~*^/(.*) "/$1; SameSite=Lax";
	}
  }
}
```

You can now access your DHIS2 instance at *http://localhost*. Since the
reverse proxy has been set up we can improve security by making Tomcat
only listen for local connections. In */conf/server.xml* you can add an
*address* attribute with the value *localhost* to the Connector element
for HTTP 1.1 like this:

```xml
<Connector address="localhost" protocol="HTTP/1.1" />
```

### Enabling SSL with nginx { #install_enabling_ssl_on_nginx } 

In order to improve security it is recommended to configure the server
running DHIS2 to communicate with clients over an encrypted connection
and to identify itself to clients using a trusted certificate. This can
be achieved through SSL which is a cryptographic communication protocol
running on top of TCP/IP. First, install the required *openssl* library:

    sudo apt-get install -y openssl

To configure nginx to use SSL you will need a proper SSL certificate
from an SSL provider. The cost of a certificate varies a lot depending
on encryption strength. An affordable certificate from [Rapid SSL
Online](http://www.rapidsslonline.com) should serve most purposes. To
generate the CSR (certificate signing request) you can invoke the
command below. When you are prompted for the *Common Name*, enter the
fully qualified domain name for the site you are
    securing.

    openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr

When you have received your certificate files (.pem or .crt) you will
need to place it together with the generated server.key file in a
location which is reachable by nginx. A good location for this can be
the same directory as where your nginx.conf file is located.

Below is an nginx server block where the certificate files are named
server.crt and server.key. Since SSL connections usually occur on port
443 (HTTPS) we pass requests on that port (443) on to the DHIS2 instance
running on `http://localhost:8080`. The first server block will rewrite
all requests connecting to port 80 and force the use of HTTPS/SSL. This
is also necessary because DHIS2 is using a lot of redirects internally
which must be passed on to use HTTPS. Remember to replace
*\<server-ip\>* with the IP of your server. These blocks should replace
the one from the previous section.

```text
http {
  gzip on; # Enables compression, incl Web API content-types
  gzip_types
	"application/json;charset=utf-8" application/json
	"application/javascript;charset=utf-8" application/javascript text/javascript
	"application/xml;charset=utf-8" application/xml text/xml
	"text/css;charset=utf-8" text/css
	"text/plain;charset=utf-8" text/plain;

  # HTTP server - rewrite to force use of SSL

  server {
	listen     80;
	rewrite    ^ https://<server-url>$request_uri? permanent;
  }

  # HTTPS server

  server {
	listen               443 ssl;
	client_max_body_size 10M;

	ssl                  on;
	ssl_certificate      server.crt;
	ssl_certificate_key  server.key;

	ssl_session_cache    shared:SSL:20m;
	ssl_session_timeout  10m;

	ssl_protocols              TLSv1 TLSv1.1 TLSv1.2;
	ssl_ciphers                RC4:HIGH:!aNULL:!MD5;
	ssl_prefer_server_ciphers  on;

	# Proxy pass to servlet container

	location / {
	  proxy_pass                http://localhost:8080/;
	  proxy_redirect            off;
	  proxy_set_header          Host               $host;
	  proxy_set_header          X-Real-IP          $remote_addr;
	  proxy_set_header          X-Forwarded-For    $proxy_add_x_forwarded_for;
	  proxy_set_header          X-Forwarded-Proto  https;
	  proxy_buffer_size         128k;
	  proxy_buffers             8 128k;
	  proxy_busy_buffers_size   256k;
	  proxy_cookie_path         ~*^/(.*) "/$1; SameSite=Lax";
	}
  }
}
```

Note the last `https` header value which is required to inform the
servlet container that the request is coming over HTTPS. In order for
Tomcat to properly produce `Location` URL headers using HTTPS you also need
to add two other parameters to the Connector in the Tomcat `server.xml` file:

```xml
<Connector scheme="https" proxyPort="443" />
```

### Enabling caching with nginx { #install_enabling_caching_ssl_nginx } 

Requests for reports, charts, maps and other analysis-related resources
will often take some time to respond and might utilize a lot of server
resources. In order to improve response times, reduce the load on the
server and hide potential server downtime we can introduce a cache proxy
in our server setup. The cached content will be stored in directory
/var/cache/nginx, and up to 250 MB of storage will be allocated. Nginx
will create this directory automatically.

```text
http {
  ..
  proxy_cache_path  /var/cache/nginx  levels=1:2  keys_zone=dhis:250m  inactive=1d;


  server {
	..

	# Proxy pass to servlet container and potentially cache response

	location / {
	  proxy_pass                http://localhost:8080/;
	  proxy_redirect            off;
	  proxy_set_header          Host               $host;
	  proxy_set_header          X-Real-IP          $remote_addr;
	  proxy_set_header          X-Forwarded-For    $proxy_add_x_forwarded_for;
	  proxy_set_header          X-Forwarded-Proto  https;
	  proxy_buffer_size         128k;
	  proxy_buffers             8 128k;
	  proxy_busy_buffers_size   256k;
	  proxy_cookie_path         ~*^/(.*) "/$1; SameSite=Lax";
	  proxy_cache               dhis;
	}
  }
}
```

> **Important**
> 
> Be aware that a server side cache shortcuts the DHIS2 security
> features in the sense that requests which hit the server side cache
> will be served directly from the cache outside the control of DHIS2
> and the servlet container. This implies that request URLs can be
> guessed and reports retrieved from the cache by unauthorized users.
> Hence, if you capture sensitive information, setting up a server side
> cache is not recommended.

### Rate limiting with nginx { #install_rate_limiting } 

Certain web API calls in DHIS 2, like the `analytics` APIs, are compute intensive. As a result it is favorable to rate limit these APIs in order to allow all users of the system to utilize a fair share of the server resources. Rate limiting can be achieved with `nginx`. There are numerous approaches to achieving rate limiting and this is intended to document the nginx-based approach.

The below nginx configuration will rate limit the `analytics` web API, and has the following elements at the *http* and *location* block level (the configuration is shortened for brevity):

```text
http {
  ..
  limit_req_zone $binary_remote_addr zone=limit_analytics:10m rate=5r/s;

  server {
    ..
        
    location ~ ^/api/(\d+/)?analytics(.*)$ {
      limit_req    zone=limit_analytics burst=20;
      proxy_pass   http://localhost:8080/api/$1analytics$2$is_args$args;
      ..
    }
  }
}
```

The various elements of the configuration can be described as:

- *limit_req_zone $binary_remote_addr*: Rate limiting is done per request IP.
- *zone=limit_analytics:20m*: A rate limit zone for the analytics API which can hold up to 10 MB of request IP addresses.
- *rate=20r/s*: Each IP is granted 5 requests per second.
- *location ~ ^/api/(\d+/)?analytics(.\*)$*: Requests for the analytics API endpoint are rate limited.
- *burst=20*: Bursts of up to 20 requests will be queued and serviced at a later point; additional requests will lead to a `503`.

For a full explanation please consult the [nginx documentation](https://www.nginx.com/blog/rate-limiting-nginx/).

### Making resources available with nginx { #install_making_resources_available_with_nginx } 

In some scenarios it is desirable to make certain resources publicly
available on the Web without requiring authentication. One example is
when you want to make data analysis related resources in the web API
available in a Web portal. The following example will allow access to
charts, maps, reports, report table and document resources through basic
authentication by injecting an *Authorization* HTTP header into the
request. It will remove the Cookie header from the request and the
Set-Cookie header from the response in order to avoid changing the
currently logged in user. It is recommended to create a user for this
purpose given only the minimum authorities required. The Authorization
value can be constructed by Base64-encoding the username appended with a
colon and the password and prefix it "Basic ", more precisely "Basic
base64\_encode(username:password)". It will check the HTTP method used
for requests and return *405 Method Not Allowed* if anything but GET is
detected.

It can be favorable to set up a separate domain for such public users
when using this approach. This is because we don't want to change the
credentials for already logged in users when they access the public
resources. For instance, when your server is deployed at somedomain.com,
you can set a dedicated subdomain at api.somedomain.com, and point URLs
from your portal to this subdomain.

```text
http {
  ..
  
  server {
    listen       80;
    server_name  api.somedomain.com;

    location ~ ^/(api/(charts|chartValues|reports|reportTables|documents|maps|organisationUnits)|dhis-web-commons/javascripts|images|dhis-web-commons-ajax-json|dhis-web-mapping|dhis-web-visualizer) {
    if ($request_method != GET) {
        return 405;
      }

      proxy_pass         http://localhost:8080;
      proxy_redirect     off;
      proxy_set_header   Host               $host;
      proxy_set_header   X-Real-IP          $remote_addr;
      proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto  http;
      proxy_set_header   Authorization      "Basic YWRtaW46ZGlzdHJpY3Q=";
      proxy_set_header   Cookie             "";
      proxy_hide_header  Set-Cookie;
    }
  }
}
```


### Block specific Android App versions with nginx { #install_block_android_versions } 

In some scenarios the system administrator might want to block certain Android clients based on its DHIS2 App version. For example, if the users on the field have not updated their Android App version to a specific one and the system administrator wants to block their access to force an update; or completely the opposite scenario when the system administrator wants to block new versions of the App as they have not been yet tested. This can be easily implemented by using specific *User-Agent* rules in the `nginx` configuration file.

```text
http {
  
  server {
    listen       80;
    server_name  api.somedomain.com;
    
    # Block the latest Android App as it has not been tested
    if ( $http_user_agent ~ 'com\.dhis2/1\.2\.1/2\.2\.1/' ) {
        return 403;
    }
    
    # Block Android 4.4 (API is 19) as all users should have received new tablets
    if ( $http_user_agent ~ 'com\.dhis2/.*/.*/Android_19' ) {
        return 403;
    }
  }
}
```

> **Note**
> For the implementation of the method described above note the following: 
> * Before version 1.1.0 the *User-Agent* string was not being sent.
> * From version 1.1.0 to 1.3.2 the *User-Agent* followed the pattern Dhis2/AppVersion/AppVersion/Android_XX
> * From version 2.0.0 and above the *User-Agent* follows the pattern com.dhis2/SdkVersion/AppVersion/Android_XX
> * Android_XX refers to the Android API level i.e. the Android version as listed [here](https://developer.android.com/studio/releases/platforms).
> * nginx uses [PCRE](http://www.pcre.org/) for Regular Expression matching .
