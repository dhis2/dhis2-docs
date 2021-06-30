# Organisation unit profile { #org_unit_profile }

The organisation unit profile resource allows you to define and retrieve an information profile for organisation units in DHIS 2.

```
/api/organisationUnitProfile
```

A single organisation unit profile can be created in and it will be applied for all organisation units.

The information part of the organisation unit profile includes:

- Name, short name, description, opening date, closed date, URL.
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

The payload looks like this, where `attributes` refers to metadata attributes,  `groupSets` refer to organisation unit group sets and `dataItems` refers to data elements, indicators, data sets and program indicators:

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

## Get organisation unit profile data

To retrieve the profile data you can use a `POST` request:

```
GET /api/organisationUnitProfile/{org-unit-id}/data?period={iso-period}
```

The organisation unit profile data endpoint will combine the profile definition with the associated information/data values. 

* The `{org-unit-id}` path variable is required and refers to the ID of the organisation unit to provide aggregated data for.
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

The profile data response payload will look like this, where the `id` and `label` fields refer to the metadata item, and the `value` field refers to the associated value:

```json
{
  "info": {
    "id": "DiszpKrYNg8",
    "code": "OU_559",
    "name": "Ngelehun CHC",
    "shortName": "Ngelehun CHC",
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

