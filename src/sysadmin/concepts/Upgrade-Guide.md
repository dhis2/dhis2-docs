# DHIS2 Upgrade Guide for System Administrators

## Introduction

This guide provides a structured approach to upgrading DHIS2 and its dependencies, facilitating a seamless transition between versions.  It outlines actionable steps while emphasizing critical aspects such as comprehensive backups to mitigate the risk of data loss.  Upgrading DHIS2 involves more than simply replacing the WAR file; new releases may require updated dependencies, such as Java or Tomcat.  Given the potential for unforeseen issues, thorough preparation is essential.  By proactively identifying potential risks and developing mitigation strategies, administrators can minimize disruptions and ensure a successful upgrade

## Target Audience

This guide is intended for **System Administrators** responsible for maintaining DHIS2 deployments.  Because DHIS2 supports only the three most recent annual releases, regular upgrades are required.  These upgrades, typically handled by system administrators, necessitate Linux expertise and strong server/application management skills.  The largely manual process requires careful planning, encompassing not only DHIS2 itself but also dependencies like PostgreSQL, Java, Tomcat, and the base operating system.

## Importance of Upgrading

Only the three latest major releases of DHIS2 are supported with maintenance patches and updates. The same is true of its dependencies, such as PostgreSQL, Tomcat, and Nginx, which follow their own independent release and support cycles. While their timelines may vary, outdated versions eventually reach end-of-life, losing official support, security updates, and compatibility with newer DHIS2 releases. To ensure system stability, security, and compatibility, it is crucial to keep both DHIS2 and its dependencies within their supported versions.


### Key Benefits of Upgrading

- Ensure compliance with DHIS2 support policy, which covers only the latest three major releases.
- Apply the latest security patches to protect against vulnerabilities.
- Benefit from recent bug fixes that enhance system stability.
- Improve performance through optimizations introduced in newer versions.
- Gain access to new features and enhancements.
- Maintain compatibility with updated dependencies required by the latest DHIS2 releases.

### Components for Upgrading

The system administrators must take into account the entire system stack when considering DHIS2 upgrades. This consists of:

- **Operating System (OS)** – Most deployments use Ubuntu LTS, which has a five-year support lifecycle. Running DHIS2 on an unsupported OS can lead to compatibility and security issues. It’s best to upgrade the OS first while keeping DHIS2 unchanged, ensuring a stable foundation before updating the application. Supported LTS versions typically include compatible software like PostgreSQL.  

- **Database** – PostgreSQL follows a defined support lifecycle, maintaining only the [latest five major releases](https://www.postgresql.org/support/versioning/). Running a supported version is crucial for security and performance. While upgrading via package managers like `apt` is straightforward, changes in newer versions (such as JIT being enabled by default from PostgreSQL 12) can introduce regressions that may impact performance.

- **Dependencies** – DHIS2 relies on various components like **Tomcat**, **Nginx**, and **PostgreSQL**, all of which require periodic updates. Linux package managers (`apt`, `yum`) simplify dependency upgrades, but it’s essential to review DHIS2’s recommended versions and requirements before proceeding; the system requirements may change with a new DHIS2 version.

- **DHIS2 application upgrade**

  The DHIS2 upgrade itself may also vary in scope, complexity and risk. We can consider three main types of upgrade for the core application:

  - **Major Upgrade** - These involve significant changes and new features, and may break compatibility with older versions. Major upgrades are denoted by changes in the first version number (e.g., from version 2.38 to 2.39, or v41 to v42). They often include changes to the database schema to accommodate new functionality. New versions are release yearly.

  - **Minor Upgrade (patch update)** - This is an upgrade with incremental, and potentially (non-breaking) changes. This upgrade usually come with improvements and bug-fixes. Historically, the DHIS2 team refer to these as patch updates. Patch updates are released every couple of months.

  - **Hot-fix** - These are minimal updates release to solve urgent, critical issues. They can be safely applied to systems already running the proceeding patch update.

> **Note**
>
> The `2.` in the DHIS2 version number has been replaced with `v` (version) in more recent documentation. The remaining numbers are referenced by the core team in the following format:
> `<major>.<patch>.<hotfix>`
> *This is equivalent to a classic semantic versioning, which would usually be referred to as `<major>.<minor>.<patch>`*

## Technical Skills and Roles Required

Managing and upgrading DHIS2 requires coordination among multiple teams and stakeholders, each contributing specific expertise to ensure a smooth transition and system stability. Below is a breakdown of the key roles and their responsibilities.

#### **1. System Administrator**

The system administrator is responsible for:
- Performing DHIS2 upgrades and managing server-related tasks.
- Ensuring the operating system, database, and dependencies are up to date.
- Monitoring server performance and troubleshooting issues.
- Managing backups and disaster recovery plans.

#### **2. DHIS2 Users**

DHIS2 users interact with the system in different capacities, including:
- **Developers/Implementers** – Configuring, customizing, and extending DHIS2 functionality.
- **Data Entry Personnel** – Capturing and validating data within the system.
- **Data Consumers & Analysts** – Generating reports and analyzing data for decision-making.

#### **3. Network Team**

In some organizations, a dedicated network team is responsible for:
- Configuring and maintaining network security, including firewall rules.
- Ensuring secure access to DHIS2 servers and databases.
- Troubleshooting connectivity issues that may affect system access.

#### **4. Infrastructure Team**

The infrastructure team handles:
- Provisioning and managing virtual machines, storage pools, and cloud resources.
- Setting up a test environment for pre-upgrade validations.
- Ensuring high availability and system redundancy where required.

#### **5. DNS Administrator**

A designated person or team is responsible for:
- Managing domain name resolution to ensure DHIS2 services are accessible.
- Updating DNS records in case of server migrations or IP changes.

#### **6. Key Stakeholders**

Several other roles play an essential part in DHIS2 management and upgrades, including:
- **Management & System Owners (e.g., Government entities)** – Overseeing the system’s operational integrity and compliance.
- **Funders & Donors** – Supporting system sustainability and ensuring necessary resources are available.
- **Project Managers** – Coordinating upgrade timelines and ensuring minimal disruption to users.


## Preparations Before Upgrading

#### **1. Backup Everything**

- **Database Backup**: Use `pg_dump` to create a full backup of your PostgreSQL database, ensure its tested and stored off-site.
- **DHIS2 Files Backup**: Backup the DHIS2 home directory, configuration files, and any custom scripts.
- **Server Snapshot**: If running on a virtualized or cloud environment, take a full system snapshot for quick rollback if needed.

#### **2. Review Compatibility and System Requirements**

- Check DHIS2’s [release notes](https://dhis2.org) for version-specific requirements.
- Ensure the operating system, PostgreSQL, Java (jre), Tomcat, and other dependencies meet the new version’s requirements.

#### **3. Test in a Staging Environment**

- Deploy the new version in a test environment before upgrading production.
- Verify data integrity and application functionality.

#### **4. Review Custom Configurations and Extensions**

- Check if any custom apps, scripts, or configurations need modifications for compatibility.
- Ensure any third-party integrations will work with the new version.

#### **5. Inform Stakeholders and Plan Downtime**

- Notify users about potential downtime and expected changes.
- Schedule the upgrade during off-peak hours to minimize disruptions.

#### **6. Document the Current System**

- Record current DHIS2, PostgreSQL, Tomcat, and OS versions.
- Take note of configurations in `dhis.conf` and `server.xml`.

#### **7. Prepare a Rollback Plan**

- Have a tested recovery strategy in case the upgrade fails.
- Ensure backups and snapshots are easily accessible.

### **Post-Upgrade Steps for DHIS2**

After upgrading DHIS2, follow these steps to verify the system's stability, performance, and functionality.

#### **1. Verify the Upgrade**

- Confirm the DHIS2 version using the **About DHIS2** page (`/dhis-web-dashboard` → Help → About DHIS2).
- Check the server logs (`catalina.out` for Tomcat, DHIS2 logs) for any errors or warnings.
- Verify the database migration logs to ensure all schema updates were applied.

#### **2. Test Core Functionality**

- Log in and confirm that user authentication works as expected.
- Open dashboards, data entry forms, analytics tools, and reports.
- Run key analytics tasks (`analyticsTableUpdate`) and confirm expected outputs.

#### **3. Validate Data Integrity**

- Run the **Data Integrity Check** under **Maintenance App** to identify inconsistencies.
- Check that all tracked entities, programs, and data elements are properly loaded.

#### **4. Monitor Performance and Resource Usage**

- Use `htop`, `top`, or **server monitoring tools** e.g Munin Zabbix to check CPU, RAM, and disk usage.
- Review PostgreSQL performance (`pg_stat_activity`, `EXPLAIN ANALYZE` for slow queries).
- Monitor system logs for memory leaks, slow queries, or other potential bottlenecks.

#### **5. Update and Optimize Configurations**

- Review `dhis.conf` and `server.xml` settings to ensure they are optimized for the new version.
- Check PostgreSQL settings (e.g., `work_mem`, `shared_buffers`, `max_connections`) for performance improvements.
- If using caching (Redis, Nginx), ensure they are functioning correctly.

#### **6. Test Integrations and External Services**

- If DHIS2 is integrated with external systems (e.g., third-party APIs, data pipelines), confirm that they are still functioning correctly.
- Validate scheduled jobs and scripts (e.g., data sync, backups, notifications).

#### **7. Inform Users and Provide Support**

- Notify users that the upgrade is complete and share any relevant changes or new features.
- Provide training or documentation if needed.
- Encourage users to report any issues they encounter.

#### **8. Perform a Final Backup**

- Once confirmed stable, create a full **post-upgrade backup** of the database and configuration files.
- Store it securely as a restore point in case of future issues.


## Detailed considerations

### Analyze Scope of the upgrade

Consider all system components that may need updating, such as the operating system, PostgreSQL database, and other dependencies. If multiple components need upgrading (e.g., operating system, PostgreSQL), tackle each one separately, starting with the operating system. Upgrading the base OS often includes updated software like Tomcat and PostgreSQL.

For OS upgrades, building a new server with the target OS and migrating DHIS2 is strongly recommended over in-place upgrades. This minimizes risk and provides a cleaner, more predictable upgrade path.  Ensure the new OS's default Tomcat, JRE, and PostgreSQL versions are compatible with the target DHIS2 version.

For more details on version lifecycles and support timelines for other dependencies refer to:
- [Ubuntu Suppport Lifecycle](https://ubuntu.com/about/release-cycle)
- [PostgreSQL Support and Release Schedule](https://www.postgresql.org/support/versioning/)
- [Tomcat Release and Support Schedule](https://tomcat.apache.org/whichversion.html)


### Backups

A robust fallback plan, including comprehensive backups, is crucial for any DHIS2 upgrade.  Issues can arise, and restoring to the previous state is often the fastest recovery.  While a full system snapshot is ideal, database backups are essential at a minimum.  Regular database backups are also crucial for ongoing data continuity. For OS upgrades, build a new server with the target OS and migrate DHIS2, rather than performing an in-place upgrade.  Ensure compatibility between the new OS's default Tomcat, JRE, and PostgreSQL versions and the target DHIS2 version.

There are several methods to perform database backups, with the `pg_dump` utility being one of the most commonly used for logical backups.

#### Backup strategies

- **Full OS Backup/Snapshot:** A complete snapshot of the server's file system and configuration. This allows for a rapid rollback to the previous state.
- **Database backup**
  - **Logical Backup:** (e.g., `pg_dump`): A portable copy of the database schema and data. This is the primary backup for restoring the database to a specific point in time.
  - **Incremental Backup:**  Backs up only the changes since the last full or incremental backup. These are smaller and faster than full backups, but require a full backup as a base. They are useful for more granular recovery and minimizing backup windows.

#### Backup storage strategy
- **Local Backups:** Storing backups on the same machine as the DHIS2 instance is not recommended for disaster recovery, as it exposes the backups to the same risks as the primary system (e.g., disk crashes, server failures). However, having a local backup can be useful during maintenance or upgrades. For added reliability, consider pushing your local backups to a network-attached storage (NAS) device.
- **Off-site Storage:** Backups should be stored separately from the primary server. This can include solutions like object storage services (e.g., AWS S3, Google Cloud Storage, Azure Blob Storage), dedicated backup servers, or other geographically distinct locations.  Off-site storage protects against site-wide disasters.
- **Cloud Backups:** Cloud providers offer various backup services, including managed backup solutions and storage options suitable for backups.  These services often provide features like encryption, versioning, and automated backup schedules. If you are already in cloud, consider cloud backups as part of a comprehensive backup strategy.


#### Important items to back up before an upgrade.

- *Databases* - All dhis2 database backup, created with `pg_dump`
- dhis.conf, and sometimes it has database encryption password
- application static files e.g custom logos etc
- dhis2.war file, -- especially if its been majorly customized, ensure you have its backup. Also, take note of its version information.
- Make backups notes.
    - version for dhis2 postgresql, proxy and other important dependencies
    - time it takes to create backups dumps - good for planning on downtimes.

#### Backup Tips:

- Ensure you have enough disk storage for storing local backups.  
  use `df -h` command to check available disk space on your server.
- Ensure you have remote location for storing your backups. It can be and object storage end point, Network Attached Storage (NAS), some backup server with sufficient storage,
- **Versioning** - Consider using versioned backups, which allow you to restore to a specific point in time, not just the latest backup.
- **Encryption:** Encrypt your backups to secure your data, especially if it contains sensitive information
- **Documentation:** Document your restore procedures and keep them in an easily accessible location. This can save valuable time during a crisis.
- **Cloud Backups:** Utilize cloud-based backup solutions for scalability, redundancy, and ease of access.
- **Snapshot Backups:** If your infrastructure supports it, use snapshot backups to create point-in-time copies of your data and systems.
- **Compression:* Compress your backups to reduce storage requirements and speed up backup and restore processes.

#### Backup Restore Tips:

- Perform a Dry Run – Before restoring on a production system, test the process in a safe environment.
- Test Restores: - Regularly be testing your backup restoration, take note of how long it takes, and ensure it works as expected. A backup is only valuable if you can restore from it.
- Validation: Even after restore, validate that your data is intact, and applications are functioning as expected.
- Check File Permissions – After restoration, verify file ownership and permissions to prevent access issues.
- Match Software Versions – Ensure the OS, database, and application versions align with the backup to avoid compatibility issues.

### Assessing Server resouces before upgrading

#### Hardware resource requirements
The server size, including RAM and CPU, depends on various factors such as the database size, anticipated growth, and the number of users. Regular monitoring of resource utilization through tools like Zabbix and Munin can help determine your system's needs. Cloud-hosted servers benefit from easy scalability. In many regions with data centers, minimum resource requirements are often specified for operating an empty database.

Ensure that you have a test server, ideally with the same specifications as the production instance. Your production server should also have adequate storage space for backup requirements before the upgrade.

For successful upgrade preparation, plan for test resources in advance. Your infrastructure should meet these requirements:

- Fast Storage: DHIS2's PostgreSQL database is I/O intensive and requires fast disks (SSD). Backup storage can use slower, more cost-effective disks.
- Good Network: Ensure a fast network (preferably 1Gbps) for distributed environments and off-site backups, to avoid delays during backup transfers.


### Assess Software requirements for the new version

Check DHIS2 release notes, and note the following requrements
1. JRE requred/Recommended
2. PostgreSQL required/Recommended
3. PostGIS version requred/Recommend
4. Tomcate Version Requred/Recommended

Note that dhis2 can run on the requred dependecy version, nevertheless, you better run on the recommended version.

### Assess whether other dependencies needs upgrading,
Ensure
- Base operating system is still supported, if its out of support, more often than not, other software in it, like postgresql, nginx, and Tomcat would be outdated.
- PostgreSQL release lifecycle
- Tomcat Support lifecycle


If you need to upgrade base OS, and other components, the recommended approach is to setup a new environment, with the required OS version and databases for example,

### How do you assess the existing metadata

One of the most common causes of upgrade failure is that anomalies in the existing metadata might be “acceptable” on the existing version but cause errors on the new version. Taking the opportunity of the upgrade to do a cleanup of your metadata is a useful thing to do and also helps you avoid problems with the upgrade.

- Run the metadata assessment scripts on the test instance (before upgrading)

  [https://github.com/dhis2/metadata-assessment](https://github.com/dhis2/metadata-assessment)

- Fix as much as you can fix

### How do you test

- Make a checklist
- Involve users
- Identifying errors in log files
- Performance measures

## Upgrading DHIS2 (Short version)

| Step  | Task| Description | Status |
|---|-----|--------|---|
| 1  | Getting Started|Identification of all National systems and critical custom applications, Versions for the different instances <br><br>- Custom Applications<br>- Software versions (java,tomcat, dhis2,PostgreSQL, nginx/apache2 proxy etc )<br>- Resources - Test server availability. <br>- Scope - Does it include OS and the database?|- Pending<br>- ongoing<br>- completed |
| 2  | Backup Current System | Identify backup Environment and required specification. Do backups for at least below items:<br><br>- DHIS2 database, <br>	- configuration files, <br>	- custom apps, <br>	- any external integration.<br><br>Backup documentation <br> - Take note of the time for backups dumps  |- Pending<br>- ongoing<br>- completed <br>	 |
| 3  | Review DHIS2 Release Notes  | Go through the release notes of the new version to understand:<br><br>- new features,<br>- fixes<br>- potential breaking changes.| |
| 4  | Set Up Staging Environment  | Replicate the production setup in a staging environment. Create test cases and test environment on the staging. <br><br>This will be used to test the upgrade before it's applied to production.<br><br>- Keep versions as is on prod, <br>- Restore prod database, take note of the time for restore<br>- Ensure staging works as prod | |
| 5  | Test Upgrade on Staging  | Implement the upgrade on the staging environment to identify any issues or conflicts.<br><br>Involve users during testing process<br><br>- Perform Metadata Cleanup using the tool [here](https://github.com/dhis2/metadata-assessment)<br>- implement test cases created<br>- Test and validate applications and functionalities<br>- Fixing of issues identified||
| 6  | Notify Stakeholders| Inform all DHIS2 users about the planned upgrade and expected downtime. This ensures all users are prepared for the outage.| |
| 7  | Create  roll-back Plan| Backup up the DHIS2 instance (both application and database) as a rollback strategy in case of any total data loss or considerable loss in functionality | |
| 8  | Upgrade Production | Once satisfied with the staging tests, apply the upgrade to the production system.  | |
| 9  | Post-Upgrade Testing  | Test the main functions in the production environment to ensure everything is working correctly after the upgrade.| |
| 19 | Monitor System  | Continuously monitor system performance and logs to catch any unexpected issues early. | |
| 11 | Document Process| Document the upgrade process, any challenges faced, solutions used, and lessons learned for future reference.  | |
| 12 | Gather User Feedback  | Collect feedback from DHIS2 users on the new version's performance, features, and any potential issues they're facing post-upgrade. | |


## The Upgrade calendar (example)
New DHIS2 version is generally released around May, you

|Month|Activity|Resource implication|
|--- |--- |--- |
|April (pre-release)|Metadata assessment and cleanup<br>Start testing, potentially join beta testing program|Human resource for metadata cleanup<br><br>Server resource for testing<br><br>Sysadmin resource for installation<br>Human resources for testing.|
|May (new release)|Test release<br>Start planning for training, training of trainers, online materials, etc.|Server resource for testing<br><br>Human resource for training preparation and training of TOT|
|June|Training|Sysadmin resource for installatio <br><br>Server resource for training <br><br>Provision of physical or virtual training events|
|July|Upgrade production|Sysadmin resource for installation|
