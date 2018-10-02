# What is DHIS2?

<!--DHIS2-SECTION-ID:what_is_dhis2-->

After reading this chapter you will be able to understand:

  - What is DHIS2 and what purpose it serves with respect to health
    information systems (HIS)?

  - What are the major technological considerations when it comes to
    deploying DHIS2, and what are the options are for extending DHIS2
    with new modules?

  - What is the difference between patient based and aggregate data?

  - What are some of the benefits and challenges with using Free and
    Open Source Software (FOSS) for HIS?

## DHIS2 Background

<!--DHIS2-SECTION-ID:mod1_1-->

DHIS2 is a tool for collection, validation, analysis, and presentation
of aggregate and patient-based statistical data, tailored (but not
limited) to integrated health information management activities. It is a
generic tool rather than a pre-configured database application, with an
open meta-data model and a flexible user interface that allows the user
to design the contents of a specific information system without the need
for programming. DHIS2 is a modular web-based software package built
with free and open source Java frameworks.

DHIS2 is open source software released under the BSD license and can be
obtained at no cost. It runs on any platform with a Java Runtime
Environment (JRE 7 or higher) installed.

DHIS2 is developed by the Health Information Systems Programme (HISP) as
an open and globally distributed process with developers currently in
India, Vietnam, Tanzania, Ireland, and Norway. The development is
coordinated by the University of Oslo with support from NORAD and other
donors.

The DHIS2 software is used in more than 40 countries in Africa, Asia,
and Latin America, and countries that have adopted DHIS2 as their
nation-wide HIS software include Kenya, Tanzania, Uganda, Rwanda, Ghana,
Liberia, and Bangladesh. A rapidly increasing number of countries and
organisations are starting up new deployments.

The documentation provided herewith, will attempt to provide a
comprehensive overview of the application. Given the abstract nature of
the application, this manual will not serve as a complete step-by-step
guide of how to use the application in each and every circumstance, but
rather will seek to provide illustrations and examples of how DHIS2 can
be implemented in a variety of situations through generalized examples.

Before implementing DHIS2 in a new setting, we highly recommend reading
the DHIS2 Implementation Guide (a separate manual from this one), also
available at the main DHIS2 [website](http://dhis2.org/documentation/).

## Key features and purpose of DHIS2

The key features and purpose of DHIS2 can be summarised as follows:

  - Provide a comprehensive data management solution based on data
    warehousing principles and a modular structure which can easily be
    customised to the different requirements of a management information
    system, supporting analysis at different levels of the
    organisational hierarchy.

  - Customisation and local adaptation through the user interface. No
    programming required to start using DHIS2 in a new setting (country,
    region, district etc.).

  - Provide data entry tools which can either be in the form of standard
    lists or tables, or can be customised to replicate paper forms.

  - Provide different kinds of tools for data validation and improvement
    of data quality.

  - Provide easy to use - one-click reports with charts and tables for
    selected indicators or summary reports using the design of the data
    collection tools. Allow for integration with popular external report
    design tools (e.g. JasperReports) to add more custom or advanced
    reports.

  - Flexible and dynamic (on-the-fly) data analysis in the analytics
    modules (i.e. GIS, PivotTables,Data Visualizer, Event reports, etc).

  - A user-specific dashboard for quick access to the relevant
    monitoring and evaluation tools including indicator charts and links
    to favourite reports, maps and other key resources in the system.

  - Easy to use user-interfaces for metadata management e.g. for
    adding/editing datasets or health facilities. No programming needed
    to set up the system in a new setting.

  - Functionality to design and modify calculated indicator formulas.

  - User management module for passwords, security, and fine-grained
    access control (user roles).

  - Messages can be sent to system users for feedback and notifications.
    Messages can also be delivered to email and SMS.

  - Users can share and discuss their data in charts and reports using
    Interpretations, enabling an active information-driven user
    community.

  - Functionalities of export-import of data and metadata, supporting
    synchronisation of offline installations as well as interoperability
    with other applications.

  - Using the DHIS2 Web-API , allow for integration with external
    software and extension of the core platform through the use of
    custom apps.

  - Further modules can be developed and integrated as per user needs,
    either as part of the DHIS2 portal user interface or a more
    loosely-coupled external application interacting through the DHIS2
    Web-API.

In summary, DHIS2 provides a comprehensive HIS solution for the
reporting and analysis needs of health information users at any
level.

## Use of DHIS2 in HIS: data collection, processing, interpretation, and analysis.

The wider context of HIS can be comprehensively described through the
information cycle presented in Figure 1.1 below. The information cycle
pictorially depicts the different components, stages and processes
through which the data is collected, checked for quality, processed,
analysed and used.


![The health information
cycle](resources/images/dhis2UserManual/dhis2_information_cycle.png)

DHIS2 supports the different facets of the information cycle including:

  - Collecting data.

  - Running quality checks.

  - Data access at multiple levels.

  - Reporting.

  - Making graphs and maps and other forms of analysis.

  - Enabling comparison across time (for example, previous months) and
    space (for example, across facilities and districts).

  - See trends (displaying data in time series to see their min and max
    levels).

As a first step, DHIS2 serves as a data collection, recording and
compilation tool, and all data (be it in numbers or text form) can be
entered into it. Data entry can be done in lists of data elements or in
customised user defined forms which can be developed to mimic paper
based forms in order to ease the process of data entry.

As a next step, DHIS2 can be used to increase data quality. First, at
the point of data entry, a check can be made to see if data falls within
acceptable range levels of minimum and maximum values for any particular
data element. Such checking, for example, can help to identify typing
errors at the time of data entry. Further, user can define various
validation rules, and DHIS2 can run the data through the validation
rules to identify violations. These types of checks help to ensure that
data entered into the system is of good quality from the start, and can
be improved by the people who are most familiar with it.

When data has been entered and verified, DHIS2 can help to make
different kinds of reports. The first kind are the routine reports that
can be predefined, so that all those reports that need to be routine
generated can be done on a click of a button. Further, DHIS2 can help in
the generation of analytical reports through comparisons of for example
indicators across facilities or over time. Graphs, maps, reports and
health profiles are among the outputs that DHIS2 can produce, and these
should routinely be produced, analysed, and acted upon by health
managers.

## Technical background

### DHIS2 as a platform

DHIS2 can be perceived as a platform on several levels. First, the
application database is designed ground-up with flexibility in mind.
Data structures such as data elements, organisation units, forms and
user roles can be defined completely freely through the application user
interface. This makes it possible for the system to be adapted to a
multitude of locale contexts and use-cases. We have seen that DHIS2
supports most major requirements for routine data capture and analysis
emerging in country implementations. It also makes it possible for DHIS2
to serve as management system for domains such as logistics, labs and
finance.

Second, due to the modular design of DHIS2 it can be extended with
additional software modules or through custom apps. These software
modules/apps can live side by side with the core modules of DHIS2 and
can be integrated into the DHIS2 portal and menu system. This is a
powerful feature as it makes it possible to extend the system with extra
functionality when needed, typically for country specific requirements
as earlier pointed out.

The downside of the software module extensibility is that it puts
several constraints on the development process. The developers creating
the extra functionality are limited to the DHIS2 technology in terms of
programming language and software frameworks, in addition to the
constraints put on the design of modules by the DHIS2 portal solution.
Also, these modules must be included in the DHIS2 software when the
software is built and deployed on the web server, not dynamically during
run-time.

In order to overcome these limitations and achieve a looser coupling
between the DHIS2 service layer and additional software artefacts, a
REST-based API has been developed as part of DHIS2. This Web API
complies with the rules of the REST architectural style. This implies
that:

  - The Web API provides a navigable and machine-readable interface to
    the complete DHIS2 data model. For instance, one can access the full
    list of data elements, then navigate using the provided URL to a
    particular data element of interest, then navigate using the
    provided URL to the list of data sets which the data element is a
    member of.

  - (Meta) Data is accessed through a uniform interface (URLs) using
    plain HTTP requests. There are no fancy transport formats or
    protocols involved - just the well-tested, well-understood HTTP
    protocol which is the main building block of the Web today. This
    implies that third-party developers can develop software using the
    DHIS2 data model and data without knowing the DHIS2 2specific
    technology or complying with the DHIS2 design constraints.

  - All data including meta-data, reports, maps and charts, known as
    resources in REST terminology, can be retrieved in most of the
    popular representation formats of the Web of today, such as XML,
    JSON, PDF and PNG. These formats are widely supported in
    applications and programming languages and gives third-party
    developers a wide range of implementation options.

### Understanding platform independence

All computers have an Operating System (OS) to manage it and the
programs running it. The operating system serves as the middle layer
between the software application, such as DHIS2, and the hardware, such
as the CPU and RAM. DHIS2 runs on the Java Virtual Machine, and can
therefore run on any operating system which supports Java. Platform
independence implies that the software application can run on ANY OS -
Windows, Linux, Macintosh etc. DHIS2 is platform independent and thus
can be used in many different contexts depending on the exact
requirements of the operating system to be used.

Additionally, DHIS2 supports three major database management systems
systems (DBMS). DHIS2 uses the Hibernate database abstraction framework
and is compatible with the following database systems: PostgreSQL, MySQL
and H2. PostgreSQL and MySQL are high-quality production ready
databases, while H2 is a useful in-memory database for small-scale
applications or development activities.

Lastly, and perhaps most importantly, since DHIS2 is a browser-based
application, the only real requirement to interact with the system is
with a web browser. DHIS2 supports most web browsers, although currently
either Google Chrome, Mozilla Firefox or Opera are recommended.

### Deployment strategies - online vs offline

DHIS2 is a network enabled application and can be accessed over the
Internet, a local intranet as well as a locally installed system. The
deployment alternatives for DHIS2 are in this chapter defined as i)
offline deployment ii) online deployment and iii) hybrid deployment. The
meaning and differences will be discussed in the following sections.

#### Offline Deployment

An off-line deployment implies that multiple standalone off-line
instances are installed for end users, typically at the district level.
The system is maintained primarily by the end users/district health
officers who enters data and generate reports from the system running on
their local server. The system will also typically be maintained by a
national super-user team who pay regular visits to the district
deployments. Data is moved upwards in the hierarchy by the end users
producing data exchange files which are sent electronically by email or
physically by mail or personal travel. (Note that the brief Internet
connectivity required for sending emails does not qualify for being
defined as on-line). This style of deployment has the obvious benefit
that it works when appropriate Internet connectivity is not available.
On the other side there are significant challenges with this style which
are described in the following section.

  - **Hardware:** Running stand-alone systems requires advanced hardware
    in terms of servers and reliable power supply to be installed,
    usually at district level, all over the country. This requires
    appropriate funding for procurement and plan for long-term
    maintenance.

  - **Software platform:** Local installs implies a significant need for
    maintenance. From experience, the biggest challenge is viruses and
    other malware which tend to infect local installations in the
    long-run. The main reason is that end users utilize memory sticks
    for transporting data exchange files and documents between private
    computers, other workstations and the system running the
    application. Keeping anti-virus software and operating system
    patches up to date in an off-line environment are challenging and
    bad practices in terms of security are often adopted by end users.
    The preferred way to overcome this issue is to run a dedicated
    server for the application where no memory sticks are allowed and
    use an Linux based operating system which is not as prone for virus
    infections as MS Windows.

  - **Software application:** Being able to distribute new functionality
    and bug-fixes to the health information software to users are
    essential for maintenance and improvement of the system. Relying on
    the end users to perform software upgrades requires extensive
    training and a high level of competence on their side as upgrading
    software applications might a technically challenging task. Relying
    on a national super-user team to maintain the software implies a lot
    of travelling.

  - **Database maintenance:**A prerequisite for an efficient system is
    that all users enter data with a standardized meta-data set (data
    elements, forms etc). As with the previous point about software
    upgrades, distribution of changes to the meta-data set to numerous
    off-line installations requires end user competence if the updates
    are sent electronically or a well-organized super-user team. Failure
    to keep the meta-data set synchronized will lead to loss of ability
    to move data from the districts and/or an inconsistent national
    database since the data entered for instance at the district level
    will not be compatible with the data at the national level.

#### Online deployment

An on-line deployment implies that a single instance of the application
is set up on a server connected to the Internet. All users (clients)
connect to the on-line central server over the Internet using a web
browser. This style of deployment is increasingly possible due to
increased availability in (mobile) Internet coverage globally, as well
as readily available and cheap cloud-computing resources. These
developments make it possible to access on-line servers in even the most
rural areas using mobile Internet modems (also referred to as
*dongles*).

This on-line deployment style has huge positive implications for the
implementation process and application maintenance compared to the
traditional off-line standalone style:

  - **Hardware:** Hardware requirements on the end-user side are limited
    to a reasonably modern computer/laptop and Internet connectivity
    through a fixed line or a mobile modem. There is no need for a
    specialized server for each user, any Internet enabled computer will
    be sufficient. A server will be required for on-line deployments,
    but since there is only one (or several) servers which need to be
    procured and maintained, this is significantly simpler (and cheaper)
    than maintaining many separate servers is disparate locations. Given
    that cloud-computing resources continue to steadily decrease in
    price while increasing in computational power, setting up a powerful
    server in the cloud is far cheaper than procuring hardware.

  - **Software platform:** The end users only need a web browser to
    connect to the on-line server. All popular operating systems today
    are shipped with a web browser and there is no special requirement
    on what type or version. This means that if severe problems such as
    virus infections or software corruption occur one can always resort
    to re-formatting and installing the computer operating system or
    obtain a new computer/laptop. The user can continue with data entry
    where it was left and no data will be lost.

  - **Software application:** The central server deployment style means
    that the application can be upgraded and maintained in a centralized
    fashion. When new versions of the applications are released with new
    features and bug-fixes it can be deployed to the single on-line
    server. All changes will then be reflected on the client side the
    next time end users connect over the Internet. This obviously has a
    huge positive impact for the process of improving the system as new
    features can be distributed to users immediately, all users will be
    accessing the same application version, and bugs and issues can be
    sorted out and deployed on-the-fly.

  - **Database maintenance:**Similar to the previous point, changes to
    the meta-data can be done on the on-line server in a centralized
    fashion and will automatically propagate to all clients next time
    they connect to the server. This effectively removes the vast issues
    related to maintaining an upgraded and standardized meta-data set
    related to the traditional off-line deployment style. It is
    extremely convenient for instance during the initial database
    development phase and during the annual database revision processes
    as end users will be accessing a consistent and standardized
    database even when changes occur frequently.

This approach might be problematic in cases where Internet connectivity
is volatile or missing in long periods of time. DHIS2 however has
certain features which requires Internet connectivity to be available
only part of the time for the system to work properly, such as offline
data entry. In general however, DHIS2 does require Internet connectivity
of some sort, but this is increasingly an easy problem to solve even in
remote locations.

#### Hybrid deployment

From the discussion so far one realizes that the on-line deployment
style is favourable over the off-line style but requires decent Internet
connectivity where it will be used. It is important to notice that the
mentioned styles can co-exist in a common deployment. It is perfectly
feasible to have on-line as well as off-line deployments within a single
country. The general rule would be that districts and facilities should
access the system on-line over the Internet where sufficient Internet
connectivity exist, and off-line systems should be deployed to districts
where this is not the case.

Defining decent Internet connectivity precisely is hard but as a rule of
thumb the download speed should be minimum 10 Kbyte/second for the
client and at least 1 Mbit/sec (dedicated) bandwidth for the server.

In this regard mobile Internet modems which can be connected to a
computer or laptop and access the mobile network is an extremely capable
and feasible solution. Mobile Internet coverage is increasing rapidly
all over the world, often provide excellent connectivity at low prices
and is a great alternative to local networks and poorly maintained fixed
Internet lines. Getting in contact with national mobile network
companies regarding post-paid subscriptions and potential large-order
benefits can be a worthwhile effort. The network coverage for each
network operator in the relevant country should be investigated when
deciding which deployment approach to opt for as it might differ and
cover different parts of the country.

#### Server hosting

The on-line deployment approach raises the question of where and how to
host the server which will run the DHIS2 application. Typically there
are several options:

1.  Internal hosting within the Ministry of Health

2.  Hosting within a government data centre

3.  Hosting through an external hosting company

The main reason for choosing the first option is often political
motivation for having “physical ownership” of the database. This is
perceived as important by many in order to “own” and control the data.
There is also a wish to build local capacity for server administration
related to sustainability of the project. This is often a donor-driven
initiatives as it is perceived as a concrete and helpful mission.

Regarding the second option, some places a government data centre is
constructed with a view to promoting and improving the use and
accessibility of public data. Another reason is that a proliferation of
internal server environments is very resource demanding and it is more
effective to establish centralized infrastructure and capacity.

Regarding external hosting there is lately a move towards outsourcing
the operation and administration of computer resources to an external
provider, where those resources are accessed over the network, popularly
referred to as “cloud computing” or “software as a service”. Those
resources are typically accessed over the Internet using a web browser.

The primary goal for an on-line server deployment is provide long-term
stable and high-performance accessibility to the intended services. When
deciding which option to choose for server environment there are many
aspects to consider:

1.  Human capacity for server administration and operation. There must
    be human resources with general skills in server administration and
    in the specific technologies used for the application providing the
    services. Examples of such technologies are web servers and database
    management platforms.

2.  Reliable solutions for automated backups, including local off-server
    and remote backup.

3.  Stable connectivity and high network bandwidth for traffic to and
    from the server.

4.  Stable power supply including a backup solution.

5.  Secure environment for the physical server regarding issues such as
    access, theft and fire.

6.  Presence of a disaster recovery plan. This plan must contain a
    realistic strategy for making sure that the service will be only
    suffering short down-times in the events of hardware failures,
    network downtime and more.

7.  Feasible, powerful and robust hardware.

All of these aspects must be covered in order to create an appropriate
hosting environment. The hardware requirement is deliberately put last
since there is a clear tendency to give it too much attention.

Looking back at the three main hosting options, experience from
implementation missions in developing countries suggests that all of the
hosting aspects are rarely present in option one and two at a feasible
level. Reaching an acceptable level in all these aspects is challenging
in terms of both human resources and money, especially when compared to
the cost of option three. It has the benefit that is accommodates the
mentioned political aspects and building local capacity for server
administration, on the other hand can this be provided for in
alternative ways.

Option three - external hosting - has the benefit that it supports all
of the mentioned hosting aspects at a very affordable price. Several
hosting providers - of virtual servers or software as a service - offer
reliable services for running most kinds of applications. Example of
such providers are [Linode](http://www.linode.com) and [Amazon Web
Services](http://aws.amazon.com). Administration of such servers happens
over a network connection, which most often anyway is the case with
local server administration. The physical location of the server in this
case becomes irrelevant as that such providers offer services in most
parts of the world. This solution is increasingly becoming the standard
solution for hosting of application services. The aspect of building
local capacity for server administration is compatible with this option
since a local ICT team can be tasked with maintaining the externally
hosted server, but with not being burdened with worrying about power
supply and bandwidth constraints which usually exist outside of major
data centres.

An approach for combining the benefits of external hosting with the need
for local hosting and physical ownership is to use an external hosting
provider for the primary transactional system, while mirroring this
server to a locally hosted non-critical server which is used for
read-only purposes such as data analysis and accessed over the intranet.

## Difference between Aggregated and Patient data in a HIS

*Patient data* is data relating to a single patient, such as his/her
diagnosis, name, age, earlier medical history etc. This data is
typically based on a single patient-health care worker interaction. For
instance, when a patient visits a health care clinic, a variety of
details may be recorded, such as the patient's temperature, their
weight, and various blood tests. Should this patient be diagnosed as
having "Vitamin B 12 deficiency anaemia, unspecified" corresponding to
ICD-10 code D51.9, this particular interaction might eventually get
recorded as an instance of "Anaemia" in an aggregate based system.
Patient based data is important when you want to track longitudinally
the progress of a patient over time. For example, if we want to track
how a patient is adhering to and responding to the process of TB
treatment (typically taking place over 6-9 months), we would need
patient based data.

*Aggregated data* is the consolidation of data relating to multiple
patients, and therefore cannot be traced back to a specific patient.
They are merely counts, such as incidences of Malaria, TB, or other
diseases. Typically, the routine data that a health facility deals with
is this kind of aggregated statistics, and is used for the generation of
routine reports and indicators, and most importantly, strategic planning
within the health system. Aggregate data cannot provide the type of
detailed information which patient level data can, but is crucial for
planning and guidance of the performance of health systems.

In between the two you have case-based data, or anonymous "patient"
data. A lot of details can be collected about a specific health event
without necessarily having to identify the patient it involved.
Inpatient or outpatient visits, a new case of cholera, a maternal death
etc. are common use-cases where one would like to collect a lot more
detail that just adding to the total count of cases, or visits. This
data is often collected in line-listing type of forms, or in more
detailed audit forms. It is different from aggregate data in the sense
that it contains many details about a specific event, whereas the
aggregate data would count how many events of a certain type, e.g. how
many outpatient visits with principal diagnosis "Malaria", or how many
maternal deaths where the deceased did not attend ANC, or how many
cholera outbreaks for children under 5 years. In DHIS2 this data is
collected through programs of the type single event without
registration.

Patient data is highly confidential and therefore must be protected so
that no one other than doctors can get it. When in paper, it must be
properly stored in a secure place. For computers, patient data needs
secure systems with passwords, restrained access and audit logs.

Security concerns for aggregated data are not as crucial as for patient
data, as it is usually impossible to identify a particular person to a
aggregate statistic . However, data can still be misused and
misinterpreted by others, and should not be distributed without adequate
data dissemination policies in place.

## Free and Open Source Software (FOSS): benefits and challenges

Software carries the instructions that tell a computer how to operate.
The human authored and human readable form of those instructions is
called source code. Before the computer can actually execute the
instructions, the source code must be translated into a machine readable
(binary) format, called the object code. All distributed software
includes the object code, but FOSS makes the source code available as
well.

Proprietary software owners license their copyrighted object code to a
user, which allows the user to run the program. FOSS programs, on the
other hand, license both the object and the source code, permitting the
user to run, modify and possibly redistribute the programs. With access
to the source code, the users have the freedom to run the program for
any purpose, redistribute, probe, adapt, learn from, customise the
software to suit their needs, and release improvements to the public for
the good of the community. Hence, some FOSS is also known as free
software, where “free” refers, first and foremost, to the above freedoms
rather than in the monetary sense of the word.

Within the public health sector, FOSS can potentially have a range of
benefits, including:

  - Lower costs as it does not involve paying for prohibitive license
    costs.

  - Given the information needs for the health sector are constantly
    changing and evolving, there is a need for the user to have the
    freedom to make the changes as per the user requirements. This is
    often limited in proprietary systems.

  - Access to source code to enable integration and interoperability. In
    the health sector interoperability between different software
    applications is becoming increasingly important, meaning enabling
    two or more systems to communicate metadata and data. This work is a
    lot easier, and sometimes dependent on the source code being
    available to the developers that create the integration. This
    availability is often not possible in the case of proprietary
    software. And when it is, it comes at a high cost and contractual
    obligations.

  - FOSS applications like DHIS2 typically are supported by a global
    network of developers, and thus have access to cutting edge research
    and development knowledge.
