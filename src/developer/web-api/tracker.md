# Tracker

> **Caution**
>
> Tracker has been re-implemented in DHIS2 2.36. This document describes the new tracker endpoints
>
> * `POST /api/tracker`
> * `GET  /api/tracker/trackedEntities`
> * `GET  /api/tracker/enrollments`
> * `GET  /api/tracker/events`
> * `GET  /api/tracker/relationships`
>
> [Tracker
> (deprecated)](https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-master/tracker-deprecated.html)
> describes the deprecated endpoints
>
> * `GET/POST/PUT/DELETE /api/trackedEntityInstance`
> * `GET/POST/PUT/DELETE /api/enrollments`
> * `GET/POST/PUT/DELETE /api/events`
> * `GET/POST/PUT/DELETE /api/relationships`
>
> The deprecated endpoints will be removed in version **42**!
>
> [Migrating to new tracker
> endpoints](https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-master/tracker-deprecated.html#webapi_tracker_migration)
> should help you get started with your migration. Reach out on the [community of
> practice](https://community.dhis2.org) if you need further assistance.

## Tracker Objects { #webapi_nti_tracker_objects }

Tracker consists of a few different types of objects that are nested together to represent the data.
In this section, we will show and describe each of the objects used in the Tracker API.

### Tracked Entities

`Tracked Entities` are the root object for the Tracker model.

| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| trackedEntity | The identifier of the tracked entity. Generated if not supplied | No | Yes | String:Uid | ABCDEF12345 |
| trackedEntityType | The type of tracked entity. | Yes | Yes | String:Uid | ABCDEF12345 |
| createdAt | Timestamp when the user created the tracked entity. Set on the server. | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| createdAtClient | Timestamp when the user created the tracked entity on the client. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAt | Timestamp when the object was last updated. Set on the server. | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAtClient | Timestamp when the object was last updated on the client. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| orgUnit | The organisation unit where the user created the tracked entity. | Yes | Yes | String:Uid | ABCDEF12345 |
| inactive | Indicates whether the tracked entity is inactive or not. | No | Yes | Boolean | Default: false, true |
| deleted | Indicates whether the tracked entity has been deleted. It can only change when deleting. | No | No | Boolean | false until deleted |
| potentialDuplicate | Indicates whether the tracked entity is a potential duplicate. | No | No | Boolean | Default: false |
| geometry | A  geographical representation of the tracked entity. Based on the "featureType" of the TrackedEntityType. | No | Yes | GeoJson | {<br>"type": "POINT",<br>"coordinates": [123.0, 123.0]<br>} |
| storedBy | Client reference for who stored/created the tracked entity. | No | Yes | String:Any | John Doe |
| createdBy | Only for reading data. User that created the object. Set on the server | No | Yes | User | {<br>"uid": "ABCDEF12345",<br>"username": "username",<br>"firstName": "John",<br>"surname": "Doe"<br>} |
| updatedBy | Only for reading data. User that last updated the object. Set on the server | No | Yes | User | {<br>"uid": "ABCDEF12345",<br>"username": "username",<br>"firstName": "John",<br>"surname": "Doe"<br>} |
| attributes | A list of tracked entity attribute values owned by the tracked entity. | No | Yes | List of TrackedEntityAttributeValue | See Attribute |
| enrollments | A list of enrollments owned by the tracked entity. | No | Yes | List of Enrollment | See Enrollment |
| relationships | A list of relationships connected to the tracked entity. | No | Yes | List of Relationship | See Relationship |
| programOwners | A list of organisation units that have access through specific programs to this tracked entity. See "Program Ownership" for more. | No | Yes | List of ProgramOwner | See section "Program Ownership" |

> **Note**
>
> `Tracked Entities` "owns" all `Tracked Entity Attribute Values` (Or "attributes" as described in
> the previous table). However, `Tracked Entity Attributes` are either connected to a `Tracked
> Entity` through its `Tracked Entity Type` or a `Program`. We often refer to this separation as
> `Tracked Entity Type Attributes` and `Tracked Entity Program Attributes`. The importance of this
> separation is related to access control and limiting what information the user can see.
>
> The "attributes" referred to in the `Tracked Entity` are `Tracked Entity Type Attributes`.

### Enrollments

`Tracked Entities` can enroll into `Programs` for which they are eligible. Tracked entities are
eligible as long as the program is configured with the same `Tracked Entity Type` as the tracked
entity. We represent the enrollment with the `Enrollment` object, which we describe in this section.

| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| enrollment | The identifier of the enrollment. Generated if not supplied | No | Yes | String:Uid | ABCDEF12345 |
| program | The program the enrollment represents. | Yes | No | String:Uid | ABCDEF12345 |
| trackedEntity | A reference to the tracked entity enrolled. | Yes | Yes | String:Uid | ABCDEF12345 |
| status | Status of the enrollment. ACTIVE if not supplied. | No | No | Enum | ACTIVE, COMPLETED, CANCELLED |
| orgUnit | The organisation unit where the user enrolled the tracked entity. | Yes | No | String:Uid | ABCDEF12345 |
| createdAt | Timestamp when the user created the object. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| createdAtClient | Timestamp when the user created the object on client | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAt | Timestamp when the object was last updated. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAtClient | Timestamp when the object was last updated on client | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| enrolledAt | Timestamp when the user enrolled the tracked entity. | Yes | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| occurredAt | Timestamp when enrollment occurred. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| completedAt | Timestamp when the user completed the enrollment. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| completedBy | Reference to who completed the enrollment | No | No | String:any | John Doe |
| followUp | Indicates whether the enrollment requires follow-up. False if not supplied | No | No | Booelan | Default: False, True |
| deleted | Indicates whether the enrollment has been deleted. It can only change when deleting. | No | Yes | Boolean | False until deleted |
| geometry | A  geographical representation of the enrollment. Based on the "featureType" of the Program | No | No | GeoJson | {<br>"type": "POINT",<br>"coordinates": [123.0, 123.0]<br>} |
| storedBy | Client reference for who stored/created the enrollment. | No | No | String:Any | John Doe |
| createdBy | Only for reading data. User that created the object. Set on the server | No | Yes | User | {<br>"uid": "ABCDEF12345",<br>"username": "username",<br>"firstName": "John",<br>"surname": "Doe"<br>} |
| updatedBy | Only for reading data. User that last updated the object. Set on the server | No | Yes | User | {<br>"uid": "ABCDEF12345",<br>"username": "username",<br>"firstName": "John",<br>"surname": "Doe"<br>} |
| attributes | A list of tracked entity attribute values connected to the enrollment. | No | No | List of TrackedEntityAttributeValue | See Attribute |
| events | A list of events owned by the enrollment. | No | No | List of Event | See Event |
| relationships | A list of relationships connected to the enrollment. | No | No | List of Relationship | See Relationship |
| notes | Notes connected to the enrollment. It can only be created. | No | Yes | List of Note | See Note |

> **Note**
>
> `Tracked Entities` "owns" all `Tracked Entity Attribute Values` (Or "attributes" as described in
> the previous table). However, `Tracked Entity Attributes` are either connected to a `Tracked
> Entity` through its `Tracked Entity Type` or a `Program`. We often refer to this separation as
> `Tracked Entity Type Attributes` and `Tracked Entity Program Attributes`. The importance of this
> separation is related to access control and limiting what information the user can see.
>
> The "attributes" referred to in the `Enrollment` are `Tracked Entity Program Attributes`.

### Events

`Events` are either part of an `EVENT PROGRAM` or `TRACKER PROGRAM`. For `TRACKER PROGRAM`, events
belong to an `Enrollment`, which again belongs to a `Tracked Entity`. On the other hand, `EVENT
PROGRAM` is `Events` not connected to a specific `Enrollment` or `Tracked Entity`. The difference is
related to whether we track a specific `Tracked Entity` or not. We sometimes refer to `EVENT
PROGRAM` events as "anonymous events" or "single events" since they only represent themselves and
not another `Tracked Entity`.

In the API, the significant difference is that all events are either connected to the same
enrollment (`EVENT PROGRAM`) or different enrollments (`TRACKER PROGRAM`). The table below will
point out any exceptional cases between these two.

| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| event | The identifier of the event. Generated if not supplied | No | Yes | String:Uid | ABCDEF12345 |
| programStage | The program stage the event represents. | Yes | No | String:Uid | ABCDEF12345 |
| enrollment | A reference to the enrollment which owns the event. ***Not applicable for `EVENT PROGRAM`*** | Yes | Yes | String:Uid | ABCDEF12345 |
| program | Only for reading data. The type of program the enrollment which owns the event has. | No | Yes | String:Uid | ABCDEF12345 |
| trackedEntity | Only for reading data. The tracked entity which owns the event. ***Not applicable for `EVENT PROGRAM`*** | No | No | String:Uid | ABCDEF12345 |
| status | Status of the event. ACTIVE if not supplied. | No | No | Enum | ACTIVE, COMPLETED, VISITED, SCHEDULE, OVERDUE, SKIPPED |
| enrollmentStatus | Only for reading data. The status of the enrollment which owns the event. ***Not applicable for `EVENT PROGRAM`*** | No | No | Enum | ACTIVE, COMPLETED, CANCELLED |
| orgUnit | The organisation unit where the user registered the event. | Yes | No | String:Uid | ABCDEF12345 |
| createdAt | Only for reading data. Timestamp when the user created the event. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| createdAtClient | Timestamp when the user created the event on client | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAt | Only for reading data. Timestamp when the event was last updated. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAtClient | Timestamp when the event was last updated on client | No | No | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| scheduledAt | Timestamp when the event was scheduled for. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| occurredAt | Timestamp when something occurred. | Yes | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| completedAt | Timestamp when the user completed the event. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| completedBy | Reference to who completed the event | No | No | String:Any | John Doe |
| followUp | Only for reading data. Indicates whether the event has been flagged for follow-up. | No | No | Boolean | False, True |
| deleted | Only for reading data. Indicates whether the event has been deleted. It can only change when deleting. | No | Yes | Boolean | False until deleted |
| geometry | A  geographical representation of the event. Based on the "featureType" of the Program Stage | No | No | GeoJson | {<br>"type": "POINT",<br>"coordinates": [123.0, 123.0]<br>} |
| storedBy | Client reference for who stored/created the event. | No | No | String:Any | John Doe |
| createdBy | Only for reading data. User that created the object. Set on the server | No | Yes | User | {<br>"uid": "ABCDEF12345",<br>"username": "username",<br>"firstName": "John",<br>"surname": "Doe"<br>} |
| updatedBy | Only for reading data. User that last updated the object. Set on the server | No | Yes | User | {<br>"uid": "ABCDEF12345",<br>"username": "username",<br>"firstName": "John",<br>"surname": "Doe"<br>} |
| attributeOptionCombo | Attribute option combo for the event. Default if not supplied or configured. | No | No | String:Uid | ABCDEF12345
| attributeCategoryOptions | Attribute category option for the event. Default if not supplied or configured. | No | No | String:Uid | ABCDEF12345
| assignedUser | A reference to a user who has been assigned to the event. | No | No | User | {<br>"uid": "ABCDEF12345",<br>"username": "username",<br>"firstName": "John",<br>"surname": "Doe"<br>} |
| dataValues | A list of data values connected to the event. | No | No | List of TrackedEntityAttributeValue | See Attribute |
| relationships | A list of relationships connected to the event. | No | No | List of Relationship | See Relationship |
| notes | Notes connected to the event. It can only be created. | No | Yes | List of Note | See Note |

### Relationships

`Relationships` are objects that link together two other tracker objects. The constraints each side
of the relationship must conform to are based on the `Relationship Type` of the `Relationship`.


| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| relationship | The identifier of the relationship. Generated if not supplied. | No | Yes | String:Uid | ABCDEF12345 |
| relationshipType | The type of the relationship. Decides what objects can be linked in a relationship. | Yes | Yes | String:Uid | ABCDEF12345 |
| relationshipName | Only for reading data. The name of the relationship type of this relationship | No | No | String:Any | Sibling |
| createdAt | Timestamp when the user created the relationship. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| updatedAt | Timestamp when the relationship was last updated. Set on the server. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| createdAtClient | Timestamp when the user created the relationship on the client. | No | Yes | Date:ISO 8601 | YYYY-MM-DDThh:mm:ss |
| bidirectional | Only for reading data. Indicated whether the relationship type is bidirectional or not. | No | No | Boolean | True or False |
| from, to | A reference to each side of the relationship. Must conform to the constraints set in the relationship type | Yes | Yes | RelationshipItem | {"trackedEntity": {"trackedEntity": "ABCEF12345"}}, {"enrollment": {"enrollment": "ABCDEF12345"}} or {"event": {"event": "ABCDEF12345" }} |

> **Note**
>
> `Relationship item` represents a link to an object. Since a `relationship` can be between any
> tracker object like `tracked entity`, `enrollment`, and `event`, the value depends on the
> `relationship type`. For example, if a `relationship type` connects from an `event` to a `tracked
> entity`, the format is strict:

> ```json
> {
>   "from": {
>     "event": { "event": "ABCDEF12345" }
>   },
>   "to": {
>     "trackedEntity": { "trackedEntity": "FEDCBA12345" }
>   }
> }
> ```

### Attributes

`Attributes` are the actual values describing the `tracked entities`. They can either be connected
through a `tracked entity type` or a `program`. Implicitly this means `attributes` can be part of
both a `tracked entity` and an `enrollment`.

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

> **Note**
>
> For `attributes` only the "attribute" and "value" properties are required when adding data.
> "value" can be null, which implies the user should remove the value.
>
> In the context of tracker objects, we refer to `Tracked Entity Attributes` and `Tracked Entity
> Attribute Values` as "attributes". However, attributes are also their own thing, related to
> metadata. Therefore, it's vital to separate Tracker attributes and metadata attributes. In the
> tracker API, it is possible to reference the metadata attributes when specifying `idScheme` (See
> request parameters for more information).

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
| createdBy | Only for reading data. User that created the object. Set on the server | No | Yes | User | {<br>"uid": "ABCDEF12345",<br>"username": "username",<br>"firstName": "John",<br>"surname": "Doe"<br>} |
| updatedBy | Only for reading data. User that last updated the object. Set on the server | No | Yes | User | {<br>"uid": "ABCDEF12345",<br>"username": "username",<br>"firstName": "John",<br>"surname": "Doe"<br>} |

> **Note**
>
> For `data elements` only the "dataElement" and "value" properties are required when adding data.
> "value" can be null, which implies the user should remove the value.

### Notes

DHIS2 tracker allows for capturing of data using data elements and tracked entity attributes.
However, sometimes there could be a situation where it is necessary to record additional information
or comment about the issue at hand. Such additional information can be captured using notes.
Notes are equivalent to data value comments from the Aggregate DHIS2 side.

There are two types of notes - notes recorded at the event level and those recorded at the
enrollment level. An enrollment can have one or more events. Comments about each of the events - for
example, why an event was missed, rescheduled, or why only a few data elements were filled and the
like - can be documented using event notes. Each of the events within an enrollment can have its own
story/notes. One can then record, for example, an overall observation of these events using the
parent enrollment note. Enrollment notes are also helpful to document, for example, why an
enrollment is canceled. It is the user's imagination and use-case when and how to use notes.

Both enrollment and event can have as many notes as needed - there is no limit. However, it is not
possible to delete or update neither of these notes. They are like a logbook. If one wants to amend
a note, one can do so by creating another note. The only way to delete a note is by deleting the
parent object - either event or enrollment.

Notes do not have their dedicated endpoint; they are exchanged as part of the parent event
and/or enrollment payload. Below is a sample payload.

```json
{
  "trackedEntity": "oi3PMIGYJH8",
  "enrollments": [
    {
      "enrollment": "EbRsJr8LSSO",
      "notes": [
        {
          "note": "vxmCvYcPdaW",
          "value": "Enrollment note 2."
        },
        {
          "value": "Enrollment note 1"
        }
      ],
      "events": [
        {
          "event": "zfzS9WeO0uM",
          "notes": [
            {
              "note": "MAQFb7fAggS",
              "value": "Event Note 1."
            },
            {
              "value": "Event Note 2."
            }
          ]
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
| storedBy | Client reference for who stored/created the note. | No | No | String:Any | John Doe |
| createdBy | Only for reading data. User that created the object. Set on the server | No | Yes | User | {<br>"uid": "ABCDEF12345",<br>"username": "username",<br>"firstName": "John",<br>"surname": "Doe"<br>} |

### Users

| Property | Description | Required | Immutable | Type | Example |
|---|---|---|---|---|---|
| uid | The identifier of the user. | Yes* | Yes | String:Uid | ABCDEF12345 |
| username | Username used by the user. | Yes* | Yes | String:Any | 123 |
| firstName | Only for reading data. First name of the user. | No | Yes | String:Any | John |
| surname | Only for reading data. Last name of the user. | No | Yes | String:Any | Doe |

> One between `uid` or `username` field must be provided. If both are provided, only username is
> considered.

### Program stage working lists { #webapi_working_list_filters }

The program stage working lists feature within the Capture app is designed to display
pre-established working lists relevant to a particular program stage. This functionality enables
users to save filters and sorting preferences that are related to program stages, facilitating the
organisation and management of their workflow. To interact with them, you'll need to use the
*/api/programStageWorkingLists* resource. These lists can be shared and follow the same sharing
pattern as any other metadata. When using the */api/sharing* the type parameter will be
*programStageWorkingLists*.

    /api/40/programStageWorkingLists

##### Payload on CRUD operations to program stage working lists

The endpoint above can be used to get all program stage working lists. To get a single one, just add
at the end the id of the one you are interested in. This is the same in case you want to delete it.
On the other hand, if you are looking to create or update a program stage working list, besides the
endpoint mentioned above, you'll need to provide a payload in the following format:

Table: Payload

| Payload values | Description | Example |
|---|---|---|
| name | Name of the working list. Required. ||
| description | A description of the working list. ||
| program | Object containing the id of the program. Required. | {"id" : "uy2gU8kTjF"} |
| programStage | Object containing the id of the program stage. Required. | {"id" : "oRySG82BKE6"} |
| programStageQueryCriteria | An object representing various possible filtering values. See *Program Stage Query Criteria* definition table below.

Table: Program Stage Query Criteria

| Criteria values | Description | Example |
|---|---|---|
| status | The event status. Possible values are ACTIVE, COMPLETED, VISITED, SCHEDULE, OVERDUE, SKIPPED and VISITED | "status":"VISITED" |
| eventCreatedAt | DateFilterPeriod object filtering based on the event creation date. | {"type":"ABSOLUTE","startDate":"2020-03-01","endDate":"2022-12-30"} |
| scheduledAt | DateFilterPeriod object filtering based on the event scheduled date. | {"type":"RELATIVE","period":"TODAY"} |
| enrollmentStatus | Any valid ProgramStatus. Possible values are ACTIVE, COMPLETED and CANCELLED. | "enrollmentStatus": "COMPLETED" |
| followUp | Indicates whether to filter enrollments marked for follow up or not | "followUp":true |
| enrolledAt | DateFilterPeriod object filtering based on the event enrollment date. | "enrolledAt": {"type":"RELATIVE","period":"THIS_MONTH"} |
| enrollmentOccurredAt | DateFilterPeriod object filtering based on the event occurred date. | {"type":"RELATIVE","period":"THIS_MONTH"} |
| orgUnit | A valid organisation unit UID | "orgUnit": "Rp268JB6Ne4" |
| ouMode | A valid OU selection mode | "ouMode": "SELECTED" |
| assignedUserMode | A valid user selection mode for events. Possible values are CURRENT, PROVIDED, NONE, ANY and ALL. If PROVIDED (or null), non-empty assignedUsers in the payload will be expected. | "assignedUserMode":"PROVIDED" |
| assignedUsers | A list of assigned users for events. To be used along with PROVIDED assignedUserMode above. | "assignedUsers":["DXyJmlo9rge"] |
| order | List of fields and its directions in comma separated values, the results will be sorted according to it. A single item in order is of the form "orderDimension:direction". | "order": "w75KJ2mc4zz:asc" |
| displayColumnOrder | Output ordering of columns | "displayColumnOrder":["w75KJ2mc4zz","zDhUuAYrxNC"] |
| dataFilters | A list of items that contains the filters to be used when querying events | "dataFilters":[{"dataItem": "GXNUsigphqK","ge": "10","le": "20"}] |
| attributeValueFilters | A list of attribute value filters. This is used to specify filters for attribute values when listing tracked entities | "attributeValueFilters":[{"attribute": "ruQQnf6rswq","eq": "15"}] |

See an example payload below:

```json
{
    "name":"Test WL",
    "program":{"id":"uy2gU8kT1jF"},
    "programStage":{"id":"oRySG82BKE6"},
    "description": "Test WL definition",
    "programStageQueryCriteria":
        {
            "status":"VISITED",
            "eventCreatedAt":{"type":"ABSOLUTE","startDate":"2020-03-01","endDate":"2022-12-30"},
            "scheduledAt": {"type":"RELATIVE","period":"TODAY"},
            "enrollmentStatus": "COMPLETED",
            "followUp" : true,
            "enrolledAt": {"type":"RELATIVE","period":"THIS_MONTH"},
            "enrollmentOccurredAt": {"type":"RELATIVE","period":"THIS_MONTH"},
            "orgUnit": "Rp268JB6Ne4",
            "ouMode": "SELECTED",
            "assignedUserMode":"PROVIDED",
            "assignedUsers":["DXyJmlo9rge"],
            "order": "w75KJ2mc4zz:asc",
            "displayColumnOrder":["w75KJ2mc4zz","zDhUuAYrxNC"],
            "dataFilters":[{
                "dataItem": "GXNUsigphqK",
                "ge": "10",
                "le": "20"
            }],
            "attributeValueFilters":[{
                "attribute": "ruQQnf6rswq",
                "eq": "15"
            }]
        }
}
```

## Tracker Import (`POST /api/tracker`) { #webapi_nti_import }

The `POST /api/tracker` endpoint allows clients to import the following tracker objects

* **Tracked entities**
* **Enrollments**
* **Events**
* **Relationships**
* Data embedded in other [tracker objects](#webapi_nti_tracker_objects)

### Request parameters

Currently, the tracker import endpoint supports the following parameters:

| Parameter name | Description | Type | Allowed values |
|---|---|---|---|
| async | Indicates whether the import should happen asynchronously or synchronously. | Boolean | `TRUE`, `FALSE` |
| reportMode | Only when performing synchronous import. See importSummary for more info. | Enum | `FULL`, `ERRORS`, `WARNINGS` |
| importMode | Can either be `VALIDATE` which will report errors in the payload without making changes to the database or `COMMIT` (default) which will validate the payload and make changes to the database. | Enum | `VALIDATE`, `COMMIT` |
| idScheme | Indicates the overall idScheme to use for metadata references when importing. Default is UID. Can be overridden for specific metadata (Listed below) | Enum | `UID`, `CODE`, `NAME`, `ATTRIBUTE` |
| dataElementIdScheme | Indicates the idScheme to use for data elements when importing. | Enum | `UID`, `CODE`, `NAME`, `ATTRIBUTE` |
| orgUnitIdScheme | Indicates the idScheme to use for organisation units when importing. | Enum | `UID`, `CODE`, `NAME`, `ATTRIBUTE` |
| programIdScheme | Indicates the idScheme to use for programs when importing. | Enum | `UID`, `CODE`, `NAME`, `ATTRIBUTE` |
| programStageIdScheme | Indicates the idScheme to use for program stages when importing. | Enum | `UID`, `CODE`, `NAME`, `ATTRIBUTE` |
| categoryOptionComboIdScheme | Indicates the idScheme to use for category option combos when importing. | Enum | `UID`, `CODE`, `NAME`, `ATTRIBUTE` |
| categoryOptionIdScheme | Indicates the idScheme to use for category options when importing. | Enum | `UID`, `CODE`, `NAME`, `ATTRIBUTE` |
| importStrategy | Indicates the effect the import should have. Can either be `CREATE`, `UPDATE`, `CREATE_AND_UPDATE` and `DELETE`, which respectively only allows importing new data, importing changes to existing data, importing any new or updates to existing data, and finally deleting data. | Enum | `CREATE`, `UPDATE`, `CREATE_AND_UPDATE`, `DELETE` |
| atomicMode | Indicates how the import responds to validation errors. If `ALL`, all data imported must be valid for any data to be committed. For `OBJECT`, only the data committed needs to be valid, while other data can be invalid. | Enum | `ALL`, `OBJECT` |
| flushMode | Indicates the frequency of flushing. This is related to how often data is pushed into the database during the import. Primarily used for debugging reasons, and should not be changed in a production setting | Enum | `AUTO`, `OBJECT` |
| validationMode | Indicates the completeness of the validation step. It can be skipped, set to fail fast (Return on the first error), or full(Default), which will return any errors found | Enum | `FULL`, `FAIL_FAST`, `SKIP` |
| skipPatternValidation | If true, it will skip validating the pattern of generated attributes. | Boolean | `TRUE`, `FALSE` |
| skipSideEffects | If true, it will skip running any side effects for the import | Boolean | `TRUE`, `FALSE` |
| skipRuleEngine | If true, it will skip running any program rules for the import | Boolean | `TRUE`, `FALSE` |

**NOTE**: idScheme and its metadata specific idScheme parameters like
orgUnitIdScheme, programIdScheme, ... used to allow and use the default `AUTO`.
`AUTO` has been removed. The default idScheme has already been `UID`. Any
requests sent with idScheme `AUTO` will see the same behavior as before, namely
matching done using `UID`.

### Flat and nested payloads

The importer support both flat and nested payloads.

**Flat**
:   The flat payload can contain collections for each of the core tracker objects we have at the
:   top level. This works seamlessly with existing data, which already have UIDs assigned. However,
:   for new data, the client will have to provide new UIDs for any references between objects. For
:   example, if you import a new tracked entity with a new enrollment, the tracked entity requires
:   the client to provide a UID so that the enrollment can be linked to that UID.

**Nested**
:   Nested payloads are the most commonly used structure. Here, tracker objects are embedded within
:   their parent object. For example, an enrollment within a tracked entity. The advantage of this
:   structure is that the client does not need to provide UIDs for these references as this is done
:   automatically.

> **NOTE**
>
> While nested payloads might prove simpler for clients to deal with, the payload will always be
> flattened before the import. This means that for large imports, providing a flat structured
> payload will provide both more control and lower overhead for the import process itself.

Examples for the **FLAT** and the **NESTED** versions of the payload are listed below.

#### ***FLAT*** payload

```json
{
  "trackedEntities": [
    {
      "orgUnit": "y77LiPqLMoq",
      "trackedEntity": "Kj6vYde4LHh",
      "trackedEntityType": "nEenWmSyUEp"
    },
    {
      "orgUnit": "y77LiPqLMoq",
      "trackedEntity": "Gjaiu3ea38E",
      "trackedEntityType": "nEenWmSyUEp"
    }
  ],
  "enrollments": [
    {
      "enrolledAt": "2019-08-19T00:00:00.000",
      "enrollment": "MNWZ6hnuhSw",
      "occurredAt": "2019-08-19T00:00:00.000",
      "orgUnit": "y77LiPqLMoq",
      "program": "IpHINAT79UW",
      "status": "ACTIVE",
      "trackedEntity": "Kj6vYde4LHh",
      "trackedEntityType": "nEenWmSyUEp"
    }
  ],
  "events": [
    {
      "attributeCategoryOptions": "xYerKDKCefk",
      "attributeOptionCombo": "HllvX50cXC0",
      "dataValues": [
        {
          "dataElement": "bx6fsa0t90x",
          "value": "true"
        },
        {
          "dataElement": "UXz7xuGCEhU",
          "value": "5.7"
        }
      ],
      "enrollment": "MNWZ6hnuhSw",
      "enrollmentStatus": "ACTIVE",
      "event": "ZwwuwNp6gVd",
      "occurredAt": "2019-08-01T00:00:00.000",
      "orgUnit": "y77LiPqLMoq",
      "program": "IpHINAT79UW",
      "programStage": "A03MvHHogjR",
      "scheduledAt": "2019-08-19T13:59:13.688",
      "status": "ACTIVE",
      "trackedEntity": "Kj6vYde4LHh"
    },
    {
      "attributeCategoryOptions": "xYerKDKCefk",
      "attributeOptionCombo": "HllvX50cXC0",
      "enrollment": "MNWZ6hnuhSw",
      "enrollmentStatus": "ACTIVE",
      "event": "XwwuwNp6gVE",
      "occurredAt": "2019-08-01T00:00:00.000",
      "orgUnit": "y77LiPqLMoq",
      "program": "IpHINAT79UW",
      "programStage": "ZzYYXq4fJie",
      "scheduledAt": "2019-08-19T13:59:13.688",
      "status": "ACTIVE",
      "trackedEntity": "Kj6vYde4LHh"
    }
  ],
  "relationships": [
    {
      "from": {
        "trackedEntity": {
          "trackedEntity": "Kj6vYde4LHh"
        }
      },
      "relationshipType": "dDrh5UyCyvQ",
      "to": {
        "trackedEntity": {
          "trackedEntity": "Gjaiu3ea38E"
        }
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
      "enrollments": [
        {
          "attributes": [
            {
              "attribute": "zDhUuAYrxNC",
              "displayName": "Last name",
              "value": "Kelly"
            },
            {
              "attribute": "w75KJ2mc4zz",
              "displayName": "First name",
              "value": "John"
            }
          ],
          "enrolledAt": "2019-08-19T00:00:00.000",
          "events": [
            {
              "attributeCategoryOptions": "xYerKDKCefk",
              "attributeOptionCombo": "HllvX50cXC0",
              "dataValues": [
                {
                  "dataElement": "bx6fsa0t90x",
                  "value": "true"
                },
                {
                  "dataElement": "UXz7xuGCEhU",
                  "value": "5.7"
                }
              ],
              "enrollmentStatus": "ACTIVE",
              "notes": [
                {
                  "value": "need to follow up"
                }
              ],
              "occurredAt": "2019-08-01T00:00:00.000",
              "orgUnit": "y77LiPqLMoq",
              "program": "IpHINAT79UW",
              "programStage": "A03MvHHogjR",
              "scheduledAt": "2019-08-19T13:59:13.688",
              "status": "ACTIVE"
            }
          ],
          "occurredAt": "2019-08-19T00:00:00.000",
          "orgUnit": "y77LiPqLMoq",
          "program": "IpHINAT79UW",
          "status": "ACTIVE",
          "trackedEntityType": "nEenWmSyUEp"
        }
      ],
      "orgUnit": "y77LiPqLMoq",
      "trackedEntityType": "nEenWmSyUEp"
    }
  ]
}
```

### SYNC and ASYNC

For the user, the main difference between importing synchronously rather than asynchronously is the
immediate response from the API. For the synchronous import, the response will be returned as soon
as the import finishes with the importSummary. However, for asynchronous imports, the response will
be immediate and contain a reference where the client can poll for updates to the import.

For significant imports, it might be beneficial for the client to use the asynchronous import to
avoid waiting too long for a response.

Examples of the **ASYNC** response is shown below. For **SYNC** response, look at the [importSummary
section](#webapi_nti_import_summary).

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "message": "Tracker job added",
  "response": {
    "id": "cHh2OCTJvRw",
    "location": "https://play.im.dhis2.org/dev/api/tracker/jobs/cHh2OCTJvRw"
  }
}
```

### CSV import

To import events using CSV make a `POST` request with CSV body file and the `Content-Type` set to
***application/csv*** or ***text/csv***.

#### Events

Every row of the CSV payload represents an event and a data value. So, for events with multiple
data values, the CSV file will have `x` rows per event, where `x` is the number of data values
in that event.

##### ***CSV PAYLOAD*** example

Your CSV file can look like:

```csv
event,status,program,programStage,enrollment,orgUnit,occurredAt,scheduledAt,geometry,latitude,longitude,followUp,deleted,createdAt,createdAtClient,updatedAt,updatedAtClient,completedBy,completedAt,updatedBy,attributeOptionCombo,attributeCategoryOptions,assignedUser,dataElement,value,storedBy,providedElsewhere,storedByDataValue,updatedAtDataValue,createdAtDataValue
A7rzcnZTe2T,ACTIVE,eBAyeGv0exc,Zj7UnCAulEk,RiLEKhWHlxZ,DwpbWkiqjMy,2023-02-12T23:00:00Z,2023-02-12T23:00:00Z,"POINT (-11.468912037323042 7.515913998868316)",7.515913998868316,-11.468912037323042,false,false,2017-09-08T19:40:22Z,,2017-09-08T19:40:22Z,,,,,HllvX50cXC0,xYerKDKCefk,,F3ogKBuviRA,"[-11.4880220438585,7.50978830548003]",admin,false,,2016-12-06T17:22:34.438Z,2016-12-06T17:22:34.438Z
```

See [Events CSV](#events-csv) in the export section for a more detailed definition of the CSV fields.

### Import Summary { #webapi_nti_import_summary }

The Tracker API has two primary endpoints for consumers to acquire feedback from their imports.
These endpoints are most relevant for async import jobs but are available for sync jobs as well.
These endpoints will return either the log related to the import or the import summary itself.

> **Note**
>
> These endpoints rely on information stored in the application memory. This means the information
> will be unavailable after certain cases, as an application restart or after a large number of
> import requests have started after this one.

After submitting a tracker import request, we can access the following endpoints in order to monitor
the job progress based on logs:

`GET /tracker/jobs/{uid}`

| Parameter|Description|Example
|---|---|---|
|`{uid}`| The UID of an existing tracker import job | ABCDEF12345

#### ***REQUEST*** example

`GET /tracker/jobs/PQK63sMwjQp`

#### ***RESPONSE*** example

```json
[
  {
    "uid": "PQK63sMwjQp",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:16.370",
    "message": "Import complete with status OK, 0 created, 0 updated, 0 deleted, 0 ignored",
    "completed": true,
    "id": "PQK63sMwjQp"
  },
  {
    "uid": "XIfTJ1UUNcd",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:16.369",
    "message": "PostCommit",
    "completed": false,
    "id": "XIfTJ1UUNcd"
  },
  {
    "uid": "uCG4FNJLLBJ",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:16.364",
    "message": "Commit Transaction",
    "completed": false,
    "id": "uCG4FNJLLBJ"
  },
  {
    "uid": "xfOUv2Lk2MC",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:16.361",
    "message": "Running Rule Engine Validation",
    "completed": false,
    "id": "xfOUv2Lk2MC"
  },
  {
    "uid": "cSPfA776obb",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:16.325",
    "message": "Running Rule Engine",
    "completed": false,
    "id": "cSPfA776obb"
  },
  {
    "uid": "mru3HJrFGKA",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:16.313",
    "message": "Running Validation",
    "completed": false,
    "id": "mru3HJrFGKA"
  },
  {
    "uid": "oTbCUJ2RnA6",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:16.312",
    "message": "Running PreProcess",
    "completed": false,
    "id": "oTbCUJ2RnA6"
  },
  {
    "uid": "lcUNbWTn6uh",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:16.312",
    "message": "Calculating Payload Size",
    "completed": false,
    "id": "lcUNbWTn6uh"
  },
  {
    "uid": "l4jQiSS9qdK",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:15.903",
    "message": "Running PreHeat",
    "completed": false,
    "id": "l4jQiSS9qdK"
  },
  {
    "uid": "qGbiuqgwPX5",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:15.850",
    "message": "Loading file content",
    "completed": false,
    "id": "qGbiuqgwPX5"
  },
  {
    "uid": "eWNHzVf7iAj",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:15.838",
    "message": "Loading file resource",
    "completed": false,
    "id": "eWNHzVf7iAj"
  },
  {
    "uid": "t9gOjotekQt",
    "level": "INFO",
    "category": "TRACKER_IMPORT_JOB",
    "time": "2024-03-19T13:18:15.837",
    "message": "Tracker import started",
    "completed": false,
    "dataType": "PARAMETERS",
    "data": {
      "userId": "xE7jOejl9FI",
      "importMode": "VALIDATE",
      "idSchemes": {
        "dataElementIdScheme": {
          "idScheme": "UID",
          "attributeUid": null
        },
        "orgUnitIdScheme": {
          "idScheme": "UID",
          "attributeUid": null
        },
        "programIdScheme": {
          "idScheme": "UID",
          "attributeUid": null
        },
        "programStageIdScheme": {
          "idScheme": "UID",
          "attributeUid": null
        },
        "idScheme": {
          "idScheme": "UID",
          "attributeUid": null
        },
        "categoryOptionComboIdScheme": {
          "idScheme": "UID",
          "attributeUid": null
        },
        "categoryOptionIdScheme": {
          "idScheme": "UID",
          "attributeUid": null
        }
      },
      "importStrategy": "CREATE_AND_UPDATE",
      "atomicMode": "ALL",
      "flushMode": "AUTO",
      "validationMode": "FULL",
      "skipPatternValidation": false,
      "skipSideEffects": false,
      "skipRuleEngine": false,
      "filename": null,
      "reportMode": "ERRORS"
    },
    "id": "t9gOjotekQt"
  }
]
```

Additionally, the following endpoint will return the import summary of the import job. This import
summary will only be available after the import has completed:

`GET /tracker/jobs/{uid}/report`

| Parameter|Description|Example
|---|---|---|
|path `/{uid}`|The UID of an existing tracker import job.|ABCDEF12345|
|`reportMode`|The level of detail the report should have.|`FULL`&#124;`ERRORS`&#124;`WARNINGS`|

#### ***REQUEST*** example

`GET /tracker/jobs/mEfEaFSCKCC/report`

#### ***RESPONSE*** example

The response payload is the same as the one returned after a sync import request.

> **Note**
>
> Both endpoints are used primarily for async import; however, `GET /tracker/jobs/{uid}` would also
> work for sync requests as it eventually uses the same import process and logging as async
> requests.

### Import Summary Structure

Import summaries have the following overall structure, depending on the requested `reportMode`:

```json
{
  "status": "OK",
  "validationReport": {
    "errorReports": [],
    "warningReports": []
  },
  "stats": {
    "created": 3,
    "updated": 0,
    "deleted": 0,
    "ignored": 0,
    "total": 3
  },
  "bundleReport": {
    "typeReportMap": {
      "EVENT": {
        "trackerType": "EVENT",
        "stats": {
          "created": 1,
          "updated": 0,
          "deleted": 0,
          "ignored": 0,
          "total": 1
        },
        "objectReports": [
          {
            "trackerType": "EVENT",
            "uid": "gTZBPT3Jq39",
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
            "uid": "ffcvJvWjiNZ",
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
            "uid": "aVcGf9iO8Xp",
            "errorReports": []
          }
        ]
      }
    }
  }
}
```

***status***

The property, `status`, of the import summary indicates the overall status of the import. If no
errors or warnings were raised during the import, the `status` is reported as `OK`. The presence of
any error or warnings in the import will result in a status of type `ERROR` or `WARNING`.

`status` is based on the presence of the most significant `validationReport`. `ERROR` has the
highest significance, followed by `WARNING` and finally `OK`. This implies that `ERROR` is reported
as long as a single error was found during the import, regardless of how many warnings occurred.

> **Note**
>
> If the import is performed using the AtomicMode "OBJECT", where the import will import any data
> without validation errors, the overall status will still be `ERROR` if any errors were found.

***validationReport***

The `validationReport` might include `errorReports` and `warningReports` if any errors or warnings
were present during the import. When present, they provide a detailed list of any errors or warnings
encountered.

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

The report contains a message and a code describing the actual error (See the [error
codes](#error-codes) section for more information about errors). Additionally, the report includes
the `trackerType` and `uid`, which aims to describe where in the data the error was found. In this
case, there was a `TRACKED_ENTITY` with the uid `Kj6vYde4LHh`, which had a reference to a tracked
entity type that was not found.

> **Note**
>
> When referring to the `uid` of tracker objects, they are labeled as their object names in the
> payload. For example, the `uid` of a tracked entity would in the payload have the name
> "trackedEntity". The same goes for "enrollment", "event" and "relationship" for enrollments,
> events, and relationships, respectively.
>
> If no uid is provided in the payload, the import process will generate new uids. This means the
> error report might refer to a uid that does not exist in your payload.
>
> Errors represent issues with the payload which the importer can not circumvent. Any errors will
> block that data from being imported. Warnings, on the other hand, are issues where it's safe to
> circumvent them, but the user should be made aware that it happened. Warnings will not block data
> from being imported.

***stats***

The stats provide a quick overview of the import. After an import is completed, these will be the
actual counts representing how much data was created, updated, deleted, or ignored.

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

`created` refers to how many new objects were created. In general, objects without an existing uid
in the payload will be treated as new objects.

`updated` refers to the number of objects updated. If an object has a uid set in the payload, it
will be treated as an update as long as that same uid exists in the database.

`deleted` refers to the number of objects deleted during the import. Deletion only happens when the
import is configured to delete data and only then when the objects in the payload have existing uids
set.

`ignored` refers to objects that were not persisted. Objects can be ignored for several reasons, for
example trying to create something that already exists. Ignores should always be safe, so if
something was ignored, it was not necessary, or it was due to the configuration of the import.

***bundleReport***

When the import is completed, the `bundleReport` contains all the [tracker
objects](#tracker-objects) imported.

For example, `TRACKED_ENTITY`:

```json
{
  "bundleReport": {
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
            "uid": "aVcGf9iO8Xp",
            "errorReports": []
          }
        ]
      }
    }
  }
}
```

As seen, each type of tracker object will be reported, and each has its own stats and
`objectReports`. These `objectReports` will provide details about each imported object, like their
type, their uid, and any error or warning reports is applicable.

***message***

If the import ended abruptly, the `message` would contain further information in relation to what
happened.

### Import Summary Report Level

As previously stated, `GET /tracker/jobs/{uid}/report` can be retrieved using a specific
`reportMode` parameter. By default the endpoint will return an `importSummary` with `reportMode`
`ERROR`.

| Parameter | Description |
|---|---|
| `FULL` | Returns everything from `WARNINGS`, plus `timingsStats` |
| `WARNINGS` | Returns everything from `ERRORS`, plus `warningReports` in `validationReports` |
| `ERRORS` (default) | Returns only `errorReports` in `validationReports` |

In addition, all `reportModes` will return `status`, `stats`, `bundleReport` and `message` when
applicable.

### Error Codes { #webapi_nti_error_codes }

There are various error codes for different error scenarios. The following table has the list of
error codes thrown from the new Tracker API, along with the error messages and some additional
descriptions. The placeholders in the error messages (`{0}`,`{1}`,`{2}`..) are usually uids unless
otherwise specified.

| Error Code | Error Message | Description |
|:--|:----|:----|
| E1000 | User: `{0}`, has no write access to OrganisationUnit: `{1}`. | This typically means that the OrganisationUnit `{1}` is not in the capture scope of the user `{0}` for the write operation to be authorized. |
| E1001 | User: `{0}`, has no data write access to TrackedEntityType: `{1}`. | The error occurs when the user is not authorized to create or modify data of the TrackedEntityType `{1}`
| E1002 | TrackedEntity: `{0}`, already exists. | This error is thrown when trying to create a new TrackedEntity with an already existing uid. Make sure a new uid is used when adding a new TrackedEntity. |
| E1003 | OrganisationUnit: `{0}` of TrackedEntity is outside search scope of User: `{1}`. | |
| E1005 | Could not find TrackedEntityType: `{0}`. | Error thrown when trying to fetch a non existing TrackedEntityType with uid `{0}` . This might also mean that the user does not have read access to the TrackedEntityType. |
| E1006 | Attribute: `{0}`, does not exist. | Error thrown when the system was not able to find a matching TrackedEntityAttribute with uid `{0}`. This might also mean that the user does not have access to the TrackedEntityAttribute. |
| E1007 | Error validating attribute value type: `{0}`; Error: `{1}`. | Mismatch between value type of a TrackedEntityAttribute and its provided attribute value. The actual validation error will be displayed in `{1}`. |
| E1008 | Program stage `{0}` has no reference to a program. Check the program stage configuration | |
| E1009 | File resource: `{0}`, has already been assigned to a different object. | The File resource uid `{0}` is already assigned to another object in the system. |
| E1010 | Could not find Program: `{0}`, linked to Event. | The system was unable to find a Program with the uid `{0}` specified inside the Event payload. This might also mean that the specific Program is not accessible by the logged in user. |
| E1011 | Could not find OrganisationUnit: `{0}`, linked to Event. | The system was unable to find a OrganisationUnit with uid `{0}` specified inside the Event payload.  |
| E1012 | Geometry does not conform to FeatureType: `{0}`. | FeatureType provided is either NONE or an incompatible one for the provided geometry value. |
| E1013 | Could not find ProgramStage: `{0}`, linked to Event. | The system was unable to find a ProgramStage with uid `{0}` specified inside the Event payload. This might also mean that the ProgramStage is not accessible to the logged in user.  |
| E1014 | Provided Program: `{0}`, is a Program without registration. An Enrollment cannot be created into Program without registration. | Enrollments can only be created for Programs with registration. |
| E1015 | TrackedEntity: `{0}`, already has an active Enrollment in Program `{1}`. | Cannot enroll into a Program if another active enrollment already exists for the Program. The active enrollment will have to be completed first at least.|
| E1016 | TrackedEntity: `{0}`, already has an active enrollment in Program: `{1}`, and this program only allows enrolling one time. | As per the Program `{1}` configuration, a TrackedEntity can only be enrolled into that Program once. It looks like the TrackedEntity `{0}` already has either an ACTIVE or COMPLETED enrollment in that Program. Hence another enrollment cannot be added. |
| E1018 | Attribute: `{0}`, is mandatory in program `{1}` but not declared in enrollment `{2}`. | Attribute value is missing in payload, for an attribute that is defined as mandatory for a Program. Make sure that attribute values for mandatory attributes are provided in the payload.  |
| E1019 | Only Program attributes is allowed for enrollment; Non valid attribute: `{0}`. | Attribute uid `{0}` specified in the enrollment payload is not associated with the Program.  |
| E1020 | Enrollment date: `{0}`, can`t be future date. | Cannot enroll into a future date unless the Program allows for it in its configuration. |
| E1021 | Incident date: `{0}`, can`t be future date. | Incident date cannot be a future date unless the Program allows for it in its configuration. |
| E1022 | TrackedEntity: `{0}`, must have same TrackedEntityType as Program `{1}`. | The Program is configured to accept TrackedEntityType uid that is different from what is provided in the enrollment payload. |
| E1023 | DisplayIncidentDate is true but property occurredAt is null or has an invalid format: `{0}`. | Program is configured with DisplayIncidentDate but its either null or an invalid date in the payload. |
| E1025 | Property enrolledAt is null or has an invalid format: `{0}`. | EnrolledAt Date is mandatory for an Enrollment. Make sure it is not null and has a valid date format. |
| E1029 | Event OrganisationUnit: `{0}`, and Program: `{1}`, don't match. | The Event payload uses a Program `{1}` which is not configured to be accessible by OrganisationUnit `{0}`. |
| E1030 | Event: `{0}`, already exists. | This error is thrown when trying to add a new Event with an already existing uid. Make sure a new uid is used when adding a new Event. |
| E1031 | Event OccurredAt date is missing. | OccuredAt property is either null or has an invalidate date format in the payload. |
| E1032 | Event: `{0}`, do not exist. | |
| E1033 | Event: `{0}`, Enrollment value is NULL. | |
| E1035 | Event: `{0}`, ProgramStage value is NULL. | |
| E1039 | ProgramStage: `{0}`, is not repeatable and an event already exists. | An Event already exists for the ProgramStage for the specific Enrollment. Since the ProgramStage is configured to be non-repeatable, another Event for the same ProgramStage cannot be added.  |
| E1041 | Enrollment OrganisationUnit: `{0}`, and Program: `{1}`, don't match. | The Enrollment payload contains a Program `{1}` which is not configured to be accessible by the OrganisationUnit  `{0}`. |
| E1042 | Event: `{0}`, needs to have completed date. | If the program is configured to have completeExpiryDays, then CompletedDate is mandatory for a COMPLETED event payload. An Event with status as COMPLETED should have completedDate property as non-null and a valid date format. |
| E1043 | Event: `{0}`, completeness date has expired. Not possible to make changes to this event. | A user without 'F_EDIT_EXPIRED' authority cannot update an Event that has passed its expiry days as configured in its Program. |
| E1045 | Program: `{0}`, expiry date has passed. It is not possible to make changes to this event. | |
| E1046 | Event: `{0}`, needs to have at least one (event or schedule) date. | Either of occuredAt or scheduledAt property should be present in the Event payload. |
| E1047 | Event: `{0}`, date belongs to an expired period. It is not possible to create such event. | Event occuredAt or scheduledAt has a value that is earlier than the PeriodType start date.  |
| E1048 | Object: `{0}`, uid: `{1}`, has an invalid uid format. | A valid uid has 11 characters. The first character has to be an alphabet (a-z or A-Z) and the remaining 10 characters can be alphanumeric (a-z or A-Z or 0-9). |
| E1049 | Could not find OrganisationUnit: `{0}`, linked to Tracked Entity. | The system could not find an OrganisationUnit with uid `{0}`. |
| E1050 | Event ScheduledAt date is missing. | ScheduledAt property in the Event payload is either missing or an invalid date format. |
| E1054 | AttributeOptionCombo `{0}` is not in the event programs category combo `{1}`. |
| E1055 | Default AttributeOptionCombo is not allowed since program has non-default CategoryCombo. | The Program is configured to contain non-default CategoryCombo but the request uses the Default AttributeOptionCombo. |
| E1056 | Event date: `{0}`, is before start date: `{1}`, for AttributeOption: `{2}`. | The CategoryOption has a start date configured , the Event date in the payload cannot be earlier than this start date. |
| E1057 | Event date: `{0}`, is after end date: `{1}`, for AttributeOption; `{2}`. | The CategoryOption has an end date configured, the Event date in the payload cannot be later than this end date.  |
| E1063 | TrackedEntity: `{0}`, does not exist. | Error thrown when trying to fetch a non existing TrackedEntity with uid `{0}` . This might also mean that the user does not have read access to the TrackedEntity. |
| E1064 | Non-unique attribute value `{0}` for attribute `{1}` | The attribute value has to be unique within the defined scope. The error indicates that the attribute value already exists for another TrackedEntity. |
| E1068 | Could not find TrackedEntity: `{0}`, linked to Enrollment. | The system could not find the TrackedEntity specified in the Enrollment payload. This might also mean that the user does not have read access to the TrackedEntity. |
| E1069 | Could not find Program: `{0}`, linked to Enrollment. | The system could not find the Program specified in the Enrollment payload. This might also mean that the user does not have read access to the Program. |
| E1070 | Could not find OrganisationUnit: `{0}`, linked to Enrollment. | The system could not find the OrganisationUnit specified in the Enrollment payload. |
| E1074 | FeatureType is missing. | |
| E1075 | Attribute: `{0}`, is missing uid. | |
| E1076 | `{0}` `{1}` is mandatory and can't be null | |
| E1077 | Attribute: `{0}`, text value exceed the maximum allowed length: `{0}`. | |
| E1079 | Event: `{0}`, program: `{1}` is different from program defined in enrollment `{2}`. | |
| E1080 | Enrollment: `{0}`, already exists. | This error is thrown when trying to create a new Enrollmentt with an already existing uid. Make sure a new uid is used when adding a new Enrollment. |
| E1081 | Enrollment: `{0}`, do not exist. | Error thrown when trying to fetch a non existing Enrollment with uid `{0}` . This might also mean that the user does not have read access to the Enrollment. |
| E1082 | Event: `{0}`, is already deleted and can't be modified. | If the event is soft deleted, no modifications on it are allowed. |
| E1083 | User: `{0}`, is not authorized to modify completed events. | Only a super user or a user with the authority "F_UNCOMPLETE_EVENT" can modify completed events. Completed Events are those Events with status as COMPLETED. |
| E1084 | File resource: `{0}`, reference could not be found. | |
| E1085 | Attribute: `{0}`, value does not match value type: `{1}`. | Mismatch between value type of an attribute and its provided attribute value. |
| E1086 | Event: `{0}`, has a program: `{1}`, that is a registration but its ProgramStage is not valid or missing. | |
| E1087 | Event: `{0}`, could not find DataElement: `{1}`, linked to a data value. | |
| E1088 | Event: `{0}`, program: `{1}`, and ProgramStage: `{2}`, could not be found. | |
| E1089 | Event: `{0}`, references a Program Stage `{1}` that does not belong to Program `{2}`. | The ProgramStage uid and Program uid in the Event payload is incompatible. |
| E1090 | Attribute: `{0}`, is mandatory in tracked entity type `{1}` but not declared in tracked entity `{2}`. | The payload has missing values for mandatory TrackedEntityTypeAttributes. |
| E1091 | User: `{0}`, has no data write access to Program: `{1}`. | The Program sharing configuration is such that, the user does not have write access for this Program. |
| E1094 | Not allowed to update Enrollment: `{0}`, existing Program `{1}`. | The Enrollment payload for an existing Enrollment has a different Program uid than the one it was originally enrolled with. |
| E1095 | User: `{0}`, has no data write access to ProgramStage: `{1}`. | The ProgramStage sharing configuration is such that, the user does not have write access for this ProgramStage.  |
| E1096 | User: `{0}`, has no data read access to Program: `{1}`. | The Program sharing configuration is such that, the user does not have read access for this Program. |
| E1099 | User: `{0}`, has no write access to CategoryOption: `{1}`. | The CategoryOption sharing configuration is such that, the user does not have write access for this CategoryOption |
| E1100 | User: `{0}`, is lacking 'F_TEI_CASCADE_DELETE' authority to delete TrackedEntity: `{1}`. | There exists undeleted Enrollments for this TrackedEntity. If the user does not have 'F_TEI_CASCADE_DELETE' authority, then these Enrollments has to be deleted first explicitly to be able to delete the TrackedEntity. |
| E1102 | User: `{0}`, does not have access to the tracked entity: `{1}`, Program: `{2}`, combination. | This error is thrown when the user's OrganisationUnit does not have the ownership of this TrackedEntity for this specific Program. The owning OrganisationUnit of the TrackedEntity-Program combination should fall into the capture scope (in some cases the search scope) of the user. |
| E1103 | User: `{0}`, is lacking 'F_ENROLLMENT_CASCADE_DELETE' authority to delete Enrollment : `{1}`. | There exists undeleted Events for this Enrollment. If the user does not have 'F_ENROLLMENT_CASCADE_DELETE' authority, then these Events has to be deleted first explicitly to be able to delete the Enrollment. |
| E1104 | User: `{0}`, has no data read access to program: `{1}`, TrackedEntityType: `{2}`. | The sharing configuration of the TrackedEntityType associated with the Program is such that, the user does not have data read access to it. |
| E1110 | Not allowed to update Event: `{0}`, existing Program `{1}`. | The Event payload for an existing Event has a different Program uid than the one it was originally created with.  |
| E1112 | Attribute value: `{0}`, is set to confidential but system is not properly configured to encrypt data. | Either JCE files is missing or the configuration property `encryption.password` might be missing in `dhis.conf`. |
| E1113 | Enrollment: `{0}`, is already deleted and can't be modified. | If the Enrollment is soft deleted, no modifications on it are allowed. |
| E1114 | TrackedEntity: `{0}`, is already deleted and can't be modified. | If the TrackedEntity is soft deleted, no modifications on it are allowed. |
| E1115 | Could not find CategoryOptionCombo: `{0}`. | |
| E1116 | Could not find CategoryOption: `{0}`. | This might also mean the CategoryOption is not accessible to the user.|
| E1117 | CategoryOptionCombo does not exist for given category combo and category options: `{0}`. | |
| E1118 | Assigned user `{0}` is not a valid uid. | |
| E1119 | A Tracker Note with uid `{0}` already exists. | |
| E1120 | ProgramStage `{0}` does not allow user assignment | Event payload has assignedUserId but the ProgramStage is not configured to allow user assignment. |
| E1121 | Missing required tracked entity property: `{0}`. | |
| E1122 | Missing required enrollment property: `{0}`. | |
| E1123 | Missing required event property: `{0}`. | |
| E1124 | Missing required relationship property: `{0}`. | |
| E1125 | Value `{0}` is not a valid option code in option set `{1}` | |
| E1126 | Not allowed to update Tracked Entity property: {0}. | |
| E1127 | Not allowed to update Enrollment property: {0}. | |
| E1128 | Not allowed to update Event property: {0}. | |
| E1300 | Generated by program rule (`{0}`) - `{1}` | |
| E1301 | Generated by program rule (`{0}`) - Mandatory DataElement `{1}` is not present | |
| E1302 | Generated by program rule (`{0}`) - DataElement `{1}` is not valid: `{2}` | |
| E1303 | Generated by program rule (`{0}`) - Mandatory DataElement `{1}` is not present | |
| E1304 | Generated by program rule (`{0}`) - DataElement `{1}` is not a valid data element | |
| E1305 | Generated by program rule (`{0}`) - DataElement `{1}` is not part of `{2}` program stage | |
| E1306 | Generated by program rule (`{0}`) - Mandatory Attribute `{1}` is not present | |
| E1307 | Generated by program rule (`{0}`) - Unable to assign value to data element `{1}`. The provided value must be empty or match the calculated value `{2}` | |
| E1308 | Generated by program rule (`{0}`) - DataElement `{1}` is being replaced in event `{2}` | |
| E1309 | Generated by program rule (`{0}`) - Unable to assign value to attribute `{1}`. The provided value must be empty or match the calculated value `{2}` | |
| E1310 | Generated by program rule (`{0}`) - Attribute `{1}` is being replaced in tei `{2}` | |
| E1311 | Referral events need to have at least one complete relationship | |
| E1312 | Referral events need to have both sides of a relationship | |
| E1313 | Event {0} of an enrollment does not point to an existing tracked entity. The data in your system might be corrupted | Indicates an anomaly in the existing data whereby enrollments might not reference a tracked entity |
| E4000 | Relationship: `{0}` cannot link to itself | |
| E4001 | Relationship Item `{0}` for Relationship `{1}` is invalid: an Item can link only one Tracker entity. | |
| E4006 | Could not find relationship Type: `{0}`. | |
| E4010 | Relationship Type `{0}` constraint requires a {1} but a {2} was found. | |
| E4011 | Relationship: `{0}` cannot be persisted because {1} {2} referenced by this relationship is not valid. | |
| E4012 | Could not find `{0}`: `{1}`, linked to Relationship. | |
| E4014 | Relationship type `{0}` constraint requires a tracked entity having type `{1}` but `{2}` was found. | |
| E4015 | Relationship: `{0}`, already exists. | |
| E4016 | Relationship: `{0}`, do not exist. | |
| E4017 | Relationship: `{0}`, is already deleted and cannot be modified. | |
| E4018 | Relationship: `{0}`, linking {1}: `{2}` to {3}: `{4}` already exists. | |
| E4019 | User: `{0}`, has no data write access to relationship type: `{1}`. | |
| E5000 | "{0}" `{1}` cannot be persisted because "{2}" `{3}` referenced by it cannot be persisted. | The importer can't persist a tracker object because a reference cannot be persisted. |
| E5001 | "{0}" `{1}` cannot be deleted because "{2}" `{3}` referenced by it cannot be deleted. | The importer can't deleted a tracker object because a reference cannot be deleted. |
| E9999 | N/A | Undefined error message. |

### Validation { #webapi_nti_validation }

While importing data using the tracker importer, a series of validations are performed to ensure the
validity of the data. This section will describe some of the different types of validation performed
to provide a better understanding if validation fails for your import.

#### Required properties

Each of the tracker objects has a few required properties that need to be present when importing
data. For an exhaustive list of required properties, have a look at the [Tracker Object
section](#webapi_nti_tracker_objects).

When validating required properties, we are usually talking about references to other data or
metadata. In these cases, there are three main criteria:

1. The reference is present and not null in the payload.
2. The reference points to the correct type of data and exists in the database
3. The user has access to see the reference

If the first condition fails, the import will fail with a message about a missing reference.
However, suppose the reference points to something that doesn't exist or which the user cannot
access. In that case, both cases will result in a message about the reference not being found.

#### Formats

Some of the properties of tracker objects require a specific format. When importing data, each of
these properties is validated against the expected format and will return different errors depending
on which property has a wrong format. Some examples of properties that are validated this way:

- UIDs (These cover all references to other data or metadata in DHIS2.)
- Dates
- Geometry (The coordinates must match the format as specified by its type)

#### User access

All data imported will be validated based on the metadata  ([Sharing](#webapi_nti_metadata_sharing))
and the organisation units ([Organisation Unit Scopes](#webapi_nti_orgunit_scope)) referenced in the
data. You can find more information about sharing and organisation unit scopes in the following
sections.

Sharing is validated at the same time as references are looked up in the database. Metadata outside
of the user's access will be treated as if it doesn't exist. The import will validate any metadata
referenced in the data.

Organisation units, on the other hand, serve a dual purpose. It will primarily make sure that data
can only be imported when imported for an organisation unit the user has within their "capture
scope". Secondly, organisation units are also used to restrict what programs are available. That
means if you are trying to import data for an organisation unit that does not have access to the
Program you are importing, the import will be invalid.

Users with the `ALL` authority will ignore the limits of sharing and organisation unit scopes when
they import data. However, they can not import enrollments in organisation units that do not have
access to the enrollment program.

#### Attribute and Data values

Attributes and data values are part of a tracked entity and an event, respectively. However,
attributes can be linked to a tracked entity either through its type (TrackedEntityType) or its
Program (Program). Additionally, attributes can also be unique.

The initial validation done in the import is to make sure the value provided for an attribute or
data element conforms to the type of value expected. For example, suppose you import a value for a
data element with a numeric type. In that case, the value is expected to be numeric. Any errors
related to a mismatch between a type and a value will result in the same error code but with a
specific message related to the type of violation.

Mandatory attributes and data values are also checked. Currently, removing mandatory attributes is
not allowed. Some use-cases require values to be sent separately, while others require all values to
be sent as one. Programs can be configured to either validate mandatory attributes `ON_COMPLETE` or
`ON_UPDATE_AND_INSERT` to accommodate these use-cases.

The import will validate unique attributes at the time of import. That means as long as the provided
value is unique for the attribute in the whole system, it will pass. However, if the unique value is
fpound used by any other tracked entity other than the one being imported, it will fail.

#### Configuration

The last part of validations in the importer are validations based on the user's configuration of
relevant metadata. For more information about each configuration, check out the relevant sections.
Some examples of configurable validations:

- Feature type (For geometry)
- User-assignable events
- Allow future dates
- Enroll once
- And more.

These configurations will further change how validation is performed during import.

### Program Rules { #webapi_nti_program_rules }

Users can configure [Program Rules](#webapi_program_rules), which adds conditional behavior to
tracker forms. In addition to running these rules in the tracker apps, the tracker importer will
also run a selection of these rules. Since the importer is also running these rules, we can ensure
an additional level of validation.

Not all program rule actions are supported since they are only suitable for a frontend presentation.
A complete list of the supported program rule actions is presented below.

  |Program Rule Action|Supported|
  |---|:---:|
  |**DISPLAYTEXT**| |
  |**DISPLAYKEYVALUEPAIR**| |
  |**HIDEFIELD**||
  |**HIDESECTION**||
  |**ASSIGN**|**X**|
  |**SHOWWARNING**|**X**|
  |**SHOWERROR**|**X**|
  |**WARNINGONCOMPLETION**|**X**|
  |**ERRORONCOMPLETION**|**X**|
  |**CREATEEVENT**||
  |**SETMANDATORYFIELD**|**X**|
  |**SENDMESSAGE**|**X**|
  |**SCHEDULEMESSAGE**|**X**|

Program rules are evaluated in the importer in the same way they are evaluated in the Tracker apps.
To summarize, the following conditions are considered when enforcing the program rules:

* The program rule must be linked to the data being imported. For example, a program stage or a data
element.
* The Program rule's condition must be evaluated to true

The results of the program rules depend on the actions defined in those rules:

* Program rule actions may end in 2 different results: Warnings or Errors.
  * Errors will make the validation fail, while the warnings will be reported as a message in the
  import summary.
    * SHOWWARNING and WARNINGONCOMPLETION actions can generate only Warnings.
    * SHOWERROR, ERRORONCOMPLETION, and SETMANDATORYFIELD actions can generate only Errors.
    * ASSIGN action can generate both Warnings and Errors.
      * When the action is assigning a value to an empty attribute/data element, a warning is
      generated.
      * When the action is assigning a value to an attribute/data element that already has the same
      value to be assigned, a warning is generated.
      * When the action is assigning a value to an attribute/data element that already has a value
      and the value to be assigned is different, an error is generated unless the
      `RULE_ENGINE_ASSIGN_OVERWRITE` system setting is set to true.

Additionally, program rules can also result in side-effects, like send and schedule messages. More
information about side effects can be found in the following section.

> **NOTE**
>
> Program rules can be skipped during import using the `skipProgramRules` parameter.

### Side Effects { #webapi_nti_side_effects }

After an import has been completed, specific tasks might be triggered as a result of the import.
These tasks are what we refer to as "Side effects". These tasks perform operations that do not
affect the import itself.

Side effects are tasks running detached from the import but are always triggered by an import. Since
side effects are detached from the import, they can fail even when the import is successful.
Additionally, side effects are only run when the import is successful, so they cannot fail the other
way around.

The following side effects are currently supported:

|Side Effects|Supported|Description|
|---|:---:|---|
|**Tracker Notification**|**X**| Updates can trigger notifications. Updates which trigger notifications are **enrollment**, **event update**, **event or enrollment completion**. |
|**ProgramRule Notification**|**X**| Program rules can trigger notifications. Note that these notifications are part of program rule effects which are generated through the DHIS2 rule engine.|

> **NOTE**
>
> Certain configurations can control the execution of side effects. `skipSideEffects` flag can be set during the import to skip side effects entirely. This parameter can be useful if you import something you don't want to trigger notifications for, as an example.

### Assign user to events { #webapi_nti_user_event_assignment }

Specific workflows benefit from treating events like tasks, and for this reason, you can assign a
user to an event.

Assigning a user to an event will not change the access or permissions for users but will create a
link between the Event and the user. When an event has a user assigned, you can query events from
the API using the `assignedUser` field as a parameter.

When you want to assign a user to an event, you simply provide the UID of the user you want to
assign in the `assignedUser` field. See the following example:

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

In this example, the user with uid `M0fCOxtkURr` will be assigned to the Event with uid
`ZwwuwNp6gVd`. Only one user can be assigned to a single event.

To use this feature, the relevant program stage needs to have user assignment enabled, and the uid
provided for the user must refer to a valid, existing user.

## Tracker Export { #webapi_nti_export }

Tracker export endpoints allow you to retrieve the previously imported objects which are:

- **tracked entities**
- **events**
- **enrollments**
- **relationships**

> **NOTE**
>
> * All tracker export endpoints default to a `JSON` response content. `CSV` is only supported
>   by tracked entities and events.
> * You can export a CSV file by adding the `Accept` header ***text/csv*** or ***application/csv***
>   to the request.
> * You can download in zip and gzip formats:
>     *  CSV for Tracked entities
>     *  JSON and CSV for Events
> * You can export a Gzip file by adding the `Accept` header ***application/csv+gzip*** for CSV
> or ***application/json+gzip*** for JSON.
> * You can export a Zip file by adding the `Accept` header ***application/csv+zip*** for CSV or
> ***application/json+zip*** for JSON.

### Common request parameters

The following endpoint supports standard parameters for pagination.

- **Tracked entities** `GET /api/tracker/trackedEntities`
- **Events** `GET /api/tracker/events`
- **Enrollments** `GET /api/tracker/enrollments`
- **Relationships** `GET /api/tracker/relationships`

#### Request parameters for pagination

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`page`|`Integer`|Any positive integer|Page number to return. Defaults to 1.|
|`pageSize`|`Integer`|Any positive integer|Page size. Defaults to 50.|
|`totalPages`|`Boolean`|`true`&#124;`false`|Indicates whether to return the total number of elements and pages. Defaults to `false` as getting the totals is an expensive operation.|
|`paging`|`Boolean`|`true`&#124;`false`|Indicates whether paging should be ignored and all rows should be returned. Defaults to `true`, meaning that by default all requests are paginated, unless `paging=false`.|
|`skipPaging` **deprecated for removal in version 42 use `paging`**|`Boolean`|`true`&#124;`false`|Indicates whether paging should be ignored and all rows should be returned. Defaults to `false`, meaning that by default all requests are paginated, unless `skipPaging=true`.|
|`order`|`String`|Comma-separated list of property name and sort direction pairs in format `propName:sortDirection`.<br><br>Example: `createdAt:desc`<br><br>**Note:** `propName` is case sensitive. Valid `sortDirections` are `asc` and `desc`. `sortDirection` is case-insensitive. `sortDirection` defaults to `asc` for properties or UIDs without explicit `sortDirection`.||

> **Caution**
>
> Be aware that the performance is directly related to the amount of data requested. Larger pages
> will take more time to return.

#### Request parameters for Organisational Unit selection mode

The available organisation unit selection modes are `SELECTED`, `CHILDREN`, `DESCENDANTS`,
`ACCESSIBLE`, `CAPTURE` and `ALL`. Each mode is explained in detail in [this
section](#webapi_nti_orgunit_scope).

#### Request parameter to filter responses { #webapi_nti_field_filter }

All export endpoints accept a `fields` parameter which controls which fields will be returned in the
JSON response. `fields` parameter accepts a comma separated list of field names or patterns. A few
possible `fields` filters are shown below. Refer to [Metadata field
filter](#webapi_metadata_field_filter) for a more complete guide on how to use `fields`.

##### Examples

|Parameter example|Meaning|
|:---|:---|
|`fields=*`|returns all fields|
|`fields=createdAt,uid`|only returns fields `createdAt` and `uid`|
|`fields=enrollments[*,!uid]`|returns all fields of `enrollments` except `uid`|
|`fields=enrollments[uid]`|only returns `enrollments` field `uid`|
|`fields=enrollments[uid,enrolledAt]`|only returns `enrollments` fields `uid` and `enrolledAt`|

### Tracked Entities (`GET /api/tracker/trackedEntities`)

Two endpoints are dedicated to tracked entities:

- `GET /api/tracker/trackedEntities`
  - retrieves tracked entities matching given criteria
- `GET /api/tracker/trackedEntities/{id}`
  - retrieves a tracked entity given the provided id

If not otherwise specified, JSON is the default response for the `GET` method.
The API also supports CSV export for single and collection endpoints. Furthermore, compressed
CSV types is an option for the collection endpoint.

#### CSV

In the case of CSV, the `fields` request parameter has no effect, and the response will always
contain the following fields:

  - trackedEntity (UID)
  - trackedEntityType (UID)
  - createdAt (Datetime)
  - createdAtClient (Datetime)
  - updatedAt (Datetime)
  - updatedAtClient (Datetime)
  - orgUnit (UID)
  - inactive (boolean)
  - deleted (boolean)
  - potentialDuplicate (boolean)
  - geometry (WKT, https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry.
    You can omit it in case of a `Point` type and with `latitude` and `longitude` provided)
  - latitude (Latitude of a `Point` type of Geometry)
  - longitude (Longitude of a `Point` type of Geometry)
  - attribute (UID)
  - displayName (String)
  - attrCreatedAt (Attribute creation Datetime)
  - attrUpdatedAt (Attribute last update Datetime)
  - valueType (String)
  - value (String)
  - storedBy (String)
  - createdBy (Username of user)
  - updatedBy (Username of user)

See [Tracked Entities](#tracked-entities) and [Attributes](#attributes) for more field descriptions.

#### GZIP

The response is file `trackedEntities.csv.gz` containing the `trackedEntities.csv` file.

#### ZIP

The response is file `trackedEntities.csv.zip` containing the `trackedEntities.csv` file.

#### Tracked Entities Collection endpoint `GET /api/tracker/trackedEntities`

The purpose of this endpoint is to retrieve tracked entities matching client-provided criteria.

The endpoint returns a list of tracked entities that match the request parameters.

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`filter`|`String`|Comma-separated values of attribute filters.|Narrows response to TEIs matching given filters. A filter is a colon separated property or attribute UID with optional operator and value pairs. Example: `filter=H9IlTX2X6SL:sw:A` with operator starts with `sw` followed by a value. Special characters like `+` need to be percent-encoded so `%2B` instead of `+`. Characters such as `:` (colon) or `,` (comma), as part of the filter value, need to be escaped by `/` (slash). Likewise, `/` needs to be escaped. Multiple operator/value pairs for the same property/attribute like `filter=AuPLng5hLbE:gt:438901703:lt:448901704` are allowed. Repeating the same attribute UID is not allowed. User needs access to the attribute to filter on it.|
|`orgUnits`|`String`|Comma-separated list of organisation unit `UID`s.|Only return tracked entities belonging to provided organisation units|
|`orgUnit` **deprecated for removal in version 42 use `orgUnits`**|`String`|Semicolon-separated list of organisation units `UID`s.|Only return tracked entities belonging to provided organisation units.|
|`orgUnitMode` see [orgUnitModes](#webapi_nti_orgunit_scope)|`String`|`SELECTED`&#124;`CHILDREN`&#124;`DESCENDANTS`&#124;`ACCESSIBLE`&#124;`CAPTURE`&#124;`ALL`|The mode of selecting organisation units, can be. Default is `SELECTED`, which refers to the selected organisation units only.|
|`ouMode` **deprecated for removal in version 42 use `orgUnitMode`** see [orgUnitModes](#webapi_nti_orgunit_scope)|`String`|`SELECTED`&#124;`CHILDREN`&#124;`DESCENDANTS`&#124;`ACCESSIBLE`&#124;`CAPTURE`&#124;`ALL`|The mode of selecting organisation units, can be. Default is `SELECTED`, which refers to the selected organisation units only.|
|`program`|`String`|Program `UID`|A program `UID` for which tracked entities in the response must be enrolled into.|
|`programStatus`|`String`|`ACTIVE`&#124;`COMPLETED`&#124;`CANCELLED`|The program status of the tracked entity in the given program.|
|`programStage`|`String`|`UID`|A program stage `UID` for which tracked entities in the response must have events for.|
|`followUp`|`Boolean`|`true`&#124;`false`|Indicates whether the tracked entity is marked for follow up for the specified program.|
|`updatedAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) | Start date and time for last updated|
|`updatedBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) | End date and time for last updated|
|`updatedWithin`|`Duration`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601#Durations) | Returns TEIs not older than specified Duration|
|`enrollmentEnrolledAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|Start date and time for enrollment in the given program|
|`enrollmentEnrolledBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|End date and time for enrollment in the given program|
|`enrollmentOccurredAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|Start date and time and time and time for occurred in the given program|
|`enrollmentOccurredBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|End date and time and time for occurred in the given program|
|`trackedEntityType`|`String`|UID of tracked entity type|Only returns tracked entities of given type.|
|`trackedEntities`|`String`|Comma-separated list of tracked entity `UID`s.|Filter the result down to a limited set of tracked entities using explicit uids of the tracked entities by using `trackedEntity=id1,id2`. This parameter will, at the very least, create the outer boundary of the results, forming the list of all tracked entities using the uids provided. If other parameters/filters from this table are used, they will further limit the results from the explicit outer boundary.|
|`trackedEntity` **deprecated for removal in version 42 use `trackedEntities`**|`String`|Semicolon-separated list of tracked entity `UID`s.|Filter the result down to a limited set of tracked entities using explicit uids of the tracked entities by using `trackedEntity=id1;id2`. This parameter will, at the very least, create the outer boundary of the results, forming the list of all tracked entities using the uids provided. If other parameters/filters from this table are used, they will further limit the results from the explicit outer boundary.|
|`assignedUserMode`|`String`|`CURRENT`&#124;`PROVIDED`&#124;`NONE`&#124;`ANY`|Restricts result to tracked entities with events assigned based on the assigned user selection mode. See table below "Assigned user modes" for explanations. |
|`assignedUsers`|`String`|Comma-separated list of user UIDs to filter based on events assigned to the users.|Filter the result down to a limited set of tracked entities with events that are assigned to the given user IDs by using `assignedUser=id1,id2`. This parameter will only be considered if `assignedUserMode` is either `PROVIDED` or `null`. The API will error out, if for example, `assignedUserMode=CURRENT` and `assignedUser=someId`.|
|`assignedUser` **deprecated for removal in version 42 use `assignedUsers`**|`String`|Semicolon-separated list of user UIDs to filter based on events assigned to the users.|Filter the result down to a limited set of tracked entities with events that are assigned to the given user IDs by using `assignedUser=id1;id2`.This parameter will only be considered if assignedUserMode is either `PROVIDED` or `null`. The API will error out, if for example, `assignedUserMode=CURRENT` and `assignedUser=someId`|
|`order`|`String`|Comma-separated list of property name or attribute or UID and sort direction pairs in format `propName:sortDirection`.|Supported values are `createdAt, createdAtClient, enrolledAt, inactive, trackedEntity, updatedAt, updatedAtClient`.|
|`eventStatus`|`String`|`ACTIVE`&#124;`COMPLETED`&#124;`VISITED`&#124;`SCHEDULE`&#124;`OVERDUE`&#124;`SKIPPED`|Status of any events in the specified program|
|`eventOccurredAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|Start date and time for Event for the given Program|
|`eventOccurredBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|End date and time for Event for the given Program|
|`includeDeleted`|`Boolean`|`true`&#124;`false`|Indicates whether to include soft-deleted elements|
|`potentialDuplicate`|`Boolean`|`true`&#124;`false`| Filter the result based on the fact that a TEI is a Potential Duplicate. true: return TEIs flagged as Potential Duplicates. false: return TEIs NOT flagged as Potential Duplicates. If omitted, we don't check whether a TEI is a Potential Duplicate or not. |

The available assigned user modes are explained in the following table.


Table: Assigned user modes

| Mode | Description |
|---|---|
| CURRENT | Includes events assigned to the current logged in user. |
| PROVIDED | Includes events assigned to the user provided in the request. |
| NONE | Includes unassigned events only. |
| ANY | Includes all assigned events, doesn't matter who are they assigned to as long as they assigned to someone. |

The query is case insensitive. The following rules apply to the query
parameters.

- At least one organisation unit must be specified using the `orgUnit`
  parameter (one or many), or `orgUnitMode=ALL` must be specified.

- Only one of the `program` and `trackedEntity` parameters can be
  specified (zero or one).

- If `programStatus` is specified, then `program` must also be
  specified.

- If `followUp` is specified, then `program` must also be specified.

- If `enrollmentEnrolledAfter` or `enrollmentEnrolledBefore` is specified then
  `program` must also be specified.

- Filter items can only be specified once.

##### Example requests

A query for all tracked entities associated with a specific organisation unit and program can look
like this:

    GET /api/tracker/trackedEntities?program=IpHINAT79UW&orgUnits=DiszpKrYNg8

To query for tracked entities using one attribute with a filter and one attribute without a filter,
with one organisation unit using the descendant organisation unit query mode:

    GET /api/tracker/trackedEntities?program=IpHINAT79UW&orgUnits=DiszpKrYNg8&filter=w75KJ2mc4zz:EQ:John

A query where multiple operand and filters are specified for a filter item:

    GET /api/tracker/trackedEntities?orgUnits=DiszpKrYNg8&program=ur1Edk5Oe2n&filter=lw1SqmMlnfh:GT:150&filter=lw1SqmMlnfh:LT:190

A query filter with a value that needs escaping and will be interpreted as `:,/`:

    GET /api/tracker/trackedEntities?orgUnits=DiszpKrYNg8&program=ur1Edk5Oe2n&filter=lw1SqmMlnfh:EQ:/:/,//

To specify program enrollment dates as part of the query:

    GET /api/tracker/trackedEntities?orgUnits=DiszpKrYNg8&program=IpHINAT79UW&fields=trackedEntity,enrollments[enrolledAt]&enrollmentEnrolledAfter=2024-01-01

To query on an attribute using multiple values in an *IN* filter:

    GET /api/tracker/trackedEntities?trackedEntityType=nEenWmSyUEp&orgUnits=DiszpKrYNg8&filter=w75KJ2mc4zz:IN:Scott;Jimmy;Santiago

You can use a range of operators for the filtering:

|Operator|  Description|
|---|---|
|`EQ`|Equal to|
|`GE`|Greater than or equal to|
|`GT`|Greater than|
|`IN`|Equal to one of the multiple values separated by ";"|
|`LE`|Less than or equal to|
|`LIKE`|Like (free text match)|
|`LT`|Less than|
|`NE`|Not equal to|

##### Tracked Entities response example

The API supports CSV and JSON response for `GET /api/tracker/trackedEntities`.

##### JSON

Responses can be filtered on desired fields, see [Request parameter to filter
responses](#webapi_nti_field_filter)

A JSON response can look like the following:

```json
{
  "pager": {
    "page": 1,
    "pageSize": 1
  },
  "trackedEntities": [
    {
      "trackedEntity": "F8yKM85NbxW",
      "trackedEntityType": "Zy2SEgA61ys",
      "createdAt": "2019-08-21T13:25:38.022",
      "createdAtClient": "2019-03-19T01:12:16.624",
      "updatedAt": "2019-08-21T13:31:33.410",
      "updatedAtClient": "2019-03-19T01:12:16.624",
      "orgUnit": "DiszpKrYNg8",
      "inactive": false,
      "deleted": false,
      "potentialDuplicate": false,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -11.7896,
          8.2593
        ]
      },
      "attributes": [
        {
          "attribute": "B6TnnFMgmCk",
          "displayName": "Age (years)",
          "createdAt": "2019-08-21T13:25:38.477",
          "updatedAt": "2019-08-21T13:25:38.477",
          "storedBy": "braimbault",
          "valueType": "INTEGER_ZERO_OR_POSITIVE",
          "value": "30"
        },
        {
          "attribute": "TfdH5KvFmMy",
          "displayName": "First Name",
          "createdAt": "2019-08-21T13:25:38.066",
          "updatedAt": "2019-08-21T13:25:38.067",
          "storedBy": "josemp10",
          "valueType": "TEXT",
          "value": "Sarah"
        },
        {
          "attribute": "aW66s2QSosT",
          "displayName": "Last Name",
          "createdAt": "2019-08-21T13:25:38.388",
          "updatedAt": "2019-08-21T13:25:38.388",
          "storedBy": "karoline",
          "valueType": "TEXT",
          "value": "Johnson"
        }
      ]
    }
  ]
}
```

##### CSV

A CSV response can look like the following:

```
trackedEntity,trackedEntityType,createdAt,createdAtClient,updatedAt,updatedAtClient,orgUnit,inactive,deleted,potentialDuplicate,geometry,latitude,longitude,storedBy,createdBy,updatedBy,attrCreatedAt,attrUpdatedAt,attribute,displayName,value,valueType
F8yKM85NbxW,Zy2SEgA61ys,2019-08-21T11:25:38.022Z,2019-03-19T00:12:16.624Z,2019-08-21T11:31:33.410Z,2019-03-19T00:12:16.624Z,DiszpKrYNg8,false,false,false,"POINT (-11.7896 8.2593)",8.2593,-11.7896,,,,2019-08-21T11:25:38.477Z,2019-08-21T11:25:38.477Z,B6TnnFMgmCk,"Age (years)",30,INTEGER_ZERO_OR_POSITIVE
F8yKM85NbxW,Zy2SEgA61ys,2019-08-21T11:25:38.022Z,2019-03-19T00:12:16.624Z,2019-08-21T11:31:33.410Z,2019-03-19T00:12:16.624Z,DiszpKrYNg8,false,false,false,"POINT (-11.7896 8.2593)",8.2593,-11.7896,,,,2019-08-21T11:25:38.066Z,2019-08-21T11:25:38.067Z,TfdH5KvFmMy,"First Name",Sarah,TEXT
F8yKM85NbxW,Zy2SEgA61ys,2019-08-21T11:25:38.022Z,2019-03-19T00:12:16.624Z,2019-08-21T11:31:33.410Z,2019-03-19T00:12:16.624Z,DiszpKrYNg8,false,false,false,"POINT (-11.7896 8.2593)",8.2593,-11.7896,,,,2019-08-21T11:25:38.388Z,2019-08-21T11:25:38.388Z,aW66s2QSosT,"Last Name",Johnson,TEXT
```

#### Tracked Entities single object endpoint `GET /api/tracker/trackedEntities/{uid}`

The purpose of this endpoint is to retrieve one tracked entity given its uid.

##### Request syntax

`GET /api/tracker/trackedEntities/{uid}?program={programUid}&fields={fields}`

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`uid`|`String`|`uid`|Return the tracked entity with specified `uid`|
|`program`|`String`|`uid`| Include program attributes in the response (only the ones user has access to) |
|`fields`|`String`| Any valid field filter (default `*,!relationships,!enrollments,!events,!programOwners`) |Include specified sub-objects in the response|

##### Example requests

A query for a tracked entity:

    GET /api/tracker/trackedEntities/PQfMcpmXeFE

##### Tracked Entity response example

The API supports CSV and JSON response for `GET /api/tracker/trackedEntities/{uid}`

###### JSON

An example of a json response:

```json
{
  "trackedEntity": "PQfMcpmXeFE",
  "trackedEntityType": "nEenWmSyUEp",
  "createdAt": "2014-03-06T05:49:28.256",
  "createdAtClient": "2014-03-06T05:49:28.256",
  "updatedAt": "2016-08-03T23:49:43.309",
  "orgUnit": "DiszpKrYNg8",
  "inactive": false,
  "deleted": false,
  "potentialDuplicate": false,
  "attributes": [
    {
      "attribute": "w75KJ2mc4zz",
      "code": "MMD_PER_NAM",
      "displayName": "First name",
      "createdAt": "2016-08-03T23:49:43.308",
      "updatedAt": "2016-08-03T23:49:43.308",
      "valueType": "TEXT",
      "value": "John"
    },
    {
      "attribute": "zDhUuAYrxNC",
      "displayName": "Last name",
      "createdAt": "2016-08-03T23:49:43.309",
      "updatedAt": "2016-08-03T23:49:43.309",
      "valueType": "TEXT",
      "value": "Kelly"
    }
  ],
  "enrollments": [
    {
      "enrollment": "JMgRZyeLWOo",
      "createdAt": "2017-03-06T05:49:28.340",
      "createdAtClient": "2016-03-06T05:49:28.340",
      "updatedAt": "2017-03-06T05:49:28.357",
      "trackedEntity": "PQfMcpmXeFE",
      "program": "IpHINAT79UW",
      "status": "ACTIVE",
      "orgUnit": "DiszpKrYNg8",
      "enrolledAt": "2024-03-06T00:00:00.000",
      "occurredAt": "2024-03-04T00:00:00.000",
      "followUp": false,
      "deleted": false,
      "events": [
        {
          "event": "Zq2dg6pTNoj",
          "status": "ACTIVE",
          "program": "IpHINAT79UW",
          "programStage": "ZzYYXq4fJie",
          "enrollment": "JMgRZyeLWOo",
          "trackedEntity": "PQfMcpmXeFE",
          "relationships": [],
          "scheduledAt": "2023-03-10T00:00:00.000",
          "followUp": false,
          "deleted": false,
          "createdAt": "2017-03-06T05:49:28.353",
          "createdAtClient": "2016-03-06T05:49:28.353",
          "updatedAt": "2017-03-06T05:49:28.353",
          "attributeOptionCombo": "HllvX50cXC0",
          "attributeCategoryOptions": "xYerKDKCefk",
          "dataValues": [],
          "notes": [],
          "followup": false
        }
      ],
      "relationships": [],
      "attributes": [
        {
          "attribute": "w75KJ2mc4zz",
          "code": "MMD_PER_NAM",
          "displayName": "First name",
          "createdAt": "2016-08-03T23:49:43.308",
          "updatedAt": "2016-08-03T23:49:43.308",
          "valueType": "TEXT",
          "value": "John"
        },
        {
          "attribute": "zDhUuAYrxNC",
          "displayName": "Last name",
          "createdAt": "2016-08-03T23:49:43.309",
          "updatedAt": "2016-08-03T23:49:43.309",
          "valueType": "TEXT",
          "value": "Kelly"
        },
        {
          "attribute": "AuPLng5hLbE",
          "code": "National identifier",
          "displayName": "National identifier",
          "createdAt": "2016-08-03T23:49:43.301",
          "updatedAt": "2016-08-03T23:49:43.301",
          "valueType": "TEXT",
          "value": "245435245"
        },
        {
          "attribute": "ruQQnf6rswq",
          "displayName": "TB number",
          "createdAt": "2016-08-03T23:49:43.308",
          "updatedAt": "2016-08-03T23:49:43.308",
          "valueType": "TEXT",
          "value": "1Z 1F2 A84 59 4464 173 6"
        },
        {
          "attribute": "cejWyOfXge6",
          "displayName": "Gender",
          "createdAt": "2016-08-03T23:49:43.307",
          "updatedAt": "2016-08-03T23:49:43.307",
          "valueType": "TEXT",
          "value": "Male"
        },
        {
          "attribute": "VqEFza8wbwA",
          "code": "MMD_PER_ADR1",
          "displayName": "Address",
          "createdAt": "2016-08-03T23:49:43.307",
          "updatedAt": "2016-08-03T23:49:43.307",
          "valueType": "TEXT",
          "value": "Main street 2"
        }
      ],
      "notes": []
    }
  ],
  "programOwners": [
    {
      "orgUnit": "DiszpKrYNg8",
      "trackedEntity": "PQfMcpmXeFE",
      "program": "ur1Edk5Oe2n"
    },
    {
      "orgUnit": "DiszpKrYNg8",
      "trackedEntity": "PQfMcpmXeFE",
      "program": "IpHINAT79UW"
    }
  ]
}
```

###### CSV

The response will be the same as the collection endpoint but referring to a single tracked
entity, although it might have multiple rows for each attribute.

#### Tracked entity attribute value change logs { #webapi_tracker_attribute_change_logs }
`GET /api/tracker/trackedEntities/{uid}/changeLogs`

This endpoint retrieves change logs for the attributes of a specific tracked entity. It returns a list of all tracked entity attributes that have changed over time for that entity.

|Parameter|Type|Allowed values|
|---|---|---|
|path `/{uid}`|`String`|Tracked entity `UID`.|
|`program`|`String`|Program `UID` (optional).|

##### Tracked entity attribute value change logs response example

An example of a json response:

```json
{
   "pager":{
      "page":1,
      "pageSize":10
   },
   "changeLogs":[
      {
         "createdBy":{
            "uid":"AIK2aQOJIbj",
            "username":"tracker",
            "firstName":"Tracker demo",
            "surname":"User"
         },
         "createdAt":"2024-06-20T14:51:16.433",
         "type":"UPDATE",
         "change":{
            "dataValue":{
               "dataElement":"bx6fsa0t90x",
               "previousValue":"true",
               "currentValue":"false"
            }
         }
      },
      {
         "createdBy":{
            "uid":"AIK2aQOJIbj",
            "username":"tracker",
            "firstName":"Tracker demo",
            "surname":"User"
         },
         "createdAt":"2024-06-20T14:50:32.966",
         "type":"CREATE",
         "change":{
            "dataValue":{
               "dataElement":"ebaJjqltK5N",
               "currentValue":"0"
            }
         }
      }
   ]
}
```

The change log type can be `CREATE`, `UPDATE`, or `DELETE`.
`CREATE` and `DELETE` will always hold a single value: the former shows the current value, and the latter shows the value that was deleted. UPDATE will hold two values: the previous and the current.

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
|`orgUnits`|`String`|Comma-separated list of organisation unit `UID`s.|Only return enrollments belonging to provided organisation units.|
|`orgUnit` **deprecated for removal in version 42 use `orgUnits`**|`String`|Semicolon-separated list of organisation units `UID`s.|Only return enrollments belonging to provided organisation units.|
|`orgUnitMode` see [orgUnitModes](#webapi_nti_orgunit_scope)|`String`|`SELECTED`&#124;`CHILDREN`&#124;`DESCENDANTS`&#124;`ACCESSIBLE`&#124;`CAPTURE`&#124;`ALL`|The mode of selecting organisation units, can be. Default is `SELECTED`, which refers to the selected organisation units only.|
|`ouMode` **deprecated for removal in version 42 use `orgUnitMode`** see [orgUnitModes](#webapi_nti_orgunit_scope)|`String`|`SELECTED`&#124;`CHILDREN`&#124;`DESCENDANTS`&#124;`ACCESSIBLE`&#124;`CAPTURE`&#124;`ALL`|The mode of selecting organisation units, can be. Default is `SELECTED`, which refers to the selected organisation units only.|
|`program`|`String`|`uid`| Identifier of program|
|`programStatus`|`enum`| `ACTIVE`&#124;`COMPLETED`&#124;`CANCELLED`| Program Status |
|`followUp`|`boolean`| `true`&#124;`false` | Follow up status of the tracked entity for the given program. Can be `true`&#124;`false` or omitted.|
|`updatedAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) | Only enrollments updated after this date|
|`updatedWithin`|`Duration`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)| Only enrollments updated since given duration |
|`enrolledAfter`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|  Only enrollments newer than this date|
|`enrolledBefore`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)| Only enrollments older than this date|
|`trackedEntityType`|`String`|`uid`| Identifier of tracked entity type|
|`trackedEntity`|`String`|`uid`| Identifier of tracked entity|
|`order`|`String`|Comma-separated list of property name or attribute or UID and sort direction pairs in format `propName:sortDirection`.|Supported fields: `completedAt, createdAt, createdAtClient, enrolledAt, updatedAt, updatedAtClient`.|
|`enrollments`|`String`|Comma-separated list of enrollment `UID`s.|Filter the result down to a limited set of IDs by using `enrollments=id1,id2`.|
|`enrollment` **deprecated for removal in version 42 use `enrollments`**|`String`|Semicolon-separated list of `uid`|Filter the result down to a limited set of IDs by using `enrollment=id1;id2`.|
|`includeDeleted`|`Boolean`| |When true, soft deleted events will be included in your query result.|

The query is case-insensitive. The following rules apply to the query parameters.

- At least one organisation unit must be specified using the `orgUnit` parameter (one or many), or
*orgUnitMode=ALL* must be specified.

- Only one of the *program* and *trackedEntity* parameters can be specified (zero or one).

- If *programStatus* is specified, then *program* must also be specified.

- If *followUp* is specified, then *program* must also be specified.

- If *enrolledAfter* or *enrolledBefore* is specified, then *program* must also be specified.

##### Example requests

A query for all enrollments associated with a specific organisation unit can look like this:

    GET /api/tracker/enrollments?orgUnits=DiszpKrYNg8

To constrain the response to enrollments which are part of a specific program you can include a
program query parameter:

    GET /api/tracker/enrollments?orgUnits=O6uvpzGd5pu&orgUnitMode=DESCENDANTS&program=ur1Edk5Oe2n

To specify program enrollment dates as part of the query:

    GET /api/tracker/enrollments?orgUnits=DiszpKrYNg8&program=M3xtLkYBlKI&enrolledAfter=2023-11-14&enrolledBefore=2024-02-07

To constrain the response to enrollments of a specific tracked entity you can include a tracked
entity query parameter:

    GET /api/tracker/enrollments?trackedEntity=ClJ3fn47c4s

To constrain the response to enrollments of a specific tracked entity you can include a tracked
entity query parameter, in In this case, we have restricted it to available enrollments viewable for
current user:

    GET /api/tracker/enrollments?orgUnitMode=ACCESSIBLE&trackedEntity=tphfdyIiVL6

##### Response format

The `JSON` response can look like the following.

```json
{
  "pager": {
    "page": 1,
    "pageSize": 1
  },
  "enrollments": [
    {
      "enrollment": "TRE0GT7eh7Q",
      "createdAt": "2019-08-21T13:28:00.056",
      "createdAtClient": "2018-11-13T15:06:49.009",
      "updatedAt": "2019-08-21T13:29:44.942",
      "updatedAtClient": "2019-08-21T13:29:44.942",
      "trackedEntity": "s4NfKOuayqG",
      "program": "M3xtLkYBlKI",
      "status": "COMPLETED",
      "orgUnit": "DiszpKrYNg8",
      "enrolledAt": "2023-11-13T00:00:00.000",
      "occurredAt": "2023-11-13T00:00:00.000",
      "followUp": false,
      "deleted": false,
      "storedBy": "healthworker1",
      "notes": []
    }
  ]
}
```

#### Enrollments single object endpoint `GET /api/tracker/enrollments/{uid}`

The purpose of this endpoint is to retrieve one Enrollment given its uid.

##### Request syntax

`GET /api/tracker/enrollment/{uid}`

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`uid`|`String`|`uid`|Return the Enrollment with specified `uid`|
|`fields`|`String`| Any valid field filter (default `*,!relationships,!events,!attributes`) |Include
specified sub-objects in the response|

##### Example requests

A query for an enrollment:

    GET /api/tracker/enrollments/JMgRZyeLWOo

##### Response format

```json
{
  "enrollment": "JMgRZyeLWOo",
  "createdAt": "2017-03-06T05:49:28.340",
  "createdAtClient": "2016-03-06T05:49:28.340",
  "updatedAt": "2017-03-06T05:49:28.357",
  "trackedEntity": "PQfMcpmXeFE",
  "program": "IpHINAT79UW",
  "status": "ACTIVE",
  "orgUnit": "DiszpKrYNg8",
  "enrolledAt": "2024-03-06T00:00:00.000",
  "occurredAt": "2024-03-04T00:00:00.000",
  "followUp": false,
  "deleted": false,
  "notes": []
}
```

### Events (`GET /api/tracker/events`)

Two endpoints are dedicated to events:

- `GET /api/tracker/events`
    - retrieves events matching given criteria
- `GET /api/tracker/events/{id}`
    - retrieves an event given the provided id

If not otherwise specified, JSON is the default response for the `GET` method.
The API also supports CSV export for single and collection endpoints. Furthermore, it supports
compressed JSON and CSV for the collection endpoint.

#### Events CSV

In the case of CSV, the `fields` request parameter has no effect, and the response will always
contain the following fields:

  - event (UID)
  - status (String)
  - program (UID)
  - programStage (UID)
  - enrollment (UID)
  - orgUnit (UID)
  - occurredAt (DateTime)
  - scheduledAt (DateTime)
  - geometry (WKT, https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry.
    You can omit it in case of a `Point` type and with `latitude` and `longitude` provided)
  - latitude (Latitude of a `Point` type of Geometry)
  - longitude (Longitude of a `Point` type of Geometry)
  - followUp (boolean)
  - deleted (boolean)
  - createdAt (DateTime)
  - createdAtClient (DateTime)
  - updatedAt (DateTime)
  - updatedAtClient (DateTime)
  - completedBy (String)
  - completedAt (DateTime)
  - updatedBy (UserName of user)
  - attributeOptionCombo (UID)
  - attributeCategoryOptions (UID)
  - assignedUser (UserName of user)
  - dataElement (UID)
  - value (String)
  - storedBy (String)
  - providedElsewhere (boolean)
  - storedByDataValue (String)
  - createAtDataValue (DateTime)
  - updatedAtDataValue (DateTime)

See [Events](#events) and [Data Values](#data-values) for more field descriptions.

#### Events GZIP

The response is file `events.json.gz` or `events.csv.gzip` containing the `events.json`
or `events.csv` file.

#### Events ZIP

The response is file`events.json.gz` or `events.json.zip` containing the `events.json`
or `events.csv` file.

#### Events Collection endpoint `GET /api/tracker/events`

Returns a list of events based on the provided filters.

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`program`|`String`|`uid`| Identifier of program|
|`programStage`|`String`|`uid`| Identifier of program stage|
|`programStatus`|`enum`| `ACTIVE`&#124;`COMPLETED`&#124;`CANCELLED`| Status of event in program |
|`filter`|`String`|Comma separated values of data element filters|Narrows response to events matching given filters. A filter is a colon separated property or data element UID with optional operator and value pairs. Example: `filter=fazCI2ygYkq:eq:PASSIVE` with operator starts with `eq` followed by a value. A filter like `filter=fazCI2ygYkq` returns all events where the given data element has a value. Characters such as `:` (colon) or `,` (comma), as part of the filter value, need to be escaped by `/` (slash). Likewise, `/` needs to be escaped. Multiple operator/value pairs for the same property/data element like `filter=qrur9Dvnyt5:gt:70:lt:80` are allowed. Repeating the same data element UID is not allowed. User needs access to the data element to filter on it.|
|`filterAttributes`|`String`|Comma separated values of attribute filters|Narrows response to TEIs matching given filters. A filter is a colon separated property or attribute UID with optional operator and value pairs. Example: `filterAttributes=H9IlTX2X6SL:sw:A` with operator starts with `sw` followed by a value. A filter like `filter=H9IlTX2X6SL` returns all events where the given attribute has a value. Special characters like `+` need to be percent-encoded so `%2B` instead of `+`. Characters such as `:` (colon) or `,` (comma), as part of the filter value, need to be escaped by `/` (slash). Likewise, `/` needs to be escaped. Multiple operator/value pairs for the same property/attribute like `filterAttributes=AuPLng5hLbE:gt:438901703:lt:448901704` are allowed. Repeating the same attribute UID is not allowed. User needs access to the attribute to filter on it.|
|`followUp`|`boolean`| `true`&#124;`false` | Whether event is considered for follow up in program. Defaults to `true`|
|`trackedEntity`|`String`|`uid`|Identifier of tracked entity|
|`orgUnit`|`String`|`uid`|Identifier of organisation unit|
|`orgUnitMode` see [orgUnitModes](#webapi_nti_orgunit_scope)|`String`|`SELECTED`&#124;`CHILDREN`&#124;`DESCENDANTS`&#124;`ACCESSIBLE`&#124;`CAPTURE`&#124;`ALL`|The mode of selecting organisation units, can be. Default is `SELECTED`, which refers to the selected organisation units only.|
|`ouMode` **deprecated for removal in version 42 use `orgUnitMode`** see [orgUnitModes](#webapi_nti_orgunit_scope)|`String`|`SELECTED`&#124;`CHILDREN`&#124;`DESCENDANTS`&#124;`ACCESSIBLE`&#124;`CAPTURE`&#124;`ALL`|The mode of selecting organisation units, can be. Default is `SELECTED`, which refers to the selected organisation units only.|
|`status`|`String`|`ACTIVE`&#124;`COMPLETED`&#124;`VISITED`&#124;`SCHEDULE`&#124;`OVERDUE`&#124;`SKIPPED` | Status of event|
|`occurredAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) | Filter for events which occurred after this date.|
|`occurredBefore`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)| Filter for events which occurred up until this date.|
|`scheduledAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) | Filter for events which were scheduled after this date.|
|`scheduledBefore`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)| Filter for events which were scheduled before this date.|
|`updatedAfter`|`DateTime`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)| Filter for events which were updated after this date. Cannot be used together with `updatedWithin`.|
|`updatedBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) | Filter for events which were updated up until this date. Cannot be used together with `updatedWithin`.|
|`updatedWithin`|`Duration`| [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601#Durations)| Include only items which are updated within the given duration.<br><br> The format is [ISO-8601#Duration](https://en.wikipedia.org/wiki/ISO_8601#Durations)|
|`enrollmentEnrolledAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|Start date and time for enrollment in the given program|
|`enrollmentEnrolledBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|End date and time for enrollment in the given program|
|`enrollmentOccurredAfter`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|Start date and time for occurred in the given program|
|`enrollmentOccurredBefore`|`DateTime`|[ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)|End date and time for occurred in the given program|
|`order`|`String`|Comma-separated list of property name, attribute or data element UID and sort direction pairs in format `propName:sortDirection`.|Supported fields: `assignedUser, assignedUserDisplayName, attributeOptionCombo, completedAt, completedBy, createdAt, createdAtClient, createdBy, deleted, enrolledAt, enrollment, enrollmentStatus, event, followUp, followup (deprecated), occurredAt, orgUnit, program, programStage, scheduledAt, status, storedBy, trackedEntity, updatedAt, updatedAtClient, updatedBy`.|
|`events`|`String`|Comma-separated list of event `UID`s.|Filter the result down to a limited set of IDs by using `event=id1,id2`.|
|`event` **deprecated for removal in version 42 use `events`**|`String`|Semicolon-separated list of `uid`| Filter the result down to a limited set of IDs by using `event=id1;id2`.|
|`attributeCategoryCombo` (see note)|`String`|Attribute category combo identifier. Must be combined with `attributeCategoryOptions`.|
|`attributeCc` **deprecated for removal in version 42 use `attributeCategoryCombo`**|`String`|Attribute category combo identifier (must be combined with attributeCos)|
|`attributeCategoryOptions` (see note)|`String`|Comma-separated attribute category option identifiers. Must be combined with `attributeCategoryCombo`.|
|`attributeCos` **deprecated for removal in version 42 use `attributeCategoryOptions`**|`String`|Semicolon-separated attribute category option identifiers. Must be combined with `attributeCc`.|
|`includeDeleted`|`Boolean`| |  When true, soft deleted events will be included in your query result.|
|`assignedUserMode`|`String`| `CURRENT`&#124;`PROVIDED`&#124;`NONE`&#124;`ANY`| Assigned user selection mode|
|`assignedUsers`|`String`|Comma-separated list of user UIDs to filter based on events assigned to the users.|Filter the result down to a limited set of tracked entities with events that are assigned to the given user IDs by using `assignedUser=id1,id2`.This parameter will only be considered if `assignedUserMode` is either `PROVIDED` or `null`. The API will error out, if for example, `assignedUserMode=CURRENT` and `assignedUser=someId`.|
|`assignedUser` **deprecated for removal in version 42 use `assignedUsers`**|`String`|Semicolon-separated list of user UIDs to filter based on events assigned to the users.|Filter the result down to a limited set of tracked entities with events that are assigned to the given user IDs by using `assignedUser=id1;id2`.This parameter will only be considered if assignedUserMode is either `PROVIDED` or `null`. The API will error out, if for example, `assignedUserMode=CURRENT` and `assignedUser=someId`|

> **Note**
>
> If the query contains neither `attributeCategoryOptions` nor `attributeCategoryOptions`,
> the server returns events for all attribute option combos where the user has read access.

##### Example requests

The query for all events with children of a particular organisation unit:

    GET /api/tracker/events?orgUnit=YuQRtpLP10I&orgUnitMode=CHILDREN

The query for all events with all descendants of a particular organisation unit, implying all
organisation units in the sub-hierarchy:

    GET /api/tracker/events?orgUnit=O6uvpzGd5pu&orgUnitMode=DESCENDANTS

Query for all events with a certain program and organisation unit:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc

Query for all events with a certain program and organisation unit, sorting by scheduled date
ascending:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc&order=scheduledAt

Query for the 10 events with the newest occurred date in a certain program and organisation unit -
by paging and ordering by occurred date descending:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc&order=occurredAt:desc&pageSize=10&page=1

Query for all events with a certain program and organisation unit for a specific tracked entity:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=M3xtLkYBlKI&trackedEntity=dNpxRu1mWG5

Query for all events older or equal to 2024-02-03 and associated with a program and organisation
unit:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc&occurredBefore=2024-02-03

A query where multiple operand and filters are specified for a data element UID:

    GET /api/tracker/events?orgUnit=g8upMTyEZGZ&program=M3xtLkYBlKI&filter=rFQNCGMYud2:GT:35&filter=rFQNCGMYud2:LT:50

A query filter with a value that needs escaping and will be interpreted as `:,/`:

    GET /api/tracker/events?orgUnit=DiszpKrYNg8&program=lxAQ7Zs9VYR&filter=DanTR5x0WDK:EQ:/:/,//

##### Events response example

The API supports CSV and JSON response for `GET /api/tracker/events`.

###### JSON

The JSON response can look like the following:

```json
{
  "pager": {
    "page": 1,
    "pageSize": 1
  },
  "events": [
    {
      "event": "A7rzcnZTe2T",
      "status": "ACTIVE",
      "program": "eBAyeGv0exc",
      "programStage": "Zj7UnCAulEk",
      "enrollment": "RiLEKhWHlxZ",
      "orgUnit": "DwpbWkiqjMy",
      "occurredAt": "2023-02-13T00:00:00.000",
      "scheduledAt": "2023-02-13T00:00:00.000",
      "followUp": false,
      "deleted": false,
      "createdAt": "2017-09-08T21:40:22.000",
      "createdAtClient": "2016-09-08T21:40:22.000",
      "updatedAt": "2017-09-08T21:40:22.000",
      "attributeOptionCombo": "HllvX50cXC0",
      "attributeCategoryOptions": "xYerKDKCefk",
      "geometry": {
        "type": "Point",
        "coordinates": [
          -11.468912037323042,
          7.515913998868316
        ]
      },
      "dataValues": [
        {
          "createdAt": "2016-12-06T18:22:34.438",
          "updatedAt": "2016-12-06T18:22:34.438",
          "storedBy": "bjorn",
          "providedElsewhere": false,
          "dataElement": "F3ogKBuviRA",
          "value": "[-11.4880220438585,7.50978830548003]"
        },
        {
          "createdAt": "2013-12-30T14:23:57.423",
          "updatedAt": "2013-12-30T14:23:57.423",
          "storedBy": "lars",
          "providedElsewhere": false,
          "dataElement": "eMyVanycQSC",
          "value": "2018-02-07"
        },
        {
          "createdAt": "2013-12-30T14:23:57.382",
          "updatedAt": "2013-12-30T14:23:57.382",
          "storedBy": "lars",
          "providedElsewhere": false,
          "dataElement": "oZg33kd9taw",
          "value": "Male"
        }
      ],
      "notes": [],
      "followup": false
    }
  ]
}
```

###### CSV

The CSV response can look like the following:

```csv
event,status,program,programStage,enrollment,orgUnit,occurredAt,scheduledAt,geometry,latitude,longitude,followUp,deleted,createdAt,createdAtClient,updatedAt,updatedAtClient,completedBy,completedAt,updatedBy,attributeOptionCombo,attributeCategoryOptions,assignedUser,dataElement,value,storedBy,providedElsewhere,storedByDataValue,updatedAtDataValue,createdAtDataValue
A7rzcnZTe2T,ACTIVE,eBAyeGv0exc,Zj7UnCAulEk,RiLEKhWHlxZ,DwpbWkiqjMy,2023-02-12T23:00:00Z,2023-02-12T23:00:00Z,"POINT (-11.468912037323042 7.515913998868316)",7.515913998868316,-11.468912037323042,false,false,2017-09-08T19:40:22Z,,2017-09-08T19:40:22Z,,,,,HllvX50cXC0,xYerKDKCefk,,F3ogKBuviRA,"[-11.4880220438585,7.50978830548003]",admin,false,,2016-12-06T17:22:34.438Z,2016-12-06T17:22:34.438Z
A7rzcnZTe2T,ACTIVE,eBAyeGv0exc,Zj7UnCAulEk,RiLEKhWHlxZ,DwpbWkiqjMy,2023-02-12T23:00:00Z,2023-02-12T23:00:00Z,"POINT (-11.468912037323042 7.515913998868316)",7.515913998868316,-11.468912037323042,false,false,2017-09-08T19:40:22Z,,2017-09-08T19:40:22Z,,,,,HllvX50cXC0,xYerKDKCefk,,eMyVanycQSC,2018-02-07,admin,false,,2013-12-30T13:23:57.423Z,2013-12-30T13:23:57.423Z
A7rzcnZTe2T,ACTIVE,eBAyeGv0exc,Zj7UnCAulEk,RiLEKhWHlxZ,DwpbWkiqjMy,2023-02-12T23:00:00Z,2023-02-12T23:00:00Z,"POINT (-11.468912037323042 7.515913998868316)",7.515913998868316,-11.468912037323042,false,false,2017-09-08T19:40:22Z,,2017-09-08T19:40:22Z,,,,,HllvX50cXC0,xYerKDKCefk,,msodh3rEMJa,2018-02-13,admin,false,,2013-12-30T13:23:57.467Z,2013-12-30T13:23:57.467Z
```

#### Events single object endpoint `GET /api/tracker/events/{uid}`

The purpose of this endpoint is to retrieve one Event given its uid.

##### Request syntax

`GET /api/tracker/events/{uid}?fields={fields}`

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`uid`|`String`|`uid`|Return the Event with specified `uid`|
|`fields`|`String`| Any valid field filter (default `*,!relationships`) |Include specified sub-objects in the response|

##### Example requests

A query for an Event:

    GET /api/tracker/events/rgWr86qs0sI

##### Event response example

The API supports CSV and JSON response for `GET /api/tracker/trackedEntities`

###### JSON

```json
{
  "event": "rgWr86qs0sI",
  "status": "ACTIVE",
  "program": "kla3mAPgvCH",
  "programStage": "aNLq9ZYoy9W",
  "enrollment": "Lo3SHzCnMSm",
  "orgUnit": "DiszpKrYNg8",
  "occurredAt": "2024-10-12T00:00:00.000",
  "followUp": false,
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
    }
  ],
  "notes": [],
  "followup": false
}
```

###### CSV

The response will be the same as the collection endpoint but referring to a single event,
although it might have multiple rows for each data element value.

#### Event data value change logs { #webapi_event_data_value_change_logs }
`GET /api/tracker/events/{uid}/changeLogs`

This endpoint retrieves change logs for the data values of a specific event. It returns a list of all event data values that have changed over time for that particular event.

|Parameter|Type|Allowed values|
|---|---|---|
|path `/{uid}`|`String`|Event `UID`.|

##### Event data value change logs response example

An example of a json response:

```json
{
   "pager":{
      "page":1,
      "pageSize":10
   },
   "changeLogs":[
      {
         "createdBy":{
            "uid":"AIK2aQOJIbj",
            "username":"tracker",
            "firstName":"Tracker demo",
            "surname":"User"
         },
         "createdAt":"2024-06-20T15:43:36.342",
         "type":"DELETE",
         "change":{
            "dataValue":{
               "dataElement":"UXz7xuGCEhU",
               "previousValue":"12"
            }
         }
      },
      {
         "createdBy":{
            "uid":"AIK2aQOJIbj",
            "username":"tracker",
            "firstName":"Tracker demo",
            "surname":"User"
         },
         "createdAt":"2024-06-20T15:43:27.175",
         "type":"CREATE",
         "change":{
            "dataValue":{
               "dataElement":"UXz7xuGCEhU",
               "currentValue":"12"
            }
         }
      },
      {
         "createdBy":{
            "uid":"AIK2aQOJIbj",
            "username":"tracker",
            "firstName":"Tracker demo",
            "surname":"User"
         },
         "createdAt":"2024-06-20T14:51:16.433",
         "type":"UPDATE",
         "change":{
            "dataValue":{
               "dataElement":"bx6fsa0t90x",
               "previousValue":"true",
               "currentValue":"false"
            }
         }
      }
   ]
}
```

The change log type can be `CREATE`, `UPDATE`, or `DELETE`.
`CREATE` and `DELETE` will always hold a single value: the former shows the current value, and the latter shows the value that was deleted. UPDATE will hold two values: the previous and the current.


### Relationships (`GET /api/tracker/relationships`)

Relationships are links between two entities in the Tracker. These entities can be tracked entities,
enrollments, and events.

The purpose of this endpoint is to retrieve relationships between objects.

Unlike other tracked objects endpoints, relationships only expose one endpoint:

- `GET /api/tracker/relationships?[trackedEntity={trackedEntityUid}|enrollment={enrollmentUid}|event={eventUid}]&fields=[fields]`

#### Request parameters

|Request parameter|Type|Allowed values|Description|
|---|---|---|---|
|`trackedEntity`|`String`|`uid`|Identifier of a tracked entity|
|`enrollment`|`String`|`uid`|Identifier of an enrollment|
|`event`|`String`|`uid`|Identifier of an event|
|`fields`|`String`|Any valid field filter (default `relationship,relationshipType,createdAtClient,from[trackedEntity[trackedEntity],enrollment[enrollment],event[event]],to[trackedEntity[trackedEntity],enrollment[enrollment],event[event]]`) |Include specified sub-objects in the response|
|`order`|`String`|Comma-separated list of property name or attribute or UID and sort direction pairs in format `propName:sortDirection`.|Supported fields: `createdAt, createdAtClient`.|
|`includeDeleted`|`Boolean`|`true`&#124;`false`| whether to include soft-deleted elements in your query result|

The following rules apply to the query parameters.

- only one parameter among `trackedEntity`, `enrollment`, `event` can be passed

> **NOTE**
>
> Using tracked entity, enrollment or event params, will return any relationship where the
> trackedEntity, enrollment or event is part of the relationship (either from or to). As long as
> user has access, that is.

#### Example response

```json
{
  "pager": {
    "page": 1,
    "pageSize": 2
  },
  "relationships": [
    {
      "relationship": "oGtgtJpp6fG",
      "relationshipType": "Mv8R4MPcNcX",
      "from": {
        "trackedEntity": {
          "trackedEntity": "neR4cmMY22o"
        }
      },
      "to": {
        "trackedEntity": {
          "trackedEntity": "DsSlC54GNXy"
        }
      }
    },
    {
      "relationship": "SSfIicJKbh5",
      "relationshipType": "Mv8R4MPcNcX",
      "from": {
        "trackedEntity": {
          "trackedEntity": "neR4cmMY22o"
        }
      },
      "to": {
        "trackedEntity": {
          "trackedEntity": "rEYUGH97Ssd"
        }
      }
    }
  ]
}
```

## Tracker Access Control { #webapi_nti_access_control }

Tracker has a few different concepts in regards to access control, like sharing, organisation unit
scopes, ownership, and access levels. The following sections provide a short introduction to the
different topics.

### Metadata Sharing { #webapi_nti_metadata_sharing }

Sharing setting is standard DHIS2 functionality that applies to both Tracker and Aggregate
metadata/data as well as dashboards and visualization items. At the core of sharing is the ability
to define who can see/do what. In general, there are five possible sharing configurations – no
access, metadata read, metadata write, data read, and data write. These access configurations can be
granted at user and/or user group level (for more flexibility). With a focus on Tracker, the
following metadata and their sharing setting is of particular importance: Data Element, Category
Option, Program, Program Stage, Tracked Entity Type, Tracked Entity Attribute as well as Tracker
related Dashboards and Dashboard Items.

How sharing setting works is straightforward – the settings are enforced during Tracker data
import/export processes. To read value, one needs to have data read access. If a user is expected to
modify data, he/she needs to have data write access. Similarly, if a user is expected to modify
metadata, it is essential to grant metadata write access.

One critical point with Tracker data is the need to have a holistic approach. For example, a user
won’t be able to see the Data Element value by having read access to just the Data Element. The user
needs to have data read to access the parent Program Stage and Program where this Data Element
belongs. It is the same with the category option combination. In Tracker, the Event is related to
AttributeOptionCombo, which is made up of a combination of Category Options. Therefore, for a user
to read data of an Event, he/she needs to have data read access to all Category Options and
corresponding Categories that constitute the AttributeOptionCombo of the Event in question. If a
user lacks access to just one Category Option or Category, then the user has no access to the entire
Event.

When it comes to accessing Enrollment data, it is essential to have access to the Tracked Entity
first. Access to a Tracked Entity is controlled through sharing setting of Program, Tracked Entity
Type, and Tracked Entity Attribute. Once Enrollment is accessed, it is possible to access Event
data, again depending on Program Stage and Data element sharing setting.

Another vital point to consider is how to map out access to different Program Stages of a Program.
Sometimes we could be in a situation where we need to grant access to a specific stage – for
example, “Lab Result” – to a specific group of users (Lab Technicians). In this situation, we can
provide data write access to "Lab Result" stage, probably data read to one or more stages just in
case we want Lab Technicians to read other medical results or no access if we think it not necessary
for the Lab Technicians to see data other than lab related.

In summary, DHIS2 has a fine-grained sharing setting that we can use to implement access control
mechanisms both at the data and metadata level. These sharing settings can be applied directly at
the user level or user group level. How exactly to apply a sharing setting depends on the use-case
at hand.

For more detailed information about data sharing, check out [Data
sharing](https://docs.dhis2.org/en/use/user-guides/dhis-core-version-master/configuring-the-system/about-sharing-of-objects.html#data-sharing-for-event-based-programs).

### Organisation Unit Scopes { #webapi_nti_orgunit_scope }

Organisation units are one of the most fundamental objects in DHIS2. They define a universe under
which a user is allowed to record and/or read data. There are three types of organisation units that
can be assigned to a user. These are data capture, data view (not used in tracker), and tracker
search. As the name implies, these organisation units define a scope under which a user is allowed
to conduct the respective operations.

However, to further fine-tune the scope, DHIS2 Tracker introduces a concept that we call
**OrganisationUnitSelectionMode**. Such a mode is often used at the time exporting tracker objects.
For example, given that a user has a particular tracker search scope, does it mean that we have to
use this scope every time a user tries to search for a tracker, Enrollment, or Event object? Or is
the user interested in limiting the searching just to the selected org unit, or the entire capture
org unit scope, and so on.

Users can do the fine-tuning by passing a specific value of `orgUnitMode` in their API request:

*api/tracker/trackedEntities?orgUnit=UID&orgUnitMode=specific_organisation_unit_selection_mode*

Currently, there are six selection modes available: *SELECTED, CHILDREN, DESCENDANTS, CAPTURE,
ACCESSIBLE, and ALL*.

1. **SELECTED**: As the name implies, this mode narrows down all operations initiated by the
   requesting API to the specified organisation unit in the request.
2. **CHILDREN**: Under this mode, the organisation unit scope is constructed using the selected
   organisation unit and its immediate children, i.e., the organisation units at the level below.
3. **DESCENDANTS**: In this mode, the selected organisation unit and everything underneath it,
   encompassing not only the immediate children but all descendants, constitute the data operation
universe.
4. **CAPTURE**: This mode includes the data capture organization units associated with the current
   user and all descendants. It encompasses all organization units in the sub-hierarchy.
5. **ACCESSIBLE**: This mode is designed to retrieve data within the user's search scope
   organization units. This encompasses everything visible to the user, including open and audited
programs within its search scope, as well as data in protected and closed programs within the user's
capture scope. If a user lacks search organization units, the system defaults to capture scope,
ensuring that the user always has access to at least one universe. The capture scope, being
mandatory, serves as a foundational element in guaranteeing a data environment for the user.
6. **ALL**: This mode is reserved for authorized users, specifically those with the authority ALL
   (super users). Users with the authority F_TRACKED_ENTITY_INSTANCE_SEARCH_IN_ALL_ORGUNITS can also
search system-wide but need sharing access to the returned program, program stage, and/or tracked
entity type. For non-authorized users, an exception will be raised.

The first three modes, *SELECTED*, *CHILDREN* and *DESCENDANTS* expect an organisation unit to be
supplied in the request, while the last three, *CAPTURE*, *ACCESSIBLE* and *ALL* do not expect it
and in fact the request will fail if an organisation unit is provided.

The organisation unit mode will be one of the ones listed above when it's explicitly provided in the
API request. Since it's not a mandatory field, in case it's not specified, then the default value
will be *SELECTED* if an organisation unit is present, and *ACCESSIBLE* otherwise.

It makes little sense to pass these modes at the time of tracker import operations. Because when
writing tracker data, each of the objects needs to have a specific organisation unit attached to
them. The system will then ensure if each of the mentioned organisation units falls under the
CAPTURE scope. If not, the system will simply reject the write operation.

Note that there is 4 type of organisation unit associations relevant for Tracker objects. A
TrackedEntity has an organisation unit, commonly referred to as the Registration Organisation unit.
Enrollments have an organisation unit associated with them. Events also have an organisation unit
associated with them. There is also an Owner organisation unit for a TrackedEntity-Program
combination.

When fetching Tracker objects, depending on the context, the organisation unit scope is applied to
one of the above four organisation unit associations.

For example, when retrieving TrackedEntities without the context of a program, the organisation unit
scope is applied to the registration organisation unit of the TrackedEntity. Whereas, when
retrieving TrackedEntities, including specific program data, the organisation unit scope is applied
to the Owner organisation unit.

### Tracker Program Ownership { #webapi_nti_ownership }

A new concept called Tracker Ownership is introduced from 2.30. This introduces a new organisation
unit association for a TrackedEntity - Program combination. We call this the Owner (or Owning)
Organisation unit of a TrackedEntity in the context of a Program. The Owner organisation unit is
used to decide access privileges when reading and writing tracker data related to a program. This,
along with the Program's [Access Level](#webapi_nti_access_level) configuration, decides the access
behavior for Program-related data (Enrollments and Events). A user can access a TrackedEntity's
Program data if the corresponding Owner OrganisationUnit for that TrackedEntity-Program combination
falls under the user's organisation unit scope (Search/Capture). For Programs that are configured
with access level  *OPEN* or *AUDITED* , the Owner OrganisationUnit has to be in the user's search
scope. For Programs that are configured with access level  *PROTECTED* or *CLOSED* , the Owner
OrganisationUnit has to be in the user's capture scope to be able to access the corresponding
program data for the specific tracked entity. Irrespective of the program access level, to access
Tracker objects, the requested organisation unit must always be within the user's search scope. A
user cannot request objects outside its search scope unless it's using the organisation unit mode
ALL and has enough privileges to use that mode.

When requesting tracked entities without specifying a program, the response will include only tracked entities that satisfy [metadata sharing settings](#webapi_tracker_metadata_sharing) and one of the following criteria:
- The tracked entity is enrolled in at least one program the user has data access to, and the user has access to the owner organisation unit.
- The tracked entity is not enrolled in any program the user has data access to, but the user has access to the tracked entity registering organisation unit.

#### Tracker Ownership Override: Break the Glass { #webapi_tracker_ownership_override }

It is possible to temporarily override the ownership privilege for a program that is configured
with an access level of *PROTECTED*. Any user with the org unit owner within their search scope, can
temporarily access the program-related data by providing a reason for accessing it.

This act of temporarily gaining access is termed *breaking the glass*.
Currently, temporary access is granted for 3 hours. DHIS2 audits breaking the glass along with the
reason specified by the user. It is not possible to gain temporary access to a program that has been
configured with an access level of *CLOSED*.

To break the glass for a TrackedEntity-Program combination, the following POST request can be used:

    /api/tracker/ownership/override?trackedEntity=DiszpKrYNg8&program=eBAyeGv0exc&reason=patient+showed+up+for+emergency+care

#### Tracker Ownership Transfer { #webapi_nti_tracker_ownership_transfer }

It is possible to transfer the ownership of a TrackedEntity-Program from one organisation unit to
another. This will be useful in case of patient referrals or migrations. Only a user who has
Ownership access (or temporary access by breaking the glass) can transfer the ownership. To transfer
ownership of a TrackedEntity-Program to another organisation unit, the following PUT request can be
used:

    /api/tracker/ownership/transfer?trackedEntity=DiszpKrYNg8&program=eBAyeGv0exc&ou=EJNxP3WreNP

### Access Level { #webapi_nti_access_level }

DHIS2 treats Tracker data with an extra level of protection. In addition to the standard feature of
metadata and data protection through sharing settings, Tracker data are shielded with additional
access level protection mechanisms.  Currently, there are four access levels that can be configured
for a Program: Open, Audited, Protected, and Closed.

These access levels are only triggered when users try to interact with program data, namely
Enrollments and Events data. The different Access Level configuration for Program is a degree of
openness (or closedness) of program data. Note that all other sharing settings are still respected,
and the access level is only an additional layer of access control. Here is a short description of
the four access levels that can be configured for a Program.

#### Open

This access level is the least restricted among the access levels. Data inside an OPEN program can
be accessed and modified by users if the Owner organisation unit falls under the user's search
scope.  With this access level, accessing and modifying data outside the capture scope is possible
without any justification or consequence.

#### Audited

This is the same as the Open access level. The difference here is that the system will automatically
add an audit log entry on the data being accessed by the specific user.

#### Protected

This access level is slightly more restricted. Data inside a PROTECTED program can only be accessed
by users if the Owner organisation unit falls under the user's capture scope. However, a user who
only has the Owner organisation unit in the search scope can gain temporary ownership by [breaking
the glass](#webapi_nti_tracker_ownership_override). The user has to provide a justification of why
they are accessing the data at hand. The system will then put a log of both the justification and
access audit and provide temporary access for 3 hours to the user. Note that when breaking the
glass, the Owner Organisation Unit remains unchanged, and only the user who has broken the glass
gains temporary access.

#### Closed

This is the most restricted access level. Data recorded under programs configured with access level
CLOSED will not be accessible if the Owner Organisation Unit does not fall within the user's capture
scope. It is also not possible to break the glass or gain temporary ownership in this configuration.
Note that it is still possible to transfer the ownership to another organisation unit. Only a user
who has access to the data can transfer the ownership of a TrackedEntity-Program combination to
another Organisation Unit. If ownership is transferred, the Owner Organisation Unit is updated.

