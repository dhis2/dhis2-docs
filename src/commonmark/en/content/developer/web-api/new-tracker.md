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
`Notes` are messages or comments attached to enrollment or event. They can only be created, not removed or changed.

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
