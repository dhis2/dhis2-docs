# architecture
# Deployment Architectures
## Introduction
DHIS2 application can be deployed using different architectures, including
single-server, distributed, hybrid, Docker, and Docker with Kubernetes. The
choice of architecture depends on various factors such as simplicity,
management complexity, scalability, maintainability, and performance.
## The Architecures
1. single server <br> 
    Uses lxd containers, you'll set `ansible_connection` variable to `lxd`, 
2. distributed <br> 
    dhis2 application stack running on separate servers/Virtual-machines. e.g
    database server runs on its own VM.  
3. Hybrid
   A good example here is when you have say postgres running on its own
   dedicated machine and proxy, dhis2 tomcat instances running from the same
   server.

## Single-server Architecture
In this setup, all components run on the same server. We are using LXD
containers to separate application components. The containers are segregated
for PostgreSQL, monitoring, instances and proxy, which improves security and
 resource allocation
Its the default choice with ansible tools with `ansible_connection=lxd`
variable set on inventory file. 

### Features
* Simplicity 
* Easy to manage
* Performance

### Drawbacks 
* Scalability - scaling individual components is challenging in this kind of a setup.
* Maintainability 
* Flexibility - less flexible that distributed setup. 

## Distributed architecture
Here you have components running on their own dedicated servers. 
For tools to support this architecture, you'll require a deployment server to
execute your Ansible scripts. The deployment server must have an SSH connection
to the other hosts. You can test the SSH connection using the command: `ansible
all -m ping -u <ssh_user> -k`. Ensure that the `ansible_connection` parameter
is set to SSH, i.e., `ansible_connection=ssh`, and make sure the IP addresses
of the hosts are correctly configured in the inventory file.

To start the installation, follow these steps:
<table>
<tr>
    <th style="text-align: left; vertical-align: top;">Command</th>
    <th style="text-align: left; vertical-align: top;">Description</th>
  </tr>
 <tr>
    <td style="vertical-align: top; text-align: left;"><code>sudo ufw limit 22</code><br><code>sudo ufw enable</code></td>
    <td> Opens ssh port on the host firewall, change 22 to if you are using non default ssh port </td>
  </tr>
 <tr>
    <td style="vertical-align: top; text-align: left; white-space: nowrap;"><code>cd dhis2-server-tools/deploy/</code></td>
    <td> cd into dhis2-server-tools/deploy/ directory </td>
  </tr>
   <tr>
    <td style="vertical-align: top; text-align: left;"><code>vim inventory/hosts </code></td>
    <td> Edit inventory hosts file and set <code>ansible_connection=ssh </code> </td>
  </tr>
   <tr>
    <td style="vertical-align: top; text-align: left;"><code> ansible-playbook dhis2.yml -u=your_ssh_user -Kk </code></td>
    <td><code>-K</code>&#8212;</span> prompts for sudo password <br><code>-k</code><span>&#8212;</span> prompts for ssh password <br><code>-u</code> <span>&#8212;</span> username for ssh connection 
 </td>
  </tr>
</table>

Replace `<your_ssh_user>` with the appropriate SSH user for the hosts.

```
ansible_connection=ssh
```

### Strengths
* scalability - easier to scale individual components independently. 
* fault isolation - Can easily isolate faults since things are decoupled. 
* modularity - is more modular than single server setup. 
* More flexible than single-server architecture.

## hybrid 
A balanced approach is possible, where the database server is isolated while
everything else runs on a single server. This allows you to enjoy the benefits
of both configurations.

## Docker, lxd and kubernetes 
There are other emerging architectures that utilize Docker and Kubernetes as
container orchestration layers.
