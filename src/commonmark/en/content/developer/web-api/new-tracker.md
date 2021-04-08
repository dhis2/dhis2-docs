# New Tracker

Version 2.36 of DHIS2 introduced a set of brand new tracker endpoints dedicated to importing and querying tracker objects (Including tracked entities, enrollments, events, and relationships).
These new endpoints set a discontinuity with earlier implementations. Re-engineering the endpoints allowed developers to improve, redesign, and formalize the API's behavior to improve the Tracker services.

The newly introduced endpoints consists of:
* `POST /api/tracker`
* `GET /api/enrollments`
* `GET /api/events`
* `GET /api/trackedEntities`
* `GET /api/relationships`

Significant changes occurred in version 2.36 to make the interface with clients homogeneous and to allow more consistent and flexible ways to use the services.

> ***NOTE***
> 
> The old endpoints are marked as deprecated but still work as before.<br>
> Some functionality is not yet ready in the new endpoints, but they support their primary use-cases.


> ***NOTE 2***
>
> These endpoints currently only support the `JSON` format as input/output.<br>
> Support for the `CSV` format will also be available in the future.

## Changes in the API

Property names used in the API have changed to use consistent naming across all the new endpoints.

### Tracker Import changelog (`POST`)

The following table highlights the differences between the old tracker import endpoints (version 2.35) and the new endpoint (introduced in version 2.36).

|Tracker Object|V2.35|V2.36|
|---|---|---|
|**Attribute**|`created`<br>`lastUpdated`|`createdAt`<br>`updatedAt`|
|**DataValue**|`created`<br>`lastUpdated`|`createdAt`<br>`updatedAt`|
|**Enrollment**|`created`<br>`createdAtClient`<br>`lastUpdated`<br>`lastUpdatedAtClient`<br>`trackedEntityInstance`<br>`enrollmentDate`<br>`incidentDate`<br>`completedDate`|`createdAt`<br>`createdAtClient`<br>`updatedAt`<br>`updatedAtClient`<br>`trackedEntity`<br>`enrolledAt`<br>`occurredAt`<br>`completedAt`|
|**Event**|`trackedEntityInstance`<br>`eventDate`<br>`dueDate`<br>`created`<br>`createdAtClient`<br>`lastUpdated`<br>`lastUpdatedAtClient`<br>`completedDate`|`trackedEntity`<br>`occurredAt`<br>`scheduledAt`<br>`createdAt`<br>`createdAtClient`<br>`updatedAt`<br>`updatedAtClient`<br>`completedAt`|
|**Note**|`storedDate`<br>`lastUpdated`|`storedAt`<br>`updatedAt`|
|**ProgramOwner**|`ownerOrgUnit`<br>`trackedEntityInstance`|`orgUnit`<br>`trackedEntity`|
|**RelationshipItem**|`trackedEntityInstance.trackedEntityInstance`<br>`enrollment.enrollment`<br>`event.event`|`trackedEntity`<br>`enrollment`<br>`event`|
|**Relationship**|`created`<br>`lastUpdated`|`createdAt`<br>`updatedAt`|
|**TrackedEntity**|`trackedEntityInstance`<br>`created`<br>`createdAtClient`<br>`lastUpdated`<br>`lastUpdatedAtClient`|`trackedEntity`<br>`createdAt`<br>`createdAtClient`<br>`updatedAt`<br>`updatedAtClient`|

### Tracker Export changelog (`GET`)

The `GET` endpoints all conform to the same naming conventions reported in the previous paragraph. Additionally, we made some changes regarding
the request parameters to respect the same naming conventions here as well.

These tables highlight the version 2.36 differences in request parameters for `GET` endpoints compared to version 2.35.

#### Request parameter changes for `GET /api/tracker/enrollments`
|V2.35|v2.36|
|---|---|
|`ou`|`orgUnit`|
|`lastUpdated`<br>`lastUpdateDuration`|`updatedAfter`<br>`updatedWithin`|
|`programStartDate`<br>`programEndDate`|`enrolledAfter`<br>`enrolledBefore`|
|`trackedEntityInstance`|`trackedEntity`|

#### Request parameter changes for `GET /api/tracker/events`
|V2.35|v2.36|
|---|---|
|`trackedEntityInstance`|`trackedEntity`|
|`startDate`<br>`endDate`|`occurredAfter`<br>`occurredBefore`|
|`dueDateStart`<br>`dueDateEnd`|`scheduledAfter`<br>`scheduledBefore`|
|`lastUpdated`|Removed - obsolete, see: <br><ul><li>`updatedAfter`</li><li>`updatedBefore`</li></ul>|
|`lastUpdatedStartDate`<br>`lastUpdateEndDate`<br>`lastUpdateDuration`|`updatedAfter`<br>`updatedBefore`<br>`updatedWithin`|

#### Request parameter changes for `GET /api/tracker/trackedEntities`
|V2.35|v2.36|
|---|---|
|`trackedEntityInstance`|`trackedEntity`|
|`ou`|`orgUnit`|
|`programStartDate`<br>`programEndDate`|Removed - obsolete, see <br><ul><li>`enrollmentEnrolledAfter`</li><li>`enrollmentEnrolledBefore`</li></ul>|
|`programEnrollmentStartDate`<br>`programEnrollmentEndDate`|`enrollmentEnrolledAfter`<br>`enrollmentEnrolledBefore`|
|`programIncidentStartDate`<br>`programIncidentEndDate`|`enrollmentOccurredAfter`<br>`enrollmentOccurredBefore`|
|`eventStartDate`<br>`eventEndDate`|`eventOccurredAfter`<br>`eventOccurredBefore`|
|`lastUpdatedStartDate`<br>`lastUpdateEndDate`<br>`lastUpdateDuration`|`updatedAfter`<br>`updatedBefore`<br>`updatedWithin`|

## Tracker Import (`POST /api/tracker`)

<!--DHIS2-SECTION-ID:webapi_nti_import-->

The `POST /api/tracker` endpoint allows clients to import the following tracker objects into DHIS2:

* **trackedEntities**
* **enrollments**
* **events**
* **relationships**
* data embedded in other objects like: **attributes**, **notes**, **data values**, etc. (TODO: Add a section about the model and link)

Main changes compared to version 2.35 are:
1. import payload can be ***nested*** or ***flat***
2. invocation can be ***synchronous*** or ***asynchronous***

### Request parameters

Currently tracker import endpoint support the following parameters:

(TODO: Make a table with all parameters; reportMode is the only difference, and should be noted in the table, not as two paragraphs; TrackerImportParams.java; also use the format name|description|type|example/allowed values )
#### ***SYNC*** endpoint
|Parameter name|Allowed values|
|---|---|
|`reportMode`|`FULL`&#124;`ERRORS`&#124;`WARNINGS`|
#### ***ASYNC*** endpoint

N.A.

### Sample payloads

Examples for the ***FLAT*** and the ***NESTED*** versions of the payload are listed below. Both cases use the same data.

#### ***FLAT*** payload

```json
{
  "trackedEntities": [
    {
      "orgUnit": "O6uvpzGd5pu",
      "trackedEntity": "Kj6vYde4LHh",
      "trackedEntityType": "Q9GufDoplCL"
    }
  ],
  "enrollments": [
    {
      "orgUnit": "O6uvpzGd5pu",
      "program": "f1AyMswryyQ",
      "trackedEntity": "Kj6vYde4LHh",
      "enrollment": "MNWZ6hnuhSw",
      "trackedEntityType": "Q9GufDoplCL",
      "enrolledAt": "2019-08-19T00:00:00.000",
      "deleted": false,
      "occurredAt": "2019-08-19T00:00:00.000",
      "status": "ACTIVE",
      "notes": [],
      "attributes": [],
    }
  ],
  "events": [
    {
      "scheduledAt": "2019-08-19T13:59:13.688",
      "program": "f1AyMswryyQ",
      "event": "ZwwuwNp6gVd",
      "programStage": "nlXNK4b7LVr",
      "orgUnit": "O6uvpzGd5pu",
      "trackedEntity": "Kj6vYde4LHh",
      "enrollment": "MNWZ6hnuhSw",
      "enrollmentStatus": "ACTIVE",
      "status": "ACTIVE",
      "occurredAt": "2019-08-01T00:00:00.000",
      "attributeCategoryOptions": "xYerKDKCefk",
      "deleted": false,
      "attributeOptionCombo": "HllvX50cXC0",
      "dataValues": [
        {
          "updatedAt": "2019-08-19T13:58:37.477",
          "storedBy": "admin",
          "dataElement": "BuZ5LGNfGEU",
          "value": "20",
          "providedElsewhere": false
        },
        {
          "updatedAt": "2019-08-19T13:58:40.031",
          "storedBy": "admin",
          "dataElement": "ZrqtjjveTFc",
          "value": "Male",
          "providedElsewhere": false
        },
        {
          "updatedAt": "2019-08-19T13:59:13.691",
          "storedBy": "admin",
          "dataElement": "mB2QHw1tU96",
          "value": "[-11.566044,9.477801]",
          "providedElsewhere": false
        }
      ],
      "notes": []
    },
    {
      "scheduledAt": "2019-08-19T13:59:13.688",
      "program": "f1AyMswryyQ",
      "event": "XwwuwNp6gVE",
      "programStage": "PaOOjwLVW23",
      "orgUnit": "O6uvpzGd5pu",
      "trackedEntity": "Kj6vYde4LHh",
      "enrollment": "MNWZ6hnuhSw",
      "enrollmentStatus": "ACTIVE",
      "status": "ACTIVE",
      "occurredAt": "2019-08-01T00:00:00.000",
      "attributeCategoryOptions": "xYerKDKCefk",
      "deleted": false,
      "attributeOptionCombo": "HllvX50cXC0",
      "notes": []
    }
  ],
  "relationships": [
    {
      "relationshipType": "Udhj3bsdHeT",
      "from": {
        "trackedEntity": "Kj6vYde4LHh"
      },
      "to": {
        "trackedEntity": "Gjaiu3ea38E"
      }
    }
  ]
}
```

#### ***NESTED*** payload
```json
{
  "trackedEntities": [
    {
      "orgUnit": "O6uvpzGd5pu",
      "trackedEntity": "Kj6vYde4LHh",
      "trackedEntityType": "Q9GufDoplCL",
      "relationships": [
        {
          "relationshipType": "Udhj3bsdHeT",
          "from": {
            "trackedEntity": "Kj6vYde4LHh"
          },
          "to": {
            "trackedEntity": "Gjaiu3ea38E"
          }
        }
      ],
      "enrollments": [
        {
          "orgUnit": "O6uvpzGd5pu",
          "program": "f1AyMswryyQ",
          "trackedEntity": "Kj6vYde4LHh",
          "enrollment": "MNWZ6hnuhSw",
          "trackedEntityType": "Q9GufDoplCL",
          "enrolledAt": "2019-08-19T00:00:00.000",
          "deleted": false,
          "occurredAt": "2019-08-19T00:00:00.000",
          "status": "ACTIVE",
          "notes": [],
          "relationships": [],
          "attributes": [],
          "events": [
            {
              "scheduledAt": "2019-08-19T13:59:13.688",
              "program": "f1AyMswryyQ",
              "event": "ZwwuwNp6gVd",
              "programStage": "nlXNK4b7LVr",
              "orgUnit": "O6uvpzGd5pu",
              "trackedEntity": "Kj6vYde4LHh",
              "enrollment": "MNWZ6hnuhSw",
              "enrollmentStatus": "ACTIVE",
              "status": "ACTIVE",
              "occurredAt": "2019-08-01T00:00:00.000",
              "attributeCategoryOptions": "xYerKDKCefk",
              "deleted": false,
              "attributeOptionCombo": "HllvX50cXC0",
              "dataValues": [
                {
                  "updatedAt": "2019-08-19T13:58:37.477",
                  "storedBy": "admin",
                  "dataElement": "BuZ5LGNfGEU",
                  "value": "20",
                  "providedElsewhere": false
                },
                {
                  "updatedAt": "2019-08-19T13:58:40.031",
                  "storedBy": "admin",
                  "dataElement": "ZrqtjjveTFc",
                  "value": "Male",
                  "providedElsewhere": false
                },
                {
                  "updatedAt": "2019-08-19T13:59:13.691",
                  "storedBy": "admin",
                  "dataElement": "mB2QHw1tU96",
                  "value": "[-11.566044,9.477801]",
                  "providedElsewhere": false
                }
              ],
              "notes": [],
              "relationships": []
            },
            {
              "scheduledAt": "2019-08-19T13:59:13.688",
              "program": "f1AyMswryyQ",
              "event": "XwwuwNp6gVE",
              "programStage": "PaOOjwLVW23",
              "orgUnit": "O6uvpzGd5pu",
              "trackedEntity": "Kj6vYde4LHh",
              "enrollment": "MNWZ6hnuhSw",
              "enrollmentStatus": "ACTIVE",
              "status": "ACTIVE",
              "occurredAt": "2019-08-01T00:00:00.000",
              "attributeCategoryOptions": "xYerKDKCefk",
              "deleted": false,
              "attributeOptionCombo": "HllvX50cXC0",
              "notes": [],
              "relationships": []
            }
          ]
        }
      ]
    }
  ]
}
```

### Sample responses

Examples of the ***SYNC*** and the ***ASYNC*** responses are listed below. Note that the ***SYNC*** example shows a `FULL` report.

#### ***SYNC*** response
```json
{
  "status": "OK",
  "validationReport": {
    "errorReports": [],
    "warningReports": []
  },
  "stats": {
    "created": 2,
    "updated": 0,
    "deleted": 0,
    "ignored": 0,
    "total": 2
  },
  "timingsStats": {
    "timers": {
      "preheat": "0,077242 sec.",
      "preprocess": "0,000026 sec.",
      "commit": "0,040080 sec.",
      "programrule": "0,000455 sec.",
      "programruleValidation": "0,000672 sec.",
      "totalImport": "0,122770 sec.",
      "validation": "0,003612 sec."
    }
  },
  "bundleReport": {
    "status": "OK",
    "typeReportMap": {
      "TRACKED_ENTITY": {
        "trackerType": "TRACKED_ENTITY",
        "stats": {
          "created": 1,
          "updated": 0,
          "deleted": 0,
          "ignored": 0,
          "total": 1
        },
        "objectReports": [
          {
            "trackerType": "TRACKED_ENTITY",
            "uid": "FkxTQC4EAKK",
            "index": 0,
            "errorReports": []
          }
        ]
      },
      "ENROLLMENT": {
        "trackerType": "ENROLLMENT",
        "stats": {
          "created": 1,
          "updated": 0,
          "deleted": 0,
          "ignored": 0,
          "total": 1
        },
        "objectReports": [
          {
            "trackerType": "ENROLLMENT",
            "uid": "hDUGDZo6xSE",
            "index": 0,
            "errorReports": []
          }
        ]
      },
      "RELATIONSHIP": {
        "trackerType": "RELATIONSHIP",
        "stats": {
          "created": 0,
          "updated": 0,
          "deleted": 0,
          "ignored": 0,
          "total": 0
        },
        "objectReports": []
      },
      "EVENT": {
        "trackerType": "EVENT",
        "stats": {
          "created": 0,
          "updated": 0,
          "deleted": 0,
          "ignored": 0,
          "total": 0
        },
        "objectReports": []
      }
    },
    "stats": {
      "created": 2,
      "updated": 0,
      "deleted": 0,
      "ignored": 0,
      "total": 2
    }
  }
}
```

#### ***ASYNC*** response
```json
{
    "httpStatus": "OK",
    "httpStatusCode": 200,
    "status": "OK",
    "message": "Tracker job added",
    "response": {
        "responseType": "TrackerJob",
        "id": "LkXBUdIgbe3",
        "location": "https://play.dhis2.org/dev/api/tracker/jobs/LkXBUdIgbe3"
    }
}
```


(TODO: Next items)
  * Configuration that alters the import process (IE. turning off cache)
  * Describe the difference between sync\async
  * Flat\nested payload support
  * Note about Side effects - Link to side effects
  * Note about validation - Link to validation
  * Note about program rules - Link to program rules

### Import Summary

<!--DHIS2-SECTION-ID:webapi_nti_import_summary-->

  * List the endpoints for retrieving log and importSummary
  * For each endpoint:
    * Example request
    * Example response
    * Table of params
  * Make a note that these are temporal, meaning they will only exists for a limited time
  * Explain the “job” / “log” / “notification” response
  * Explain the structure of the importSummary
  * Explain how to read errors from the importSummary - Link to   errors

### Error Codes

<!--DHIS2-SECTION-ID:webapi_nti_error_codes-->

A table with a full reference of error codes, messages and description:

| Error Code | Error Message | Description |
|:--|:----|:----|
||||


### Validation

<!--DHIS2-SECTION-ID:webapi_nti_validation-->

  * A full overview of validation that takes place during import
  * What properties are required
  * What is the validation for certain types of values
  * Uniqueness
  * Program rules - Link to program rules
  * Access control - Link to Tracker access control
  * Date restrictions
  * Program and Program Stage configuration-based validation

  * I am not sure about the best format here, but maybe we split it up into each model:
  * Tracked Entity
      * Enrollment
        * Event
            * DataValue -> Link
            * TrackedEntityAttributeValue -> Link
      * TrackedEntityAttributesValue -> Link
      * TrackedEntityAttributeValue
        * Value Types


### Program Rules

<!--DHIS2-SECTION-ID:webapi_nti_program_rules-->

  * Describe when\how rules are now run on the backend as well
  * Describe what rules are being run, and which are not being run
  * Describe any condition for when something is or is not run
  * Describe the different results rules can have (warning, error, etc)
  * Side effects(?) - Link to side effects


### Side Effects

<!--DHIS2-SECTION-ID:webapi_nti_side_effects-->

  * Describe what side-effects are
  * Note that side-effects can fail even if import succeeds. But not the other way around
  * Describe what side-effects we have and what they do (Table?)
  * Any configuration that affects side effects.

## Tracker Export

<!--DHIS2-SECTION-ID:webapi_nti_export-->

Tracker export endpoints are a set of services which allow clients to query and retrieve objects stored using import endpoint.

Beside differences highlighted in (TODO ADD REFERENCE TO INTERFACE CHANGELOG), request parameters for these endpoints match older ones.

Being currently under development, some internal implementation might change over time, however, 
we expect that interfaces (`request`/`response`) will receive minor if not any changes at all.

Tracker export endpoints deal with the following Tracker objects:

- **Tracked Entities**
- **Events**
- **Enrollments**
- **Relationships**

> **_NOTE 1:_** 
> 
> These resource supports `JSON` and `CSV` resource representation (`CSV` planned but not implemented yet).


> **_NOTE 2:_**
> 
> These endpoints adopt new naming convention documented (TODO[add reference to changelog] here) 

> **_NOTE 3:_**
> 
> The following functionalities are still missing, but available in older endpoints:
> - field filtering

### Common request parameters

The following endpoint supports common parameters for pagination

- **Tracked Entities** `GET /api/tracker/trackedEntities`
- **Events** `GET /api/tracker/events`
- **Enrollments** `GET /api/tracker/enrollments`

|request parameter|type|allowed values|description|
|---|---|---|---|
|`page`|`Integer`| |Page number to return. Defaults to 1 if missing|
|`pageSize`|`Integer`|Page size. Defaults to 50 if missing |
|`totalPages`|`Boolean`| |Indicates whether to return the total number of pages in the response (implies higher response time)|
|`skipPaging`|`Boolean`| |Indicates whether paging should be ignored and all rows should be returned TODO [VERIFY]|
|`paging`|`Boolean`| |Indicates whether paging is enabled TODO [VERIFY]| 
|`order`|`String`|comma-delimited list of `OrderCriteria` in the form of `propName:sortDirection`.<br><br> Example: `createdAt:desc`<br><br>**Note:** `propName` is case sensitive, `sortDirection` is case insensitive|Sort the response based on given `OrderCriteria`|

### Tracked Entities

Two endpoints are dedicated to tracked entities:

- `GET /api/tracker/trackedEntities`
  - retrieves tracked entities matching given criteria
- `GET /api/tracker/{id}`
  - retrieves a tracked entity given the provided id
    
#### Tracked Entities Collection endpoint `GET /api/tracker/trackedEntities`

Purpose of this endpoint is to retrieve tracked entities matching client-provided criteria.

It's intended to return a collection of tracked entities with pagination TODO [VERIFY USE CASES].

##### Request syntax

|request parameter|type|allowed values|description|
|---|---|---|---|
|`query`|`String`|`{operator}:{filter-value}`|Creates a QueryFilter from the given string. Only the filter-value is mandatory, `EQ` operator is used if `operator` is not specified.|
|`attribute`|`String`|Comma separated values of attribute `UID` ??| ??|
|`filter`|`String`|Comma separated values of ??|??|
|`orgUnit`|`String`|semicolon-delimited list of organisational unit `UID`|Only return tracked entity instances belonging to provided organisational units|
|`ouMode`|`String`|`SELECTED`&#124;`CHILDREN`&#124;`DESCENDANTS`&#124;`ACCESSIBLE`&#124;`CAPTURE`&#124;`ALL`|The mode of selecting organisation units, can be. Default is `SELECTED`, which refers to the selected selected organisation units only. See table below for explanations.|
|`program`|`String`|Program `UID`| a Program `UID` for which instances in the response must be enrolled in|
|`programStatus`|`String`|`ACTIVE`&#124;`COMPLETED`&#124;`CANCELLED`|The ProgramStatus of the Tracked Entity Instance in the given program|
|`programStage`|`String`|`UID`|a Program Stage `UID` for which instances in the response must have events on|
|`followUp`|`Boolean`|`true`&#124;`false`|Indicates whether the Tracked Entity Instance is marked for follow up for the specified Program|
|`updatedAfter`|`DateTime`| ?? | Start date for last updated|
|`updatedBefore`|`DateTime`| ?? | End date for last updated|
|`updatedWithin`|`Duration`|?? | ??|
|`enrollmentEnrolledAfter`|`DateTime`|??|Start date for incident in the given program|
|`enrollmentEnrolledBefore`|`DateTime`|??|End date for incident in the given program|
|`enrollmentOccurredAfter`|`DateTime`|??|Start date for incident in the given program|
|`enrollmentOccurredBefore`|`DateTime`|??|End date for incident in the given program|
|`trackedEntityType`|`String`|??|Only returns Tracked Entity Instances of given type|
|`trackedEntity`|`String`|semicolon-delimited list of tracked entity instance `UID`|Filter the result down to a limited set of teis using explicit uids of the tracked entity instances by using `trackedEntity=id1;id2`. This parameter will at the very least create the outer boundary of the results, forming the list of all teis using the uids provided. If other parameters/filters from this table are used, they will further limit the results from the explicit outer boundary.|
|`assignedUserMode`|`String`|`CURRENT`&#124;`PROVIDED`&#124;`NONE`&#124;`ANY`|Restricts result to tei with events assigned based on the assigned user selection mode|
|`assignedUser`|`String`|Semicolon-delimited list of user UIDs to filter based on events assigned to the users.|Filter the result down to a limited set of teis with events that are assigned to the given user IDs by using `assignedUser=id1;id2`.This parameter will be considered only if assignedUserMode is either `PROVIDED` or `null`. The API will error out, if for example, `assignedUserMode=CURRENT` and `assignedUser=someId`|
|`eventStatus`|`String`|`ACTIVE`&#124;`COMPLETED`&#124;`VISITED`&#124;`SCHEDULE`&#124;`OVERDUE`&#124;`SKIPPED`|Status of any events in the specified program|
|`eventOccurredAfter`|`DateTime`|???|Start date for Event for the given Program|
|`eventOccurredBefore`|`DateTime`|???|End date for Event for the given Program|
|`skipMeta`|`Boolean`|`true`&#124;`false`|Indicates whether not to include meta data in the response.|
|`includeDeleted`|`Boolean`|`true`&#124;`false`|Indicates whether to include soft-deleted elements|
|`includeAllAttributes`|`Boolean`|`true`&#124;`false`|Indicates whether to include all TEI attributes|
|`attachment`|`String`| |The file name in case of exporting as a file|

The available organisation unit selection modes are explained in the
following table.

|Mode|Description|
|---|---|
|`SELECTED`|	Organisation units defined in the request.|
|`CHILDREN`|	The selected organisation units and the immediate children, i.e. the organisation units at the level below.|
|`DESCENDANTS`|	The selected organisation units and all children, i.e. all organisation units in the sub-hierarchy.|
|`ACCESSIBLE`|	The data view organisation units associated with the current user and all children, i.e. all organisation units in the sub-hierarchy. Will fall back to data capture organisation units associated with the current user if the former is not defined.|
|`CAPTURE`|	The data capture organisation units associated with the current user and all children, i.e. all organisation units in the sub-hierarchy.|
|`ALL`|	All organisation units in the system. Requires the ALL authority.|

The query is case insensitive. The following rules apply to the query
parameters.

- At least one organisation unit must be specified using the `orgUnit`
  parameter (one or many), or `ouMode=ALL` must be specified.

- Only one of the `program` and `trackedEntity` parameters can be
  specified (zero or one).

- If `programStatus` is specified then `program` must also be
  specified.

- If `followUp` is specified then `program` must also be specified.

- If `enrollmentEnrolledAfter` or `enrollmentEnrolledBefore` is specified then
  `program` must also be specified.

- Filter items can only be specified once.

##### Example requests

A query for all instances associated with a specific organisation unit
can look like this:

    GET /api/tracker/trackedEntities?orgUnit=DiszpKrYNg8

To query for instances using one attribute with a filter and one
attribute without a filter, with one organisation unit using the
descendant organisation unit query mode:

    GET /api/tracker/trackedEntities?filter=zHXD5Ve1Efw:EQ:A
        &filter=AMpUYgxuCaE&orgUnit=DiszpKrYNg8;yMCshbaVExv

A query for instances where one attribute is included in the response
and one attribute is used as a filter:

    GET /api/tracker/trackedEntities?filter=zHXD5Ve1Efw:EQ:A
        &filter=AMpUYgxuCaE:LIKE:Road
        &orgUnit=DiszpKrYNg8

A query where multiple operand and filters are specified for a filter
item:

    GET /api/tracker/trackedEntities?orgUnit=DiszpKrYNg8
        &program=ur1Edk5Oe2n
        &filter=lw1SqmMlnfh:GT:150:LT:190

To query on an attribute using multiple values in an *IN* filter:

    GET /api/tracker/trackedEntities?orgUnit=DiszpKrYNg8
        &filter=dv3nChNSIxy:IN:Scott;Jimmy;Santiago

To constrain the response to instances which are part of a specific
program you can include a program query parameter:

    GET GET /api/tracker/trackedEntities?filter=zHXD5Ve1Efw:EQ:A
        &orgUnit=O6uvpzGd5pu&ouMode=DESCENDANTS
        &program=ur1Edk5Oe2n

To specify program enrollment dates as part of the query:

    GET /api/tracker/trackedEntities?filter=zHXD5Ve1Efw:EQ:A
        &orgUnit=O6uvpzGd5pu&program=ur1Edk5Oe2n
        &enrollmentEnrolledAfter=2013-01-01
        &enrollmentEnrolledBefore=2013-09-01

To constrain the response to instances of a specific tracked entity you
can include a tracked entity query parameter:

    GET /api/tracker/trackedEntities?filter=zHXD5Ve1Efw:EQ:A
        &orgUnit=O6uvpzGd5pu
        &ouMode=DESCENDANTS
        &trackedEntity=cyl5vuJ5ETQ

By default the instances are returned in pages of size 50, to change
this you can use the page and pageSize query parameters:

    GET /api/tracker/trackedEntities?filter=zHXD5Ve1Efw:EQ:A
        &orgUnit=O6uvpzGd5pu
        &ouMode=DESCENDANTS
        &page=2&pageSize=3

You can use a range of operators for the filtering:

|Operator|	Description|
|---|---|
|`EQ`|	Equal to|
|`GT`|	Greater than|
|`GE`|	Greater than or equal to|
|`LT`|	Less than|
|`LE`|	Less than or equal to|
|`NE`|	Not equal to|
|`LIKE`|	Like (free text match)|
|`IN`|	Equal to one of multiple values separated by ";"|

##### Response format

The `JSON` response can look like the following.

Please note that field filtering (`fields=...`) support is planned but not yet implemented.

```json
{
  "instances": [
    {
      "trackedEntity": "IzHblRD2sDH",
      "trackedEntityType": "nEenWmSyUEp",
      "createdAt": "2014-03-26T15:40:36.669",
      "createdAtClient": "2014-03-26T15:40:36.669",
      "updatedAt": "2014-03-28T12:28:17.544",
      "orgUnit": "g8upMTyEZGZ",
      "inactive": false,
      "deleted": false,
      "relationships": [],
      "attributes": [
        {
          "attribute": "VqEFza8wbwA",
          "code": "MMD_PER_ADR1",
          "displayName": "Address",
          "createdAt": "2016-01-12T00:00:00.000",
          "updatedAt": "2016-01-12T00:00:00.000",
          "valueType": "TEXT",
          "value": "1061 Marconi St"
        },
        {
          "attribute": "RG7uGl4w5Jq",
          "code": "Longitude",
          "displayName": "Longitude",
          "createdAt": "2016-01-12T00:00:00.000",
          "updatedAt": "2016-01-12T00:00:00.000",
          "valueType": "TEXT",
          "value": "27.866613"
        },
        ...,
        ...,
      ],
      "enrollments": [],
      "programOwners": []
    }
  ],
  "page": 1,
  "total": 39,
  "pageSize": 1
}
```

#### Tracked Entities single object endpoint `GET /api/tracker/trackedEntities/{uid}`

Purpose of this endpoint is to retrieve one tracked entities given its uid.

##### Request syntax

`GET /api/tracker/trackedEntities/{uid}?program={programUid}&fields={fields}`

|request parameter|type|allowed values|description|
|---|---|---|---|
|`uid`|`String`|`uid`|Return the Tracked Entity Instance with specified `uid`|
|`program`|`String`|`uid`| TODO - verify what exactly this param does |
|`fields`|`String`| **Currently:** <br>`*`&#124;`relationships`&#124;`enrollments`&#124;`events`&#124;`programOwners`<br><br>**Planned:**<br> a `String` specifying which fields to include in the response|Include specified sub-objects in the response| 

##### Example requests

A query for a Tracked Entity Instance:

    GET /api/tracker/trackedEntities/IzHblRD2sDH?program=ur1Edk5Oe2n&fields=*

##### Response format

Please note that even though full field filtering (`fields=...`) support is not yet implemented, this endpoint still supports
returning sub-objects when `fields` request parameter is passed.

```json
{
    "trackedEntity": "IzHblRD2sDH",
    "trackedEntityType": "nEenWmSyUEp",
    "createdAt": "2014-03-26T15:40:36.669",
    "updatedAt": "2014-03-28T12:28:17.544",
    "orgUnit": "g8upMTyEZGZ",
    "inactive": false,
    "deleted": false,
    "relationships": [],
    "attributes": [
        {
            "attribute": "w75KJ2mc4zz",
            "code": "MMD_PER_NAM",
            "displayName": "First name",
            "createdAt": "2016-01-12T09:10:26.986",
            "updatedAt": "2016-01-12T09:10:35.884",
            "valueType": "TEXT",
            "value": "Wegahta"
        },
        {
            "attribute": "zDhUuAYrxNC",
            "displayName": "Last name",
            "createdAt": "2016-01-12T09:10:26.986",
            "updatedAt": "2016-01-12T09:10:35.884",
            "valueType": "TEXT",
            "value": "Goytiom"
        }
    ],
    "enrollments": [
        {
            "enrollment": "uT5ZysTES7j",
            "createdAt": "2017-03-28T12:28:17.539",
            "createdAtClient": "2016-03-28T12:28:17.539",
            "updatedAt": "2017-03-28T12:28:17.544",
            "trackedEntity": "IzHblRD2sDH",
            "trackedEntityType": "nEenWmSyUEp",
            "program": "ur1Edk5Oe2n",
            "status": "ACTIVE",
            "orgUnit": "g8upMTyEZGZ",
            "orgUnitName": "Njandama MCHP",
            "enrolledAt": "2020-11-10T12:28:17.532",
            "occurredAt": "2020-10-12T12:28:17.532",
            "followUp": false,
            "deleted": false,
            "events": [
                {
                    "event": "ixDYEGrNQeH",
                    "status": "ACTIVE",
                    "program": "ur1Edk5Oe2n",
                    "programStage": "ZkbAXlQUYJG",
                    "enrollment": "uT5ZysTES7j",
                    "enrollmentStatus": "ACTIVE",
                    "trackedEntity": "IzHblRD2sDH",
                    "relationships": [],
                    "scheduledAt": "2019-10-12T12:28:17.532",
                    "followup": false,
                    "deleted": false,
                    "createdAt": "2017-03-28T12:28:17.542",
                    "createdAtClient": "2016-03-28T12:28:17.542",
                    "updatedAt": "2017-03-28T12:28:17.542",
                    "attributeOptionCombo": "HllvX50cXC0",
                    "attributeCategoryOptions": "xYerKDKCefk",
                    "dataValues": [],
                    "notes": []
                }
            ],
            "relationships": [],
            "attributes": [],
            "notes": []
        }
    ],
    "programOwners": [
        {
            "orgUnit": "g8upMTyEZGZ",
            "trackedEntity": "IzHblRD2sDH",
            "program": "ur1Edk5Oe2n"
        }
    ]
}
```

### Events (`GET /api/tracker/events`)
### Enrollments (`GET /api/tracker/enrollments`)
### Relationships (`GET /api/tracker/relationships`)



  * Which endpoints are here today?
  * common parameters (paging)
  * For each endpoint:
    * Important: What is the intention of the endpoint (exporting a lot of data? Searching? Etc)
    * Example payload
    * Example response
    * Example request
    * Table of params
  * For endpoints with reduced functionality, make a note of it, and that the old, deprecated endpoint still supports this.
  * Make a note that the intention of these endpoints is to support the new format when exporting.


## Tracker Access Control

<!--DHIS2-SECTION-ID:webapi_nti_access_control-->

### Metadata Sharing

<!--DHIS2-SECTION-ID:webapi_nti_metadata_sharing-->


  * How sharing relates to how we import and export data
  * Explain how the sharing is cascading in our model (if tei can’t be seen, you can’t see enrolment, etc)

### Organisation Unit Scopes

<!--DHIS2-SECTION-ID:webapi_nti_ou_scope-->

  * Explain the different scopes
  * Explain how they relate to import and export
  * Explain how they relate to searching
  * Explain how they relate to ownership - Link to Program Ownership

### Program Ownership

<!--DHIS2-SECTION-ID:webapi_nti_ownership-->

  * Describe the idea about Program Ownership
  * Temporary ownership
  * Program Ownership and Access Level - Link to Access Level

### Access Level

<!--DHIS2-SECTION-ID:webapi_nti_access_level-->

  * What is “access level”?
  * How does access level affect import\export?
