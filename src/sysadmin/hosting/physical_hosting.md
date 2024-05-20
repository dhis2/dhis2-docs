# Physical Hosting
## Introduction
Physical hosting involves running DHIS2 servers within a country, where
organizations manage their own physical servers either within ministry premises
or centrally in a national data center.
In cases where the ministry or government has sufficient technical and human
resources and infrastructure, physical hosting can be a preferred option.

As mentioned, physical hosting can further be sub-divided into two 

## Local Physical hosting
The Ministry of Health typically installs its server in a dedicated room.  This
server room often houses multiple servers, not just one.  These servers are
often clustered together to ensure high availability and reliability.

### Advantages
- Direct Control: Offers the highest level of control over server resources and data.
- Accessibility: Having the server on-site ensures easy physical access for
  maintenance, 


### Drawbacks
- Demands significant technical expertise for design, installation, and
  maintenance.
- Initial investment costs are high.
- Presents various physical challenges such as power supply reliability, pest
  control, environmental control (water, ventilation), physical security, and
  round-the-clock building access.

Because of the costs and risk involved, in most cases we would not advise going
this route.

## Centralized physical hosting
he Ministry of Health (MoH) applications reside in a central government data
center, acting as a shared service for various ministries and sectors. This
data center typically uses virtualization technology to create and share
resources efficiently.

In simpler terms, MoH is just one tenant in this large data center "cloud"
environment, sharing resources with other government entities.

### Advantages 
- Aligned with national policies on data sovereignty
- MoH does not need to maintain server infrastructure directly
- Only System Administrator skills are required

### Drawbacks
- Cost may be higher than cloud hosting providers
- Dependent on the skill level and infrastructure of the data center team
- Access to services can be hampered by bureaucratic processes
- We often see performance issues in these setups

## Other Considerations for Physical hosting 
### The server 
Its the server where you'd typically have compute and memory resources. More
often that not, you'd also have directly attached storage on a physical server.
A data-center in most cases have more that one servers running, and different
serve servers different purposes depending on the application they are running.
Workloads have different resource requirements, there are those that are compute
intensive, others are over reliant on memory and so forth. 
Servers are typically interconnected using fast switches.

A PostgreSQL server thrives on good resources, including a good share of CPU
and RAM.  For optimal performance, fast disks are essential, with Solid State
Drives (SSDs) being the preferred choice.
The following command, for example , provides a quick overview of your disk performance in
terms of latency. Any latency exceeding 3 seconds may indicate a potential
issue.

```
dd if=/dev/zero of=/tmp/test2.img bs=512 count=1000 oflag=dsync
```

### Networking
Well, in cases where you'd be building a cluster of servers, you'd typically
need to have a fast connectivity between your physical servers. It is
recommended to have fiber links supporting even up to 40G links connecting
your servers. This implies a modern network Switch in your server room. 
If you are going to be running your workloads on a Network Attached Storage
(NAS), ensure this resource is having excellent networking to your server
stack.
Your Clustered hosts would typically need super-fast networking to perform optimally.  

#### Internet Connectivity
*Inbound Traffic:* DHIS2 application access for users will occur through the
internet. This necessitates sufficient bandwidth to accommodate user traffic
efficiently.

*Outbound Traffic:* Periodic software and system updates require outbound
internet access for the server.

*Recommendation:* To ensure smooth user experience and efficient update
processes, a high-bandwidth internet connection (e.g., 1 Gigabit per second) is
recommended for your data center.


#### DMZ network
In a Data-Center, you have gateway to your infrastructure, this is usually a
reverse proxy. Servers in this territory would need to have public ip addresses
and for them to be accessible from the internet. It is a good practice to have
this server in a separate network , a DMZ. 
Other servers to be in this network is SSH JumpHost. 
#### Internal network
You have other servers that needs not to be accessible from the internet.
Examples are the application server, this is were you'll be running your dhis2
application and the database server, this is where you'll have PostgreSQL
database running. 
These servers should be on a private network with not direct inbound access
from the internet. This servers are only accessible from either ssh JumpHost
for ssh access for from the proxy (running nginx, apache2 or HAProxy) for web
    app access. 

### High Availability
A high availability (HA) setup is broadly defined as infrastructure without a
single point of failure.  Its a good practice to have
redundancy on the different levels i.e server, networking and
storage.  

### Backups and disaster planning
Backups and archiving requires additional server resources.
Consider a disaster recovery plan with backups in a separate data center for added security.

### Testing environment
A dedicated testing environment (separate servers) is crucial for safely
testing DHIS2 updates and other major changes before deploying them to
production. This minimizes risk to your live system.

Budget for additional servers to facilitate a robust testing environment.
Plan for major upgrades to operating systems and database servers every 2-3
years. 

Testing these upgrades in the dedicated environment helps ensure a
smooth transition when implemented.

### Prioritize Physical Security:
*Implement Rigorous Access Control:* Enforce strict access protocols for the data
center. This may include the use of security badges, biometric authentication
systems, and security cameras to monitor entry points and critical areas.

*Mitigate Environmental Hazards:* Develop a comprehensive pest control program to
safeguard against rodents and other potential threats. Additionally, consider
measures to mitigate other environmental hazards like flooding or fire.

*Maintain Cable Infrastructure:* Regularly inspect and maintain network and power
cables to prevent damage or deterioration.
