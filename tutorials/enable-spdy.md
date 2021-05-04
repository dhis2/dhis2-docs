---
title: How to enable SPDY with nginx for DHIS 2
---
# How to enable SPDY with nginx for DHIS 2

[SPDY](http://en.wikipedia.org/wiki/SPDY) manipulates HTTP traffic with the aim of of reducing web page load time and improving web security. SPDY achieves reduced latency through compression, multiplexing, and prioritization. SPDY is supported by later versions of all major browsers. To follow this tutorial you need the following:

*  A Linux web server running DHIS
*  A SSL certificate
*  The nginx http server running as reverse proxy

First, verify that you have a later version of nginx with the SPDY module installed:

```
$ nginx -V
```

Make sure you see `--with-http_spdy_module` somewhere in the output. If not then you need to add the nginx stable repository and [install the latest stable version](http://wiki.nginx.org/Install). SPDY support was introduced in version 1.5.10\. To enable SPDY first open your nginx.conf configuration file, move down to your SSL server block and change this line:

```
listen 443 ssl;
```

to this:

```
listen 443 ssl spdy;
```

and reload nginx with:

```
$ sudo /etc/init.d/nginx reload
```

That's it. New visitors should get content served with SPDY. To verify your setup you can use a nice online check found at [spdycheck.org](http://spdycheck.org/). If you are using the Chrome browser you can type `chrome://net-internals/#spdy` in the address bar and look for your site after you have visited it. Note that nginx SPDY is still [experimental](http://nginx.org/en/docs/http/ngx_http_spdy_module.html).
