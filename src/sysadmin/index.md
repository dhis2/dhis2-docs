# Install Guide

This section contains information related to the installation, management and 
maintenance of DHIS2 systems. It provides information on how to install DHIS2 in
various contexts, including online central server, offline local
network or standalone application.

## Introduction { #install_introduction } 

DHIS2 runs on all platforms for which there exists a Java JRE, which includes most popular operating
systems such as Windows, Linux and Mac. DHIS2 runs on the PostgreSQL
database system. DHIS2 is packaged as a standard Java Web Archive
(WAR-file) and thus runs on any Servlet containers such as Tomcat and
Jetty.

The DHIS2 team recommends Ubuntu 18.04 LTS operating system, PostgreSQL
database system and Tomcat Servlet container as the preferred
environment for server installations.

This chapter provides a guide for setting up the above technology stack.
It should however be read as a guide for getting up and running and not
as an exhaustive documentation for the mentioned environment. We refer
to the official Ubuntu, PostgreSQL and Tomcat documentation for in-depth
reading.

The `dhis2-tools` Ubuntu package automates many of the tasks described in
the guide below and is recommended for most users, especially those who
are not familiar with the command line or administration of servers. It
is described in detail in a separate chapter in this guide.

## Server specifications { #install_server_specifications } 

DHIS2 is a database intensive application and requires that your server
has an appropriate amount of RAM, number of CPU cores and a fast disk.
These recommendations should be considered as rules-of-thumb and not
exact measures. DHIS2 scales linearly on the amount of RAM and number of
CPU cores so the more you can afford, the better the application will perform.

- *RAM:* At least 2 GB for a small instance, 12 GB for a medium instance, 64 GB
  or more for a large instance.
- *CPU cores:* 4 CPU cores for a small instance, 8 CPU cores for a medium
  instance, 16 CPU cores or more for a large instance.
- *Disk:* SSD is recommeded as storage device. Minimum
  read speed is 150 Mb/s, 200 Mb/s is good, 350 Mb/s or better is
  ideal. At least 100 GB storage space is recommended, but
  will depend entirely on the amount of data which is contained in the
  data value tables. Analytics tables require a significant amount of
  storage space. Plan ahead and ensure that your server can be upgraded
  with more disk space as needed.

## Software requirements { #install_software_requirements } 

Later DHIS2 versions require the following software versions to operate.

- An operating system for which a Java JDK or JRE version 8 or 11 exists. Linux is recommended.
- Java JDK. OpenJDK is recommended.  
    - For DHIS 2 version 2.38 and later, JDK 11 is required.
    - For DHIS 2 version 2.35 and later, JDK 11 is recommended and JDK 8 or later is required. 
    - For DHIS 2 versions older than 2.35, JDK 8 is required.
- PostgreSQL database version 9.6 or later. A later PostgreSQL version such as version 14 is recommended.
- PostGIS database extension version 2.2 or later.
- Tomcat servlet container version 8.5.50 or later, or other Servlet API
  3.1 compliant servlet containers.
- Cluster setup only (optional): Redis data store version 4 or later. 

So a minimal installation of DHIS2 would consist just of the tomcat server
(with DHIS2 war file deployed) and a postgresql database server for persistent
storage.  This type of minimal setup can be suitable for a developer or
experimental setup.  For a production deployment there are many other factors
to take into account regarding maintenance, monitoring, security, scalability
and performance.

## Types of installation
There are many ways to get DHIS2 up and running.  How you choose to install
will depend on which skills and tools you are familiar with and whether the
installation is for production or experimental use.  We have a number of
different guides which emphasise different styles of implementation.

Regardless of the implementation approach you adopt, you will want to
familarize yourself with the additional reference material we provide regarding
database management, reverse proxy setup, system monitoring, upgrades etc.

### Manual Install with   [simple step-by-step guide](https://docs.kipkurgat.com/server-admin/getting-started/manual-install-on-linux.html) 
This guide takes you through the individual commands to install DHIS2 on an
ubuntu operating system using apache tomcat and postgresql. It is not aimed at
production deployments, but is useful for people to work through to in order
to understand the interconnections between the different parts.

### Automated Install with  [dhis2-server-tools](https://github.com/dhis2/dhis2-server-tools)
The ansible based
[dhis2-server-tools](https://github.com/dhis2/dhis2-server-tools)
This toolset provides a set of ansible playbooks to automate the installation
and management of DHIS2 and supporting components. It is geared towards
production environments with the aim of addressing the most critical security
and monitoring considerations out-of-the-box..

### Running DHIS2 in docker containers

### Running DHIS2 on Kubernetes
