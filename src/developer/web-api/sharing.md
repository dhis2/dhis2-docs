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
**Note**
> It is possible to create surprising sharing combinations. For
> instance, if `externalAccess` is set to `true` but `publicAccess` is
> set to `--------`, then users will have access to the object 
> only when they are logged out.




## New Sharing object
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
Please note that this function ***only supports*** new `sharing` format. The payload in JSON format looks like this:
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

- `cascadeSharing` is available for Dashboards. This function copies the `userAccesses` and `userGroupAccesses` of a Dashboard to all of the objects in its `DashboardItems`, including `Map`, `EventReport`, `EventChart`, `Visualization`. 
- This function will not copy `METADATA_WRITE` access. The copied `UserAccess` and `UserGroupAccess` will **only** receive the `METADATA_READ` permission. 
- The `publicAccess` setting of the Dashboard is not copied.
- If any target object has `publicAccess` enabled, then it will be skipped and will not receive the `UserAccesses` or `UserGroupAccesses` from the Dashboard.
- The current user must have `METADATA_READ` sharing permission to all target objects. If the user does not, error `E5001` is thrown.
- The current user must have `METADATA_WRITE` sharing permission to update any target objects. If a target object should be updated and the user does not have this permission, error `E3001` is thrown.

### Sample use case

- DashboardA is shared to userA with `METADATA_READ_WRITE` permission. 
- DashboardA has VisualizationA which has DataElementA.
- VisualizationA, DataElementA have `publicAccess` *disabled* and are *not shared* to userA.
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

## Bulk Sharing patch API { #webapi_bulk_sharing } 
- The bulk sharing API allow you to apply sharing settings to multiple metadata objects. This means the ability to add or remove many users and user groups to many objects in one API operation.
- This API should not support keeping metadata objects in sync over time, and instead treat it as a one-time operation.
- The API needs to respect the sharing access control, in that the current user must have access to edit the sharing of the objects being updated.
- There are two new api endpoints introduced from 2.38 that allow bulk sharing patch update as described below.
- Please note that those `PATCH` request must use header `Content-type:application/json-patch+json`

### Using `/api/{object-type}/sharing` with `PATCH` request
- This endpoint allows user to apply one set of Sharing settings for multiple metadata objects of *one object-type*.
- Note that we still support JsonPatch request for one object with endpoint `api/{object-type}/{uid}`. For instance, you can still update sharing of a DataElement by sending PATCH request to `api/dataElements/cYeuwXTCPkU/sharing`

Example: 
```
curl -X PATCH -d @payload.json -H "Content-Type: application/json-patch+json" "https://play.dhis2.org/dev/api/dataElements/sharing"
```

### Using `/api/metadata/sharing` with `PATCH` request
- This endpoint allows user to apply Sharing settings for *multiple object-types* in one payload.

Example:
```
curl -X PATCH -d @payload.json -H "Content-Type: application/json-patch+json" "https://play.dhis2.org/dev/api/metadata/sharing"
```

## Parameters
- Both patch api endpoints have same parameter:

| Name  |  Default  |  Description  |
| ---- | ---- | -------------------- |
| atomic | false | If this is set to true, then the batch function will stop and not updating any objects if there is an error <br> Otherwise, if this is false then the function will try to proceed with best effort mode. |


## Validation
- All object ID will be validated for existence.
- Current User need to have metadata READ/WRITE permission on updating objects.
- All existing validations from metadata import service will also be applied.

## Response
- Response format should be same as from `/api/metadata` api.

## Payload formats
- Payload for single object type using `/api/{object-type}/sharing` looks like this
```json
{
  "dataSets":[
    "cYeuwXTCPkU",
    "aYeuwXTCPkU"
  ],
  "patch":[
    {
      "op":"add",
      "path":"/sharing/users/DXyJmlo9rge",
      "value":{
        "access":"rw------",
        "id":"DXyJmlo9rge"
      }
    },
    {
      "op":"remove",
      "path":"/sharing/users/N3PZBUlN8vq"
    }
  ]
}
```

- Payload for multiple object types in one payload using `api/metadata/sharing`
```json
{
  "dataElements": {
    "fbfJHSPpUQD": [
      {
        "op": "replace",
        "path": "/sharing/users",
        "value": {
          "NOOF56dveaZ": {
            "access": "rw------",
            "id": "CotVI2NX0rI"
          },
          "Kh68cDMwZsg": {
            "access": "rw------",
            "id": "DLjZWMsVsq2"
          }
        }
      }
    ]
  },
  "dataSets": {
    "cYeuwXTCPkA": [
      {
        "op": "remove",
        "path": "/sharing/users/N3PZBUlN8vq"
      }
    ],
    "cYeuwXTCPkU": [
      {
        "op": "add",
        "path": "/sharing/users/DXyJmlo9rge",
        "value": {
          "access": "rw------",
          "id": "DXyJmlo9rge"
        }
      }
    ]
  },
  "programs": {
    "GOLswS44mh8": [
      {
        "op": "add",
        "path": "/sharing/userGroups",
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
  }
}
```