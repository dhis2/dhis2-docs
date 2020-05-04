# Deployment Strategies

DHIS2 is a network enabled application and can be accessed over the
Internet, a local intranet and as a locally installed system. The
deployment alternatives for DHIS2 are in this chapter defined as i)
offline deployment ii) online deployment and iii) hybrid deployment. The
meaning and differences will be discussed in the following sections.

## Offline Deployment

An offline deployment implies that multiple standalone offline instances
are installed for end users, typically at the district level. The system
is maintained primarily by the end users/district health officers who
enters data and generate reports from the system running on their local
server. The system will also typically be maintained by a national
super-user team who pay regular visits to the district deployments. Data
is moved upwards in the hierarchy by the end users producing data
exchange files which are sent electronically by email or physically by
mail or personal travel. (Note that the brief Internet connectivity
required for sending emails does not qualify for being defined as
online). This style of deployment has the obvious benefit that it works
when appropriate Internet connectivity is not available. On the other
side there are significant challenges with this style which are
described in the following section.

  - Hardware: Running stand-alone systems requires advanced hardware in
    terms of servers and reliable power supply to be installed, usually
    at district level, all over the country. This requires appropriate
    funding for procurement and plan for long-term maintenance.

  - Software platform: Local installs implies a significant need for
    maintenance. From experience, the biggest challenge is viruses and
    other malware which tend to infect local installations in the
    long-run. The main reason is that end users utilize memory sticks
    for transporting data exchange files and documents between private
    computers, other workstations and the system running the
    application. Keeping anti-virus software and operating system
    patches up to date in an offline environment are challenging and bad
    practices in terms of security are often adopted by end users. The
    preferred way to overcome this issue is to run a dedicated server
    for the application where no memory sticks are allowed and use a
    Linux based operating system which is not as prone to virus
    infections as MS Windows.

  - Software application: Being able to distribute new functionality and
    bug-fixes to the health information software to users are essential
    for maintenance and improvement of the system. Relying on the end
    users to perform software upgrades requires extensive training and a
    high level of competence on their side as upgrading software
    applications might be a technically challenging task. Relying on a
    national super-user team to maintain the software implies a lot of
    travelling.

  - Database maintenance: A prerequisite for an efficient system is that
    all users enter data with a standardized meta-data set (data
    elements, forms etc). As with the previous point about software
    upgrades, distribution of changes to the meta-data set to numerous
    offline installations requires end user competence if the updates
    are sent electronically or a well-organized super-user team. Failure
    to keep the meta-data set synchronized will lead to loss of ability
    to move data from the districts and/or an inconsistent national
    database since the data entered for instance at the district level
    will not be compatible with the data at the national level.

## Online deployment

An online deployment implies that a single instance of the application
is set up on a server connected to the Internet. All users (clients)
connect to the online central server over the Internet using a web
browser. This style of deployment currently benefits from the huge
investments in and expansions of mobile networks in developing
countries. This makes it possible to access online servers in even the
most rural areas using mobile Internet modems (also referred to as
*dongles*).

This online deployment style has huge positive implications for the
implementation process and application maintenance compared to the
traditional offline standalone style:

  - Hardware: Hardware requirements on the end-user side are limited to
    a reasonably modern computer/laptop and Internet connectivity
    through a fixed line or a mobile modem. There is no need for a
    specialized server, any Internet enabled computer will be
    sufficient.

  - Software platform: The end users only need a web browser to connect
    to the online server. All popular operating systems today are
    shipped with a web browser and there is no special requirement on
    what type or version. This means that if severe problems such as
    virus infections or software corruption occur one can always resort
    to re-formatting and installing the computer operating system or
    obtain a new computer/laptop. The user can continue with data entry
    where it was left and no data will be lost.

  - Software application: The central server deployment style means that
    the application can be upgraded and maintained in a centralized
    fashion. When new versions of the applications are released with new
    features and bug-fixes it can be deployed to the single online
    server. All changes will then be reflected on the client side the
    next time end users connect over the Internet. This obviously has a
    huge positive impact for the process of improving the system as new
    features can be distributed to users immediately, all users will be
    accessing the same application version, and bugs and issues can be
    sorted out and deployed on-the-fly.

  - Database maintenance: Similar to the previous point, changes to the
    meta-data can be done on the online server in a centralized fashion
    and will automatically propagate to all clients next time they
    connect to the server. This effectively removes the vast issues
    related to maintaining an upgraded and standardized meta-data set
    related to the traditional offline deployment style. It is extremely
    convenient for instance during the initial database development
    phase and during the annual database revision processes as end users
    will be accessing a consistent and standardized database even when
    changes occur frequently.

This approach might be problematic in cases where Internet connectivity
is volatile or missing in long periods of time. DHIS2 however has
certain features which require Internet connectivity to be available
only part of the time for the system to work properly, such as the
MyDatamart tool presented in a separate chapter in this guide.

## Hybrid deployment

From the discussion so far one realizes that the online deployment style
is favourable over the offline style but requires decent Internet
connectivity where it will be used. It is important to notice that the
mentioned styles can co-exist in a common deployment. It is perfectly
feasible to have online as well as offline deployments within a single
country. The general rule would be that districts and facilities should
access the system online over the Internet where sufficient Internet
connectivity exist, and offline systems should be deployed to districts
where this is not the case.

Defining decent Internet connectivity precisely is hard but as a rule of
thumb the download speed should be minimum 10 Kbyte/second and
accessibility should be minimum 70% of the time.

In this regard, mobile Internet modems which can be connected to a
computer or laptop and access the mobile network are an extremely
capable and feasible solution. Mobile Internet coverage is increasing
rapidly all over the world, often provides excellent connectivity at low
prices and is a great alternative to local networks and poorly
maintained fixed Internet lines. Getting in contact with national mobile
network companies regarding post-paid subscriptions and potential
large-order benefits can be a worthwhile effort. The network coverage
for each network operator in the relevant country should be investigated
when deciding which deployment approach to opt for as it might differ
and cover different parts of the country.

## Server hosting

The online deployment approach raises the question of where and how to
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
initiative as it is perceived as a concrete and helpful mission.

Regarding the second option, some places a government data centre is
constructed with a view to promoting and improving the use and
accessibility of public data. Another reason is that a proliferation of
internal server environments is very resource demanding and it is more
effective to establish centralized infrastructure and capacity.

Regarding external hosting, there is lately a move towards outsourcing
the operation and administration of computer resources to an external
provider, where those resources are accessed over the network, popularly
referred to as “cloud computing” or “software as a service”. Those
resources are typically accessed over the Internet using a web browser.

The primary goal for an online server deployment is to provide long-term
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
the cost of option three. It has the benefit that it accommodates the
mentioned political aspects and building local capacity for server
administration, on the other hand, can this be provided for in
alternative ways.

Option three - external hosting - has the benefit that it supports all
of the mentioned hosting aspects at a very affordable price. Several
hosting providers - of virtual servers or software as a service - offer
reliable services for running most kinds of applications. Examples of
such providers are Linode and Amazon Web Services. Administration of
such servers happens over a network connection, which most often anyway
is the case with local server administration. The physical location of
the server in this case becomes irrelevant in that such providers offer
services in most parts of the world. This solution is increasingly
becoming the standard solution for hosting of application services. The
aspect of building local capacity for server administration is
compatible with this option since a local ICT team can be tasked with
maintaining the externally hosted server.

An approach for combining the benefits of external hosting with the need
for local hosting and physical ownership is to use an external hosting
provider for the primary transactional system while mirroring this
server to a locally hosted non-critical server which is used for
read-only purposes such as data analysis and accessed over the intranet.

