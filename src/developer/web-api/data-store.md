# Data store

## Data store { #webapi_data_store } 

Using the *dataStore* resource, developers can store arbitrary data for
their apps. Access to a datastore's key is based on its sharing settings.
By default all keys created are publicly accessible (read and write).
Additionally,  access to a datastore's namespace is limited to the user's
access to the corresponding app, if the app has reserved the namespace.
For example a user with access to the "sampleApp" application will also
be able to use the sampleApp namespace in the datastore. If a namespace
is not reserved, no specific access is required to use it.

    /api/33/dataStore

Note that there are reserved namespaces used by the system that require 
special authority to be able to read or write entries. 
For example the namespace for the android settings app `ANDROID_SETTINGS_APP`
will require `F_METADATA_MANAGE` authority.

### Data store structure { #webapi_data_store_structure } 

Data store entries consist of a namespace, key and value. The
combination of namespace and key is unique. The value data type is JSON.



Table: Data store structure

| Item | Description | Data type |
|---|---|---|
| Namespace | Namespace for organization of entries. | String |
| Key | Key for identification of values. | String |
| Value | Value holding the information for the entry. | JSON |
| Encrypted | Indicates whether the value of the given key should be encrypted | Boolean |

### Get keys and namespaces { #webapi_data_store_get_keys_and_namespaces } 

For a list of all existing namespaces:

    GET /api/33/dataStore

Example curl request for listing:

```bash
curl "play.dhis2.org/demo/api/33/dataStore" -u admin:district
```

Example response:

```json
[
  "foo",
  "bar"
]
```

For a list of all keys in a namespace:

    GET /api/33/dataStore/<namespace>

Example curl request for listing:

```bash
curl "play.dhis2.org/demo/api/33/dataStore/foo" -u admin:district
```

Example response:

```json
[
  "key_1",
  "key_2"
]
```

To retrieve a value for an existing key from a namespace:

    GET /api/33/dataStore/<namespace>/<key>

Example curl request for retrieval:

```bash
curl "play.dhis2.org/demo/api/33/dataStore/foo/key_1"-u admin:district
```

Example response:

```json
{
  "foo":"bar"
}
```

To retrieve meta-data for an existing key from a namespace:

    GET /api/33/dataStore/<namespace>/<key>/metaData

Example curl request for retrieval:

```bash
curl "play.dhis2.org/demo/api/33/dataStore/foo/key_1/metaData" -u admin:district
```

Example response:

```json
{
  "id": "dsKeyUid001", 
  "created": "...",
  "user": {...},
  "namespace": "foo",
  "key": "key_1"
}
```

### Create values { #webapi_data_store_create_values } 

To create a new key and value for a namespace:

    POST /api/33/dataStore/<namespace>/<key>

Example curl request for create, assuming a valid JSON payload:

```bash
curl "https://play.dhis2.org/demo/api/33/dataStore/foo/key_1" -X POST
  -H "Content-Type: application/json" -d "{\"foo\":\"bar\"}" -u admin:district
```

Example response:

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 201,
  "status": "OK",
  "message": "Key 'key_1' created."
}
```

If you require the data you store to be encrypted (for example user
credentials or similar) you can append a query to the url like this:

    GET /api/33/dataStore/<namespace>/<key>?encrypt=true

### Update values { #webapi_data_store_update_values } 

To update a key that exists in a namespace:

    PUT /api/33/dataStore/<namespace>/<key>

Example curl request for update, assuming valid JSON payload:

```bash
curl "https://play.dhis2.org/demo/api/33/dataStore/foo/key_1" -X PUT -d "[1, 2, 3]"
  -H "Content-Type: application/json" -u admin:district
```

Example response:

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "message": "Key 'key_1' updated."
}
```

### Delete keys { #webapi_data_store_delete_keys } 

To delete an existing key from a namespace:

    DELETE /api/33/dataStore/<namespace>/<key>

Example curl request for delete:

```bash
curl "play.dhis2.org/demo/api/33/dataStore/foo/key_1" -X DELETE -u admin:district
```

Example response:

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "message": "Key 'key_1' deleted from namespace 'foo'."
}
```

To delete all keys in a namespace:

    DELETE /api/33/dataStore/<namespace>

Example curl request for delete:

```bash
curl "play.dhis2.org/demo/api/33/dataStore/foo" -X DELETE -u admin:district
```

Example response:

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "message": "Namespace 'foo' deleted."
}
```

### Sharing datastore keys { #webapi_data_store_sharing } 

Sharing of datastore keys follows the same principle as for other metadata sharing (see
[Sharing](#webapi_sharing)).

To get sharing settings for a specific datastore key:

    GET /api/33/sharing?type=dataStore&id=<uid>

Where the id for the datastore key comes from the `/metaData` endpoint for that key:

    /api/33/dataStore/<namespace>/<key>/metaData

To modify sharing settings for a specific datastore key:

    POST /api/33/sharing?type=dataStore&id=<uid>

with the following request:

```json
{
  "object": {
    "publicAccess": "rw------",
    "externalAccess": false,
    "user": {},
    "userAccesses": [],
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

## User data store { #webapi_user_data_store } 

In addition to the *dataStore* which is shared between all users of the
system, a user-based data store is also available. Data stored to the
*userDataStore* is associated with individual users, so that each user
can have different data on the same namespace and key combination. All
calls against the *userDataStore* will be associated with the logged in
user. This means one can only see, change, remove and add values
associated with the currently logged in user.

    /api/33/userDataStore

### User data store structure { #webapi_user_data_store_structure } 

*userDataStore* consists of a user, a namespace, keys and associated
values. The combination of user, namespace and key is unique.



Table: User data store structure

| Item | Description | Data Type |
|---|---|---|
| User | The user this data is associated with | String |
| Namespace | The namespace the key belongs to | String |
| Key | The key a value is stored on | String |
| Value | The value stored | JSON |
| Encrypted | Indicates whether the value should be encrypted | Boolean |

### Get namespaces { #webapi_user_data_store_get_namespaces } 

Returns an array of all existing namespaces

    GET /api/33/userDataStore

Example
    request:

```bash
curl -H "Content-Type: application/json" -u admin:district "play.dhis2.org/api/33/userDataStore"
```

```json
[
  "foo",
  "bar"
]
```

### Get keys { #webapi_user_data_store_get_keys } 

Returns an array of all existing keys in a given namespace

    GET /api/userDataStore/<namespace>

Example request:

```bash
curl -H "Content-Type: application/json" -u admin:district "play.dhis2.org/api/33/userDataStore/foo"
```

```json
[
  "key_1",
  "key_2"
]
```

### Get values { #webapi_user_data_store_get_values } 

Returns the value for a given namespace and key

    GET /api/33/userDataStore/<namespace>/<key>

Example request:

```bash
curl -H "Content-Type: application/json" -u admin:district "play.dhis2.org/api/33/userDataStore/foo/bar"
```

```json
{
  "some": "value"
}
```

### Create value { #webapi_user_data_store_create_values } 

Adds a new value to a given key in a given namespace.

    POST /api/33/userDataStore/<namespace>/<key>

Example request:

```bash
curl -X POST -H "Content-Type: application/json" -u admin:district -d "['some value']"
  "play.dhis2.org/api/33/userDataStore/foo/bar"
```

```json
{
  "httpStatus": "Created",
  "httpStatusCode": 201,
  "status": "OK",
  "message": "Key 'bar' in namespace 'foo' created."
}
```

If you require the value to be encrypted (For example user credentials
and such) you can append a query to the url like this:

    GET /api/33/userDataStore/<namespace>/<key>?encrypt=true

### Update values { #webapi_user_data_store_update_values } 

Updates an existing value

    PUT /api/33/userDataStore/<namespace>/<key>

Example request:

```bash
curl -X PUT -H "Content-Type: application/json" -u admin:district -d "['new value']"
  "play.dhis2.org/api/33/userDataStore/foo/bar"
```

```json
{
  "httpStatus":"Created",
  "httpStatusCode":201,
  "status":"OK",
  "message":"Key 'bar' in namespace 'foo' updated."
}
```

### Delete key { #webapi_user_data_store_delete_key } 

Delete a key

    DELETE /api/33/userDataStore/<namespace>/<key>

Example request:

```bash
curl -X DELETE -u admin:district "play.dhis2.org/api/33/userDataStore/foo/bar"
```

```json
{
  "httpStatus":"OK",
  "httpStatusCode":200,
  "status":"OK",
  "message":"Key 'bar' deleted from the namespace 'foo."
}
```

### Delete namespace { #webapi_user_data_store_delete_namespace } 

Delete all keys in the given namespace

    DELETE /api/33/userDataStore/<namespace>

Example request:

```bash
curl -X DELETE -u admin:district "play.dhis2.org/api/33/userDataStore/foo"
```

```json
{
  "httpStatus":"OK",
  "httpStatusCode":200,
  "status":"OK",
  "message":"All keys from namespace 'foo' deleted."
}
```




