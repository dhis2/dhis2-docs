# Organisation unit profile { #org_unit_profile }

The organisation unit profile resource allows you to define and retrieve an information profile for organisation units in DHIS 2.

```
/api/organisationUnitProfile
```

A single organisation unit profile can be created in applies to all organisation units.

The information part of the organisation unit profile includes:

- Name, short name, description, parent organisation unit, level, opening date, closed date, URL.
- Contact person, address, email, phone number (if exists).
- Location (longitude/latitude).
- Metadata attributes (configurable).
- Organisation unit group sets and groups (configurable).
- Aggregate data for data elements, indicators, reporting rates, program indicators (configurable).

## Create organisation unit profile

To define the organisation unit profile you can use a `POST` request:

```
POST /api/organisationUnitProfile
```

The payload in JSON format looks like this, where `attributes` refers to metadata attributes,  `groupSets` refer to organisation unit group sets and `dataItems` refers to data elements, indicators, data sets and program indicators:

```json
{
  "attributes": [
    "xqWyz9jNCA5",
    "n2xYlNbsfko"
  ],
  "groupSets": [
    "Bpx0589u8y0",
    "J5jldMd8OHv"
  ],
  "dataItems": [
    "WUg3MYWQ7pt",
    "vg6pdjObxsm",
    "DTVRnCGamkV",
    "Uvn6LCg7dVU",
    "eTDtyyaSA7f"
  ]
}
```

The `F_ORG_UNIT_PROFILE_ADD` authority is required to define the profile.

## Get organisation unit profile

To retrieve the organisation unit profile definition you can use a `GET` request:

```
GET /api/organisationUnitProfile
```

The response will be in JSON format.

## Get organisation unit profile data

To retrieve the organisation unit profile data you can use a `GET` request:

```
GET /api/organisationUnitProfile/{org-unit-id}/data?period={iso-period}
```

The organisation unit profile data endpoint will combine the profile definition with the associated information/data values. 

* The `org-unit-id` path variable is required and refers to the ID of the organisation unit to provide aggregated data for.
* The `iso-period` query parameter is optional and refers to the ISO period ID for the period to provide aggregated data for the data items. If none is specified, the _this year_ relative period will be used as fallback.

The response will include the following sections:

* `info`: Fixed information about the organisation unit.
* `attributes`: Metadata attributes with corresponding attribute values.
* `groupSets`: Organisation unit group sets with the corresponding organisation unit group which the organisation unit is a member of.
* `dataItems`: Data items with the corresponding aggregated data value.

Note that access control checks are performed and metadata items which are not accessible to the current user will be omitted.

An example request looks like this:

```
GET /api/organisationUnitProfile/DiszpKrYNg8/data?period=2021
```

The profile data response payload in JSON format will look like this, where the `id` and `label` fields refer to the metadata item, and the `value` field refers to the associated value:

```json
{
  "info": {
    "id": "DiszpKrYNg8",
    "code": "OU_559",
    "name": "Ngelehun CHC",
    "shortName": "Ngelehun CHC",
    "parentName": "Badjia",
    "level": 4,
    "levelName": "Facility",
    "openingDate": "1970-01-01T00:00:00.000",
    "longitude": -11.4197,
    "latitude": 8.1039
  },
  "attributes": [
    {
      "id": "n2xYlNbsfko",
      "label": "NGO ID",
      "value": "GHE51"
    },
    {
      "id": "xqWyz9jNCA5",
      "label": "TZ code",
      "value": "NGE54"
    }
  ],
  "groupSets": [
    {
      "id": "Bpx0589u8y0",
      "label": "Facility Ownership",
      "value": "Public facilities"
    },
    {
      "id": "J5jldMd8OHv",
      "label": "Facility Type",
      "value": "CHC"
    }
  ],
  "dataItems": [
    {
      "id": "WUg3MYWQ7pt",
      "label": "Total Population",
      "value": 3503
    },
    {
      "id": "DTVRnCGamkV",
      "label": "Total population < 1 year",
      "value": 140
    },
    {
      "id": "vg6pdjObxsm",
      "label": "Population of women of child bearing age (WRA)",
      "value": 716
    },
    {
      "id": "Uvn6LCg7dVU",
      "label": "ANC 1 Coverage",
      "value": 368.2
    },
    {
      "id": "eTDtyyaSA7f",
      "label": "FIC <1y",
      "value": 291.4
    }
  ]
}
```

## Upload image for an organisation unit

To upload an image for an organisation unit you can use the `fileResource` endpoint.

```
/api/fileResources
```

The `fileResource` endpoint accepts a raw file as the request body. The `JPG`/`JPEG` and `PNG` formats are supported for organisation unit images. The domain for organisation unit images is `ORG_UNIT`.

Please consult *File resources* in the *Metadata* section for details about the `fileResources` endpoint. 

To upload an image you can send a `POST` request with `ORG_UNIT` as domain query parameter with the image as the request paylaod. The `Content-Type` header should match the type of file being uploaded.

```
POST /api/fileResources?domain=ORG_UNIT
```

The `id ` property of the `response` > `fileResource` object in the JSON response will contain a reference to the identifier of the file resource.

The organisation unit entity has an `image` property which refers to the file resource image. To set the file resource reference on an organisation unit you can send a `PATCH` request to the organisation unit with a JSON payload:

```
PATCH /api/organisationUnits/{id}
```

```json
{ 
  "image": "{file-resource-id}" 
}
```

Alternatively, you can use a `PUT` request with the full organisation unit payload (fields omitted for brevity):

```
PUT /api/organisationUnits/{id}
```

```json
{
  "id": "Rp268JB6Ne4",
  "name": "Adonkia CHP",
  "image": {
    "id":  "{file-resource-iid}"
  }
}
```

## Get image for an organisation unit

The organisation unit entity has an `image` object which refers to a file resource by identifier. You can get the organisation unit information from the `organisationUnits` endpoint. If set, the JSON format looks like this:

```
GET /api/organisationUnits/{id}
```

```json
{
  "id": "Rp268JB6Ne4",
  "name": "Adonkia CHP",
  "image": {
    "id":  "{file-resource-id}"
  }
}
```

The image file resource identifier can be used to make a request to the `fileResources` endpoint to retrieve the file content:

```
GET /api/fileResources/{id}/data
```

The `Content-Type` header will reflect the type of file being retrieved.