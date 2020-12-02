# Tracker data

## Tracker data models

### Tracked Entities

The following is a complete model of a tracked entity:

```
{
    "trackedEntity": "<uid>",
    "trackedEntityType": "<uid>",
    "createdAt": "01-01-2020",
    "updatedAt": "01-01-2020",
    "orgUnit": "<uid>",
    "inactive": false,
    "deleted": false,
    "geometry": {
        "type": "POINT",
        "coordinates": [123.0, 123.0]
    },
    "storedBy": "Admin",
    "attributes": [],
    "enrollments": [],
    "relationships": [],
    "programOwners": [
        {
            "orgUnit": "<uid>",
            "trackedEntity": "<uid>",
            "program": "<uid>"
        }
    ]
}
```

Each property is further described in the following table: __ table __


### Enrollments

The following is a complete model of an enrollment:

```
{
    "enrollment": "<uid>",
    "trackedEntity": "<uid>",
    "trackedEntityType": "<uid>",
    "program": "<uid>",
    "createdAt": "01-01-2020",
    "updatedAt": "01-01-2020",
    "orgUnit": "<uid>",
    "status": "ACTIVE",
    "enrolledAt": "01-01-2020',
    "occurredAt": "01-01-2020',
    "followUp": false,
    "completedBy": "Admin",
    "completedAt": "01-01-2020",
    "deleted": false,
    "geometry": {
        "type": "POINT",
        "coordinates": [123.0, 123.0]
    },
    "storedBy": "Admin",
    "attributes": [],
    "events": [],
    "relationships": [],
    "notes": [
        {
            "note": "<uid>",
            "storedAt": "01-01-2020",
            "storedBy": "Admin",
            "value": "Content of note"
        }
    ]
}
```

Each property is further described in the following table: __ table __
### Events 

The following is a complete model of an event:

```
{
    "event": "<uid>",
    "program": "<uid>",
    "programStage": "<uid>",
    "enrollment": "<uid>",
    "enrollmentStatus": "ACTIVE",
    "trackedEntity": "<uid>",
    "createdAt": "01-01-2020",
    "updatedAt": "01-01-2020",
    "orgUnit": "<uid>",
    "status": "ACTIVE",
    "scheduledAt": "01-01-2020',
    "occurredAt": "01-01-2020',
    "followUp": false,
    "completedBy": "Admin",
    "completedAt": "01-01-2020",
    "attributeOptionCombo": "<uid>",
    "attributeCategoryOptions": "<uid>",
    "deleted": false,
    "geometry": {
        "type": "POINT",
        "coordinates": [123.0, 123.0]
    },
    "assignedUser": "<uid>",
    "storedBy": "Admin",
    "dataValues": [],
    "relationships": [],
    "notes": [
        {
            "note": "<uid>",
            "storedAt": "01-01-2020",
            "storedBy": "Admin",
            "value": "Content of note"
        }
    ]
}
```

Each property is further described in the following table: __ table __

### Relationships

The following is a complete model of a relationship:

```
{
    "relationship": "<uid>",
    "relationshipType": "<uid>",
    "createdAt": "01-01-2020",
    "updatedAt": "01-01-2020",
    "bidirectional": false,
    "from": {
        "trackedEntity": "<uid>"
        OR
        "enrollment": "<uid>"
        OR
        "event": "<uid>"
    },
    "to": {
        "trackedEntity": "<uid>"
        OR
        "enrollment": "<uid>"
        OR
        "event": "<uid>"
    }
}
```

Each property is further described in the following table: __ table __


### Attribute Values

The following is a complete model of a attribute:

```
{
    "attribute": "<uid>",
    "code": "<uid>",
    "createdAt": "01-01-2020",
    "updatedAt": "01-01-2020",
    "storedBy": "Admin",
    "valueType": "TEXT",
    "value": "Hello world!"
}
```

Each property is further described in the following table: __ table __

### Data Values


The following is a complete model of a attribute:

```
{
    "dataElement": "<uid>",
    "createdAt": "01-01-2020",
    "updatedAt": "01-01-2020",
    "storedBy": "Admin",
    "providedElsewhere": false,
    "value": "Hello world!"
}
```

Each property is further described in the following table: __ table __

## Tracker data import
The tracker data import endpoints support creating, updatering and deletng tracker data. The api accepts both `JSON` and `CSV` formats.


**Parameters**
All requests supports the following table of parameters (If applicable):

importMode
identifiers
importStrategy
atomicMode
flushMode
validationMode
skipPatternValidation
skipSideEffects
skipRuleEngine
filename
sync

(Fill out later)

**Async vs sync requests**
Requests to import data are primarily handled async. After sending a request, the client will receive a response with a reference to the backend process that was started, which can be used to follow the progress of the import and after completion, the import summary. 

An example response for the async request:

```
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "message": "Tracker job added",
  "response": {
    "responseType": "TrackerJob",
    "id": "<uid>",
    "location": "https://play.dhis2.org/dev/api/tracker/jobs/<uid>"
  }
}
``` 

If the client requires the request to be synchronous, they can set the `sync` parameter to `true`. Synchronous request will respond with the import summary directly. More information about the process log and import summary can be found in a following section.

**Payload structure**
The tracker data import endpoints support two types of payloads: flat and nested. The basic structure is for both as follows:

```
{
    "trackedEntity": [],
    "enrollments": [],
    "events": [],
    "relationships": []
}
```

The primary difference is how the client chooses to structure the objects sent in. For example, if a client wants to add a new trackedEntity, with a new enrollment, all in one request, the client either needs to generate uids for the trackedEntity and enrollment, or nest the objects together. Both examples can be found below:

```
Flat:
{
    "trackedEntities": [
        {
            "trackedEntity": "<generated uid>",
            "trackedEntityType": "<uid>",
            <other properties>
        }
    ],
    "enrollments": [
        {
            "enrollment": "<generated uid>",
            "trackedEntity": "<same uid as tracked entity>",
            "program": "<uid>",
            <other properties>
        }
    ]
}

Nested:
{
    "trackedEntities": [
        {
            "enrollments": [
                {
                    <other properties>
                }
            ],
            <other properties>
        }
    ]
}
``` 

*When using the nested structure, enclosed objects will inherit references from their parent object. For example, the enclosed enrollment will have it's "trackedEntity" property set to the uid of the parent trackedEntity*

### New and updated data
When you want to push new or updated data to the api, there are 3 options: `POST`, `PUT` and `PATCH`.


#### POST
``` POST /api/tracker ``` 

`POST` will accept both new and updated data in the same request. In the case of updated data, the update will be equvivalent to a PUT request, meaning we replace the entire model.

An example payload sending in a new tracked entity (No "trackedEntity" property) and an updated tracked entity, in the same payload.

```
    {
        "trackedEntities": [
            {
                "trackedEntityType": "<uid>",
                "orgUnit": "<uid>",
                "attributes": [
                    {
                        "attribute": "<uid>",
                        "value": "value"
                    }
                ]
            },
            {
                "trackedEntity": "<uid>",
                "attributes": [
                    {
                        "attribute": "<uid>",
                        "value": "new value"
                    }
                ]
            }
        ]
    }
```

Without the uid reference in the updated tracked entity (The property "trackedEntity"), the data would be treated as a new tracked entity.

#### PUT

``` PUT /api/tracker ```

`PUT` will only accept updates to existing data. This mean validation will fail if new data is included in the request. When using PUT, the objects in the payload will replace the objects previously persisted. For more information about which properties can be replaced and not, see the previous section about the tracker data models.

The following example shows how to update a tracked entity and 2 enrollment in the same payload.

```
    {
        "trackedEntities": [
            {
                "trackedEntity": "<uid>",
                "trackedEntityType": "<uid>",
                "orgUnit": "<uid>",
                "attributes": [
                    {
                        "attribute": "<uid>",
                        "value": "value"
                    }
                ],
                "enrollments": [
                    {
                        "enrollment": "<uid>",
                        "program": "<uid>",
                        "orgUnit": "<uid>",
                        "attributes": [
                            {
                                "attribute": "<uid>",
                                "value": "new value"
                            }
                        ]
                    }
                ]

            }
        ],
        "enrollments": [
            {
                "enrollment": "<uid>",
                "program": "<uid>",
                "orgUnit": "<uid>",
                "attributes": [
                    {
                        "attribute": "<uid>",
                        "value": "new value"
                    }
                ]
            }
        ]
    }
```
Make a note of how both the tracked entity and enrollment at the root level of the payload has their respective uids set ("trackedEntity" and "enrollment" for the tracked entity and enrollment respectively). This is so we know which objects we are updating. Without these uids, they would be recognised as new data, and validation would fail for this request. Also note that we include several properties we don't intend to change, like orgUnit, since we are replacing the previous object.

#### PATCH

``` PATCH /api/tracker ```

The `PATCH` endpoint, similar to the `PUT` endpoint, only accepts updates to existing objects. However, while the `PUT` endpoint will replace the entire object, `PATCH` will only replace the properties included in the payload.

The following example shows how we can update only the geometry of a tracked entity using the `PATCH` endpoint:

```
    {
        "trackedEntities": [
            {
                "trackedEntity": "<uid>",
                "geometry": {
                    "type": "POINT",
                    "coordinates": [123.0, 123.0]
                }
            }
        ]
    }
```

Again, note that we do include the uid of the object, "trackedEntity", so we can identify which object to update - However, we only include "geometry" since it's the only property we want to update, and all other properties will remain as they are.

#### DELETE

```DELETE /api/tracker```

Tracker data can be removed to *soft deleting* them. We can do this using the `DELETE` endpoint. The `DELETE` endpoint accepts the same payload structure as the other endspoints, however they only require the uids of each object.

The following example shows how we can delete a tracked entity, an enrollment and an event in the same request:

```
    {
        "trackedEntities": [
            {
                "trackedEntity": "<uid>"
        ],
        "enrollments": [
            {
                "enrollment": "<uid>"
            }
        ],
        "events": [
            {
                "event": "<uid>"
            }
        ],
        "relationship": [
            {
                "relationship": "<uid>"
            }
        ]
    }
```

Note that each object has a uid reference. An unknown or invalid uid reference will result in a validation error, as we only expect existing objects to be present in a DELETE request.

### Import logs and summary

### Special tracker data updates
- Complete
- Assign
- Geometry?
- etc.

## Tracker data export

