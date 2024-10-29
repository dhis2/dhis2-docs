# Quick Start
DHIS2 stands as a freely accessible, open-source, and adaptable software
platform. It serves the purpose of collecting, managing, visualizing, and
analyzing health data derived from diverse sources and programs.
DHIS2 components are  proxy(Nginx/Apache2), Tomcat Server, PostgreSQL database
and optional APM and Server monitoring tools. 
This quick start shows you how to install dhis2 and its components and a
single sever with dhis2-server tools. 
## Requirements
### Hardware 
Hardware requirements depend on your database size, with larger databases
needing more resources. It’s important to monitor system performance to
understand usage. If you're managing your own infrastructure (not cloud-based),
ensure your network connections are solid, using nothing below 1 Gbps between
hosts. Fast SSDs are critical, particularly for PostgreSQL databases, as they
provide better read/write speeds and lower disk latencies, which improve
overall performance.

## Operating system. 
DHIS2 have been widely tested on Ubuntu 22.04 and 24.04 host. It is recommended that
you run it on latest LTS release of an Ubuntu Server.

## Installing DHIS2 
1. Use SSH to access your server and clone "https://github.com/dhis2/dhis2-server-tools" repository
   
   ```
   git clone https://github.com/dhis2/dhis2-server-tools.git
   ```

2. Ensure your server has firewall running and ssh port allowed. 
   ```
   sudo ufw limit {ssh_port}/tcp
   sudo ufw enable
   ```

3. The install
   ```
   cd dhis2-server-tools/deploy
   cp inventory/hosts.template inventory/hosts
   sudo ./deploy.sh
   ```

4. Access your dhis2 application with your browser with the server's ip address e.g 
```
https://{server_ip}/dhis
```

## Set fully qualified domain name (fqdn)

> **Important**
> 
> Before setting `fqdn`, its has to be mapped to your servers public ip address
> for LetsEncrypt to work. Otherwise, you can use your own custom TLS Certificate.

Edit your inventory hosts file and add `fqdn` variable, use an editor of your choice.   

     ```
     vim inventory/hosts 
     fqdn=dhis.example.com
     ```
Save the your changes and run the install again, 
```
sudo ./deploy.sh
```

## Adding an instance

You can run multiple instances on a single server. Adding an instance will
create a separate lxd container.
Edit your inventory/hosts file located in `dhis2-server-tools/deploy/inventory/hosts`
```
vim inventory/hosts
```
Add another line under `[instances]` section. E.g 
```
hmis    ansible_host=172.19.1.12   database_host=postgres
```

> **Note**
> 
> The name `hmis` and ansible_host `172.19.1.12` should be unique. 

## You have your own TLS certificate.
In some occasions, you could be having your own TLS certificate and you are not
using LetsEncrypt. Here is how you can instruct the tools to use your own TLS
certificate. 

> **Note**
>
> You'll need to have your TLS certificate file and its corresponding key.

Copy TLS certificate and key to `dhis2-server-tools/deploy/roles/proxy/files/`
They should be named `customssl.crt` and `customssl.key` respectively.

Instruct your tools to use these TLS parameters by editing your `inventory/hosts`
file and setting `SSL_TYPE` parameter to `customssl` , see below, 

```
SSL_TYPE=customssl
```

## Automated PostgreSQL Optimization



