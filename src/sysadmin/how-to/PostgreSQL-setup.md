# PostgreSQL setup
## Introduction 

PostgreSQL is a popular relational database system used globally, including by
the DHIS2 health information system. This tutorial provides a step-by-step
guide for manually installing and configuring PostgreSQL on an Ubuntu
20.04/22.04 server or within LXD Containers.

The recommended version of PostgreSQL for DHIS2 version 2.35 and above is 16.
You can choose to install PostgreSQL on a dedicated server or within an LXD
container, but the tutorial suggests using an LXD container, especially when
setting up DHIS2 on a single host.

Setting up PostgreSQL correctly is crucial before deploying the Tomcat web
application. This involves configuring the database for optimal performance and
meeting the data storage and retrieval requirements of DHIS2. By following the
tutorial, you will be able to effectively set up PostgreSQL and proceed with
the smooth installation of DHIS2.

## prerequisites 

* Ubuntu 22.04 or 24.04 with good internet 
* SSH access, 
* non root user with `sudo` privileges 

## Resource requirements 

Given that DHIS2 is a database-intensive application, it is crucial to ensure
that your database server possesses adequate resources to achieve optimal
performance. Here, we provide a list of minimum recommended specifications for
your database, tailored to different deployment scenarios. These specifications
aim to facilitate smooth operation and efficient handling of DHIS2's data
management requirements.

* RAM - At least 2 GB for a small instance, 16 GB for a medium instance, 64 GB
  or more for a large instance.
* CPU -  4 CPU cores for a small instance, 8 CPU cores for a medium instance,
  16 CPU cores or more for a large instance
* FAST SSD disks 


Check your disk performance with these commands. Here, we assume the
performance disk is mounted at `/tmp/`. Adjust the path to match your
environment.

Disk latency
```
dd if=/dev/zero of=/tmp/testfile bs=512 count=1000 oflag=direct
```
Disk Throughput 
```
dd if=/dev/zero of=/tmp/test1.img bs=1G count=1 oflag=dsync
```

## Postgresql Manual install 
We recommend using automation tools to set up PostgreSQL. This guide is
intended to demonstrate what happens behind the scenes when these tools are in
use.
Although the official Ubuntu repositories do offer PostgreSQL packages, they
may not always provide the exact version you require for your installation. For
instance, Ubuntu 20.04 installs PostgreSQL 12, while Ubuntu 22.04 installs
PostgreSQL 14 by default. To install a specific version—in this case,
PostgreSQL 16, we will utilize the official PostgreSQL repositories, which
ensure access to the desired version for our installation.

### Step1 -  update and upgrade the server. 

```
sudo apt update -y 
sudo apt upgrade -y 
```

### Step2 -  installing PostgreSQL database 

* Add postgresql repo signing key

    ```
    sudo apt install curl ca-certificates gnupg
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
    ```

* Adding PostgreSQL apt repository to sources list. Official Ubuntu repository
  comes with only one version of the database, and it might be the version that
  you do not want. PostgreSQL apt repository has all the versions, and with it, you
  can install  any that you want in your environment. 

  ```
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  ```

  Update your cache after adding repository

  ```
  sudo apt update	
  ```

* Installing postgres version 16

  ```
  sudo apt install postgresql-16 postgresql-client-16 libdbd-pg-perl postgresql-16-postgis-3
  ```

* Ensure postgresql is running

  ```
  sudo systemctl start postgresql
  ```

### Step3 -  Postgresql configuration and optimization.   

* The `postgresql.conf` file serves as the primary configuration file for
  PostgreSQL. It provides essential settings that can be modified to configure
  various parameters of the PostgreSQL database. Upon initializing the database
  cluster on Ubuntu systems, a default copy of the `postgresql.conf` file is
  installed in the "**/etc/postgresql/<major_version>/main/"** directory.
  Additionally, all ".conf" files located within the
  **/etc/postgresql/16/main/conf.d/** directory are also loaded and they
  **override** what's in the main configuration file. 

  To implement our custom configurations that will override the settings in
  "postgresql.conf," we will create a new file called **"dhispg.conf"** within
  the **"/etc/postgresql/<pg_major_version>/main/conf.d" **directory.

  ```
  vim /etc/postgresql/16/main/conf.d/dhispg.conf
  ```
  Optimize below settings

  ```
  max_connections=
  shared_buffers=
  work_memory=
  maintenance_work_memory=
  effective_cache_size=
  jit=
  ```

  Below is a sample file.  

  ```
  # Postgresql settings for DHIS2
  # Adjust depending on number of DHIS2 instances and their pool size
  # By default each instance requires up to 80 connections
  # This might be different if you have set pool in dhis.conf
  max_connections = 200
  
  # Tune these according to your environment
  # About 25% available RAM for postgres
  shared_buffers = 3GB
  
  # Multiply by max_connections to know potentially how much RAM is required
  work_mem=20MB
  
  # As much as you can reasonably afford.  Helps with index generation 
  # during the analytics generation task
  maintenance_work_mem=512MB
  
  # if your database is going to be accessed over the network, you want to
  #allow its access by ensuring its listens on the appropriate interface, '*'
  #will listen to all interfaces. 
  #listen_address "*"
  
  # Approx 80% of (Available RAM - maintenance_work_mem - max_connections*work_mem)
  effective_cache_size=8GB
  
  checkpoint_completion_target = 0.8
  synchronous_commit = off
  wal_writer_delay = 10000ms
  random_page_cost = 1.1
  log_min_duration_statement = 300s
  
  # This is required for DHIS2.32+
  max_locks_per_transaction = 128
  jit = off 
  ```

* PostgreSQL Access Control configuration`,pg_hba.conf`  has access control
  settings. These settings restrict  unwanted access to the database. It has
  five parts, **TYPE,DATABASE,USER,ADDRESS **and** METHOD.**

  The "postgresql.conf" file also allows you to specify the location of the
  "pg_hba.conf" file. It is usually in
  <code>[/etc/postgresql/16/main/pg_hba.conf](https://github.com/dhis2/dhis2-server-tools/blob/main/deploy/roles/postgres/files/pg_hba.conf.sample)</code>
  by default if you install pg_version 16, , edit the by invoking-: 

  `vim /etc/postgresql/16/main/pg_hba.conf`

  You’ll add lines below the file, looking like the below two entries. 
  Obviously, the database names  and ip addresses could be different in your case. Adapt and overcome.

  ```
  # TYPE    DATABASE     USER   ADDRESS          METHOD
  host      hmis         hmis  172.19.2.11/32    md5
  host      dhis         dhis  172.19.2.12/32    md5
  ```

### Step 4: Firewall 

To ensure the security of your database server, it is important to assign a
private IP address and restrict access from the internet. At the host level,
you can enable the Uncomplicated Firewall (UFW) to strengthen your server's
defenses. By opening only the necessary ports, you can minimize potential
vulnerabilities.

It is recommended to follow these steps to enhance security:

* Assign a private IP address to your database server.
* Enable the Uncomplicated Firewall (UFW) on the host level
* Open only the required ports, specific to your database needs e.g ssh and db
  access from the application server. 

By implementing these measures, you can improve the security of your database
server, limiting access to authorized connections and reducing the risk of
unauthorized access or attacks.

Below are examples of ufw commands allowing ssh access and db access from the
application server. 

```
sudo ufw allow proto tcp from <instnce_ip> to 0.0.0.0 port 5432 comment "dhis2-traffic" 
sudo ufw allow proto tcp from 0.0.0.0 to 0.0.0.0 port 22 comment "ssh traffic"
sudo ufw enable
```

DB Maintenance and backup

For database maintenance and administration, use psql  command line client,
which usually comes with standard postgresql install. To login to the database
invoke, 

```
sudo -u postgres psql 
```

We shall be interacting with postgresql database for simple tasks with psql, 
To create a database 

```
CREATE DATABASE dhis; 
```

creating user, invoke 
```
CREATE ROLE "dhis" WITH ENCRYPTED PASSWORD 'secure_password';
```
Granting user login permissions
```
ALTER ROLE "dhis"  WITH LOGIN;
```

### Backups

We have a general backup script in place that generates a dump of a dhis2
database and transfers it to a remote backup location. The specific aspect that
varies in this script is the remote location where you intend to store your
database backup. To customize the backup script, you will need to modify it
with the details of your remote location. Below are some common remote
locations supported by the tools. 

* A remote server dedicated to backups, which requires ample storage space. If
  the remote server runs on a Linux system, we utilize the rsync tool.
  Otherwise, if it's a different operating system, we employ scp. For this
  setup to function correctly, you must have a functional SSH connection
  established with appropriate keys.
* S3-compatible object storage. In this scenario, you can push your backups to
  a remote storage solution that is compatible with the S3 protocol.

### Troubleshooting and monitoring

When encountering any problems with your PostgreSQL database, it is essential
to investigate the logs, which are typically stored in the /var/log/postgresql/
directory. By carefully examining these logs, you can gather valuable insights
into the system's behavior and identify any potential errors or irregularities.

```
sudo tail -f /var/log/postgresql/postgresql-16-main.log
```

Furthermore, PostgreSQL logs are automatically recorded in the system journal.
To analyze these logs, you can utilize the journalctl system logging service.
This provides a convenient method for reviewing PostgreSQL-related events and
errors within the system journal.

```
journalctl -fu postgresql 
```
You can also enable logging slow running queries on postgresql by adding below
lines on the postgresql configuration file. 

Common troubleshooting tips 

Check whether postgresql is invoking,  

```
ps aux | grep postgres 
```

Verify the open ports for listening and confirm that postgresql is included in
the displayed results.

```
ss -tunlp 
```

Check if you can connection with the user you created and monitor the logs
while you are doing so

```
psql -U dhis -d dhis -W 
```
### ansible Playbook

```
- hosts: 127.0.0.1 
  become: true
  gather_facts: true
  vars:
    postgresql_version: 16
  tasks:
    - name: "Update and upgrade database"
      ansible.builtin.apt:
        upgrade: true
        update_cache: true
        cache_valid_time: 86400

    # Adding postgresql signing key
    - name: "Adding postgresql repo signing key"
      ansible.builtin.get_url:
        url: "https://www.postgresql.org/media/keys/ACCC4CF8.asc"
        dest: /etc/apt/trusted.gpg.d/postgresql.asc
        owner: root
        group: root
        mode: '0600'

    # adding apt signing key
    - name: "Adding postgres apt repository to sources list"
      ansible.builtin.apt_repository:
        repo: "deb [arch={{ guest_os_arch|default('amd64') }} signed-by=/etc/apt/trusted.gpg.d/postgresql.asc] https://apt.postgresql.org/pub/repos/apt {{ hostvars[inventory_hostname]['ansible_facts']['distribution_release'] }}-pgdg main"
        update_cache: true
        filename: apt_postgresql_org
        state: present

    # Install postgresql and python module for Postgres
    - name: "Installing postgres version {{ postgresql_version }}"
      ansible.builtin.apt:
        name:
          - ca-certificates
          - postgresql-{{ postgresql_version }}
          - postgresql-client-{{ postgresql_version }}
          - postgresql-{{ postgresql_version }}-postgis-{{ '2.5' if guest_os == '20.04' else '3' }}
          - python3-psycopg2
          - libdbd-pg-perl
    
    # sometimes postgres is installed but not started
    - name: "Ensure postgresql is running"
      become: true
      ansible.builtin.service:
        name: postgresql
        state: started
        enabled: true
```
