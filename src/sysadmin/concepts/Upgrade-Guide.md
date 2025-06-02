# DHIS2 Upgrade Guide for System Administrators

## Introduction

This document serves as a comprehensive guide outlining the process of upgrading DHIS2. It is designed to facilitate the smooth transition from one version to another by breaking down the upgrade process into manageable action items. Additionally, it provides detailed considerations for crucial aspects such as backups to ensure no essential steps are overlooked.

Although upgrading DHIS2 may seem straightforward, it is actually a complex process requiring careful planning and execution. While automation tools like `apt` can streamline some parts of the upgrade, managing dependencies and resolving issues ultimately remains the user’s responsibility. Therefore, it is imperative to anticipate and prepare for potential challenges during the upgrade process.

The manual nature of both DHIS2 installation and upgrade underscores the importance of having a well-defined strategy in place. Thorough preparation and strategic planning are essential to increase the likelihood of a successful upgrade. This includes identifying potential risks and developing strategies to mitigate them effectively. By following this general guide and implementing best practices, organizations can minimize disruptions and ensure a smooth transition to the latest version of DHIS2.

### Who is this document for?

- This document is primarily intended for system administrators and anyone managing an outdated DHIS2 instance planning an upgrade.
- While DHIS2 is an open-source application that anyone can install and deploy, performing upgrades requires basic Linux skills. System administrators are typically responsible for server and application maintenance and usually lead the upgrade process. This document serves as a high-level guide to help plan upgrades effectively, acknowledging that the upgrade process remains manual despite regular new DHIS2 releases.

### Why do we need to upgrade?

Regular software updates are essential, particularly since only three major DHIS2 releases are actively supported. Key reasons for upgrading include:

- Maintaining support for your DHIS2 version
- Receiving the latest security patches and updates
- Benefiting from bug fixes and performance improvements
- Accessing new features
- Meeting required dependencies

Upgrading DHIS2 is a hands-on task that requires careful planning and a solid understanding of dependencies. While upgrading to the latest version may seem appealing, new releases can sometimes introduce regressions or breaking changes. This emphasizes the importance of developing a comprehensive upgrade plan.

### Types of Upgrade

DHIS2 upgrades encompass various components since it is not standalone software. The system depends on several components such as Java, Tomcat, PostgreSQL, and the operating system. Here are the main types of upgrades:

1. **Operating System Upgrade**:
    - Upgrade the operating system first, ensuring DHIS2 remains unchanged during this process.
    - Verify system stability.
    - Proceed with application upgrades.

2. **Database Upgrade**:
    - Database systems like PostgreSQL have specific support lifecycles, typically supporting only the latest five major releases.
    - PostgreSQL upgrades through package managers are generally straightforward but can introduce changes affecting DHIS2 functionality.

3. **Dependency Upgrades**:
    - Supporting software components require regular updates for security and compatibility. On Linux systems, package managers like `apt` and `yum` can help manage these upgrades. Always review dependency requirements before proceeding with updates.

4. **DHIS2 Application Upgrade**:
    - **Major Upgrade**: Involves significant changes between versions (e.g., 2.38 to 2.39, or v41 to v42), including database schema changes and new features.
    - **Minor Upgrade**: Includes incremental improvements and bug fixes with minimal risk.
    - **Hot-fix**: Addresses critical issues and can be safely applied to systems running the preceding patch update.

> **Note**
>
> Recent DHIS2 documentation has replaced the `2.` prefix with `v` (version). The version format follows:
> `<major>.<patch>.<hotfix>`
> *This corresponds to traditional semantic versioning (`<major>.<minor>.<patch>`)*

### Developing an Upgrade Plan

While this guide provides comprehensive upgrade steps, you should customize it for your specific needs. Before beginning, visualize and document your entire upgrade process—this becomes your upgrade plan. Although this guide aims to cover all upgrade requirements, different setups demand different approaches. For instance, you might be running DHIS2 on Windows, or you might have a significantly outdated database that requires upgrading first. Review the upgrade notes while keeping in mind their general nature.

When beginning the actual upgrade, develop a specific plan tailored to your situation. Planning is crucial for success as it breaks down the large task into smaller, manageable actions. This clear perspective makes tackling individual tasks much easier.

#### Scope of the upgrade

Understand that upgrading involves more than just the DHIS2 system. The base operating system, PostgreSQL database, and other dependencies also require updates. A clear understanding of the upgrade scope is essential for success.

#### Review release and upgrade notes

Gather required information from the release and upgrade notes, as they contain important precautions to take before proceeding. Understand the requirements, particularly regarding dependency and software version requirements.

#### Hardware resource requirements

Before proceeding with the upgrade, allocate a budget for necessary test resources. Testing your upgrade process before implementing it in production is essential. Your infrastructure should have:

- Strong network connectivity: For distributed environments, connections should operate on 1Gbps links.
- High-performance storage: DHIS2's PostgreSQL database is I/O intensive and requires fast disks, preferably SSDs.

#### Upgrade Schedule

- **Best timing:** Friday or Monday?
    - Ensure all necessary personnel are available.
    - Align with the DHIS2 release schedule.

- **Scheduling and Planning**:
    - Timelines: Schedule tasks with clear timelines.
    - Feasibility: Ensure the plan is realistic, considering resources, constraints, and challenges.

- **Team Coordination**:
    - Roles and Responsibilities: Understand who is responsible for what.
    - Collaborative process: Know your team.

- **Continuous Monitoring and Evaluation**:
    - Flexibility: Regularly review and adjust the plan as needed.

- **Resource Planning**:
    - Testing Environment: Plan for test bed resource requirements.
    - Training: Include a training phase for the team.
    - Changeover Phase: Optimal timing (e.g., Monday morning or Friday evening) and consider weekend work compensation.

- **Risk Management and Contingency Plans**:
    - Risk Management: Identify and mitigate potential risks.
    - Backups: Plan for backups with adequate storage, including off-site backups.

- **Action Points**:
  - Detailed Breakdown: Break the plan into actionable steps.

- **Post-Upgrade Activities**:
    - Post-Upgrade: Plan for post-upgrade activities such as system monitoring, evaluating performance, and resolving any issues.

### Who needs to be involved

- **System Administrator** - Responsible for server management, performing upgrades, and handling server-related tasks.
- **DHIS2 Users** - These can be developers/implementers, those doing data capture, and those consuming reports generated.
- **Network Team** - In some organizations, a distinct and autonomous network team may be needed to assist in configuring and securing the network, including firewall configurations.
- **Infrastructure Team** - Responsible for creating virtual resources (e.g., virtual machines, storage pools). They usually provide the required test environment.
- **DNS Administrator**
- **Stakeholders/Management**:
    - System owners (e.g., government entities)
    - Funders
    - Managers

### Post Upgrade

- Establish testing and feedback channels.
- Implement system monitoring and evaluation.
- Perform necessary optimizations.
- Configure backup procedures.

## Detailed Considerations

### Backups

Maintaining comprehensive backups is crucial for recovering from potential upgrade issues. Numerous problems can arise during the process, making backups essential. If the system fails to work as expected after an upgrade, restoring from backups is often the best option.

Ideally, a complete system snapshot is desirable. However, if this is not feasible, having a database backup is sufficient. Data is of immense value, and maintaining regular database backups is essential both during upgrades and as a standard practice to ensure data continuity.

There are several methods to perform database backups, with the `pg_dump` utility being one of the most commonly used.

#### Types of Backups

- Full OS backup, snapshot
- Database backup
- Local backups
- Remote backups
- Cloud Backup
- Application backup

#### What do you need to backup?

- Databases
- DHIS2 filestore
- `dhis.conf` file (sometimes it has database encryption passwords)
- Application static files (e.g., custom logos)
- `dhis2.war` file (especially if customized)
- Make backup notes (e.g., DHIS2 version information, PostgreSQL version, proxy version)

#### Backup Tips:

- Ensure sufficient disk storage for storing local backups (`df -h` to check available disk space).
- Ensure a remote location for storing backups (object storage endpoint, NAS, backup server).
- Consider versioned backups to restore to a specific point in time.
- Encrypt backups to secure your data, especially sensitive information.
- Document restore procedures and keep them in an accessible location.
- Utilize cloud-based backup solutions for scalability, redundancy, and ease of access.
- If supported, use snapshot backups to create point-in-time copies of your data and systems.
- Compress backups to reduce storage requirements and speed up processes.

#### Restore Tips:

- Regularly test backup restoration, note the restoration time, and ensure functionality.
- Validate the integrity and functionality of data and applications post-restore.

### Assessing Server Requirements for Upgrade

Server requirements are typically influenced by factors like database size, anticipated growth, and the number of expected users. Regular monitoring of resource utilization using tools like Zabbix and Munin provides insights for scaling needs. Cloud-deployed servers offer easy scalability.

- **RAM:** At least 4 GB for a small instance, 12 GB for a medium instance, 64 GB or more for a large instance.
- **CPU Cores:** 4 CPU cores for a small instance, 8 CPU cores or more for medium and large instances.
- **Disk:** SSD is recommended with a minimum read speed of 150 Mb/s, 200 Mb/s is good, and 350 Mb/s or better is ideal. At least 100 GB of disk space is recommended, though actual requirements depend on the amount of data. Analytics tables require a significant amount of disk space. Plan and ensure your server can be upgraded with more disk space.

### Software Requirements for the New Version

Newer DHIS2 versions require the following software versions:

1. An operating system compatible with Java JDK or JRE version 8 or 11. Linux is recommended.
2. Java JDK (OpenJDK is recommended).
    - DHIS2 version 2.38 and later: JDK 11 is required.
    - DHIS2 version 2.35 and later: JDK 11 is recommended; JDK 8 or later is required.
    - DHIS2 versions older than 2.35: JDK 8 is required.
    - DHIS2 versions 2.41 and later: JDK 17 is required.
3. PostgreSQL database version 9.6 or later. Version 13 is recommended.
4. PostGIS database extension version 2.2 or later.
5. Tomcat servlet container version 8.5.50 or later, or any Servlet API 3.1 compliant container.

### What if you also need to upgrade other components like the OS and database?

If you need to upgrade the base OS and other components, the recommended approach is to set up a new environment with the required OS version and databases.

### How do you assess the existing metadata?

One common cause of upgrade failure is that anomalies in the existing metadata might be "acceptable" on the current version but cause errors in the new version. Taking the opportunity of an upgrade to do a cleanup of your metadata is useful and helps avoid problems.

- Run metadata assessment scripts on the test instance (before upgrading): [Metadata Assessment](https://github.com/dhis2/metadata-assessment).
- Fix as many issues as possible.

### How do you test?

- Make a checklist.
- Involve users in the testing process.
- Identify errors in log files.
- Measure performance before and after the upgrade.

## Upgrading DHIS2 (Short version)

| Step  | Task | Description | Status |
|---|-----|--------|---|
| 1  | Getting Started | Identification of all national systems and critical custom applications, versions for the different instances: <br><br>- Custom applications<br>- Software versions (Java, Tomcat, DHIS2, PostgreSQL, nginx/apache2 proxy, etc.)<br>- Resources - Test server availability.<br>- Scope - Does it include OS and the database? | Pending<br>- Ongoing<br>- Completed |
| 2  | Backup Current System | Identify backup environment and required specifications. Perform backups for at least the following: <br><br>- DHIS2 database<br>- Configuration files<br>- Custom apps<br>- External integrations<br><br>Backup documentation<br>- Note the time taken for backup dumps | - Pending<br>- Ongoing<br>- Completed |
| 3  | Review DHIS2 Release Notes | Review the release notes of the new version to understand: <br><br>- New features<br>- Fixes<br>- Potential breaking changes | |
| 4  | Set Up Staging Environment | Replicate the production setup in a environment. Create test cases and test the environment on the staging setup: <br><br>- Keep versions as they are on prod<br>- Restore the prod database; note the restore time<br>- Ensure staging works as expected | |
| 5  | Test Upgrade on Staging | Execute the upgrade on the staging environment to identify and address any issues or conflicts before implementing in production: <br><br>- Involve users during testing<br>- Perform metadata cleanup using the tool [here](https://github.com/dhis2/metadata-assessment)<br>- Implement test cases created<br>- Validate applications and functionalities<br>- Resolve identified issues | |
| 6  | Notify Stakeholders | Inform all DHIS2 users about the planned upgrade and expected downtime to ensure preparedness. | |
| 7  | Create Roll-back Plan | Backup the DHIS2 instance (both application and database) as a rollback strategy in case of any issues during the upgrade. | |
| 8  | Upgrade Production | Once satisfied with the staging tests, apply the upgrade to the production system. | |
| 9  | Post-Upgrade Testing | Test the main functions in the production environment to ensure everything works correctly. | |
| 10 | Monitor System | Continuously monitor system performance and logs to catch any unexpected issues early. | |
| 11 | Document Process | Document the upgrade process, challenges faced, solutions used, and lessons learned for future reference. | |
| 12 | Gather User Feedback | Collect feedback from DHIS2 users on the performance and features of the new version, as well as any potential issues they face post-upgrade. | |

## The Upgrade Calendar (Example)

| Month | Activity | Resource Implication |
|---|---|---|
| April (pre-release) | Metadata assessment and cleanup<br>Start testing, potentially join the beta testing program | Human resources for metadata cleanup<br>Server resources for testing<br>Sysadmin resources for installation<br>Testing resources |
| May (new release) | Test release<br>Start planning for training, training of trainers, online materials, etc. | Server resources for testing<br>Human resources for training preparation and trainer training |
| June | Training | Sysadmin resources for installation<br>Server resources for training<br>Provision of physical or virtual training events |
| July | Upgrade production | Sysadmin resources for installation |
