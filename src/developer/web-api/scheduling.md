# Scheduling { #webapi_scheduling }

DHIS2 allows for scheduling of jobs of various types. Each type of job has different properties for configuration, giving you finer control over how jobs are run. In addition, you can configure the same job to run with different configurations and at different intervals if required.



Table: Main properties

| Property | Description | Type |
|---|---|---|
| name | Name of the job. | String |
| cronExpression | The cron expression which defines the interval for when the job should run. | String (Cron expression) |
| jobType | The job type represent which task is run. In the next table, you can get an overview of existing job types. Each job type can have a specific set of parameters for job configuration. | String (Enum) |
| jobParameters | Job parameters, if applicable for job type. | (See list of job types) |
| enabled | A job can be added to the system without it being scheduled by setting `enabled` to false in the JSON payload. Use this if you want to temporarily stop scheduling for a job, or if a job configuration is not complete yet. | Boolean |



### Job Parameters

Table: `DATA_INTEGRITY` job parameters

| Name          | Type          | Default | Description                                      |
|---------------|---------------|---------|--------------------------------------------------|
| `checks` | array of string | `[]` = all | names of the checks to run in order of execution |
| `type`   | enum            | `REPORT`   | REPORT, SUMMARY or DETAILS                       |

Table: `ANALYTICS_TABLE` job parameters

| Name          | Type          | Default | Description                                      |
|---------------|---------------|---------|--------------------------------------------------|
| `lastYears` | int | empty | Number of years back to include. No value means all years. |
| `skipTableTypes` | array of enum  | `[]`    | Skip generation of tables; Possible values: `DATA_VALUE`, `COMPLETENESS`, `COMPLETENESS_TARGET`, `ORG_UNIT_TARGET`, `EVENT`, `ENROLLMENT`, `VALIDATION_RESULT` |
| `skipResourceTables` | boolean | `false`   | Skip generation of resource tables |
| `skipPrograms` | array of string | `[]`    | Optional list of programs (IDs) that should be skipped |

Table: `CONTINUOUS_ANALYTICS_TABLE` job parameters

| Name          | Type          | Default | Description                                      |
|---------------|---------------|---------|--------------------------------------------------|
| `lastYears` | int | empty | Number of years back to include. No value means all years. |
| `skipTableTypes` | array of enum | `[]`    | Skip generation of tables; Possible values: `DATA_VALUE`, `COMPLETENESS`, `COMPLETENESS_TARGET`, `ORG_UNIT_TARGET`, `EVENT`, `ENROLLMENT`, `VALIDATION_RESULT` |
| `fullUpdateHourOfDay` | int           | `0`     | Hour of day for full update of analytics tables (0-23) |

Table: `DATA_SYNC` job parameters

| Name          | Type          | Default | Description                                      |
|---------------|---------------|---------|--------------------------------------------------|
| `pageSize` | int | `10000` | number of data values processed as a unit |

Table: `META_DATA_SYNC` job parameters

| Name          | Type          | Default | Description                                      |
|---------------|---------------|---------|--------------------------------------------------|
| `trackerProgramPageSize` | int | `20` | number of tracked entities processed as a unit |
| `eventProgramPageSize` | int | `60` | number of events processed as a unit           |
| `dataValuesPageSize` | int | `10000` | number of data values processed as a unit  |

Table: `MONITORING` (Validation rule analysis) job parameters

| Name          | Type          | Default | Description                                      |
|---------------|---------------|---------|--------------------------------------------------|
| `relativeStart` | int | `0` | A number related to date of execution which resembles the start of the period to monitor |
| `relativeEnd` | int | `0` | A number related to date of execution which resembles the end of the period to monitor |
| `validationRuleGroups` | array of string | `[]` | Validation rule groups (UIDs) to include in job |
| `sendNotification` | boolean | `false` | Set `true` if job should send notifications based on validation rule groups |
| `persistsResults` | boolean | `false` | Set `true` if job should persist validation results |

Table: `PUSH_ANALYSIS` job parameters

| Name          | Type          | Default | Description                                      |
|---------------|---------------|---------|--------------------------------------------------|
| `pushAnalysis` | array of string | `[]` |  The UIDs of the push analysis you want to run |

Table: `PREDICTOR` job parameters

| Name          | Type          | Default | Description                                      |
|---------------|---------------|---------|--------------------------------------------------|
| `relativeStart` | int | `0` | A number related to date of execution which resembles the start of the period to monitor |
| `relativeEnd` | int | `0` | A number related to date of execution which resembles the start of the period to monitor |
| `predictors` | array of string | `[]` | Predictors (UIDs) to include in job                                                      |
| `predictorGroups` | array of string | `[]` | Predictor groups (UIDs) to include in job                                                |


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

### Create a Job Configuration

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

### Get Job Configurations

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

### Update a Job Configuration

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

### Delete a Job Configuration

Delete a job using:

    DELETE /api/jobConfiguration/{id}

Note that some jobs with custom configuration parameters may not be added if the
required system settings are not configured. An example of this is data
synchronization, which requires remote server configuration.

### Run Jobs Manually

Jobs can be run manually using:

    POST /api/jobConfiguration/{id}/execute


### Observe Running Jobs
The execution steps and state can be observed while the job is running.
A list of all types of jobs that are currently running is provided by:

    GET /api/scheduling/running/types

To get an overview of all running jobs by job type use:

    GET /api/scheduling/running

As there only can be one job running for each type at a time the status of a
running job can be viewed in details using:

    GET /api/scheduling/running/{type}

For example, to see status of a running `ANALYTICS_TABLE` job use

    GET /api/scheduling/running/ANALYTICS_TABLE

A job is a sequence of processes. Each process has a sequence of `stages`.
Within each stage there might be zero, one or many `items`. Items could be
processed strictly sequential or parallel, n items at a time. Often the
number of `totalItems` is known up-front.

In general the stages in a process and the items in a stage are "discovered"
as a "side effect" of processing the data. While most processes have a fixed
sequence of stages some processed might have varying stages depending on the
data processed. Items are usually data dependent. Most jobs just include a
single process.

Each of the nodes in the process-stage-item tree has a status that is either
* `RUNNING`: is currently processed (not yet finished)
* `SUCCESS`: when completed successful
* `ERROR`: when completed with errors or when an exception has occurred
* `CANCELLED`: when cancellation was requested and the item will not complete

### See Completed Job Runs
Once a job has completed successful or with a failure as a consequence of an
exception or cancellation the status moves from the set of running states to
the completed job states. This set keeps only the most recent execution
state for each job type. The overview is available at:

    GET /api/scheduling/completed

Details on a particular job type are accordingly provided at:

    GET /api/scheduling/completed/{type}

In case of the `ANALYTICS_TABLE` job this would be:

    GET /api/scheduling/completed/ANALYTICS_TABLE

### Request Cancelling a Running Jobs
Once a job is started it works through a sequence of steps. Each step might
in turn have collections of items that are processed. While jobs usually
cannot be stopped at any point in time we can request cancellation and the
process gives up cooperatively once it has completed an item or step and
recognises that a cancellation was requested. This means jobs do not stop
immediately and leave at an unknown point right in the middle of some
processing. Instead, they give up when there is an opportunity to skip to
the end. This still means that the overall process is unfinished and is not
rolled back. It might just have done a number of steps and skipped others at
the end.

To cancel a running job use:

    POST /api/scheduling/cancel/{type}

For example, to cancel the `ANALYTICS_TABLE` job run:

    POST /api/scheduling/cancel/ANALYTICS_TABLE

Depending on the current step and item performed this can take from
milliseconds to minutes before the cancellation becomes effective.
However, the status of the overall process will be shown as `CANCELLED`
immediately when check using

    GET /api/scheduling/running/ANALYTICS_TABLE

Only jobs that have been split into processes, stages and items can be
cancelled effectively. Not all jobs have been split yet. These will run till
completion even if cancellation has been requested.
