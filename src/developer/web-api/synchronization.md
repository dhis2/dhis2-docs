# Synchronization { #webapi_synchronization }

This section covers pull and push of data and metadata.

## Data value push { #webapi_sync_data_push }

To initiate a data value push to a remote server one must first configure the
URL and credentials for the relevant server from System settings >
Synchronization, then make a POST request to the following resource:

    /api/33/synchronization/dataPush

## Metadata pull { #webapi_sync_metadata_pull }

To initiate a metadata pull from a remote JSON document you can make a
POST request with a *url* as request payload to the following resource:

    /api/33/synchronization/metadataPull

> **Note**
>
> The supplied URL will be checked against the config property `metadata.sync.remote_servers_allowed` in the `dhis.conf` file.
> If the base URL is not one of the configured servers allowed then the operation will not be allowed. See failure example below.  
> Some examples where the config set is `metadata.sync.remote_servers_allowed=https://server1.org/,https://server2.org/`
> - supply `https://server1.org/path/to/resource` -> this will be accepted
> - supply `https://server2.org/resource/path` -> this will be accepted
> - supply `https://oldserver.org/resource/path` -> this will be rejected
>
Sample failure response

```json
 {
  "httpStatus": "Conflict",
  "httpStatusCode": 409,
  "status": "ERROR",
  "message": "Provided URL is not in the remote servers allowed list",
  "errorCode": "E1004"
}
```

## Availability check { #webapi_sync_availability_check }

To check the availability of the remote data server and verify user
credentials you can make a GET request to the following resource:

    /api/33/synchronization/availability
