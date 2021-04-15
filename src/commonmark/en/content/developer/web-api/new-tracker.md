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


Sharing setting is a standard DHIS2 functionality that applies to both Tracker and Aggregate metadata/data as well as dashboards and visualization items. At the core of sharing setting is the ability to define who can see/do what. In general there are 5 possible sharing configurations – no access, metadata read, metadata write, data read and data write. These access configurations can be granted at user and/or user group level (for more flexibility). With focus on Tracker, the following metadata and their sharing setting are of especial importance: Data Element, Category Option, Program, Program Stage, Tracked Entity Type, Tracked Entity Attribute as well as Tracker related Dashboards and Dashboard Items.

How sharing setting works is straightforward – the settings are enforced during Tracker data import/export processes. To read value, one needs to have data read access. If a user is expected to modify data, he/she needs to have data write access. Similarly if a user is expected to modify metadata, it is important to grant metadata write access.

One very important point with Tracker data is the need to have a holistic approach. For example a user won’t be able to see Data Element value by having read access to just the Data Element. The user needs to have data read access the parent Program Stage and Program where this Data Element belongs. It is the same with category option combination. In Tracker, Event is related to AttributeOptionCombo which is made up of combination of Category Options. Therefore, for a user to read data of an Event, he/she needs to have data read access to all Category Options, and corresponding Categories, that constitute the AttributeOptionCombo of the Event in question. If a user lacks access to just one Category Option or Category, then the user has no access to the entire Event.

When it comes accessing Enrollment data, it is important to have access to the Tracked Entity first. Access to a Tracked Entity is controlled through sharing setting of Program, Tracked Entity Type and Tracked Entity Attribute. Once Enrollment is accessed it is possible to access Event data, again depending on Program Stage and Data element sharing setting.

Another important point to consider is how to map out access to different Program Stages of a Program. Sometimes we could be in a situation where we need grant access to a specific stage – for example “Lab Result” – to specific group of users (Lab Technicians). In this situation, we can provide data write access to "Lab Result" stage, probably data read to one or more stages just in case we want Lab Technicians to read other medical results or no access if we think it not necessary for the Lab Technicians to see data other than lab related.

In summary, DHIS2 has fine grained sharing setting that we can use to implement access control mechanisms both at data and metadata level. These sharing settings can be applied directly at user level or user group level. How exactly to apply a sharing setting depends on the usecase at hand.

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

DHIS2 treats Tracker data with extra level of protection. In addition to the standard feature of metadata and data protection through sharing settings, Tracker data are shielded with various access level protection mechanisms. Currently there are 4 access levels: Open, Audited, Protected and Closed.

These access levels are triggered only when users try to interact with data outside their capture scope. If request to data is within the capture scope, DHIS2 applies standard metadata and data sharing protection. To access data outside capture scope, but within search scope, users need to pass through extra level of protection or what we call in DHIS2 concept of “breaking the glass”. The concept is, accessing outside data needs to be justified, has consequence and will be audited for others to see it.  The way to configure the level of consequence of breaking the glass is by setting Program’s access level to either Open, Audited, Protected or Closed.

1. Open: as the name implies, accessing data outside capture scope is possible without any justification or consequence. It is as if the data is within the capture scope. However, it is not possible to modify data captured by another org unit irrespective of the access level.
2.	Audited: this is the same as Open access level. The difference here is that the system will automatically put audit log entry on the data being accessed by the specific user.
3.	Protected: this takes audited access protection one level up. This time users need to provide a justification why they are accessing the data at hand. The system will then put a log of both the justification and access audit.
4. 	Closed: as the name implies, data recorded under programs configured with access level closed will not be accessed outside the capturing orgunit. Everything is closed for those outside the capture scope.