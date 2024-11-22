# Post Install {# getting_started_post_install }   
### Fully Qualified Domain Name {# getting_started_post_install_fully_aualified_domain_name } 
Edit `dhis2-server-tools/deploy/inventory/hosts` file and set the `fqdn` variable.`fqdn` 

> **NOTE**
>
> The `fqdn` variable is an instance-specific setting, allowing you to define
> unique Fully Qualified Domain Names (FQDNs) for each DHIS2 instance. This is
> particularly useful when you're running multiple instances with different
> subdomains. By default, the `fqdn` variable is configured at the group level
> (all), which applies to all instances. However, you can override this setting
> at the instance level to specify a custom FQDN for each instance.

```
vim inventory/hosts
fqdn=dhis.example.com
```
Save your changes and run the install again,
```
sudo ./deploy.sh
```

### TLS Certificate {# getting_started_post_install_tls_certificate } 

If you're using a custom TLS certificate instead of Let's Encrypt, you'll need
to configure the tools to use it. This involves specifying the path to your
certificate and private key files.

> **Note**
>
>  Ensure you have your TLS certificate file and its corresponding private key
>  ready before proceeding with the configuration.

- Copy TLS certificate and key to `dhis2-server-tools/deploy/roles/proxy/files/` They should be named `customssl.crt` and `customssl.key` respectively.

- Configure the tools to use the copied TLS certificate and key by editing your `inventory/hosts` file and setting `SSL_TYPE` parameter to `customssl` , see below,

```
SSL_TYPE=customssl
```


###  Adding an instance {# getting_started_post_install_adding_an_instance } 
You can run multiple instances on a single server. Adding an instance will create a separate lxd container.

- Edit `dhis2-server-tools/deploy/inventory/hosts` file in
  ```
  vim dhis2-server-tools/deploy/inventory/hosts
  ```
- Add a new line line under `[instances]` section, should look like the line below,
  ```
  [instances]
  dhis    ansible_host=172.19.1.11   database_host=postgres # your first instance
  hmis    ansible_host=172.19.1.12   database_host=postgres # your second instance
  ```

> **Note**
>
> The name `hmis` and ansible_host `172.19.1.12` should be unique.
### Setting Instance Heap Memory {# getting_started_post_install_instance_heap_memory } 
### Changing/Setting instance base path {# getting_started_post_install_instance_base_path } 

### PostgreSQL Tuning  {# getting_started_post_install_postgresql_tuning } 
The default settings of the installed PostgreSQL database should be sufficient
and functional at this point. However, for performance optimization and to
full utilize the available system resources, you may consider making some
adjustments. To begin with the optimization process, it is essential to first
assess the resources available on your system. I.e, total RAM  available, use
`free -h` for that.

The amount of RAM to allocate to PostgreSQL depends on the number of DHIS2
instances you plan to run. If you have a production instance and a small test
instance, with 32GB of RAM, dedicating 16GB exclusively to PostgreSQL would be
a reasonable starting point.

Decide amount of RAM to allocate PostgreSQL, and limit the postgres container to that size, e.g 
```
sudo lxc config set postgresql limits.memory 16GB
```
PostgreSQL specific parameters can be set for further optimization,
Add a file on dhis2-server-tools/deploy/inventory/host_vars/postgres_host
If for example you database host is named postgres in you `inventory/hosts` file, 
```
cd dhis2-server-tools/deploy/inventory/host_vars/
cp postgres.template postgres
```
Example config
```
pg_max_connections: 400 

pg_shared_buffers: 8GB

pg_work_mem: 20MB

pg_maintenance_work_mem: 3GB

pg_effective_cache_size: 10GB
```

<table>
 <tr>
    <th style="text-align: left; vertical-align: top;">Parameter</th>
    <th style="text-align: left; vertical-align: top;">Comments</th>
  </tr>
<tr>
    <td style="vertical-align: top; text-align: left;"><code>postgresql_version</code></td>
    <td> Version for PostgreSQL to be installed, default: 13 </td>
  </tr>
  <tr>
    <td style="vertical-align: top; text-align: left;"><code>pg_max_connections</code></td>
    <td> Maximum allowed connections to the database </td>
  </tr>
   <tr>
    <td style="vertical-align: top; text-align: left;"><code>pg_shared_buffers</code></td>
    <td> Shared Buffers for postgresql,<br> recommended <code>0.25 x Available_RAM</code> for PostgreSQL </td>
  </tr>
   <tr>
    <td style="vertical-align: top; text-align: left;"><code>pg_work_mem</code></td>
    <td> PostgreSQL work memory, <br> Recommended = <code>(0.25 x Available_RAM)/max_connections</code> </td>
  </tr>
   <tr>
    <td style="vertical-align: top; text-align: left;"><code>pg_maintenance_work_mem</code></td>
    <td> As much as you can reasonably afford.  Helps with index generation during the analytics generation task <br> </td>
  </tr>
   <tr>
    <td style="vertical-align: top; text-align: left;"><code>pg_effective_cache_size</code></td>
    <td> Approx <code>80% of (Available RAM - maintenance_work_mem - max_connections*work_mem)</code> </td>
  </tr>
</table>

