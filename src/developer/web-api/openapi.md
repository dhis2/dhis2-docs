# OpenAPI

The DHIS2 server can provide an OpenAPI document for its API.
This document is created on the fly from analysis of the actual API.
It means the document is complete but details may be lost or misrepresented
due to limitations in the analysis.

Both JSON and YAML format are supported by all OpenAPI endpoints.
YAML should be requested with `Accept` header of `application/x-yaml`.

To fetch a single document containing all endpoints of the server use:

    GET /api/openapi.json
    GET /api/openapi.yaml

OBS! Be aware that this generates a document that is several MBs in size.

A document for a specific endpoint can be accessed by appending either 
`openapi.json` or `openapi.yaml` to an endpoint root path. 
For example, to generate a document for the `/users` endpoints use:

    GET /api/users/openapi.json
    GET /api/users/openapi.yaml

To generate a document with a specific selection of root paths and/or tags the
general `/openapi` endpoint can be used with one or more `tag` and `path`
selectors.

    GET /api/openapi/openapi.json?path=/users&path=/dataElements
    GET /api/openapi/openapi.yaml?tag=system&tag=metadata

Available tags are:

* `user`
* `data`
* `metadata`
* `ui`
* `analytics`
* `system`
* `messaging`
* `tracker`
* `integration`
* `login`
* `query`
* `management`

All endpoints that generate a OpenAPI document support the following optional 
request parameters:

### `failOnNameClash`
When set to `true`, two or more types of same simple (unqualified) name are considered clashing and the generation fails with an error. 

When set `false` (default), name clashes are resolved by adding numbers to the simple name to make each of them unique.
As a result the names are not predictable or stable. Merging simple names with their intended markdown documentation based on name will be broken. 
This option is meant as a preview feature which should only be used during development.

### `failOnInconsistency`
When set to `true`, a semantic inconsistency in the declaration causes the generation to fail with an error.
Usually this indicates a programming mistake. For example, declaring a field both as required and having a default value.

When set to `false`, a semantic inconsistency is logged as warning but the generation proceeds.
This might produce a document that contradicts itself semantically but is valid formally.