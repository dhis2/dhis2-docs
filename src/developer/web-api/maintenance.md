# Maintenance

## Resource and analytics tables { #webapi_generating_resource_analytics_tables } 

DHIS2 features a set of generated database tables which are used as
a basis for various system functionality. These tables can be executed
immediately or scheduled to be executed at regular intervals through the
user interface. They can also be generated through the Web API as
explained in this section. This task is typically one for a system
administrator and not consuming clients.

The resource tables are used internally by the DHIS2 application for
various analysis functions. These tables are also valuable for users
writing advanced SQL reports. They can be generated with a POST or PUT
request to the following URL:

    /api/33/resourceTables

The analytics tables are optimized for data aggregation and used
currently in DHIS2 for the pivot table module. The analytics tables can
be generated with a POST or PUT request to:

    /api/33/resourceTables/analytics



Table: Analytics tables optional query parameters

| Query parameter | Options | Description |
|---|---|---|
| skipResourceTables | false &#124; true | Skip generation of resource tables |
| skipAggregate | false &#124; true | Skip generation of aggregate data and completeness data |
| skipEvents | false &#124; true | Skip generation of event data |
| skipEnrollment | false &#124; true | Skip generation of enrollment data |
| skipOrgUnitOwnership | false &#124; true | Skip generation of organization unit ownership data |
| lastYears | integer | Number of last years of data to include |

> **Note**
>
> lastYears=0 means latest or continuous analytics, as defined in
[Continuous analytics table](#scheduling_continuous_analytics_table).


"Data Quality" and "Data Surveillance" can be run through the monitoring
task, triggered with the following endpoint:

    /api/33/resourceTables/monitoring

This task will analyse your validation rules, find any violations and
persist them as validation results.

These requests will return immediately and initiate a server-side
process.

## Maintenance { #webapi_maintenance } 

To perform maintenance you can interact with the *maintenance* resource. You should use *POST* or *PUT* as a method for requests. The following methods are available.

Analytics tables clear will drop all analytics tables.

    POST PUT /api/maintenance/analyticsTablesClear

Analytics table analyze will collects statistics about the contents of analytics tables in the database.

    POST PUT /api/maintenance/analyticsTablesAnalyze

Expired invitations clear will remove all user account invitations which
have expired.

    POST PUT /api/maintenance/expiredInvitationsClear

Period pruning will remove periods which are not linked to any data
values.

    POST PUT /api/maintenance/periodPruning

Zero data value removal will delete zero data values linked to data
elements where zero data is defined as not significant:

    POST PUT /api/maintenance/zeroDataValueRemoval

Soft deleted data value removal will permanently delete soft deleted data values.

    POST PUT /api/maintenance/softDeletedDataValueRemoval

Soft deleted program stage instance removal will permanently delete soft deleted events.

    POST PUT /api/maintenance/softDeletedProgramStageInstanceRemoval

Soft deleted program instance removal will permanently delete soft deleted enrollments.

    POST PUT /api/maintenance/softDeletedProgramInstanceRemoval

Soft deleted tracked entity instance removal will permanently delete soft deleted tracked entity instances.

    POST PUT /api/maintenance/softDeletedTrackedEntityInstanceRemoval

Drop SQL views will drop all SQL views in the database. Note that it will not delete the DHIS2 SQL view entities.

    POST PUT /api/maintenance/sqlViewsDrop

Create SQL views will recreate all SQL views in the database.

    POST PUT /api/maintenance/sqlViewsCreate

Category option combo update will remove obsolete and generate missing category option combos for all category combinations.

    POST PUT /api/maintenance/categoryOptionComboUpdate

It is also possible to update category option combos for a single category combo using the following endpoint.

    POST PUT /api/maintenance/categoryOptionComboUpdate/categoryCombo/<category-combo-uid>

Cache clearing will clear the application Hibernate cache and the analytics partition caches.

    POST PUT /api/maintenance/cacheClear

Org unit paths update will re-generate the organisation unit path property. This can be useful e.g. if you imported org units with SQL.

    POST PUT /api/maintenance/ouPathsUpdate

Data pruning will remove complete data set registrations, data approvals, data value audits and data values, in this case for an organisation unit.

    POST PUT /api/maintenance/dataPruning/organisationUnits/<org-unit-id>

Data pruning for data elements, which will remove data value audits and data values.

    POST PUT /api/maintenance/dataPruning/dataElements/<data-element-uid>

Metadata validation will apply all metadata validation rules and return the result of the operation.

    POST PUT /api/metadataValidation

App reload will refresh the DHIS2 managed cache of installed apps by reading from the file system.

    POST PUT /api/appReload

Maintenance operations are supported in a batch style with a POST request to the api/maintenance resource where the operations are supplied as query parameters:

    POST PUT /api/maintenance?analyticsTablesClear=true&expiredInvitationsClear=true
      &periodPruning=true&zeroDataValueRemoval=true&sqlViewsDrop=true&sqlViewsCreate=true
      &categoryOptionComboUpdate=true&cacheClear=true&ouPathsUpdate=true

## System info { #webapi_system_resource } 

The system resource provides you with convenient information and
functions. The system resource can be found at */api/system*.

### Generate identifiers { #webapi_system_resource_generate_identifiers } 

To generate valid, random DHIS2 identifiers you can do a GET request to
this resource:

    /api/33/system/id?limit=3

The *limit* query parameter is optional and indicates how many
identifiers you want to be returned with the response. The default is to
return one identifier. The response will contain a JSON object with an
array named codes, similar to this:

```json
{
  "codes": [
    "Y0moqFplrX4",
    "WI0VHXuWQuV",
    "BRJNBBpu4ki"
  ]
}
```

The DHIS2 UID format has these requirements:

  - 11 characters long.

  - Alphanumeric characters only, ie. alphabetic or numeric characters
    (A-Za-z0-9).

  - Start with an alphabetic character (A-Za-z).

### View system information { #webapi_system_resource_view_system_information } 

To get information about the current system you can do a GET request to
this URL:

    /api/33/system/info

JSON and JSONP response formats are supported. The system info response
currently includes the below properties.

```json
{
  "contextPath": "http://yourdomain.com",
  "userAgent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/29.0.1547.62",
  "calendar": "iso8601",
  "dateFormat": "yyyy-mm-dd",
  "serverDate": "2021-01-05T09:16:03.548",
  "serverTimeZoneId": "Etc/UTC",
  "serverTimeZoneDisplayName": "Coordinated Universal Time",
  "version": "2.13-SNAPSHOT",
  "revision": "11852",
  "buildTime": "2013-09-01T21:36:21.000+0000",
  "serverDate": "2013-09-02T12:35:54.311+0000",
  "environmentVariable": "DHIS2_HOME",
  "javaVersion": "1.7.0_06",
  "javaVendor": "Oracle Corporation",
  "javaIoTmpDir": "/tmp",
  "javaOpts": "-Xms600m -Xmx1500m -XX:PermSize=400m -XX:MaxPermSize=500m",
  "osName": "Linux",
  "osArchitecture": "amd64",
  "osVersion": "3.2.0-52-generic",
  "externalDirectory": "/home/dhis/config/dhis2",
  "databaseInfo": {
    "type": "PostgreSQL",
    "name": "dhis2",
    "user": "dhis",
    "spatialSupport": false
  },
  "memoryInfo": "Mem Total in JVM: 848 Free in JVM: 581 Max Limit: 1333",
  "cpuCores": 8
}
```

> **Note**
>
> If the user requesting this resource does not have full authority then only properties which are not considered sensitive will be included.

To get information about the system context only, i.e. `contextPath` and
`userAgent`, you can make a GET request to the below URL. JSON and
JSONP response formats are supported:

    /api/33/system/context

### Check if username and password combination is correct { #webapi_system_resource_check_username_password } 

To check if some user credentials (a username and password combination)
is correct you can make a *GET* request to the following resource using
*basic authentication*:

    /api/33/system/ping

You can detect the outcome of the authentication by inspecting the *HTTP
status code* of the response header. The meanings of the possible status
codes are listed below. Note that this applies to Web API requests in
general.



Table: HTTP Status codes

| HTTP Status code | Description | Outcome |
|---|---|---|
| 200 | OK | Authentication was successful |
| 302 | Found | No credentials were supplied with the request - no authentication took place |
| 401 | Unauthorized | The username and password combination was incorrect - authentication failed |

### View asynchronous task status { #webapi_system_resource_view_async_task_status } 

Tasks which often take a long time to complete can be performed
asynchronously. After initiating an async task you can poll the status
through the `system/tasks` resource by supplying the task category and
the task identifier of interest.

When polling for the task status you need to authenticate as the same
user which initiated the task. The following task categories are
supported:



Table: Task categories

| Identifier | Description |
|---|---|
| ANALYTICS_TABLE | Generation of the analytics tables. |
| RESOURCE_TABLE | Generation of the resource tables. |
| MONITORING | Processing of data surveillance/monitoring validation rules. |
| DATAVALUE_IMPORT | Import of data values. |
| EVENT_IMPORT | Import of events. |
| ENROLLMENT_IMPORT | Import of enrollments. |
| TEI_IMPORT | Import of tracked entity instances. |
| METADATA_IMPORT | Import of metadata. |
| DATA_INTEGRITY | Processing of data integrity checks. |

Each asynchronous task is automatically assigned an identifier which can
be used to monitor the status of the task. This task identifier is
returned by the API when you initiate an async task through the various
async-enabled endpoints.

#### Monitoring a task

You can poll the task status through a GET request to the system tasks
resource like this:

    /api/33/system/tasks/{task-category-id}/{task-id}

An example request may look like this:

    /api/33/system/tasks/DATAVALUE_IMPORT/j8Ki6TgreFw

The response will provide information about the status, such as the
notification level, category, time and status. The *completed* property
indicates whether the process is considered to be complete.

```json
[{
  "uid": "hpiaeMy7wFX",
  "level": "INFO",
  "category": "DATAVALUE_IMPORT",
  "time": "2015-09-02T07:43:14.595+0000",
  "message": "Import done",
  "completed": true
}]
```

#### Monitoring all tasks for a category

You can poll all tasks for a specific category through a GET request to
the system tasks resource:

    /api/33/system/tasks/{task-category-id}

An example request to poll for the status of data value import tasks
looks like this:

    /api/33/system/tasks/DATAVALUE_IMPORT

#### Monitor all tasks

You can request a list of all currently running tasks in the system with
a GET request to the system tasks resource:

    /api/33/system/tasks

The response will look similar to this:

```json
[{
  "EVENT_IMPORT": {},
  "DATA_STATISTICS": {},
  "RESOURCE_TABLE": {},
  "FILE_RESOURCE_CLEANUP": {},
  "METADATA_IMPORT": {},
  "CREDENTIALS_EXPIRY_ALERT": {},
  "SMS_SEND": {},
  "MOCK": {},
  "ANALYTICSTABLE_UPDATE": {},
  "COMPLETE_DATA_SET_REGISTRATION_IMPORT": {},
  "DATAVALUE_IMPORT": {},
  "DATA_SET_NOTIFICATION": {},
  "DATA_INTEGRITY": {
    "OB1qGRlCzap": [{
      "uid": "LdHQK0PXZyF",
      "level": "INFO",
      "category": "DATA_INTEGRITY",
      "time": "2018-03-26T15:02:32.171",
      "message": "Data integrity checks completed in 38.31 seconds.",
      "completed": true
    }]
  },
  "PUSH_ANALYSIS": {},
  "MONITORING": {},
  "VALIDATION_RESULTS_NOTIFICATION": {},
  "REMOVE_EXPIRED_RESERVED_VALUES": {},
  "DATA_SYNC": {},
  "SEND_SCHEDULED_MESSAGE": {},
  "DATAVALUE_IMPORT_INTERNAL": {},
  "PROGRAM_NOTIFICATIONS": {},
  "META_DATA_SYNC": {},
  "ANALYTICS_TABLE": {},
  "PREDICTOR": {}
}]
```

### View asynchronous task summaries

The task summaries resource allows you to retrieve a summary of an
asynchronous task invocation. You need to specify the category and
optionally the identifier of the task. The task identifier can be
retrieved from the response of the API request which initiated the
asynchronous task.

To retrieve the summary of a specific task you can issue a request to:

    /api/33/system/taskSummaries/{task-category-id}/{task-id}

An example request might look like this:

    /api/33/system/taskSummaries/DATAVALUE_IMPORT/k72jHfF13J1

The response will look similar to this:

```json
{
  "responseType": "ImportSummary",
  "status": "SUCCESS",
  "importOptions": {
    "idSchemes": {},
    "dryRun": false,
    "async": true,
    "importStrategy": "CREATE_AND_UPDATE",
    "reportMode": "FULL",
    "skipExistingCheck": false,
    "sharing": false,
    "skipNotifications": false,
    "datasetAllowsPeriods": false,
    "strictPeriods": false,
    "strictCategoryOptionCombos": false,
    "strictAttributeOptionCombos": false,
    "strictOrganisationUnits": false,
    "requireCategoryOptionCombo": false,
    "requireAttributeOptionCombo": false,
    "skipPatternValidation": false
  },
  "description": "Import process completed successfully",
  "importCount": {
    "imported": 0,
    "updated": 431,
    "ignored": 0,
    "deleted": 0
  },
  "dataSetComplete": "false"
}
```

You might also retrieve import summaries for multiple tasks of a
specific category with a request like
this:

    /api/33/system/taskSummaries/{task-category-id}

### Get appearance information { #webapi_system_resource_get_appearance_information } 

You can retrieve the available flag icons in JSON format with a GET
request:

    /api/33/system/flags

You can retrieve the available UI styles in JSON format with a GET
request:

    /api/33/system/styles
    
    
## Trigram Index Summary

Trigram indexes can be created using Tracker Search Optimization jobs. It is useful to know which tracked entity attributes are indexed and which ones are not. The following API can be used to get a summary of the trigram index status. The API supports field selection and filtering using the field query parameter.

The attributes corresponding to the property "indexedAttributes" are currently indexed in the system. The attributes corresponding to the property "indexableAttributes" are not indexed currently but are candidates for creating indexes if required. The attributes corresponding to the property "obsoleteIndexedAttributes" are indexed in the system, but those indexes are obsolete due to changes in the attribute configuration which do not qualify them as indexable anymore.

```
GET /api/39/trigramSummary
```

A sample JSON response looks like this:

```json
{
	"indexedAttributes": [{
		"displayName": "First name",
		"id": "w75KJ2mc4zz"
	}, {
		"displayName": "Last name",
		"id": "zDhUuAYrxNC"
	}],
	"indexableAttributes": [{
		"displayName": "Phone number",
		"id": "P2cwLGskgxn"
	}],
	"obsoleteIndexedAttributes": [{
		"displayName": "TB identifier",
		"id": "xs8A6tQJY0s"
	}, {
		"displayName": "Provider ID",
		"id": "DODgdr5Oo2v"
	}]
}
```

## Cluster info

When DHIS 2 is set up in a cluster configuration, it is useful to know which node in the cluster acts as the leader of the cluster. The following API can be used to get the details of the leader node instance. The API supports both JSON and XML formats.

```
GET /api/36/cluster/leader
```

A sample JSON response looks like this:

```json
{
  "leaderNodeId": "play-dhis2-org-dev",
  "leaderNodeUuid": "d386e46b-26d4-4937-915c-025eb99c8cad",
  "currentNodeId": "play-dhis2-org-dev",
  "currentNodeUuid": "d386e46b-26d4-4937-915c-025eb99c8cad",
  "leader": true
}
```

## Min-max data elements { #webapi_min_max_data_elements } 

The min-max data elements resource allows you to set minimum and maximum
value ranges for data elements. It is unique by the combination of
organisation unit, data element and category option combo.

    /api/minMaxDataElements



Table: Min-max data element data structure

| Item | Description | Data type |
|---|---|---|
| source | Organisation unit identifier | String |
| dataElement | Data element identifier | String |
| optionCombo | Data element category option combo identifier | String |
| min | Minimum value | Integer |
| max | Maximum value | Integer |
| generated | Indicates whether this object is generated by the system (and not set manually). | Boolean |

You can retrieve a list of all min-max data elements from the following
resource:

    GET /api/minMaxDataElements.json

You can filter the response like this:

    GET /api/minMaxDataElements.json?filter=dataElement.id:eq:UOlfIjgN8X6
    
    GET /api/minMaxDataElements.json?filter=dataElement.id:in:[UOlfIjgN8X6,xc8gmAKfO95]

The filter parameter for min-max data elements supports two operators:
eq and in. You can also use the `fields` query parameter.

    GET /api/minMaxDataElements.json?fields=:all,dataElement[id,name]

### Add/update min-max data element { #webapi_add_update_min_max_data_element } 

To add a new min-max data element, use POST request to:

    POST /api/minMaxDataElements.json

The JSON content format looks like this:

```json
{
  "min": 1,
  "generated": false,
  "max": 100,
  "dataElement": {
    "id": "UOlfIjgN8X6"
   },
  "source": {
    "id": "DiszpKrYNg8"
  },
  "optionCombo": {
    "id": "psbwp3CQEhs"
  }
}
```

If the combination of data element, organisation unit and category
option combo exists, the min-max value will be updated.

### Delete min-max data element { #webapi_delete_min_max_data_element } 

To delete a min-max data element, send a request with DELETE method:

    DELETE /api/minMaxDataElements.json

The JSON content is in similar format as above:

```json
{
  "min": 1,
  "generated": false,
  "max": 100,
  "dataElement": {
	"id": "UOlfIjgN8X6"
   },
  "source": {
	"id": "DiszpKrYNg8"
  },
  "optionCombo": {
	"id": "psbwp3CQEhs"
  }
}
```

## Lock exceptions { #webapi_lock_exceptions }

The lock exceptions resource allows you to open otherwise locked data
sets for data entry for a specific data set, period and organisation
unit. You can read lock exceptions from the following resource:

    /api/lockExceptions

To create a new lock exception you can use a POST request and specify
the data set, period and organisation unit:

    POST /api/lockExceptions?ds=BfMAe6Itzgt&pe=201709&ou=DiszpKrYNg8

To delete a lock exception you can use a similar request syntax with a
DELETE request:

    DELETE /api/lockExceptions?ds=BfMAe6Itzgt&pe=201709&ou=DiszpKrYNg8

## Data summary { #webapi_data_statistics}

The data summary resource provides some metrics about the database and level of system usage. The metrics include: 

    - Number of object types (dashboards, data elements, etc)
    - Number of user account invitations
    - Number of data values updated by day
    - Number of events updated by day
    - Number of users logged in by day
    - Number of enrollment by day

Data statistics can be accessed with a GET request to :

    GET /api/dataSummary

A JSON response similar to the one below is provided:

```json
{
    "objectCounts": {
        "indicator": 77,
        "trackedEntity": 73125,
        "visualization": 292,
        "period": 384,
        "programStageInstance": 372987,
        "organisationUnit": 1332,
        "validationRule": 37,
        "dataValue": 4934284,
        "dataElement": 1037,
        "program": 14,
        "organisationUnitGroup": 18,
        "enrollment": 73133,
        "trackedEntityInstance": 73125,
        "programInstance": 73133,
        "indicatorType": 5,
        "eventVisualization": 50,
        "event": 372987,
        "indicatorGroup": 17,
        "map": 91,
        "user": 131,
        "userGroup": 34,
        "dataSet": 26,
        "dataElementGroup": 84,
        "dashboard": 28
    },
    "activeUsers": {
        "0": 2,
        "1": 2,
        "2": 2,
        "7": 2,
        "30": 3
    }
    ....
}
```
As can been seen, various summary statistics are included in the response.Object counts refer to the current
number of various metadata objects in the system. The `activeUsers`, `userInvitations`, `dataValueCount` and `eventCount` all represent
values on various days. `userInvitations` provides the number
of expired and all invitations currently in the system. The `system`
object provides various information related to to the version, revision, build time, system ID (a UUID) and the current server date.

## Data summary Prometheus metrics { #webapi_data_statistics_prometheus }

In order to support the long-term monitoring of DHIS2 instances, a special endpoint is available
which outputs the data summary information in the [Prometheus text exposition format](https://prometheus.io/docs/instrumenting/exposition_formats/). This can be fetched from the server by making
a GET request to :
    GET api/dataSummary/metrics

An example of the output is provided below

```text
# HELP data_summary_object_counts Count of metadata objects
# TYPE data_summary_object_counts gauge
data_summary_object_counts{type="indicator"} 77
data_summary_object_counts{type="trackedEntity"} 73125
data_summary_object_counts{type="visualization"} 292
data_summary_object_counts{type="period"} 384
data_summary_object_counts{type="programStageInstance"} 373597
```

This endpoint provides essentially the same information as the `api/dataSummary` endpoint, but in a format which
Prometheus is capable of scraping and importing. Most of the metrics represent object counts, such as the current
number of data elements, organization units, etc.

The build information metric is explained in more detail below. 

```
# HELP data_summary_build_info Build information
# TYPE data_summary_build_info gauge
data_summary_build_info{version="2.42-SNAPSHOT", commit="932e552"} 1737621197
```

This metric represents the current version and commit hash of the server. The metric itself is an integer
and represents the build time as seconds since the epoch. This metric can be easily converted or to
an actual date when needed.

>**Note**
>On systems with large amounts of data, the `dataValueCount` and `eventCount` metrics may take a long time to compute due
>to the large number of records in the database. Users should thus use caution if scraping metrics from this endpoint
>as it may impact the performance of the server. It should generally be sufficient to scrape this endpoint once per day, since
>this will provide a good overview of the system usage and performance.