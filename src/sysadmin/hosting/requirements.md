# Requirements
## DHIS2 Architecture
DHIS2 software needs to be hosted some server. Setting up dhis2 involever
integrating at least theree components. A single dhis2 system can involve more
than one servers, an examople is whene you use dedicated servers/Virtual
servers for Database and/or proxy. 

For a production system, there is more factors to conside, i.e

- Reliability  - The application will typically need to be continuously available 24x7 with very little scheduled or unscheduled downtime
- Data Security - The data it will hold is valuable and potentially sensitive
- Perfomance and scalability -  Large sites may have tens of thousands of users and millions of records
- Maintainability - The system will need to be actively maintained and updated over many years

All of the above give rise to quite complex requirements regarding physical
infrastructure, security and performance constraints and a broad range of
technical skill, none of which are immediately visible when viewing the simple
software architecture above. 
It is essential that the server implementation is properly planned for when an implementation is in its planning stage in order to be able to mobilize the physical and human resources to meet these requirements.


### Components
A DHIS2 application requires a minimum of three components to run:
1. A servlet container (usually tomcat, but others such as jetty are also
   used). This is required to run the java DHIS2 web application and host
   additional apps.
2. A database server. Recent versions of DHIS2 require a postgresql database
   with version greater than 9.6.
3. A web proxy front-end. The primary function of this is for SSL termination
   and potentially load sharing. nginx and apache2 are commonly used.

In production it is also necessary to include some form of monitoring solution
as well as an alerting mechanism. Popular solutions for m nitoring include
munin and Prometheus/grafana. Prometheus is more modern and is likely to be
directly integrated into dhis2 in the near future so might be a better long
term option than munin. A minimal alerting system can be implemented using a
send-only mail system. It is also possible to integrate the alerting into
messaging systems such as Telegram or Slack.


It has been common practice to setup all three components on a single machine
(or virtual machine). This might be called the "boombox" approach and should no
longer be considered good practice except for very simple aggregate setups.
There are a number of good reasons to isolate these components:

1. Security. This is an important reason, particularly if you have a number of
   web applications running. If your web application gets hacked you want to be
   sure that the potential damage is limited.
2. Monitoring and performance. When all components are running together it can
   be hard to determine the underlying culprit in memory or cpu exhaustion and
   to provision each appropriately.
3. Scalability. In order to be able to scale the web application or database
   horizontally, replicas need to be allocated their own resources.



Isolation can be done with different levels of granularity:

1. Separate physical machines. This provides isolation but is a bit of an
   inflexible (and expensive) solution to the problem. The only exception to
   this might be the postgresql database server, where there can be some
   performance advantage to running on bare metal with direct access to disk
   array, but it is a costly choice.
2. Separate virtual machines. This can be a very sensible solution, where you
   dedicate an in-house VM or a cloud hosted VPS to each of the proxy,
   application server and database. There is a security concern that might need
   to be taken into account as, by default, traffic will pass unencrypted on
   the network between the various components. This might be considered OK if
   the network is trusted, but in many cases you might need to implement SSL on
   tomcat and postgres to ensure adequate encryption in transit.
2. Separate containers. This can be an elegant and lightweight solution to
   provide isolation between components. It is particularly attractive where
   you might be renting a single VPS server from a cloud provider. There are
   different Linux containerization solutions with different advantages and
   disadvantages. Most people will use docker or lxc or some combination of the
   two. This guide will describe a solution using lxc, but we will also add
   documentation on docker.

Whichever of the different isolation approaches you adopt it is important to
ensure that the components are configured with minimum access to one another.
So, for example, the tomcat containers need to be accessed via their http port
from the proxy server. No more than that is required and so the host based
firewall should restrict to that. Similarly, containers should not normally be
allowed to access one another by ssh. Nor should the proxy container be able to
access the postgresql server etc.
## Things that are often overlooked
Budget for: 
- Backups and archiving of data (this requires additional server resources)
- Systems for testing, staging and training (to test DHIS2 version updates and
  other major changes with lower risk to the system)
- Major operating system/database server upgrades (every 2-3 years)

> Note:
> Countries typically run each DHIS2 system (HMIS, HIV Tracker, TB Tracker,
> COVID-19) on separate servers, each of which need to be provisioned. These
> should be managed and budgeted holistically.
> With cloud/virtual systems, test servers do not need to be permanently on,
> but can be spun up on demand as long as sufficient resources are available.


## Conclusion
Decisions on hosting are not final. Countries may begin with one hosting option
with a long-term plan to transition to another, for example hosting locally and
planning to transition to the cloud or vice versa.
Many countries have the long-term ambition of building a national data center
and building the skills required to manage it. It is possible to have this
ambition in the long term while still avoiding risky hosting decisions in the
short term (such as trying to host data locally before the necessary skills and
infrastructure are in place).

