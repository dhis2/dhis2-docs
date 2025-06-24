# Installation

This section contains information related to the installation, management and maintenance of DHIS2 systems. It provides information on how to install DHIS2 in various contexts, including online central server, offline local network or standalone application.

## Introduction { #install_introduction }

---

DHIS2 runs on all platforms for which there exists a Java JRE, which includes most popular operating systems such as Linux, Windows and Mac. DHIS2 is packaged as a standard Java Web Archive (WAR-file) and thus runs on any Servlet containers such as Tomcat and Jetty. Its writes its data to a PostgreSQL database. Its recommended that you run it on a Supported Ubuntu LTS system,

This chapter provides a guide for setting up the above technology stack. It should however be read as a guide for getting up and running and not as an exhaustive documentation for the mentioned environment. We refer to the official Ubuntu, PostgreSQL and Tomcat documentation for in-depth reading.

## Server specifications { #install_server_specifications }

---

DHIS2 is a database intensive application and requires that your server has an appropriate amount of RAM, a good number of CPU cores and a fast disk, preferably an solid state disk (ssd). These recommendations should be considered as rules-of-thumb and not exact measures. DHIS2 scales linearly on the amount of RAM and number of CPU cores so the more you can afford, the better the application will perform.

- _RAM_
  : At least 8 GB for a small instance, 16 GB for a medium instance, 64 GB or more for a large instance.
- _CPU_
  : 4 CPU cores for a small instance, 8 CPU cores for a medium instance, 16 CPU cores or more for a large instance.
- _Disk_
  : SSD is recommended as the storage device. Minimum read speed is 150 Mb/s, 200 Mb/s is good, 350 Mb/s or better is ideal. At least 100 GB storage space is recommended, but will depend entirely on the amount of data which is contained in the data value tables. Analytics tables require a significant amount of storage space. Plan ahead and ensure that your server can be upgraded with more disk space as needed. On linux, you can test disk latency and throughput with below commands

  ```
  # disk latency
  dd if=/dev/zero of=/tmp/test2.img bs=512 count=1000 oflag=dsync

  # disk throughput
  dd if=/dev/zero of=/tmp/test1.img bs=1G count=1 oflag=dsync

  # remove /tmp/test1.img after testing
  rm -v -i /tmp/test1.img
  ```

## Software requirements { #install_software_requirements }

---

Later DHIS2 versions require the following software versions to operate.

- An operating system for which a Java JDK or JRE version 8 ,11 or 17 exists. Ubuntu LTS release is recommended.
- Java JDK. OpenJDK is recommended.

  Table: DHIS2 JDK compatibility

  | DHIS2 version | JDK recommended | JDK required | Tomcat required |
  | ------------- | --------------- | ------------ | ------------ |
  | 2.42          | 17              | 17           | 10           |
  | 2.41          | 17              | 17           | 9            |
  | 2.40          | 17              | 11           | 9            |
  | 2.38          | 11              | 11           | 9            |
  | 2.35          | 11              | 8            | 9            |
  | pre 2.35      | 8               | 8            | 9            |

- PostgreSQL database version 13 or later. A later PostgreSQL 16 is recommended.
- PostGIS database extension version 2.2 or later, 3 is recommended.
- Tomcat servlet container version 8.5.50 or 9, 9 is recommended.
- Cluster setup only (optional): Redis data store version 4 or later.

So a minimal installation of DHIS2 would consist of just the tomcat server (with DHIS2 war file deployed) and a PostgreSQL database. This type of minimal setup can be suitable for a developer or experimental setup. For a production deployment there are many other factors to take into account regarding maintenance, monitoring, security, scalability and performance.

## Install approaches { #install_install_approaches }

---

There are many ways to get DHIS2 up and running. How you choose to install will depend on which skills and tools you are familiar with and whether the installation is for production or experimental use. We have a number of different guides which emphasize different styles of implementation. Regardless of the implementation approach you adopt, you will want to familiarize yourself with the additional reference material we provide regarding database management, reverse proxy setup, system monitoring, upgrades etc.

#### [Automated Install](#getting_started_linux_automated_install) { #install_automated_install_on_linux }

These tools are ansible based [dhis2-server-tools](https://github.com/dhis2/dhis2-server-tools). This tool set provides a set of ansible playbooks to automate the installation and management of DHIS2 and supporting components. It is geared towards production environments with the aim of addressing the most critical security and monitoring considerations out-of-the-box.

#### [Manual Install](#getting_started_linux_manual_install)

This guide provides step-by-step instructions for setting up DHIS2 on Ubuntu 22.04. For production environments, however, we highly recommend using an automated installation to ensure consistency and ease of management. Manual setup is ideal for learning and understanding how different DHIS2 components are setup and how they interconnect.

### Running DHIS2 on docker

#### Important Considerations for Deploying DHIS2 with Docker

While Docker containers offer a potential method for running DHIS2 applications, there are important factors to consider before implementing this approach in production environments.

##### Limited Production Use Cases:

Currently available Docker images for DHIS2 may not be suitable for production deployments. These images haven't undergone extensive testing in real-world production settings. While they might function adequately for development purposes, their stability and performance under demanding workloads cannot be guaranteed for mission-critical applications.

##### User Awareness and Testing:

The decision to utilize DHIS2 within Docker containers for production environments rests solely with the user. If you choose to proceed with this approach, comprehensive security, performance, and stress testing are absolutely essential. Rigorous testing will help ensure the stability and reliability of your DHIS2 application in a production setting.

For those interested in exploring DHIS2 with Docker, the following link provides information on running DHIS2 in a Docker container:

[ Running DHIS2 on Docker ](https://github.com/dhis2/dhis2-core/blob/master/docker/DOCKERHUB.md)

### Running DHIS2 on Kubernetes

#### Leveraging Kubernetes for DHIS2 Deployment

Kubernetes, a leading open-source container orchestration platform, offers a compelling approach to automate the deployment, scaling, and management of containerized applications.

> **NOTE**
>
> Kubernetes would still require dhis2 docker images and thus reservations made above regarding Limited Production Use Cases still holds.

#### Container Image Selection:

While Kubernetes is agnostic to the container image format, successful DHIS2 deployment relies on readily available container images. Currently, available Docker images for DHIS2 are primarily intended for development environments. These images may not have undergone rigorous testing for production workloads, potentially impacting stability and performance.
