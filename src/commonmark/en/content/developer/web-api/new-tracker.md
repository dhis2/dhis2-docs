# New Tracker

Version 2.36 of DHIS2 introduced a set of brand new tracker endpoints dedicated to importing and querying tracker objects (Including tracked entities, enrollments, events, and relationships).
These new endpoints set a discontinuity with earlier implementations. Re-engineering the endpoints allowed developers to improve, redesign, and formalize the API's behavior to improve the Tracker services.

The newly introduced endpoints consist of:
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


## Tracker Objects

<!--DHIS2-SECTION-ID:webapi_nti_tracker_objects-->

Tracker consists of a few different types of objects that are nested together to represent the data. In this section, we will show and describe each of the objects used in the Tracker API.

### Tracked Entity

`Tracked Entities` are the root object for the Tracker model.

| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| trackedEntity | The identifier of the tracked entity. Generated if not supplied | No | Yes | String:Uid | ABCDEF12345 |
| trackedEntityType | The type of tracked entity. | Yes | No | String:Uid | ABCDEF12345 |
| createdAt | Timestamp when the user created the tracked entity. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| createdAtClient | Timestamp when the user created the tracked entity on the client. | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAt | Timestamp when the object was last updated. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAtClient | Timestamp when the object was last updated on the client. | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| orgUnit | The organisation unit where the user created the tracked entity. | Yes | No | String:Uid | ABCDEF12345 |
| inactive | Indicates whether the tracked entity is inactive or not. | No | No | Boolean | Default: False, True |
| deleted | Indicates whether the tracked entity has been deleted. It can only change when deleting. | No | Yes | Boolean | False until deleted |
| geometry | A  geographical representation of the tracked entity. Based on the "featureType" of the TrackedEntityType. | No | No | GeoJson | {<br>"type": "POINT",<br>"coordinates": [123.0, 123.0]<br>} |
| storedBy | Client reference for who stored/created the tracked entity. | No | No | String:Any | John Doe |
| attributes | A list of tracked entity attribute values owned by the tracked entity. | No | No | List of TrackedEntityAttributeValue | See Attribute |
| enrollments | A list of enrollments owned by the tracked entity. | No | No | List of Enrollment | See Enrollment |
| relationships | A list of relationships connected to the tracked entity. | No | No | List of Relationship | See Relationship |
| programOwners | A list of organisation units that have access through specific programs to this tracked entity. See "Program Ownership" for more. | No | No | List of ProgramOwner | See section "Program Ownership" |

> ***Note***
> `Tracked Entities` "owns" all `Tracked Entity Attribute Values` (Or "attributes" as described in the previous table). However, `Tracked Entity Attributes` are either connected to a `Tracked Entity` through its `Tracked Entity Type` or a `Program`. We often refer to this separation as `Tracked Entity Type Attrbiutes` and `Tracked Entity Program Attributes`. The importance of this separation is related to access control and limiting what information the user can see.
>
> The "attributes" referred to in the `Tracked Entity` are `Tracked Entity Type Attributes`.


### Enrollment
`Tracked Entities` can enroll into `Programs` for which they are eligible. We represent the enrollment with the `Enrollment` object, which we describe in this section.


| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| enrollment | The identifier of the enrollment. Generated if not supplied | No | Yes | String:Uid | ABCDEF12345 |
| program | The program the enrollment represents. | Yes | No | String:Uid | ABCDEF12345 |
| trackedEntity | A reference to the tracked entity enrolled. | Yes | Yes | String:Uid | ABCDEF12345 |
| trackedEntityType | Only for reading data. The type of tracked entity enrolled | No | Yes | String:Uid | ABCDEF12345 |
| status | Status of the enrollment. ACTIVE if not supplied. | No | No | Enum | ACTIVE, COMPLETED, CANCELLED |
| orgUnit | The organisation unit where the user enrolled the tracked entity. | Yes | No | String:Uid | ABCDEF12345 |
| orgUnitName | Only for reading data. The name of the organisation unit where the enrollment took place. | No | No | String:Any | Sierra Leone |
| createdAt | Timestamp when the user created the object. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| createdAtClient | Timestamp when the user created the object on client | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAt | Timestamp when the object was last updated. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAtClient | Timestamp when the object was last updated on client | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| enrolledAt | Timestamp when the user enrolled the tracked entity. | Yes | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| occurredAt | Timestamp when something occurred. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| completedAt | Timestamp when the user completed the enrollment. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| completedBy | Reference to who completed the enrollment | No | No | John Doe |
| followUp | Indicates whether the enrollment requires follow-up. False if not supplied | No | No | Booelan | Default: False, True |
| deleted | Indicates whether the enrollment has been deleted. It can only change when deleting. | No | Yes | Boolean | False until deleted |
| geometry | A  geographical representation of the enrollment. Based on the "featureType" of the Program | No | No | GeoJson | {<br>"type": "POINT",<br>"coordinates": [123.0, 123.0]<br>} |
| storedBy | Client reference for who stored/created the enrollment. | No | No | String:Any | John Doe |
| attributes | A list of tracked entity attribute values connected to the enrollment. | No | No | List of TrackedEntityAttributeValue | See Attribute |
| events | A list of events owned by the enrollment. | No | No | List of Event | See Event |
| relationships | A list of relationships connected to the enrollment. | No | No | List of Relationship | See Relationship |
| notes | Notes connected to the enrollment. It can only be created. | No | Yes | List of Note | See Note |

> ***Note***
> `Tracked Entities` "owns" all `Tracked Entity Attribute Values` (Or "attributes" as described in the previous table). However, `Tracked Entity Attributes` are either connected to a `Tracked Entity` through its `Tracked Entity Type` or a `Program`. We often refer to this separation as `Tracked Entity Type Attrbiutes` and `Tracked Entity Program Attributes`. The importance of this separation is related to access control and limiting what information the user can see.
>
> The "attributes" referred to in the `Enrollment` are `Tracked Entity Program Attributes`.


### Events
`Events` are either part of an `EVENT PROGRAM` or `TRACKER PROGRAM`. For `TRACKER PROGRAM`, events belong to an `Enrollment`, which again belongs to a `Tracked Entity`. On the other hand, `EVENT PROGRAM` is `Events` not connected to a specific `Enrollment` or `Tracked Entity`. The difference is related to whether we track a specific `Tracked Entity` or not. We sometimes refer to `EVENT PROGRAM` events as "anonymous events" or "single events" since they only represent themselves and not another `Tracked Entity`.

In the API, the significant difference is that all events are either connected to the same enrollment (`EVENT PROGRAM`) or different enrollments (`TRACKER PROGRAM`). The table below will point out any exceptional cases between these two.

| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| event | The identifier of the event. Generated if not supplied | No | Yes | String:Uid | ABCDEF12345 |
| programStage | The program stage the event represents. | Yes | No | String:Uid | ABCDEF12345 |
| enrollment | A reference to the enrollment which owns the event. | Yes | Yes | String:Uid | ABCDEF12345 |
| program | Only for reading data. The type of program the enrollment which owns the event has. | No | Yes | String:Uid | ABCDEF12345 |
| trackedEntity | Only for reading data. The tracked entity which owns the event. ***Not applicable for `EVENT PROGRAM`*** | No | No | String:Uid | ABCDEF12345 |
| status | Status of the event. ACTIVE if not supplied. | No | No | Enum | ACTIVE, COMPLETED, VISITED, SCHEDULE, OVERDUE, SKIPPED |
| enrollmentStatus | Only for reading data. The status of the enrollment which owns the event. ***Not applicable for `EVENT PROGRAM`*** | No | No | Enum | ACTIVE, COMPLETED, CANCELLED |
| orgUnit | The organisation unit where the user registered the event. | Yes | No | String:Uid | ABCDEF12345 |
| orgUnitName | Only for reading data. The name of the organisation unit where the user registered the event. | No | No | String:Any | Sierra Leone |
| createdAt | Timestamp when the user created the event. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| createdAtClient | Timestamp when the user created the event on client | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAt | Timestamp when the event was last updated. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAtClient | Timestamp when the event was last updated on client | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| scheduledAt | Timestamp when the event was scheduled for. | Yes | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| occurredAt | Timestamp when something occurred. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| completedAt | Timestamp when the user completed the event. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| completedBy | Reference to who completed the event | No | No | String:Any | John Doe |
| followUp | Indicates whether the event has been flagged for follow-up. False if not supplied | No | No | Booelan | Default: False, True |
| deleted | Indicates whether the event has been deleted. It can only change when deleting. | No | Yes | Boolean | False until deleted |
| geometry | A  geographical representation of the event. Based on the "featureType" of the Program Stage | No | No | GeoJson | {<br>"type": "POINT",<br>"coordinates": [123.0, 123.0]<br>} |
| storedBy | Client reference for who stored/created the event. | No | No | String:Any | John Doe |
| attributeOptionCombo | Attribute option combo for the event. Default if not supplied or configured. | No | No | String:Uid | ABCDEF12345
| attributeCategoryOptions | Attribute category option for the event. Default if not supplied or configured. | No | No | String:Uid | ABCDEF12345
| assignedUser | A reference to a user who has been assigned to the event. | No | No | String:Uid | ABCDEF12345 |
| dataValues | A list of data values connected to the event. | No | No | List of TrackedEntityAttributeValue | See Attribute |
| relationships | A list of relationships connected to the event. | No | No | List of Relationship | See Relationship |
| notes | Notes connected to the event. It can only be created. | No | Yes | List of Note | See Note |

### Relationship

`Relationships` are objects that link together two other tracker objects. The constraints each side of the relationship must conform to are based on the `Relationship Type` of the `Relationship`.


| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| relationship | The identifier of the relationship. Generated if not supplied. | No | Yes | String:Uid | ABCDEF12345 |
| relationshipType | The type of the relationship. Decides what objects can be linked in a relationship. | Yes | Yes | String:Uid | ABCDEF12345 |
| relationshipName | Only for reading data. The name of the relationship type of this relationship | No | No | String:Any | Sibling |
| createdAt | Timestamp when the user created the relationship. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAt | Timestamp when the relationship was last updated. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| bidirectional | Only for reading data. Indicated whether the relationship type is bidirectional or not. | No | No | Boolean | True or False |
| from, to | A reference to each side of the relationship. Must conform to the constraints set in the relationship type | Yes | Yes | RelationshipItem | {"trackedEntity": "ABCEF12345"}, {"enrollment": "ABCDEF12345"} or {"event": "ABCDEF12345"} |

>***Note***
>`Relationship item` represents a link to an object. Since a `relationship` can be between any tracker object like `tracked entity`, `enrollment`, and `event`, the value depends on the `relationship type`. For example, if the `relationship type` connects from an `event` to a `tracked entity`, the format is strict:
>```json
>{
>   "from": {
>     "event": "ABCDEF12345"    
>   },
>   "to": {
>     "trackedEntity": "FEDCBA12345"
>   }
>}
>```

### Attribute
`Attributes` are the actual values describing the `tracked entities`. They can either be connected through a `tracked entity type` or a `program`. Implicitly this means `attributes` can be part of both a `tracked entity` and an `enrollment`.

| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| attribute | A reference to the tracked entity attribute represented. | Yes | Yes | String:Uid | ABCDEF12345 |
| code | Only for reading data. The code of the tracked entity attribute. | No | No | String:Any | ABC |
| displayName | Only for reading data. The displayName of the tracked entity attribute. | No | No | String:Any | Name |
| createdAt | Timestamp when the value was added. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAt | Timestamp when the value was last updated. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| storedBy | Client reference for who stored/created the value. | No | No | String:Any | John Doe |
| valueType | Only for reading data. The type of value the attribute represents. | No | No | Enum | TEXT, INTEGER, and more |
| value | The value of the tracked entity attribute. | No | No | String:Any | John Doe |

>***Note***
> For `attributes` only the "attribute" and "value" properties are required when adding data. "value" can be null, which implies the user should remove the value.

>***Note***
> In the context of tracker objects, we refer to `Tracked Entity Attributes` and `Tracked Entity Attribute Values` as "attributes". However, attributes are also their own thing, related to metadata. Therefore it's vital to separate Tracker attributes and metadata attributes. In the tracker API, it is possible to reference the metadata attributes when specifying `idScheme` (See request parameters for more information).

### Data Values
While `Attributes` describes a `tracked entity` or an `enrollment`, `data values` describes an `event`. The major difference is that `attributes` can only have a single value for a given `tracked entity`. In contrast, `data values` can have many different values across different `events` - even if the `events` all belong to the same `enrollment` or `tracked entity`.

| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| dataElement | The data element this value represents. | Yes | Yes | String:Uid | ABCDEF12345 |
| value | The value of the data value. | No | No | String:Any | 123 |
| providedElsewhere | Indicates whether the user provided the value elsewhere or not. False if not supplied. | No | No | Boolean | False or True |
| createdAt | Timestamp when the user added the value. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAt | Timestamp when the value was last updated. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| storedBy | Client reference for who stored/created the value. | No | No | String:Any | John Doe |


### Note
DHIS2 tracker allows for capturing of data using data elements and tracked entity attributes. However, sometimes there could be a situation where it is necessary to record additional information or comment about the issue at hand. Such additional information can be captured using tracker notes. Tracker notes are equivalent of data value comments from Aggregate DHIS2 side.

There are two types of tracker notes - notes recorded at event level and those recorded at enrollment level. An enrollment can have one or more events. Comments about each of the events - for example why an event was missed, rescheduled or why only few data elements were filled and the like - can be documented using event notes. Each of the events within an enrollment can have their own story/notes. One can then record for example an overall observation of these events using the parent enrollment note. Enrollment notes are also useful to document for example why an enrollment is canceled. It is the user's imagination and usecase when and how to use notes.

Both enrollment and event can have as many notes as needed - there is no limit. However, it is not possible to delete or update neither of these notes. They are like a logbook. If one wants to amend a note, can do so by creating another note. The only way to delete a note is by deleting the parent object - either event or enrollment. 

Tracker notes do not have their own dedicated endpoint, they are exchanged as part of the parent event and/or enrollment payload. Below is a sample payload.

```json
{
  "trackedEntityInstance": "oi3PMIGYJH8",
  <entity_details>,
  ],
  "enrollments": [
    {
      "enrollment": "EbRsJr8LSSO",
      <enrollment_details>
      "notes": [
        {
          "note": "vxmCvYcPdaW",
          "value": "Enrollment note 2.",
        },
        {
          "value": "Enrollment note 1",
        }
      ],
      
      "events": [
        {
          "event": "zfzS9WeO0uM",
          <event_details>,
          "notes": [
            {
              "note": "MAQFb7fAggS",
              "value": "Event Note 1.",
            },
            {
              "value": "Event Note 2.",
            }
          ],
        },
        {
          ...
        }
      ]
    }
  ]
}
```


| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| note | The reference of the note. Generated if empty | No | Yes | String:Uid | ABCDEF12345 |
| value | The content of the note. | Yes | Yes | String:Any | This is a note |
| storedAt | Timestamp when the user added the note. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAt | Timestamp when the note was last updated. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| storedBy | Client reference for who stored/created the note. | No | No | String:Any | John Doe |

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

The Tracker API has two primary endpoints for consumers to acquire feedback from their imports. These endpoints are most relevant for async import jobs, but are available for sync job as well. These endpoints will return either the log related to the import, or the import summary itself.

>***Note****
>These endpoints rely on information stored in the application memory. This means the information will be unavailable after certain cases, like a application restart or after a large number of import requests have started after this one.

After submitting a tracker import request, we can access following endpoints in order to monitor the job progress based on logs:

`GET /tracker/jobs/{uid}`

| Parameter|Description|Example
|---|---|---|
|`{uid}`| The UID of an existing tracker import job | ABCDEF12345

#### ***REQUEST*** example

`GET /tracker/jobs/mEfEaFSCKCC`

#### ***RESPONSE*** example

```json
[
  {
    "uid": "mEfEaFSCKCC",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2021-01-01T00:00:06.00",
    "message": "TRACKER_IMPORT_JOB ( mEfEaFSCKCC ) finished in 6.00000 sec. Import:Done",
    "completed": true,
    "id": "mEfEaFSCKCC"
  },
  {
    "uid": "mEfEaFSCKCC",
    "level": "DEBUG",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2021-01-01T00:00:05.00",
    "message": "TRACKER_IMPORT_JOB ( mEfEaFSCKCC ) commit completed in 1.00000 sec. Import:commit",
    "completed": true,
    "id": "mEfEaFSCKCC"
  },
  {
    "uid": "mEfEaFSCKCC",
    "level": "DEBUG",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2021-01-01T00:00:04.00",
    "message": "TRACKER_IMPORT_JOB ( mEfEaFSCKCC ) programruleValidation completed in 1.00000 sec. Import:programruleValidation",
    "completed": true,
    "id": "mEfEaFSCKCC"
  },
  {
    "uid": "mEfEaFSCKCC",
    "level": "DEBUG",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2021-01-01T00:00:03.00",
    "message": "TRACKER_IMPORT_JOB ( mEfEaFSCKCC ) programrule completed in 1.00000 sec. Import:programrule",
    "completed": true,
    "id": "mEfEaFSCKCC"
  },
  {
    "uid": "mEfEaFSCKCC",
    "level": "DEBUG",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2021-01-01T00:00:02.00",
    "message": "TRACKER_IMPORT_JOB ( mEfEaFSCKCC ) validation completed in 1.00000 sec. Import:validation",
    "completed": true,
    "id": "mEfEaFSCKCC"
  },
  {
    "uid": "mEfEaFSCKCC",
    "level": "DEBUG",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2021-01-01T00:00:01.00",
    "message": "TRACKER_IMPORT_JOB ( mEfEaFSCKCC ) preheat completed in 1.00000 sec. Import:preheat",
    "completed": true,
    "id": "mEfEaFSCKCC"
  },
  {
    "uid": "mEfEaFSCKCC",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2021-01-01T00:00:00.00",
    "message": "TRACKER_IMPORT_JOB ( mEfEaFSCKCC ) started by admin ( xE7jOejl9FI ) Import:Start",
    "completed": true,
    "id": "mEfEaFSCKCC"
  }
]
```

Additionally, the following endpoint will return the import summary of the import job. This import summary will only be available after the import has completed:

`GET /tracker/jobs/{uid}/report`

| Parameter|Description|Example
|---|---|---|
|path `/{uid}`| The UID of an existing tracker import job | ABCDEF12345
|`reportMode`| The level of report to return | `FULL`&#124;`ERRORS`&#124;`WARNINGS`|

#### ***REQUEST*** example

`GET /tracker/jobs/mEfEaFSCKCC/report`

#### ***RESPONSE*** example

The [response payload](#sample-responses) is the same as the one returned after a sync import request.

>***Note***
> Both endpoints are used primarily for async import, however `GET /tracker/jobs/{uid}` would also work for sync request as it eventually uses same import process and logging as async requests.

### Import Summary Structure

Import summaries have the following overall structure, depending on the requested `reportMode`:
```json
{
  "status": "...",
  "validationReport": { },
  "stats": { },
  "timingsStats": { },
  "bundleReport": { },
  "message" : { }
}
```

***status***

The property, `status`, of the import summary indicates the overall status of the import. If no errors or warnings was raised during the import, the `status` is reported as `OK`. The presence of any error or warnings in the import will result in a status of type `ERROR` or `WARNING`.

`status` is based on the presence of the most significant `validationReport`. `ERROR` has the highest significance, followed by `WARNING` and finally `OK`. This implies `ERROR` is reported as long as a single error was found during the import, regardless of how many warnings occurred.

>***Note***
>If the import is performed using the AtomicMode "OBJECT", where the import will import any data without validation errors, the overall status will still be `ERROR` if any errors was found.

***validationReport***

The `validationReport` may include `errorReports` and `warningReports` if any errors or warnings were present during the import. When present, they provide a detailed list of any errors or warnings encountered.

For example, a validation error while importing a `TRACKED_ENTITY`:
```json
{
  "validationReport": {
    "errorReports": [
      {
        "message": "Could not find TrackedEntityType: `Q9GufDoplCL`.",
        "errorCode": "E1005",
        "trackerType": "TRACKED_ENTITY",
        "uid": "Kj6vYde4LHh"
      },
      ...
    ],
    "warningReports" : [ ... ]
  }
}
```

The report contains a message and a code describing the actual error (See the [error codes](#error-codes) section for more information about errors). Additionally, the report includes the `trackerType` and `uid` which aims to describe where in the data the error was found. In this case, there was a `TRACKED_ENTITY` with the uid `Kj6vYde4LHh` which had a reference to a tracked entity type which was not found.

>***Note 1***
>When referring to the `uid` of tracker objects, they are labeled as their object names in the payload. For example, the `uid` of a tracked entity would in the payload have the name "trackedEntity". The same goes for "enrollment", "event" and "relationship" for enrollments, events and relationships respectively.

>***Note 2***
>If no uid is provided in the payload, the import process will generate new uids. This means the error report might refer to a uid that does not exist in your payload.

>***Note 3***
>Errors are represents issues with the payload which the importer can not circumvent. Any errors will block that data from being imported. Warnings on the other hand are issues where it's safe to circumvent them, but the user should be made aware that it happened. Warnings will not block data from being imported.

***stats***

The status provides a quick overview of the import. After an import is completed, this will be the actual counts representing how much data was created, updated, deleted or ignored.

Example:
```json
{
  "stats": {
    "created": 2,
    "updated": 2,
    "deleted": 1,
    "ignored": 5,
    "total": 10
  }
}
```
`created` refers to how many new objects which was created. In general, objects without an existing uid in the payload will be treated as a new object.

`updated` refers to the number of objects updated. Objects with an existing uid in the payload will be treated as updating an existing object.

`deleted` refers to the amount of objects deleted during the import. Deletion only happens when the import is configured to delete data, and only then when the objects in the payload have existing uids set.

`ignored` refers to objects that was not persisted. Objects can be ignored for several reasons, for example trying to create something that already exists. Ignores should always be safe, so if something was ignored, it was either not neccesary or it was due to the configuration of the import.

***timingsStats***

`timingStats` represents the time elapsed in different steps of the import. These stats does not provide an accurate overall time for the import, but rather the time spent in the code for different steps.

The `timingStats` are primarily useful for debugging imports that are causing issues, to see which part of the import is having issues.
```json
{
  "timingsStats": {
    "timers": {
      "preheat": "0.234086 sec.",
      "preprocess": "0.000058 sec.",
      ...
      "totalImport": "0.236810 sec.",
      "validation": "0.001533 sec."
    }
  }
}
```

***bundleReport***

When the import is completed, the `bundleReport` contains all the [tracker objects](#tracker-objects) imported.

For example, `TRACKED_ENTITY`:
```json
{
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
      ...
    }
  }
}
```
As seen, each type of tracker object will be reported, and each has their own stats and `objectReports`. These `objectReports` will provide details about each imported object, like their type, their uid and any error or warning reports is applicable.

***message***

If the import ended abruptly, the `message` would contain further information in relation to what happened.

### Import Summary Report Level

As previously stated, `GET /tracker/jobs/{uid}/report` can be retrieved using a specific `reportMode` parameter. By default the endpoint will return an `importSummary` with `reportMode` `ERROR`.

| Parameter | Description |
|---|---|
| `FULL` | Returns everything from `WARNINGS`, plus `timingsStats` |
| `WARNINGS` | Returns everything from `ERRORS`, plus `warningReports` in `validationReports` |
| `ERRORS` (default) | Returns only `errorReports` in `validationReports` |

In addition, all `reportModes` will return `status`, `stats`, `bundleReport` and `message` when applicable.

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

### Assign user to events

<!--DHIS2-SECTION-ID:webapi_nti_user_event_assignment-->

Certain workflows benefits from treating events like tasks, and for this reason you can assign a user to an event.

Assigning a user to an event, will not change the access or permissions for users, but will create a link between the event and the user.
When an event have a user assign, you can query events from the API using the `assignedUser` field as a parameter.

When you want to assign a user to an event, you simply provide the UID of the user you want to assign in the `assignedUser` field. See the following example:

```json
{
  ...
  "events": [
    {
      "event": "ZwwuwNp6gVd",
      "programStage": "nlXNK4b7LVr",
      "orgUnit": "O6uvpzGd5pu",
      "enrollment": "MNWZ6hnuhSw",
      "assignedUser" : "M0fCOxtkURr"
    }
  ],
  ...
}
```

In this example, the user with uid `M0fCOxtkURr` will be assign to the event with uid `ZwwuwNp6gVd`. Only one user can be assigned to a single event.

To use this feature, the relevant program stage needs to have user assignment enabled, and the uid provided for the user must refer to a valid, existing user.

## Tracker Export

<!--DHIS2-SECTION-ID:webapi_nti_export-->

Tracker export endpoints are a set of services which allow clients to query and retrieve objects stored using import endpoint.

Beside differences highlighted in **[Changes in the API](#Changes-in-the-API)**, request parameters for these endpoints match older ones.

These endpoints are still being developed, and are subject to change. However, 
the `request` and `response` interfaces will most likely not undergo significant changes.

Tracker export endpoints deal with the following Tracker objects:

- **Tracked Entities**
- **Events**
- **Enrollments**
- **Relationships**

> **_NOTE 1:_** 
> 
> These endpoints currently only support `JSON`, but `CSV` will be supported in the near future.


> **_NOTE 2:_**
> 
> These endpoints adopt the new naming convention documented in **[Changes in the API](#Changes-in-the-API)** 

> **_NOTE 3:_**
> 
> The following functionalities are still missing, but available in older endpoints:
> - field filtering

### Common request parameters

The following endpoint supports common parameters for pagination

- **Tracked Entities** `GET /api/tracker/trackedEntities`
- **Events** `GET /api/tracker/events`
- **Enrollments** `GET /api/tracker/enrollments`

#### Request parameters for pagination

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`page`|`Integer`| Any positive integer |Page number to return. Defaults to 1 if missing|
|`pageSize`|`Integer`| Any positive integer |Page size. Defaults to 50. |
|`totalPages`|`Boolean`| `true`&#124;`false` |Indicates whether to return the total number of pages in the response |
|`skipPaging`|`Boolean`| `true`&#124;`false` |Indicates whether paging should be ignored and all rows should be returned TODO [VERIFY]|
|`paging`|`Boolean`| `true`&#124;`false`  | Indicates whether paging is enabled TODO [VERIFY]| 
|`order`|`String`|comma-delimited list of `OrderCriteria` in the form of `propName:sortDirection`.<br><br> Example: `createdAt:desc`<br><br>**Note:** `propName` is case sensitive, `sortDirection` is case insensitive|Sort the response based on given `OrderCriteria`|

> **_NOTE_**
> 
> Be aware that the performance is directly related to the amount of data requested. Bigger pages will take more time to return.
#### Request parameters for Organisational Unit selection mode

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

### Tracked Entities

Two endpoints are dedicated to tracked entities:

- `GET /api/tracker/trackedEntities`
  - retrieves tracked entities matching given criteria
- `GET /api/tracker/trackedEntities/{id}`
  - retrieves a tracked entity given the provided id
    
#### Tracked Entities Collection endpoint `GET /api/tracker/trackedEntities`

The purpose of this endpoint is to retrieve tracked entities matching client-provided criteria.

The endpoint returns a list of tracked entities that match the request parameters.

##### Request syntax

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`query`|`String`|`{operator}:{filter-value}`|Creates a filter over tracked entity attributes. Only the filter-value is mandatory, `EQ` operator is used if `operator` is not specified.|
|`attribute`|`String`|Comma separated values of attribute `UID` ??| For each tracked entity in the response, only returns specified attributes |
|`filter`|`String`|Comma separated values of filters|Filter are properties or attributes with operator and value.<br>Example: `filter=updatedAfter:lt:2000-01-01`<br>Multiple filters are allowed. User needs access to attribute to be able to have a filter on it|
|`orgUnit`|`String`|semicolon-delimited list of organisational unit `UID`|Only return tracked entity instances belonging to provided organisational units|
|`ouMode` see [ouModes](#Request-parameters-for-Organisational-Unit-selection-mode)|`String`|`SELECTED`&#124;`CHILDREN`&#124;`DESCENDANTS`&#124;`ACCESSIBLE`&#124;`CAPTURE`&#124;`ALL`|The mode of selecting organisation units, can be. Default is `SELECTED`, which refers to the selected organisation units only.|
|`program`|`String`|Program `UID`| a Program `UID` for which instances in the response must be enrolled in|
|`programStatus`|`String`|`ACTIVE`&#124;`COMPLETED`&#124;`CANCELLED`|The ProgramStatus of the Tracked Entity Instance in the given program|
|`programStage`|`String`|`UID`|a Program Stage `UID` for which instances in the response must have events on|
|`followUp`|`Boolean`|`true`&#124;`false`|Indicates whether the Tracked Entity Instance is marked for follow up for the specified Program|
|`updatedAfter`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) | Start date for last updated|
|`updatedBefore`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) | End date for last updated|
|`updatedWithin`|`Duration`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601#Durations) | Returns TEIs not older than specified Duration|
|`enrollmentEnrolledAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|Start date for incident in the given program|
|`enrollmentEnrolledBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|End date for incident in the given program|
|`enrollmentOccurredAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|Start date for incident in the given program|
|`enrollmentOccurredBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|End date for incident in the given program|
|`trackedEntityType`|`String`|UID of tracked entity type|Only returns Tracked Entity Instances of given type|
|`trackedEntity`|`String`|semicolon-delimited list of tracked entity instance `UID`|Filter the result down to a limited set of teis using explicit uids of the tracked entity instances by using `trackedEntity=id1;id2`. This parameter will at the very least create the outer boundary of the results, forming the list of all teis using the uids provided. If other parameters/filters from this table are used, they will further limit the results from the explicit outer boundary.|
|`assignedUserMode`|`String`|`CURRENT`&#124;`PROVIDED`&#124;`NONE`&#124;`ANY`|Restricts result to tei with events assigned based on the assigned user selection mode|
|`assignedUser`|`String`|Semicolon-delimited list of user UIDs to filter based on events assigned to the users.|Filter the result down to a limited set of teis with events that are assigned to the given user IDs by using `assignedUser=id1;id2`.This parameter will be considered only if assignedUserMode is either `PROVIDED` or `null`. The API will error out, if for example, `assignedUserMode=CURRENT` and `assignedUser=someId`|
|`eventStatus`|`String`|`ACTIVE`&#124;`COMPLETED`&#124;`VISITED`&#124;`SCHEDULE`&#124;`OVERDUE`&#124;`SKIPPED`|Status of any events in the specified program|
|`eventOccurredAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|Start date for Event for the given Program|
|`eventOccurredBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|End date for Event for the given Program|
|`skipMeta`|`Boolean`|`true`&#124;`false`|Indicates whether not to include meta data in the response.|
|`includeDeleted`|`Boolean`|`true`&#124;`false`|Indicates whether to include soft-deleted elements|
|`includeAllAttributes`|`Boolean`|`true`&#124;`false`|Indicates whether to include all TEI attributes|
|`attachment`|`String`| |The file name in case of exporting as a file|


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
        &attribure=AMpUYgxuCaE&orgUnit=DiszpKrYNg8;yMCshbaVExv

A query for instances where attributes are included in the response
and one attribute is used as a filter:

    GET /api/tracker/trackedEntities?filter=zHXD5Ve1Efw:EQ:A
        &filter=AMpUYgxuCaE:LIKE:Road
        &orgUnit=DiszpKrYNg8

A query where multiple operand and filters are specified for a filter
item:

    GET /api/tracker/trackedEntities?orgUnit=DiszpKrYNg8
        &program=ur1Edk5Oe2n
        &filter=lw1SqmMlnfh:GT:150
        &filter=lw1SqmMlnfh:LT:190

To query on an attribute using multiple values in an *IN* filter:

    GET /api/tracker/trackedEntities?orgUnit=DiszpKrYNg8
        &filter=dv3nChNSIxy:IN:Scott;Jimmy;Santiago

To constrain the response to instances which are part of a specific
program you can include a program query parameter:

    GET GET /api/tracker/trackedEntities?filter=zHXD5Ve1Efw:EQ:A
        &orgUnit=O6uvpzGd5pu&ouMode=DESCENDANTS
        &program=ur1Edk5Oe2n

To specify program enrollment dates as part of the query:

    GET /api/tracker/trackedEntities?
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

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`uid`|`String`|`uid`|Return the Tracked Entity Instance with specified `uid`|
|`program`|`String`|`uid`| Include program attributes in the response (only the ones user has access to) |
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

Two endpoints are dedicated to events:

- `GET /api/tracker/events`
    - retrieves events matching given criteria
- `GET /api/tracker/events/{id}`
    - retrieves an event given the provided id

#### Events Collection endpoint `GET /api/tracker/trackedEntities`

Returns a list of events based on filters.

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`program`|`String`|`uid`| Identifier of program|
|`programStage`|`String`|`uid`| Identifier of program stage|
|`programStatus`|`enum`| `ACTIVE`&#124;`COMPLETED`&#124;`CANCELLED`| Status of event in program | 
|`followUp`|`boolean`| `true`&#124;`false` | Whether event is considered for follow up in program. Defaults to `true`|
|`trackedEntityInstance`|`String`|`uid`| Identifier of tracked entity instance|
|`orgUnit`|`String`|`uid`| Identifier of organisation unit|
|`ouMode` see [ouModes](#Request-parameters-for-Organisational-Unit-selection-mode)|`String`| `SELECTED`&#124;`CHILDREN`&#124;`DESCENDANTS`|	Org unit selection mode| 
|`occurredAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|	Only events newer than this date|
|`occurredBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)| Only events older than this date|
|`status`|`String`|`COMPLETED`&#124;`VISITED`&#124;`SCHEDULED`&#124;`OVERDUE`&#124;`SKIPPED` | Status of event|
|`occurredAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) | Filter for events which were occurred after this date.|
|`occurredBefore`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)| Filter for events which were occurred up until this date.|
|`scheduledAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) | Filter for events which were scheduled after this date.|
|`scheduledBefore`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)| Filter for events which were scheduled up until this date.|
|`updatedAfter`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)| Filter for events which were updated after this date. Cannot be used together with `updatedWithin`.|
|`updatedBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) | Filter for events which were updated up until this date. Cannot be used together with `updatedWithin`.|
|`updatedWithin`|`Duration`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601#Durations)| Include only items which are updated within the given duration.<br><br> The format is [ISO-8601#Duration](https://en.wikipedia.org/wiki/ISO_8601#Durations)|
|`skipMeta`|`Boolean`| `true`&#124;`false` | Exclude the meta data part of response (improves performance)|
|`dataElementIdScheme`|`String`| `UID`&#124;`CODE`&#124;`ATTRIBUTE:{ID}`|	Data element ID scheme to use for export.|
|`categoryOptionComboIdScheme`|`String`| `UID`&#124;`CODE`&#124;`ATTRIBUTE:{ID}`| Category Option Combo ID scheme to use for export|
|`orgUnitIdScheme`|`String`| `UID`&#124;`CODE`&#124;`ATTRIBUTE:{ID}`| Organisation Unit ID scheme to use for export|
|`programIdScheme`|`String`| `UID`&#124;`CODE`&#124;`ATTRIBUTE:{ID}`| Program ID scheme to use for export|
|`programStageIdScheme`|`String`| `UID`&#124;`CODE`&#124;`ATTRIBUTE:{ID}`| Program Stage ID scheme to use for export|
|`idScheme`|`string`| `UID`&#124;`CODE`&#124;`ATTRIBUTE:{ID}`| Allows to set id scheme for data element, category option combo, orgUnit, program and program stage at once.|
|`order`|`String`|comma-delimited list of `OrderCriteria` in the form of `propName:sortDirection`.<br><br> Example: `createdAt:desc`<br><br>**Note:** `propName` is case sensitive, `sortDirection` is case insensitive|Sort the response based on given `OrderCriteria`|
|`event`|`String`|comma-delimited list of `uid`| Filter the result down to a limited set of IDs by using event=id1;id2.|
|`skipEventId`|`Boolean`| |	Skips event identifiers in the response|
|`attributeCc` (see note)|`String`| Attribute category combo identifier (must be combined with attributeCos)|
|`attributeCos` (see note)|`String`| Attribute category option identifiers, separated with ; (must be combined with attributeCc)|
|`includeDeleted`|`Boolean`| |	When true, soft deleted events will be included in your query result.|
|`assignedUserMode`|`String`| `CURRENT`&#124;`PROVIDED`&#124;`NONE`&#124;`ANY`| Assigned user selection mode|
|`assignedUser`|`String`|comma-delimited list od `uid`| Filter the result down to a limited set of events that are assigned to the given user IDs by using `assignedUser=id1;id2`.<br><br>This parameter will be considered only if assignedUserMode is either `PROVIDED` or `null`.<br><br>The API will error out, if for example, `assignedUserMode=CURRENT` and `assignedUser=someId`|

> **Note**
>
> If the query contains neither `attributeCC` nor `attributeCos`, 
> the server returns events for all attribute option combos where the user has read access.

##### Example requests

Query for all events with children of a certain organisation unit:

    GET /api/tracker/events?orgUnit=YuQRtpLP10I&ouMode=CHILDREN

Query for all events with all descendants of a certain organisation
unit, implying all organisation units in the sub-hierarchy:

    GET /api/tracker/events?orgUnit=O6uvpzGd5pu&ouMode=DESCENDANTS

Query for all events with a certain program and organisation unit:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc

Query for all events with a certain program and organisation unit,
sorting by due date
ascending:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc&order=dueDate

Query for the 10 events with the newest event date in a certain program
and organisation unit - by paging and ordering by due date descending:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc
      &order=eventDate:desc&pageSize=10&page=1

Query for all events with a certain program and organisation unit for a
specific tracked entity instance:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8
      &program=eBAyeGv0exc&trackedEntityInstance=gfVxE3ALA9m

Query for all events with a certain program and organisation unit older
or equal to
2014-02-03:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc&endDate=2014-02-03

Query for all events with a certain program stage, organisation unit and
tracked entity instance in the year 2014:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc
      &trackedEntityInstance=gfVxE3ALA9m&occurredAfter=2014-01-01&occurredBefore=2014-12-31

Retrieve events with specified Organisation unit and Program, and use `Attribute:Gq0oWTf2DtN` as
identifier scheme

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=lxAQ7Zs9VYR&idScheme=Attribute:Gq0oWTf2DtN

Retrieve events with specified Organisation unit and Program, and use UID as identifier scheme for
orgUnits, Code as identifier scheme for Program stages, and _Attribute:Gq0oWTf2DtN_ as identifier
scheme for the rest of the metadata with assigned attribute.

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=lxAQ7Zs9VYR&idScheme=Attribute:Gq0oWTf2DtN
      &orgUnitIdScheme=UID&programStageIdScheme=Code

##### Response format

The `JSON` response can look like the following.

Please note that field filtering (`fields=...`) support is planned but not yet implemented.

```json
{
    "instances": [
        {
            "href": "https://play.dhis2.org/dev/api/tracker/events/rgWr86qs0sI",
            "event": "rgWr86qs0sI",
            "status": "ACTIVE",
            "program": "kla3mAPgvCH",
            "programStage": "aNLq9ZYoy9W",
            "orgUnit": "DiszpKrYNg8",
            "orgUnitName": "Ngelehun CHC",
            "relationships": [],
            "occurredAt": "2021-10-12T00:00:00.000",
            "followup": false,
            "deleted": false,
            "createdAt": "2018-10-20T12:09:19.492",
            "updatedAt": "2018-10-20T12:09:19.492",
            "attributeOptionCombo": "amw2rQP6r6M",
            "attributeCategoryOptions": "RkbOhHwiOgW",
            "dataValues": [
                {
                    "createdAt": "2015-10-20T12:09:19.640",
                    "updatedAt": "2015-10-20T12:09:19.640",
                    "storedBy": "system",
                    "providedElsewhere": false,
                    "dataElement": "HyJL2Lt37jN",
                    "value": "12"
                },
              ...
            ],
            "notes": []
        }
    ],
    "page": 1,
    "pageSize": 1
}
```
#### Events single object endpoint `GET /api/tracker/events/{uid}`

Purpose of this endpoint is to retrieve one event given its uid.

##### Request syntax

`GET /api/tracker/events/{uid}?fields={fields}`

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`uid`|`String`|`uid`|Return the Event with specified `uid`|
|`fields`|`String`| **Not implemented yet**|Include specified properties in the response| 

##### Example requests

A query for an Event:

    GET /api/tracker/events/rgWr86qs0sI

##### Response format

```json
{
  "href": "https://play.dhis2.org/dev/api/tracker/events/rgWr86qs0sI",
  "event": "rgWr86qs0sI",
  "status": "ACTIVE",
  "program": "kla3mAPgvCH",
  "programStage": "aNLq9ZYoy9W",
  "enrollment": "Lo3SHzCnMSm",
  "enrollmentStatus": "ACTIVE",
  "orgUnit": "DiszpKrYNg8",
  "orgUnitName": "Ngelehun CHC",
  "relationships": [],
  "occurredAt": "2021-10-12T00:00:00.000",
  "followup": false,
  "deleted": false,
  "createdAt": "2018-10-20T12:09:19.492",
  "createdAtClient": "2017-10-20T12:09:19.492",
  "updatedAt": "2018-10-20T12:09:19.492",
  "attributeOptionCombo": "amw2rQP6r6M",
  "attributeCategoryOptions": "RkbOhHwiOgW",
  "dataValues": [
    {
      "createdAt": "2015-10-20T12:09:19.640",
      "updatedAt": "2015-10-20T12:09:19.640",
      "storedBy": "system",
      "providedElsewhere": false,
      "dataElement": "HyJL2Lt37jN",
      "value": "12"
    },
    {
      "createdAt": "2015-10-20T12:09:19.514",
      "updatedAt": "2015-10-20T12:09:19.514",
      "storedBy": "system",
      "providedElsewhere": false,
      "dataElement": "b6dOUjAarHD",
      "value": "213"
    },
    {
      "createdAt": "2015-10-20T12:09:19.626",
      "updatedAt": "2015-10-20T12:09:19.626",
      "storedBy": "system",
      "providedElsewhere": false,
      "dataElement": "UwCXONyUtGs",
      "value": "3"
    },
    {
      "createdAt": "2015-10-20T12:09:19.542",
      "updatedAt": "2015-10-20T12:09:19.542",
      "storedBy": "system",
      "providedElsewhere": false,
      "dataElement": "fqnXmRYo5Cz",
      "value": "123"
    },
    {
      "createdAt": "2015-10-20T12:09:19.614",
      "updatedAt": "2015-10-20T12:09:19.614",
      "storedBy": "system",
      "providedElsewhere": false,
      "dataElement": "Qz3kfeKgLgL",
      "value": "23"
    },
    {
      "createdAt": "2015-10-20T12:09:19.528",
      "updatedAt": "2015-10-20T12:09:19.528",
      "storedBy": "system",
      "providedElsewhere": false,
      "dataElement": "W7aC8jLASW8",
      "value": "12"
    },
    {
      "createdAt": "2015-10-20T12:09:19.599",
      "updatedAt": "2015-10-20T12:09:19.599",
      "storedBy": "system",
      "providedElsewhere": false,
      "dataElement": "HrJmqlBqTFG",
      "value": "3"
    }
  ],
  "notes": []
}
```

### Enrollments (`GET /api/tracker/enrollments`)

Two endpoints are dedicated to enrollments:

- `GET /api/tracker/enrollments`
    - retrieves enrollments matching given criteria
- `GET /api/tracker/enrollments/{id}`
    - retrieves an enrollment given the provided id

#### Enrollment Collection endpoint `GET /api/tracker/enrollments`

Returns a list of events based on filters.

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`orgUnit`|`String`|`uid`| Identifier of organisation unit|
|`ouMode` see [ouModes](#Request-parameters-for-Organisational-Unit-selection-mode)|`String`| `SELECTED`&#124;`CHILDREN`&#124;`DESCENDANTS`&#124;`ACCESSIBLE`&#124;`CAPTURE`&#124;`ALL|	Org unit selection mode| 
|`program`|`String`|`uid`| Identifier of program|
|`programStatus`|`enum`| `ACTIVE`&#124;`COMPLETED`&#124;`CANCELLED`| Program Status |
|`followUp`|`boolean`| `true`&#124;`false` | Follow up status of the instance for the given program. Can be `true`&#124;`false` or omitted.|
|`updatedAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) |	Only enrollments updated after this date|
|`updatedWithin`|`Duration`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)| Only enrollments updated since given duration |
|`enrolledAfter`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|	Only enrollments newer than this date|
|`enrolledBefore`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)| Only enrollments older than this date|
|`trackedEntityType`|`String`|`uid`| Identifier of tracked entity type|
|`trackedEntity`|`String`|`uid`| Identifier of tracked entity instance|
|`enrollment`|`String`|Comma-delimited list of `uid`| Filter the result down to a limited set of IDs by using enrollment=id1;id2.|
|`includeDeleted`|`Boolean`| |	When true, soft deleted events will be included in your query result.|

The query is case-insensitive. The following rules apply to the query parameters.

- At least one organisation unit must be specified using the `orgUnit`
  parameter (one or many), or *ouMode=ALL* must be specified.

- Only one of the *program* and *trackedEntity* parameters can be
  specified (zero or one).

- If *programStatus* is specified then *program* must also be
  specified.

- If *followUp* is specified then *program* must also be specified.

- If *enrolledAfter* or *enrolledBefore* is specified then *program* must also be specified.

##### Example requests

A query for all enrollments associated with a specific organisation unit
can look like this:

    GET /api/tracker/enrollments?orgUnit=DiszpKrYNg8

To constrain the response to enrollments which are part of a specific
program you can include a program query
parameter:

    GET /api/tracker/enrollments?orgUnit=O6uvpzGd5pu&ouMode=DESCENDANTS&program=ur1Edk5Oe2n

To specify program enrollment dates as part of the
query:

    GET /api/tracker/enrollments?&orgUnit=O6uvpzGd5pu&program=ur1Edk5Oe2n
      &enrolledAfter=2013-01-01&enrolledBefore=2013-09-01

To constrain the response to enrollments of a specific tracked entity
you can include a tracked entity query
parameter:

    GET /api/tracker/enrollments?orgUnit=O6uvpzGd5pu&ouMode=DESCENDANTS&trackedEntity=cyl5vuJ5ETQ

To constrain the response to enrollments of a specific tracked entity
instance you can include a tracked entity instance query parameter, in
this case we have restricted it to available enrollments viewable for
current
user:

    GET /api/tracker/enrollments?ouMode=ACCESSIBLE&trackedEntity=tphfdyIiVL6

##### Response format

The `JSON` response can look like the following.

Please note that field filtering (`fields=...`) support is planned but not yet implemented.

```json
{
  "instances": [
    {
      "enrollment": "iKaBMOyq7QQ",
      "createdAt": "2017-03-28T12:28:19.812",
      "createdAtClient": "2016-03-28T12:28:19.812",
      "updatedAt": "2017-03-28T12:28:19.817",
      "trackedEntity": "PpqV8ytvW5i",
      "trackedEntityType": "nEenWmSyUEp",
      "program": "ur1Edk5Oe2n",
      "status": "ACTIVE",
      "orgUnit": "NnQpISrLYWZ",
      "orgUnitName": "Govt. Hosp. Bonthe",
      "enrolledAt": "2020-10-23T12:28:19.805",
      "occurredAt": "2020-10-07T12:28:19.805",
      "followUp": false,
      "deleted": false,
      "events": [],
      "relationships": [],
      "attributes": [],
      "notes": []
    }
  ],
  "page": 1,
  "total": 1,
  "pageSize": 5
}
```

#### Enrollments single object endpoint `GET /api/tracker/enrollments/{uid}`

Purpose of this endpoint is to retrieve one enrollment given its uid.

##### Request syntax

`GET /api/tracker/enrollment/{uid}?fields={fields}`

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`uid`|`String`|`uid`|Return the Enrollment with specified `uid`|
|`fields`|`String`| **Not implemented yet**|Include specified sub-objects in the response| 

##### Example requests

A query for a Enrollment:

    GET /api/tracker/enrollments/iKaBMOyq7QQ

##### Response format

```json
{
  "enrollment": "iKaBMOyq7QQ",
  "createdAt": "2017-03-28T12:28:19.812",
  "createdAtClient": "2016-03-28T12:28:19.812",
  "updatedAt": "2017-03-28T12:28:19.817",
  "trackedEntity": "PpqV8ytvW5i",
  "trackedEntityType": "nEenWmSyUEp",
  "program": "ur1Edk5Oe2n",
  "status": "ACTIVE",
  "orgUnit": "NnQpISrLYWZ",
  "orgUnitName": "Govt. Hosp. Bonthe",
  "enrolledAt": "2020-10-23T12:28:19.805",
  "occurredAt": "2020-10-07T12:28:19.805",
  "followUp": false,
  "deleted": false,
  "events": [],
  "relationships": [],
  "attributes": [],
  "notes": []
}
```

### Relationships (`GET /api/tracker/relationships`)

Relationships are links between two entities in tracker.
These entities can be tracked entity instances, enrollments and events.

Purpose of this endpoint is to retrieve Relationships between objects.

Unlike other tracked objects endpoints, Relationship only expose one endpoint:

- `GET /api/tracker/relationships?[tei={teiUid}|enrollment={enrollmentUid}|event={eventUid}]&fields=[fields]`

#### Request parameters
|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`tei`|`String`|`uid`| Identifier of a Tracked Entity Instance|
|`enrollment`|`String`|`uid`| Identifier of an Enrollment |
|`event`|`String`|`uid`| Identifier of and Event|
|`fields`|`String`| | **Not implemented yet:** Only includes specified properties in the response| 

The following rules apply to the query parameters.

- only one parameter among `tei`,`enrollment`,`event` can be passed

> **NOTE:**
>
> using tei, enrollment or event params, will return any relationship where the tei\enrollment or
> event is part of the relationship (either from or to). As long as user has access that is.
> 

#### Example response

```json
[
  {
    "relationshipType": "dDrh5UyCyvQ",
    "relationshipName": "Mother-Child",
    "relationship": "t0HIBrc65Rm",
    "bidirectional": false,
    "from": {
      "trackedEntity": {
        "trackedEntity": "vOxUH373fy5"
      }
    },
    "to": {
      "trackedEntity": {
        "trackedEntity": "pybd813kIWx"
      }
    },
    "created": "2019-04-26T09:30:56.267",
    "lastUpdated": "2019-04-26T09:30:56.267"
  },
  ...,
]
```

## Tracker Access Control

<!--DHIS2-SECTION-ID:webapi_nti_access_control-->

### Metadata Sharing

<!--DHIS2-SECTION-ID:webapi_nti_metadata_sharing-->


Sharing setting is a standard DHIS2 functionality that applies to both Tracker and Aggregate metadata/data as well as dashboards and visualization items. At the core of sharing setting is the ability to define who can see/do what. In general there are 5 possible sharing configurations – no access, metadata read, metadata write, data read and data write. These access configurations can be granted at user and/or user group level (for more flexibility). With focus on Tracker, the following metadata and their sharing setting are of especial importance: Data Element, Category Option, Program, Program Stage, Tracked Entity Type, Tracked Entity Attribute as well as Tracker related Dashboards and Dashboard Items.

How sharing setting works is straightforward – the settings are enforced during Tracker data import/export processes. To read value, one needs to have data read access. If a user is expected to modify data, he/she needs to have data write access. Similarly if a user is expected to modify metadata, it is important to grant metadata write access.

One very important point with Tracker data is the need to have a holistic approach. For example a user won’t be able to see Data Element value by having read access to just the Data Element. The user needs to have data read access the parent Program Stage and Program where this Data Element belongs. It is the same with category option combination. In Tracker, Event is related to AttributeOptionCombo which is made up of combination of Category Options. Therefore, for a user to read data of an Event, he/she needs to have data read access to all Category Options, and corresponding Categories, that constitute the AttributeOptionCombo of the Event in question. If a user lacks access to just one Category Option or Category, then the user has no access to the entire Event.

When it comes accessing Enrollment data, it is important to have access to the Tracked Entity first. Access to a Tracked Entity is controlled through sharing setting of Program, Tracked Entity Type and Tracked Entity Attribute. Once Enrollment is accessed it is possible to access Event data, again depending on Program Stage and Data element sharing setting.

Another important point to consider is how to map out access to different Program Stages of a Program. Sometimes we could be in a situation where we need grant access to a specific stage – for example “Lab Result” – to specific group of users (Lab Technicians). In this situation, we can provide data write access to "Lab Result" stage, probably data read to one or more stages just in case we want Lab Technicians to read other medical results or no access if we think it not necessary for the Lab Technicians to see data other than lab related.

In summary, DHIS2 has fine grained sharing setting that we can use to implement access control mechanisms both at data and metadata level. These sharing settings can be applied directly at user level or user group level. How exactly to apply a sharing setting depends on the usecase at hand.

### Organisation Unit Scopes

<!--DHIS2-SECTION-ID:webapi_nti_ou_scope-->

Organisation units are one of the most fundamental objects in DHIS2. They define a universe under which a user is allowed to record and/or read data. There are three types of organisation units that can be assigned to a user. These are data capture, data view and tracker search. As the name implies, these organisation units define a scope under which a user is allowed to conduct the respective operations.

However, to further fine tune the scope, DHIS2 tracker introduces a concept that we call **OrganisationUnitSelectionMode**. Such a mode is often used at the time exporting tracker objects. For example, given a user has a particular tracker search scope does it mean that we have to use this scope every time a user tries to search for a tracker, enrollment or event object? Or is the user interested to limit the searching just to the selected org unit, or the entire capture org unit scope and so on. 

Users can do the fine-tuning by passing a specific value of ouMode in their API request:

*api/tracker?orgUnit=UID&ouMode=specific_organisation_unit_selection_mode*

Currently, there are six selection modes available: *SELECTED, CHILDREN, DESCENDANTS, CAPTURE, ACCESSIBLE and ALL*.

1. **SELECTED**: as the name implies, all operations intended by the requesting API narrow down to the selected organisation unit.
2. **CHILDREN**: under this mode, the organisation unit scope will be constructed using the selected organisation unit and its immediate children. 
3. **DESCENDANTS**: here the selected organisation unit and everything underneath it, not just the immediate children, constitute the data operation universe.
4. **CAPTURE**: as the name implies organisation units assigned as the user's data capture constitute the universe. Note that, of the three organisation units that can be assigned to a user data capture is the mandatory one. If a user does not have data vaiew and tracker search organisation units, the system will fall back to data capture. This way, we are always sure that a user has at least one universe.
5. **ACCESSIBLE**: technically this is the same scope as the user's tracker search organisation units.
6. **ALL**: the name ALL makes perfect sense if we are dealing with a super user. For super users, this scope means the entire organisation unit available in the system. However, for non-super users, ALL boils down to ACCESSIBLE organisation units.

It makes little sense to pass these modes at the time of tracker import operations. Because when writing tracker data, each of the objects need to have a specific organisation unit attached to them. The system will then ensure if each of the mentioned organisation units fall under the CAPTURE scope. If not the system will simply reject the write operation.


  * **Explain how they relate to ownership - Link to Program Ownership**

### Program Ownership

<!--DHIS2-SECTION-ID:webapi_nti_ownership-->

  * Describe the idea about Program Ownership
  * Temporary ownership
  * Program Ownership and Access Level - Link to Access Level

### Access Level

<!--DHIS2-SECTION-ID:webapi_nti_access_level-->

DHIS2 treats Tracker data with extra level of protection. In addition to the standard feature of metadata and data protection through sharing settings, Tracker data are shielded with various access level protection mechanisms. Currently there are 4 access levels: Open, Audited, Protected and Closed.

These access levels are triggered only when users try to interact with data outside their capture scope. If request to data is within the capture scope, DHIS2 applies standard metadata and data sharing protection. To access data outside capture scope, but within search scope, users need to pass through extra level of protection or what we call in DHIS2 concept of “breaking the glass”. The concept is, accessing outside data needs to be justified, has consequence and will be audited for others to see it.  The way to configure the level of consequence of breaking the glass is by setting Program’s access level to either Open, Audited, Protected or Closed.

1. Open: as the name implies, accessing data outside capture scope is possible without any justification or consequence. It is as if the data is within the capture scope. However, it is not possible to modify data captured by another org unit irrespective of the access level.
2.	Audited: this is the same as Open access level. The difference here is that the system will automatically put audit log entry on the data being accessed by the specific user.
3.	Protected: this takes audited access protection one level up. This time users need to provide a justification why they are accessing the data at hand. The system will then put a log of both the justification and access audit.
4. 	Closed: as the name implies, data recorded under programs configured with access level closed will not be accessed outside the capturing orgunit. Everything is closed for those outside the capture scope.
