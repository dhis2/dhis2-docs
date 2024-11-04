# Requirements

<!-- 1. A server -->
<!-- 2. Good Power supply -->
<!-- 3. Good internet -->
<!-- 4. Good storage -->
<!-- 5. Fast Interconnect network -->

## Hardware

Hardware requirements depend on your database size, with larger databases needing more resources. It’s important to monitor system performance to understand usage. If you're managing your own infrastructure (not cloud-based), ensure your network connections are solid, using nothing below 1 Gbps between hosts. Fast SSDs are critical, particularly for PostgreSQL databases, as they provide better read/write speeds and lower disk latencies, which improve overall performance.

## Operating System

DHIS2 have been widely tested on Ubuntu 22.04 and 24.04 host. It is recommended that you run it on latest LTS release of an Ubuntu Server.

### DHIS2 Architecture

DHIS2 needs servers to run. It has different parts: DHIS2 war file, PostgreSQL database, Monitoring Server and Proxy. You can install all these components on a single server or distributed on multiple servers. While the architecture itself may seem straightforward, running it in a real-world environment (production) requires significant planning.

Hosting Consideration factors

- **Reliability:** - the application should strive for 24/7 availability with clearly defined windows for scheduled maintenance and minimal potential for unscheduled downtime.
- **Data Security:** - If the data is sensitive, E. Personal Identifier Information (PII) robust security measures are crucial.
- **Performance and scalability:** - Large sites may have tens of thousands of users and millions of records
- **Maintainability:** - The system will need to be actively maintained and updated
- **Scalability:** - Whether the system must be scalable to accommodate future growth in data volume, user base, or functionality. This may involve implementing features like horizontal scaling or using distributed architectures.

These requirements translate into needing the right hardware (physical infrastructure), strong security practices, and good overall performance. It also means the people maintaining the system need a wide range of technical skills. This complexity might not be obvious from just looking at the simple dhis2 architecture.

Therefore, it is vital to plan for the server implementation early on. This way, you can secure the necessary resources (hardware and skilled personnel) to meet these demands and ensure the smooth running of the application in a production environment.

### DHIS2 application Components

A DHIS2 application requires a minimum of three components to run:

- **Servlet container (Required):** Like tomcat (or jetty). Runs the java DHIS2 web application and hosts additional apps.
- **A database server (Required):** Recent versions of DHIS2 require a postgresql database with version greater than 9.6.
- **A web proxy front-end (Optional):** The primary function of this is for SSL termination and potentially load sharing. Nginx and apache2 are commonly used.
- **Monitoring (Optional):** For real-world use (production), keeping an eye on both the application and server health is crucial. This can be done with tools like Prometheus (modern and likely to be directly integrated with the dhis2 system ) or Munin/Zabbix. Alerts can be sent via email or integrated with messaging apps like Telegram or Slack.

It has been common to set up all four components on one machine or a virtual machine, This might be called the "boombox" approach and should no longer be considered good practice except for very basic setups for aggregate data collection. There are a number of good reasons to isolate these components:

- **Security:**- This is an important reason, particularly if you have a number of web applications running. If your web application gets hacked you want to be sure that the potential damage is limited.
- **Monitoring and performance:**- When all components are running together it can be hard to determine the underlying culprit in memory or cpu exhaustion and to provision each appropriately.
- **Scalability:**- In order to be able to scale the web application or database horizontally, replicas need to be allocated their own resources.
- **Easier Maintenance:**- Updating or maintaining individual components becomes simpler when they're not intertwined.
- **Improved Stability:**- Isolating components prevents issues in one area from crashing everything else.

Isolation can be done with different levels of granularity:

- **Separate physical machines:** - This provides isolation but is a bit of an inflexible (and expensive) solution to the problem. The only exception to this might be the postgresql database server, where there can be some performance advantage to running on bare metal with direct access to disk array, but it is a costly choice.
- **Separate virtual machines:** - This can be a very sensible solution, where you dedicate an in-house VM or a cloud hosted VPS to each of the proxy, application server and database. There is a security concern that might need to be taken into account as, by default, traffic will pass unencrypted on the network between the various components. This might be considered OK if the network is trusted, but in many cases you might need to implement SSL on tomcat and postgres to ensure adequate encryption in transit.
- **Separate containers:** - This can be an elegant and lightweight solution to provide isolation between components. It is particularly attractive where you might be renting a single VPS server from a cloud provider. There are different Linux containerization solutions with different advantages and disadvantages. Most people will use docker or lxc or some combination of the two. This guide will describe a solution using lxc, but we will also add documentation on docker.

No matter how you isolate the system components (web server, app server, database, etc.), they should have limited access to each other. Below are few examples of what that means:

- **Proxy Server (e.g., Nginx):** Only the proxy server can access Tomcat containers through the HTTP port.
- **Application Server (e.g., Tomcat):** Shouldn't allow direct access via SSH from other components.
- **Database Server (e.g., PostgreSQL):** Shouldn't be accessible by the proxy server directly.

**Lock it it Down:** Firewalls on your servers (physical or virtual) and containers should be enabled and only allow connections from authorized sources. This minimizes the risk of one compromised component affecting others.

## Other Important considerations

### Budget:

- Backups and archiving of data (this requires additional server resources)
- Systems for testing, staging and training (to test DHIS2 version updates and other major changes with lower risk to the system)
- Major operating system/database server upgrades (every 2-3 years)

> **Note**
>
> Countries typically run each DHIS2 system (HMIS, HIV Tracker, TB Tracker, COVID-19) on separate servers, each of which need to be provisioned. These should be managed and budgeted holistically. With cloud/virtual systems, test servers do not need to be permanently on, but can be spun up on demand as long as sufficient resources are available.

## Conclusion

Decisions on hosting are not final. Countries may begin with one hosting option with a long-term plan to transition to another, for example hosting locally and planning to transition to the cloud or vice versa. Many countries have the long-term ambition of building a national data center and building the skills required to manage it. It is possible to have this ambition in the long term while still avoiding risky hosting decisions in the short term (such as trying to host data locally before the necessary skills and infrastructure are in place).
