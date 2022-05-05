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

## Availability check { #webapi_sync_availability_check } 

To check the availability of the remote data server and verify user
credentials you can make a GET request to the following resource:

    /api/33/synchronization/availability
