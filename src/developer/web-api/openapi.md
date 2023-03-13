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

