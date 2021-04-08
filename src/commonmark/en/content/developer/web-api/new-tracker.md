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

This will be sort of a work-in-progress, but as far as we can, we will describe what we have today. Describe that this is endpoints that are incomplete and will be improved in the future


  * Which endpoints are here today?
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
