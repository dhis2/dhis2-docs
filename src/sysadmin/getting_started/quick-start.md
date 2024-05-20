# Quick Start
DHIS2 stands as a freely accessible, open-source, and adaptable software
platform. It serves the purpose of collecting, managing, visualizing, and
analyzing health data derived from diverse sources and programs.
DHIS2 components are  proxy(nginx/apache2), Tomcat Server, PostgreSQL database
and optional APM and Server monitoring tools. 
This quick start shows you how to instaall dhis2 and its components and a
single sever with dhis2-server tools. 
## Requirements
### Hardware 
Hardware requirements highly depends on the size of your database, good
resources are required for big databases. Its generally good to monitor you
system and get to know how resources are being utilized.
If by any chance you are running your own infrastructure, not on cloud, ensure
you have good networking, not anything below 1Gbps links between your hosts. Do
not use 100Mbps switch ports. Use fast **ssd** disks as well, at lest for
PostgreSQL database. 

## Operating system. 
DHIS2 have been widely tested on Ubuntu  operating system. Its recommended that
you run it on latest LTS release. 

## Installing DHIS2 
1. Download dhis2-server-tools
   ```
   git clone https://github.com/dhis2/dhis2-server-tools.git
   ```

2. Ensure your server has firewall running and ssh port opened. Below assumes
   your ssh port is default 22, 
   ```
   sudo ufw limit 22/tcp
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
https://172.16.0.1/dhis
```

## Set fully qualified domain name (fqdn)

> **Important**
> 
> Before setting fqdn, its has to be mapped to your servers public ip address
> for letsencrypt to work. Otherwise, you can use your own customssl
> certificate. 

Edit your inventory hosts file and add fqdn variable, use your favourited
editor, common are `vim` or `nano` 
     ```
     vim inventory/hosts 
     fqdn=dhis.example.com
     ```
Save the your changes and run installation again to apply your changes 
```
sudo ./deploy.sh
```

## Adding another instance

You can run multiple intances from a single server. Here is how you do it 
Edit your inventory/hosts file located in `dhis2-server-tools/deploy/inventory/hosts`
```
vim inventory/hosts
```
Add another line under `[instances]` section. e.g 
```
hmis    ansible_host=172.19.1.12   database_host=postgres
```

> **Note**
> 
> The name `hmis` and ansible_host `172.19.1.12` should be unique. 

## You have your own TLS certificate.
In some occasions, you could be having your own TLS certificate and you are not using letsencrypt. 
Here is how you can instruct the tools to use your own TLS certificate. 

> **Note**
>
> You'll need to have your TLS certificate pem file and its corresponding key.

Copy TLS certificate and key to `dhis2-server-tools/deploy/roles/proxy/files/`
and name them `customssl.crt` and `customssl.key` respectively. 

Instruct your tools to use these TLS parameters by editing your `inventory/hosts`
file and setting `SSL_TYPE` parameter to `customssl` e.g
```
SSL_TYPE=customssl
```

