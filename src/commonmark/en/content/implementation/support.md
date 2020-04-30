# Support

The DHIS2 community uses a set of collaboration and coordination
platforms for information and provision of downloads, documentation,
development, source code, functionality specifications, bug tracking.
This chapter will describe these in more detail.

## Home page: dhis2.org

The DHIS2 home page is found at *https://www.dhis2.org/*. The *Downloads* page
provides links to downloads of the DHIS2 WAR files, the Android Capture mobile
application, the source code, sample databases, and links to additional resources 
and guides. Please note that the current latest release will be maintained until 
the next is released and both the actual release and the latest build from the
release branch are provided. We recommend that you check back regularly
on the download page and update your online server with the latest build
from the release branch. The build revision can be found under *Help* -
*About* inside DHIS2.

The *Documentation* page provides installation instructions, user
documentation, this implementation guide, presentations, Javadocs,
changelog, roadmap and a guide for contributing to the documentation.
The user documentation is focused on the practical aspects of using
DHIS2, such as how to create data elements and reports. This
implementation guide is addressing the more high-level aspects of DHIS2
implementation, database development and maintenance. The change log and
roadmap sections provide links to the relevant pages in the Launchpad
site described later.

The *Overview* page gives a brief overview with screenshots of the main 
functionalities and features of DHIS2, with subpages that give additional
information on new features included on each DHIS2 version. Demo DHIS2 
applications can be reached from the *Demos* menu link. These
pages can be used when a quick introduction to the system must be given
to various stakeholders.

The *Contact* page has information about the license under which DHIS2 is 
released, how to sign up for the mailing lists, get access to the source 
code and more.

## Collaboration platform: community.dhis2.org

The primary DHIS2 collaboration platform is the *DHIS2 Community of Practice*. The site can
be accessed at *https://community.dhis2.org/* and is based on the Discourse platform.

The Community of Practice is used to facilitate community support for DHIS2 user issues, as
well as to help identify potential bugs in existing software versions and feature requests
for future versions. It is also a place where members of the community can share stories,
best practices, and challenges from their DHIS2 implementations, collaborate with others
on projects, and offer their services to the larger community. Users can set up their Community
of Practice accounts based on individual preferences for notification settings, and can reply
to existing topics by email. 

The *Support* section of the Community of Practice includes all topics that were created using 
DHIS2's previous collaboration platform, Launchpad, which is no longer active.

Bugs identified on the Community of Practice should be submitted to the DHIS2 core team on *Jira*

## Reporting a problem

If you encounter a problem while using DHIS2, take these steps first:

  - Clear the web browser cache (also called history or browsing data)
    completely (select all options before clearing).

  - Clear the DHIS2 application cache: Go to Data administration -\>
    Cache statistics and click Clear cache.

If the problem persists, go to the Community of Practice and use key terms to search for 
topics that other users have posted which describe similar issues to find out if your issue 
has already been reported and resolved. If you are not able to find a threat with a similar 
issue, you should create a new topic in the *Support* category. Members of the community 
and the DHIS2 team will respond to attempt to assist with resolving your issue.

If the response you received in the Community of Practice indicates that you have identified 
a bug, you should post a bug report on the DHIS2 Jira.

## Development tracking: jira.dhis2.org

*Jira* is the place to report issues, and to follow requirements, progress and roadmap for 
the DHIS2 software. The DHIS2 Jira site can be accessed at https://jira.dhis2.org/.

If you find a bug in DHIS2 you can report it on Jira by navigating
to the DHIS2 Jire homepage, clicking *create* in the top menu, selecting "bug" as the 
issue type, and filling out the required fields.

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

Your bug report will be investigated by the developer team and be given a status. 
If valid it will also be assigned to a developer and approver and eventually be
fixed. Note that bugfixes are incorporated into the trunk and latest
release branch - so more testing and feedback to the developer teams
leads to higher quality of your software.

If you want to suggest new functionality to be implemented in DHIS2 you
should first start a discussion on the Community of Practice to get feedback on your 
idea and confirm that the functionality you are suggesting does not already exist. 
Once you have completed these steps, you can submit a feature request on DHIS2 Jira 
by clicking "Create" in the top menu and selecting "Feature" as the issue type. 
Your feature request will be considered by the core development team and if accepted 
it will be assigned a developer, approver and release version. DHIS2 users can vote 
to show support for feature requests that have been submitted. Existing feature requests 
can be browsed by using the "filter" function on Jira.



## Source code: github.com/dhis2
The various source code branches including trunk and release branches
can be browsed at *https://github.com/dhis2*


