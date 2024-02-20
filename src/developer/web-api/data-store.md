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
will require the `M_androidsettingsapp` authority.

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

### Query API
The query API is allows you to query and filter values over all keys in a namespace. The `fields` parameter is used to specify the query. This is useful for retrieving specific values of keys across a namespace in a single request. 

    GET /api/dataStore/<namespace>?fields=

The list of `fields` can be:

* empty: returns just the entry keys
* `.`: return the root value as stored
* comma separated list of paths: `<path>[,<path>]`; each `<path>` can be a simple property name (like `age`) or a nested path (like `person.age`) 

Furthermore, entries can be filtered using one or more `filter` parameters 
and sorted using the `order` parameter. 

Multiple filters can be combined using `rootJunction=OR` (default) or `rootJunction=AND`. 

All details on the `fields`, `filter` and `order` parameters are given in the following sections.

#### Paging
By default, results use paging. Use `pageSize` and `page` to adjust size and offset. 
The parameter `paging=false` can be used to opt-out and always return all matches. 
This should be used with caution as there could be many entries in a namespace. The default page size is 50.

    GET /api/dataStore/<namespace>?fields=.&page=2&pageSize=10

When paging is turned off, entries are returned as plain result array as the root JSON structure. The same effect can be achieved while having paged results by using `headless=true`.

```json
{
  "pager": { ... },
  "entries": [...]
}
```
vs.
```json
[...]
```

#### Value extraction
The data store allows extracting entire simple or complex values 
as well as the extraction of parts of complex JSON values.

> **Note**
> 
> For clarity of the examples the responses shown mostly omit the outermost object with the `pager` information
> and the `entries` array that the examples show.

To filter a certain set of fields add a `fields` parameter to the namespace 
query:

    GET /api/dataStore/<namespace>?fields=name,description

This returns a list of all entries having a non-null `name` and/or a 
`description` field like in the following example:

```json
[
  {"key": "key1", "name": "name1", "description": "description1"},
  {"key": "key2", "name": "name2", "description": "description2"}
]
```

If for some reason we even want entries where none of the extracted fields 
is non-null contained in the result list the `includeAll` parameter can be 
added:

    GET /api/dataStore/<namespace>?fields=name,description&includeAll=true

The response now might look like this:

```json
[
  {"key": "key1", "name": "name1", "description": "description1"},
  {"key": "key2", "name": "name2", "description": "description2"},
  {"key": "key3", "name": null, "description": null},
  {"key": "key4", "name": null, "description": null}
]
```

The extraction is not limited to simple root level members but can pick 
nested members as well by using square or round brackets after a members name:

    GET /api/dataStore/<namespace>?fields=name,root[child1,child2]
    GET /api/dataStore/<namespace>?fields=name,root(child1,child2)

The example response could look like this:

```json
[
  { "key": "key1", "name": "name1", "root": {"child1": 1, "child2": []}},
  { "key": "key2", "name": "name2", "root": {"child1": 2, "child2": []}}
]
```

The same syntax works for nested members:

    GET /api/dataStore/<namespace>?fields=root[level1[level2[level3]]]
    GET /api/dataStore/<namespace>?fields=root(level1(level2(level3)))

Example response here:

```json
[
  { "key": "key1", "root": {"level1": {"level2": {"level3": 42}}}},
  { "key": "key1", "root": {"level1": {"level2": {"level3": 13}}}}
]
```

When such deeply nested values are extracted we might not want to keep the 
structure but extract the leaf member to a top level member in the response.
Aliases can be used to make this happen. An alias can be placed anywhere 
after a member name using `~hoist` followed by the alias in round brackets like so:

    GET /api/dataStore/<namespace>?fields=root[level1[level2[level3~hoist(my-prop)]]]

The response now would look like this:

```json
[
  { "key": "key1", "my-prop": 42},
  { "key": "key2", "my-prop": 13}
]
```

If the full path should be kept while giving an alias to a nested member the 
parent path needs to be repeated using dot-syntax to indicate the nesting.
This can also be used to restructure a response in a new different structure 
like so:

    GET /api/dataStore/<namespace>?fields=root[level1[level2[level3~hoist(my-root.my-prop)]]]

The newly structured response now looks like this:

```json
[
  { "key": "key1", "my-root": {"my-prop": 42}},
  { "key": "key2", "my-root": {"my-prop": 13}}
]
```

OBS! An alias cannot be used to rename an intermediate level. However, an alias
could be used to resolve a name collision with the `key` member.

    GET /api/dataStore/<namespace>?fields=id,key~hoist(value-key)

```json
[
  { "key": "key1", "id": 1, "value-key": "my-key1"},
  { "key": "key2", "id": 2, "value-key": "my-key2"}
]
```

### Sorting results
Results can be sored by a single property using the `order=<path>[:direction]` parameter.
This can be any valid value `<path>` or the entry key (use `_` as path).

By default, sorting is alphanumeric assuming the value at the path is a string of mixed type.

For example to extract the name property and also sort the result by it use:

    GET /api/dataStore/<namespace>?fields=name&order=name

To switch to descending order use `:desc`:

    GET /api/dataStore/<namespace>?fields=name&order=name:desc

Sometimes the property sorted by is numeric so alphanumeric interpretation would be confusing.
In such cases special ordering types `:nasc` and `:ndesc` can be used.

In summary, order can be one of the following:

* `asc`: alphanumeric ascending order
* `desc:`: alphanumeric descending order
* `nasc`: numeric ascending order
* `ndesc`: numeric descending order

> **OBS!**
> 
> When using numeric order all matches must have a numeric value for the property at the provided `<path>`.

### Filtering entries
To filter entries within the query API context add one or more `filter` parameters
while also using the `fields` parameter.

Each `filter` parameter has the following form:

* unary operators: `<path>:<operator>`
* binary operators: `<path>:<operator>:<value>`
* set operators: `<path>:<operator>:[<value>,<value>,...]`

Unary operators are:

| Operator | Description |
| -------- | ----------- |
| `null`   | value is JSON `null` |
| `!null`  | value is defined but different to JSON `null` |
| `empty`  | value is an empty object, empty array or JSON string of length zero |
| `!empty` | value is different to an empty object, empty array or zero length string |

Binary operators are:

| Operator | Description |
| -------- | ----------- |
| `eq`     | value is equal to the given boolean, number or string |
| `!eq`, `ne`, `neq` | value is not equal to the given boolean, number or string |
| `lt`     | value is numerically or alphabetically less than the given number or string |
| `le`     | value is numerically or alphabetically less than or equal to the given number or string |
| `gt`     | value is numerically or alphabetically greater than the given number or string |
| `ge`     | value is numerically or alphabetically greater than or equal to the given number or string |

Text pattern matching binary operators are:

| Operator | Case Insensitive |  Description |
| -------- | ---------------- | ----------- |
| `like`   | `ilike`          | value matches the text pattern given |
| `!like`  | `!ilike`         | value does not match the text pattern given |
| `$like`  | `$ilike`, `startswith`   | value starts with the text pattern given |
| `!$like` | `!$ilike`, `!startswith` | value does not start with the text pattern given |
| `like$`  | `ilike$`, `endswith`     | value ends with the text pattern given |
| `!like$` | `!ilike$`, `!endswith`   | value does not end with the text pattern given |

For operators that work for multiple JSON node types the semantic is determined from the provided value.
If the value is `true` or `false` the filter matches boolean JSON values.
If the value is a number the filter matches number JSON values.
Otherwise, the value matches string JSON values or mixed types of values.

> **Tip**
>
> To force text comparison for a value that is numeric quote the value in single quotes.
> For example, the value `'13'` is the text 13 while `13` is the number 13.  

Set operators are:

| Operator | Description |
| -------- | ----------- |
| `in`     | entry value is textually equal to one of the given values (is in set) |
| `!in`    | entry value is not textually equal to any of the given values (is not in set) |

The `<path>` can be:

* `_`: the entry key is
* `.`: the entry root value is
* `<member>`: the member of the root value is
* `<member>.<member>`: the member at the path is (up to 5 levels deep)

A `<member>` path expression can be a member name or in case of arrays an array index.
In case of an array the index can also be given in the form: `[<index>]`.
For example, the path `addresses[0].street` would be identical to `addresses.0.street`.

Some example queries are found below.

Name (of root object) is "Luke":

    GET /api/dataStore/<namespace>?fields=.&filter=name:eq:Luke

Age (of root object) is greater than 42 (numeric):

    GET /api/dataStore/<namespace>?fields=.&filter=age:gt:42

Root value is a number greater than 42 (numeric matching inferred from the value):

    GET /api/dataStore/<namespace>?fields=.&filter=.:gt:42

Enabled (of root object) is true (boolean matching inferred from the value):

    GET /api/dataStore/<namespace>?fields=.&filter=enabled:eq:true

Root object has name containing "Pet" and has an age greater than 20:

    GET /api/dataStore/<namespace>?fields=.&filter=name:like:Pet&filter=age:gt:20

Root object is either flagged as minor or has an age less than 18:

    GET /api/dataStore/<namespace>?fields=.&filter=minor:eq:true&filter=age:lt:18&rootJunction=or

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

### Sharing data store keys { #webapi_data_store_sharing } 

Sharing of data store keys follows the same principle as for other metadata sharing (see
[Sharing](#webapi_sharing)).

To get sharing settings for a specific data store key:

    GET /api/33/sharing?type=dataStore&id=<uid>

Where the id for the data store key comes from the `/metaData` endpoint for that key:

    GET /api/33/dataStore/<namespace>/<key>/metaData

As usual the `access` property in the response reflects the capabilities of the 
current user for the target entry.
Namespace wide protection might still apply and render a user incapable to
perform certain changes.

To modify sharing settings for a specific data store key:

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

### Admin Access to another User's Datastore
Admins can manipulate another user's datastore by adding the `username`
parameter to any of the manipulations described above to not have them affect
the admins own datastore but the datastore of the user given by the `username`
parameter.

For example, to add a value to `Peter`'s datastore an admin uses:

    POST /api/userDataStore/<namespace>/<key>?username=Peter

## Partial Update (Experimental)
Both the datastore and user datastore allow partial updating of entry values.  

All the subsequent examples operate on the basis that the following JSON entry is in the namespace `pets` with key `whiskers`.  

```json
{
  "name": "wisker",
  "favFood": [
    "fish", "rabbit"
  ]
}
```

We can perform many update operations on this entry. The following examples use `{store}` in the API calls, please substitute with `dataStore` or `userDataStore` for your use case.

### Update root (entire entry)
We can update the entry at the root by not supplying the `path` request param or leaving it empty `path=`.  

`PUT` `/api/{store}/pets/whiskers` with body `"whiskers"` updates the entry to be the supplied body. So a `GET` request to `/api/{store}/pets/whiskers` would now show:  
```json
"whiskers"
```

### Update at specific path
We can update the entry at a specific path by supplying the `path` request param and the property to update.

`PUT` `/api/{store}/pets/whiskers?path=name` with body `"whiskers"` updates the entry at the `name` property only. So a `GET` request to `/api/{store}/pets/whiskers` would now show the updated `name`:

```json
{
    "name": "whiskers",
    "favFood": [
        "fish",
        "rabbit"
    ]
}
```

We can update an array element at a specific path.

`PUT` `/api/{store}/pets/whiskers?path=favFood.[0]` with body `"carrot"` updates the first element in the `favFood` array only. So a `GET` request to `/api/{store}/pets/whiskers` would now show the updated `favFood`:

```json
{
    "name": "wisker",
    "favFood": [
        "carrot",
        "rabbit"
    ]
}
```

### Benefits
- smaller payloads required for small changes
- less error-prone (no copy-pasting large entries to change 1 property)

## Roll (Experimental)
The `roll` request param enables the user to have a 'rolling' number of elements in an array. In our example we have the `favFood` array. If we wanted to update this array previously, we'd have to supply the whole payload like so:  
`PUT` `/api/{store}/pets/whiskers` with body

```json
{
    "name": "wisker",
    "favFood": [
        "fish",
        "rabbit",
        "carrot"
    ]
}
```

Now we can use the `roll` request param (with the `path` functionality) to state that we want the rolling functionality for _n_ number of elements.
In this example we state that we want the array to have a rolling value of 3, passing in an extra element in the call.  
`PUT` `/api/{store}/pets/whiskers?roll=3&path=favFood` with body `"carrot"` would result in the following state.

```json
{
    "name": "wisker",
    "favFood": [
        "fish",
        "rabbit",
        "carrot"
    ]
}
```

Since we passed the rolling value of `3`, this indicates that we only want the last 3 elements passed into the array. So if we now make another call and add a new element to the array, we would expect the first element (`fish`) to be dropped from the array.
`PUT` `/api/{store}/pets/whiskers?roll=3&path=favFood` with body `"bird"` would result in the following state:

```json
{
    "name": "wisker",
    "favFood": [
        "rabbit",
        "carrot",
        "bird"
    ]
}
```

> **Note**
>
> Once a rolling value has been set (e.g. `role=3`), it can only be increased (e.g. `roll=5`) and cannot be decreased (e.g. `roll=2`)

Dot notation does allow for nested calls. Let's say we have this current entry value:

```json
{
  "name": "wisker",
  "favFood": [
    "fish", "rabbit"
  ],
  "type": {
    "breed": ["shorthair"]
  }
}
```

If we wanted to add another breed using a rolling array we could make the call:
`PUT` `/api/{store}/pets/whiskers?roll=3&path=type.breed` with body `"small"` which would result in the following state:

```json
{
  "name": "wisker",
  "favFood": [
    "fish", "rabbit"
  ],
  "type": {
    "breed": ["shorthair, small"]
  }
}
```

### Benefits
- Only interested in keeping track of _n_ values which may change over time