# Sharing

## Sharing { #webapi_sharing } 

The sharing solution allows you to share most objects in the system with
specific user groups and to define whether objects should be publicly
accessible or private. To get and set sharing status for objects you can
interact with the *sharing* resource.

    /api/33/sharing

### Get sharing status { #webapi_get_sharing_status } 

To request the sharing status for an object use a GET request to:

    /api/33/sharing?type=dataElement&id=fbfJHSPpUQD

The response looks like the below.

```json
{
  "meta": {
    "allowPublicAccess": true,
    "allowExternalAccess": false
  },
  "object": {
    "id": "fbfJHSPpUQD",
    "name": "ANC 1st visit",
    "publicAccess": "rw------",
    "externalAccess": false,
    "user": {},
    "userGroupAccesses": [
      {
        "id": "hj0nnsVsPLU",
        "access": "rw------"
      },
      {
        "id": "qMjBflJMOfB",
        "access": "r-------"
      }
    ]
  }
}
```

### Set sharing status { #webapi_set_sharing_status } 

You can define the sharing status for an object using the same URL with
a POST request, where the payload in JSON format looks like this:

```json
{
  "object": {
    "publicAccess": "rw------",
    "externalAccess": false,
    "user": {},
    "userGroupAccesses": [
      {
        "id": "hj0nnsVsPLU",
        "access": "rw------"
      },
      {
        "id": "qMjBflJMOfB",
        "access": "r-------"
      }
    ]
  }
}
```

In this example, the payload defines the object to have read-write
public access, no external access (without login), read-write access to
one user group and read-only access to another user group. You can
submit this to the sharing resource using curl:

```bash
curl -d @sharing.json "localhost/api/33/sharing?type=dataElement&id=fbfJHSPpUQD"
  -H "Content-Type:application/json" -u admin:district
```

## Scheduling { #webapi_scheduling } 

DHIS2 allows for scheduling of jobs of various types. Each type of job has different properties for configuration, giving you finer control over how jobs are run. In addition, you can configure the same job to run with different configurations and at different intervals if required.

<table>
<caption>Main properties</caption>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
<th>Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>Name of the job.</td>
<td>String</td>
</tr>
<tr class="even">
<td>cronExpression</td>
<td>The cron expression which defines the interval for when the job should run.</td>
<td>String (Cron expression)</td>
</tr>
<tr class="odd">
<td>jobType</td>
<td>The job type represent which task is run. In the next table, you can get an overview of existing job types. Each job type can have a specific set of parameters for job configuration.</td>
<td>String (Enum)</td>
</tr>
<tr class="even">
<td>jobParameters</td>
<td>Job parameters, if applicable for job type.</td>
<td>(See list of job types)</td>
</tr>
<tr class="odd">
<td>enabled</td>
<td>A job can be added to the system without it being scheduled by setting `enabled` to false in the JSON payload. Use this if you want to temporarily stop scheduling for a job, or if a job configuration is not complete yet.</td>
<td>Boolean</td>
</tr>
</tbody>
</table>

<table>
<caption>Available job types</caption>
<thead>
<tr class="header">
<th>Job type</th>
<th>Parameters</th>
<th>Param(Type:Default)</th>
</tr>
</thead>
<tbody>
<tr>
<td>DATA_INTEGRITY</td>
<td>NONE</td>
<td></td>
</tr>
<tr>
<td>ANALYTICS_TABLE</td>
<td><ul>
<li><p>lastYears: Number of years back to include</p></li>
<li><p>skipTableTypes: Skip generation of tables</p><p>Possible values: DATA_VALUE, COMPLETENESS, COMPLETENESS_TARGET, ORG_UNIT_TARGET, EVENT, ENROLLMENT, VALIDATION_RESULT</p></li>
<li><p>skipResourceTables: Skip generation of resource tables</p></li>
</ul></td>
<td><ul>
<li><p>lastYears (int:0)</p></li>
<li><p>skipTableTypes (Array of String (Enum):None )</p></li>
<li><p>skipResourceTables (Boolean)</p></li>
</ul></td>
</tr>
<tr>
<td>CONTINUOUS_ANALYTICS_TABLE</td>
<td><ul>
<li><p>fullUpdateHourOfDay: Hour of day for full update of analytics tables (0-23)</p></li>
<li><p>lastYears: Number of years back to include</p></li>
<li><p>skipTableTypes: Skip generation of tables</p><p>Possible values: DATA_VALUE, COMPLETENESS, COMPLETENESS_TARGET, ORG_UNIT_TARGET, EVENT, ENROLLMENT, VALIDATION_RESULT</p></li>
<li><p>skipResourceTables: Skip generation of resource tables</p></li>
</ul></td>
<td><ul>
<li><p>lastYears (int:0)</p></li>
<li><p>skipTableTypes (Array of String (Enum):None )</p></li>
<li><p>skipResourceTables (Boolean)</p></li>
</ul></td>
</tr>
<tr>
<td>DATA_SYNC</td>
<td>NONE</td>
<td></td>
</tr>
<tr >
<td>META_DATA_SYNC</td>
<td>NONE</td>
<td></td>
</tr>
<tr>
<td>SEND_SCHEDULED_MESSAGE</td>
<td>NONE</td>
<td></td>
</tr>
<tr>
<td>PROGRAM_NOTIFICATIONS</td>
<td>NONE</td>
<td></td>
</tr>
<tr>
<td>MONITORING (Validation rule analysis)</td>
<td><ul>
<li><p>relativeStart: A number related to date of execution which resembles the start of the period to monitor</p></li>
<li><p>relativeEnd: A number related to date of execution which resembles the end of the period to monitor</p></li>
<li><p>validationRuleGroups: Validation rule groups(UIDs) to include in job</p></li>
<li><p>sendNotification: Set &quot;true&quot; if job should send notifications based on validation rule groups</p></li>
<li><p>persistsResults: Set &quot;true&quot; if job should persist validation results</p></li>
</ul></td>
<td><ul>
<li><p>relativeStart (int:0)</p></li>
<li><p>relativeEnd (int:0)</p></li>
<li><p>validationRuleGroups (Array of String (UIDs):None )</p></li>
<li><p>sendNotification (Boolean:false)</p></li>
<li><p>persistsResults (Boolean:false)</p></li>
</ul></td>
</tr>
<tr>
<td>PUSH_ANALYSIS</td>
<td><ul>
<li><p>pushAnalysis: The uid of the push analysis you want to run</p></li>
</ul></td>
<td><ul>
<li><p>pushAnalysis (String:None)</p></li>
</ul></td>
</tr>
<tr>
<td>PREDICTOR</td>
<td><ul>
<li><p>relativeStart: A number related to date of execution which resembles the start of the period to monitor</p></li>
<li><p>relativeEnd: A number related to date of execution which resembles the start of the period to monitor</p></li>
<li><p>predictors: Predictors(UIDs) to include in job</p></li>
</ul></td>
<td><ul>
<li><p>relativeStart (int:0)</p></li>
<li><p>relativeEnd (int:0)</p></li>
<li><p>predictors (Array of String (UIDs):None )</p></li>
</ul></td>
</tr>
</tbody>
</table>

### Get available job types

To get a list of all available job types you can use the following endpoint:

	GET /api/jobConfigurations/jobTypes

The response contains information about each job type including name, job type, key, scheduling type and available parameters. The scheduling type can either be `CRON`, meaning jobs can be scheduled using a cron expression with the `cronExpression` field, or `FIXED_DELAY`, meaning jobs can be scheduled to run with a fixed delay in between with the `delay` field. The field delay is given in seconds.

A response will look similar to this:

```json
{
  "jobTypes": [
    {
      "name": "Data integrity",
      "jobType": "DATA_INTEGRITY",
      "key": "dataIntegrityJob",
      "schedulingType": "CRON"
    }, {
      "name": "Resource table",
      "jobType": "RESOURCE_TABLE",
      "key": "resourceTableJob",
      "schedulingType": "CRON"
    }, {
      "name": "Continuous analytics table",
      "jobType": "CONTINUOUS_ANALYTICS_TABLE",
      "key": "continuousAnalyticsTableJob",
      "schedulingType": "FIXED_DELAY"
    }
  ]
}
```

### Create job

To configure jobs you can do a POST request to the following resource:

    /api/jobConfigurations

A job without parameters in JSON format looks like this :

```json
{
  "name": "",
  "jobType": "JOBTYPE",
  "cronExpression": "0 * * ? * *",
}
```

An example of an analytics table job with parameters in JSON format:

```json
{
  "name": "Analytics tables last two years",
  "jobType": "ANALYTICS_TABLE",
  "cronExpression": "0 * * ? * *",
  "jobParameters": {
    "lastYears": "2",
    "skipTableTypes": [],
    "skipResourceTables": false
  }
}
```

As example of a push analysis job with parameters in JSON format:

```json
{
   "name": "Push anlysis charts",
   "jobType": "PUSH_ANALYSIS",
   "cronExpression": "0 * * ? * *",
   "jobParameters": {
     "pushAnalysis": [
       "jtcMAKhWwnc"
     ]
    }
 }
```

An example of a job with scheduling type `FIXED_DELAY` and 120 seconds delay:

```json
{
  "name": "Continuous analytics table",
  "jobType": "CONTINUOUS_ANALYTICS_TABLE",
  "delay": "120",
  "jobParameters": {
    "fullUpdateHourOfDay": 4
  }
}
```

### Get jobs

List all job configurations:

    GET /api/jobConfigurations

Retrieve a job:

    GET /api/jobConfigurations/{id}

The response payload looks like this:

```json
{
  "lastUpdated": "2018-02-22T15:15:34.067",
  "id": "KBcP6Qw37gT",
  "href": "http://localhost:8080/api/jobConfigurations/KBcP6Qw37gT",
  "created": "2018-02-22T15:15:34.067",
  "name": "analytics last two years",
  "jobStatus": "SCHEDULED",
  "displayName": "analytics last two years",
  "enabled": true,
  "externalAccess": false,
  "jobType": "ANALYTICS_TABLE",
  "nextExecutionTime": "2018-02-26T03:00:00.000",
  "cronExpression": "0 0 3 ? * MON",
  "jobParameters": {
    "lastYears": 2,
    "skipTableTypes": [],
    "skipResourceTables": false
  },
  "favorite": false,
  "configurable": true,
  "access": {
    "read": true,
    "update": true,
    "externalize": true,
    "delete": true,
    "write": true,
    "manage": true
  },
  "lastUpdatedBy": {
    "id": "GOLswS44mh8"
  },
  "favorites": [],
  "translations": [],
  "userGroupAccesses": [],
  "attributeValues": [],
  "userAccesses": []
}
```

### Update job

Update a job with parameters using the following endpoint and JSON payload format:

    PUT /api/jobConfiguration/{id}

```json
{
  "name": "analytics last two years",
  "enabled": true,
  "cronExpression": "0 0 3 ? * MON",
  "jobType": "ANALYTICS_TABLE",
  "jobParameters": {
    "lastYears": "3",
    "skipTableTypes": [],
    "skipResourceTables": false
  }
}
```

### Delete job

Delete a job using:

    DELETE /api/jobConfiguration/{id}

Note that some jobs with custom configuration parameters may not be added if the
required system settings are not configured. An example of this is data
synchronization, which requires remote server configuration.

## Synchronization { #webapi_synchronization } 

This section covers pull and push of data and metadata.

### Data value push { #webapi_sync_data_push } 

To initiate a data value push to a remote server one must first configure the
URL and credentials for the relevant server from System settings >
Synchronization, then make a POST request to the following resource:

    /api/33/synchronization/dataPush

### Metadata pull { #webapi_sync_metadata_pull } 

To initiate a metadata pull from a remote JSON document you can make a
POST request with a *url* as request payload to the following resource:

    /api/33/synchronization/metadataPull

### Availability check { #webapi_sync_availability_check } 

To check the availability of the remote data server and verify user
credentials you can make a GET request to the following resource:

    /api/33/synchronization/availability


