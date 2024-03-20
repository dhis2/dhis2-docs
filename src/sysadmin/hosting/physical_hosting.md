# Physical Hosting
Physical hostiing can further be sub-divided into two 
## local 
For local hosting, the server is installed on site in the Ministry of Health,
typically in a repurposed room.
### Pros: 

Most direct control over server resources and data

### Cons:
- Requires extensive technical skill to design, install and manage
- High startup costs
- Numerous physical challenges that need to be addressed: continuous power,
  rodent control, water and ventilation management, physical security, 24/7
  building access, etc.
- Because of the costs and risk involved, in most cases we would not advise
  going this route.

## Central  (Ministry or national data centre).
MoH applications are hosted in a purpose-built data center managed as a cross-government service.

### Pros: 
Aligned with national policies on data sovereignty
MoH does not need to maintain server infrastructure directly
Only System Administrator skills are required

### Cons:
- Cost may be higher than cloud hosting providers
- Dependent on the skill level and infrastructure of the data center team
- Access to services can be hampered by bureaucratic processes
- We often see performance issues in these setups

In cases where the ministry or government has sufficient technical and human
resources and infrastructure, this can be a preferred option.



Server is installed on site in the Ministry of Health, typically in a
re-purposed room. Often, its not just one serve running withing the server room.
You'd typically have resources clustered together for High Availability and
reliability. Things that you'd typically see in a server room is listed below 


1. Compute resources. 
2. Memory 
3. Storage disks 
4. Netowrk recsouces 

## Considerations
### The server 
Its the server where you'd typically have compute and memory resouces. More
often that not, you'd also have directly attached storage on a physical server.
A datacentre in most cases have more that one servers running, and different
serve servers different purposes depending on the application they are running.
Workloads have different resocue requirements, there are those that are compute
intesive, others are over reliant on memory and so forth. 
Servers are typically interconnected using fast switches. 

### Networking
Well, in cases where you'd be bulding a cluster of servers, you'd typically
need to have a fast connectivity between your physical servers. It is
recommended to have fibre links suppoortding even up to 40G links connecting
your servers. This implies a modern network Switch in your server room. 
If you are going to be running your workloads on a Network Attached Storeage
(NAS), ensure this resource is having excellent networking to your server
stack.
Your Clustered hosts would typically need super-fast networking to perform optimally.  

#### Outbound Connectivity (Public access)
Your users will be accesssing dhis2 application from the internet. There are
users who'll be doing data capture and submission and those who'll be consuming
analytics generated from the captured data. You will need a good internet
connection to you dataCenter, its recommended you get 1G internet link for your
dataCentre. 

#### DMZ network
In a dataCentre, you have gateway to your infrastructure, this is usually a
reverse proxy. Servers in this teritory would need to have public ip addresses
and for them to be accessible from the internet. It is a good practice to have
this server in a separate network , a DMZ. 
Other servers to be in this network is SSH jumpHost. 

#### Internal network
You have other servers that needs not to be accessible from the internet.
Examples are the application server, this is were you'll be runnning your dhis2
application and the database server, this is where you'll have postgreSQL
database running. 
These servers should be on a private network with not direct inbound access
from the internet. This servers are only accessible from either ssh JumpHost
for ssh access for from the prox (running nginx, apache2 or HAProxy) for web
    app access. 


### High Availability
A high availability (HA) setup is broadly defined as infrastructure without a
single point of failure.  Its a good practice to have
redundancy on the different levels i.e server, networking and
storage.  

#### Backups and disaster planning

### Data Centre Security
You should ensure your data Centre is physically secure from un-authorized
human access. Add redundancy to every layaer of your architecture is  It should
also be difficult for rodents to access. Rodents tend
to damage network and power cobles in your data Centre.  

