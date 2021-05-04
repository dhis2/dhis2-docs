# Organisation Units

In DHIS2 the location of the data, the geographical context, is
represented as organisational units. Organisational units can be either
a health facility or department/sub-unit providing services or an
administrative unit representing a geographical area (e.g. a health
district).

Organisation units are located within a hierarchy, also referred to as a
tree. The hierarchy will reflect the health administrative structure and
its levels. Typical levels in such a hierarchy are the national,
province, district and facility levels. In DHIS2 there is a single
organisational hierarchy so the way this is defined and mapped to the
reality needs careful consideration. Which geographical areas and levels
are defined in the main organisational hierarchy will have major impact
on the usability and performance of the application. Additionally, there
are ways of addressing alternative hierarchies and levels as explained
in the section called Organisation unit groups and group sets further
down.

## Organisation unit hierarchy design

The process of designing a sensible organisation unit hierarchy has many
aspects:

  - *Include all reporting health facilities:* All health facilities
    which contribute to the national data collection should be included
    in the system. Facilities of all kinds of ownership should be
    incorporated, including private, public, NGO and faith-oriented
    facilities. Often private facilities constitute half of the total
    number of facilities in a country and have policies for data
    reporting imposed on them, which means that incorporating data from
    such facilities are necessary to get realistic, national aggregate
    figures.

  - *Emphasize the health administrative hierarchy:* A country typically
    has multiple administrative hierarchies which are often not well
    coordinated nor harmonized. When considering what to emphasize when
    designing the DHIS2 database one should keep in mind what areas are
    most interesting and will be most frequently requested for data
    analysis. DHIS2 is primarily managing health data and performing
    analysis based on the health administrative structure. This implies
    that even if adjustments might be made to cater for areas such as
    finance and local government, the point of departure for the DHIS2
    organisation unit hierarchy should be the health administrative
    areas.

<!-- end list -->

  - *Limit the number of organisation unit hierarchy levels:* To cater
    for analysis requirements coming from various organisational bodies
    such as local government and the treasury, it is tempting to include
    all of these areas as organisation units in the DHIS2 database.
    However, due to performance considerations one should try to limit
    the organisation unit hierarchy levels to the smallest possible
    number. The hierarchy is used as the basis for aggregation of data
    to be presented in any of the reporting tools, so when producing
    aggregate data for the higher levels, the DHIS2 application must
    search for and add together data registered for all organisation
    units located further down the hierarchy. Increasing the number of
    organisation units will hence negatively impact the performance of
    the application and an excessively large number might become a
    significant problem in that regard.
    
    In addition, a central part in most of the analysis tools in DHIS2
    is based around dynamically selecting the “parent” organisation unit
    of those which are intended to be included. For instance, one would
    want to select a province and have the districts belonging to that
    province included in the report. If the district level is the most
    interesting level from an analysis point of view and several
    hierarchy levels exist between this and the province level, this
    kind of report will be rendered unusable. When building up the
    hierarchy, one should focus on the levels that will be used
    frequently in reports and data analysis and leave out levels that
    are rarely or never used as this will have an impact on both the
    performance and usability of the application.

  - *Avoid one-to-one relationships:* Another guiding principle for
    designing the hierarchy is to avoid connecting levels that have near
    one-to-one parent-child ratios, meaning that for instance a district
    (parent) should have on average more than one local council (child)
    at the level below before it make sense to add a local council level
    to the hierarchy. Parent-child ratios from 1:4 or more are much more
    useful for data analysis purposes as one can start to look at e.g.
    how a district’s data is distributed in the different sub-areas and
    how these vary. Such drill-down exercises are not very useful when
    the level below has the same target population and the same serving
    health facilities as the parent.
    
    Skipping geographical levels when mapping the reality to the DHIS2
    organisation unit hierarchy can be difficult and can easily lead to
    resistance among certain stakeholders, but one should have in mind
    that there are actually ways of producing reports based on
    geographical levels that are not part of the organisational
    hierarchy in DHIS2, as will be explained in the next section.

## Organisation unit groups and group sets

In DHIS2, organisation units can be grouped in organisation unit groups,
and these groups can be further organised into group sets. Together they
can mimic an alternative organisational hierarchy which can be used when
creating reports and other data output. In addition to representing
alternative geographical locations not part of the main hierarchy, these
groups are useful for assigning classification schemes to health
facilities, e.g. based on the type or ownership of the facilities. Any
number of group sets and groups can be defined in the application
through the user interface, and all these are defined locally for each
DHIS2 database.

An example illustrates this best: Typically one would want to provide
analysis based on the ownership of the facilities. In that case one
would create a group for each ownership type, for instance “MoH”,
“Private” and “NGO”. All facilities in the database must then be
classified and assigned to one and only one of these three groups. Next
one would create a group set called “Ownership” to which the three
groups above are assigned, as illustrated in the figure
below.

![](resources/images/implementation_guide/organisation_unit_hiearchy.png)

In a similar way one can create a group set for an additional
administrative level, e.g. local councils. All local councils must be
defined as organisation unit groups and then assigned to a group set
called “Local Council”. The final step is then to assign all health
facilities to one and only one of the local council groups. This enables
the DHIS2 to produce aggregate reports by each local council (adding
together data for all assigned health facilities) without having to
include the local council level in the main organisational hierarchy.
The same approach can be followed for any additional administrative or
geographical level that is needed, with one group set per additional
level. Before going ahead and designing this in DHIS2, a mapping between
the areas of the additional geographical level and the health facilities
in each area is needed.

A key property of the group set concept in DHIS2 to understand is
*exclusivity*, which implies that an organisation unit can be member of
exactly one of the groups in a group set. A violation of this rule would
lead to duplication of data when aggregating health facility data by the
different groups, as a facility assigned to two groups in the same group
set would be counted twice.

With this structure in place, DHIS2 can provide aggregated data for each
of the organisation unit ownership types through the “Organisation unit
group set report” in “Reporting” module or through the Excel pivot table
third-party tool. For instance one can view and compare utilisation
rates aggregated by the different types of ownership (e.g. MoH, Private,
NGO). In addition, DHIS2 can provide statistics of the distribution of
facilities in “Organisation unit distribution report” in “Reporting”
module. For instance one can view how many facilities exist under any
given organisation unit in the hierarchy for each of the various
ownership types. In the GIS module, given that health facility
coordinates have been registered in the system, one can view the
locations of the different types of health facilities (with different
symbols for each type), and also combine this information with another
map layer showing indicators e.g. by district.

