# Data

## Data values { #webapi_data_values } 

This section is about sending and reading data values.

    /api/33/dataValueSets

### Sending data values { #webapi_sending_data_values } 

A common use-case for system integration is the need to send a set of
data values from a third-party system into DHIS. In this example, we will
use the DHIS2 demo on `http://play.dhis2.org/demo` as basis. We assume
that we have collected case-based data using a simple software client
running on mobile phones for the *Mortality <5 years* data set in the
community of *Ngelehun CHC* (in *Badjia* chiefdom, *Bo* district) for
the month of January 2014. We have now aggregated our data into a
statistical report and want to send that data to the DHIS2 instance. The
base URL to the demo API is `http://play.dhis2.org/demo/api`. The following
links are relative to the base URL.


The resource which is most appropriate for our purpose of sending data
values is the `/api/dataValueSets` resource. A data value set represents a
set of data values which have a relationship, usually from being
captured off the same data entry form. The format looks like
this:

```xml
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0" dataSet="dataSetID"
  completeDate="date" period="period" orgUnit="orgUnitID" attributeOptionCombo="aocID">
  <dataValue dataElement="dataElementID"
    categoryOptionCombo="cocID" value="1" comment="comment1"/>
  <dataValue dataElement="dataElementID"
    categoryOptionCombo="cocID" value="2" comment="comment2"/>
  <dataValue dataElement="dataElementID"
    categoryOptionCombo="cocID" value="3" comment="comment3"/>
</dataValueSet>
```

JSON is supported in this format:

```json
{
  "dataSet": "dataSetID",
  "completeDate": "date",
  "period": "period",
  "orgUnit": "orgUnitID",
  "attributeOptionCombo": "aocID",
  "dataValues": [
    {
      "dataElement": "dataElementID",
      "categoryOptionCombo": "cocID",
      "value": "1",
      "comment": "comment1"
    },
    {
      "dataElement": "dataElementID",
      "categoryOptionCombo": "cocID",
      "value": "2",
      "comment": "comment2"
    },
    {
      "dataElement": "dataElementID",
      "categoryOptionCombo": "cocID",
      "value": "3",
      "comment": "comment3"
    }
  ]
}
```

CSV is supported in this format:

```csv
"dataelement","period","orgunit","catoptcombo","attroptcombo","value","strby","lstupd","cmt"
"dataElementID","period","orgUnitID","cocID","aocID","1","username","2015-04-01","comment1"
"dataElementID","period","orgUnitID","cocID","aocID","2","username","2015-04-01","comment2"
"dataElementID","period","orgUnitID","cocID","aocID","3","username","2015-04-01","comment3"
```

> **Note**
>
> Please refer to the date and period section above for time formats.

From the example, we can see that we need to identify the period, the
data set, the org unit (facility) and the data elements for which to
report.

To obtain the identifier for the data set we make a request to the
`/api/dataSets` resource. From there we find and follow the link to
the *Mortality < 5 years* data set which leads us to `/api/dataSets/pBOMPrpg1QX`.
The resource representation for the *Mortality < 5 years* data set conveniently
advertises links to the data elements which are members of it. From here
we can follow these links and obtain the identifiers of the data
elements. For brevity we will only report on three data elements:
*Measles* with id `f7n9E0hX8qk`, *Dysentery* with id `Ix2HsbDMLea` and
*Cholera* with id `eY5ehpbEsB7`.

What remains is to get hold of the identifier of the organisation
unit. The *dataSet* representation conveniently provides a link to organisation
units which report on it so we search for *Ngelehun CHC* and follow the
link to the HTML representation at `/api/organisationUnits/DiszpKrYNg8`, which
tells us that the identifier of this org unit is `DiszpKrYNg8`.

From our case-based data, we assume that we have 12 cases of measles, 14
cases of dysentery and 16 cases of cholera. We have now gathered enough
information to be able to put together the XML data value set
message:

```xml
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0" dataSet="pBOMPrpg1QX"
  completeDate="2014-02-03" period="201401" orgUnit="DiszpKrYNg8">
  <dataValue dataElement="f7n9E0hX8qk" value="12"/>
  <dataValue dataElement="Ix2HsbDMLea" value="14"/>
  <dataValue dataElement="eY5ehpbEsB7" value="16"/>
</dataValueSet>
```

In JSON format:

```json
{
  "dataSet": "pBOMPrpg1QX",
  "completeDate": "2014-02-03",
  "period": "201401",
  "orgUnit": "DiszpKrYNg8",
  "dataValues": [
    {
      "dataElement": "f7n9E0hX8qk",
      "value": "1"
    },
    {
      "dataElement": "Ix2HsbDMLea",
      "value": "2"
    },
    {
      "dataElement": "eY5ehpbEsB7",
      "value": "3"
    }
  ]
}
```

To perform functional testing we will use the _curl_ tool which provides
an easy way of transferring data using HTTP. First, we save the data
value set XML content in a file called `datavalueset.xml`. From the
directory where this file resides we invoke the following from the
command line:

```bash
curl -d @datavalueset.xml "https://play.dhis2.org/demo/api/33/dataValueSets"
  -H "Content-Type:application/xml" -u admin:district
```

For sending JSON content you must set the content-type header
accordingly:

```bash
curl -d @datavalueset.json "https://play.dhis2.org/demo/api/33/dataValueSets"
  -H "Content-Type:application/json" -u admin:district
```

The command will dispatch a request to the demo Web API, set
`application/xml` as the content-type and authenticate using
`admin`/`district` as username/password. If all goes well this will return a
`200 OK` HTTP status code. You can verify that the data has been
received by opening the data entry module in DHIS2 and select the org
unit, data set and period used in this example.

The API follows normal semantics for error handling and HTTP status
codes. If you supply an invalid username or password, `401 Unauthorized`
is returned. If you supply a content-type other than `application/xml`,
`415 Unsupported Media Type` is returned. If the XML content is invalid
according to the DXF namespace, `400 Bad Request` is returned. If you
provide an invalid identifier in the XML content, `409 Conflict` is
returned together with a descriptive message.

### Sending bulks of data values { #webapi_sending_bulks_data_values } 

The previous example showed us how to send a set of related data values
sharing the same period and organisation unit. This example will show us
how to send large bulks of data values which don't necessarily are
logically related.

Again we will interact with the `/api/dataValueSets` resource. This time we
will not specify the `dataSet` and `completeDate` attributes. Also, we will
specify the `period` and `orgUnit` attributes on the individual data value
elements instead of on the outer data value set element. This will
enable us to send data values for various periods and organisation units:

```xml
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0">
  <dataValue dataElement="f7n9E0hX8qk"
    period="201401" orgUnit="DiszpKrYNg8" value="12"/>
  <dataValue dataElement="f7n9E0hX8qk"
    period="201401" orgUnit="FNnj3jKGS7i" value="14"/>
  <dataValue dataElement="f7n9E0hX8qk"
    period="201402" orgUnit="DiszpKrYNg8" value="16"/>
  <dataValue dataElement="f7n9E0hX8qk"
    period="201402" orgUnit="Jkhdsf8sdf4" value="18"/>
</dataValueSet>
```

In JSON format:

```json
{
  "dataValues": [
    {
      "dataElement": "f7n9E0hX8qk",
      "period": "201401",
      "orgUnit": "DiszpKrYNg8",
      "value": "12"
    },
    {
      "dataElement": "f7n9E0hX8qk",
      "period": "201401",
      "orgUnit": "FNnj3jKGS7i",
      "value": "14"
    },
    {
      "dataElement": "f7n9E0hX8qk",
      "period": "201402",
      "orgUnit": "DiszpKrYNg8",
      "value": "16"
    },
    {
      "dataElement": "f7n9E0hX8qk",
      "period": "201402",
      "orgUnit": "Jkhdsf8sdf4",
      "value": "18"
    }
  ]
}
```

In CSV format:

```csv
"dataelement","period","orgunit","categoryoptioncombo","attributeoptioncombo","value"
"f7n9E0hX8qk","201401","DiszpKrYNg8","bRowv6yZOF2","bRowv6yZOF2","1"
"Ix2HsbDMLea","201401","DiszpKrYNg8","bRowv6yZOF2","bRowv6yZOF2","2"
"eY5ehpbEsB7","201401","DiszpKrYNg8","bRowv6yZOF2","bRowv6yZOF2","3"
```

We test by using curl to send the data values in XML format:

```bash
curl -d @datavalueset.xml "https://play.dhis2.org/demo/api/33/dataValueSets"
  -H "Content-Type:application/xml" -u admin:district
```

Note that when using CSV format you must use the binary data option to
preserve the line-breaks in the CSV file:

```bash
curl --data-binary @datavalueset.csv "https://play.dhis2.org/demo/24/api/dataValueSets"
  -H "Content-Type:application/csv" -u admin:district
```

The data value set resource provides an XML response which is useful
when you want to verify the impact your request had. The first time we
send the data value set request above the server will respond with the
following import summary:

```xml
<importSummary>
  <dataValueCount imported="2" updated="1" ignored="1"/>
  <dataSetComplete>false</dataSetComplete>
</importSummary>
```

This message tells us that 3 data values were imported, 1 data value was
updated while zero data values were ignored. The single update comes as
a result of us sending that data value in the previous example. A data
value will be ignored if it references a non-existing data element,
period, org unit or data set. In our case, this single ignored value was
caused by the last data value having an invalid reference to org unit.
The data set complete element will display the date of which the data
value set was completed, or false if no data element attribute was
supplied.

### Import parameters { #webapi_data_values_import_parameters } 

The import process can be customized using a set of import parameters:

<table>
<caption>Import parameters</caption>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Values (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dataElementIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the data element object to use to map the data values.</td>
</tr>
<tr class="even">
<td>orgUnitIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the org unit object to use to map the data values.</td>
</tr>
<tr class="odd">
<td>categoryOptionComboIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the category option combo and attribute option combo objects to use to map the data values.</td>
</tr>
<tr class="even">
<td>idScheme</td>
<td>id | name | code| attribute:ID</td>
<td>Property of all objects including data elements, org units and category option combos, to use to map the data values.</td>
</tr>
<tr class="odd">
<td>preheatCache</td>
<td>false | true</td>
<td>Indicates whether to preload metadata caches before starting to import data values, will speed up large import payloads with high metadata cardinality.</td>
</tr>
<tr class="even">
<td>dryRun</td>
<td>false | true</td>
<td>Whether to save changes on the server or just return the import summary.</td>
</tr>
<tr class="odd">
<td>importStrategy</td>
<td>CREATE | UPDATE | CREATE_AND_UPDATE | DELETE</td>
<td>Save objects of all, new or update import status on the server.</td>
</tr>
<tr class="even">
<td>skipExistingCheck</td>
<td>false | true</td>
<td>Skip checks for existing data values. Improves performance. Only use for empty databases or when the data values to import do not exist already.</td>
</tr>
<tr class="even">
<td>skipAudit</td>
<td>false | true</td>
<td>Skip audit, meaning audit values will not be generated. Improves performance at the cost of ability to audit changes. Requires authority "F_SKIP_DATA_IMPORT_AUDIT".</td>
</tr>
<tr class="odd">
<td>async</td>
<td>false | true</td>
<td>Indicates whether the import should be done asynchronous or synchronous. The former is suitable for very large imports as it ensures that the request does not time out, although it has a significant performance overhead. The latter is faster but requires the connection to persist until the process is finished.</td>
</tr>
<tr class="even">
<td>force</td>
<td>false | true</td>
<td>Indicates whether the import should be forced. Data import could be rejected for various reasons of data set locking for example due to approval, data input period, expiry days, etc. In order to override such locks and force data input one can use data import with force=true. However, one needs to be a *superuser* for this parameter to work.</td>
</tr>
</tbody>
</table>

All parameters are optional and can be supplied as query parameters in
the request URL like this:

    /api/33/dataValueSets?dataElementIdScheme=code&orgUnitIdScheme=name
      &dryRun=true&importStrategy=CREATE

They can also be supplied as XML attributes on the data value set
element like below. XML attributes will override query string
parameters.

```xml
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0" dataElementIdScheme="code"
  orgUnitIdScheme="name" dryRun="true" importStrategy="CREATE">
</dataValueSet>
```

Note that the `preheatCache` parameter can have a huge impact on
performance. For small import files, leaving it to false will be fast.
For large import files which contain a large number of distinct data
elements and organisation units, setting it to true will be orders of
magnitude faster.

#### Data value requirements { #webapi_data_values_import_requirement } 

Data value import supports a set of value types. For each value type,
there is a special requirement. The following table lists the edge cases
for value types.

<table>
<caption>Value type requirements</caption>
<thead>
<tr class="header">
<th>Value type</th>
<th>Requirements</th>
<th>Comment</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>BOOLEAN</td>
<td>true | True | TRUE | false | False | FALSE | 1 | 0 | t | f |</td>
<td>Used when the value is a boolean, true or false value. The import service does not care if the input begins with an uppercase or lowercase letter, or if it's all uppercase.</td>
</tr>
</tbody>
</table>

#### Identifier schemes { #webapi_data_values_identifier_schemes } 

Regarding the id schemes, by default the identifiers used in the XML
messages use the DHIS2 stable object identifiers referred to as `UID`.
In certain interoperability situations we might experience that an external
system decides the identifiers of the objects. In that case we can use
the `code` property of the organisation units and other objects to set
fixed identifiers. When importing data values we hence need to reference
the code property instead of the identifier property of these metadata
objects. Identifier schemes can be specified in the XML message as well
as in the request as query parameters. To specify it in the XML payload
you can do this:

```xml
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0"
  dataElementIdScheme="CODE" orgUnitIdScheme="UID" idScheme="CODE">
</dataValueSet>
```

The parameter table above explains how the id schemes can be specified
as query parameters. The following rules apply for what takes
precedence:

  - Id schemes defined in the XML or JSON payload take precedence over
    id schemes defined as URL query parameters.

  - Specific id schemes including dataElementIdScheme and
    orgUnitIdScheme take precedence over the general idScheme.

  - The default id scheme is UID, which will be used if no explicit id
    scheme is defined.

The following identifier schemes are available.

  - uid (default)

  - code

  - name

  - attribute (followed by UID of attribute)

The attribute option is special and refers to meta-data attributes which
have been marked as *unique*. When using this option, `attribute` must
be immediately followed by the identifier of the attribute, e.g.
"attribute:DnrLSdo4hMl".

#### Async data value import { #webapi_data_values_async_import } 

Data values can be sent and imported in an asynchronous fashion by
supplying an `async` query parameter set to *true*:

    /api/33/dataValueSets?async=true

This will initiate an asynchronous import job for which you can monitor
the status at the task summaries API. The API response indicates the
unique identifier of the job, type of job and the URL you can use to
monitor the import job status. The response will look similar to this:

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "message": "Initiated dataValueImport",
  "response": {
    "name": "dataValueImport",
    "id": "YR1UxOUXmzT",
    "created": "2018-08-20T14:17:28.429",
    "jobType": "DATAVALUE_IMPORT",
    "relativeNotifierEndpoint": "/api/system/tasks/DATAVALUE_IMPORT/YR1UxOUXmzT"
  }
}
```

Please read the section on *asynchronous task status* for more
information.

### CSV data value format { #webapi_data_values_csv } 

The following section describes the CSV format used in DHIS2. The first
row is assumed to be a header row and will be ignored during import.

<table>
<caption>CSV format of DHIS2</caption>
<tbody>
<tr class="odd">
<td>Column</td>
<td>Required</td>
<td>Description</td>
</tr>
<tr class="even">
<td>Data element</td>
<td>Yes</td>
<td>Refers to ID by default, can also be name and code based on selected id scheme</td>
</tr>
<tr class="odd">
<td>Period</td>
<td>Yes</td>
<td>In ISO format</td>
</tr>
<tr class="even">
<td>Org unit</td>
<td>Yes</td>
<td>Refers to ID by default, can also be name and code based on selected id scheme</td>
</tr>
<tr class="odd">
<td>Category option combo</td>
<td>No</td>
<td>Refers to ID</td>
</tr>
<tr class="even">
<td>Attribute option combo</td>
<td>No</td>
<td>Refers to ID (from version 2.16)</td>
</tr>
<tr class="odd">
<td>Value</td>
<td>No</td>
<td>Data value</td>
</tr>
<tr class="even">
<td>Stored by</td>
<td>No</td>
<td>Refers to username of user who entered the value</td>
</tr>
<tr class="odd">
<td>Last updated</td>
<td>No</td>
<td>Date in ISO format</td>
</tr>
<tr class="even">
<td>Comment</td>
<td>No</td>
<td>Free text comment</td>
</tr>
<tr class="odd">
<td>Follow up</td>
<td>No</td>
<td>true or false</td>
</tr>
</tbody>
</table>

An example of a CSV file which can be imported into DHIS2 is seen below.

```csv
"dataelement","period","orgunit","catoptcombo","attroptcombo","value","storedby","timestamp"
"DUSpd8Jq3M7","201202","gP6hn503KUX","Prlt0C1RF0s",,"7","bombali","2010-04-17"
"DUSpd8Jq3M7","201202","gP6hn503KUX","V6L425pT3A0",,"10","bombali","2010-04-17"
"DUSpd8Jq3M7","201202","OjTS752GbZE","V6L425pT3A0",,"9","bombali","2010-04-06"
```

### Generating data value set template { #webapi_data_values_template } 

To generate a data value set template for a certain data set you can use
the `/api/dataSets/<id>/dataValueSet` resource. XML and JSON response
formats are supported. Example:

    /api/dataSets/BfMAe6Itzgt/dataValueSet.json

The parameters you can use to further adjust the output are described
below:

<table style="width:100%;">
<caption>Data values query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 19%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>period</td>
<td>No</td>
<td>Period to use, will be included without any checks.</td>
</tr>
<tr class="even">
<td>orgUnit</td>
<td>No</td>
<td>Organisation unit to use, supports multiple orgUnits, both id and code can be used.</td>
</tr>
<tr class="odd">
<td>comment</td>
<td>No</td>
<td>Should comments be include, default: Yes.</td>
</tr>
<tr class="even">
<td>orgUnitIdScheme</td>
<td>No</td>
<td>Organisation unit scheme to use, supports id | code.</td>
</tr>
<tr class="odd">
<td>dataElementIdScheme</td>
<td>No</td>
<td>Data-element scheme to use, supports id | code.</td>
</tr>
</tbody>
</table>

### Reading data values { #webapi_reading_data_values } 

This section explains how to retrieve data values from the Web API by
interacting with the *dataValueSets* resource. Data values can be
retrieved in *XML*, *JSON* and *CSV* format. Since we want to read data
we will use the *GET* HTTP verb. We will also specify that we are
interested in the XML resource representation by including an `Accept`
HTTP header with our request. The following query parameters are
required:

<table>
<caption>Data value set query parameters</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dataSet</td>
<td>Data set identifier. Can be repeated any number of times.</td>
</tr>
<tr class="even">
<td>dataElementGroup</td>
<td>Data element group identifier. Can be repeated any number of times.</td>
</tr>
<tr class="odd">
<td>period</td>
<td>Period identifier in ISO format. Can be repeated any number of times.</td>
</tr>
<tr class="even">
<td>startDate</td>
<td>Start date for the time span of the values to export.</td>
</tr>
<tr class="odd">
<td>endDate</td>
<td>End date for the time span of the values to export.</td>
</tr>
<tr class="even">
<td>orgUnit</td>
<td>Organisation unit identifier. Can be repeated any number of times.</td>
</tr>
<tr class="odd">
<td>children</td>
<td>Whether to include the children in the hierarchy of the organisation units.</td>
</tr>
<tr class="even">
<td>orgUnitGroup</td>
<td>Organisation unit group identifier. Can be repeated any number of times.</td>
</tr>
<tr class="odd">
<td>attributeOptionCombo</td>
<td>Attribute option combo identifier. Can be repeated any number of times.</td>
</tr>
<tr class="even">
<td>includeDeleted</td>
<td>Whether to include deleted data values.</td>
</tr>
<tr class="odd">
<td>lastUpdated</td>
<td>Include only data values which are updated since the given time stamp.</td>
</tr>
<tr class="even">
<td>lastUpdatedDuration</td>
<td>Include only data values which are updated within the given duration. The format is &lt;value&gt;&lt;time-unit&gt;, where the supported time units are &quot;d&quot; (days), &quot;h&quot; (hours), &quot;m&quot; (minutes) and &quot;s&quot; (seconds).</td>
</tr>
<tr class="odd">
<td>limit</td>
<td>The max number of results in the response.</td>
</tr>
<tr class="even">
<td>idScheme</td>
<td>Property of meta data objects to use for data values in response.</td>
</tr>
<tr class="odd">
<td>dataElementIdScheme</td>
<td>Property of the data element object to use for data values in response.</td>
</tr>
<tr class="even">
<td>orgUnitIdScheme</td>
<td>Property of the org unit object to use for data values in response.</td>
</tr>
<tr class="odd">
<td>categoryOptionComboIdScheme</td>
<td>Property of the category option combo and attribute option combo objects to use for data values in response.</td>
</tr>
<tr class="even">
<td>dataSetIdScheme</td>
<td>Property of the data set object to use in the response.</td>
</tr>
</tbody>
</table>

The following response formats are supported:

  - xml (application/xml)

  - json (application/json)

  - csv (application/csv)

  - adx (application/adx+xml)

Assuming that we have posted data values to DHIS2 according to the
previous section called *Sending data values* we can now put together
our request for a single data value set and request it using cURL:

```bash
curl "https://play.dhis2.org/demo/api/33/dataValueSets?dataSet=pBOMPrpg1QX&period=201401&orgUnit=DiszpKrYNg8"
  -H "Accept:application/xml" -u admin:district
```

We can also use the start and end dates query parameters to request a
larger bulk of data values. I.e. you can also request data values for
multiple data sets and org units and a time span in order to export
larger chunks of data. Note that the period query parameter takes
precedence over the start and end date parameters. An example looks like
this:

```bash
curl "https://play.dhis2.org/demo/api/33/dataValueSets?dataSet=pBOMPrpg1QX&dataSet=BfMAe6Itzgt
  &startDate=2013-01-01&endDate=2013-01-31&orgUnit=YuQRtpLP10I&orgUnit=vWbkYPRmKyS&children=true"
  -H "Accept:application/xml" -u admin:district
```

To retrieve data values which have been created or updated within the
last 10 days you can make a request like this:

    /api/dataValueSets?dataSet=pBOMPrpg1QX&orgUnit=DiszpKrYNg8&lastUpdatedDuration=10d

The response will look like this:

```xml
<?xml version='1.0' encoding='UTF-8'?>
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0" dataSet="pBOMPrpg1QX"
  completeDate="2014-01-02" period="201401" orgUnit="DiszpKrYNg8">
<dataValue dataElement="eY5ehpbEsB7" period="201401" orgUnit="DiszpKrYNg8"
  categoryOptionCombo="bRowv6yZOF2" value="10003"/>
<dataValue dataElement="Ix2HsbDMLea" period="201401" orgUnit="DiszpKrYNg8"
  categoryOptionCombo="bRowv6yZOF2" value="10002"/>
<dataValue dataElement="f7n9E0hX8qk" period="201401" orgUnit="DiszpKrYNg8"
  categoryOptionCombo="bRowv6yZOF2" value="10001"/>
</dataValueSet>
```

You can request the data in JSON format like this:

    /api/dataValueSets.json?dataSet=pBOMPrpg1QX&period=201401&orgUnit=DiszpKrYNg8

The response will look something like this:

```json
{
  "dataSet": "pBOMPrpg1QX",
  "completeDate": "2014-02-03",
  "period": "201401",
  "orgUnit": "DiszpKrYNg8",
  "dataValues": [
    {
      "dataElement": "eY5ehpbEsB7",
      "categoryOptionCombo": "bRowv6yZOF2",
      "period": "201401",
      "orgUnit": "DiszpKrYNg8",
      "value": "10003"
    },
    {
      "dataElement": "Ix2HsbDMLea",
      "categoryOptionCombo": "bRowv6yZOF2",
      "period": "201401",
      "orgUnit": "DiszpKrYNg8",
      "value": "10002"
    },
    {
      "dataElement": "f7n9E0hX8qk",
      "categoryOptionCombo": "bRowv6yZOF2",
      "period": "201401",
      "orgUnit": "DiszpKrYNg8",
      "value": "10001"
    }
  ]
}
```

Note that data values are softly deleted, i.e. a deleted value has the
`deleted` property set to true instead of being permanently deleted.
This is useful when integrating multiple systems in order to communicate
deletions. You can include deleted values in the response like this:

    /api/33/dataValueSets.json?dataSet=pBOMPrpg1QX&period=201401
      &orgUnit=DiszpKrYNg8&includeDeleted=true

You can also request data in CSV format like this:

    /api/33/dataValueSets.csv?dataSet=pBOMPrpg1QX&period=201401
      &orgUnit=DiszpKrYNg8

The response will look like this:

```csv
dataelement,period,orgunit,catoptcombo,attroptcombo,value,storedby,lastupdated,comment,flwup
f7n9E0hX8qk,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,12,system,2015-04-05T19:58:12.000,comment1,false
Ix2HsbDMLea,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,14,system,2015-04-05T19:58:12.000,comment2,false
eY5ehpbEsB7,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,16,system,2015-04-05T19:58:12.000,comment3,false
FTRrcoaog83,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,12,system,2014-03-02T21:45:05.519,comment4,false
```

The following constraints apply to the data value sets resource:

  - At least one data set must be specified.

  - Either at least one period or a start date and end date must be
    specified.

  - At least one organisation unit must be specified.

  - Organisation units must be within the hierarchy of the organisation
    units of the authenticated user.

  - Limit cannot be less than zero.

### Sending, reading and deleting individual data values { #webapi_sending_individual_data_values } 

This example will show how to send individual data values to be saved in
a request. This can be achieved by sending a *POST* request to the
`dataValues` resource:

    /api/dataValues

The following query parameters are supported for this resource:

<table style="width:100%;">
<caption>Data values query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 19%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>de</td>
<td>Yes</td>
<td>Data element identifier</td>
</tr>
<tr class="even">
<td>pe</td>
<td>Yes</td>
<td>Period identifier</td>
</tr>
<tr class="odd">
<td>ou</td>
<td>Yes</td>
<td>Organisation unit identifier</td>
</tr>
<tr class="even">
<td>co</td>
<td>No</td>
<td>Category option combo identifier, default will be used if omitted</td>
</tr>
<tr class="odd">
<td>cc</td>
<td>No (must be combined with cp)</td>
<td>Attribute category combo identifier</td>
</tr>
<tr class="even">
<td>cp</td>
<td>No (must be combined with cc)</td>
<td>Attribute category option identifiers, separated with ; for multiple values</td>
</tr>
<tr class="odd">
<td>ds</td>
<td>No</td>
<td>Data set, to check if POST or DELETE is allowed for period and organisation unit. If specified, the data element must be assigned to this data set. If not specified, a data set containing the data element will be chosen to check if the operation is allowed.</td>
</tr>
<tr class="even">
<td>value</td>
<td>No</td>
<td>Data value. For boolean values, the following will be accepted: true | True | TRUE | false | False | FALSE | 1 | 0 | t | f |</td>
</tr>
<tr class="odd">
<td>comment</td>
<td>No</td>
<td>Data comment</td>
</tr>
<tr class="even">
<td>followUp</td>
<td>No</td>
<td>Follow up on data value, will toggle the current boolean value</td>
</tr>
</tbody>
</table>

If any of the identifiers given are invalid, if the data value or
comment is invalid or if the data is locked, the response will contain
the *409 Conflict* status code and descriptive text message. If the
operation leads to a saved or updated value, *200 OK* will be returned.
An example of a request looks like this:

```bash
curl "https://play.dhis2.org/demo/api/33/dataValues?de=s46m5MS0hxu
  &pe=201301&ou=DiszpKrYNg8&co=Prlt0C1RF0s&value=12"
  -X POST -u admin:district
```

This resource also allows a special syntax for associating the value to
an attribute option combination. This can be done by sending the
identifier of the attribute category combination, together with the identifiers
of the attribute category options which the value represents within the
combination. The category combination is specified with the `cc` parameter, while
the category options are specified as a semi-colon separated string with the `cp`
parameter. It is necessary to ensure that the category options are all part
of the category combination. An example looks like this:

```bash
curl "https://play.dhis2.org/demo/api/33/dataValues?de=s46m5MS0hxu&ou=DiszpKrYNg8
  &pe=201308&cc=dzjKKQq0cSO&cp=wbrDrL2aYEc;btOyqprQ9e8&value=26"
  -X POST -u admin:district
```

You can retrieve a data value with a request using the *GET* method. The
value, comment and followUp params are not applicable in this regard:

```bash
curl "https://play.dhis2.org/demo/api/33/dataValues?de=s46m5MS0hxu
  &pe=201301&ou=DiszpKrYNg8&co=Prlt0C1RF0s"
  -u admin:district
```

You can delete a data value with a request using the *DELETE* method.

#### Working with file data values { #datavalue_file } 

When dealing with data values which have a data element of type *file*
there is some deviation from the method described above. These data
values are special in that the contents of the value is a UID reference
to a *FileResource* object instead of a self-contained constant. These
data values will behave just like other data values which store text
content, but should be handled differently in order to produce
meaningful input and output.

There are two methods of storing FileResource data values.

**The Easy Way:** Upload the file to the `/api/dataValues/file` endpoint as
described in the file resource section.  This works on versions 2.36 and later.

**The Hard Way:** If you are writing code that needs to be compatible
with versions of DHIS2 before 2.36, then the process is:

1.  Upload the file to the `/api/fileResources` endpoint as described
    in the file resource section.

2.  Retrieve the `id` property of the returned *FileResource*.

3.  Store the retrieved id *as the value* to the data value using any
    of the methods described above.

Only one-to-one relationships between data values and file resources are
allowed. This is enforced internally so that saving a file resource id
in several data values is not allowed and will return an error. Deleting
the data value will delete the referenced file resource. Direct deletion
of file resources are not possible.

The data value can now be retrieved as any other but the returned data
will be the UID of the file resource. In order to retrieve the actual
contents (meaning the file which is stored in the file resource mapped
to the data value) a GET request must be made to `/api/dataValues/files`
mirroring the query parameters as they would be for the data value
itself. The `/api/dataValues/files` endpoint only supports GET requests.

It is worth noting that due to the underlying storage mechanism working
asynchronously the file content might not be immediately ready for
download from the `/api/dataValues/files` endpoint. This is especially true
for large files which might require time consuming uploads happening in
the background to an external file store (depending on the system
configuration). Retrieving the file resource meta-data from the
`/api/fileResources/<id>` endpoint allows checking the `storageStatus`
of the content before attempting to download it.

## ADX data format { #webapi_adx_data_format } 

From version 2.20 we have included support for an international standard
for aggregate data exchange called ADX. ADX is developed and maintained
by the Quality Research and Public Health committee of the IHE
(Integrating the HealthCare Enterprise). The wiki page detailing QRPH
activity can be found at
[wiki.ihe.net](http://wiki.ihe.net/index.php?title=Quality,_Research_and_Public_Health#Current_Domain_Activities).
ADX is still under active development and has now been published for
trial implementation. Note that what is implemented currently in DHIS2
is the functionality to read and write adx formatted data, i.e. what is
described as Content Consumer and Content Producer actors in the ADX
profile.

The structure of an ADX data message is quite similar to what you might
already be familiar with from DXF 2 data described earlier. There are a
few important differences. We will describe these differences with
reference to a small example:

```xml
<adx xmlns="urn:ihe:qrph:adx:2015" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="urn:ihe:qrph:adx:2015 ../schema/adx_loose.xsd"
  exported="2015-02-08T19:30:00Z">
  <group orgUnit="OU_559" period="2015-06-01/P1M"
    completeDate="2015-07-01" dataSet="(TB/HIV)VCCT">
    <dataValue dataElement="VCCT_0" GENDER="FMLE" HIV_AGE="AGE0-14" value="32"/>
    <dataValue dataElement="VCCT_1" GENDER="FMLE" HIV_AGE="AGE0-14" value="20"/>
    <dataValue dataElement="VCCT_2" GENDER="FMLE" HIV_AGE="AGE0-14" value="10"/>
    <dataValue dataElement="PLHIV_TB_0" GENDER="FMLE" HIV_AGE="AGE0-14" value="10"/>
    <dataValue dataElement="PLHIV_TB_1" GENDER="FMLE" HIV_AGE="AGE0-14" value="10"/>

    <dataValue dataElement="VCCT_0" GENDER="MLE" HIV_AGE="AGE0-14" value="32"/>
    <dataValue dataElement="VCCT_1" GENDER="MLE" HIV_AGE="AGE0-14" value="20"/>
    <dataValue dataElement="VCCT_2" GENDER="MLE" HIV_AGE="AGE0-14" value="10"/>
    <dataValue dataElement="PLHIV_TB_0" GENDER="MLE" HIV_AGE="AGE0-14" value="10"/>
    <dataValue dataElement="PLHIV_TB_1" GENDER="MLE" HIV_AGE="AGE0-14" value="10"/>

    <dataValue dataElement="VCCT_0" GENDER="FMLE" HIV_AGE="AGE15-24" value="32"/>
    <dataValue dataElement="VCCT_1" GENDER="FMLE" HIV_AGE="AGE15-24" value="20"/>
    <dataValue dataElement="VCCT_2" GENDER="FMLE" HIV_AGE="AGE15-24" value="10"/>
    <dataValue dataElement="PLHIV_TB_0" GENDER="FMLE" HIV_AGE="AGE15-24" value="10"/>
    <dataValue dataElement="PLHIV_TB_1" GENDER="FMLE" HIV_AGE="AGE15-24" value="10"/>

    <dataValue dataElement="VCCT_0" GENDER="MLE" HIV_AGE="AGE15-24" value="32"/>
    <dataValue dataElement="VCCT_1" GENDER="MLE" HIV_AGE="AGE15-24" value="20"/>
    <dataValue dataElement="VCCT_2" GENDER="MLE" HIV_AGE="AGE15-24" value="10"/>
    <dataValue dataElement="PLHIV_TB_0" GENDER="MLE" HIV_AGE="AGE15-24" value="10"/>
    <dataValue dataElement="PLHIV_TB_1" GENDER="MLE" HIV_AGE="AGE15-24" value="10"/>
  </group>
</adx>
```

### The adx root element

The adx root element has only one mandatory attribute, which is the
*exported* timestamp. In common with other adx elements, the schema is
extensible in that it does not restrict additional application specific
attributes.

### The group element

Unlike dxf2, adx requires that the datavalues are grouped according to
orgUnit, period and dataSet. The example above shows a data report for
the "(TB/HIV) VCCT" dataset from the online demo database. This example
is using codes as identifiers instead of dhis2 uids. Codes are the
preferred form of identifier when using adx.

The orgUnit, period and dataSet attributes are mandatory in adx. The
group element may contain additional attributes. In our DHIS2
implementation any additional attributes are simply passed through to
the underlying importer. This means that all attributes which currently
have meaning in dxf2 (such as completeDate in the example above) can
continue to be used in adx and they will be processed in the same way.

A significant difference between adx and dxf2 is in the way that periods
are encoded. Adx makes strict use of ISO8601 and encodes the reporting
period as (date|datetime)/(duration). So the period in the example above
is a period of 1 month (P1M) starting on 2015-06-01. So it is the data
for June 2015. The notation is a bit more verbose, but it is very
flexible and allows us to support all existing period types in DHIS2

### ADX period definitions

DHIS2 supports a limited number of periods or durations during import.
Periods should begin with the date in which the duration begins, followed by
a "/" and then the duration notation as noted in the table. The
following table details all of the ADX supported period types, along
with examples.

<table>
<caption>ADX Periods</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th>Period type</th>
<th>Duration notation</th>
<th>Example</th>
<th>Duration</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Daily</td>
<td>P1D</td>
<td>2017-10-01/P1M</td>
<td>Oct 01 2017</td>
</tr>
<tr class="even">
<td>Weekly</td>
<td>P7D</td>
<td>2017-10-01/P7D</td>
<td>Oct 01 2017-Oct 07-2017</td>
</tr>
<tr class="odd">
<td>Monthly</td>
<td>P1M</td>
<td>2017-10-01/P1M</td>
<td>Oct 01 2017-Oct 31 2017</td>
</tr>
<tr class="even">
<td>Bi-monthly</td>
<td>P2M</td>
<td>2017-11-01/P2M</td>
<td>Nov 01 2017-Dec 31 2017</td>
</tr>
<tr class="odd">
<td>Quarterly</td>
<td>P3M</td>
<td>2017-09-01/P3M</td>
<td>Sep 01 2017-Dec 31 2017</td>
</tr>
<tr class="even">
<td>Six-monthly</td>
<td>P6M</td>
<td>2017-01-01/P6M</td>
<td>Jan 01 2017-Jun 30 2017</td>
</tr>
<tr class="odd">
<td>Yearly</td>
<td>P1Ý</td>
<td>2017-01-01/P1Y</td>
<td>Jan 01 2017-Dec 31 2017</td>
</tr>
<tr class="even">
<td>Financial October</td>
<td>P1Y</td>
<td>2017-10-01/P1Y</td>
<td>Oct 01 2017-Sep 30 2018</td>
</tr>
<tr class="odd">
<td>Financial April</td>
<td>P1Y</td>
<td>2017-04-01/P1Y</td>
<td>April 1 2017-Mar 31 2018</td>
</tr>
<tr class="even">
<td>Financial July</td>
<td>P1Y</td>
<td>2017-07-01/P1Y</td>
<td>July 1 2017-June 30 2018</td>
</tr>
</tbody>
</table>

### Data values

The dataValue element in adx is very similar to its equivalent in DXF.
The mandatory attributes are *dataElement* and *value*. The *orgUnit* and
*period* attributes don't appear in the dataValue as they are required
at the *group* level.

The most significant difference is the way that disaggregation is
represented. DXF uses the categoryOptionCombo to indicate the disaggregation
of data. In adx the disaggregations (e.g. AGE_GROUP and SEX) are
expressed explicitly as attributes. One important constraint on using
adx is that the categories used for dataElements in the dataSet MUST
have a code assigned to them, and further, that code must be of a form
which is suitable for use as an XML attribute. The exact constraint on
an XML attribute name is described in the W3C XML standard - in practice,
this means no spaces, no non-alphanumeric characters other than '_' and
it may not start with a letter. The example above shows examples of
'good' category codes ('GENDER' and 'HIV_AGE').

This restriction on the form of codes applies only to categories.
Currently, the convention is not enforced by DHIS2 when you are assigning
codes, but you will get an informative error message if you try to
import adx data and the category codes are either not assigned or not
suitable.

The main benefits of using explicit dimensions of disaggregated data are
that

  - The system producing the data does not have to be synchronised with the
    categoryOptionCombo within DHIS2.

  - The producer and consumer can match their codes to a 3rd party
    authoritative source, such as a vterminology service. Note that in
    the example above the Gender and AgeGroup codes are using code lists
    from the [WHO Global Health Observatory](http://apps.who.int/gho/data/node.resources.api).

Note that this feature may be extremely useful, for example when
producing disaggregated data from an EMR system, but there may be cases
where a *categoryOptionCombo* mapping is easier or more desirable. The
DHIS2 implementation of adx will check for the existence of a
*categoryOptionCombo* attribute and, if it exists, it will use that it
preference to exploded dimension attributes. Similarly, an
*attributeOptionCombo* attribute on the *group* element will be
processed in the legacy way. Otherwise, the attributeOptionCombo can be
treated as exploded categories just as on the *dataValue*.

In the simple example above, each of the dataElements in the dataSet
have the same dimensionality (categorycombo) so the data is neatly
rectangular. This need not be the case. dataSets may contain
dataElements with different categoryCombos, resulting in a
*ragged-right* adx data message.

### Importing data

DHIS2 exposes an endpoint for POST adx data at `/api/dataValueSets`
using *application/xml+adx* as content type. So, for example, the
following curl command can be used to POST the example data above to the
DHIS2 demo server:

```bash
curl -u admin:district -X POST -H "Content-Type: application/adx+xml"
  -d @data.xml "https://play.dhis2.org/demo/api/33/dataValueSets?dataElementIdScheme=code&orgUnitIdScheme=code"
```

Note the query parameters are the same as are used with DXF data. The
adx endpoint should interpret all the existing DXF parameters with the
same semantics as DXF.

### Exporting data

DHIS2 exposes an endpoint to GET adx data sets at `/api/dataValueSets`
using *application/xml+adx* as the accepted content type. So, for
example, the following curl command can be used to retrieve the adx
data:

```bash
curl -u admin:district -H "Accept: application/adx+xml"
 "https://play.dhis2.org/demo/api/33/dataValueSets?dataValueSets?orgUnit=M_CLINIC&dataSet=MALARIA&period=201501"
```

Note the query parameters are the same as are used with DXF data. An
important difference is that the identifiers for dataSet and orgUnit are
assumed to be codes rather than uids.

## Follow-up { #webapi_follow_up } 

This section covers marking data for follow-up.

### Data value follow-up

The data value follow-up endpoint allows for marking data values for follow-up.

```
PUT /api/36/dataValues/followup
```

The payload in `JSON` format looks like this:

```json
{
  "dataElement": "s46m5MS0hxu",
  "period": "202005",
  "orgUnit": "DiszpKrYNg8",
  "categoryOptionCombo": "psbwp3CQEhs",
  "attributeOptionCombo": "HllvX50cXC0",
  "followup": true
}
```

The `categoryOptionCombo` and `attributeOptionCombo` fields are optional. A minimal `JSON` payload looks like this:

```json
{
  "dataElement": "s46m5MS0hxu",
  "period": "202005",
  "orgUnit": "DiszpKrYNg8",
  "followup": false
}
```

The `followup` field should be set to `true` to mark a data value for follow-up, and `false` to remove the mark.

The response status code will be `200 OK` if the operation was successful, and `409 Conflict` in case of an error with the request.
