# Data Analysis Tools Overview

This chapter offers an overview of the available tools for data analysis
provided by DHIS2 along with a description of the purpose and benefits
of each. If you are looking for a detailed guide on how to use each tool
we recommend to continue to read the user guide after finishing this
chapter. The following list shows the various tools:

1.  Standard reports

2.  Data set reports

3.  Data completeness reports

4.  Static reports

5.  Organisation unit distribution reports

6.  Report tables

7.  Charts

8.  Web Pivot table

9.  GIS

10. My Datamart and Excel pivot tables

## Data analysis tools

The following section gives a description of each tool.

### Standard reports

Standard reports are reports with predefined designs. This means that
the reports are easily accessible with a few clicks and can be consumed
by users at all levels of experience. The report can contain statistics
in the form of tables and charts and can be tailored to suit most
requirements. The report solution in DHIS2 is based on JasperReports and
reports are most often designed with the iReport report designer. Even
though the report design is fixed, data can be dynamically loaded into
the report based on any organisation unit from within the hierarchy and
with a variety of time periods.

### Data set reports

Data set reports displays the design of data entry forms as a report
populated with aggregated data (as opposed to captured low-level data).
This report is easily accessible for all types of users and gives quick
access to aggregate data. There is often a legacy requirement for
viewing data entry forms as reports which this tool efficiently provides
for. The data set report supports all types of data entry forms
including section and custom forms.

### Data completeness report

The data completeness report produces statistics for the degree of
completeness of data entry forms. The statistical data can be analysed
per individual data sets or per a list of organisation units with a
common parent in the hierarchy. It provides a percentage value for the
total completeness and for the completeness of timely submissions. One
can use various definitions of completeness as basis for the statistics:
First based on number of data sets marked manually as complete by the
user entering data. Second based on whether all data element defined as
compulsory are being filled in for a data set. Third based on the
percentage of number of values filled over the total number of values in
a data set.

### Static reports

Static reports provides two methods for linking to existing resources in
the user interface. First it provides the possibility to link to a
resource on the Internet trough a URL. Second it provides the
possibility to upload files to the system and link to those files. The
type of files to upload can be any kind of document, image or video.
Useful examples of documents to link to are health surveys, policy
documents and annual plans. URLs can point to relevant web sites such as
the Ministry of Health home page, sources of health related information.
In addition it can be used as an interface to third-party web based
analysis tools by pointing at specific resources. One example is
pointing a URL to a report served by the BIRT reporting framework.

### Organisation unit distribution reports

The organisation unit distribution report provides statistics on the
facilities (organisation units) in the hierarchy based on their
classification. The classification is based on organisation unit groups
and group sets. For instance facilities can be classified by type
through assignment to the relevant group from the group set for
organisation unit type. The distribution report produces the number of
facilities for each class and can be generated for all organisation
units and for all group sets in the system.

### Report tables

Report tables are reports based on aggregated data in a tabular format.
A report table can be used as a stand-alone report or can be used as
data source for a more sophisticated standard report design. The tabular
format can be cross-tabulated with any number of dimensions appearing as
columns. It can contain indicator and data element aggregate data as
well as completeness data for data sets. It can contain relative periods
which enables the report to be reused over time. It can contain user
selectable parameters for organisation units and periods to enable the
report to be reused for all organisation units in the hierarchy. The
report table can be limited to the top results and sorted ascending or
descending. When generated the report table data can be downloaded as
PDF, Excel workbook, CSV file and Jasper report.

### Charts

The chart component offers a wide variety of charts including the
standard bar, line and pie charts. The charts can contain indicators,
data elements, periods and organisation units on both the x and y axis
as well as a fixed horizontal target line. Charts can be view directly
or as part of the dashboard as will be explained later.

### Web Pivot tables

The web pivot table offers quick access to statistical data in a tabular
format and provides the ability to “pivot” any number of the dimensions
such as indicators, data elements, organisation units and periods to
appear on columns and rows in order to create tailored views. Each cell
in the table can be visualized as a bar chart.

### GIS

The GIS module gives the ability to visualize aggregate data on maps.
The GIS module can provide thematic mapping of polygons such as
provinces and districts and of points such as facilities in separate
layers. The mentioned layers can be displayed together and be combined
with custom overlays. Such map views can be easily navigated back in
history, saved for easy access at a later stage and saved to disk as an
image file. The GIS module provides automatic and fixed class breaks for
thematic mapping, predefined and automatic legend sets, ability to
display labels (names) for the geographical elements and the ability to
measure the distance between points in the map. Mapping can be viewed
for any indicator or data element and for any level in the organisation
unit hierarchy. There is also a special layer for displaying facilities
on the map where each one is represented with a symbol based on its
type.

### My Datamart and Excel Pivot tables

The purpose of the My Datamart tool is to provide users with full access
to aggregate data even on unreliable Internet connections. This tool
consists of a light-weight client application which is installed on the
computer of the users. It connects to an online central server running a
DHIS2 instance, downloads aggregate data and stores it in a database on
the local computer. This database can be used to connect third-party
tools such as MS Excel Pivot tables, which is a powerful tool for data
analysis and visualization. This solution implies that just short
periods of Internet connectivity are required to synchronize the client
database with the central online one, and that after this process is
done the data will be available independent of connectivity. Please read
the chapter dedicated to this tool for in-depth information.

