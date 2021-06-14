# Support

The DHIS2 community uses a set of collaboration and coordination
platforms for information and provision of downloads, documentation,
development, source code, functionality specifications, bug tracking.
This chapter will describe these in more detail.

## Home page: dhis2.org

The DHIS2 home page is found at *http://dhis2.org*. The *download* page
provides downloads for the DHIS2 Live package, WAR files, the mobile
client, a Debian package, the source code, sample databases and a tool
for editing the application user interface translations. Please note
that the current latest release will be maintained until the next is
released and both the actual release and the latest build from the
release branch are provided. We recommend that you check back regularly
on the download page and update your online server with the latest build
from the release branch. The build revision can be found under *Help* -
*About* inside DHIS2.

The *documentation* page provides installation instructions, user
documentation, this implementation guide, presentations, Javadocs,
changelog, roadmap and a guide for contributing to the documentation.
The user documentation is focused on the practical aspects of using
DHIS2, such as how to create data elements and reports. This
implementation guide is addressing the more high-level aspects of DHIS2
implementation, database development and maintenance. The change log and
roadmap sections provide links to the relevant pages in the Launchpad
site described later.

The *functionality* and *features* pages give a brief overview with
screenshots of the main functionalities and features of DHIS2. A demo
DHIS2 application can be reached from the *demo* top menu link. These
pages can be used when a quick introduction to the system must be given
to various stakeholders.

The *about* page has information about the license under which DHIS2 is
released, how to sign up for the mailing lists, get access to the source
code and more.

## Collaboration platform: launchpad.net/dhis2

DHIS2 uses *Launchpad* as the main collaboration platform. The site can
be accessed at *http://lanchpad.net/dhis2* Launchpad is used for source
code hosting, functionality specifications, bug tracking and
notifications. The *Bazaar* version control system is tightly integrated
with Launchpad and is required for checking out the source code.

The various source code branches including trunk and release branches
can be browsed at *http://code.launchpad.net/dhis2*

If you want to suggest new functionality to be implemented in DHIS2 you
can air your views on the developer mailing list and eventually write a
specification, which is referred to as *blueprints* in Launchpad. The
bueprint will be considered by the core development team and if accepted
be assigned a developer, approver and release version. Blueprints can be
browsed and added at *http://blueprints.launchpad.net/dhis2*

If you find a bug in DHIS2 you can report it at Launchpad by navigating
to *http://bugs.launchpad.net/dhis2* Your bug report will be
investigated by the developer team and be given a status. If valid it
will also be assigned to a developer and approver and eventually be
fixed. Note that bugfixes are incorporated into the trunk and latest
release branch - so more testing and feedback to the developer teams
leads to higher quality of your software.

## Reporting a problem

If you encounter a problem with the DHIS2 software you can ask for
assistance on the developer's mailing list at
<https://launchpad.net/~dhis2-devs>. Before reporting, make sure that
you have:

  - Cleared the web browser cache (also called history or browsing data)
    completely (select all options before clearing).

  - Cleared the DHIS2 application cache: Go to Data administration -\>
    Cache statistics and click Clear cache.

If you believe you have found a bug you can report it either to the
developer mailing lists or to the bug tracker at
https://bugs.launchpad.net/dhis2 .

For the developers to be able to help you need to provide as much useful
information as possible:

  - DHIS2 version: Look in the Help -\> About page inside DHIS2 and
    provide the version and build revision.

  - Web browser including version.

  - Operating system including version.

  - Servlet container / Tomcat log: Provide any output in the Tomcat log
    (typically catalina.out) related to your problem.

  - Web browser console: In the Chrome web browser, click F12, then
    "Console", and look for exceptions related to your problem.

  - Actions leading to the problem: Describe as clearly as possible
    which steps you take leading to the problem or exception.

  - Problem description: Describe the problem clearly, why you think it
    is a problem and which behavior you would expect from the system.

