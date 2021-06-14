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



Table: Main properties

| Property | Description | Type |
|---|---|---|
| name | Name of the job. | String |
| cronExpression | The cron expression which defines the interval for when the job should run. | String (Cron expression) |
| jobType | The job type represent which task is run. In the next table, you can get an overview of existing job types. Each job type can have a specific set of parameters for job configuration. | String (Enum) |
| jobParameters | Job parameters, if applicable for job type. | (See list of job types) |
| enabled | A job can be added to the system without it being scheduled by setting `enabled` to false in the JSON payload. Use this if you want to temporarily stop scheduling for a job, or if a job configuration is not complete yet. | Boolean |



Table: Available job types

| Job type | Parameters | Param(Type:Default) |
|---|---|---|
| DATA_INTEGRITY | NONE ||
| ANALYTICS_TABLE | * lastYears: Number of years back to include<br> * skipTableTypes: Skip generation of tables<br>Possible values: DATA_VALUE, COMPLETENESS, COMPLETENESS_TARGET, ORG_UNIT_TARGET, EVENT, ENROLLMENT, VALIDATION_RESULT<br> * skipResourceTables: Skip generation of resource tables | * lastYears (int:0)<br> * skipTableTypes (Array of String (Enum):None )<br> * skipResourceTables (Boolean) |
| CONTINUOUS_ANALYTICS_TABLE | * fullUpdateHourOfDay: Hour of day for full update of analytics tables (0-23)<br> * lastYears: Number of years back to include<br> * skipTableTypes: Skip generation of tables<br>Possible values: DATA_VALUE, COMPLETENESS, COMPLETENESS_TARGET, ORG_UNIT_TARGET, EVENT, ENROLLMENT, VALIDATION_RESULT<br> * skipResourceTables: Skip generation of resource tables | * lastYears (int:0)<br> * skipTableTypes (Array of String (Enum):None )<br> * skipResourceTables (Boolean) |
| DATA_SYNC | NONE ||
| META_DATA_SYNC | NONE ||
| SEND_SCHEDULED_MESSAGE | NONE ||
| PROGRAM_NOTIFICATIONS | NONE ||
| MONITORING (Validation rule analysis) | * relativeStart: A number related to date of execution which resembles the start of the period to monitor<br> * relativeEnd: A number related to date of execution which resembles the end of the period to monitor<br> * validationRuleGroups: Validation rule groups(UIDs) to include in job<br> * sendNotification: Set "true" if job should send notifications based on validation rule groups<br> * persistsResults: Set "true" if job should persist validation results | * relativeStart (int:0)<br> * relativeEnd (int:0)<br> * validationRuleGroups (Array of String (UIDs):None )<br> * sendNotification (Boolean:false)<br> * persistsResults (Boolean:false) |
| PUSH_ANALYSIS | * pushAnalysis: The uid of the push analysis you want to run | * pushAnalysis (String:None) |
| PREDICTOR | * relativeStart: A number related to date of execution which resembles the start of the period to monitor<br> * relativeEnd: A number related to date of execution which resembles the start of the period to monitor<br> * predictors: Predictors(UIDs) to include in job | * relativeStart (int:0)<br> * relativeEnd (int:0)<br> * predictors (Array of String (UIDs):None ) |

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
