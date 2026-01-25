# Installation

This section contains information related to the installation, management and maintenance of DHIS2 systems. It provides information on how to install DHIS2 in various contexts, including online central server, offline local network or standalone application.

## Introduction { #install_introduction }

---

DHIS2 runs on all platforms for which there exists a Java JRE, which includes most popular operating systems such as Linux, Windows and Mac. DHIS2 is packaged as a standard Java Web Archive (WAR-file) and thus runs on any Servlet containers such as Tomcat and Jetty. Its writes its data to a PostgreSQL database. Its recommended that you run it on a Supported Ubuntu LTS system,

This chapter provides a guide for setting up the above technology stack. It should however be read as a guide for getting up and running and not as an exhaustive documentation for the mentioned environment. We refer to the official Ubuntu, PostgreSQL and Tomcat documentation for in-depth reading.

## Server specifications { #install_server_specifications }

---

DHIS2 is a database-intensive application that scales linearly with RAM and CPU resources. These recommendations should be considered starting points - more resources will improve performance.

### Hardware Requirements by Instance Size

| Component | Small Instance | Medium Instance | Large Instance |
|-----------|----------------|-----------------|----------------|
| **RAM** | 8 GB minimum | 16 GB | 64 GB or more |
| **CPU Cores** | 4 cores | 8 cores | 16+ cores |
| **Disk Type** | SSD required | SSD required | SSD required |
| **Storage** | 100 GB+ | 200 GB+ | 500 GB+ |

### Storage Performance Requirements

**SSD is mandatory for production deployments.** Here are the recommended read speeds:

- **Minimum**: 150 Mb/s
- **Good**: 200 Mb/s
- **Ideal**: 350 Mb/s or better

> **Important**
>
> Storage requirements depend heavily on your data volume. Analytics tables require significant space. Plan for expandable storage to accommodate growth.

#### Testing Disk Performance on Linux

You can benchmark your disk performance using these commands:

```bash
# Test disk latency
dd if=/dev/zero of=/tmp/test2.img bs=512 count=1000 oflag=dsync

# Test disk throughput
dd if=/dev/zero of=/tmp/test1.img bs=1G count=1 oflag=dsync

# Clean up test files
rm -v -i /tmp/test1.img /tmp/test2.img
```

## Software requirements { #install_software_requirements }

---

### Core Components

DHIS2 requires the following software stack:

| Component | Version | Notes |
|-----------|---------|-------|
| **Operating System** | Ubuntu LTS (recommended) | Any OS with Java JRE support |
| **Java JDK** | OpenJDK 8, 11, or 17 | Version depends on DHIS2 version (see table below) |
| **PostgreSQL** | 13+ (16 recommended) | Primary database |
| **PostGIS** | 2.2+ (3 recommended) | PostgreSQL spatial extension |
| **Tomcat** | 8.5.50+ or 9+ | Servlet container |
| **Redis** | 4+ | Optional: For cluster setups only |

### DHIS2 Version Compatibility Matrix

Table: DHIS2 version requirements

| **DHIS2 Version** | **JRE (Recommended)** | **JRE (Minimum)** | **Tomcat** | **Ubuntu LTS** |
|-------------------|-----------------------|-------------------|------------|----------------|
| 2.42              | 17                    | 17                | 10         | 24.04          |
| 2.41              | 17                    | 17                | 9          | 22.04          |
| 2.40              | 17                    | 11                | 9          | 22.04          |
| 2.38              | 11                    | 11                | 9          | 22.04          |
| 2.35              | 11                    | 8                 | 9          | 22.04          |
| Pre-2.35          | 8                     | 8                 | 9          | 22.04          |

### Minimal vs Production Setup

**Minimal setup** (development/testing):
- Tomcat server with DHIS2 WAR file
- PostgreSQL database

**Production setup** requires additional considerations:
- Monitoring and alerting systems
- Backup and disaster recovery
- Security hardening
- Performance optimization
- Scalability planning

> **NOTE**
>
> For production deployments, refer to the [Deployment options](#install_install_approaches) section below for automated and manual installation guidance.

## Deployment options { #install_install_approaches }

---

Choose the deployment method that best fits your environment and requirements. Each option is designed for specific use cases, from production-ready automated installations to development and testing environments.

---

### Automated Installation with Ansible

**Recommended for production deployments**

Ansible-based automation framework for secure, consistent DHIS2 deployments on Ubuntu Linux servers.

**What you get:**

- Automated setup of PostgreSQL, DHIS2, and web proxy (Nginx/Apache2)
- Built-in security hardening and SSL/TLS certificate management
- Application performance monitoring (Glowroot) and server monitoring (Munin)
- Support for single-server or distributed multi-server architectures
- Multi-instance management capabilities

**Ideal for:**

- Production environments
- Organizations deploying multiple DHIS2 instances
- Teams requiring consistent, repeatable deployments

[Get Started](#getting_started_linux_automated_install){ .md-button }
[View on GitHub](https://github.com/dhis2/dhis2-server-tools){ .md-button }
[Watch Video Tutorial](https://www.youtube.com/watch?v=fh3E-VY4LoY){ .md-button }

---

### Manual Installation

**For learning and customization**

Step-by-step manual installation providing complete control over the deployment process on Ubuntu 22.04.

**What you get:**

- Deep understanding of DHIS2 component interactions
- Full control over every configuration aspect
- Valuable troubleshooting knowledge
- Flexibility for specialized requirements

**Ideal for:**

- Development and testing environments
- Learning DHIS2 infrastructure
- Custom deployment scenarios

[Get Started](#getting_started_linux_manual_install){ .md-button }

> **NOTE**
>
> For production environments, we highly recommend the automated installation approach for consistency, security, and ease of management.

---

### Docker Deployment

**Container-based infrastructure**

An ongoing project is actively developing a production-ready Docker deployment solution for DHIS2. This project is currently being tested and shows promise as a recommended approach for deploying DHIS2 in production environments.

The solution provides comprehensive Docker Compose orchestration for DHIS2 with PostgreSQL, Traefik proxy, and monitoring tools.

**What you get:**

- Complete infrastructure orchestration with automatic SSL/TLS via Let's Encrypt
- Optional monitoring stack: Grafana, Prometheus, Loki
- Built-in backup and restore capabilities
- Make-based automation for common tasks

**Status:** Ready for public testing. NOT yet recommended for production or critical data.

**Ideal for:**

- Local development and testing
- Proof-of-concept deployments
- Organizations familiar with Docker infrastructure

[Get Started](https://github.com/dhis2/docker-deployment){ .md-button }
[Docker Images](https://hub.docker.com/r/dhis2/core/tags){ .md-button }

---

### Kubernetes Deployment

**High availability container orchestration**

Kubernetes is a container orchestration platform designed for high availability deployments. It automates the deployment, scaling, and management of containerized applications across a cluster of machines. Kubernetes clusters can be deployed on-premise or consumed as a managed service from cloud providers (e.g., Amazon EKS, Google GKE, Azure AKS).

It is possible to run containerized DHIS2 in a Kubernetes cluster environment, including horizontally scaled setups where multiple DHIS2 instances connect to a single database. However, this type of clustered DHIS2 deployment is still experimental and not commonly used in production environments.

**Advantages of Kubernetes:**

- Auto-scaling based on demand
- Self-healing capabilities (automatic container restarts)
- Load balancing across multiple instances
- Rolling updates with zero downtime

**Important considerations:**

- There is limited real-world production experience running DHIS2 on Kubernetes, which means less community knowledge to draw from
- Setting up and managing Kubernetes environments requires specialized expertise
- If pursuing a Kubernetes deployment, you must also factor in critical operational aspects such as:
    - Backup and disaster recovery strategies
    - Monitoring and alerting infrastructure
    - DHIS2 horizontal scaling configuration (if using multiple instances)

> **NOTE**
>
> Kubernetes deployments for DHIS2 are considered experimental. If you are confident in your Kubernetes expertise and operational capabilities, this can be a viable option, but be prepared to pioneer some aspects of the setup.
