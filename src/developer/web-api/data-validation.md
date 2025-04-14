# Data validation

## Validation { #webapi_validation } 

To generate a data validation summary you can interact with the
validation resource. The dataSet resource is optimized for data entry
clients for validating a data set / form, and can be accessed like this:

    GET /api/33/validation/dataSet/QX4ZTUbOt3a.json?pe=201501&ou=DiszpKrYNg8

In addition to validate rules based on data set, there are two
additional methods for performing validation: Custom validation and
Scheduled validation.

The first path variable is an identifier referring to the data set to
validate. XML and JSON resource representations are supported. The
response contains violations of validation rules. This will be extended
with more validation types in the coming versions.

To retrieve validation rules which are relevant for a specific data set,
meaning validation rules with formulas where all data elements are part
of the specific data set, you can make a GET request to to
`validationRules` resource like this:

    GET /api/validationRules?dataSet=<dataset-id>

The validation rules have a left side and a right side, which is
compared for validity according to an operator. The valid operator
values are found in the table below.



Table: Operators

| Value | Description |
|---|---|
| equal_to | Equal to |
| not_equal_to | Not equal to |
| greater_than | Greater than |
| greater_than_or_equal_to | Greater than or equal to |
| less_than | Less than |
| less_than_or_equal_to | Less than or equal to |
| compulsory_pair | If either side is present, the other must also be |
| exclusive_pair | If either side is present, the other must not be |

The left side and right side expressions are mathematical expressions
which can contain references to data elements and category option
combinations on the following format:

    ${<dataelement-id>.<catoptcombo-id>}

The left side and right side expressions have a *missing value
strategy*. This refers to how the system should treat data values which
are missing for data elements / category option combination references
in the formula in terms of whether the validation rule should be checked
for validity or skipped. The valid missing value strategies are found in
the table below.



Table: Missing value strategies

| Value | Description |
|---|---|
| SKIP_IF_ANY_VALUE_MISSING | Skip validation rule if any data value is missing |
| SKIP_IF_ALL_VALUES_MISSING | Skip validation rule if all data values are missing |
| NEVER_SKIP | Never skip validation rule irrespective of missing data values |

## Validation results { #webapi_validation_results } 

Validation results are persisted results of violations found during a
validation analysis. If you choose "persist results" when starting or
scheduling a validation analysis, any violations found will be stored in
the database. When a result is stored in the database it will be used
for 3 things:

1.  Generating analytics based on the stored results.

2.  Persisted results that have not generated a notification, will do so,
    once.

3.  Keeping track of whether or not the result has generated a
    notification.

4.  Skipping rules that have been already checked when running
    validation analysis.

This means if you don't persist your results, you will be unable to
generate analytics for validation results, if checked, results will
generate notifications every time it's found and running validation
analysis might be slower.

### Query validation results

The validation results persisted can be viewed at the following
endpoint:

    GET /api/33/validationResults

You can also inspect an individual result using the validation result id
in this endpoint:

    GET /api/33/validationResults/<id>

Validation results can also be filtered by following properties:

* Organisation Unit: `ou=<UID>`
* Validation Rule: `vr=<UID>`
* Period: `pe=<ISO-expression>`

Each of the above filter properties can occur multiple times, for example:

    GET /api/36/validationResults?ou=jNb63DIHuwU&ou=RzgSFJ9E46G

Multiple values for the same filter are combined with OR, results have to match one of the given values.

If more then one filter properties is used these are combined with AND, results have to match one of the values for each of the properties.

For the period filter matching results have to overlap with any of the specified periods.

In addition the validation results can also be filtered on their creation date:

    GET /api/36/validationResults?createdDate=<date>

This filter can be combined with any of the other filters.    

### Trigger validation result notifications

Validation results are sent out to the appropriate users once every day,
but can also be manually triggered to run on demand using the following
API endpoint:

    POST /api/33/validation/sendNotifications

Only unsent results are sent using this endpoint.

### Delete validation results

Validation results can be manually deleted by ID,

    DELETE /api/36/validationResults/<id>

or using filters

    DELETE /api/36/validationResults?<filters>

Supported filter parameters include:

* `ou=<UID>` to match all validation results of an organisation unit; multiple units combine OR when the parameter is provided more than once
* `vr=<UID>` to match all validation results of a validation rule; multiple rules combine OR when the parameter is provided more than once
* `pe=<ISO-expression>` to match all validation results related to a period that overlaps with the specified period
* `created=<ISO-expression>` to match all validation results that were created within the provided period
* `notificationSent=<boolean>` to match either only validation results for which a notification was or wasn't sent


If filters are combined, all conditions have to be true (AND logic).

Some examples:

To delete all validation results related the organisation unit with UID `NqwvaQC1ni4` for Q1 of 2020 use:

```
DELETE /api/36/validationResults?ou=NqwvaQC1ni4&pe=2020Q1
```

To delete all validation results that were created in week 1 of 2019 and for which notification has been sent use:

```
DELETE /api/36/validationResults?created=2019W1&notificationSent=true
```

Any delete operation will require the authority _Perform maintenance tasks_.


## Outlier detection

The outlier detection endpoint allows for detecting outliers in aggregate data values.

```
GET /api/36/outlierDetection
```

This endpoint supports two algorithms for detecting outliers:

* **Z-score:** The z-score is defined as the absolute deviation between the score and mean divided by the standard deviation. A threshold parameter referring to the number of standard deviations from the mean must be specified with the z-score algorithm to define the upper and lower boundaries for what is considered an outlier value.
* **Modified Z-score:** Same as z-score except it uses the median instead of the mean as measure of central tendency. Parameters are same as for Z-score.
* **Min-max:** Min-max data element values refers to custom boundaries which can be inserted in DHIS2 based on data element, org unit and category option combination.

The outlier values will be *ordered according to significance*, by default by the absolute deviation from the mean, with the most significant value first. This is helpful to quickly identify the outlier values which have the biggest impact on data quality and data analytics.

### Request query parameters

The following query parameters are supported.

| Query parameter | Description                                                  | Mandatory | Options (default first)                   |
| --------------- | ------------------------------------------------------------ | --------- | ----------------------------------------- |
| ds              | Data set, can be specified multiple times.                   | No [*]    | Data set identifier.                      |
| de              | Data element, can be specified multiple times.               | No [*]    | Data element identifier.                  |
| startDate       | Start date for interval to check for outliers.               | Yes       | Date (yyyy-MM-dd).                        |
| endDate         | End date for interval to check for outliers.                 | Yes       | Date (yyyy-MM-dd).                        |
| ou              | Organisation unit, can be specified multiple times.          | Yes       | Organisation unit identifier.             |
| algorithm       | Algorithm to use for outlier detection.                      | No        | `Z_SCORE`, `MIN_MAX`, `MOD_Z_SCORE`       |
| threshold       | Threshold for outlier values. `Z_SCORE` and `MOD_Z_SCORE` algorithm only. | No        | Numeric, greater than zero. Default: 3.0. |
| dataStartDate   | Start date for interval for mean and std dev calculation. `Z_SCORE` and `MOD_Z_SCORE` algorithm only. | No        | Date (yyyy-MM-dd). |
| dataEndDate     | End date for interval for mean and std dev calculation. `Z_SCORE` and `MOD_Z_SCORE` algorithm only. | No        | Date (yyyy-MM-dd).   |
| orderBy         | Field to order by. `Z_SCORE` and `MOD_Z_SCORE`algorithm only.| No        | `MEAN_ABS_DEV`, `Z_SCORE`                 |
| maxResults      | Max limit for the output.                                    | No        | Integer, greater than zero and less than system setting `keyDataQualityMaxLimit` Default: 500. |

[*]  You must specify either data sets with the `ds` parameter, which will include all data elements in the data sets, _or_ specify data elements with the `de` parameter.

At least one data set or data element, start date and end date, and at least one organisation unit must be defined.

The `startDate` and `endDate` parameters are mandatory and refer to the time interval for which you want to detect outliers. The `dataStartDate` and `dataEndDate` parameters are optional and refer to the time interval for the data to use when calculating the mean and std dev, which are used to eventually calculate the z-score.

### Usage and examples

Get outlier values using the default z-score algorithm:

```
GET /api/36/outlierDetection?ds=BfMAe6Itzgt&ds=QX4ZTUbOt3a
  &ou=O6uvpzGd5pu&ou=fdc6uOvgoji&startDate=2020-01-01&endDate=2020-12-31
```

Get outlier values using a specific algorithm and a specific threshold:

```
GET /api/36/outlierDetection?ds=BfMAe6Itzgt&ds=QX4ZTUbOt3a
  &ou=O6uvpzGd5pu&startDate=2020-01-01&endDate=2020-12-31
  &algorithm=Z_SCORE&threshold=2.5
```

Get outlier values ordered by z-score:

```
GET /api/36/outlierDetection?ds=BfMAe6Itzgt
  &ou=O6uvpzGd5pu&startDate=2020-01-01&endDate=2020-12-31
  &orderBy=Z_SCORE
```

Get the top 10 outlier values:

```
GET /api/36/outlierDetection?ds=BfMAe6Itzgt
  &ou=O6uvpzGd5pu&startDate=2020-01-01&endDate=2020-12-31
  &maxResults=10
```

Get outlier values with a defined interval for data to use when calculating the mean and std dev:

```
GET /api/36/outlierDetection?ds=BfMAe6Itzgt
  &ou=O6uvpzGd5pu&startDate=2020-01-01&endDate=2020-12-31
  &dataStartDate=2018-01-01&dataEndDate=2020-12-31
```

Get outlier values using the min-max algorithm:

```
GET /api/36/outlierDetection?ds=BfMAe6Itzgt&ds=QX4ZTUbOt3a
  &ou=O6uvpzGd5pu&ou=fdc6uOvgoji&startDate=2020-01-01&endDate=2020-12-31
  &algorithm=MIN_MAX
```

### Response format

The following response formats are supported.

| Format | API format                                                   |
| ------ | ------------------------------------------------------------ |
| JSON   | `/api/36/outlierDetection.json` or `Accept: application/json` (default format) |
| CSV    | `/api/36/outlierDetection.csv` or `Accept: application/csv`  |

The response contains the following fields:

| Field      | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| de         | Data element identifier.                                     |
| deName     | Data element name.                                           |
| pe         | Period ISO identifier.                                       |
| ou         | Organisation unit identifier.                                |
| ouName     | Organisation unit name.                                      |
| coc        | Category option combination identifier.                      |
| cocName    | Category option combination name.                            |
| aoc        | Attribute option combination identifier.                     |
| aocName    | Attribute option combination name.                           |
| value      | Data value.                                                  |
| mean       | Mean of data values in the time dimension.                   |
| stdDev     | Standard deviation.                                          |
| absDev     | For z-score, absolute deviation from the mean. For min-max, absolute deviation from the min or max boundary. |
| zScore     | The z-score. Z-score algorithm only.                         |
| lowerBound | The lower boundary.                                          |
| upperBound | The upper boundary.                                          |
| followUp   | Whether data value is marked for follow-up.                  |

The `mean`, `stdDev` and `zScore` fields are only present when `algorithm` is `Z_SCORE`.

The response will look similar to this. The `metadata` section contains metadata for the request and response. The `outlierValues` section contains the outlier values.

```json
{
  "metadata": {
    "algorithm": "Z_SCORE",
    "threshold": 2.5,
    "orderBy": "MEAN_ABS_DEV",
    "maxResults": 10,
    "count": 10
  },
  "outlierValues": [
    {
      "de": "rbkr8PL0rwM",
      "deName": "Iron Folate given at ANC 3rd",
      "pe": "202011",
      "ou": "Pae8DR7VmcL",
      "ouName": "MCH (Kakua) Static",
      "coc": "pq2XI5kz2BY",
      "cocName": "Fixed",
      "aoc": "HllvX50cXC0",
      "aocName": "default",
      "value": 9000.0,
      "mean": 1524.5555,
      "stdDev": 2654.4661,
      "absDev": 7475.4444,
      "zScore": 2.8161,
      "lowerBound": -5111.6097,
      "upperBound": 8160.7208,
      "followUp": false
    },
    {
      "de": "rbkr8PL0rwM",
      "deName": "Iron Folate given at ANC 3rd",
      "pe": "202010",
      "ou": "vELbGdEphPd",
      "ouName": "Jimmi CHC",
      "coc": "pq2XI5kz2BY",
      "cocName": "Fixed",
      "aoc": "HllvX50cXC0",
      "aocName": "default",
      "value": 8764.0,
      "mean": 1448.0833,
      "stdDev": 2502.3031,
      "absDev": 7315.9166,
      "zScore": 2.9236,
      "lowerBound": -4807.6745,
      "upperBound": 7703.8412,
      "followUp": false
    }
  ]
}
```

### Constraints and validation

The following constraints apply during query validation. Each validation error has a corresponding error code.

| Error code | Message                                                      |
| ---------- | ------------------------------------------------------------ |
| E2200      | At least one data element must be specified                  |
| E2201      | Start date and end date must be specified                    |
| E2202      | Start date must be before end date                           |
| E2203      | At least one organisation unit must be specified             |
| E2204      | Threshold must be a positive number                          |
| E2205      | Max results must be a positive number                        |
| E2206      | Max results exceeds the allowed max limit: {d}               |
| E2207      | Data start date must be before data end date                 |
| E2208      | Non-numeric data values encountered during outlier value detection |

## Data analysis { #webapi_data_analysis } 

Several resources for performing data analysis and finding data quality
and validation issues are provided.

**Note:** This endpoint is deprecated and will be removed in 2.38. Use the `outlierAnalysis` endpoint instead.

### Validation rule analysis { #webapi_data_analysis_validation_rules } 

To run validation rules and retrieve violations:

    GET /api/dataAnalysis/validationRules

The following query parameters are supported:

Table: Validation rule analysis query parameters

| Query parameter | Description | Option | Required | Default |
|---|---|---|---|
| vrg | Validation rule group | ID | false | If omitted, all validation rule groups will be used |
| ou | Organisation unit | ID |true | |
| startDate | Start date for the time span | Date (yyyy-MM-dd) | false | Today |
| endDate | End date for the time span | Date (yyyy-MM-dd) | false | Today |
| persist | Whether to persist violations in the system | false &#124; true | false | false |
| notification | Whether to send notifications about violations | false &#124; true | false | false |
| maxResults | Max limit for the output | Integer, greater than zero. Maximum as specified by system setting `keyDataQualityMaxLimit`| false | 500 |

Sample POST body request: 
```json
{"startDate":"2024-01-01",
"endDate":"2025-04-10",
"ou":"ImspTQPwCqd",
"notification":false,
"persist":false,
"vrg":"UP1lctvalPn",
"maxResults": 500}
```

Sample output:
```json
[{
	"validationRuleId": "kgh54Xb9LSE",
	"validationRuleDescription": "Malaria outbreak",
	"organisationUnitId": "DiszpKrYNg8",
	"organisationUnitDisplayName": "Ngelehun CHC",
	"organisationUnitPath": "/ImspTQPwCqd/O6uvpzGd5pu/YuQRtpLP10I/DiszpKrYNg8",
	"organisationUnitAncestorNames": "Sierra Leone / Bo / Badjia / ",
	"periodId": "201901",
	"periodDisplayName": "January 2019",
	"attributeOptionComboId": "HllvX50cXC0",
	"attributeOptionComboDisplayName": "default",
	"importance": "MEDIUM",
	"leftSideValue": 10.0,
	"operator": ">",
	"rightSideValue": 14.0
}, {
	"validationRuleId": "ZoG4yXZi3c3",
	"validationRuleDescription": "ANC 2 cannot be higher than ANC 1",
	"organisationUnitId": "DiszpKrYNg8",
	"organisationUnitDisplayName": "Ngelehun CHC",
	"organisationUnitPath": "/ImspTQPwCqd/O6uvpzGd5pu/YuQRtpLP10I/DiszpKrYNg8",
	"organisationUnitAncestorNames": "Sierra Leone / Bo / Badjia / ",
	"periodId": "201901",
	"periodDisplayName": "January 2019",
	"attributeOptionComboId": "HllvX50cXC0",
	"attributeOptionComboDisplayName": "default",
	"importance": "MEDIUM",
	"leftSideValue": 22.0,
	"operator": "<=",
	"rightSideValue": 19.0
}]
```

### Standard deviation based outlier analysis { #webapi_data_analysis_std_dev_outlier } 

To identify data outliers based on standard deviations of the average
value:

    GET /api/dataAnalysis/stdDevOutlier

The following query parameters are supported:



Table: Standard deviation outlier analysis query parameters

| Query parameter | Description | Option |
|---|---|---|
| ou | Organisation unit | ID |
| startDate | Start date for the timespan | Date |
| endDate | End date for the timespan | Date |
| ds | Data sets, parameter can be repeated | ID |
| standardDeviation | Number of standard deviations from the average | Numeric value |

### Min/max value based outlier analysis { #webapi_data_analysis_min_max_outlier } 

To identify data outliers based on min/max values:

    GET /api/dataAnalysis/minMaxOutlier

The supported query parameters are equal to the *std dev based outlier
analysis* resource described above.

### Follow-up data analysis

To identify data marked for follow-up:

    GET /api/dataAnalysis/followup

At least one data set or data element, start date and end date or period, and at least one organisation unit must be defined.

The following query parameters are supported.

| Parameter  | Description                                                  | Mandatory | Options (default first)                   |
| ---------- | ------------------------------------------------------------ | --------- | ----------------------------------------- |
| ou         | Organisation unit, can be specified multiple times.          | Yes       | Organisation unit identifier.             |
| ds         | Data set, can be specified multiple times.                   | No [*]    | Data set identifier.                      |
| de         | Data element, can be specified multiple times.               | No [*]    | Data element identifier.                  |
| startDate  | Start date for interval to check for outliers.               | No [*]    | Date (yyyy-MM-dd).                        |
| endDate    | End date for interval to check for outliers.                 | No [*]    | Date (yyyy-MM-dd).                        |
| pe         | ISO period ID.                                               | No [*]    | Period ISO ID.                        |
| peType     | ISO period.                                                  | No [*]    | Period ISO string.                        |
| coc        | Category option combos, can be specified multiple times.     | No        | Category option combo identifier.         |
| maxResults | Max limit for the output.                                    | No        | Integer, greater than zero. Default: 50.  |

[*]  You must specify either data sets with the `ds` parameter, which will include all data elements in the data sets, _or_ specify data elements with the `de` parameter.
     Equally, either `startDate` and `endDate` _or_ `period` must be specified.

The `startDate` and `endDate` parameters refer to the time interval for which you want to detect outliers.
If a period `pe` is provided instead the interval start and end is that of the period.

If no option combos `coc` are provided all data elements of numeric value type are considered.


## Data integrity { #webapi_data_integrity } 

The data integrity capabilities of the data administration module are
available through the web API. This section describes how to run the
data integrity process and retrieve the results. The specific
details regarding each check are described in the user manual.

### Listing the available data integrity checks { #webapi_data_integrity_list }
A description of the available checks is returned by a request to:

    GET /api/dataIntegrity

```
[
    {
        "name": "data_elements_without_groups",
        "displayName": "Data elements lacking groups",
        "section": "Data Elements",
        "severity": "WARNING",
        "description": "Lists all data elements that have no data element groups",
        "issuesIdType": "dataElements",
        "isSlow": false
    }
]
```

The `name` member of the returned check elements is the identifier used for the
`checks` parameter to declare the set of checks to run.

> **Note**
> 
> Each check will indicate whether it may require significant time and resources to complete with the `isSlow` field. 
> Users should be cautious about running these
> checks on production systems as they could lead to decreased performance. 
> These checks can be run individually, but will 
> not be run unless specifically requested.

Checks are grouped semantically by the `section` member and categorised in 
one of four `severity` levels:

| Severity | Description                                                                                                                   |
| -------- |-------------------------------------------------------------------------------------------------------------------------------|
| INFO     | Indicates that this is for information only.                                                                                  |
| WARNING  | A warning indicates that this may be a problem, but not necessarily an error. It is however recommended to triage these issues. |
| SEVERE   | An error that should be fixed but which may not necessarily lead to the system not functioning.                               |
| CRITICAL | An error that must be fixed and which may lead to end-user error or system crashes.                                           |

The available checks can be filtered using the `checks` parameter.

    GET /api/dataIntegrity?checks=<pattern1>,<pattern2>

One or more exact names or patterns using `*` as a wildcard can be provided.

Additional results can be filtered using a `section` parameter.

    GET /api/dataIntegrity?section=Categories

The `section` filter will return all exact matches which have the specified section. 

Furthermore, to filter (select) only checks marked as `isSlow` use `slow=true`,

    GET /api/dataIntegrity?slow=true

or to filter (select) only checks that are not performed via database query 
(programmed checks) use `programmatic=true`:

    GET /api/dataIntegrity?programmatic=true

The `slow`, `programmatic` and `section` filters can be combined in which case
all conditions must be met.

### Running data integrity summaries { #webapi_data_integrity_run_summary }

Since version 2.38, data integrity checks have two levels of specificity: 

- a `summary` level that provides an overview of the number of issues
- a `details` level that provides a list of issues pointing to individual data integrity violations.

To trigger a summary analysis for a set of checks run:

    POST /api/dataIntegrity/summary?checks=<name1>,<name2>

This triggers a job that runs the check(s) asynchronously. Individual check results
will be returned to the application cache as soon as the check has completed.

Alternatively the list of checks can also be given as BODY of the POST request.
This can be useful if the list becomes to long to be used in the URL.

To fetch the data integrity summary of the triggered check(s) use:

    GET /api/dataIntegrity/summary?checks=<name1>,<name2>

When the `checks` parameter is omitted, all checks are fetched from the server cache.

The response is a "map" of check results, one for each check that has completed already.
This information is cached for one hour or until the check is rerun.

To wait for the summary to be available in the cache a `timeout` in milliseconds can be added:

    GET /api/dataIntegrity/summary?checks=<name1>,<name2>&timeout=500

An example of a summary response could look like: 
```json
{
  "<name1>": {
    "name": "<name1>",
    "displayName": "<displayName1>",
    "startTime": "2023-01-11T06:12:56.436",
    "finishedTime": "2023-01-11T06:12:57.021",
    "section": "...",
    "severity": "WARNING",
    "description": "...",
    "count": 12,
    "percentage": 2.3
  },
  "<name2>": {
    "name": "<name2>",
    "displayName": "<displayName2>",
    "startTime": "2023-01-11T06:12:57.345",
    "finishedTime": "2023-01-11T06:12:58.007",
    "section": "...",
    "severity": "WARNING",
    "description": "...",
    "count": 4,
    "percentage": 5.1
  }
}
```

Each summary response will contain the `name`, `section`, `severity`, 
`description` and optionally  an `introduction` and `recommendation`.  
Each summary contains the number of issues found in the `count` field. When possible,
an optional `percentage` field will provide the percentage of objects with data
integrity issues when compared to all objects of the same type.
The `startTime` field indicates when the check was initiated. Using the `finishedTime`
the duration which was required to execute the check can be calculated.

Should a check analysis fail due to programming error or unforeseen data inconsistencies
both the summary and the details will have an `error` field describing the error that occurred.
The `count` of any checks which failed will be set to -1. 
No `percentage` will be returned in such cases.

```json
{
  "<name1>": {
    "name": "<name1>",
    "displayName": "<displayName1>",
    "finishedTime": "2022-02-15 14:55",
    "section": "...",
    "severity": "WARNING",
    "description": "...",
    "error": "what has happened",
    "issues": []
  }
}
```

> **Note**
> 
> Each metadata check is run asynchronously on the server.  Results
> will be returned as soon as each check completes. The safest way to ensure 
> that you have retrieved the latest set of results which has been 
> requested is to compare the timestamp of when the request was made
> with the `finishedTime` in the response.

To get a list of the names of checks that are currently being performed by the 
server use:

    GET /api/dataIntegrity/summary/running

To get a list of the names of checks for which results are available already use:

    GET /api/dataIntegrity/summary/completed

### Retrieving completed checks as Prometheus metrics {#webapi_data_integrity_metrics}

Metadata integrity checks which are present in the cache, can be retrieved in the Prometheus
metrics format by making a request to :
    GET /api/dataIntegrity/metrics

The response should return a plain text format in the [Prometheus plain text exposition format](https://prometheus.io/docs/instrumenting/exposition_formats/#text-based-format). Several metrics are available
for each data integrity check.
 - Count: A count of the number of issues identified by the metadata check. 
 - Percentage: When available, provides a percentage of the objects which have been identified by the check relative to a baseline. For instance, if check "Organisation units with trailing spaces" has a percent of 2.13, the percentage is calculated by dividing the number of organisation units with trailing spaces by the total number of organisation units. Note that this percentage may not be available for all metadata integrity checks.
 - Duration: Number of milliseconds that the check took to execute the last time it was run.

An example of the output of this endpoint is provided below:

```text
# HELP dhis_data_integrity_check_count Data integrity check counts
# TYPE dhis_data_integrity_check_count gauge
dhis_data_integrity_check_count{check="orgunits_invalid_geometry"} 1
dhis_data_integrity_check_count{check="user_groups_scarce"} 0
dhis_data_integrity_check_count{check="indicator_no_analysis"} 13
# HELP dhis_data_integrity_check_percentage Data integrity check percentages
# TYPE dhis_data_integrity_check_percentage gauge
dhis_data_integrity_check_percentage{check="orgunits_invalid_geometry"} 0.13054830287206268
dhis_data_integrity_check_percentage{check="user_groups_scarce"} 0.0
dhis_data_integrity_check_percentage{check="indicator_no_analysis"} 16.0
# HELP dhis_data_integrity_check_duration Data integrity check durations
# TYPE dhis_data_integrity_check_duration gauge
dhis_data_integrity_check_duration{check="orgunits_invalid_geometry"} 11
dhis_data_integrity_check_duration{check="user_groups_scarce"} 1
dhis_data_integrity_check_duration{check="indicator_no_analysis"} 0
```

Data integrity checks which are not currently in the cache will not be returned by this endpoint.  A request would need to be made to the `/summary` endpoint to trigger the checks to be run or alternatively through a scheduled job.

### Running data integrity details { #webapi_data_integrity_run_details }

To run a selection of details checks first trigger them using a  `POST` request:

    POST /api/dataIntegrity/details?checks=<name1>,<name2>

Similar to the summary the list of checks can also be given as the POST body.

Then fetch the results from the cache using:

    GET /api/dataIntegrity/details?checks=<name1>,<name2>&timeout=500

When the `checks` parameter is not provided,  all checks which 
have not been marked as `isSlow` will be scheduled to be run on the server.

Omitting the `timeout` will not wait for results to be found in the cache, 
but instead not have a result for the requested check.

The `/details` response returns a map similar to the `summary`, but does not contain
a `count` or `percentage`. Instead, a list of `issues` is returned.

```json
{
  "<name1>": {
    "name": "<name1>",
    "displayName": "<displayName1>",
    "startTime": "2023-01-11T06:12:56.436",
    "finishedTime": "2023-01-11T06:12:57.021",
    "section": "...",
    "severity": "WARNING",
    "description": "...",
    "issuesIdType": "<object-type-plural>",
    "isSlow": false,
    "issues": [{
      "id": "<id-or-other-identifier>",
      "name": "<name-of-the-id-obj>",
      "comment": "optional plain text description or hint of the issue",
      "refs": ["<id1>", "<id2>"]
    }]
  },
  "<name2>": {
    "name": "<name2>",
    "displayName": "<displayName2>",
    "startTime": "2023-01-11T06:12:57.345",
    "finishedTime": "2023-01-11T06:12:58.007",
    "section": "...",
    "severity": "WARNING",
    "description": "...",
    "issuesIdType": "<object-type-plural>",
    "isSlow": false,
    "issues": []
  }
}
```
Each issue will always have `id` and `name` members.  Often the `issuesIdType`
is available to indicate the type of objects the `id` refers to. If the 
`issuesIdType` is not available, the `id` often is not available either and the
`name` is used for an aggregate key of an issue that has no object equivalent.

The `comment` and `refs` fields are optional for each issue.
A `comment` may provide more context or
insight into why this particular issue is regarded to be a data integrity problem. 
The `refs` list may also give the identifiers of other objects that contributed to the violation.
The `finishedTime` field shows when the particular check finished processing on the server.
The cache will store the result of each completed check for one hour.

> **Tip**
>
> A set of checks can also be specified using wild-cards. To include all 
> checks with _element_ in the name use `checks=*element*`. Like full names 
> such patterns can be used in a comma-separated list and be mixed with full 
> names as well. Duplicates will be eliminated. 
> Also a check can be given by its code. A code consists of the first letters
> of each word in the name as upper case letter. 
> For example, `orgunits_invalid_geometry` has the code `OIG`.

Similar to the summary a set of names of the currently performed and the
already completed details checks can be obtained using:

    GET /api/dataIntegrity/details/running
    GET /api/dataIntegrity/details/completed

### Custom Data Integrity Checks { #custom_data_integrity_checks } 

Users of DHIS2 can now create and supply their own Data Integrity Checks. This can be useful if users
want to avail of this functionality and extend upon the supplied set of core data integrity checks.

> **Tip**
> 
> Users are also encouraged to share their custom checks with others by opening a pull request in the 
> [dhis2-core](https://github.com/dhis2/dhis2-core) repository containing their `.yaml` file(s).
> Please select `platform-backend` as reviewer to put the PR on our radar early on. The team will 
> take care of checking and linking the check correctly, so it becomes part of the provided suite of 
> checks with the next release. 

An example of a custom check could be for determining if certain users are members of specific user groups.
This type of check would be very specific to an implementation, and not generally applicable across all installs.
These types of metadata checks can be used to extend the default checks which are included with DHIS2.

Custom checks can be implemented by satisfying the following requirements, each of which we will go into detail:
- Supplying your own list of custom data integrity checks in a list file named `custom-data-integrity-checks.yaml`
 in your `DHIS2_HOME` directory
- Having a directory named `custom-data-integrity-checks` in your `DHIS2_HOME` directory
- Supplying your valid custom data integrity check yaml files

#### Custom Data Integrity Check List File

DHIS2 will only try to load data integrity files when they are needed. e.g. when making a call to view all
data integrity checks:

    GET /api/dataIntegrity

DHIS2 will look for a file named `custom-data-integrity-checks.yaml` in your `DHIS2_HOME` directory when loading
data integrity files. If you are not using custom checks and the file is not present, a warning log like this will
be present:

```text
08:29:57.729  WARN o.h.d.d.DataIntegrityYamlReader: Failed to load data integrity check from YAML. Error message `{DHIS2_HOME}/custom-data-integrity-checks.yaml (No such file or directory)
```

If you are implementing custom data integrity checks then this file must be present. To see what the core data integrity checks
file looks like as an example, check out [this file](https://github.com/dhis2/dhis2-core/blob/master/dhis-2/dhis-services/dhis-service-administration/src/main/resources/data-integrity-checks.yaml).


The `custom-data-integrity-checks.yaml` file should list all of your custom data integrity checks.
As an example, it could look something like this:

```yaml
checks:
  - categories/my_custom_check.yaml
  - users/my_user_group_check.yaml
  - base_check.yaml
```

Check names in this file can be preceded with a directory name for logical grouping. From the 3 example checks listed 
above, the directory structure should look like this:

```
├── DHIS2_HOME
│   ├── dhis.conf
│   ├── custom-data-integrity-checks.yaml
│   ├── custom-data-integrity-checks
│   │   ├── categories
│   │   │   ├── my_custom_check.yaml
│   │   ├── users
│   │   │   ├── my_user_group_check.yaml
│   │   ├── base_check.yaml
```

#### Name and Code constraints

Each data integrity check `name` and `code` must be unique. If there are any clashes then the violating custom
check will not be loaded.

> **Note**
>
> System data integrity checks are always loaded first. Any name or code clashes resulting from
> custom checks will not affect these core system checks.

An example data integrity check yaml file is located [here](https://github.com/dhis2/dhis2-core/blob/master/dhis-2/dhis-services/dhis-service-administration/src/main/resources/data-integrity-checks/orgunits/orgunits_orphaned.yaml)
for reference. Note the `name` property.

The data integrity `code` is calculated dynamically by using the first letter of each word in the `name`. Some examples:

| Name                   | Code |
|------------------------|------|
| my_custom_check        | MCC  |
| my_second_custom_check | MSCC |
| another_custom_check   | ACC  |

If there is a `name` clash, a warning log like this will be present:
```text
09:48:43.138  WARN o.h.d.d.DefaultDataIntegrityService: Data Integrity Check `my_custom_check` not added as a check with that name already exists
```

If there is a `code` clash, a warning log like this will be present:
```text
09:48:43.138  WARN o.h.d.d.DefaultDataIntegrityService: Data Integrity Check `my_custom_check` not added as a check with the code `MCC` already exists
```

#### Data Integrity Check Schema

A data integrity check file must comply with this [JSON schema](https://github.com/dhis2/dhis2-core/blob/master/dhis-2/dhis-services/dhis-service-administration/src/main/resources/data-integrity-checks/integrity_check_schema.json).
If a check does not comply with the schema then a warning like this will be present:
```text
09:48:43.136  WARN o.h.d.d.DataIntegrityYamlReader: JsonSchema validation errors found for Data Integrity Check `categories/my_custom_check.yaml`. Errors: [$.name: is missing but it is required]
```

Any schema violations must be fixed before that check can be loaded and used.

If a data integrity check file contains invalid yaml then a warning log like this could be present:
```text
10:30:37.858  WARN o.h.d.d.DataIntegrityYamlReader: JsonSchema validation errors found for Data Integrity Check `my_custom_check.yaml`. Errors: [$: string found, object expected]
```

To view and use the custom checks please refer to the main [Data Integrity section](#webapi_data_integrity)

> **Note**
>
> It is recommended to follow any naming and format conventions seen in the provided examples above when implementing
> your own custom checks to help avoid any issues

#### Data Integrity File

Details of the data integrity check yaml file, taken from the JSON schema file

| property        | required | info                                                                                                                          |
|-----------------|----------|-------------------------------------------------------------------------------------------------------------------------------|
| name            | yes      | unique name of the check                                                                                                      |
| description     | yes      | description                                                                                                                   |
| section         | yes      | used for logical grouping of checks e.g. categories, users                                                                    |
| section_order   | yes      | the order of the check when displayed in the UI                                                                               |
| summary_sql     | yes      | an SQL query which should return a single result which represents the total count of issues                                   |
| details_sql     | yes      | an SQL query which should return a list of identified objects from this particular issue. Should return at least uid and name |
| details_id_type | yes      | a short string which identifies the section of the details SQL                                                                |
| severity        | yes      | level of severity of the issue. One of [INFO, WARNING, SEVERE, CRITICAL]                                                      |
| introduction    | yes      | outlining the objective of the check                                                                                          |
| recommendation  | yes      | outlining how to resolve identified issues                                                                                    |

### Example custom data integrity check


An example of a custom check could be for determining if users have an email. Emails are useful to be
able to communicate with users and sent them notifications, as well as password recovery. So, in some
instllations of DHIS2, it could be a policy that all users should have emails. An example of this type
of custom check is shown below.

```
---
name: users_should_have_emails
description: Users should have emails.
section: Users
section_order: 6
summary_sql: >-
  WITH users_no_email as (
  SELECT uid,username from
  userinfo where email IS NULL)
  SELECT COUNT(*) as value,
  100*COUNT(*) / NULLIF( ( select COUNT(*) from userinfo), 0) as percent
  from users_no_email;
details_sql: >-
  WITH users_no_email as (
  SELECT uid,username from
  userinfo where email IS NULL)
  SELECT uid,username as from users_no_email;
severity: WARNING
introduction: >
  Users should have defined emails. This is important for password recovery and to be able
  to send notifications to users.
recommendation: >
  Make sure that all users have defined emails.
details_id_type: users
```

More examples of different types of metadata integrity checks can be found in the DHIS2 source code [here](https://github.com/dhis2/dhis2-core/tree/master/dhis-2/dhis-services/dhis-service-administration/src/main/resources/data-integrity-checks).

## Complete data set registrations { #webapi_complete_data_set_registrations }

This section is about complete data set registrations for data sets. A
registration marks as a data set as completely captured.

### Completing data sets { #webapi_completing_data_sets }

This section explains how to register data sets as complete. This is
achieved by interacting with the *completeDataSetRegistrations*
resource:

    GET /api/33/completeDataSetRegistrations

The endpoint supports the *POST* method for registering data set
completions. The endpoint is functionally very similar to the
*dataValueSets* endpoint, with support for bulk import of complete
registrations.

Importing both *XML* and *JSON* formatted payloads are supported. The
basic format of this payload, given as *XML* in this example, is like
so:

```xml
<completeDataSetRegistrations xmlns="http://dhis2.org/schema/dxf/2.0">
  <completeDataSetRegistration period="200810" dataSet="eZDhcZi6FLP"
    organisationUnit="qhqAxPSTUXp" attributeOptionCombo="bRowv6yZOF2" storedBy="imported"/>
  <completeDataSetRegistration period="200811" dataSet="eZDhcZi6FLP"
    organisationUnit="qhqAxPSTUXp" attributeOptionCombo="bRowv6yZOF2" storedBy="imported"/>
</completeDataSetRegistrations>
```

The *storedBy* attribute is optional (as it is a nullable property on
the complete registration object). You can also optionally set the
*date* property (time of registration) as an attribute. It the time is
not set, the current time will be used.

The import process supports the following query parameters:



Table: Complete data set registrations query parameters

| Parameter | Values | Description |
|---|---|---|
| dataSetIdScheme | id &#124; name &#124; code &#124; attribute:ID | Property of the data set to use to map the complete registrations. |
| orgUnitIdScheme | id &#124; name &#124; code &#124; attribute:ID | Property of the organisation unit to use to map the complete registrations. |
| attributeOptionComboIdScheme | id &#124; name &#124; code &#124; attribute:ID | Property of the attribute option combos to use to map the complete registrations. |
| idScheme | id &#124; name &#124; code &#124; attribute:ID | Property of all objects including data sets, org units and attribute option combos, to use to map the complete registrations. |
| preheatCache | false &#124; true | Whether to save changes on the server or just return the import summary. |
| dryRun | false &#124; true | Whether registration applies to sub units |
| importStrategy | CREATE &#124; UPDATE &#124; CREATE_AND_UPDATE &#124; DELETE | Save objects of all, new or update import status on the server. |
| skipExistingCheck | false &#124; true | Skip checks for existing complete registrations. Improves performance. Only use for empty databases or when the registrations to import do not exist already. |
| async | false &#124; true | Indicates whether the import should be done asynchronous or synchronous. The former is suitable for very large imports as it ensures that the request does not time out, although it has a significant performance overhead. The latter is faster but requires the connection to persist until the process is finished. |

The `idScheme`, `dataSetIdScheme`, `orgUnitIdScheme`, `attributeOptionComboIdScheme`, 
`dryRun` and `strategy` (note the dissimilar naming to parameter `importStrategy`) 
can also be set as part of the payload.
In case of XML these are attributes, in case of JSON these are members in the
`completeDataSetRegistrations` node.

For example:
```xml
<completeDataSetRegistrations xmlns="http://dhis2.org/schema/dxf/2.0"
      orgUnitIdScheme="CODE">
    <completeDataSetRegistration period="200810" dataSet="eZDhcZi6FLP"
    organisationUnit="OU_559" attributeOptionCombo="bRowv6yZOF2" storedBy="imported"/>
</completeDataSetRegistrations>
```

Should both URL parameter and payload set a scheme the payload takes precedence. 

### Reading complete data set registrations { #webapi_reading_complete_data_sets } 

This section explains how to retrieve data set completeness
registrations. We will be using the *completeDataSetRegistrations*
resource. The query parameters to use are these:



Table: Data value set query parameters

| Parameter | Description |
|---|---|
| dataSet | Data set identifier, multiple data sets are allowed |
| period | Period identifier in ISO format. Multiple periods are allowed. |
| startDate | Start date for the time span of the values to export |
| endDate | End date for the time span of the values to export |
| created | Include only registrations which were created since the given timestamp |
| createdDuration | Include only registrations which were created within the given duration. The format is <value\><time-unit\>, where the supported time units are "d", "h", "m", "s" *(days, hours, minutes, seconds).* The time unit is relative to the current time. |
| orgUnit | Organisation unit identifier, can be specified multiple times. Not applicable if orgUnitGroup is given. |
| orgUnitGroup | Organisation unit group identifier, can be specified multiple times. Not applicable if orgUnit is given. |
| children | Whether to include the children in the hierarchy of the organisation units |
| limit | The maximum number of registrations to include in the response. |
| idScheme | Identifier property used for meta data objects in the response. |
| dataSetIdScheme | Identifier property used for data sets in the response. Overrides idScheme. |
| orgUnitIdScheme | Identifier property used for organisation units in the response. Overrides idScheme. |
| attributeOptionComboIdScheme | Identifier property used for attribute option combos in the response. Overrides idScheme. |
The `dataSet` and `orgUnit` parameters can be repeated in order to include multiple data sets and organisation units.

The `period`, `startDate`,  `endDate`, `created` and `createdDuration` parameters provide multiple ways to set the time dimension for the request, thus only
one can be used. For example, it doesn't make sense to both set the start/end date and to set the periods.

An example request looks like this:

```bash
GET /api/33/completeDataSetRegistrations?dataSet=pBOMPrpg1QX
  &startDate=2014-01-01&endDate=2014-01-31&orgUnit=YuQRtpLP10I
  &orgUnit=vWbkYPRmKyS&children=true
```

You can get the response in *xml* and *json* format. You can indicate which response format you prefer through the *Accept* HTTP header like
in the example above. For xml you use *application/xml*; for json you use *application/json*.

### Un-completing data sets { #webapi_uncompleting_data_sets } 

This section explains how you can un-register the completeness of a data set. To un-complete a data set you will interact with the completeDataSetRegistrations resource:

    GET /api/33/completeDataSetRegistrations

This resource supports *DELETE* for un-registration. The following query
parameters are supported:



Table: Complete data set registrations query parameters

| Query parameter | Required | Description |
|---|---|---|
| ds | Yes | Data set identifier |
| pe | Yes | Period identifier |
| ou | Yes | Organisation unit identifier |
| cc | No (must combine with cp) | Attribute combo identifier (for locking check) |
| cp | No (must combine with cp) | Attribute option identifiers, separated with ; for multiple values (for locking check) |
| multiOu | No (default false) | Whether registration applies to sub units |
