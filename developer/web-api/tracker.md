# Tracker

## Tracker Web API

<!--DHIS2-SECTION-ID:webapi_tracker_api-->

Tracker Web API consists of 3 endpoints that have full CRUD (create,
read, update, delete) support. The 3 endpoints are
`/api/trackedEntityInstances`, `/api/enrollments` and
`/api/events` and they are responsible for tracked entity instance,
enrollment and event items.

### Tracked entity instance management

<!--DHIS2-SECTION-ID:webapi_tracked_entity_instance_management-->

Tracked entity instances have full CRUD support in the API. Together
with the API for enrollment most operations needed for working with
tracked entity instances and programs are supported.

    /api/33/trackedEntityInstances

#### Creating a new tracked entity instance

<!--DHIS2-SECTION-ID:webapi_creating_tei-->

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

#### Updating a tracked entity instance

<!--DHIS2-SECTION-ID:webapi_updating_tei-->

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

#### Deleting a tracked entity instance

<!--DHIS2-SECTION-ID:webapi_deleting_tei-->

In order to delete a tracked entity instance, make a request to the URL
identifying the tracked entity instance with the *DELETE*
method. The URL is equal to the one above used for update.

#### Create and enroll tracked entity instances

<!--DHIS2-SECTION-ID:webapi_create_enroll_tei-->

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

#### Complete example of payload including: tracked entity instance, enrollment and event

<!--DHIS2-SECTION-ID:webapi_create_enroll_tei_create_event-->

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

#### Generated tracked entity instance attributes

<!--DHIS2-SECTION-ID:webapi_generate_tei_attributes-->

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

##### Generate value endpoint

<!--DHIS2-SECTION-ID:webapi_generate_values-->

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

##### Generate and reserve value endpoint

<!--DHIS2-SECTION-ID:webapi_generate_reserve_values-->

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

<table style="width:100%;">
<caption>Reserved values</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 84%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ownerObject</td>
<td>The metadata type referenced when generating and reserving the value. Currently only TRACKEDENTITYATTRIBUTE is supported.</td>
</tr>
<tr class="even">
<td>ownerUid</td>
<td>The uid of the metadata object referenced when generating and reserving the value.</td>
</tr>
<tr class="odd">
<td>key</td>
<td>A partially generated value where generated segments are not yet added.</td>
</tr>
<tr class="even">
<td>value</td>
<td>The fully resolved value reserved. This is the value you send to the server when storing data.</td>
</tr>
<tr class="odd">
<td>created</td>
<td>The timestamp when the reservation was made</td>
</tr>
<tr class="even">
<td>expiryDate</td>
<td>The timestamp when the reservation will no longer be reserved</td>
</tr>
</tbody>
</table>

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

The API also supports a *dimension* parameter. It can take three possible values: `small` (254x254), `medium` (512x512), `large` (1024x1024) or `original`. Image type attributes will be stored in pre-generated sizes
and will be furnished upon request based on the value of the `dimension` parameter.

```bash
curl "http://server/api/33/trackedEntityInstances/ZRyCnJ1qUXS/zDhUuAYrxNC/image?dimension=medium"
```

#### Tracked entity instance query

<!--DHIS2-SECTION-ID:webapi_tracked_entity_instance_query-->

To query for tracked entity instances you can interact with the
`/api/trackedEntityInstances` resource.

    /api/33/trackedEntityInstances

##### Request syntax

<!--DHIS2-SECTION-ID:webapi_tei_query_request_syntax-->

<table style="width:100%;">
<caption>Tracked entity instances query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 84%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>filter</td>
<td>Attributes to use as a filter for the query. Param can be repeated any number of times. Filters can be applied to a dimension on the format &lt;attribute-id&gt;:&lt;operator&gt;:&lt;filter&gt;[:&lt;operator&gt;:&lt;filter&gt;]. Filter values are case-insensitive and can be repeated together with operator any number of times. Operators can be EQ | GT | GE | LT | LE | NE | LIKE | IN.</td>
</tr>
<tr class="even">
<td>ou</td>
<td>Organisation unit identifiers, separated by &quot;;&quot;.</td>
</tr>
<tr class="odd">
<td>ouMode</td>
<td>The mode of selecting organisation units, can be SELECTED | CHILDREN | DESCENDANTS | ACCESSIBLE | CAPTURE | ALL. Default is SELECTED, which refers to the selected selected organisation units only. See table below for explanations.</td>
</tr>
<tr class="even">
<td>program</td>
<td>Program identifier. Restricts instances to being enrolled in the given program.</td>
</tr>
<tr class="odd">
<td>programStatus</td>
<td>Status of the instance for the given program. Can be ACTIVE | COMPLETED | CANCELLED.</td>
</tr>
<tr class="even">
<td>followUp</td>
<td>Follow up status of the instance for the given program. Can be true | false or omitted.</td>
</tr>
<tr class="odd">
<td>programStartDate</td>
<td>Start date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="even">
<td>programEndDate</td>
<td>End date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="odd">
<td>trackedEntity</td>
<td>Tracked entity identifier. Restricts instances to the given tracked instance type.</td>
</tr>
<tr class="even">
<td>page</td>
<td>The page number. Default page is 1.</td>
</tr>
<tr class="odd">
<td>pageSize</td>
<td>The page size. Default size is 50 rows per page.</td>
</tr>
<tr class="even">
<td>totalPages</td>
<td>Indicates whether to include the total number of pages in the paging response (implies higher response time).</td>
</tr>
<tr class="odd">
<td>skipPaging</td>
<td>Indicates whether paging should be ignored and all rows should be returned.</td>
</tr>
<tr class="even">
<td>lastUpdatedStartDate</td>
<td>Filter for events which were updated after this date. Cannot be used together with <em>lastUpdatedDuration</em>.</td>
</tr>
<tr class="odd">
<td>lastUpdatedEndDate</td>
<td>Filter for events which were updated up until this date. Cannot be used together with <em>lastUpdatedDuration</em>.</td>
</tr>
<tr class="even">
<td>lastUpdatedDuration</td>
<td>Include only items which are updated within the given duration. The format is <value><time-unit>, where the supported time units are “d” (days), “h” (hours), “m” (minutes) and “s” (seconds). Cannot be used together with <em>lastUpdatedStartDate</em> and/or <em>lastUpdatedEndDate</em>.</td>
</tr>
<tr class="odd">
<td>assignedUserMode</td>
<td>Restricts result to tei with events assigned based on the assigned user selection mode, can be CURRENT | PROVIDED | NONE | ANY.</td>
</tr>
<tr class="even">
<td>assignedUser</td>
<td>Filter the result down to a limited set of teis with events that are assigned to the given user IDs by using <em>assignedUser=id1;id2</em>.This parameter will be considered only if assignedUserMode is either PROVIDED or null. The API will error out, if for example, assignedUserMode=CURRENT and assignedUser=someId</td>
</tr>
<tr class="odd">
<td>trackedEntityInstance</td>
<td>Filter the result down to a limited set of teis using explicit uids of the tracked entity instances by using <em>trackedEntityInstance=id1;id2</em>. This parameter will at the very least create the outer boundary of the results, forming the list of all teis using the uids provided. If other parameters/filters from this table are used, they will further limit the results from the explicit outer boundary. </td>
</tr>
</tbody>
</table>

The available organisation unit selection modes are explained in the
following table.

<table>
<caption>Organisation unit selection modes</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th>Mode</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>SELECTED</td>
<td>Organisation units defined in the request.</td>
</tr>
<tr class="even">
<td>CHILDREN</td>
<td>The selected organisation units and the immediate children, i.e. the organisation units at the level below.</td>
</tr>
<tr class="odd">
<td>DESCENDANTS</td>
<td>The selected organisation units and all children, i.e. all organisation units in the sub-hierarchy.</td>
</tr>
<tr class="even">
<td>ACCESSIBLE</td>
<td>The data view organisation units associated with the current user and all children, i.e. all organisation units in the sub-hierarchy. Will fall back to data capture organisation units associated with the current user if the former is not defined.</td>
</tr>
<tr class="odd">
<td>CAPTURE</td>
<td>The data capture organisation units associated with the current user and all children, i.e. all organisation units in the sub-hierarchy.</td>
</tr>
<tr class="even">
<td>ALL</td>
<td>All organisation units in the system. Requires the ALL authority.</td>
</tr>
</tbody>
</table>

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

<table>
<caption>Filter operators</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr class="header">
<th>Operator</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>EQ</td>
<td>Equal to</td>
</tr>
<tr class="even">
<td>GT</td>
<td>Greater than</td>
</tr>
<tr class="odd">
<td>GE</td>
<td>Greater than or equal to</td>
</tr>
<tr class="even">
<td>LT</td>
<td>Less than</td>
</tr>
<tr class="odd">
<td>LE</td>
<td>Less than or equal to</td>
</tr>
<tr class="even">
<td>NE</td>
<td>Not equal to</td>
</tr>
<tr class="odd">
<td>LIKE</td>
<td>Like (free text match)</td>
</tr>
<tr class="even">
<td>IN</td>
<td>Equal to one of multiple values separated by &quot;;&quot;</td>
</tr>
</tbody>
</table>

##### Response format

<!--DHIS2-SECTION-ID:webapi_tei_query_response_format-->

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

#### Tracked entity instance grid query

<!--DHIS2-SECTION-ID:webapi_tracked_entity_instance_grid_query-->

To query for tracked entity instances you can interact with the
*/api/trackedEntityInstances/grid* resource. There are two types of
queries: One where a *query* query parameter and optionally *attribute*
parameters are defined, and one where *attribute* and *filter*
parameters are defined. This endpoint uses a more compact "grid" format,
and is an alternative to the query in the previous section.

    /api/33/trackedEntityInstances/query

##### Request syntax

<!--DHIS2-SECTION-ID:webapi_tei_grid_query_request_syntax-->

<table style="width:100%;">
<caption>Tracked entity instances query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 84%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>query</td>
<td>Query string. Attribute query parameter can be used to define which attributes to include in the response. If no attributes but a program is defined, the attributes from the program will be used. If no program is defined, all attributes will be used. There are two formats. The first is a plan query string. The second is on the format &lt;operator&gt;:&lt;query&gt;. Operators can be EQ | LIKE. EQ implies exact matches on words, LIKE implies partial matches on words. The query will be split on space, where each word will form a logical AND query.</td>
</tr>
<tr class="even">
<td>attribute</td>
<td>Attributes to be included in the response. Can also be used as a filter for the query. Param can be repeated any number of times. Filters can be applied to a dimension on the format &lt;attribute-id&gt;:&lt;operator&gt;:&lt;filter&gt;[:&lt;operator&gt;:&lt;filter&gt;]. Filter values are case-insensitive and can be repeated together with operator any number of times. Operators can be EQ | GT | GE | LT | LE | NE | LIKE | IN. Filters can be omitted in order to simply include the attribute in the response without any constraints.</td>
</tr>
<tr class="odd">
<td>filter</td>
<td>Attributes to use as a filter for the query. Param can be repeated any number of times. Filters can be applied to a dimension on the format &lt;attribute-id&gt;:&lt;operator&gt;:&lt;filter&gt;[:&lt;operator&gt;:&lt;filter&gt;]. Filter values are case-insensitive and can be repeated together with operator any number of times. Operators can be EQ | GT | GE | LT | LE | NE | LIKE | IN.</td>
</tr>
<tr class="even">
<td>ou</td>
<td>Organisation unit identifiers, separated by &quot;;&quot;.</td>
</tr>
<tr class="odd">
<td>ouMode</td>
<td>The mode of selecting organisation units, can be SELECTED | CHILDREN | DESCENDANTS | ACCESSIBLE | ALL. Default is SELECTED, which refers to the selected organisation units only. See table below for explanations.</td>
</tr>
<tr class="even">
<td>program</td>
<td>Program identifier. Restricts instances to being enrolled in the given program.</td>
</tr>
<tr class="odd">
<td>programStatus</td>
<td>Status of the instance for the given program. Can be ACTIVE | COMPLETED | CANCELLED.</td>
</tr>
<tr class="even">
<td>followUp</td>
<td>Follow up status of the instance for the given program. Can be true | false or omitted.</td>
</tr>
<tr class="odd">
<td>programStartDate</td>
<td>Start date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="even">
<td>programEndDate</td>
<td>End date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="odd">
<td>trackedEntity</td>
<td>Tracked entity identifier. Restricts instances to the given tracked instance type.</td>
</tr>
<tr class="even">
<td>eventStatus</td>
<td>Status of any event associated with the given program and the tracked entity instance. Can be ACTIVE | COMPLETED | VISITED | SCHEDULED | OVERDUE | SKIPPED.</td>
</tr>
<tr class="odd">
<td>eventStartDate</td>
<td>Start date of event associated with the given program and event status.</td>
</tr>
<tr class="even">
<td>eventEndDate</td>
<td>End date of event associated with the given program and event status.</td>
</tr>
<tr class="odd">
<td>programStage</td>
<td>The programStage for which the event related filters should be applied to. If not provided all stages will be considered.</td>
</tr>
<tr class="even">
<td>skipMeta</td>
<td>Indicates whether meta data for the response should be included.</td>
</tr>
<tr class="odd">
<td>page</td>
<td>The page number. Default page is 1.</td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>The page size. Default size is 50 rows per page.</td>
</tr>
<tr class="odd">
<td>totalPages</td>
<td>Indicates whether to include the total number of pages in the paging response (implies higher response time).</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>Indicates whether paging should be ignored and all rows should be returned.</td>
</tr>
<tr class="odd">
<td>assignedUserMode</td>
<td>Restricts result to tei with events assigned based on the assigned user selection mode, can be CURRENT | PROVIDED | NONE | ANY.</td>
</tr>
<tr class="even">
<td>assignedUser</td>
<td>Filter the result down to a limited set of teis with events that are assigned to the given user IDs by using <em>assignedUser=id1;id2</em>.This parameter will be considered only if assignedUserMode is either PROVIDED or null. The API will error out, if for example, assignedUserMode=CURRENT and assignedUser=someId</td>
</tr>
<tr class="odd">
<td>trackedEntityInstance</td>
<td>Filter the result down to a limited set of teis using explicit uids of the tracked entity instances by using <em>trackedEntityInstance=id1;id2</em>. This parameter will at the very least create the outer boundary of the results, forming the list of all teis using the uids provided. If other parameters/filters from this table are used, they will further limit the results from the explicit outer boundary. </td>
</tr>
</tbody>
</table>

The available organisation unit selection modes are explained in the
following table.

<table>
<caption>Organisation unit selection modes</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th>Mode</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>SELECTED</td>
<td>Organisation units defined in the request.</td>
</tr>
<tr class="even">
<td>CHILDREN</td>
<td>Immediate children, i.e. only the first level below, of the organisation units defined in the request.</td>
</tr>
<tr class="odd">
<td>DESCENDANTS</td>
<td>All children, i.e. at only levels below, e.g. including children of children, of the organisation units defined in the request.</td>
</tr>
<tr class="even">
<td>ACCESSIBLE</td>
<td>All descendants of the data view organisation units associated with the current user. Will fall back to data capture organisation units associated with the current user if the former is not defined.</td>
</tr>
<tr class="odd">
<td>CAPTURE</td>
<td>The data capture organisation units associated with the current user and all children, i.e. all organisation units in the sub-hierarchy.</td>
</tr>
<tr class="even">
<td>ALL</td>
<td>All organisation units in the system. Requires authority.</td>
</tr>
</tbody>
</table>

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
      &program=ur1Edk5Oe2n&eventStatus=LATE_VISIT
      &eventStartDate=2014-01-01&eventEndDate=2014-09-01

You can use a range of operators for the filtering:

<table>
<caption>Filter operators</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr class="header">
<th>Operator</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>EQ</td>
<td>Equal to</td>
</tr>
<tr class="even">
<td>GT</td>
<td>Greater than</td>
</tr>
<tr class="odd">
<td>GE</td>
<td>Greater than or equal to</td>
</tr>
<tr class="even">
<td>LT</td>
<td>Less than</td>
</tr>
<tr class="odd">
<td>LE</td>
<td>Less than or equal to</td>
</tr>
<tr class="even">
<td>NE</td>
<td>Not equal to</td>
</tr>
<tr class="odd">
<td>LIKE</td>
<td>Like (free text match)</td>
</tr>
<tr class="even">
<td>IN</td>
<td>Equal to one of multiple values separated by &quot;;&quot;</td>
</tr>
</tbody>
</table>

##### Response format

<!--DHIS2-SECTION-ID:webapi_tei_grid_query_response_format-->

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

#### Tracked entity instance filters

<!--DHIS2-SECTION-ID:webapi_tei_filters-->

To create, read, update and delete tracked entity instance filters you
can interact with the */api/trackedEntityInstanceFilters* resource.

    /api/33/trackedEntityInstanceFilters

##### Create and update a tracked entity instance filter definition

For creating and updating a tracked entity instance filter in the
system, you will be working with the *trackedEntityInstanceFilters*
resource. The tracked entity instance filter definitions are used in the
Tracker Capture app to display relevant predefined "Working lists" in
the tracker user interface.

<table>
<caption>Payload</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Payload values</th>
<th>Description</th>
<th>Example</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>Name of the filter. Required.</td>
<td></td>
</tr>
<tr class="even">
<td>description</td>
<td>A description of the filter.</td>
<td></td>
</tr>
<tr class="odd">
<td>sortOrder</td>
<td>The sort order of the filter. Used in Tracker Capture to order the filters in the program dashboard.</td>
<td></td>
</tr>
<tr class="even">
<td>style</td>
<td>Object containing css style.</td>
<td>( &quot;color&quot;: &quot;blue&quot;, &quot;icon&quot;: &quot;fa fa-calendar&quot;}</td>
</tr>
<tr class="odd">
<td>program</td>
<td>Object containing the id of the program. Required.</td>
<td>{ &quot;id&quot; : &quot;uy2gU8kTjF&quot;}</td>
</tr>
<tr class="even">
<td>enrollmentStatus</td>
<td>The TEIs enrollment status. Can be none(any enrollmentstatus) or ACTIVE|COMPLETED|CANCELED</td>
<td></td>
</tr>
<tr class="odd">
<td>followup</td>
<td>When this parameter is true, the filter only returns TEIs that have an enrollment with status followup.</td>
<td></td>
</tr>
<tr class="even">
<td>enrollmentCreatedPeriod</td>
<td>Period object containing a period in which the enrollment must be created. See <em>Period</em> definition table below.</td>
<td>{ &quot;periodFrom&quot;: -15, &quot;periodTo&quot;: 15}</td>
</tr>
<tr class="odd">
<td>eventFilters</td>
<td>A list of eventFilters. See <em>Event filters</em> definition table below.</td>
<td>[{&quot;programStage&quot;: &quot;eaDH9089uMp&quot;, &quot;eventStatus&quot;: &quot;OVERDUE&quot;, &quot;eventCreatedPeriod&quot;: {&quot;periodFrom&quot;: -15, &quot;periodTo&quot;: 15}}]</td>
</tr>
</tbody>
</table>

<table>
<caption>Event filters definition</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td>programStage</td>
<td>Which programStage the TEI needs an event in to be returned.</td>
<td>&quot;eaDH9089uMp&quot;</td>
</tr>
<tr class="even">
<td>eventStatus</td>
<td>The events status. Can be none(any event status) or ACTIVE|COMPLETED|SCHEDULED|OVERDUE</td>
<td>ACTIVE</td>
</tr>
<tr class="odd">
<td>eventCreatedPeriod</td>
<td>Period object containing a period in which the event must be created. See <em>Period</em> definition below.</td>
<td>{ &quot;periodFrom&quot;: -15, &quot;periodTo&quot;: 15}</td>
</tr>
<tr class="even">
<td>assignedUserMode</td>
<td>To specify the assigned user selection mode for events. Possible values are CURRENT (events assigned to current user)| PROVIDED (events assigned to users provided in "assignedUsers" list) | NONE (events assigned to no one) | ANY (events assigned to anyone). If PROVIDED (or null), non-empty assignedUsers in the payload will be considered.</td>
<td>"assignedUserMode": "PROVIDED"</td>
</tr>
<tr class="odd">
<td>assignedUsers</td>
<td>To specify a list of assigned users for events. To be used along with PROVIDED assignedUserMode above.</td>
<td>"assignedUsers": ["a3kGcGDCuk7", "a3kGcGDCuk8"]</td>
</tr>
</tbody>
</table>

<table>
<caption>Period definition</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td>periodFrom</td>
<td>Number of days from current day. Can be positive or negative integer.</td>
<td>-15</td>
</tr>
<tr class="even">
<td>periodTo</td>
<td>Number of days from current day. Must be bigger than periodFrom. Can be positive or negative integer.</td>
<td>15</td>
</tr>
</tbody>
</table>

##### Tracked entity instance filters query

To query for tracked entity instance filters in the system, you can
interact with the */api/trackedEntityInstanceFilters* resource.

<table>
<caption>Tracked entity instance filters query parameters</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>program</td>
<td>Program identifier. Restricts filters to the given program.</td>
</tr>
</tbody>
</table>

### Enrollment management

<!--DHIS2-SECTION-ID:webapi_enrollment_management-->

Enrollments have full CRUD support in the API. Together with the API
for tracked entity instances most operations needed for working with
tracked entity instances and programs are supported.

    /api/33/enrollments

#### Enrolling a tracked entity instance into a program

<!--DHIS2-SECTION-ID:webapi_enrolling_tei-->

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

#### Enrollment instance query

<!--DHIS2-SECTION-ID:webapi_enrollment_instance_query-->

To query for enrollments you can interact with the */api/enrollments*
resource.

    /api/33/enrollments

##### Request syntax

<!--DHIS2-SECTION-ID:webapi_enrollment_query_request_syntax-->

<table style="width:100%;">
<caption>Enrollment query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 84%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ou</td>
<td>Organisation unit identifiers, separated by &quot;;&quot;.</td>
</tr>
<tr class="even">
<td>ouMode</td>
<td>The mode of selecting organisation units, can be SELECTED | CHILDREN | DESCENDANTS | ACCESSIBLE | CAPTURE | ALL. Default is SELECTED, which refers to the selected organisation units only. See table below for explanations.</td>
</tr>
<tr class="odd">
<td>program</td>
<td>Program identifier. Restricts instances to being enrolled in the given program.</td>
</tr>
<tr class="even">
<td>programStatus</td>
<td>Status of the instance for the given program. Can be ACTIVE | COMPLETED | CANCELLED.</td>
</tr>
<tr class="odd">
<td>followUp</td>
<td>Follow up status of the instance for the given program. Can be true | false or omitted.</td>
</tr>
<tr class="even">
<td>programStartDate</td>
<td>Start date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="odd">
<td>programEndDate</td>
<td>End date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="even">
<td>lastUpdatedDuration</td>
<td>Include only items which are updated within the given duration. The format is <value><time-unit>, where the supported time units are “d” (days), “h” (hours), “m” (minutes) and “s” (seconds).</td>
</tr>
<tr class="odd">
<td>trackedEntity</td>
<td>Tracked entity identifier. Restricts instances to the given tracked instance type.</td>
</tr>
<tr class="even">
<td>trackedEntityInstance</td>
<td>Tracked entity instance identifier. Should not be used together with trackedEntity.</td>
</tr>
<tr class="odd">
<td>page</td>
<td>The page number. Default page is 1.</td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>The page size. Default size is 50 rows per page.</td>
</tr>
<tr class="odd">
<td>totalPages</td>
<td>Indicates whether to include the total number of pages in the paging response (implies higher response time).</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>Indicates whether paging should be ignored and all rows should be returned.</td>
</tr>
<tr class="odd">
<td>includeDeleted</td>
<td>Indicates whether to include soft deleted enrollments or not. It is false by default.</td>
</tr>
</tbody>
</table>

The available organisation unit selection modes are explained in the
following table.

<table>
<caption>Organisation unit selection modes</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th>Mode</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>SELECTED</td>
<td>Organisation units defined in the request (default).</td>
</tr>
<tr class="even">
<td>CHILDREN</td>
<td>Immediate children, i.e. only the first level below, of the organisation units defined in the request.</td>
</tr>
<tr class="odd">
<td>DESCENDANTS</td>
<td>All children, i.e. at only levels below, e.g. including children of children, of the organisation units defined in the request.</td>
</tr>
<tr class="even">
<td>ACCESSIBLE</td>
<td>All descendants of the data view organisation units associated with the current user. Will fall back to data capture organisation units associated with the current user if the former is not defined.</td>
</tr>
<tr class="odd">
<td>ALL</td>
<td>All organisation units in the system. Requires authority.</td>
</tr>
</tbody>
</table>

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

##### Response format

<!--DHIS2-SECTION-ID:webapi_enrollment_query_response_format-->

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

### Events

<!--DHIS2-SECTION-ID:webapi_events-->

This section is about sending and reading events.

    /api/33/events

#### Sending events

<!--DHIS2-SECTION-ID:webapi_sending_events-->

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
called *event.xml* and send it as a POST request to the events resource
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

<table>
<caption>Events resource format</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 8%" />
<col style="width: 8%" />
<col style="width: 30%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Type</th>
<th>Required</th>
<th>Options (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>program</td>
<td>string</td>
<td>true</td>
<td></td>
<td>Identifier of the single event with no registration program</td>
</tr>
<tr class="even">
<td>orgUnit</td>
<td>string</td>
<td>true</td>
<td></td>
<td>Identifier of the organisation unit where the event took place</td>
</tr>
<tr class="odd">
<td>eventDate</td>
<td>date</td>
<td>true</td>
<td></td>
<td>The date of when the event occurred</td>
</tr>
<tr class="even">
<td>completedDate</td>
<td>date</td>
<td>false</td>
<td></td>
<td>The date of when the event is completed. If not provided, the current date is selected as the event completed date</td>
</tr>
<tr class="odd">
<td>status</td>
<td>enum</td>
<td>false</td>
<td>ACTIVE | COMPLETED | VISITED | SCHEDULE | OVERDUE | SKIPPED</td>
<td>Whether the event is complete or not</td>
</tr>
<tr class="even">
<td>storedBy</td>
<td>string</td>
<td>false</td>
<td>Defaults to current user</td>
<td>Who stored this event (can be username, system-name, etc)</td>
</tr>
<tr class="odd">
<td>coordinate</td>
<td>double</td>
<td>false</td>
<td></td>
<td>Refers to where the event took place geographically (latitude and longitude)</td>
</tr>
<tr class="even">
<td>dataElement</td>
<td>string</td>
<td>true</td>
<td></td>
<td>Identifier of data element</td>
</tr>
<tr class="odd">
<td>value</td>
<td>string</td>
<td>true</td>
<td></td>
<td>Data value or measure for this event</td>
</tr>
</tbody>
</table>

##### OrgUnit matching

By default the orgUnit parameter will match on the
ID, you can also select the orgUnit id matching scheme by using the
parameter orgUnitIdScheme=SCHEME, where the options are: *ID*, *UID*,
*UUID*, *CODE*, and *NAME*. There is also the *ATTRIBUTE:* scheme, which
matches on a *unique* metadata attribute value.

#### Updating events

<!--DHIS2-SECTION-ID:webapi_updating_events-->

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

#### Deleting events

<!--DHIS2-SECTION-ID:webapi_deleting_events-->

To delete an existing event, all you need is to send a DELETE request
with an identifier reference to the server you are using.

```bash
curl -X DELETE "localhost/api/33/events/ID" -u admin:district
```

#### Assigning user to events

<!--DHIS2-SECTION-ID:webapi_user_assign_event-->

A user can be assigned to an event. This can be done by including the appropriate property in the payload when updating or creating the event.

      "assignedUser": "<id>"

The id refers to the if of the user. Only one user can be assigned to an event at a time.

User assignment must be enabled in the program stage before users can be assigned to events.
#### Getting events

<!--DHIS2-SECTION-ID:webapi_getting_events-->

To get an existing event you can issue a GET request including the
identifier like this:

```bash
curl "http://localhost/api/33/events/ID" -H "Content-Type: application/xml" -u admin:district
```

#### Querying and reading events

<!--DHIS2-SECTION-ID:webapi_querying_reading_events-->

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

<table>
<caption>Events resource query parameters</caption>
<thead>
<tr class="header">
<th>Key</th>
<th>Type</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>program</td>
<td>identifier</td>
<td>true (if not programStage is provided)</td>
<td>Identifier of program</td>
</tr>
<tr class="even">
<td>programStage</td>
<td>identifier</td>
<td>false</td>
<td>Identifier of program stage</td>
</tr>
<tr class="odd">
<td>programStatus</td>
<td>enum</td>
<td>false</td>
<td>Status of event in program, ca be ACTIVE | COMPLETED | CANCELLED</td>
</tr>
<tr class="even">
<td>followUp</td>
<td>boolean</td>
<td>false</td>
<td>Whether event is considered for follow up in program, can be true | false or omitted.</td>
</tr>
<tr class="odd">
<td>trackedEntityInstance</td>
<td>identifier</td>
<td>false</td>
<td>Identifier of tracked entity instance</td>
</tr>
<tr class="even">
<td>orgUnit</td>
<td>identifier</td>
<td>true</td>
<td>Identifier of organisation unit</td>
</tr>
<tr class="odd">
<td>ouMode</td>
<td>enum</td>
<td>false</td>
<td>Org unit selection mode, can be SELECTED | CHILDREN | DESCENDANTS</td>
</tr>
<tr class="even">
<td>startDate</td>
<td>date</td>
<td>false</td>
<td>Only events newer than this date</td>
</tr>
<tr class="odd">
<td>endDate</td>
<td>date</td>
<td>false</td>
<td>Only events older than this date</td>
</tr>
<tr class="even">
<td>status</td>
<td>enum</td>
<td>false</td>
<td>Status of event, can be ACTIVE | COMPLETED | VISITED | SCHEDULED | OVERDUE | SKIPPED</td>
</tr>
<tr class="odd">
<td>lastUpdatedStartDate</td>
<td>date</td>
<td>false</td>
<td>Filter for events which were updated after this date. Cannot be used together with <em>lastUpdatedDuration</em>.</td>
</tr>
<tr class="even">
<td>lastUpdatedEndDate</td>
<td>date</td>
<td>false</td>
<td>Filter for events which were updated up until this date. Cannot be used together with <em>lastUpdatedDuration</em>.</td>
</tr>
<tr class="odd">
<td>lastUpdatedDuration</td>
<td>string</td>
<td>false</td>
<td>Include only items which are updated within the given duration. The format is <value><time-unit>, where the supported time units are “d” (days), “h” (hours), “m” (minutes) and “s” (seconds). Cannot be used together with <em>lastUpdatedStartDate</em> and/or <em>lastUpdatedEndDate</em>.</td>
</tr>
<tr class="even">
<td>skipMeta</td>
<td>boolean</td>
<td>false</td>
<td>Exclude the meta data part of response (improves performance)</td>
</tr>
<tr class="odd">
<td>page</td>
<td>integer</td>
<td>false</td>
<td>Page number</td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>integer</td>
<td>false</td>
<td>Number of items in each page</td>
</tr>
<tr class="odd">
<td>totalPages</td>
<td>boolean</td>
<td>false</td>
<td>Indicates whether to include the total number of pages in the paging response.</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>boolean</td>
<td>false</td>
<td>Indicates whether to skip paging in the query and return all events.</td>
</tr>
<tr class="odd">
<td>dataElementIdScheme</td>
<td>string</td>
<td>false</td>
<td>Data element ID scheme to use for export, valid options are UID, CODE and ATTRIBUTE:{ID}</td>
</tr>
<tr class="even">
<td>categoryOptionComboIdScheme</td>
<td>string</td>
<td>false</td>
<td>Category Option Combo ID scheme to use for export, valid options are UID, CODE and
ATTRIBUTE:{ID}</td>
</tr>
<tr class="odd">
<td>orgUnitIdScheme</td>
<td>string</td>
<td>false</td>
<td>Organisation Unit ID scheme to use for export, valid options are UID, CODE and
ATTRIBUTE:{ID}</td>
</tr>
<tr class="even">
<td>programIdScheme</td>
<td>string</td>
<td>false</td>
<td>Program ID scheme to use for export, valid options are UID, CODE and ATTRIBUTE:{ID}</td>
</tr>
<tr class="odd">
<td>programStageIdScheme</td>
<td>string</td>
<td>false</td>
<td>Program Stage ID scheme to use for export, valid options are UID, CODE and ATTRIBUTE:{ID}</td>
</tr>
<tr class="even">
<td>idScheme</td>
<td>string</td>
<td>false</td>
<td>Allows to set id scheme for data element, category option combo, orgUnit, program and program
stage at once.</td>
</tr>
<tr class="odd">
<td>order</td>
<td>string</td>
<td>false</td>
<td>The order of which to retrieve the events from the API. Usage: order=&lt;property&gt;:asc/desc - Ascending order is default.
<p>Properties: event | program | programStage | enrollment | enrollmentStatus | orgUnit | orgUnitName | trackedEntityInstance | eventDate | followup | status | dueDate | storedBy | created | lastUpdated | completedBy | completedDate</p>
<pre><code>order=orgUnitName:DESC</code></pre>
<pre><code>order=lastUpdated:ASC</code></pre></td>
</tr>
<tr class="even">
<td>event</td>
<td>comma delimited string</td>
<td>false</td>
<td>Filter the result down to a limited set of IDs by using <em>event=id1;id2</em>.</td>
</tr>
<tr class="odd">
<td>skipEventId</td>
<td>boolean</td>
<td>false</td>
<td>Skips event identifiers in the response</td>
</tr>
<tr class="even">
<td>attributeCc (**)</td>
<td>string</td>
<td>false</td>
<td>Attribute category combo identifier (must be combined with <em>attributeCos</em>)</td>
</tr>
<tr class="odd">
<td>attributeCos (**)</td>
<td>string</td>
<td>false</td>
<td>Attribute category option identifiers, separated with ; (must be combined with <em>attributeCc</em>)</td>
</tr>
<tr class="even">
<td>async</td>
<td>false | true</td>
<td>false</td>
<td>Indicates whether the import should be done asynchronous or synchronous.</td>
</tr>
<tr class="odd">
<td>includeDeleted</td>
<td>boolean</td>
<td>false</td>
<td>When true, soft deleted events will be included in your query result.</td>
</tr>
<tr class="even">
<td>assignedUserMode</td>
<td>enum</td>
<td>false</td>
<td>Assigned user selection mode, can be CURRENT | PROVIDED | NONE | ANY.</td>
</tr>
<tr class="odd">
<td>assignedUser</td>
<td>comma delimited strings</td>
<td>false</td>
<td>Filter the result down to a limited set of events that are assigned to the given user IDs by using <em>assignedUser=id1;id2</em>. This parameter will be considered only if assignedUserMode is either PROVIDED or null. The API will error out, if for example, assignedUserMode=CURRENT and assignedUser=someId</td>
</tr>
</tbody>
</table>

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

#### Event filters

<!--DHIS2-SECTION-ID:webapi_event_filters-->

To create, read, update and delete event filters you
can interact with the `/api/eventFilters` resource.

    /api/33/eventFilters

##### Create and update an event filter definition

For creating and updating an event filter in the
system, you will be working with the *eventFilters*
resource. *POST* is used to create and *PUT* method is used to update. The event filter definitions are used in the
Tracker Capture app to display relevant predefined "Working lists" in
the tracker user interface.

<table>
<caption>Request Payload</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Request Property</th>
<th>Description</th>
<th>Example</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>Name of the filter.</td>
<td>"name":"My working list"</td>
</tr>
<tr class="even">
<td>description</td>
<td>A description of the filter.</td>
<td>"description":"for listing all events assigned to me".</td>
</tr>
<tr class="odd">
<td>program</td>
<td>The uid of the program.</td>
<td>"program" : "a3kGcGDCuk6"</td>
</tr>
<tr class="even">
<td>programStage</td>
<td>The uid of the program stage.</td>
<td>"programStage" : "a3kGcGDCuk6"</td>
</tr>
<tr class="even">
<td>eventQueryCriteria</td>
<td>Object containing parameters for querying, sorting and filtering events.</td>
<td>  
  "eventQueryCriteria": {
    "organisationUnit":"a3kGcGDCuk6",
    "status": "COMPLETED",
    "createdDate": {
      "from": "2014-05-01",
      "to": "2019-03-20"
    },
    "dataElements": ["a3kGcGDCuk6:EQ:1", "a3kGcGDCuk6"],
    "filters": ["a3kGcGDCuk6:EQ:1"],
    "programStatus": "ACTIVE",
    "ouMode": "SELECTED",
    "assignedUserMode": "PROVIDED",
    "assignedUsers" : ["a3kGcGDCuk7", "a3kGcGDCuk8"],
    "followUp": false,
    "trackedEntityInstance": "a3kGcGDCuk6",
    "events": ["a3kGcGDCuk7", "a3kGcGDCuk8"],
    "fields": "eventDate,dueDate",
    "order": "dueDate:asc,createdDate:desc"
  }
</td>
</tr>
</tbody>
</table>

<table>
<caption>Event Query Criteria definition</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td>followUp</td>
<td>Used to filter events based on enrollment followUp flag. Possible values are true|false.</td>
<td>"followUp": true</td>
</tr>
<tr class="even">
<td>organisationUnit</td>
<td>To specify the uid of the organisation unit</td>
<td>"organisationUnit": "a3kGcGDCuk7"</td>
</tr>
<tr class="odd">
<td>ouMode</td>
<td>To specify the OU selection mode. Possible values are SELECTED| CHILDREN|DESCENDANTS|ACCESSIBLE|CAPTURE|ALL</td>
<td>"ouMode": "SELECTED"</td>
</tr>
<tr class="even">
<td>assignedUserMode</td>
<td>To specify the assigned user selection mode for events. Possible values are CURRENT| PROVIDED| NONE | ANY. See table below to understand what each value indicates. If PROVIDED (or null), non-empty assignedUsers in the payload will be considered.</td>
<td>"assignedUserMode": "PROVIDED"</td>
</tr>
<tr class="odd">
<td>assignedUsers</td>
<td>To specify a list of assigned users for events. To be used along with PROVIDED assignedUserMode above.</td>
<td>"assignedUsers": ["a3kGcGDCuk7", "a3kGcGDCuk8"]</td>
</tr>
<tr class="even">
<td>displayOrderColumns</td>
<td>To specify the output ordering of columns</td>
<td>"displayOrderColumns": ["eventDate", "dueDate", "program"]</td>
</tr>
<tr class="odd">
<td>order</td>
<td>To specify ordering/sorting of fields and its directions in comma separated values. A single item in order is of the form "dataItem:direction".</td>
<td>"order"="a3kGcGDCuk6:desc,eventDate:asc"</td>
</tr>
<tr class="even">
<td>dataFilters</td>
<td>To specify filters to be applied when listing events</td>
<td>"dataFilters"=[{
      "dataItem": "abcDataElementUid",
      "le": "20",
      "ge": "10",
      "lt": "20",
      "gt": "10",
      "in": ["India", "Norway"],
      "like": "abc",
      "dateFilter": {
        "startDate": "2014-05-01",
        "endDate": "2019-03-20",
        "startBuffer": -5,
        "endBuffer": 5,
        "period": "LAST_WEEK",
        "type": "RELATIVE"
      }
    }]</td>
</tr>
<tr class="odd">
<td>status</td>
<td> Any valid EventStatus</td>
<td>  "eventStatus": "COMPLETED"</td>
</tr>
<tr class="even">
<td>events</td>
<td>To specify list of events</td>
<td>"events"=["a3kGcGDCuk6"]</td>
</tr>
<tr class="odd">
<td>completedDate</td>
<td>DateFilterPeriod object date filtering based on completed date.</td>
<td>
  "completedDate": {
    "startDate": "2014-05-01",
    "endDate": "2019-03-20",
    "startBuffer": -5,
    "endBuffer": 5,
    "period": "LAST_WEEK",
    "type": "RELATIVE"
  }
</td>
</tr>
<tr class="even">
<td>eventDate</td>
<td>DateFilterPeriod object date filtering based on event date.</td>
<td>
  "eventDate": {
    "startBuffer": -5,
    "endBuffer": 5,
    "type": "RELATIVE"
  }
</td>
</tr>
<tr class="odd">
<td>dueDate</td>
<td>DateFilterPeriod object date filtering based on due date.</td>
<td>
  "dueDate": {
    "period": "LAST_WEEK",
    "type": "RELATIVE"
  }
</td>
</tr>
<tr class="even">
<td>lastUpdatedDate</td>
<td>DateFilterPeriod object date filtering based on last updated date.</td>
<td>
  "lastUpdatedDate": {
    "startDate": "2014-05-01",
    "endDate": "2019-03-20",
    "type": "ABSOLUTE"
  }
</td>
</tr>

</tbody>
</table>

<table>
<caption>DateFilterPeriod object definition</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td>type</td>
<td>Specify whether the date period type is ABSOLUTE | RELATIVE</td>
<td>"type" : "RELATIVE"</td>
</tr>
<tr class="even">
<td>period</td>
<td>Specify if a relative system defined period is to be used. Applicable only when "type" is RELATIVE. (see <a href="#webapi_date_relative_period_values">Relative Periods</a> for supported relative periods)</td>
<td>"period" : "THIS_WEEK"</td>
</tr>
<tr class="odd">
<td>startDate</td>
<td>Absolute start date. Applicable only when "type" is ABSOLUTE</td>
<td>"startDate":"2014-05-01"</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>Absolute end date. Applicable only when "type" is ABSOLUTE</td>
<td>"startDate":"2014-05-01"</td>
</tr>
<tr class="odd">
<td>startBuffer</td>
<td>Relative custom start date. Applicable only when "type" is RELATIVE</td>
<td>"startBuffer":-10</td>
</tr>
<tr class="even">
<td>endBuffer</td>
<td>Relative custom end date. Applicable only when "type" is RELATIVE</td>
<td>"startDate":+10</td>
</tr>
</tbody>
</table>

The available assigned user selection modes are explained in the
following table.

<table>
<caption>Assigned user selection modes (event assignment)</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th>Mode</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>CURRENT</td>
<td>Assigned to the current logged in user</td>
</tr>
<tr class="even">
<td>PROVIDED</td>
<td>Assigned to the users provided in the "assignedUser" parameter</td>
</tr>
<tr class="odd">
<td>NONE</td>
<td>Assigned to no users.</td>
</tr>
<tr class="even">
<td>ANY</td>
<td>Assigned to any users.</td>
</tr>
</tbody>
</table>

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

List all relationships require you to provide the UID of the trackedEntityInstance, Enrollment or event that you want to list all the relationships for:  

    GET /api/relationships?tei=ABCDEF12345
    GET /api/relationships?enrollment=ABCDEF12345
    GET /api/relationships?event=ABCDEF12345

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

### Update strategies

<!--DHIS2-SECTION-ID:webapi_tei_update_strategies-->

Two update strategies for all 3 tracker endpoints are supported:
enrollment and event creation. This is useful when you have generated an
identifier on the client side and are not sure if it was created or not
on the server.

<table>
<caption>Available tracker strategies</caption>
<colgroup>
<col style="width: 24%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>CREATE</td>
<td>Create only, this is the default behavior.</td>
</tr>
<tr class="even">
<td>CREATE_AND_UPDATE</td>
<td>Try and match the ID, if it exist then update, if not create.</td>
</tr>
</tbody>
</table>

To change the parameter, please use the strategy parameter:

    POST /api/33/trackedEntityInstances?strategy=CREATE_AND_UPDATE

### Tracker bulk deletion

<!--DHIS2-SECTION-ID:webapi_tracker_bulk_deletion-->

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

### Identifier reuse and item deletion via POST and PUT methods

<!--DHIS2-SECTION-ID:webapi_updating_and_deleting_items-->

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

### Import parameters

<!--DHIS2-SECTION-ID:webapi_import_parameters-->

The import process can be customized using a set of import parameters:

<table>
<caption>Import parameters</caption>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Values (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dataElementIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the data element object to use to map the data values.</td>
</tr>
<tr class="even">
<td>orgUnitIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the org unit object to use to map the data values.</td>
</tr>
<tr class="odd">
<td>idScheme</td>
<td>id | name | code| attribute:ID</td>
<td>Property of all objects including data elements, org units and category option combos, to use to map the data values.</td>
</tr>
<tr class="even">
<td>dryRun</td>
<td>false | true</td>
<td>Whether to save changes on the server or just return the import summary.</td>
</tr>
<tr class="odd">
<td>strategy</td>
<td>CREATE | UPDATE | CREATE_AND_UPDATE | DELETE</td>
<td>Save objects of all, new or update import status on the server.</td>
</tr>
<tr class="even">
<td>skipNotifications</td>
<td>true | false</td>
<td>Indicates whether to send notifications for completed events.</td>
</tr>
<tr class="odd">
<td>skipFirst</td>
<td>true | false</td>
<td>Relevant for CSV import only. Indicates whether CSV file contains a header row which should be skipped.</td>
</tr>
<tr class="even">
<td>importReportMode</td>
<td>FULL, ERRORS, DEBUG</td>
<td>Sets the `ImportReport` mode, controls how much is reported back after the import is done. `ERRORS` only includes <em>ObjectReports</em> for object which has errors. `FULL` returns an <em>ObjectReport</em> for all objects imported, and `DEBUG` returns the same plus a name for the object (if available).</td>
</tr>
</tbody>
</table>

#### CSV Import / Export

<!--DHIS2-SECTION-ID:webapi_events_csv_import_export-->

In addition to XML and JSON for event import/export, in DHIS2.17 we
introduced support for the CSV format. Support for this format builds on
what was described in the last section, so here we will only write about
what the CSV specific parts are.

To use the CSV format you must either use the `/api/events.csv`
endpoint, or add *content-type: text/csv* for import, and *accept:
text/csv* for export when using the `/api/events` endpoint.

The order of column in the CSV which are used for both export and import
is as follows:

<table>
<caption>CSV column</caption>
<thead>
<tr class="header">
<th>Index</th>
<th>Key</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>event</td>
<td>identifier</td>
<td>Identifier of event</td>
</tr>
<tr class="even">
<td>2</td>
<td>status</td>
<td>enum</td>
<td>Status of event, can be ACTIVE | COMPLETED | VISITED | SCHEDULED | OVERDUE | SKIPPED</td>
</tr>
<tr class="odd">
<td>3</td>
<td>program</td>
<td>identifier</td>
<td>Identifier of program</td>
</tr>
<tr class="even">
<td>4</td>
<td>programStage</td>
<td>identifier</td>
<td>Identifier of program stage</td>
</tr>
<tr class="odd">
<td>5</td>
<td>enrollment</td>
<td>identifier</td>
<td>Identifier of enrollment (program instance)</td>
</tr>
<tr class="even">
<td>6</td>
<td>orgUnit</td>
<td>identifier</td>
<td>Identifier of organisation unit</td>
</tr>
<tr class="odd">
<td>7</td>
<td>eventDate</td>
<td>date</td>
<td>Event date</td>
</tr>
<tr class="even">
<td>8</td>
<td>dueDate</td>
<td>date</td>
<td>Due Date</td>
</tr>
<tr class="odd">
<td>9</td>
<td>latitude</td>
<td>double</td>
<td>Latitude where event happened</td>
</tr>
<tr class="even">
<td>10</td>
<td>longitude</td>
<td>double</td>
<td>Longitude where event happened</td>
</tr>
<tr class="odd">
<td>11</td>
<td>dataElement</td>
<td>identifier</td>
<td>Identifier of data element</td>
</tr>
<tr class="even">
<td>12</td>
<td>value</td>
<td>string</td>
<td>Value / measure of event</td>
</tr>
<tr class="odd">
<td>13</td>
<td>storedBy</td>
<td>string</td>
<td>Event was stored by (defaults to current user)</td>
</tr>
<tr class="even">
<td>14</td>
<td>providedElsewhere</td>
<td>boolean</td>
<td>Was this value collected somewhere else</td>
</tr>
<tr class="odd">
<td>14</td>
<td>completedDate</td>
<td>date</td>
<td>Completed date of event</td>
</tr>
<tr class="even">
<td>14</td>
<td>completedBy</td>
<td>string</td>
<td>Username of user who completed event</td>
</tr>
</tbody>
</table>

*Example of 2 events with 2 different data value
    each:*

```csv
EJNxP3WreNP,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,1,,
EJNxP3WreNP,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,2,,
qPEdI1xn7k0,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,3,,
qPEdI1xn7k0,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,4,,
```

#### Import strategy: SYNC

<!--DHIS2-SECTION-ID:webapi_sync_import_strategy-->

The import strategy SYNC should be used only by internal synchronization
task and not for regular import. The SYNC strategy allows all 3
operations: CREATE, UPDATE, DELETE to be present in the payload at the
same time.

### Tracker Ownership Management

<!--DHIS2-SECTION-ID:webapi_tracker_ownership_management-->

A new concept called Tracker Ownership is introduced from 2.30. There
will now be one owner organisation unit for a tracked entity instance in
the context of a program. Programs that are configured with an access
level of *PROTECTED* or *CLOSED* will adhere to the ownership
privileges. Only those users belonging to the owning org unit for a
tracked entity-program combination will be able to access the data
related to that program for that tracked entity.

#### Tracker Ownership Override : Break the Glass

<!--DHIS2-SECTION-ID:webapi_tracker_ownership_override_api-->

It is possible to temporarily override this ownership privilege for a
program that is configured with an access level of *PROTECTED*. Any user
will be able to temporarily gain access to the program related data, if
the user specifies a reason for accessing the tracked entity-program
data. This act of temporarily gaining access is termed as *breaking the
glass*. Currently, the temporary access is granted for 3 hours. DHIS2
audits breaking the glass along with the reason specified by the user.
It is not possible to gain temporary access to a program that has been
configured with an access level of *CLOSED*. To break the glass for a
tracked entity program combination, you can issue a POST request as
shown:

    /api/33/tracker/ownership/override?trackedEntityInstance=DiszpKrYNg8
      &program=eBAyeGv0exc&reason=patient+showed+up+for+emergency+care

#### Tracker Ownership Transfer

<!--DHIS2-SECTION-ID:webapi_tracker_ownership_transfer_api-->

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

A potential duplicate represents a single or pair of records which are suspected to be a duplicate.

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

Additionally you can inspect individual records:

    GET /api/potentialDuplicates/<id>

To create a new potential duplicate, you can use this endpoint:

    POST /api/potentialDuplicates

The payload you provide needs at least _teiA_ to be a valid tracked entity instance; _teiB_ is optional. If _teiB_ is set, it also needs to point to an existing tracked entity instance.

```json
{
  "teiA": "<id>",
  "teiB": "<id>"
}
```

You can mark a potential duplicate as _invalid_ to tell the system that the potential duplicate has been investigated and deemed to be not a duplicate. To do so you can use the following endpoint:

    PUT /api/potentialDuplicates/<id>/invalidation

To hard delete a potential duplicate:

    DELETE /api/potentialDuplicates/<id>

## Program Messages

<!--DHIS2-SECTION-ID:webapi_program_messages-->

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

<table>
<caption>Program message payload</caption>
<colgroup>
<col style="width: 21%" />
<col style="width: 21%" />
<col style="width: 31%" />
<col style="width: 26%" />
</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Required</th>
<th>Description</th>
<th>Values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>recipients</td>
<td>Yes</td>
<td>Recipients of the program message. At least one recipient must be specified. Any number of recipients / types can be specified for a message.</td>
<td>Can be trackedEntityInstance, organisationUnit, an array of phoneNumbers or an array of emailAddresses.</td>
</tr>
<tr class="even">
<td>programInstance</td>
<td>Either this or programStageInstance required</td>
<td>The program instance / enrollment.</td>
<td>Enrollment ID.</td>
</tr>
<tr class="odd">
<td>programStageInstance</td>
<td>Either this or programInstance required</td>
<td>The program stage instance / event.</td>
<td>Event ID.</td>
</tr>
<tr class="even">
<td>deliveryChannels</td>
<td>Yes</td>
<td>Array of delivery channels.</td>
<td>SMS | EMAIL</td>
</tr>
<tr class="odd">
<td>subject</td>
<td>No</td>
<td>The message subject. Not applicable for SMS delivery channel.</td>
<td>Text.</td>
</tr>
<tr class="even">
<td>text</td>
<td>Yes</td>
<td>The message text.</td>
<td>Text.</td>
</tr>
<tr class="odd">
<td>storeCopy</td>
<td>No</td>
<td>Whether to store a copy of the program message in DHIS2.</td>
<td>false (default) | true</td>
</tr>
</tbody>
</table>

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

<table>
<caption>Query program messages API</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>URL</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>programInstance</td>
<td>/api/33/messages?programInstance=6yWDMa0LP7</td>
</tr>
<tr class="even">
<td>programStageInstance</td>
<td>/api/33/messages?programStageInstance=SllsjpfLH2</td>
</tr>
<tr class="odd">
<td>trackedEntityInstance</td>
<td>/api/33/messages?trackedEntityInstance=xdfejpfLH2</td>
</tr>
<tr class="even">
<td>organisationUnit</td>
<td>/api/33/messages?ou=Sllsjdhoe3</td>
</tr>
<tr class="odd">
<td>processedDate</td>
<td>/api/33/messages?processedDate=2016-02-01</td>
</tr>
</tbody>
</table>






