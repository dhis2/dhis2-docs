# Sharing

## Sharing { #webapi_sharing } 

The sharing solution allows you to share most objects in the system with
specific user groups and to define whether objects should be publicly
accessible or private. To get and set sharing status for objects you can
interact with the *sharing* resource.

    /api/33/sharing

### Get sharing status { #webapi_get_sharing_status } 

To request the sharing status for an object use a GET request to:

    /api/33/sharing?type=dataElement&id=fbfJHSPpUQD

The response looks like the below.

```json
{
  "meta": {
    "allowPublicAccess": true,
    "allowExternalAccess": false
  },
  "object": {
    "id": "fbfJHSPpUQD",
    "name": "ANC 1st visit",
    "publicAccess": "rw------",
    "externalAccess": false,
    "user": {},
    "userGroupAccesses": [
      {
        "id": "hj0nnsVsPLU",
        "access": "rw------"
      },
      {
        "id": "qMjBflJMOfB",
        "access": "r-------"
      }
    ]
  }
}
```

### Set sharing status { #webapi_set_sharing_status } 

You can define the sharing status for an object using the same URL with
a POST request, where the payload in JSON format looks like this:

```json
{
  "object": {
    "publicAccess": "rw------",
    "externalAccess": false,
    "user": {},
    "userGroupAccesses": [
      {
        "id": "hj0nnsVsPLU",
        "access": "rw------"
      },
      {
        "id": "qMjBflJMOfB",
        "access": "r-------"
      }
    ]
  }
}
```

In this example, the payload defines the object to have read-write
public access, no external access (without login), read-write access to
one user group and read-only access to another user group. You can
submit this to the sharing resource using curl:

```bash
curl -d @sharing.json "localhost/api/33/sharing?type=dataElement&id=fbfJHSPpUQD"
  -H "Content-Type:application/json" -u admin:district
```

### New Sharing object
From 2.36 a new `sharing` property has been introduced in order to replace the old sharing properties `userAccesses`, `userGroupAccesses`, `publicAccess`, `externalAccess` in all metadata classes that have sharing enabled. This `Sharing` object is saved as a JSONB column in database. 
However, in order make it backward compatible the old sharing objects still work normally as before, for both import and export. In backend sharing data will be saved to new  JSONb `sharing` column instead of the old `*accesses` tables.

The format looks like this:
```json
{
  "name": "ANC 1st visit",
  "publicAccess": "rw------",
  "externalAccess": false,
  "userGroupAccesses": [
      {
          "access": "r-r-----",
          "userGroupUid": "Rg8wusV7QYi",
          "displayName": "HIV Program Coordinators",
          "id": "Rg8wusV7QYi"
      }
  ],
  "userAccesses": [],
  "user": {
      "displayName": "Tom Wakiki",
      "name": "Tom Wakiki",
      "id": "GOLswS44mh8",
      "username": "system"
  },
  "sharing": {
      "owner": "GOLswS44mh8",
      "external": false,
      "users": {},
      "userGroups": {
          "Rg8wusV7QYi": {
              "access": "r-r-----",
              "id": "Rg8wusV7QYi"
          }
      },
      "public": "rw------"
  }
}
```

### Set sharing status using new JSON Patch Api { #webapi_set_sharing_status_using_json_patch_api } 
You can use [JSON Patch API](#webapi_partial_updates) to update sharing for an object by sending a `PATCH` request to this endpoint with header `Content-Type: application/json-patch+json`
```
api/dataElements/fbfJHSPpUQD
```
Please note that this function ***only supports*** new `sharing` format, so the payload in JSON format looks like this:
```json
[
  {
    "op": "replace",
    "path": "/sharing/users",
    "value": {
      "NOOF56dveaZ": {
        "access": "rw------",
        "id": "NOOF56dveaZ"
      },
      "Kh68cDMwZsg": {
        "access": "rw------",
        "id": "Kh68cDMwZsg"
      }
    }
  }
]
```
You can add users to `sharing` property of an object like this
```json
[
  {
    "op": "add",
    "path": "/sharing/users",
    "value": {
      "NOOF56dveaZ": {
        "access": "rw------",
        "id": "NOOF56dveaZ"
      },
      "Kh68cDMwZsg": {
        "access": "rw------",
        "id": "Kh68cDMwZsg"
      }
    }
  }
]
```
You can add one user to `sharing` like this
```json
[
  {
    "op": "add",
    "path": "/sharing/users/NOOF56dveaZ",
    "value": {
      "access": "rw------",
      "id": "NOOF56dveaZ"
    }
  }
]
```
You can remove one user from `sharing` like this
```json
[
  { 
  	"op": "remove", 
  	"path": "/sharing/users/N3PZBUlN8vq"
	}
]
```

## Cascade Sharing for Dashboard

### Overview

- The sharing solution supports cascade sharing for Dashboard. 
- This function will copy `userAccesses` and `userGroupAccesses` of a Dashboard to all of its DashboardItem's objects including `Map`, `EventReport`, `EventChart`, `Visualization`. 
- This function will ***NOT*** copy `METADATA_WRITE` access. The copied `UserAccess` and `UserGroupAccess` will **only** have `METADATA_READ` permission. 
- The `publicAccess` setting is currently ***NOT*** handled by this function. Means the `publicAccess` of the current `Dashboard` will not be copied to its `DashboardItems`'s objects.
- If target object has `publicAccess` enabled, then it will be ignored by this function. Means that no `UserAccesses` or `UserGroupAccesses` will be copied from `Dashboard`.
- Current `User` is required to have `METADATA_READ` sharing permission to all target objects, otherwise error `E5001` will be thrown. And to update target objects, `METADATA_WRITE` is required, otherwise error `E3001` will be thrown.
- Sample use case:

	- DashboardA is shared to userA with `METADATA_READ_WRITE` permission.

	- DashboardA has VisualizationA which has DataElementA.

	- VisualizationA, DataElementA have `publicAccess`  *disabled* and are *not shared* to userA.

	- After executing cascade sharing for DashboardA, userA will have `METADATA_READ` access to VisualizationA and DataElementA.

### API endpoint 

- Send `POST` request to endpoint 
```
api/dashboards/cascadeSharing/{dashboardUID}
```


### API Parameters

| Name | Default | Description |
| --- | --- | -- |
| dryRun | false | If this is set to `true`, then cascade sharing function will proceed without updating any objects. </br> The response will includes errors if any and all objects which will be updated. </br>This helps user to know the result before actually executing the cascade sharing function.
| atomic | false | If this is set to `true`, then the cascade sharing function will stop and not updating any objects if there is an error. </br>Otherwise, if this is `false` then the function will try to proceed with best effort mode.

Sample response: 

```json
{
  "errorReports": [
    {
      "message": "No matching object for reference. Identifier was s46m5MS0hxu, and object was DataElement.",
      "mainKlass": "org.hisp.dhis.dataelement.DataElement",
      "errorCode": "E5001",
      "errorProperties": [
        "s46m5MS0hxu",
        "DataElement"
      ]
    }
  ],
  "countUpdatedDashBoardItems": 1,
  "updateObjects": {
    "dataElements": [
      {
        "id": "YtbsuPPo010",
        "name": "Measles doses given"
      },
      {
        "id": "l6byfWFUGaP",
        "name": "Yellow Fever doses given"
      }
    ]
  }
}
```

### Response properties:

- `errorReports`: includes all errors during cascade sharing process.
- `countUpdatedDashBoardItems`: Number of `DashboardItem` will be or has been updated depends on `dryRun` mode.
- `updateObjects`: List of all objects which will be or has been updated depends on `dryRun` mode.