# Setting Up a New Database

The DHIS2 application comes with a set of tools for data collection,
validation, reporting and analysis, but the contents of the database,
e.g. what data to collect, where the data comes from, and on what format
will depend on the context of use. These meta data need to be populated
into the application before it can be used, and this can be done through
the user interface and requires no programming. What is required is
in-depth knowledge about the local HIS context as well as an
understanding of the DHIS2 design principles (see the chapter “Key
conceptual design principles in DHIS2”). We call this initial process
database design or customisation. This chapter provides an overview of
the customisation process and briefly explains the steps involved, in
order to give the implementer a feeling of what this process requires.
Other chapters in this manual provide a lot more detail into some of the
specific steps.

## Strategies for getting started

The following section describes a list of tips for getting off to a good
start when developing a new database.

1.  Quickly populate a demo database, incl. examples of reports, charts,
    dashboard, GIS, data entry forms. Use real data, ideally
    nation-wide, but not necessarily facility-level data.

2.  Put the demo database online. Server hosting with an external
    provider server can be a solution to speed up the process, even if
    temporary. This makes a great collaborative platform and
    dissemination tool to get buy-in from stakeholders.

3.  The next phase is a more elaborate database design process. Parts of
    the demo can be reused if viable.

4.  Make sure to have a local team with different skills and background:
    public health, data administrator, IT and project management.

5.  Use the customisation and database design phase as a learning and
    training process to build local capacity through learning-by-doing.

6.  The country national team should drive the database design process
    but be supported and guided by experienced implementers.

## Controlled or open process?

As the DHIS2 customisation process often is and should be a
collaborative process, it is also important to have in mind which parts
of the database are more critical than others, e.g. to avoid an
untrained user to corrupt the data. Typically it is a lot more critical
to customise a database which already has data values, than working with
meta data on an “empty” database. Although it might seem strange, much
customisation takes place after the first data collection or import has
started, e.g. when adding new validation rules, indicators or report
layouts. The most critical mistake that can be made is to modify the
meta data that directly describes the data values, and these as we have
seen above, are the *data elements* and the *organisation units*. When
modifying these definitions it is important to think about how the
change will affect the meaning of the data values already in the system
(collected using the old definitions). It is recommended to limit who
can edit these core meta data through the user role management, to
restrict the access to a core customisation team.

Other parts of the system that are not directly coupled to the data
values are a lot less critical to play around with, and here, at least
in the early phases, one should encourage the users to try out new
things in order to create learning. This goes for groups, validation
rules, indicator formulas, charts, and reports. All these can easily be
deleted or modified later without affecting the underlying data values,
and therefore are not critical elements in the customisation process.

Of course, later in the customisation process when going into a
production phase, one should be even more careful in allowing access to
edit the various meta data, as any change, also to the less critical
meta data, might affect how data is aggregated together or presented in
a report (although the underlying raw data is still safe and correct).

## Steps for developing a database

The following section describes concrete steps for developing a database
from scratch.

### The organisational hierarchy

The organisational hierarchy defines the organisation using the DHIS2,
the health facilities, administrative areas and other geographical areas
used in data collection and data analysis. This dimension to the data is
defined as a hierarchy with one root unit (e.g. Ministry of Health) and
any number of levels and nodes below. Each node in this hierarchy is
called an organisational unit in DHIS2. The design of this hierarchy
will determine the geographical units of analysis available to the users
as data is collected and aggregated in this structure. There can only be
one organisational hierarchy at the same time so its structure needs
careful consideration.

Additional hierarchies (e.g. parallel administrative boundaries to the
health care sector) can be modelled using organisational groups and
group sets, but the organisational hierarchy is the main vehicle for
data aggregation on the geographical dimension. Typically national
organisational hierarchies in public health have 4-6 levels, but any
number of levels is supported. The hierarchy is built up of parent-child
relations, e.g. a Country or MoH unit (the root) might have e.g. 8 child
units (provinces), and each province again ( at level 2) might have
10-15 districts as their children. Normally the health facilities will
be located at the lowest level, but they can also be located at higher
levels, e.g. national or provincial hospitals, so skewed organisational
trees are supported (e.g. a leaf node can be positioned at level 2 while
most other leaf nodes are at level 5).

### Data Elements

The Data Element is perhaps the most important building block of a DHIS2
database. It represents the *what* dimension, it explains what is being
collected or analysed. In some contexts, this is referred to an
indicator, but in DHIS2 we call this unit of collection and analysis a
data element. The data element often represents a count of something,
and its name describes what is being counted, e.g. "BCG doses given" or
"Malaria cases". When data is collected, validated, analysed, reported
or presented it is the data elements or expressions built upon data
elements that describe the WHAT of the data. As such the data elements
become important for all aspects of the system and they decide not only
how data is collected, but more importantly how the data values are
represented in the database, which again decides how data can be
analysed and presented.

A best practice when designing data elements is to think of data
elements as a unit of data analysis and not just as a field in the data
collection form. Each data element lives on its own in the database,
completely detached from the collection form, and reports and other
outputs are based on data elements and expressions/formulas composed of
data elements and not the data collection forms. So the data analysis
needs should drive the process, and not the look and feel of the data
collection forms.

### Data sets and data entry forms

All data entry in DHIS2 is organised through the use of data sets. A
data set is a collection of data elements grouped together for data
collection, and in the case of distributed installs they also define
chunks of data for export and import between instances of DHIS2 (e.g.
from a district office local installation to a national server). Data
sets are not linked directly to the data values, only through their data
elements and frequencies, and as such a data set can be modified,
deleted or added at any point in time without affecting the raw data
already captured in the system, but such changes will of course affect
how new data will be collected.

Once you have assigned a data set to an organisation unit that data set
will be made available in Data Entry (under Services) for the
organisation units you have assigned it to and for the valid periods
according to the data set's period type. A default data entry form will
then be shown, which is simply a list of the data elements belonging to
the data set together with a column for inputting the values. If your
data set contains data elements with categories such as age groups or
gender, then additional columns will be automatically generated in the
default form based on the categories. In addition to the default
list-based data entry form, there are two more alternatives, the
section-based form and the custom form. Section forms allow for a bit
more flexibility when it comes to using tabular forms and are quick and
simple to design. Often your data entry form will need multiple tables
with subheadings, and sometimes you need to disable (grey out) a few
fields in the table (e.g. some categories do not apply to all data
elements), both of these functions are supported in section forms. When
the form you want to design is too complicated for the default or
section forms then your last option is to use a custom form. This takes
more time but gives you full flexibility in term of the design. In
DHIS2 there is a built in HTML editor (FcK Editor) for the form designer
and you can either design the form in the UI or paste in your html
directly (using the Source window in the editor.

### Validation rules

Once you have set up the data entry part of the system and started to
collect data then there is time to define data quality checks that help
to improve the quality of the data being collected. You can add as many
validation rules as you like and these are composed of left and right
side expressions that again are composed of data elements, with an
operator between the two sides. Typical rules are comparing subtotals to
totals of something. E.g. if you have two data elements "HIV tests
taken" and "HIV test result positive" then you know that in the same
form (for the same period and organisational unit) the total number of
tests must always be equal or higher than the number of positive tests.
These rules should be absolute rules meaning that they are
mathematically correct and not just assumptions or "most of the time
correct". The rules can be run in data entry, after filling each form,
or as a more batch like process on multiple forms at the same time, e.g.
for all facilities for the previous reporting month. The results of the
tests will list all violations and the detailed values for each side of
the expression where the violation occurred to make it easy to go back
to data entry and correct the values.

### Indicators

Indicators represent perhaps the most powerful data analysis feature of
the DHIS2. While data elements represent the raw data (counts) being
collected the indicators represent formulas providing coverage rates,
incidence rates, ratios and other formula-based units of analysis. An
indicator is made up of a factor (e.g. 1, 100, 100, 100 000), a
numerator and a denominator, the two latter are both expressions based
on one or more data elements. E.g. the indicator "BCG coverage \<1 year"
is defined a formula with a factor 100, a numerator ("BCG doses given to
children under 1 year") and a denominator ("Target population under 1
year"). The indicator "DPT1 to DPT3 drop out rate" is a formula of 100 %
x ("DPT1 doses given"- "DPT3 doses given") / ("DPT1 doses given").

Most report modules in DHIS2 support both data elements and indicators
and you can also combine these in custom reports, but the important
difference and strength of indicators versus raw data (data element's
data values) is the ability to compare data across different
geographical areas (e.g. highly populated vs rural areas) as the target
population can be used in the denominator.

Indicators can be added, modified and deleted at any point in time
without interfering with the data values in the database.

### Report tables and reports

Standard reports in DHIS2 is a very flexible way of presenting the data
that has been collected. Data can be aggregated by any organisational
unit or orgunit level, by data element, by indicators, as well as over
time (e.g. monthly, quarterly, yearly). The report tables are custom
data sources for the standard reports and can be flexibly defined in the
user interface and later accessed in external report designers such as
iReport or BIRT. These report designs can then be set up as easily
accessible one-click reports with parameters so that the users can run
the same reports e.g. every month when new data is entered, and also be
relevant to users at all levels as the organisational unit can be
selected at the time of running the report.

### GIS (Maps)

In the integrated GIS module you can easily display your data on maps,
both on polygons (areas) and as points (health facilities), and either
as data elements or indicators. By providing the coordinates of your
organisational units to the system you can quickly get up to speed with
this module. See the GIS section for details on how to get started.

### Charts and dashboard

One of the easiest way to display your indicator data is through charts.
An easy to use chart dialogue will guide you through the creation of
various types of charts with data on indicators, organisational units
and periods of your choice. These charts can easily be added to one of
the four chart sections on your dashboard and there be made easily
available right after log in. Make sure to set the dashboard module as
the start module in user settings.

