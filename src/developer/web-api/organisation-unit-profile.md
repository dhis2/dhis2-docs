# OrganisationUnit Profile API { #orgUnitProfile_api }

## Overview

The `OrgUnitProfile` settings allow user to defined a list of `OrganisationUnit` information for displaying in UI. 

User can create one `OrgUnitProfile` in system, and it will be applied for all `OrganisationUnit`. 

The information includes:
- Name, short name, description, opening date, closed date, URL of org unit.
- Contact person, address, email, phone number (if exists).
- Location ( longtitude / latitude ).
- Metadata attributes ( configurable ).
- Exclusive org unit group sets. Use to display group in exclusive group sets (e.g. "Facility type: Hospital", "Facility ownership: Public").
- Aggregate data for data elements, indicators, reporting rates, program indicators (configurable). The period to retrieve aggregate data is provided as an API input parameter. Period type is fixed to yearly for now.

## OrgUnitProfile API endpoint

 ### Get `OrgUnitProfile` settings
 
 - A `GET` request to `/api/orgUnitProfile` will receive `OrgUnitProfile` payload as below

 ```
 {
  "attributes":[
    "Zc3y9LinmtA",
    "Zc3y9LinmtB"
  ],
  "groupSets": [
    "Zc3y9LinmtC",
    "Zc3y9LinmtD",
  ],
  "dataItems": [
    "Zc3y9LinmtE",
    "Zc3y9LinmtF"
  ]
}
```
- Payload descriptions:
    - `attributes`: arrays of Metadata `Attribute` UID.
    - `groupSets`: arrays of `OrganisationUnitGroupSet` UID.
    - `dataItems`: arrays of Data Item UID, can be `DataElement`, `Indicator`, `ReportingRate`, Event data items, `ProgramIndicator`.

### Save `OrgUnitProfile` settings
- Send `POST` request to `/api/orgUnitProfile` with same payload format as above for saving `OrgUnitProfile` settings.
- Authority `F_ORG_UNIT_PROFILE_ADD` or `ALL` is required for this function.
- All UIDs will be validated for exsitence in database. 
- ACL check is also applied. If user doesn't have `METADATA READ` permission then the object is considered not existed.

### Get `OrgUnitProfileData` 

- The object `OrgUnitProfileData` contains infomation of an `OrganisationUnit` based on `OrgUnitProfile` settings.
- If there is no `OrgUnitProfile` defined, only basic info of `OrganisationUnit` will be returned.
- Send `GET` request to `api/orgUnitProfile/data/{orgUnitId}?period={isoPeriod}` to get `OrgUnitProfileData` of an `OrganisationUnit`.
  - `orgUnitId` path parameter is required.
  - `period` parameter is not required, the period shoud be in ISO format.
  - Sharing check is applied for all metadata.
  
Sample `OrgUnitProfileData` JSON payload
```
{
  "info": {
    "id": "ImspTQPwCqd",
    "code": "OU_525",
    "name": "Sierra Leone",
    "shortName": "Sierra Leone",
    "openingDate": "1994-01-01T00:00:00.000"
  },
  "attributes": [
    {
      "id": "Zc3y9LinmtA",
      "label": "testAttribute1",
      "value": "aaa"
    },
    {
      "id": "FFGU7hRkPK7",
      "label": "testAttribute2",
      "value": "bbb"
    }
  ],
  "groupSets": [],
  "dataItems": []
}
```
