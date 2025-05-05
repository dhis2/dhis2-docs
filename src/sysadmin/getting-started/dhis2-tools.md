# dhis2-tools

Tools have been developed to help in deploying dhis2 in a secure and standard way. There are two versions of the tools, one is based on bash scripts and the other is written with ansible. The end result for these tools is the same; they gives you a dhis2 deployment with munin and glowroot monitoring.

> **Note**
>
> We strongly recommend using [dhis2-server-tools](https://github.com/dhis2/dhis2-server-tools) because of the advantages that ansible offers.

## dhis2-server-tools { #getting-started-dhis2-server-tools }

To deploy dhis2 with this tool, click the link [here](https://github.com/dhis2/dhis2-server-tools), and follow through the instructions on the **README.md** file. The scripts leverage Ansible, offering several benefits through support for multiple connection parameters like SSH, LXD, Docker, and others. By incorporating various connection plugins, they enable the implementation of diverse architectures. This includes distributed setups with dedicated instances for PostgreSQL, proxy, and application servers.

### Idempotency

One notable feature of Ansible, idempotency, ensures that running the same script multiple times yields consistent results.

### Connection plugins

The Ansible tool boasts support for over ten connection plugins. To explore the list of supported connection plugins, you can invoke the command:

```
ansible-doc -t connection --list
```

in your terminal. Within this tooling, we leverage two connection plugins: SSH and LXD.

**ssh**

  : Utilizing the underlying SSH connection, it facilitates the execution of deployment scripts with Ansible. This capability enables the configuration of distributed setups for dhis2 using Ansible.

**lxd**

  : This connection plugin deploys dhis2 on a single server by utilizing LXD containers, offering a streamlined and efficient deployment process.

### Features of dhis2-server-tools

- **Standard dhis2 Deployment:** Ensures a standardized dhis2 deployment following best security practices.

- **Server and App Monitoring with Munin and Glowroot:** Provides monitoring capabilities Munin and Glowroot.

- **Reverse Proxy:** Offers Nginx/Apache2 reverse proxy with optional TLS termination.

- **Secure PostgreSQL Server:** Ensures a standardized and secure PostgreSQL server.

- **Backups**: the tooling also helps in generating a backup script, with S3 sync capabilities.

  > **Note** 
  > You'll need a working s3 endpoint with credentials to configure this.

- **Un-attended upgrades**: The tooling automates the configuration of un-attended upgrades for all of the hosts.

## dhis2-tools-ng

This is the [classic dhis2 server deployment tooling](https://github.com/bobjolliffe/dhis2-tools-ng) based on bash scripts. This should be considered deprecated now, in favour of [dhis2-server-tools](#getting-started-dhis2-server-tools)
