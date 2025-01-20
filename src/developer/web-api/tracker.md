# Tracker

> **Note**
>Tracker has been re-implemented in [New Tracker - DHIS2 Documentation](https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-master/new-tracker.html).
>
>This version of the endpoints is in maintenance mode and does not receive any
>new features. Important bugs on the endpoints will still be fixed.
>
>* If you are using the tracker endpoints in your implementation, it is
>  advisable to use the new version at [New Tracker - DHIS2 Documentation](https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-master/new-tracker.html)
>* If you already use the tracker endpoints in production, please plan to
>  migrate over to the new version. Reach out on the [community of practice](https://community.dhis2.org)
>  if you need any assistance. NOTE: The feature for data sync(importMode=SYNC)
>  is not implemented in the new tracker endpoints, and if you are using this
>  feature you will have to postpone the migration until a new SYNC feature is
>  in place.

## Tracker Web API { #webapi_tracker_api }

Tracker Web API consists of 3 endpoints that have full CRUD (create,
read, update, delete) support. The 3 endpoints are
`/api/trackedEntityInstances`, `/api/enrollments` and
`/api/events` and they are responsible for tracked entity instance,
enrollment and event items.

### Tracked entity instance management { #webapi_tracked_entity_instance_management }

Tracked entity instances have full CRUD support in the API. Together
with the API for enrollment most operations needed for working with
tracked entity instances and programs are supported.

    /api/33/trackedEntityInstances

#### Creating a new tracked entity instance { #webapi_creating_tei }

For creating a new person in the system, you will be working with the
*trackedEntityInstances* resource. A template payload can be seen below:

```json
{
  "trackedEntity": "tracked-entity-id",
  "orgUnit": "org-unit-id",
  "geometry": "<Geo JSON>",
  "attributes": [{
    "attribute": "attribute-id",
    "value": "attribute-value"
  }]
}
```

The field "geometry" accepts a GeoJson object, where the type of the
GeoJson have to match the featureType of the TrackedEntityType
definition. An example GeoJson object looks like this:

```json
{
  "type": "Point",
  "coordinates": [1, 1]
}
```

The "coordinates" field was introduced in 2.29, and accepts a coordinate
or a polygon as a value.

For getting the IDs for `relationship` and `attributes` you can have a look
at the respective resources `relationshipTypes`, `trackedEntityAttributes`.
To create a tracked entity instance you must use the HTTP *POST* method.
You can post the payload the following URL:

    /api/trackedEntityInstances

For example, let us create a new instance of a person tracked entity and
specify its first name and last name attributes:

```json
{
  "trackedEntity": "nEenWmSyUEp",
  "orgUnit": "DiszpKrYNg8",
  "attributes": [
    {
      "attribute": "w75KJ2mc4zz",
      "value": "Joe"
    },
    {
      "attribute": "zDhUuAYrxNC",
      "value": "Smith"
    }
  ]
}
```

To push this to the server you can use the cURL command like this:

```bash
curl -d @tei.json "https://play.dhis2.org/demo/api/trackedEntityInstances" -X POST
  -H "Content-Type: application/json" -u admin:district
```

To create multiple instances in one request you can wrap the payload in
an outer array like this and POST to the same resource as above:[]()

```json
{
  "trackedEntityInstances": [
    {
      "trackedEntity": "nEenWmSyUEp",
      "orgUnit": "DiszpKrYNg8",
      "attributes": [
        {
          "attribute": "w75KJ2mc4zz",
          "value": "Joe"
        },
        {
          "attribute": "zDhUuAYrxNC",
          "value": "Smith"
        }
      ]
    },
    {
      "trackedEntity": "nEenWmSyUEp",
      "orgUnit": "DiszpKrYNg8",
      "attributes": [
        {
          "attribute": "w75KJ2mc4zz",
          "value": "Jennifer"
        },
        {
          "attribute": "zDhUuAYrxNC",
          "value": "Johnson"
        }
      ]
    }
  ]
}
```

The system does not allow the creation of a tracked entity instance
(as well as enrollment and event) with a UID that was already used in
the system. That means that UIDs cannot be reused.

#### Updating a tracked entity instance { #webapi_updating_tei }

For updating a tracked entity instance, the payload is equal to the
previous section. The difference is that you must use the HTTP *PUT*
method for the request when sending the payload. You will also need to
append the person identifier to the *trackedEntityInstances* resource in
the URL like this, where `<tracked-entity-instance-identifier>` should
be replaced by the identifier of the tracked entity instance:

    /api/trackedEntityInstances/<tracked-entity-instance-id>

The payload has to contain all, even non-modified, attributes and
relationships. Attributes or relationships that were present before and
are not present in the current payload any more will be removed from the
system. This means that if attributes/relationships are empty in the
current payload, all existing attributes/relationships will be deleted
from the system. From 2.31, it is possible to ignore empty
attributes/relationships in the current payload. A request parameter of
`ignoreEmptyCollection` set to `true` can be used in case you do not
wish to send in any attributes/relationships and also do not want them
to be deleted from the system.

It is not allowed to update an already deleted tracked entity instance.
Also, it is not allowed to mark a tracked entity instance as deleted via
an update request. The same rules apply to enrollments and events.

#### Deleting a tracked entity instance { #webapi_deleting_tei }

In order to delete a tracked entity instance, make a request to the URL
identifying the tracked entity instance with the *DELETE*
method. The URL is equal to the one above used for update.

#### Create and enroll tracked entity instances { #webapi_create_enroll_tei }

It is also possible to both create (and update) a tracked entity
instance and at the same time enroll into a program.

```json
{
  "trackedEntity": "tracked-entity-id",
  "orgUnit": "org-unit-id",
  "attributes": [{
    "attribute": "attribute-id",
    "value": "attribute-value"
  }],
  "enrollments": [{
    "orgUnit": "org-unit-id",
    "program": "program-id",
    "enrollmentDate": "2013-09-17",
    "incidentDate": "2013-09-17"
   }, {
    "orgUnit": "org-unit-id",
    "program": "program-id",
    "enrollmentDate": "2013-09-17",
    "incidentDate": "2013-09-17"
   }]
}
```

You would send this to the server as you would normally when creating or
updating a new tracked entity instance.

```bash
curl -X POST -d @tei.json -H "Content-Type: application/json"
  -u user:pass "http://server/api/33/trackedEntityInstances"
```

#### Complete example of payload including: tracked entity instance, enrollment and event { #webapi_create_enroll_tei_create_event }

It is also possible to create (and update) a tracked entity instance, at
the same time enroll into a program and create an event.

```json
{
  "trackedEntityType": "nEenWmSyUEp",
  "orgUnit": "DiszpKrYNg8",
  "attributes": [
    {
      "attribute": "w75KJ2mc4zz",
      "value": "Joe"
    },
    {
      "attribute": "zDhUuAYrxNC",
      "value": "Rufus"
    },
    {
     "attribute":"cejWyOfXge6",
     "value":"Male"
    }
  ],
  "enrollments":[
    {
      "orgUnit":"DiszpKrYNg8",
      "program":"ur1Edk5Oe2n",
      "enrollmentDate":"2017-09-15",
      "incidentDate":"2017-09-15",
      "events":[
        {
          "program":"ur1Edk5Oe2n",
          "orgUnit":"DiszpKrYNg8",
          "eventDate":"2017-10-17",
          "status":"COMPLETED",
          "storedBy":"admin",
          "programStage":"EPEcjy3FWmI",
          "coordinate": {
            "latitude":"59.8",
            "longitude":"10.9"
          },
          "dataValues": [
            {
              "dataElement":"qrur9Dvnyt5",
              "value":"22"
            },
            {
              "dataElement":"oZg33kd9taw",
              "value":"Male"
            }
         ]
      },
      {
         "program":"ur1Edk5Oe2n",
         "orgUnit":"DiszpKrYNg8",
         "eventDate":"2017-10-17",
         "status":"COMPLETED",
         "storedBy":"admin",
         "programStage":"EPEcjy3FWmI",
         "coordinate": {
           "latitude":"59.8",
           "longitude":"10.9"
         },
         "dataValues":[
           {
             "dataElement":"qrur9Dvnyt5",
             "value":"26"
           },
           {
             "dataElement":"oZg33kd9taw",
             "value":"Female"
           }
         ]
       }
     ]
    }
  ]  
}
```

You would send this to the server as you would normally when creating or
updating a new tracked entity instance.

```bash
curl -X POST -d @tei.json -H "Content-Type: application/json"
  -u user:pass "http://server/api/33/trackedEntityInstances"
```

#### Generated tracked entity instance attributes { #webapi_generate_tei_attributes }

Tracked entity instance attributes that are using automatic generation of
unique values have three endpoints that are used by apps. The endpoints
are all used for generating and reserving values.

In 2.29 we introduced TextPattern for defining and generating these
patterns. All existing patterns will be converted to a valid TextPattern
when upgrading to 2.29.

> **Note**
>
> As of 2.29, all these endpoints will require you to include any
> variables reported by the `requiredValues` endpoint listed as
> required. Existing patterns, consisting of only `#`, will be upgraded
> to the new TextPattern syntax `RANDOM(<old-pattern>)`. The RANDOM
> segment of the TextPattern is not a required variable, so this
> endpoint will work as before for patterns defined before 2.29.

##### Finding required values

A TextPattern can contain variables that change based on different
factors. Some of these factors will be unknown to the server, so the
values for these variables have to be supplied when generating and
reserving values.

This endpoint will return a map of required and optional values, that
the server will inject into the TextPattern when generating new values.
Required variables have to be supplied for the generation, but optional
variables should only be supplied if you know what you are doing.

    GET /api/33/trackedEntityAttributes/Gs1ICEQTPlG/requiredValues

```json
{
  "REQUIRED": [
    "ORG_UNIT_CODE"
  ],
  "OPTIONAL": [
    "RANDOM"
  ]
}
```

##### Generate value endpoint { #webapi_generate_values }

Online web apps and other clients that want to generate a value that
will be used right away can use the simple generate endpoint. This
endpoint will generate a value that is guaranteed to be unique at the
time of generation. The value is also guaranteed not to be reserved. As
of 2.29, this endpoint will also reserve the value generated for 3 days.

If your TextPattern includes required values, you can pass them as
parameters like the example below:

The expiration time can also be overridden at the time of generation, by
adding the `?expiration=<number-of-days>` to the request.

    GET /api/33/trackedEntityAttributes/Gs1ICEQTPlG/generate?ORG_UNIT_CODE=OSLO

```json
{
  "ownerObject": "TRACKEDENTITYATTRIBUTE",
  "ownerUid": "Gs1ICEQTPlG",
  "key": "RANDOM(X)-OSL",
  "value": "C-OSL",
  "created": "2018-03-02T12:01:36.680",
  "expiryDate": "2018-03-05T12:01:36.678"
}
```

##### Generate and reserve value endpoint { #webapi_generate_reserve_values }

The generate and reserve endpoint is used by offline clients that need
to be able to register tracked entities with unique ids. They will
reserve a number of unique ids that this device will then use when
registering new tracked entity instances. The endpoint is called to
retrieve a number of tracked entity instance reserved values. An
optional parameter numberToReserve specifies how many ids to generate
(default is 1).

If your TextPattern includes required values, you can pass them as
parameters like the example below:

Similar to the /generate endpoint, this endpoint can also specify the
expiration time in the same way. By adding the `?expiration=<number-of-days>`
you can override the default 60 days.

    GET /api/33/trackedEntityAttributes/Gs1ICEQTPlG/generateAndReserve?numberToReserve=3&ORG_UNIT_CODE=OSLO

```json
[
  {
    "ownerObject": "TRACKEDENTITYATTRIBUTE",
    "ownerUid": "Gs1ICEQTPlG",
    "key": "RANDOM(X)-OSL",
    "value": "B-OSL",
    "created": "2018-03-02T13:22:35.175",
    "expiryDate": "2018-05-01T13:22:35.174"
  },
  {
    "ownerObject": "TRACKEDENTITYATTRIBUTE",
    "ownerUid": "Gs1ICEQTPlG",
    "key": "RANDOM(X)-OSL",
    "value": "Q-OSL",
    "created": "2018-03-02T13:22:35.175",
    "expiryDate": "2018-05-01T13:22:35.174"
  },
  {
    "ownerObject": "TRACKEDENTITYATTRIBUTE",
    "ownerUid": "Gs1ICEQTPlG",
    "key": "RANDOM(X)-OSL",
    "value": "S-OSL",
    "created": "2018-03-02T13:22:35.175",
    "expiryDate": "2018-05-01T13:22:35.174"
  }
]
```

##### Reserved values

Reserved values are currently not accessible through the api, however, they
are returned by the `generate` and `generateAndReserve` endpoints. The
following table explains the properties of the reserved value object:

#####



Table: Reserved values

| Property | Description |
|---|---|
| ownerObject | The metadata type referenced when generating and reserving the value. Currently only TRACKEDENTITYATTRIBUTE is supported. |
| ownerUid | The uid of the metadata object referenced when generating and reserving the value. |
| key | A partially generated value where generated segments are not yet added. |
| value | The fully resolved value reserved. This is the value you send to the server when storing data. |
| created | The timestamp when the reservation was made |
| expiryDate | The timestamp when the reservation will no longer be reserved |

Expired reservations are removed daily. If a pattern changes, values
that were already reserved will be accepted when storing data, even if
they don't match the new pattern, as long as the reservation has not
expired.

#### Image attributes

Working with image attributes is a lot like working with file data
values. The value of an attribute with the image value type is the id of
the associated file resource. A GET request to the
`/api/trackedEntityInstances/<entityId>/<attributeId>/image`
endpoint will return the actual image. The optional height and width
parameters can be used to specify the dimensions of the image.

```bash
curl "http://server/api/33/trackedEntityInstances/ZRyCnJ1qUXS/zDhUuAYrxNC/image?height=200&width=200"
  > image.jpg
```

The API also supports a *dimension* parameter. It can take three possible values (please note capital letters): `SMALL` (254x254), `MEDIUM` (512x512), `LARGE` (1024x1024) or `ORIGINAL`. Image type attributes will be stored in pre-generated sizes
and will be furnished upon request based on the value of the `dimension` parameter.

```bash
curl "http://server/api/33/trackedEntityInstances/ZRyCnJ1qUXS/zDhUuAYrxNC/image?dimension=MEDIUM"
```

#### File attributes

Working with file attributes is a lot like working with image data
values. The value of an attribute with the file value type is the id of
the associated file resource. A GET request to the
`/api/trackedEntityInstances/<entityId>/<attributeId>/file`
endpoint will return the actual file content.

```bash
curl "http://server/api/trackedEntityInstances/ZRyCnJ1qUXS/zDhUuAYrxNC/file
```

#### Tracked entity instance query { #webapi_tracked_entity_instance_query }

To query for tracked entity instances you can interact with the
`/api/trackedEntityInstances` resource.

    /api/33/trackedEntityInstances

##### Request syntax { #webapi_tei_query_request_syntax }



Table: Tracked entity instances query parameters

| Query parameter | Description |
|---|---|
| filter | Attributes to use as a filter for the query. Param can be repeated any number of times. Filters can be applied to a dimension on the format <attribute-id\>:<operator\>:<filter\>[:<operator\>:<filter\>]. Filter values are case-insensitive and can be repeated together with operator any number of times. Operators can be EQ &#124; GT &#124; GE &#124; LT &#124; LE &#124; NE &#124; LIKE &#124; IN. |
| ou | Organisation unit identifiers, separated by ";". |
| ouMode | The mode of selecting organisation units, can be SELECTED &#124; CHILDREN &#124; DESCENDANTS &#124; ACCESSIBLE &#124; CAPTURE &#124; ALL. Default is SELECTED, which refers to the selected selected organisation units only. See table below for explanations. |
| program | Program identifier. Restricts instances to being enrolled in the given program. |
| programStatus | Status of the instance for the given program. Can be ACTIVE &#124; COMPLETED &#124; CANCELLED. |
| followUp | Follow up status of the instance for the given program. Can be true &#124; false or omitted. |
| programStartDate | Start date of enrollment in the given program for the tracked entity instance. |
| programEndDate | End date of enrollment in the given program for the tracked entity instance. |
| trackedEntity | Tracked entity identifier. Restricts instances to the given tracked instance type. |
| page | The page number. Default page is 1. |
| pageSize | The page size. Default size is 50 rows per page. |
| totalPages | Indicates whether to include the total number of pages in the paging response (implies higher response time). |
| skipPaging | Indicates whether paging should be ignored and all rows should be returned. |
| lastUpdatedStartDate | Filter for teis which were updated after this date. Cannot be used together with *lastUpdatedDuration*. |
| lastUpdatedEndDate | Filter for teis which were updated up until this date. Cannot be used together with *lastUpdatedDuration*. |
| lastUpdatedDuration | Include only items which are updated within the given duration. The format is , where the supported time units are “d” (days), “h” (hours), “m” (minutes) and “s” (seconds). Cannot be used together with *lastUpdatedStartDate* and/or *lastUpdatedEndDate*. |
| assignedUserMode | Restricts result to tei with events assigned based on the assigned user selection mode, can be CURRENT &#124; PROVIDED &#124; NONE &#124; ANY. See table below "Assigned user modes" for explanations. |
| assignedUser | Filter the result down to a limited set of teis with events that are assigned to the given user IDs by using *assignedUser=id1;id2*.This parameter will be considered only if assignedUserMode is either PROVIDED or null. The API will error out, if for example, assignedUserMode=CURRENT and assignedUser=someId |
| trackedEntityInstance | Filter the result down to a limited set of teis using explicit uids of the tracked entity instances by using *trackedEntityInstance=id1;id2*. This parameter will at the very least create the outer boundary of the results, forming the list of all teis using the uids provided. If other parameters/filters from this table are used, they will further limit the results from the explicit outer boundary. |
| includeDeleted | Indicates whether to include soft deleted teis or not. It is false by default. |
| potentialDuplicate | Filter the result based on the fact that a TEI is a Potential Duplicate. true: return TEIs flagged as Potential Duplicates. false: return TEIs NOT flagged as Potential Duplicates. If omitted, we don't check whether a TEI is a Potential Duplicate or not.|

The available organisation unit selection modes are explained in the
following table.



Table: Organisation unit selection modes

| Mode | Description |
|---|---|
| SELECTED | Organisation units defined in the request. |
| CHILDREN | The selected organisation units and the immediate children, i.e. the organisation units at the level below. |
| DESCENDANTS | The selected organisation units and all children, i.e. all organisation units in the sub-hierarchy. |
| ACCESSIBLE | The data view organisation units associated with the current user and all children, i.e. all organisation units in the sub-hierarchy. Will fall back to data capture organisation units associated with the current user if the former is not defined. |
| CAPTURE | The data capture organisation units associated with the current user and all children, i.e. all organisation units in the sub-hierarchy. |
| ALL | All organisation units in the system. Requires the ALL authority. |

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

  - At least one organisation unit must be specified using the *ou*
    parameter (one or many), or *ouMode=ALL* must be specified.

  - Only one of the *program* and *trackedEntity* parameters can be
    specified (zero or one).

  - If *programStatus* is specified then *program* must also be
    specified.

  - If *followUp* is specified then *program* must also be specified.

  - If *programStartDate* or *programEndDate* is specified then
    *program* must also be specified.

  - Filter items can only be specified once.

A query for all instances associated with a specific organisation unit
can look like this:

    /api/33/trackedEntityInstances.json?ou=DiszpKrYNg8

To query for instances using one attribute with a filter and one
attribute without a filter, with one organisation unit using the
descendant organisation unit query mode:

    /api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A
      &filter=AMpUYgxuCaE&ou=DiszpKrYNg8;yMCshbaVExv

A query for instances where one attribute is included in the response
and one attribute is used as a filter:

    /api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A
      &filter=AMpUYgxuCaE:LIKE:Road&ou=DiszpKrYNg8

A query where multiple operand and filters are specified for a filter
item:

    api/33/trackedEntityInstances.json?ou=DiszpKrYNg8&program=ur1Edk5Oe2n
      &filter=lw1SqmMlnfh:GT:150:LT:190

To query on an attribute using multiple values in an *IN* filter:

    api/33/trackedEntityInstances.json?ou=DiszpKrYNg8
      &filter=dv3nChNSIxy:IN:Scott;Jimmy;Santiago

To constrain the response to instances which are part of a specific
program you can include a program query parameter:

    api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A&ou=O6uvpzGd5pu
      &ouMode=DESCENDANTS&program=ur1Edk5Oe2n

To specify program enrollment dates as part of the query:

    api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A&ou=O6uvpzGd5pu
      &program=ur1Edk5Oe2n&programStartDate=2013-01-01&programEndDate=2013-09-01

To constrain the response to instances of a specific tracked entity you
can include a tracked entity query parameter:

    api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A&ou=O6uvpzGd5pu
      &ouMode=DESCENDANTS&trackedEntity=cyl5vuJ5ETQ

By default the instances are returned in pages of size 50, to change
this you can use the page and pageSize query parameters:

    api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A&ou=O6uvpzGd5pu
      &ouMode=DESCENDANTS&page=2&pageSize=3

You can use a range of operators for the filtering:



Table: Filter operators

| Operator | Description |
|---|---|
| EQ | Equal to |
| GT | Greater than |
| GE | Greater than or equal to |
| LT | Less than |
| LE | Less than or equal to |
| NE | Not equal to |
| LIKE | Free text match (Contains) |
| SW | Starts with |
| EW | Ends with |
| IN | Equal to one of multiple values separated by ";" |

##### Response format { #webapi_tei_query_response_format }

This resource supports JSON, JSONP, XLS and CSV resource
representations.

  - json (application/json)

  - jsonp (application/javascript)

  - xml (application/xml)

The response in JSON/XML is in object format and can look like the
following. Please note that field filtering is supported, so if you want
a full view, you might want to add `fields=*` to the query:

```json
{
  "trackedEntityInstances": [
    {
      "lastUpdated": "2014-03-28 12:27:52.399",
      "trackedEntity": "cyl5vuJ5ETQ",
      "created": "2014-03-26 15:40:19.997",
      "orgUnit": "ueuQlqb8ccl",
      "trackedEntityInstance": "tphfdyIiVL6",
      "relationships": [],
      "attributes": [
        {
          "displayName": "Address",
          "attribute": "AMpUYgxuCaE",
          "type": "string",
          "value": "2033 Akasia St"
        },
        {
          "displayName": "TB number",
          "attribute": "ruQQnf6rswq",
          "type": "string",
          "value": "1Z 989 408 56 9356 521 9"
        },
        {
          "displayName": "Weight in kg",
          "attribute": "OvY4VVhSDeJ",
          "type": "number",
          "value": "68.1"
        },
        {
          "displayName": "Email",
          "attribute": "NDXw0cluzSw",
          "type": "string",
          "value": "LiyaEfrem@armyspy.com"
        },
        {
          "displayName": "Gender",
          "attribute": "cejWyOfXge6",
          "type": "optionSet",
          "value": "Female"
        },
        {
          "displayName": "Phone number",
          "attribute": "P2cwLGskgxn",
          "type": "phoneNumber",
          "value": "085 813 9447"
        },
        {
          "displayName": "First name",
          "attribute": "dv3nChNSIxy",
          "type": "string",
          "value": "Liya"
        },
        {
          "displayName": "Last name",
          "attribute": "hwlRTFIFSUq",
          "type": "string",
          "value": "Efrem"
        },
        {
          "code": "Height in cm",
          "displayName": "Height in cm",
          "attribute": "lw1SqmMlnfh",
          "type": "number",
          "value": "164"
        },
        {
          "code": "City",
          "displayName": "City",
          "attribute": "VUvgVao8Y5z",
          "type": "string",
          "value": "Kranskop"
        },
        {
          "code": "State",
          "displayName": "State",
          "attribute": "GUOBQt5K2WI",
          "type": "number",
          "value": "KwaZulu-Natal"
        },
        {
          "code": "Zip code",
          "displayName": "Zip code",
          "attribute": "n9nUvfpTsxQ",
          "type": "number",
          "value": "3282"
        },
        {
          "code": "National identifier",
          "displayName": "National identifier",
          "attribute": "AuPLng5hLbE",
          "type": "string",
          "value": "465700042"
        },
        {
          "code": "Blood type",
          "displayName": "Blood type",
          "attribute": "H9IlTX2X6SL",
          "type": "string",
          "value": "B-"
        },
        {
          "code": "Latitude",
          "displayName": "Latitude",
          "attribute": "Qo571yj6Zcn",
          "type": "string",
          "value": "-30.659626"
        },
        {
          "code": "Longitude",
          "displayName": "Longitude",
          "attribute": "RG7uGl4w5Jq",
          "type": "string",
          "value": "26.916172"
        }
      ]
    }
  ]
}
```

#### Tracked entity instance grid query { #webapi_tracked_entity_instance_grid_query }

To query for tracked entity instances you can interact with the
*/api/trackedEntityInstances/grid* resource. There are two types of
queries: One where a *query* query parameter and optionally *attribute*
parameters are defined, and one where *attribute* and *filter*
parameters are defined. This endpoint uses a more compact "grid" format,
and is an alternative to the query in the previous section.

    /api/33/trackedEntityInstances/query

##### Request syntax { #webapi_tei_grid_query_request_syntax }



Table: Tracked entity instances query parameters

| Query parameter | Description |
|---|---|
| query | Query string. Attribute query parameter can be used to define which attributes to include in the response. If no attributes but a program is defined, the attributes from the program will be used. If no program is defined, all attributes will be used. There are two formats. The first is a plan query string. The second is on the format <operator\>:<query\>. Operators can be EQ &#124; LIKE. EQ implies exact matches on words, LIKE implies partial matches on words. The query will be split on space, where each word will form a logical AND query. |
| attribute | Attributes to be included in the response. Can also be used as a filter for the query. Param can be repeated any number of times. Filters can be applied to a dimension on the format <attribute-id\>:<operator\>:<filter\>[:<operator\>:<filter\>]. Filter values are case-insensitive and can be repeated together with operator any number of times. Operators can be EQ &#124; GT &#124; GE &#124; LT &#124; LE &#124; NE &#124; LIKE &#124; IN. Filters can be omitted in order to simply include the attribute in the response without any constraints. |
| filter | Attributes to use as a filter for the query. Param can be repeated any number of times. Filters can be applied to a dimension on the format <attribute-id\>:<operator\>:<filter\>[:<operator\>:<filter\>]. Filter values are case-insensitive and can be repeated together with operator any number of times. Operators can be EQ &#124; GT &#124; GE &#124; LT &#124; LE &#124; NE &#124; LIKE &#124; IN. |
| ou | Organisation unit identifiers, separated by ";". |
| ouMode | The mode of selecting organisation units, can be SELECTED &#124; CHILDREN &#124; DESCENDANTS &#124; ACCESSIBLE &#124; ALL. Default is SELECTED, which refers to the selected organisation units only. See table below for explanations. |
| program | Program identifier. Restricts instances to being enrolled in the given program. |
| programStatus | Status of the instance for the given program. Can be ACTIVE &#124; COMPLETED &#124; CANCELLED. |
| followUp | Follow up status of the instance for the given program. Can be true &#124; false or omitted. |
| programStartDate | Start date of enrollment in the given program for the tracked entity instance. |
| programEndDate | End date of enrollment in the given program for the tracked entity instance. |
| trackedEntity | Tracked entity identifier. Restricts instances to the given tracked instance type. |
| eventStatus | Status of any event associated with the given program and the tracked entity instance. Can be ACTIVE &#124; COMPLETED &#124; VISITED &#124; SCHEDULE &#124; OVERDUE &#124; SKIPPED. |
| eventStartDate | Start date of event associated with the given program and event status. |
| eventEndDate | End date of event associated with the given program and event status. |
| programStage | The programStage for which the event related filters should be applied to. If not provided all stages will be considered. |
| skipMeta | Indicates whether meta data for the response should be included. |
| page | The page number. Default page is 1. |
| pageSize | The page size. Default size is 50 rows per page. |
| totalPages | Indicates whether to include the total number of pages in the paging response (implies higher response time). |
| skipPaging | Indicates whether paging should be ignored and all rows should be returned. |
| assignedUserMode | Restricts result to tei with events assigned based on the assigned user selection mode, can be CURRENT &#124; PROVIDED &#124; NONE &#124; ANY. |
| assignedUser | Filter the result down to a limited set of teis with events that are assigned to the given user IDs by using *assignedUser=id1;id2*.This parameter will be considered only if assignedUserMode is either PROVIDED or null. The API will error out, if for example, assignedUserMode=CURRENT and assignedUser=someId |
| trackedEntityInstance | Filter the result down to a limited set of teis using explicit uids of the tracked entity instances by using *trackedEntityInstance=id1;id2*. This parameter will at the very least create the outer boundary of the results, forming the list of all teis using the uids provided. If other parameters/filters from this table are used, they will further limit the results from the explicit outer boundary. |
| potentialDuplicate | Filter the result based on the fact that a TEI is a Potential Duplicate. true: return TEIs flagged as Potential Duplicates. false: return TEIs NOT flagged as Potential Duplicates. If omitted, we don't check whether a TEI is a Potential Duplicate or not.|

The available organisation unit selection modes are explained in the
following table.



Table: Organisation unit selection modes

| Mode | Description |
|---|---|
| SELECTED | Organisation units defined in the request. |
| CHILDREN | Immediate children, i.e. only the first level below, of the organisation units defined in the request. |
| DESCENDANTS | All children, i.e. at only levels below, e.g. including children of children, of the organisation units defined in the request. |
| ACCESSIBLE | All descendants of the data view organisation units associated with the current user. Will fall back to data capture organisation units associated with the current user if the former is not defined. |
| CAPTURE | The data capture organisation units associated with the current user and all children, i.e. all organisation units in the sub-hierarchy. |
| ALL | All organisation units in the system. Requires authority. |

Note that you can specify "attribute" with filters or directly using the "filter" params for constraining the
instances to return.

Certain rules apply to which attributes are returned.

  - If "query" is specified without any attributes or program, then all attributes that
    are marked as "Display in List without Program" is included in the response.

  - If program is specified,  all the attributes linked to the program will
    be included in the response.

  - If tracked entity type is specified, then all tracked entity type attributes
    will be included in the response.

You can specify queries with words separated by space - in that
situation the system will query for each word independently and return
records where each word is contained in any attribute. A query item can
be specified once as an attribute and once as a filter if needed. The
query is case insensitive. The following rules apply to the query
parameters.

  - At least one organisation unit must be specified using the *ou*
    parameter (one or many), or *ouMode=ALL* must be specified.

  - Only one of the *program* and *trackedEntity* parameters can be
    specified (zero or one).

  - If *programStatus* is specified then *program* must also be
    specified.

  - If *followUp* is specified then *program* must also be specified.

  - If *programStartDate* or *programEndDate* is specified then
    *program* must also be specified.

  - If *eventStatus* is specified then *eventStartDate* and
    *eventEndDate* must also be specified.

  - A query cannot be specified together with filters.

  - Attribute items can only be specified once.

  - Filter items can only be specified once.

A query for all instances associated with a specific organisation unit
can look like this:

    /api/33/trackedEntityInstances/query.json?ou=DiszpKrYNg8

A query on all attributes for a specific value and organisation unit,
using an exact word match:

    /api/33/trackedEntityInstances/query.json?query=scott&ou=DiszpKrYNg8

A query on all attributes for a specific value, using a partial word
match:

    /api/33/trackedEntityInstances/query.json?query=LIKE:scott&ou=DiszpKrYNg8

You can query on multiple words separated by the URL character for
space which is %20, will use a logical AND query for each
    word:

    /api/33/trackedEntityInstances/query.json?query=isabel%20may&ou=DiszpKrYNg8

A query where the attributes to include in the response are specified:

    /api/33/trackedEntityInstances/query.json?query=isabel
      &attribute=dv3nChNSIxy&attribute=AMpUYgxuCaE&ou=DiszpKrYNg8

To query for instances using one attribute with a filter and one
attribute without a filter, with one organisation unit using the
descendants organisation unit query mode:

    /api/33/trackedEntityInstances/query.json?attribute=zHXD5Ve1Efw:EQ:A
      &attribute=AMpUYgxuCaE&ou=DiszpKrYNg8;yMCshbaVExv

A query for instances where one attribute is included in the response
and one attribute is used as a
    filter:

    /api/33/trackedEntityInstances/query.json?attribute=zHXD5Ve1Efw:EQ:A
      &filter=AMpUYgxuCaE:LIKE:Road&ou=DiszpKrYNg8

A query where multiple operand and filters are specified for a filter
item:

    /api/33/trackedEntityInstances/query.json?ou=DiszpKrYNg8&program=ur1Edk5Oe2n
      &filter=lw1SqmMlnfh:GT:150:LT:190

To query on an attribute using multiple values in an IN
    filter:

    /api/33/trackedEntityInstances/query.json?ou=DiszpKrYNg8
      &attribute=dv3nChNSIxy:IN:Scott;Jimmy;Santiago

To constrain the response to instances which are part of a specific
program you can include a program query parameter:

    /api/33/trackedEntityInstances/query.json?filter=zHXD5Ve1Efw:EQ:A
      &ou=O6uvpzGd5pu&ouMode=DESCENDANTS&program=ur1Edk5Oe2n

To specify program enrollment dates as part of the query:

    /api/33/trackedEntityInstances/query.json?filter=zHXD5Ve1Efw:EQ:A
      &ou=O6uvpzGd5pu&program=ur1Edk5Oe2n&programStartDate=2013-01-01
      &programEndDate=2013-09-01

To constrain the response to instances of a specific tracked entity you
can include a tracked entity query parameter:

    /api/33/trackedEntityInstances/query.json?attribute=zHXD5Ve1Efw:EQ:A
      &ou=O6uvpzGd5pu&ouMode=DESCENDANTS&trackedEntity=cyl5vuJ5ETQ

By default the instances are returned in pages of size 50, to change
this you can use the page and pageSize query parameters:

    /api/33/trackedEntityInstances/query.json?attribute=zHXD5Ve1Efw:EQ:A
      &ou=O6uvpzGd5pu&ouMode=DESCENDANTS&page=2&pageSize=3

To query for instances which have events of a given status within a
given time span:

    /api/33/trackedEntityInstances/query.json?ou=O6uvpzGd5pu
      &program=ur1Edk5Oe2n&eventStatus=COMPLETED
      &eventStartDate=2014-01-01&eventEndDate=2014-09-01

You can use a range of operators for the filtering:



Table: Filter operators

| Operator | Description |
|---|---|
| EQ | Equal to |
| GT | Greater than |
| GE | Greater than or equal to |
| LT | Less than |
| LE | Less than or equal to |
| NE | Not equal to |
| LIKE | Free text match (Contains) |
| SW | Starts with |
| EW | Ends with |
| IN | Equal to one of multiple values separated by ";" |

##### Response format { #webapi_tei_grid_query_response_format }

This resource supports JSON, JSONP, XLS and CSV resource
representations.

  - json (application/json)

  - jsonp (application/javascript)

  - xml (application/xml)

  - csv (application/csv)

  - xls (application/vnd.ms-excel)

The response in JSON comes is in a tabular format and can look like the
following. The *headers* section describes the content of each column.
The instance, created, last updated, org unit and tracked entity columns
are always present. The following columns correspond to attributes
specified in the query. The *rows* section contains one row per
instance.

```json
{
  "headers": [{
    "name": "instance",
    "column": "Instance",
    "type": "java.lang.String"
  }, {
    "name": "created",
    "column": "Created",
    "type": "java.lang.String"
  }, {
    "name": "lastupdated",
    "column": "Last updated",
    "type": "java.lang.String"
  }, {
    "name": "ou",
    "column": "Org unit",
    "type": "java.lang.String"
  }, {
    "name": "te",
    "column": "Tracked entity",
    "type": "java.lang.String"
  }, {
    "name": "zHXD5Ve1Efw",
    "column": "Date of birth type",
    "type": "java.lang.String"
  }, {
    "name": "AMpUYgxuCaE",
    "column": "Address",
    "type": "java.lang.String"
  }],
  "metaData": {
    "names": {
      "cyl5vuJ5ETQ": "Person"
    }
  },
  "width": 7,
  "height": 7,
  "rows": [
    ["yNCtJ6vhRJu", "2013-09-08 21:40:28.0", "2014-01-09 19:39:32.19", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "21 Kenyatta Road"],
    ["fSofnQR6lAU", "2013-09-08 21:40:28.0", "2014-01-09 19:40:19.62", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "56 Upper Road"],
    ["X5wZwS5lgm2", "2013-09-08 21:40:28.0", "2014-01-09 19:40:31.11", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "56 Main Road"],
    ["pCbogmlIXga", "2013-09-08 21:40:28.0", "2014-01-09 19:40:45.02", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "12 Lower Main Road"],
    ["WnUXrY4XBMM", "2013-09-08 21:40:28.0", "2014-01-09 19:41:06.97", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "13 Main Road"],
    ["xLNXbDs9uDF", "2013-09-08 21:40:28.0", "2014-01-09 19:42:25.66", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "14 Mombasa Road"],
    ["foc5zag6gbE", "2013-09-08 21:40:28.0", "2014-01-09 19:42:36.93", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "15 Upper Hill"]
  ]
}
```

#### Tracked entity instance filters { #webapi_tei_filters }

To create, read, update and delete tracked entity instance filters you
can interact with the */api/trackedEntityInstanceFilters* resource. Tracked entity instance filters are shareable and follows the same pattern of sharing as any other metadata object. When using the */api/sharing* the type parameter will be *trackedEntityInstanceFilter*.

    /api/33/trackedEntityInstanceFilters

##### Create and update a tracked entity instance filter definition

For creating and updating a tracked entity instance filter in the
system, you will be working with the *trackedEntityInstanceFilters*
resource. The tracked entity instance filter definitions are used in the
Tracker Capture app to display relevant predefined "Working lists" in
the tracker user interface.



Table: Payload

| Payload values | Description | Example |
|---|---|---|
| name | Name of the filter. Required. ||
| description | A description of the filter. ||
| sortOrder | The sort order of the filter. Used in Tracker Capture to order the filters in the program dashboard. ||
| style | Object containing css style. | ( "color": "blue", "icon": "fa fa-calendar"} |
| program | Object containing the id of the program. Required. | { "id" : "uy2gU8kTjF"} |
| entityQueryCriteria | An object representing various possible filtering values. See *Entity Query Criteria* definition table below.
| eventFilters | A list of eventFilters. See *Event filters* definition table below. | [{"programStage": "eaDH9089uMp", "eventStatus": "OVERDUE", "eventCreatedPeriod": {"periodFrom": -15, "periodTo": 15}}] |

Table: Entity Query Criteria definition

||||
|---|---|---|
| attributeValueFilters | A list of attributeValueFilters. This is used to specify filters for attribute values when listing tracked entity instances | "attributeValueFilters"=[{       "attribute": "abcAttributeUid",       "le": "20",       "ge": "10",       "lt": "20",       "gt": "10",       "in": ["India", "Norway"],       "like": "abc",       "sw": "abc",       "ew": "abc",       "dateFilter": {         "startDate": "2014-05-01",         "endDate": "2019-03-20",         "startBuffer": -5,         "endBuffer": 5,         "period": "LAST_WEEK",         "type": "RELATIVE"       }     }] |
| enrollmentStatus | The TEIs enrollment status. Can be none(any enrollmentstatus) or ACTIVE&#124;COMPLETED&#124;CANCELLED ||
| followup | When this parameter is true, the filter only returns TEIs that have an enrollment with status followup. ||
| organisationUnit | To specify the uid of the organisation unit | "organisationUnit": "a3kGcGDCuk7" |
| ouMode | To specify the OU selection mode. Possible values are SELECTED&#124; CHILDREN&#124;DESCENDANTS&#124;ACCESSIBLE&#124;CAPTURE&#124;ALL | "ouMode": "SELECTED" |
| assignedUserMode | To specify the assigned user selection mode for events. Possible values are CURRENT&#124; PROVIDED&#124; NONE &#124; ANY. See table below to understand what each value indicates. If PROVIDED (or null), non-empty assignedUsers in the payload will be considered. | "assignedUserMode": "PROVIDED" |
| assignedUsers | To specify a list of assigned users for events. To be used along with PROVIDED assignedUserMode above. | "assignedUsers": ["a3kGcGDCuk7", "a3kGcGDCuk8"] |
| displayColumnOrder | To specify the output ordering of columns | "displayOrderColumns": ["enrollmentDate", "program"] |
| order | To specify ordering/sorting of fields and its directions in comma separated values. A single item in order is of the form "orderDimension:direction". Note: Supported orderDimensions are trackedEntity, created, createdAt, createdAtClient, updatedAt, updatedAtClient, enrolledAt, inactive and the tracked entity attributes | "order"="a3kGcGDCuk6:desc" |
| eventStatus | Any valid EventStatus | "eventStatus": "COMPLETED" |
| programStage | To specify a programStage uid to filter on. TEIs will be filtered based on presence of enrollment in the specified program stage.| "programStage"="a3kGcGDCuk6" |
| trackedEntityType | To specify a trackedEntityType filter TEIs on. | "trackedEntityType"="a3kGcGDCuk6" |
| trackedEntityInstances | To specify a list of trackedEntityInstances to use when querying TEIs. | "trackedEntityInstances"=["a3kGcGDCuk6","b4jGcGDCuk7"] |
| enrollmentIncidentDate | DateFilterPeriod object date filtering based on enrollment incident date. | "enrollmentIncidentDate": {     "startDate": "2014-05-01",     "endDate": "2019-03-20",     "startBuffer": -5,     "endBuffer": 5,     "period": "LAST_WEEK",     "type": "RELATIVE"   } |
| eventDate | DateFilterPeriod object date filtering based on event date. | "eventDate": {     "startBuffer": -5,     "endBuffer": 5,     "type": "RELATIVE"   } |
| enrollmentCreatedDate | DateFilterPeriod object date filtering based on enrollment created date. | "enrollmentCreatedDate": {     "period": "LAST_WEEK",     "type": "RELATIVE"   } |
| lastUpdatedDate | DateFilterPeriod object date filtering based on last updated date. | "lastUpdatedDate": {     "startDate": "2014-05-01",     "endDate": "2019-03-20",     "type": "ABSOLUTE"   } |

Table: Event filters definition

||||
|---|---|---|
| programStage | Which programStage the TEI needs an event in to be returned. | "eaDH9089uMp" |
| eventStatus | The events status. Can be none(any event status) or ACTIVE&#124;COMPLETED&#124;SCHEDULE&#124;OVERDUE | ACTIVE |
| eventCreatedPeriod | Period object containing a period in which the event must be created. See *Period* definition below. | { "periodFrom": -15, "periodTo": 15} |
| assignedUserMode | To specify the assigned user selection mode for events. Possible values are CURRENT (events assigned to current user)&#124; PROVIDED (events assigned to users provided in "assignedUsers" list) &#124; NONE (events assigned to no one) &#124; ANY (events assigned to anyone). If PROVIDED (or null), non-empty assignedUsers in the payload will be considered. | "assignedUserMode": "PROVIDED" |
| assignedUsers | To specify a list of assigned users for events. To be used along with PROVIDED assignedUserMode above. | "assignedUsers": ["a3kGcGDCuk7", "a3kGcGDCuk8"] |


Table: DateFilterPeriod object definition

||||
|---|---|---|
| type | Specify whether the date period type is ABSOLUTE &#124; RELATIVE | "type" : "RELATIVE" |
| period | Specify if a relative system defined period is to be used. Applicable only when "type" is RELATIVE. (see [Relative Periods](#webapi_date_relative_period_values) for supported relative periods) | "period" : "THIS_WEEK" |
| startDate | Absolute start date. Applicable only when "type" is ABSOLUTE | "startDate":"2014-05-01" |
| endDate | Absolute end date. Applicable only when "type" is ABSOLUTE | "startDate":"2014-05-01" |
| startBuffer | Relative custom start date. Applicable only when "type" is RELATIVE | "startBuffer":-10 |
| endBuffer | Relative custom end date. Applicable only when "type" is RELATIVE | "startDate":+10 |

Table: Period definition

||||
|---|---|---|
| periodFrom | Number of days from current day. Can be positive or negative integer. | -15 |
| periodTo | Number of days from current day. Must be bigger than periodFrom. Can be positive or negative integer. | 15 |

##### Tracked entity instance filters query

To query for tracked entity instance filters in the system, you can
interact with the */api/trackedEntityInstanceFilters* resource.



Table: Tracked entity instance filters query parameters

| Query parameter | Description |
|---|---|
| program | Program identifier. Restricts filters to the given program. |

### Enrollment management { #webapi_enrollment_management }

Enrollments have full CRUD support in the API. Together with the API
for tracked entity instances most operations needed for working with
tracked entity instances and programs are supported.

    /api/33/enrollments

#### Enrolling a tracked entity instance into a program { #webapi_enrolling_tei }

For enrolling persons into a program, you will need to first get the
identifier of the person from the *trackedEntityInstances* resource.
Then, you will need to get the program identifier from the *programs*
resource. A template payload can be seen below:

```json
{
  "trackedEntityInstance": "ZRyCnJ1qUXS",
  "orgUnit": "ImspTQPwCqd",
  "program": "S8uo8AlvYMz",
  "enrollmentDate": "2013-09-17",
  "incidentDate": "2013-09-17"
}
```

This payload should be used in a *POST* request to the enrollments
resource identified by the following URL:

    /api/33/enrollments

The different status of an enrollment are:

* **ACTIVE**: It is used meanwhile when the tracked entity participates on the program.
* **COMPLETED**: It is used when the tracked entity finished its participation on the program.
* **CANCELLED**: "Deactivated" in the web UI. It is used when the tracked entity cancelled its participation on the program.

For cancelling or completing an enrollment, you can make a *PUT*
request to the `enrollments` resource, including the identifier and the
action you want to perform. For cancelling an enrollment for a tracked
entity instance:

    /api/33/enrollments/<enrollment-id>/cancelled

For completing an enrollment for a tracked entity instance you can make a
*PUT* request to the following URL:

    /api/33/enrollments/<enrollment-id>/completed

For deleting an enrollment, you can make a *DELETE* request to the
following URL:

    /api/33/enrollments/<enrollment-id>

#### Enrollment instance query { #webapi_enrollment_instance_query }

To query for enrollments you can interact with the */api/enrollments*
resource.

    /api/33/enrollments

##### Request syntax { #webapi_enrollment_query_request_syntax }



Table: Enrollment query parameters

| Query parameter | Description |
|---|---|
| ou | Organisation unit identifiers, separated by ";". |
| ouMode | The mode of selecting organisation units, can be SELECTED &#124; CHILDREN &#124; DESCENDANTS &#124; ACCESSIBLE &#124; CAPTURE &#124; ALL. Default is SELECTED, which refers to the selected organisation units only. See table below for explanations. |
| program | Program identifier. Restricts instances to being enrolled in the given program. |
| programStatus | Status of the instance for the given program. Can be ACTIVE &#124; COMPLETED &#124; CANCELLED. |
| followUp | Follow up status of the instance for the given program. Can be true &#124; false or omitted. |
| programStartDate | Start date of enrollment in the given program for the tracked entity instance. |
| programEndDate | End date of enrollment in the given program for the tracked entity instance. |
| lastUpdatedDuration | Include only items which are updated within the given duration. The format is , where the supported time units are “d” (days), “h” (hours), “m” (minutes) and “s” (seconds). |
| trackedEntity | Tracked entity identifier. Restricts instances to the given tracked instance type. |
| trackedEntityInstance | Tracked entity instance identifier. Should not be used together with trackedEntity. |
| page | The page number. Default page is 1. |
| pageSize | The page size. Default size is 50 rows per page. |
| totalPages | Indicates whether to include the total number of pages in the paging response (implies higher response time). |
| skipPaging | Indicates whether paging should be ignored and all rows should be returned. |
| includeDeleted | Indicates whether to include soft deleted enrollments or not. It is false by default. |
| order | Comma-delimited list in the form of `propName:sortDirection`.<br>Available properties are: `completedAt`, `createdAt`, `createdAtClient`, `enrolledAt`, `updatedAt` and `updatedAtClient`.<br> Example: `createdAt:desc`<br>**Note:** `propName` is case sensitive, `sortDirection` is case insensitive. `sortDirection` defaults to `asc` when non provided.|

The available organisation unit selection modes are explained in the
following table.



Table: Organisation unit selection modes

| Mode | Description |
|---|---|
| SELECTED | Organisation units defined in the request (default). |
| CHILDREN | Immediate children, i.e. only the first level below, of the organisation units defined in the request. |
| DESCENDANTS | All children, i.e. at only levels below, e.g. including children of children, of the organisation units defined in the request. |
| ACCESSIBLE | All descendants of the data view organisation units associated with the current user. Will fall back to data capture organisation units associated with the current user if the former is not defined. |
| ALL | All organisation units in the system. Requires authority. |

The query is case insensitive. The following rules apply to the query
parameters.

  - At least one organisation unit must be specified using the *ou*
    parameter (one or many), or *ouMode=ALL* must be specified.

  - Only one of the *program* and *trackedEntity* parameters can be
    specified (zero or one).

  - If *programStatus* is specified then *program* must also be
    specified.

  - If *followUp* is specified then *program* must also be specified.

  - If *programStartDate* or *programEndDate* is specified then
    *program* must also be specified.

A query for all enrollments associated with a specific organisation unit
can look like this:

    /api/33/enrollments.json?ou=DiszpKrYNg8

To constrain the response to enrollments which are part of a specific
program you can include a program query
    parameter:

    /api/33/enrollments.json?ou=O6uvpzGd5pu&ouMode=DESCENDANTS&program=ur1Edk5Oe2n

To specify program enrollment dates as part of the
    query:

    /api/33/enrollments.json?&ou=O6uvpzGd5pu&program=ur1Edk5Oe2n
      &programStartDate=2013-01-01&programEndDate=2013-09-01

To constrain the response to enrollments of a specific tracked entity
you can include a tracked entity query
    parameter:

    /api/33/enrollments.json?ou=O6uvpzGd5pu&ouMode=DESCENDANTS&trackedEntity=cyl5vuJ5ETQ

To constrain the response to enrollments of a specific tracked entity
instance you can include a tracked entity instance query parameter, in
this case we have restricted it to available enrollments viewable for
current
    user:

    /api/33/enrollments.json?ouMode=ACCESSIBLE&trackedEntityInstance=tphfdyIiVL6

By default the enrollments are returned in pages of size 50, to change
this you can use the page and pageSize query
    parameters:

    /api/33/enrollments.json?ou=O6uvpzGd5pu&ouMode=DESCENDANTS&page=2&pageSize=3

##### Response format { #webapi_enrollment_query_response_format }

This resource supports JSON, JSONP, XLS and CSV resource
representations.

  - json (application/json)

  - jsonp (application/javascript)

  - xml (application/xml)

The response in JSON/XML is in object format and can look like the
following. Please note that field filtering is supported, so if you want
a full view, you might want to add `fields=*` to the query:

```json
{
  "enrollments": [
    {
      "lastUpdated": "2014-03-28T05:27:48.512+0000",
      "trackedEntity": "cyl5vuJ5ETQ",
      "created": "2014-03-28T05:27:48.500+0000",
      "orgUnit": "DiszpKrYNg8",
      "program": "ur1Edk5Oe2n",
      "enrollment": "HLFOK0XThjr",
      "trackedEntityInstance": "qv0j4JBXQX0",
      "followup": false,
      "enrollmentDate": "2013-05-23T05:27:48.490+0000",
      "incidentDate": "2013-05-10T05:27:48.490+0000",
      "status": "ACTIVE"
    }
  ]
}
```

### Events { #webapi_events }

This section is about sending and reading events.

    /api/33/events

The different status of an event are:

* **ACTIVE**: If a event has ACTIVE status, it is possible to edit the event details. COMPLETED events can be turned ACTIVE again and vice versa.
* **COMPLETED**: An event change the status to COMPLETED only when a user clicks the complete button. If a event has COMPLETED status, it is not possible to edit the event details. ACTIVE events can be turned COMPLETED again and vice versa.
* **SKIPPED**: Scheduled events that no longer need to happen. In Tracker Capture, there is a button for that.
* **SCHEDULE**: If an event has no event date (but it has an due date) then the event status is saved as SCHEDULE.
* **OVERDUE**: If the due date of a scheduled event (no event date) has expired, it can be interpreted as OVERDUE.
* **VISITED**: (Removed since 2.38. VISITED migrate to ACTIVE). In Tracker Capture its possible to reach VISITED by adding a new event with an event date, and then leave before adding any data to the event - but it is not known to the tracker product team that anyone uses the status for anything. The VISITED status is not visible in the UI, and in all means treated in the same way as an ACTIVE event.


#### Sending events { #webapi_sending_events }

DHIS2 supports three kinds of events: single events with no registration
(also referred to as anonymous events), single event with registration
and multiple events with registration. Registration implies that the
data is linked to a tracked entity instance which is identified using
some sort of identifier.

To send events to DHIS2 you must interact with the *events* resource.
The approach to sending events is similar to sending aggregate data
values. You will need a *program* which can be looked up using the
*programs* resource, an *orgUnit* which can be looked up using the
*organisationUnits* resource, and a list of valid data element
identifiers which can be looked up using the *dataElements* resource.
For events with registration, a *tracked entity instance* identifier is
required, read about how to get this in the section about the
*trackedEntityInstances* resource. For sending events to programs with
multiple stages, you will need to also include the *programStage*
identifier, the identifiers for programStages can be found in the
*programStages* resource.

A simple single event with no registration example payload in XML format
where we send events from the "Inpatient morbidity and mortality"
program for the "Ngelehun CHC" facility in the demo database can be seen
below:

```xml
<?xml version="1.0" encoding="utf-8"?>
<event program="eBAyeGv0exc" orgUnit="DiszpKrYNg8"
  eventDate="2013-05-17" status="COMPLETED" storedBy="admin">
  <coordinate latitude="59.8" longitude="10.9" />
  <dataValues>
    <dataValue dataElement="qrur9Dvnyt5" value="22" />
    <dataValue dataElement="oZg33kd9taw" value="Male" />
    <dataValue dataElement="msodh3rEMJa" value="2013-05-18" />
  </dataValues>
</event>
```

To perform some testing we can save the XML payload as a file
called*event.xml* and send it as a POST request to the events resource
in the API using curl with the following command:

```bash
curl -d @event.xml "https://play.dhis2.org/demo/api/33/events"
  -H "Content-Type:application/xml" -u admin:district
```

The same payload in JSON format looks like this:

```json
{
  "program": "eBAyeGv0exc",
  "orgUnit": "DiszpKrYNg8",
  "eventDate": "2013-05-17",
  "status": "COMPLETED",
  "completedDate": "2013-05-18",
  "storedBy": "admin",
  "coordinate": {
    "latitude": 59.8,
    "longitude": 10.9
  },
  "dataValues": [
    {
      "dataElement": "qrur9Dvnyt5",
      "value": "22"
    },
    {
      "dataElement": "oZg33kd9taw",
      "value": "Male"
    },
    {
      "dataElement": "msodh3rEMJa",
      "value": "2013-05-18"
    }
  ]
}
```

To send this you can save it to a file called *event.json* and use curl
like this:

```bash
curl -d @event.json "localhost/api/33/events" -H "Content-Type:application/json"
  -u admin:district
```

We also support sending multiple events at the same time. A payload in
XML format might look like this:

```xml
<?xml version="1.0" encoding="utf-8"?>
<events>
  <event program="eBAyeGv0exc" orgUnit="DiszpKrYNg8"
    eventDate="2013-05-17" status="COMPLETED" storedBy="admin">
    <coordinate latitude="59.8" longitude="10.9" />
    <dataValues>
      <dataValue dataElement="qrur9Dvnyt5" value="22" />
      <dataValue dataElement="oZg33kd9taw" value="Male" />
    </dataValues>
  </event>
  <event program="eBAyeGv0exc" orgUnit="DiszpKrYNg8"
    eventDate="2013-05-17" status="COMPLETED" storedBy="admin">
    <coordinate latitude="59.8" longitude="10.9" />
    <dataValues>
      <dataValue dataElement="qrur9Dvnyt5" value="26" />
      <dataValue dataElement="oZg33kd9taw" value="Female" />
    </dataValues>
  </event>
</events>
```

You will receive an import summary with the response which can be
inspected in order to get information about the outcome of the request,
like how many values were imported successfully. The payload in JSON
format looks like this:

```json
{
  "events": [
  {
    "program": "eBAyeGv0exc",
    "orgUnit": "DiszpKrYNg8",
    "eventDate": "2013-05-17",
    "status": "COMPLETED",
    "storedBy": "admin",
    "coordinate": {
      "latitude": "59.8",
      "longitude": "10.9"
    },
    "dataValues": [
      {
        "dataElement": "qrur9Dvnyt5",
        "value": "22"
      },
      {
        "dataElement": "oZg33kd9taw",
        "value": "Male"
      }
    ]
  },
  {
    "program": "eBAyeGv0exc",
    "orgUnit": "DiszpKrYNg8",
    "eventDate": "2013-05-17",
    "status": "COMPLETED",
    "storedBy": "admin",
    "coordinate": {
      "latitude": "59.8",
      "longitude": "10.9"
    },
    "dataValues": [
      {
        "dataElement": "qrur9Dvnyt5",
        "value": "26"
      },
      {
        "dataElement": "oZg33kd9taw",
        "value": "Female"
      }
    ]
  } ]
}
```

You can also use GeoJson to store any kind of geometry on your event. An example payload using GeoJson instead of the former latitude and longitude properties can be seen here:

```json
{
  "program": "eBAyeGv0exc",
  "orgUnit": "DiszpKrYNg8",
  "eventDate": "2013-05-17",
  "status": "COMPLETED",
  "storedBy": "admin",
  "geometry": {
    "type": "POINT",
    "coordinates": [59.8, 10.9]
  },
  "dataValues": [
    {
      "dataElement": "qrur9Dvnyt5",
      "value": "22"
    },
    {
      "dataElement": "oZg33kd9taw",
      "value": "Male"
    },
    {
      "dataElement": "msodh3rEMJa",
      "value": "2013-05-18"
    }
  ]
}
```

As part of the import summary you will also get the identifier
*reference* to the event you just sent, together with a *href* element
which points to the server location of this event. The table below
describes the meaning of each element.



Table: Events resource format

| Parameter | Type | Required | Options (default first) | Description |
|---|---|---|---|---|
| program | string | true || Identifier of the single event with no registration program |
| orgUnit | string | true || Identifier of the organisation unit where the event took place |
| eventDate | date | true || The date of when the event occurred |
| completedDate | date | false || The date of when the event is completed. If not provided, the current date is selected as the event completed date |
| status | enum | false | ACTIVE &#124; COMPLETED &#124; VISITED &#124; SCHEDULE &#124; OVERDUE &#124; SKIPPED | Whether the event is complete or not |
| storedBy | string | false | Defaults to current user | Who stored this event (can be username, system-name, etc) |
| coordinate | double | false || Refers to where the event took place geographically (latitude and longitude) |
| dataElement | string | true || Identifier of data element |
| value | string | true || Data value or measure for this event |

##### OrgUnit matching

By default the orgUnit parameter will match on the
ID, you can also select the orgUnit id matching scheme by using the
parameter orgUnitIdScheme=SCHEME, where the options are: *ID*, *UID*,
*UUID*, *CODE*, and *NAME*. There is also the *ATTRIBUTE:* scheme, which
matches on a *unique* metadata attribute value.

#### Updating events { #webapi_updating_events }

To update an existing event, the format of the payload is the same, but
the URL you are posting to must add the identifier to the end of the URL
string and the request must be PUT.

The payload has to contain all, even non-modified, attributes.
Attributes that were present before and are not present in the current
payload any more will be removed by the system.

It is not allowed to update an already deleted event. The same applies
to tracked entity instance and enrollment.

```bash
curl -X PUT -d @updated_event.xml "localhost/api/33/events/ID"
  -H "Content-Type: application/xml" -u admin:district
```

```bash
curl -X PUT -d @updated_event.json "localhost/api/33/events/ID"
  -H "Content-Type: application/json" -u admin:district
```

#### Deleting events { #webapi_deleting_events }

To delete an existing event, all you need is to send a DELETE request
with an identifier reference to the server you are using.

```bash
curl -X DELETE "localhost/api/33/events/ID" -u admin:district
```

#### Assigning user to events { #webapi_user_assign_event }

A user can be assigned to an event. This can be done by including the appropriate property in the payload when updating or creating the event.

      "assignedUser": "<id>"

The id refers to the if of the user. Only one user can be assigned to an event at a time.

User assignment must be enabled in the program stage before users can be assigned to events.
#### Getting events { #webapi_getting_events }

To get an existing event you can issue a GET request including the
identifier like this:

```bash
curl "http://localhost/api/33/events/ID" -H "Content-Type: application/xml" -u admin:district
```

#### Querying and reading events { #webapi_querying_reading_events }

This section explains how to read out the events that have been stored
in the DHIS2 instance. For more advanced uses of the event data, please
see the section on event analytics. The output format from the
`/api/events` endpoint will match the format that is used to send events
to it (which the analytics event api does not support). Both XML and
JSON are supported, either through adding .json/.xml or by setting the
appropriate *Accept* header. The query is paged by default and the
default page size is 50 events, *field* filtering works as it does for
metadata, add the *fields* parameter and include your wanted properties,
i.e. *?fields=program,status*.



Table: Events resource query parameters

| Key | Type | Required | Description |
|---|---|---|---|
| program | identifier | true (if not programStage is provided) | Identifier of program |
| programStage | identifier | false | Identifier of program stage |
| programStatus | enum | false | Status of event in program, ca be ACTIVE &#124; COMPLETED &#124; CANCELLED |
| followUp | boolean | false | Whether event is considered for follow up in program, can be true &#124; false or omitted. |
| trackedEntityInstance | identifier | false | Identifier of tracked entity instance |
| orgUnit | identifier | true | Identifier of organisation unit |
| ouMode | enum | false | Org unit selection mode, can be SELECTED &#124; CHILDREN &#124; DESCENDANTS |
| startDate | date | false | Only events newer than this date |
| endDate | date | false | Only events older than this date |
| status | enum | false | Status of event, can be ACTIVE &#124; COMPLETED &#124; VISITED &#124; SCHEDULE &#124; OVERDUE &#124; SKIPPED |
| lastUpdatedStartDate | date | false | Filter for events which were updated after this date. Cannot be used together with *lastUpdatedDuration*. |
| lastUpdatedEndDate | date | false | Filter for events which were updated up until this date. Cannot be used together with *lastUpdatedDuration*. |
| lastUpdatedDuration | string | false | Include only items which are updated within the given duration. The format is , where the supported time units are “d” (days), “h” (hours), “m” (minutes) and “s” (seconds). Cannot be used together with *lastUpdatedStartDate* and/or *lastUpdatedEndDate*. |
| skipMeta | boolean | false | Exclude the meta data part of response (improves performance) |
| page | integer | false | Page number |
| pageSize | integer | false | Number of items in each page |
| totalPages | boolean | false | Indicates whether to include the total number of pages in the paging response. |
| skipPaging | boolean | false | Indicates whether to skip paging in the query and return all events. |
| dataElementIdScheme | string | false | Data element ID scheme to use for export, valid options are UID, CODE and ATTRIBUTE:{ID} |
| categoryOptionComboIdScheme | string | false | Category Option Combo ID scheme to use for export, valid options are UID, CODE and ATTRIBUTE:{ID} |
| orgUnitIdScheme | string | false | Organisation Unit ID scheme to use for export, valid options are UID, CODE and ATTRIBUTE:{ID} |
| programIdScheme | string | false | Program ID scheme to use for export, valid options are UID, CODE and ATTRIBUTE:{ID} |
| programStageIdScheme | string | false | Program Stage ID scheme to use for export, valid options are UID, CODE and ATTRIBUTE:{ID} |
| idScheme | string | false | Allows to set id scheme for data element, category option combo, orgUnit, program and program stage at once. |
| order | string | false | The order of which to retrieve the events from the API. Usage: order=<property\>:asc/desc - Ascending order is default. <br>Properties: event &#124; program &#124; programStage &#124; enrollment &#124; enrollmentStatus &#124; orgUnit &#124; orgUnitName &#124; trackedEntityInstance &#124; eventDate &#124; followup &#124; status &#124; dueDate &#124; storedBy &#124; created &#124; lastUpdated &#124; completedBy &#124; completedDate<br> order=orgUnitName:DESC order=lastUpdated:ASC |
| event | comma delimited string | false | Filter the result down to a limited set of IDs by using *event=id1;id2*. |
| skipEventId | boolean | false | Skips event identifiers in the response |
| attributeCc (\*\*) | string | false | Attribute category combo identifier (must be combined with *attributeCos*) |
| attributeCos (\*\*) | string | false | Attribute category option identifiers, separated with ; (must be combined with *attributeCc*) |
| async | false &#124; true | false | Indicates whether the import should be done asynchronous or synchronous. |
| includeDeleted | boolean | false | When true, soft deleted events will be included in your query result. |
| assignedUserMode | enum | false | Assigned user selection mode, can be CURRENT &#124; PROVIDED &#124; NONE &#124; ANY. |
| assignedUser | comma delimited strings | false | Filter the result down to a limited set of events that are assigned to the given user IDs by using *assignedUser=id1;id2*. This parameter will be considered only if assignedUserMode is either PROVIDED or null. The API will error out, if for example, assignedUserMode=CURRENT and assignedUser=someId |

> **Note**
>
> If the query contains neither `attributeCC` nor `attributeCos`, the server returns events for all attribute option combos where the user has read access.

##### Examples

Query for all events with children of a certain organisation unit:

    /api/29/events.json?orgUnit=YuQRtpLP10I&ouMode=CHILDREN

Query for all events with all descendants of a certain organisation
unit, implying all organisation units in the sub-hierarchy:

    /api/33/events.json?orgUnit=O6uvpzGd5pu&ouMode=DESCENDANTS

Query for all events with a certain program and organisation unit:

    /api/33/events.json?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc

Query for all events with a certain program and organisation unit,
sorting by due date
    ascending:

    /api/33/events.json?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc&order=dueDate

Query for the 10 events with the newest event date in a certain program
and organisation unit - by paging and ordering by due date descending:

    /api/33/events.json?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc
      &order=eventDate:desc&pageSize=10&page=1

Query for all events with a certain program and organisation unit for a
specific tracked entity instance:

    /api/33/events.json?orgUnit=DiszpKrYNg8
      &program=eBAyeGv0exc&trackedEntityInstance=gfVxE3ALA9m

Query for all events with a certain program and organisation unit older
or equal to
    2014-02-03:

    /api/33/events.json?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc&endDate=2014-02-03

Query for all events with a certain program stage, organisation unit and
tracked entity instance in the year 2014:

    /api/33/events.json?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc
      &trackedEntityInstance=gfVxE3ALA9m&startDate=2014-01-01&endDate=2014-12-31

Query files associated with event data values. In the specific case of fetching an image file an
additional parameter can be provided to fetch the image with different dimensions. If dimension is
not provided, the system will return the original image. The parameter will be ignored in case of
fetching non-image files e.g pdf. Possible dimension values are *small(254 x 254),
medium(512 x 512), large(1024 x 1024) or original*. Any value other than those mentioned will be
discarded and the original image will be returned.

    /api/33/events/files?eventUid=hcmcWlYkg9u&dataElementUid=C0W4aFuVm4P&dimension=small

Retrieve events with specified Organisation unit and Program, and use _Attribute:Gq0oWTf2DtN_ as
identifier scheme

    /api/events?orgUnit=DiszpKrYNg8&program=lxAQ7Zs9VYR&idScheme=Attribute:Gq0oWTf2DtN

Retrieve events with specified Organisation unit and Program, and use UID as identifier scheme for
orgUnits, Code as identifier scheme for Program stages, and _Attribute:Gq0oWTf2DtN_ as identifier
scheme for the rest of the metadata with assigned attribute.

    api/events.json?orgUnit=DiszpKrYNg8&program=lxAQ7Zs9VYR&idScheme=Attribute:Gq0oWTf2DtN
      &orgUnitIdScheme=UID&programStageIdScheme=Code

#### Event grid query

In addition to the above event query end point, there is an event grid
query end point where a more compact "grid" format of events are
returned. This is possible by interacting with
/api/events/query.json|xml|xls|csv endpoint.

    /api/33/events/query

Most of the query parameters mentioned in event querying and reading
section above are valid here. However, since the grid to be returned
comes with specific set of columns that apply to all rows (events), it
is mandatory to specify a program stage. It is not possible to mix
events from different programs or program stages in the return.

Returning events from a single program stage, also opens up for new
functionality - for example sorting and searching events based on their
data element values. api/events/query has support for this. Below are
some examples

A query to return an event grid containing only selected data elements
for a program stage

    /api/33/events/query.json?orgUnit=DiszpKrYNg8&programStage=Zj7UnCAulEk
      &dataElement=qrur9Dvnyt5,fWIAEtYVEGk,K6uUAvq500H&order=lastUpdated:desc
      &pageSize=50&page=1&totalPages=true

A query to return an event grid containing all data elements of a
program
    stage

    /api/33/events/query.json?orgUnit=DiszpKrYNg8&programStage=Zj7UnCAulEk
      &includeAllDataElements=true

A query to filter events based on data element
    value

    /api/33/events/query.json?orgUnit=DiszpKrYNg8&programStage=Zj7UnCAulEk
      &filter=qrur9Dvnyt5:GT:20:LT:50

In addition to the filtering, the above example also illustrates one
thing: the fact that there are no data elements mentioned to be returned
in the grid. When this happens, the system defaults back to return only
those data elements marked "Display in report" under program stage
configuration.

We can also extend the above query to return us a grid sorted (asc|desc)
based on data element
    value

    /api/33/events/query.json?orgUnit=DiszpKrYNg8&programStage=Zj7UnCAulEk
      &filter=qrur9Dvnyt5:GT:20:LT:50&order=qrur9Dvnyt5:desc

#### Event filters { #webapi_event_filters }

To create, read, update and delete event filters you
can interact with the `/api/eventFilters` resource.

    /api/33/eventFilters

##### Create and update an event filter definition

For creating and updating an event filter in the
system, you will be working with the *eventFilters*
resource. *POST* is used to create and *PUT* method is used to update. The event filter definitions are used in the
Tracker Capture app to display relevant predefined "Working lists" in
the tracker user interface.



Table: Request Payload

| Request Property | Description | Example |
|---|---|---|
| name | Name of the filter. | "name":"My working list" |
| description | A description of the filter. | "description":"for listing all events assigned to me". |
| program | The uid of the program. | "program" : "a3kGcGDCuk6" |
| programStage | The uid of the program stage. | "programStage" : "a3kGcGDCuk6" |
| eventQueryCriteria | Object containing parameters for querying, sorting and filtering events. | "eventQueryCriteria": {     "organisationUnit":"a3kGcGDCuk6",     "status": "COMPLETED",     "createdDate": {       "from": "2014-05-01",       "to": "2019-03-20"     },     "dataElements": ["a3kGcGDCuk6:EQ:1", "a3kGcGDCuk6"],     "filters": ["a3kGcGDCuk6:EQ:1"],     "programStatus": "ACTIVE",     "ouMode": "SELECTED",     "assignedUserMode": "PROVIDED",     "assignedUsers" : ["a3kGcGDCuk7", "a3kGcGDCuk8"],     "followUp": false,     "trackedEntityInstance": "a3kGcGDCuk6",     "events": ["a3kGcGDCuk7", "a3kGcGDCuk8"],     "fields": "eventDate,dueDate",     "order": "dueDate:asc,createdDate:desc"   } |



Table: Event Query Criteria definition

||||
|---|---|---|
| followUp | Used to filter events based on enrollment followUp flag. Possible values are true&#124;false. | "followUp": true |
| organisationUnit | To specify the uid of the organisation unit | "organisationUnit": "a3kGcGDCuk7" |
| ouMode | To specify the OU selection mode. Possible values are SELECTED&#124; CHILDREN&#124;DESCENDANTS&#124;ACCESSIBLE&#124;CAPTURE&#124;ALL | "ouMode": "SELECTED" |
| assignedUserMode | To specify the assigned user selection mode for events. Possible values are CURRENT&#124; PROVIDED&#124; NONE &#124; ANY. See table below to understand what each value indicates. If PROVIDED (or null), non-empty assignedUsers in the payload will be considered. | "assignedUserMode": "PROVIDED" |
| assignedUsers | To specify a list of assigned users for events. To be used along with PROVIDED assignedUserMode above. | "assignedUsers": ["a3kGcGDCuk7", "a3kGcGDCuk8"] |
| displayOrderColumns | To specify the output ordering of columns | "displayOrderColumns": ["eventDate", "dueDate", "program"] |
| order | To specify ordering/sorting of fields and its directions in comma separated values. A single item in order is of the form "dataItem:direction". | "order"="a3kGcGDCuk6:desc,eventDate:asc" |
| dataFilters | To specify filters to be applied when listing events | "dataFilters"=[{       "dataItem": "abcDataElementUid",       "le": "20",       "ge": "10",       "lt": "20",       "gt": "10",       "in": ["India", "Norway"],       "like": "abc",       "dateFilter": {         "startDate": "2014-05-01",         "endDate": "2019-03-20",         "startBuffer": -5,         "endBuffer": 5,         "period": "LAST_WEEK",         "type": "RELATIVE"       }     }] |
| status | Any valid EventStatus | "eventStatus": "COMPLETED" |
| events | To specify list of events | "events"=["a3kGcGDCuk6"] |
| completedDate | DateFilterPeriod object date filtering based on completed date. | "completedDate": {     "startDate": "2014-05-01",     "endDate": "2019-03-20",     "startBuffer": -5,     "endBuffer": 5,     "period": "LAST_WEEK",     "type": "RELATIVE"   } |
| eventDate | DateFilterPeriod object date filtering based on event date. | "eventDate": {     "startBuffer": -5,     "endBuffer": 5,     "type": "RELATIVE"   } |
| dueDate | DateFilterPeriod object date filtering based on due date. | "dueDate": {     "period": "LAST_WEEK",     "type": "RELATIVE"   } |
| lastUpdatedDate | DateFilterPeriod object date filtering based on last updated date. | "lastUpdatedDate": {     "startDate": "2014-05-01",     "endDate": "2019-03-20",     "type": "ABSOLUTE"   } |



Table: DateFilterPeriod object definition

||||
|---|---|---|
| type | Specify whether the date period type is ABSOLUTE &#124; RELATIVE | "type" : "RELATIVE" |
| period | Specify if a relative system defined period is to be used. Applicable only when "type" is RELATIVE. (see [Relative Periods](#webapi_date_relative_period_values) for supported relative periods) | "period" : "THIS_WEEK" |
| startDate | Absolute start date. Applicable only when "type" is ABSOLUTE | "startDate":"2014-05-01" |
| endDate | Absolute end date. Applicable only when "type" is ABSOLUTE | "startDate":"2014-05-01" |
| startBuffer | Relative custom start date. Applicable only when "type" is RELATIVE | "startBuffer":-10 |
| endBuffer | Relative custom end date. Applicable only when "type" is RELATIVE | "startDate":+10 |

The available assigned user selection modes are explained in the
following table.



Table: Assigned user selection modes (event assignment)

| Mode | Description |
|---|---|
| CURRENT | Assigned to the current logged in user |
| PROVIDED | Assigned to the users provided in the "assignedUser" parameter |
| NONE | Assigned to no users. |
| ANY | Assigned to any users. |

A sample payload that can be used to create/update an eventFilter is shown below.

```json
{
  "program": "ur1Edk5Oe2n",
  "description": "Simple Filter for TB events",
  "name": "TB events",
  "eventQueryCriteria": {
    "organisationUnit":"DiszpKrYNg8",
    "eventStatus": "COMPLETED",
    "eventDate": {
      "startDate": "2014-05-01",
      "endDate": "2019-03-20",
      "startBuffer": -5,
      "endBuffer": 5,
      "period": "LAST_WEEK",
      "type": "RELATIVE"
    },
    "dataFilters": [{
      "dataItem": "abcDataElementUid",
      "le": "20",
      "ge": "10",
      "lt": "20",
      "gt": "10",
      "in": ["India", "Norway"],
      "like": "abc"
    },
    {
      "dataItem": "dateDataElementUid",
      "dateFilter": {
        "startDate": "2014-05-01",
        "endDate": "2019-03-20",
        "type": "ABSOLUTE"
      }
    },
    {
      "dataItem": "anotherDateDataElementUid",
      "dateFilter": {
        "startBuffer": -5,
        "endBuffer": 5,
        "type": "RELATIVE"
      }
    },
    {
      "dataItem": "yetAnotherDateDataElementUid",
      "dateFilter": {
        "period": "LAST_WEEK",
        "type": "RELATIVE"
      }
    }],
    "programStatus": "ACTIVE"
  }
}
```


##### Retrieving and deleting event filters

A specific event filter can be retrieved by using the following api

    GET /api/33/eventFilters/{uid}

All event filters can be retrieved by using the following api.

    GET /api/33/eventFilters?fields=*

All event filters for a specific program can be retrieved by using the following api

    GET /api/33/eventFilters?filter=program:eq:IpHINAT79UW

An event filter can be deleted by using the following api

    DELETE /api/33/eventFilters/{uid}

### Relationships
Relationships are links between two entities in tracker. These entities can be tracked entity instances, enrollments and events.

There are multiple endpoints that allow you to see, create, delete and update relationships. The most common is the /api/trackedEntityInstances endpoint, where you can include relationships in the payload to create, update or deleting them if you omit them - Similar to how you work with enrollments and events in the same endpoint. All the tracker endpoints, /api/trackedEntityInstances, /api/enrollments and /api/events also list their relationships if requested in the field filter.

The standard endpoint for relationships is, however, /api/relationships. This endpoint provides all the normal CRUD operations for relationships.

You can view a list of relationships by trackedEntityInstance, enrollment or event:

    GET /api/relationships?[tei={teiUID}|enrollment={enrollmentUID}|event={eventUID}]

This request will return a list of any relationship you have access to see that includes the trackedEntityInstance, enrollment or event you specified. Each relationship is represented with the following JSON:

```json
{
  "relationshipType": "dDrh5UyCyvQ",
  "relationshipName": "Mother-Child",
  "relationship": "t0HIBrc65Rm",
  "bidirectional": false,
  "from": {
    "trackedEntityInstance": {
      "trackedEntityInstance": "vOxUH373fy5"
    }
  },
  "to": {
    "trackedEntityInstance": {
      "trackedEntityInstance": "pybd813kIWx"
    }
  },
  "created": "2019-04-26T09:30:56.267",
  "lastUpdated": "2019-04-26T09:30:56.267"
}
```

You can also view specified relationships using the following endpoint:

    GET /api/relationships/<id>

To create or update a relationship, you can use the following endpoints:

    POST /api/relationships
    PUT /api/relationships

And use the following payload structure:

```json
{
  "relationshipType": "dDrh5UyCyvQ",
  "from": {
    "trackedEntityInstance": {
      "trackedEntityInstance": "vOxUH373fy5"
    }
  },
  "to": {
    "trackedEntityInstance": {
      "trackedEntityInstance": "pybd813kIWx"
    }
  }
}
```

To delete a relationship, you can use this endpoint:

      DELETE /api/relationships/<id>

In our example payloads, we use a relationship between trackedEntityInstances. Because of this, the "from" and "to" properties of our payloads include "trackedEntityInstance" objects. If your relationship includes other entities, you can use the following properties:

```json
{
  "enrollment": {
    "enrollment": "<id>"
  }
}
```

```json
{
  "event": {
    "event": "<id>"
  }
}
```
Relationship can be soft deleted. In that case, you can use the `includeDeleted` request parameter to see the relationship.

    GET /api/relationships?tei=pybd813kIWx?includeDeleted=true

### Update strategies { #webapi_tei_update_strategies }

Two update strategies for all 3 tracker endpoints are supported:
enrollment and event creation. This is useful when you have generated an
identifier on the client side and are not sure if it was created or not
on the server.



Table: Available tracker strategies

| Parameter | Description |
|---|---|
| CREATE | Create only, this is the default behavior. |
| CREATE_AND_UPDATE | Try and match the ID, if it exist then update, if not create. |

To change the parameter, please use the strategy parameter:

    POST /api/33/trackedEntityInstances?strategy=CREATE_AND_UPDATE

### Tracker bulk deletion { #webapi_tracker_bulk_deletion }

Bulk deletion of tracker objects work in a similar fashion to adding and
updating tracker objects, the only difference is that the
`importStrategy` is *DELETE*.

*Example: Bulk deletion of tracked entity instances:*

```json
{
  "trackedEntityInstances": [
    {
      "trackedEntityInstance": "ID1"
    }, {
      "trackedEntityInstance": "ID2"
    }, {
      "trackedEntityInstance": "ID3"
    }
  ]
}
```

```bash
curl -X POST -d @data.json -H "Content-Type: application/json"
  "http://server/api/33/trackedEntityInstances?strategy=DELETE"
```

*Example: Bulk deletion of enrollments:*

```json
{
  "enrollments": [
    {
       "enrollment": "ID1"
    }, {
      "enrollment": "ID2"
    }, {
      "enrollment": "ID3"
    }
  ]
}
```

```bash
curl -X POST -d @data.json -H "Content-Type: application/json"
  "http://server/api/33/enrollments?strategy=DELETE"
```

*Example: Bulk deletion of events:*

```json
{
  "events": [
    {
      "event": "ID1"
    }, {
      "event": "ID2"
    }, {
      "event": "ID3"
    }
  ]
}
```

```bash
curl -X POST -d @data.json -H "Content-Type: application/json"
  "http://server/api/33/events?strategy=DELETE"
```

### Identifier reuse and item deletion via POST and PUT methods { #webapi_updating_and_deleting_items }

Tracker endpoints */trackedEntityInstances*, */enrollments*, */events*
support CRUD operations. The system keeps track of used identifiers.
Therefore, an item which has been created and then deleted (e.g. events,
enrollments) cannot be created or updated again. If attempting to delete
an already deleted item, the system returns a success response as
deletion of an already deleted item implies no change.

The system does not allow to delete an item via an update (*PUT*) or
create (*POST*) method. Therefore, an attribute *deleted* is ignored in
both *PUT* and *POST* methods, and in *POST* method it is by default set
to *false*.

### Import parameters { #webapi_import_parameters }

The import process can be customized using a set of import parameters:



Table: Import parameters

| Parameter | Values (default first) | Description |
|---|---|---|
| dataElementIdScheme | id &#124; name &#124; code &#124; attribute:ID | Property of the data element object to use to map the data values. |
| orgUnitIdScheme | id &#124; name &#124; code &#124; attribute:ID | Property of the org unit object to use to map the data values. |
| idScheme | id &#124; name &#124; code&#124; attribute:ID | Property of all objects including data elements, org units and category option combos, to use to map the data values. |
| dryRun | false &#124; true | Whether to save changes on the server or just return the import summary. |
| strategy | CREATE &#124; UPDATE &#124; CREATE_AND_UPDATE &#124; DELETE | Save objects of all, new or update import status on the server. |
| skipNotifications | true &#124; false | Indicates whether to send notifications for completed events. |
| skipFirst | true &#124; false | Relevant for CSV import only. Indicates whether CSV file contains a header row which should be skipped. |
| importReportMode | FULL, ERRORS, DEBUG | Sets the `ImportReport` mode, controls how much is reported back after the import is done. `ERRORS` only includes *ObjectReports* for object which has errors. `FULL` returns an *ObjectReport* for all objects imported, and `DEBUG` returns the same plus a name for the object (if available). |

#### CSV Import / Export { #webapi_events_csv_import_export }

In addition to XML and JSON for event import/export, in DHIS2.17 we
introduced support for the CSV format. Support for this format builds on
what was described in the last section, so here we will only write about
what the CSV specific parts are.

To use the CSV format you must either use the `/api/events.csv`
endpoint, or add *content-type: text/csv* for import, and *accept:
text/csv* for export when using the `/api/events` endpoint.

The order of column in the CSV which are used for both export and import
is as follows:



Table: CSV column

| Index | Key | Type | Description |
|---|---|---|---|
| 1 | event | identifier | Identifier of event |
| 2 | status | enum | Status of event, can be ACTIVE &#124; COMPLETED &#124; VISITED &#124; SCHEDULE &#124; OVERDUE &#124; SKIPPED |
| 3 | program | identifier | Identifier of program |
| 4 | programStage | identifier | Identifier of program stage |
| 5 | enrollment | identifier | Identifier of enrollment (program instance) |
| 6 | orgUnit | identifier | Identifier of organisation unit |
| 7 | eventDate | date | Event date |
| 8 | dueDate | date | Due Date |
| 9 | latitude | double | Latitude where event happened |
| 10 | longitude | double | Longitude where event happened |
| 11 | dataElement | identifier | Identifier of data element |
| 12 | value | string | Value / measure of event |
| 13 | storedBy | string | Event was stored by (defaults to current user) |
| 14 | providedElsewhere | boolean | Was this value collected somewhere else |
| 14 | completedDate | date | Completed date of event |
| 14 | completedBy | string | Username of user who completed event |

*Example of 2 events with 2 different data value
    each:*

```csv
EJNxP3WreNP,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,1,,
EJNxP3WreNP,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,2,,
qPEdI1xn7k0,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,3,,
qPEdI1xn7k0,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,4,,
```

#### Import strategy: SYNC { #webapi_sync_import_strategy }

The import strategy SYNC should be used only by internal synchronization
task and not for regular import. The SYNC strategy allows all 3
operations: CREATE, UPDATE, DELETE to be present in the payload at the
same time.

### Tracker Ownership Management { #webapi_tracker_ownership_management }

A new concept called Tracker Ownership is introduced from 2.30. There
will now be one owner organisation unit for a tracked entity instance in
the context of a program. Programs that are configured with an access
level of *PROTECTED* or *CLOSED* will adhere to the ownership
privileges. Only those users belonging to the owning org unit for a
tracked entity-program combination will be able to access the data
related to that program for that tracked entity.

When requesting tracked entities without specifying a program, the response will include only tracked entities that satisfy [metadata sharing settings](#webapi_tracker_metadata_sharing) and one of the following criteria:
- The tracked entity is enrolled in at least one program the user has data access to, and the user has access to the owner organisation unit.
- The tracked entity is not enrolled in any program the user has data access to, but the user has access to the tracked entity registering organisation unit.

#### Tracker Ownership Override : Break the Glass { #webapi_tracker_ownership_override_api }

It is possible to temporarily override the ownership privilege for a program that is configured
with an access level of *PROTECTED*. Any user with the org unit owner within their search scope, can
temporarily access the program-related data by providing a reason for accessing it.

This act of temporarily gaining access is termed *breaking the glass*.
Currently, temporary access is granted for 3 hours. DHIS2 audits breaking the glass along with the
reason specified by the user. It is not possible to gain temporary access to a program that has been
configured with an access level of *CLOSED*.
To break the glass for a TrackedEntity-Program combination, the following POST request can be used:

    /api/33/tracker/ownership/override?trackedEntityInstance=DiszpKrYNg8
      &program=eBAyeGv0exc&reason=patient+showed+up+for+emergency+care

#### Tracker Ownership Transfer { #webapi_tracker_ownership_transfer_api }

It is possible to transfer the ownership of a tracked entity-program
from one org unit to another. This will be useful in case of patient
referrals or migrations. Only an owner (or users who have broken the
glass) can transfer the ownership. To transfer ownership of a tracked
entity-program to another organisation unit, you can issue a PUT request
as shown:

    /api/33/tracker/ownership/transfer?trackedEntityInstance=DiszpKrYNg8
      &program=eBAyeGv0exc&ou=EJNxP3WreNP


## Potential Duplicates  

Potential duplicates are records we work with in the data deduplication feature. Due to the nature of the deduplication feature, this API endpoint is somewhat restricted.

A potential duplicate represents a pair of records which are suspected to be a duplicate.

The payload of a potential duplicate looks like this:

```json
{
  "teiA": "<id>",
  "teiB": "<id>",
  "status": "OPEN|INVALID|MERGED"
}
```

You can retrieve a list of potential duplicates using the following endpoint:

    GET /api/potentialDuplicates

| Parameter name | Description | Type | Allowed values |
|---|---|---|---|
| teis | List of tracked entity instances | List of string (separated by comma)| existing tracked entity instance id |
| status | Potential duplicate status | string | `OPEN <default>`, `INVALID`, `MERGED`, `ALL` |

| Status code | Description
|---|---|
| 400 | Invalid input status

You can inspect individual potential duplicate records:

    GET /api/potentialDuplicates/<id>

| Status code | Description
|---|---|
| 404 | Potential duplicate not found

You can also filter potential duplicates by Tracked Entity Instance (referred as tei) :

    GET /api/potentialDuplicates/tei/<tei>

| Parameter name | Description | Type | Allowed values |
|---|---|---|---|
| status | Potential duplicate status | string | `OPEN`, `INVALID`, `MERGED`, `ALL <default>` |

| Status code | Description
|---|---|
| 400 | Invalid input status
| 403 | User do not have access to read tei
| 404 | Tei not found

To create a new potential duplicate, you can use this endpoint:

    POST /api/potentialDuplicates

The payload you provide must include both teiA and teiB

```json
{
  "teiA": "<id>",
  "teiB": "<id>"
}
```

| Status code | Description
|---|---|
| 400 | Input teiA or teiB is null or has invalid id
| 403 | User do not have access to read teiA or teiB
| 404 | Tei not found
| 409 | Pair of teiA and teiB already existing

To update a potential duplicate status:

    PUT /api/potentialDuplicates/<id>

| Parameter name | Description | Type | Allowed values |
|---|---|---|---|
| status | Potential duplicate status | string | `OPEN`, `INVALID`, `MERGED` |

| Status code | Description
|---|---|
| 400 | You can't update a potential duplicate to MERGED as this is possible only by a merging request
| 400 | You can't update a potential duplicate that is already in a MERGED status

## Flag Tracked Entity Instance as Potential Duplicate

To flag as potential duplicate a Tracked Entity Instance (referred as tei)

 `PUT /api/trackedEntityInstances/{tei}/potentialDuplicate`

| Parameter name | Description | Type | Allowed values |
|---|---|---|---|
| flag | either flag or unflag a tei as potential duplicate | string | `true`, `false` |


| Status code | Description
|---|---|
| 400 | Invalid flag must be true of false
| 403 | User do not have access to update tei
| 404 | Tei not found

## Merging Tracked Entity Instances
Tracked entity instances can now be merged together if they are viable. To initiate a merge, the first step is to define two tracked entity instances as a Potential Duplicate. The merge endpoint
will move data from the duplicate tracked entity instance to the original tracked entity instance, and delete the remaining data of the duplicate.

To merge a Potential Duplicate, or the two tracked entity instances the Potential Duplicate represents, the following endpoint can be used:

    POST /potentialDuplicates/<id>/merge

| Parameter name | Description | Type | Allowed values |
|---|---|---|---|
| mergeStrategy | Strategy to use for merging the potentialDuplicate | enum | AUTO(default) or MANUAL |

The endpoint accepts a single parameter, "mergeStrategy", which decides which strategy to use when merging. For the AUTO strategy, the server will attempt to merge the two tracked entities
automatically, without any input from the user. This strategy only allows merging tracked entities without conflicting data (See examples below). The other strategy, MANUAL, requires the
user to send in a payload describing how the merge should be done. For examples and rules for each strategy, see their respective sections below.

### Merge Strategy AUTO
The automatic merge will evaluate the mergability of the two tracked entity instances, and merge them if they are deemed mergable. The mergability is based on whether the two tracked entity instances
has any conflicts or not. Conflicts refers to data which cannot be merged together automatically. Examples of possible conflicts are:
- The same attribute has different values in each tracked entity instance
- Both tracked entity instances are enrolled in the same program
- Tracked entity instances have different types

If any conflict is encountered, an errormessage is returned to the user.

When no conflicts are found, all data in the duplicate that is not already in the original will be moved over to the original. This includes attribute values, enrollments (Including events) and relationships.
After the merge completes, the duplicate is deleted and the potentialDuplicate is marked as MERGED.

When requesting an automatic merge like this, a payload is not required and will be ignored.

### Merge Strategy MANUAL
The manual merge is suitable when the merge has resolvable conflicts, or when not all the data is required to be moved over during a merge. For example, if an attribute has different values in both tracked
entity instances, the user can specify whether to keep the original value, or move over the duplicate's value. Since the manual merge is the user explicitly requesting to move data, there are some different
checks being done here:
- Relationship cannot be between the original and the duplicate (This results in an invalid self-referencing relationship)
- Relationship cannot be of the same type and to the same object in both tracked entity instances (IE. between original and other, and duplicate and other; This would result in a duplicate relationship)

There are two ways to do a manual merge: With and without a payload.

When a manual merge is requested without a payload, we are telling the API to merge the two tracked entity instances without moving any data. In other words, we are just removing the duplicate and marking the
potentialDuplicate MERGED. This might be valid in a lot of cases where the tracked entity instance was just created, but not enrolled for example.

Otherwise, if a manual merge is requested with a payload, the payload refers to what data should be moved from the duplicate to the original. The payload looks like this:
```json
{
  "trackedEntityAttributes": ["B58KFJ45L9D"],
  "enrollments": ["F61SJ2DhINO"],
  "relationships": ["ETkkZVSNSVw"]
}
```

This payload contains three lists, one for each of the types of data that can be moved. `trackedEntityAttributes` is a list of uids for tracked entity attributes, `enrollments` is a list of uids for enrollments and `relationships`
a list of uids for relationships. The uids in this payload have to refer to data that actually exists on the duplicate. There is no way to add new data or change data using the merge endpoint - Only moving data.


### Additional information about merging
Currently it is not possible to merge tracked entity instances that are enrolled in the same program, due to the added complexity. A workaround is to manually remove the enrollments from one of the tracked entity
instances before starting the merge.

All merging is based on data already persisted in the database, which means the current merging service is not validating that data again. This means if data was already invalid, it will not be reported during the merge.
The only validation done in the service relates to relationships, as mentioned in the previous section.



## Program Notification Template

Program Notification Template lets you create message templates which can be sent as a result of different type of events.
Message and Subject templates will be translated into actual values and can be sent to the configured destination. Each program notification template will be
transformed to either MessageConversation object or ProgramMessage object based on external or internal notificationRecipient. These intermediate objects will
only contain translated message and subject text.
There are multiple configuraiton parameters in Program Notification Tempalte which are critical for correct working of notifications.
All those are explained in the table below.

    POST /api/programNotificationTemplates

```json
{
	"name": "Case notification",
	"notificationTrigger": "ENROLLMENT",
	"subjectTemplate": "Case notification V{org_unit_name}",
	"displaySubjectTemplate": "Case notification V{org_unit_name}",
	"notifyUsersInHierarchyOnly": false,
	"sendRepeatable": false,
	"notificationRecipient": "ORGANISATION_UNIT_CONTACT",
	"notifyParentOrganisationUnitOnly": false,
	"displayMessageTemplate": "Case notification A{h5FuguPFF2j}",
	"messageTemplate": "Case notification A{h5FuguPFF2j}",
	"deliveryChannels": [
		"EMAIL"
	]
}
```

The fields are explained in the following table.


Table: Program Notification Template payload

| Field | Required | Description | Values |
|---|---|---|---|
| name | Yes | name of Program Notification Tempalte | case-notification-alert |
| notificationTrigger | Yes | When notification should be triggered. Possible values are ENROLLMENT, COMPLETION, PROGRAM_RULE, SCHEDULED_DAYS_DUE_DATE| ENROLLMENT |
| subjectTemplate | No | Subject template string | Case notification V{org_unit_name} |
| messageTemplate | Yes | Message template string | Case notification A{h5FuguPFF2j} |
| notificationRecipient | YES | Who is going to receive notification. Possible values are USER_GROUP, ORGANISATION_UNIT_CONTACT, TRACKED_ENTITY_INSTANCE, USERS_AT_ORGANISATION_UNIT, DATA_ELEMENT, PROGRAM_ATTRIBUTE, WEB_HOOK  | USER_GROUP |
| deliveryChannels | No | Which channel should be used for this notification. It can be either SMS, EMAIL or HTTP | SMS |
| sendRepeatable | No | Whether notification should be sent multiple times | false |

NOTE: WEB_HOOK notificationRecipient is used only to POST http request to an external system. Make sure to choose HTTP delivery channel when using WEB_HOOK.

### Retrieving and deleting Program Notification Template

The list of Program Notification Templates can be retrieved using GET.

    GET /api/programNotificationTemplates

For one particular Program Notification Template.

	GET /api/33/programNotificationTemplates/{uid}

To get filtered list of Program Notification Templates

	GET /api/programNotificationTemplates/filter?program=<uid>
	GET /api/programNotificationTemplates/filter?programStage=<uid>

Program Notification Template can be deleted using DELETE.

    DELETE /api/33/programNotificationTemplates/{uid}


## Program Messages

Program message lets you send messages to tracked entity instances,
contact addresses associated with organisation units, phone numbers and
email addresses. You can send messages through the `messages` resource.

    /api/33/messages

### Sending program messages

Program messages can be sent using two delivery channels:

  - SMS (SMS)

  - Email address (EMAIL)

Program messages can be sent to various recipients:

  - Tracked entity instance: The system will look up attributes of value
    type PHONE_NUMBER or EMAIL (depending on the specified delivery
    channels) and use the corresponding attribute values.

  - Organisation unit: The system will use the phone number or email
    information registered for the organisation unit.

  - List of phone numbers: The system will use the explicitly defined
    phone numbers.

  - List of email addresses: The system will use the explicitly defined
    email addresses.

Below is a sample JSON payload for sending messages using POST requests.
Note that message resource accepts a wrapper object named
`programMessages` which can contain any number of program messages.

    POST /api/33/messages

```json
{
  "programMessages": [{
    "recipients": {
      "trackedEntityInstance": {
        "id": "UN810PwyVYO"
      },
      "organisationUnit": {
        "id": "Rp268JB6Ne4"
      },
      "phoneNumbers": [
        "55512345",
        "55545678"
      ],
      "emailAddresses": [
        "johndoe@mail.com",
        "markdoe@mail.com"
      ]
    },
    "programInstance": {
      "id": "f3rg8gFag8j"
    },
    "programStageInstance": {
      "id": "pSllsjpfLH2"
    },
    "deliveryChannels": [
      "SMS", "EMAIL"
    ],
    "notificationTemplate": "Zp268JB6Ne5",
    "subject": "Outbreak alert",
    "text": "An outbreak has been detected",
    "storeCopy": false
  }]
}
```

The fields are explained in the following table.



Table: Program message payload

| Field | Required | Description | Values |
|---|---|---|---|
| recipients | Yes | Recipients of the program message. At least one recipient must be specified. Any number of recipients / types can be specified for a message. | Can be trackedEntityInstance, organisationUnit, an array of phoneNumbers or an array of emailAddresses. |
| programInstance | Either this or programStageInstance required | The program instance / enrollment. | Enrollment ID. |
| programStageInstance | Either this or programInstance required | The program stage instance / event. | Event ID. |
| deliveryChannels | Yes | Array of delivery channels. | SMS &#124; EMAIL |
| subject | No | The message subject. Not applicable for SMS delivery channel. | Text. |
| text | Yes | The message text. | Text. |
| storeCopy | No | Whether to store a copy of the program message in DHIS2. | false (default) &#124; true |

A minimalistic example for sending a message over SMS to a tracked
entity instance looks like this:

```bash
curl -d @message.json "https://play.dhis2.org/demo/api/33/messages"
  -H "Content-Type:application/json" -u admin:district
```

```json
{
  "programMessages": [{
    "recipients": {
      "trackedEntityInstance": {
        "id": "PQfMcpmXeFE"
      }
    },
    "programInstance": {
      "id": "JMgRZyeLWOo"
    },
    "deliveryChannels": [
      "SMS"
    ],
    "text": "Please make a visit on Thursday"
  }]
}
```

### Retrieving and deleting program messages

The list of messages can be retrieved using GET.

    GET /api/33/messages

To get the list of sent tracker messages, the below endpoint can be used. ProgramInstance or ProgramStageInstance uid has to be provided.

	GET /api/33/messages/scheduled/sent?programInstance={uid}
	GET /api/33/messages/scheduled/sent?programStageInstance={uid}

To get the list of all scheduled message

	GET /api/33/messages/scheduled
	GET /api/33/messages/scheduled?scheduledAt=2020-12-12

One particular message can also be retrieved using GET.

    GET /api/33/messages/{uid}

Message can be deleted using DELETE.

    DELETE /api/33/messages/{uid}


### Querying program messages

The program message API supports program message queries based on
request parameters. Messages can be filtered based on below mentioned
query parameters. All requests should use the GET HTTP verb for
retrieving information.



Table: Query program messages API

| Parameter | URL |
|---|---|
| programInstance | /api/33/messages?programInstance=6yWDMa0LP7 |
| programStageInstance | /api/33/messages?programStageInstance=SllsjpfLH2 |
| trackedEntityInstance | /api/33/messages?trackedEntityInstance=xdfejpfLH2 |
| organisationUnit | /api/33/messages?ou=Sllsjdhoe3 |
| processedDate | /api/33/messages?processedDate=2016-02-01 |
