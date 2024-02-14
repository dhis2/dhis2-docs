# DHIS2  upgrade guide
## Introduction
This document serves as a comprehensive guide outlining the process of upgrading DHIS2. It is designed to facilitate the smooth transition from one version to another by breaking down the upgrade process into manageable action items. Additionally, it provides detailed considerations for crucial aspects such as backups, ensuring that no essential steps are overlooked.

While DHIS2 upgrading may appear straightforward on the surface, it is indeed a complex process requiring careful planning and execution. While a simple replacement of the war file with the latest release may seem sufficient, the reality is that unforeseen complications can and do arise. Therefore, it is imperative to anticipate and prepare for potential challenges that may arise during the upgrade process.

The manual nature of both DHIS2 installation and upgrade underscores the importance of having a well-defined strategy in place. While automation tools such as `apt` exist to streamline certain aspects of the upgrade process, the responsibility ultimately lies with the user to manage dependencies and address any issues that may arise.

To increase the likelihood of a successful upgrade, thorough preparation and strategic planning are essential. This includes identifying potential risks and developing strategies to mitigate them effectively. By following this general guide and implementing best practices, organizations can minimize disruptions and ensure a smooth transition to the latest version of DHIS2.


### Who is this document for ?.
- Short answer, Whoever is managing and maintaining DHIS2. In most cases,
   System Administrator, - Generally anyone running a not up-to-date dhis2
   instance, and planning to do an upgrade. <br>
- DHIS2 is an open source application. Anyone can simply install/deploy it and
  implement any project with it, solving whichever needs they have. Obviously,
  to do an upgrade, there are are basics Linux skills you'd would require. Not
  everyone can manage the upgrade. System Admins, in most cases are the ones
  responsible for the server and application maintenance. More often that not,
  they are the ones doing upgrade, at at least leading the process of the
  upgrade. This document is a high level guide helping plan better for the
  upgrade. New dhis2 versions are regularly released, and, but the upgrade
  process is a bit manual.

### Why do we need to upgrade
Or asked differently, are there problems running outdated software ?. There
surely are lots of problems with outdated software. Only 3 dhis2 major releases
are supported, you want to always run actively supported version. Some of the
reasons listed below. 

   - to be withing supported verssg  of dhis2, usually the latest three versions. 
   - to get latest security fixes
   - to get latest bug fixes
   - latest version might be having performance improvement
   - new features could be shipped with the latest releases.  
   - To meet  required dependencies.
   - Unlike other software systems, like Linux OSes, dhis2 upgrade process is not automated, this is an hands on task. You will need to to the upgrade yourself. You will need to plan better, know prior required and recommended dependencies.
   - It it advisable to upgrade to bleeding version ?. Sometimes the upgrades introduces new problems, regressions, breaking changes, issues never envisaged. That is why we develop this plan.

### Types of upgrade
It depends on the scope really, upgrades can have many forms, it can be
categorized into software, hardware, minor, major, dependency upgrades, name
them. DHIS2 is a not stand-alone software, its depends on other libraries and
software to work, Java , Tomcat PostgreSQL, OS, just to name a few. Lets talk
about upgrade types with respect to dhis2 and its dependencies. 

   * Operating system upgrade - We all know that your need a form of an
     Operating System  to run DHIS2. But OSes with time, gets out of date.
     This one type of the upgrade that at some point you'd need to tackle. In
     most of our deployments, we are using Ubuntu. This system has release life
     cycles. LTS releases are have 5year support lifetime. Not supported LTS
     systems runs in most cases unsupported software, take for example Ubuntu
     18.04, the default postgres version is 10, which its last release was,
     November 10, 2022. If you have dhis2 running on old, and no-longer
     supported OS, then you'll have bigger problems to solve. It is recommended
     to deal with one problem at at time, start with upgrading the OS, keep the
     dhis2 system the way it is, while upgrading your base OS. Then after that
     is successful, start working on the app. In most cases, if you are running
     an OS that is still withing LTS bracket, its software like PostgreSQL
     will also be withing supported versions. 

   * Database upgrade - Same as the base OS upgrade, the backend database needs
     to be also upgraded. Its has support life cycle as well, referring to
     [PostgreSQL Versioning](https://www.postgresql.org/support/versioning/)
     for example,it is apparent that postgresql supports only the latest five
	major releases. You always want to be running supported version. Well,
	it is important to note that in most cases, your PostgreSQL database
	install with apt package management tool and its upgrade is pretty
	straight forward, apt deals with dependencies. It try, upgrades have
	many benefits but but can introduce undesired changes as well. An
	example, JIT setting, prior to PostgreSQL 12, this setting was off, any
	server running pg_version  12 onwards have this on by default, and this
	is a regression on how particularly PI related queries are executed in
	the DB. 

   * Dependency Upgrades - As discussed, dhis2 relies on other software to run,
     this software needs to be constantly upgrade for reasons already
     mentioned, lucky enough that can be simple if you are on Linux system, you
     use upgrade management software such as apt and yum. Its also important
     reading more on the dependency requirements/recommendations before doing
     upgrade. 
   * DHIS2 application Upgrade 
      * Major Upgrade - Significant and potentially breaking changes, new features
	 Major upgrades are often denoted by changes in the first version number (e.g., from version 2.38 to 2.39).
	 does changes to the database schema to accommodate new structure. 
      * Minor Upgrade - This is an upgrade with incremental, and potentially non-breaking changes. This upgrade usually come with improvements and bug-fixes
      * Patch upgrades 
      * Hot-fix 

### General guide on developing a good upgrade plan. 
Already, this guide is a plan, but a general one, customize it to suit your
specific needs. Visualize your entire upgrade before doing it, write it down.
That's an upgrade plan. This guide tries to capture all the upgrade
requirements, but we have varying setups, perhaps your are running your dhis2
on Windows, it could be your database is very old, (and in your case your need
to deal with upgrading database first). Read the upgrade notes, and but its
general. When you'll be doing the actual upgrade, you might need create a more
specific plan.   Planning is an important piece for the success of the upgrade
process. It brakes down the "Upgrade Elephant" into smaller executable
actions.Planning lays a clear perspective on what needs to be done.  When you
break down your upgrade task, it becomes easy tackling individual tasks.

#### Scope of the upgrade 
  Understand the scope of work better - Well there are other things that needs upgrading apart from just dhis2 system. There is always the base operating system, and the PostgreSQL database and even other dependencies,  these too get out of date. It is a good idea if you understand the scope of your upgrade. 

####  Read on the release/upgrade notes.
Gather required information from the upgrade/release notes usually have important information on the precautions you'll need
to take before doing the upgrade. Get to know what is required for the
upgrades.   Know more about dependency/software version requirements.  

#### Hardware resource requirements

Before doing the upgrade, you'll need to budget for the test resources.
Ideally, you usually need to test your upgrade before doing actual upgrade.  
Your infrastructure should have -:

  - Good network - You'll need to have a fast networking if you are on a
    distributed environment. Preferably, connectivity should happen on 1Gbps
    links.
  - Fast Storage  - DHIS2, saving data on PostgreSQL database is I/O
    intensive, it needs fast disks, preferably SSD disks.  

#### Upgrade Schedule
When is the best time to do upgrades ?. 

      - Friday, -- Monday ?. 
      - Ensure your have all hands on deck 
      - DHIS2 release schedule
- Your plan should be scheduled - You tasks should have timelines 
- Is your plan Realistic - Is your plan feasible ?. Is it achievable ?. It should take account of the available resources, constraints and potential challenges. 
- Know more on who does what ?. - The upgrade process in most cases is a
  collaborating project. Know your team prior. 
- Continuous Monitoring and Evaluation: - Contently review you plan while executing it, identify issues arising, make necessary changes if need be. Your plan should be flexible. 
- Plan for a test bed resource requirements. 
- training phase
- Change-over phase
    - Eg. Monday morning or a Friday evening? Compensation for working on the weekend
- Risk Management - Identify potential risks, plan on how to mitigate and manage them. 
- Contingency Plans - backups. Plan for backups, Storage is the basic requirement for backup, and an off-site. 
- After having your plan, what need to be done. Break it down to action points. 
- PostUpgrade 


### Who needs to be involved
- System Administrator - This individual handles server tasks, performs
  upgrades, and manages server-related activities.
- DHIS2 users - These are users of the system. They can be
  developers/implementers, those doing datacpture, those consuming reports
  generated etc. 
- Network Team - On certain occasions, there exists a distinct and autonomous
  network team whose support may be required. Typically, they are tasked with
  configuring and securing the network, including firewall configurations.
- infrastructure team- Responsible for creating virtual resources, e.g virtual
  machines, storage pools etc. You'll generally need a test environment, and
  its them going to provide.
- person responsible for the DNS 
- stakeholders, Management. 
      - system owners (the Government for example)
      - funders
      - Managers etc 
   
### Post Upgrade 
- Testing and feedback channels.
- System monitoring and evaluation 
- optimizations, 
- backup configuration


## Detailed considerations
### Backups
You can't talk about upgrading without a fall-back plan. So many things can go
wrong.You need to backups. It happens all the time, you finish upgrading and
nothing works after. You do not even know what went wrong, lets face it. The
only option you have is restoring system as it was before, your rescue is your
backups. Its one of the ways to prepare for unforeseen circumstances. If you
can, backups of everything, a all system snapshot would be the best, but may
not be possible in your case, so having a database backup will suffice. Data is
your currency, you always need to have your database backups, not only during
the upgrade.  Its data that guarantees business continuity in case of
uncertainties. There are various supported methods of doing database backups,
most commonly is with pg_dump utility.  

#### Types of backups
- Full OS backup, snapshot. 
- database backup
- local backups 
- remote backups
- Cloud Backup
- application backup


#### What do your need to backup ?. 
- databases
- dhis.conf, and sometime it has database encryption password
- application static files e.g custom logos etc
- dhis2.war file, -- especially if its been majorly customized, ensure you have its backup. Also, take note of its version information.  
- Make backups notes. 
      - version for dhis2 postgresql, proxy and other important dependencies 
      - time it takes to make backups dumps.

#### Backup Tips:
   - Ensure you have enough disk storage for storing local backups. <br> 
      use  ` df -h`  command to check available disk space on your server.
   - Ensure you have remote location for storing your backups.
     It can be and object storage end point, Network Attached Storage (NAS),
     some backup server with sufficient storage, 
   - Versioning - Consider using versioned backups, which allow you to restore
     to a specific point in time, not just the latest backup.
   - Encryption: Encrypt your backups to secure your data, especially if it
     contains sensitive information
   - Documentation: Document your restore procedures and keep them in an easily
     accessible location. This can save valuable time during a crisis.
   - Cloud Backups: Utilize cloud-based backup solutions for scalability,
     redundancy, and ease of access.
   - Snapshot Backups: If your infrastructure supports it, use snapshot backups
     to create point-in-time copies of your data and systems.
   - Compression: Compress your backups to reduce storage requirements and
     speed up backup and restore processes.

####  Restore Tips:
   * Test Restores: - Regularly be testing your backup restoration, take note
     of how long it takes, and ensure it works as expected. A backup is only
     valuable if you can restore from it. 
   * Validation: Even after restore, validate that your data is intact, and
     applications are functioning as expected. 

### Assessing Server Requirements for upgrade
Typically, the server size is influenced by various factors such as database
size, anticipated growth, and expected user numbers. It is advisable to
regularly monitor resource utilization using tools like Zabbix and Munin to
gauge your system's needs. This monitoring provides insights into resource
requirements. Cloud-deployed servers hold an advantage in easy scalability. In
many countries with data centers, it is common to specify the minimal resources
necessary to operate an empty database.

- _RAM:_ At least 4 GB for a small instance, 12 GB for a medium instance, 64 GB
  or more for a large instance.
- _CPU cores:_ 4 CPU cores for a small instance, 8 CPU cores or more for a
  medium or large instance.
- _Disk:_ SSD is recommended as a storage device. The minimum read speed is 150
  Mb/s, 200 Mb/s is good, and 350 Mb/s or better is ideal. In terms of disk
  space, at least 100 GB is recommended, but it will depend entirely on the
  amount of data which is contained in the data value tables. Analytics tables
  require a significant amount of disk space. Plan and ensure your server can
  be upgraded with more disk space.

### Software requirements for the new version
Later DHIS2 versions require the following software versions to operate.

1. An operating system for which a Java JDK or JRE version 8 or 11 exists.
   Linux is recommended.
2. Java JDK. OpenJDK is recommended.
    1. For DHIS2 version 2.38 and later, JDK 11 is required.
    2. For DHIS2 version 2.35 and later, JDK 11 is recommended and JDK 8 or
       later is required.
    3. For DHIS2 versions older than 2.35, JDK 8 is required.
    4. For DHIS2 Versions 2.41 and later, JDK 17 is required. 
3. PostgreSQL database version 9.6 or later. A later PostgreSQL version such as
   version 13 is recommended.
4. PostGIS database extension version 2.2 or later.
5. Tomcat servlet container version 8.5.50 or later, or other Servlet API 3.1
   compliant servlet containers.

### What if you also need to upgrade other components like the OS and database etc.

If you need to upgrade base OS, and other components, the recommended approach
is to setup a new environment, with the required OS version and databases for
example, 

### How do you assess the existing metadata

One of the most common causes of upgrade failure is that anomalies in the
existing metadata might be “acceptable” on the existing version but cause
errors on the new version.  Taking the opportunity of the upgrade to do a
cleanup of your metadata is a useful thing to do and also helps you avoid
problems with the upgrade.


* Run the metadata assessment scripts on the test instance (before upgrading)

    [https://github.com/dhis2/metadata-assessment](https://github.com/dhis2/metadata-assessment)

* Fix as much as you can fix

### How do you test
* Make a checklist
* Involve users
* Identifying errors in log files
* Performance measures

## Upgrading DHIS2 (Short version)

<table>
  <tr>
   <td style="vertical-align: top; text-align: left;">Step </td>
   <td style="vertical-align: top; text-align: left;">Task </td>
   <td style="vertical-align: top; text-align: left;">Description </td>
   <td style="vertical-align: top; text-align: left;">Status </td>
  </tr>
  <tr>
  <td style="vertical-align: top; text-align: left;">1 </td>
   <td style="vertical-align: top; text-align: left;"> Getting Started </td>
   <td style="vertical-align: top; text-align: left;">
   Identification of all National systems and critical custom applications, Versions for the different instances 
<ul>
<li>Custom Applications
<li>Software versions (java,tomcat, dhis2,PostgreSQL, nginx/apache2 proxy etc )
<li>Resources - Test server availability. 
<li>Scope - Does it include OS and the database ?.
</li> </ul> </td>
<td style="vertical-align: top; text-align: left;">
<ul>
<li>Pending
<li>ongoing
<li>completed 
</li> </ul> </td> </tr>
<tr>
   <td style="vertical-align: top; text-align: left;">2 </td>
   <td style="vertical-align: top; text-align: left;">Backup Current System </td>
   <td style="vertical-align: top; text-align: left;">Identify backup Environment and required specification. Do backups for at least below items:-  
      <ul>
	 <li>DHIS2 database, 
	 <li>configuration files, 
	 <li>custom apps, 
	 <li>any external integration.
      </ul>
      Backup documentation 
      <ul> <li>Take note of the time for backups dumps </li> </ul>
   </td>

   <td style="vertical-align: top; text-align: left;">
      <ul>
	    <li>Pending
	    <li>ongoing
	    <li>completed 
	    </li>
      </ul>
   </td>
</tr>

<tr>
   <td style="vertical-align: top; text-align: left;">3 </td>
   <td style="vertical-align: top; text-align: left;">Review DHIS2 Release Notes </td>
   <td style="vertical-align: top; text-align: left;">Go through the release notes of the new version to understand 
<ul>

<li>new features, 

<li>fixes

<li>potential breaking changes.
</li>
</ul>
   </td>
   <td style="vertical-align: top; text-align: left;"> </td>
  </tr>
  <tr>
   <td style="vertical-align: top; text-align: left;">4 </td>
   <td style="vertical-align: top; text-align: left;">Set Up Staging Environment </td>
   <td style="vertical-align: top; text-align: left;">Replicate the production setup in a staging environment. Create test cases and test environment on the staging. 
<p>
This will be used to test the upgrade before it's applied to production.
<ul>
<li>Keep versions as is on prod, 
<li>restore prod database, take note of the time for restore
<li>Ensure staging works as prod 
</li>
</ul> </td>
   <td style="vertical-align: top; text-align: left;"> </td>
  </tr>
  <tr>
   <td style="vertical-align: top; text-align: left;">5 </td>
   <td style="vertical-align: top; text-align: left;">Test Upgrade on Staging </td>
   <td style="vertical-align: top; text-align: left;">Implement the upgrade on the staging environment to identify any issues or conflicts.
<p>
Involve users during testing process
   <ul>
      <li> Perform Metadata Cleanup using the tool <a href="https://github.com/dhis2/metadata-assessment">here</a>
      <li>implement test cases created
      <li>Test and validate applications and functionalities
      <li>Fixing of issues identified
      </li>
   </ul>
   </td>
   <td style="vertical-align: top; text-align: left;">
   </td>
  </tr>
     <tr>
	 <td style="vertical-align: top; text-align: left;">6 </td>
	 <td style="vertical-align: top; text-align: left;">Notify Stakeholders </td>
	 <td style="vertical-align: top; text-align: left;">Inform all DHIS2 users about the planned upgrade and expected downtime. This ensures all users are prepared for the outage. </td>
	 <td style="vertical-align: top; text-align: left;"> </td>
     </tr>
      <tr>
	 <td style="vertical-align: top; text-align: left;">7 </td>
	 <td style="vertical-align: top; text-align: left;">Create  roll-back Plan </td>
	 <td style="vertical-align: top; text-align: left;">Backup up the DHIS2 instance (both application and database) as a rollback strategy in case of any total data loss or considerable loss in functionality </td>
	 <td style="vertical-align: top; text-align: left;"> </td>
     </tr>
     <tr>
	 <td style="vertical-align: top; text-align: left;">8 </td>
	 <td style="vertical-align: top; text-align: left;">Upgrade Production </td>
	 <td style="vertical-align: top; text-align: left;">Once satisfied with the staging tests, apply the upgrade to the production system. </td>
	 <td style="vertical-align: top; text-align: left;"> </td>
     </tr>
     <tr>
	 <td style="vertical-align: top; text-align: left;">9 </td>
	 <td style="vertical-align: top; text-align: left;">Post-Upgrade Testing </td>
	 <td style="vertical-align: top; text-align: left;">Test the main functions in the production environment to ensure everything is working correctly after the upgrade. </td>
	 <td style="vertical-align: top; text-align: left;"> </td>
     </tr>
     <tr>
	 <td style="vertical-align: top; text-align: left;">19 </td>
	 <td style="vertical-align: top; text-align: left;">Monitor System </td>
	 <td style="vertical-align: top; text-align: left;">Continuously monitor system performance and logs to catch any unexpected issues early. </td>
	 <td style="vertical-align: top; text-align: left;"> </td>
     </tr>
     <tr>
	 <td style="vertical-align: top; text-align: left;">11 </td>
	 <td style="vertical-align: top; text-align: left;">Document Process </td>
	 <td style="vertical-align: top; text-align: left;">Document the upgrade process, any challenges faced, solutions used, and lessons learned for future reference. </td>
	 <td style="vertical-align: top; text-align: left;"> </td>
     </tr>
     <tr>
	 <td style="vertical-align: top; text-align: left;">12 </td>
	 <td style="vertical-align: top; text-align: left;">Gather User Feedback </td>
	 <td style="vertical-align: top; text-align: left;">Collect feedback from DHIS2 users on the new version's performance, features, and any potential issues they're facing post-upgrade. </td>
	 <td style="vertical-align: top; text-align: left;"> </td>
     </tr>
</table>

## The Upgrade calendar (example)
<table>
     <tr>
	 <td style="vertical-align: top; text-align: left;"><strong>Month</strong> </td>
	 <td style="vertical-align: top; text-align: left;"><strong>Activity</strong> </td>
	 <td style="vertical-align: top; text-align: left;"><strong>Resource implication</strong> </td>
     </tr>
  <tr>
      <td style="vertical-align: top; text-align: left;">April (pre-release) </td>
      <td style="vertical-align: top; text-align: left;">Metadata assessment
      and cleanup <p> Start testing, potentially join beta testing program
      </td>
      <td style="vertical-align: top; text-align: left;">Human resource for
      metadata cleanup <p> Server resource for testing <p> Sysadmin resource
      for installation <p> Human resources for testing. </td>
  </tr>
  <tr>
   <td style="vertical-align: top; text-align: left;">May (new release)
   </td>
   <td style="vertical-align: top; text-align: left;">Test release.  
<p>
Start planning for training, training of trainers, online materials etc
   </td>
   <td style="vertical-align: top; text-align: left;">Server resource for testing
<p>
Human resource for training preparation and training of TOT
   </td>
  </tr>
  <tr>
   <td style="vertical-align: top; text-align: left;">June
   </td>
   <td style="vertical-align: top; text-align: left;">Training
   </td>
   <td style="vertical-align: top; text-align: left;">Sysadmin resource for installation
<p>
Server resource for training
<p>
Provision of physical or virtual training events </td>
  </tr>
     <tr>
	 <td style="vertical-align: top; text-align: left;">July </td>
	 <td style="vertical-align: top; text-align: left;">Upgrade production </td>
	 <td style="vertical-align: top; text-align: left;">Sysadmin resource for installation </td>
     </tr>
</table>
