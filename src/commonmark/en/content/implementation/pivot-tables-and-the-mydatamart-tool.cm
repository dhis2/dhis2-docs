# Pivot Tables and the MyDataMart tool

Excel Pivot Table (see screenshot below) is a powerful and dynamic data
analysis tool that can be automatically linked to the DHIS2 data. While
most reporting tools in DHIS2 are limited in how much data they can
present at the same time, the pivot tables are designed to give nice
overviews with multiple data elements or indicators, and organisation
units and periods (see example below). Furthermore, the dynamic features
in pivoting and drill-down are very different from static spreadsheets
or many web reports, and this makes it a useful tool for information
users who want to do more in-depth analysis and to manipulate the views
on the data more dynamically. This, combined with the well-known
charting capabilities of Excel, has made the Pivot Table tool a popular
analysis tool among the more advanced DHIS2 users for a long time.

![](resources/images/implementation_guide/pivot_table.png)

With the recent shift towards online deployments, the offline pivot
tables in Excel also provide a useful alternative to the online
reporting tools as they allow for local data analysis without Internet
connectivity, which can be an advantage on unstable or expensive
connections. Internet is only needed to download new data from the
online server and, as soon as the data exists locally, working with the
pivot tables require no connectivity. The MyDatamart tool, which is
explained in detail further down, helps the users to maintain a local
data mart file (small database) which is updated over the Internet
against the online server, and then used as an offline data source that
feeds the pivot tables with data.

## Pivot table design

Typically an Excel pivot table file set up for DHIS2 will contain
multiple worksheets with one pivot table on each sheet. A table can
consist of either raw data values (by data elements) or indicator
values, and will usually be named based on which level of the
organisation unit hierarchy the source data is aggregated by as well as
the period type (frequency e.g. Monthly, Yearly) of the data. A standard
DHIS2 pivot table file includes the following pivot tables: District
Indicators, District Data Monthly, District Data Yearly, Facility
Indicators, Facility Data Monthly, Facility Data Yearly. In addition
there might be more specialized tables that focus on specific programs
and/or other period types.

One popular feature of pivot tables is to be able to drag-and-drop the
various fields between the three positions page/filter, row, and
columns, and thereby completely change the data view. These fields can
be seen as dimensions to the data values and represent the dimensions in
the DHIS2 data model; organisation unit (one field per level), data
elements or indicators, periods, and then a dynamically extended lists
of additional dimensions representing organisation unit/indicator/data
element group sets and data element categories (see other chapters of
this guide for details). In fact a dynamic pivot table is an excellent
tool to represent the many dimensions created in the DHIS2, and makes it
very easy to zoom in or out on each dimension, e.g. look at raw data
values by individual age groups or just by its total, or in combination
with other dimensions like gender. All the dimensions created in the
DHIS2 will be reflected in the available fields list of each pivot
table, and then it is up to the user to select which ones to use.

It is important to understand that the values in the pivot tables are
non-editable and all the names and numbers are fetched directly from the
DHIS2 database, which makes it different from a normal spreadsheet. In
order to be edited, the contents of a pivot table must be copied to a
normal spreadsheet, but this is rarely needed as all the names can be
edited in DHIS2 (and then be reflected in the pivot tables on the next
update). The names (captions) on each field however are editable, but
not their contents (values).

## Connecting to the DHIS2 database

Each pivot table has a connection to the DHIS2 database and makes use of
a pivot source view (SQL query) in the database to fetch the data. These
queries pull all their data from the data mart tables, so it is
important to keep the data mart updated at all times in order to get the
most recent data into the pivot tables. A pivot table can connect to a
database on the local computer or on a remote server. This makes it well
suitable for use in a local network where there is only one shared
database and multiple client computers using pivot tables. Excel can
also connect to databases running on Linux. The database connection used
in the pivot tables is specified in an ODBC data source on the Windows
computers running pivot tables.

For online deployments the recommended way to connect to the DHIS2 data
is to make use of the MyDatamart tool, which creates and updates a local
data mart file (database) that Excel can connect to. The MyDatamart tool
will be described in detail further down.

## Dealing with large amounts of data

The amount of data in a DHIS2 database can easily go beyond the
capabilities of Excel. A table with around 1 million values (rows of
data) tend to become less responsive to updates (refresh) and pivoting
operations, and on some computers Excel will give out of memory errors
when dealing with tables of this size. Typically, the more powerful the
computer, the more data can be handled, but the top limit seems to be
around 1 million rows even on the high-end computers.

To deal with this problem the standard DHIS2 pivot table setup is to
split the data over several pivot tables. There are different ways of
splitting the data; by organisation unit aggregation level (how deep),
by organisation unit coverage/boundary area (how wide), by period (e.g.
one year of data at a time), or by data element or indicator groups
(e.g. by health programs or themes). Aggregating away the lowest level
in the organisation unit hierarchy is the most effective approach as it
reduces the amount of data by a factor of the number of health
facilities in a country. Typically there is no need to look at all the
health facilities in a country at the same time, but instead only for a
limited area (e.g. district or province). And when there is a need for
data for the whole country that can be provided with district level
aggregates or similar. At a district or province office the users will
typically have facility level data only for their own area, and then for
the neighboring areas the data will be aggregated up one or two levels
to reduce the size of data, but still allow for comparison, split into
e.g. the two tables Facility Data and District Data, and similar for
indicator values. Splitting data by period or by data element/indicator
groups work more or less in the same way, and can be done either in
combination with the organisation unit splitting or instead of it. E.g.
if a health program wants to analyse a few data elements at facility
level for the whole country that can be possible. The splitting is
controlled by the pivot views in the database where one specifies which
data values to fetch.

