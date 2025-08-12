# Data

## Data values { #webapi_data_values } 

This section is about sending and reading data values.

    /api/dataValueSets

### Sending data values { #webapi_sending_data_values } 

To send data values you can make a POST request to the following resource.

```
POST /api/dataValueSets
```

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

> **Note**
>
> Any imported data value which is seen as unchanged will be ignored and the import summary will reflect this. An unchanged data value is classed as one which has the same value for all 3 of these properties:
> - value
> - comment
> - followUp

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
curl -d @datavalueset.xml "https://play.dhis2.org/demo/api/dataValueSets"
  -H "Content-Type:application/xml" -u admin:district
```

For sending JSON content you must set the content-type header
accordingly:

```bash
curl -d @datavalueset.json "https://play.dhis2.org/demo/api/dataValueSets"
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
curl -d @datavalueset.xml "https://play.dhis2.org/demo/api/dataValueSets"
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

The import process can be customized using a set of import parameters.

Table: Import parameters

| Parameter | Values (default first) | Description |
|---|---|---|
| dataElementIdScheme | uid &#124; name &#124; code &#124; attribute:ID | Property of the data element object to use to map the data values. |
| orgUnitIdScheme | uid &#124; name &#124; code &#124; attribute:ID | Property of the org unit object to use to map the data values. |
| attributeOptionComboIdScheme | uid &#124; name &#124; code&#124; attribute:ID | Property of the attribute option combo object to use to map the data values. |
| categoryOptionComboIdScheme | uid &#124; name &#124; code &#124; attribute:ID | Property of the category option combo object to use to map the data values. |
| dataSetIdScheme | uid &#124; name &#124; code&#124; attribute:ID | Property of the data set object to use to map the data values. |
| categoryIdScheme | uid &#124; name &#124; code&#124; attribute:ID | Property of the category object to use to map the data values (ADX only). |
| categoryOptionIdScheme | uid &#124; name &#124; code&#124; attribute:ID | Property of the category option object to use to map the data values (ADX only). |
| idScheme | uid &#124; name &#124; code&#124; attribute:ID | Property of any of the above objects if they are not specified, to use to map the data values. |
| preheatCache | false &#124; true | Indicates whether to preload metadata caches before starting to import data values, will speed up large import payloads with high metadata cardinality. |
| dryRun | false &#124; true | Whether to save changes on the server or just return the import summary. |
| importStrategy | CREATE &#124; UPDATE &#124; CREATE_AND_UPDATE &#124; DELETE | Save objects of all, new or update import status on the server. |
| skipExistingCheck | false &#124; true | Skip checks for existing data values. Improves performance. Only use for empty databases or when the data values to import do not exist already. |
| skipAudit | false &#124; true | Skip audit, meaning audit values will not be generated. Improves performance at the cost of ability to audit changes. Requires authority "F_SKIP_DATA_IMPORT_AUDIT". |
| async | false &#124; true | Indicates whether the import should be done asynchronous or synchronous. The former is suitable for very large imports as it ensures that the request does not time out, although it has a significant performance overhead. The latter is faster but requires the connection to persist until the process is finished. |
| force | false &#124; true | Indicates whether the import should be forced. Data import could be rejected for various reasons of data set locking for example due to approval, data input period, expiry days, etc. In order to override such locks and force data input one can use data import with force=true. However, one needs to be a \*superuser\* for this parameter to work. |
| dataSet | uid | Provide the data set ID for CSV import where the ID cannot be provided in the file itself |

All parameters are optional and can be supplied as query parameters in
the request URL like this:

    /api/dataValueSets?dataElementIdScheme=code&orgUnitIdScheme=name
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



Table: Value type requirements

| Value type | Requirements | Comment |
|---|---|---|
| BOOLEAN | true &#124; True &#124; TRUE &#124; false &#124; False &#124; FALSE &#124; 1 &#124; 0 &#124; t &#124; f &#124; | Used when the value is a boolean, true or false value. The import service does not care if the input begins with an uppercase or lowercase letter, or if it's all uppercase. |

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

  - Specific id schemes such as dataElementIdScheme or
    orgUnitIdScheme take precedence over the general idScheme.

  - If no explicit id scheme is defined, the default id scheme is `code`
    for ADX format, and `uid` for all other formats.

The following identifier schemes are available.

  - uid

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

    /api/dataValueSets?async=true

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

Table: CSV format of DHIS2

||||
|---|---|---|
| Column | Required | Description |
| Data element | Yes | Refers to ID by default, can also be name and code based on selected id scheme |
| Period | Yes | In ISO format |
| Org unit | Yes | Refers to ID by default, can also be name and code based on selected id scheme |
| Category option combo | No | Refers to ID |
| Attribute option combo | No | Refers to ID (from version 2.16) |
| Value | No | Data value |
| Stored by | No | Refers to username of user who entered the value |
| Last updated | No | Date in ISO format |
| Comment | No | Free text comment |
| Follow up | No | true or false |

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

    /api/dataSets/BfMAe6Itzgt/dataValueSet

The parameters you can use to further adjust the output are described
below:



Table: Data values query parameters

| Query parameter | Required | Description |
|---|---|---|
| period | No | Period to use, will be included without any checks. |
| orgUnit | No | Organisation unit to use, supports multiple orgUnits, both id and code can be used. |
| comment | No | Should comments be include, default: Yes. |
| orgUnitIdScheme | No | Organisation unit scheme to use, supports id &#124; code. |
| dataElementIdScheme | No | Data-element scheme to use, supports id &#124; code. |

### Reading data values { #webapi_reading_data_values } 

To read data values you can make a GET request to the following resource.

```
GET /api/dataValueSets
```

Data values can be retrieved in *XML*, *JSON*, *CSV*, and *ADX* format. Since we want to read data we will use the *GET* HTTP verb. We will also specify that we are
interested in the XML resource representation by including an `Accept` HTTP header with our request. The following query parameters are
available.

Table: Data value set query parameters

| Parameter | Description |
|---|---|
| dataSet | Data set identifier. Can be repeated any number of times. |
| dataElementGroup | Data element group identifier. Can be repeated any number of times (Not supported for ADX). |
| dataElement | Data element identifier. Can be repeated any number of times. |
| period | Period identifier in ISO format. Can be repeated any number of times. |
| startDate | Start date for the time span of the values to export. |
| endDate | End date for the time span of the values to export. |
| orgUnit | Organisation unit identifier. Can be repeated any number of times. |
| children | Whether to include the children in the hierarchy of the organisation units. Boolean value (default `false`)|
| orgUnitGroup | Organisation unit group identifier. Can be repeated any number of times. |
| attributeOptionCombo | Attribute option combo identifier. Can be repeated any number of times. |
| includeDeleted | Whether to include deleted data values. |
| lastUpdated | Include only data values which are updated since the given time stamp. |
| lastUpdatedDuration | Include only data values which are updated within the given duration. The format is <value\><time-unit\>, where the supported time units are "d" (days), "h" (hours), "m" (minutes) and "s" (seconds). |
| limit | The max number of results in the response. |
| dataElementIdScheme | Property of the data element object to use for data values in response. |
| orgUnitIdScheme | Property of the org unit object to use for data values in response. |
| categoryOptionComboIdScheme | Property of the category option combo to use for data values in response. |
| attributeOptionComboIdScheme | Property of the attribute option combo objects to use for data values in response. |
| dataSetIdScheme | Property of the data set object to use in the response. |
| categoryIdScheme | Property of the category object to use in the response (ADX only). |
| categoryOptionIdScheme | Property of the category option object to use in the response (ADX only). |
| idScheme | Property of any of the above objects if they are not specified, to use in the response. If not specified, the default idScheme for ADX is code, and for all other formats is uid. |
| inputOrgUnitIdScheme | Identifier property used for the provided `orgUnit` parameter values; `id` or `code` |
| inputDataSetIdScheme | Identifier property used for the provided `dataSet` parameter values; `id` or `code` |
| inputDataElementGroupIdScheme | Identifier property used for the provided `dataElementGroup` parameter values; `id` or `code` |
| inputDataElementIdScheme | Identifier property used for the provided `dataElement` parameter values; `id` or `code` |
| inputIdScheme | General identifier property used for all object types, specific identifier schemes will override the general scheme; `id` or `code` |
| compression | Whether to compress the response payload; `none`, `gzip` or `zip` |
| attachment | File name to use for the response, a non-blank value indicates rendering the response as an attachment. |

The following parameters from the list above are required:
- either dataSet or dataElementGroup (for ADX this must be dataSet)
- either period, both startDate and endDate, lastUpdated, or lastUpdatedDuration
- either orgUnit or orgUnitGroup

The following response formats are supported:

  - xml (application/xml)

  - json (application/json)

  - csv (application/csv)

  - adx (application/adx+xml)

Assuming that we have posted data values to DHIS2 according to the
previous section called *Sending data values* we can now put together
our request for a single data value set and request it using cURL:

```bash
curl "https://play.dhis2.org/demo/api/dataValueSets?dataSet=pBOMPrpg1QX&period=201401&orgUnit=DiszpKrYNg8"
  -H "Accept:application/xml" -u admin:district
```

We can also use the start and end dates query parameters to request a
larger bulk of data values. I.e. you can also request data values for
multiple data sets and org units and a time span in order to export
larger chunks of data. Note that the period query parameter takes
precedence over the start and end date parameters. An example looks like
this:

```bash
curl "https://play.dhis2.org/demo/api/dataValueSets?dataSet=pBOMPrpg1QX&dataSet=BfMAe6Itzgt
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

The response will look like this:

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

    /api/dataValueSets.json?dataSet=pBOMPrpg1QX&period=201401
      &orgUnit=DiszpKrYNg8&includeDeleted=true

You can also request data in CSV format like this:

    /api/dataValueSets.csv?dataSet=pBOMPrpg1QX&period=201401&orgUnit=DiszpKrYNg8

The response will look like this:

```csv
dataelement,period,orgunit,catoptcombo,attroptcombo,value,storedby,lastupdated,comment,flwup
f7n9E0hX8qk,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,12,system,2015-04-05T19:58:12.000,comment1,false
Ix2HsbDMLea,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,14,system,2015-04-05T19:58:12.000,comment2,false
eY5ehpbEsB7,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,16,system,2015-04-05T19:58:12.000,comment3,false
FTRrcoaog83,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,12,system,2014-03-02T21:45:05.519,comment4,false
```

Request data values in CSV format compressed with `gzip`:

```
/api/dataValueSets.csv?dataSet=pBOMPrpg1QX&period=202401&orgUnit=DiszpKrYNg8&compression=gzip
```

The response will be in compressed CSV format. The content can be uncompressed with the `gunzip` tool.

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

    POST /api/dataValues

The following query parameters are supported for this resource:

Table: Data values query parameters

| Query parameter | Required | Description |
|---|---|---|
| de | Yes | Data element identifier |
| pe | Yes | Period identifier |
| ou | Yes | Organisation unit identifier |
| co | No | Category option combo identifier, default will be used if omitted |
| cc | No (must be combined with cp) | Attribute category combo identifier |
| cp | No (must be combined with cc) | Attribute category option identifiers, separated with ; for multiple values |
| ds | No | Data set, to check if POST or DELETE is allowed for period and organisation unit. If specified, the data element must be assigned to this data set. If not specified, a data set containing the data element will be chosen to check if the operation is allowed. |
| value | No | Data value. For boolean values, the following will be accepted: true &#124; True &#124; TRUE &#124; false &#124; False &#124; FALSE &#124; 1 &#124; 0 &#124; t &#124; f &#124; |
| comment | No | Data comment |
| followUp | No | Follow up on data value, will toggle the current boolean value |

If any of the identifiers given are invalid, if the data value or
comment is invalid or if the data is locked, the response will contain
the *409 Conflict* status code and descriptive text message. If the
operation leads to a saved or updated value, *200 OK* will be returned.
An example of a request looks like this:

```bash
curl "https://play.dhis2.org/demo/api/dataValues?de=s46m5MS0hxu
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
curl "https://play.dhis2.org/demo/api/dataValues?de=s46m5MS0hxu&ou=DiszpKrYNg8
  &pe=201308&cc=dzjKKQq0cSO&cp=wbrDrL2aYEc;btOyqprQ9e8&value=26"
  -X POST -u admin:district
```

You can retrieve a data value with a request using the *GET* method. The
value, comment and followUp params are not applicable in this regard:

```bash
curl "https://play.dhis2.org/demo/api/dataValues?de=s46m5MS0hxu
  &pe=201301&ou=DiszpKrYNg8&co=Prlt0C1RF0s"
  -u admin:district
```

You can delete a data value with a request using the *DELETE* method.

### Sending individual data values as payload { #webapi_sending_individual_data_values_as_payload } 

You can send individual data values as a JSON payload using the following resource using `Content-Type: application/json`.

```
POST /api/dataValues
```

The resource will create a new data value or update a data value if it already exists. The JSON payload format is defined below.

```json
{
  "dataElement": "fbfJHSPpUQD",
  "categoryOptionCombo": "PT59n8BQbqM",
  "period": "202201",
  "orgUnit": "DiszpKrYNg8",
  "value": "10",
  "comment": "OK"
}
```

The endpoint supports specifying attribute option combos in a nested structure.

```json
{
  "dataElement": "BOSZApCrBni",
  "categoryOptionCombo": "TkDhg29x18A",
  "attribute": {
    "combo": "O4VaNks6tta",
    "options": [
      "C6nZpLKjEJr", "i4Nbp8S2G6A"
    ]
  },
  "dataSet": "lyLU2wR22tC",
  "period": "202201",
  "orgUnit": "DiszpKrYNg8",
  "value": "15",
  "comment": "Good"
}
```

The status code will be `201 Created` if the data value was successfully saved or updated, or `409 Conflict` if there was a validation error.

### Working with file data values { #datavalue_file } 

When dealing with data values which have a data element of type *file*
there is some deviation from the method described above. These data
values are special in that the contents of the value is a UID reference
to a *FileResource* object instead of a self-contained constant. These
data values will behave just like other data values which store text
content, but should be handled differently in order to produce
meaningful input and output.

There are two methods of storing file resource data values.

* Upload the file to the `/api/dataValues/file` endpoint as
  described in the file resource section.  This works on versions 2.36 and later.

* If you are writing code that needs to be compatible
  with versions of DHIS2 before 2.36, then the process is:

1.  Upload the file to the `/api/fileResources` endpoint as described
    in the file resource section.

2.  Retrieve the `id` property of the returned file resource.

3.  Store the retrieved identifier using the `value` property of the data value using any
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
is the functionality to read and write ADX formatted data, i.e. what is
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

### The ADX root element

The ADX root element has only one mandatory attribute, which is the
*exported* timestamp. In common with other ADX elements, the schema is
extensible in that it does not restrict additional application specific
attributes.

### The ADX group element

Unlike dxf2, ADX requires that the datavalues are grouped according to
orgUnit, period and dataSet. The example above shows a data report for
the "(TB/HIV) VCCT" dataset from the online demo database. This example
is using codes as identifiers instead of dhis2 uids. Codes are the
preferred form of identifier when using ADX.

The orgUnit, period and dataSet attributes are mandatory in ADX. The
group element may contain additional attributes. In our DHIS2
implementation any additional attributes are simply passed through to
the underlying importer. This means that all attributes which currently
have meaning in dxf2 (such as completeDate in the example above) can
continue to be used in ADX and they will be processed in the same way.

A significant difference between ADX and dxf2 is in the way that periods
are encoded. ADX makes strict use of ISO8601 and encodes the reporting
period as (date|datetime)/(duration). So the period in the example above
is a period of 1 month (P1M) starting on 2015-06-01. So it is the data
for June 2015. The notation is a bit more verbose, but it is very
flexible and allows us to support all existing period types in DHIS2

### ADX period definitions

Periods begin with the date in which the duration begins, followed by
a "/" and then the duration notation as noted in the table. The
following table details all of the DHIS2 period types and how they are
represented in ADX, along with examples.

Table: ADX Periods

| Period type | Duration notation | Example(s) | Duration(s) |
|---|---|---|---|
| Daily | P1D | 2017-10-01/P1M | Oct 01 2017 |
| Weekly | P7D | 2017-10-02/P7D | Oct 02 2017-Oct 08-2017 |
| Weekly Wednesday | P7D | 2017-10-04/P7D | Oct 04 2017-Oct 10-2017 |
| Weekly Thursday | P7D | 2017-10-05/P7D | Oct 05 2017-Oct 011-2017 |
| Weekly Saturday | P7D | 2017-10-07/P7D | Oct 07 2017-Oct 13-2017 |
| Weekly Sunday | P7D | 2017-10-01/P7D | Oct 01 2017-Oct 07-2017 |
| Bi-weekly | P14D | 2017-10-02/P14D | Oct 02 2017-Oct 15 2017 |
| Monthly | P1M | 2017-10-01/P1M | Oct 01 2017-Oct 31 2017 |
| Bi-monthly | P2M | 2017-11-01/P2M | Nov 01 2017-Dec 31 2017 |
| Quarterly | P3M | 2017-09-01/P3M | Sep 01 2017-Dec 31 2017 |
| Six-monthly | P6M | 2017-01-01/P6M<br>2017-07-01/P6M | Jan 01 2017-Jun 30 2017<br>Jul 01 2017-Dec 31 2017 |
| Six-monthly April | P6M | 2017-04-01/P6M<br>2017-10-01/P6M | Apr 01 2017-Sep 30 2017<br>Oct 01 2017-Mar 31 2018 |
| Six-monthly November | P6M | 2017-10-01/P6M<br>2018-05-01/P6M | Nov 01 2017-Apr 30 2018<br>May 01 2018-Oct 31 2018 |
| Yearly | P1Y | 2017-01-01/P1Y | Jan 01 2017-Dec 31 2017 |
| Financial April | P1Y | 2017-04-01/P1Y | April 1 2017-Mar 31 2018 |
| Financial July | P1Y | 2017-07-01/P1Y | July 1 2017-June 30 2018 |
| Financial October | P1Y | 2017-10-01/P1Y | Oct 01 2017-Sep 30 2018 |
| Financial November | P1Y | 2017-11-01/P1Y | Nov 01 2017-Oct 31 2018 |

### ADX Data values

The dataValue element in ADX is very similar to its equivalent in DXF.
The mandatory attributes are *dataElement* and *value*. The *orgUnit* and
*period* attributes don't appear in the dataValue as they are required
at the *group* level.

The most significant difference is the way that disaggregation is
represented. DXF uses the categoryOptionCombo to indicate the disaggregation
of data. In ADX the disaggregations (e.g. AGE_GROUP and SEX) are
expressed explicitly as attributes. If you use `code` as the id scheme for
`category`, not that you must assign a code to all the categories used for
dataElements in the dataSet, and further, that code must be of a form
which is suitable for use as an XML attribute. The exact constraint on
an XML attribute name is described in the W3C XML standard - in practice,
this means no spaces, no non-alphanumeric characters other than '_' and
it may not start with a letter. The example above shows examples of
'good' category codes ('GENDER' and 'HIV_AGE'). The same restrictions
apply if you use `name` or `attribute` as id schemes.

In ADX, only category identifiers are used as XML attributes; identifiers
for other metadata types do not have to be usalbe as XML attributes.
Note that this syntax is not enforced by DHIS2 when you are assigning
names, codes, or DHIS2 attributes, but you will get an informative error
message if you try to import ADX data and the category identifiers are
either not assigned or not suitable.

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
DHIS2 implementation of ADX will check for the existence of a
*categoryOptionCombo* attribute and, if it exists, it will use that in
preference to exploded dimension attributes. Similarly, an
*attributeOptionCombo* attribute on the *group* element will be
processed in the legacy way. Otherwise, the attributeOptionCombo can be
treated as exploded categories just as on the *dataValue*.

In the simple example above, each of the dataElements in the dataSet
have the same dimensionality (categorycombo) so the data is neatly
rectangular. This need not be the case. dataSets may contain
dataElements with different categoryCombos, resulting in a
*ragged-right* ADX data message (i.e. values for different dataElements
may have different numbers of categories.)

### Importing ADX data

DHIS2 exposes an endpoint for POST ADX data at `/api/dataValueSets`
using *application/xml+adx* as content type. So, for example, the
following curl command can be used to POST the example data above to the
DHIS2 demo server:

```bash
curl -u admin:district -X POST -H "Content-Type: application/adx+xml"
  -d @data.xml "https://play.dhis2.org/demo/api/dataValueSets?dataElementIdScheme=code&orgUnitIdScheme=code"
```

Note the query parameters are the same as are used with DXF data. The
ADX endpoint should interpret all the existing DXF parameters with the
same semantics as DXF.

### Exporting ADX data

DHIS2 exposes an endpoint to GET ADX data sets at `/api/dataValueSets`
using *application/xml+adx* as the accepted content type. So, for
example, the following curl command can be used to retrieve the ADX
data:

```bash
curl -u admin:district -H "Accept: application/adx+xml"
 "https://play.dhis2.org/demo/api/dataValueSets?dataValueSets?orgUnit=M_CLINIC&dataSet=MALARIA&period=201501"
```

Note the query parameters are the same as are used with DXF data. An
important difference is that the identifiers for dataSet and orgUnit may
be either uids or codes.

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

To bulk update data values for follow-up use:

    PUT /api/dataValues/followups

with `JSON` payload:

```json
{
  "values": [
    {
      "dataElement": "s46m5MS0hxu",
      "period": "202005",
      "orgUnit": "DiszpKrYNg8",
      "categoryOptionCombo": "psbwp3CQEhs",
      "attributeOptionCombo": "HllvX50cXC0",
      "followup": true
    }
  ]
}
```

Each item of the bulk update has the same fields and requirements as the single
update endpoint.

Bulk update equally confirms with a `200 OK` on success or returns a 
`409 Conflict` in case of input errors.
