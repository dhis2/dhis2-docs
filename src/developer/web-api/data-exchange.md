# Data exchange

## Aggregate data exchange

This section describes the aggregate data exchange service and API.

### Overview

The aggregate data exchange service offers the ability to exchange data between instances of DHIS 2, and possibly other software which supports the DHIS 2 data value set JSON format. It also allows for data exchange within a single instance of DHIS 2, for instance for aggregation of tracker data and saving the result as aggregate data. 

The aggregate data exchange service is suitable for use-cases such as:

* Data exchange between an HMIS instance to a data portal or data warehouse instance of DHIS 2.
* Data exchange between a DHIS 2 tracker instance with individual data to an aggregate HMIS instance.
* Pre-computation of tracker data with program indicators saved as aggregate data values.
* Data reporting from a national HMIS to a global donor.

The aggregate data exchange service allows for data exchange between a *source* instance of DHIS 2 and a *target* instance of DHIS 2. A data exchange can be *external*, for which the target instance is different/external to the source instance. A data exchange can also be *internal*, for which the target is the same as the source instance. The aggregate data exchange source can contain multiple source requests, where a source request corresponds roughly to an analytics API request.

The data value will be retrieved and transformed into the *data value set* format, and then pushed to the target instance of DHIS 2. The aggregate data exchange service supports *identifier schemes* to allow for flexibility in mapping metadata between instances.

Data will be retrieved and aggregated from the source instance using the analytics engine. This implies that data elements, aggregate indicators, data set reporting rates and program indicators can be referenced in the request to the source instance. A source request also contains periods, where both fixed and relative periods are supported, and organisation units. 

A data exchange can be run as a scheduled job, where the data exchange can be set to run at a specific interval. A data exchange can also be run on demand through the API.

To create and manipulate aggregate data exchanges, the `F_AGGREGATE_DATA_EXCHANGE_PUBLIC_ADD` or `F_AGGREGATE_DATA_EXCHANGE_PRIVATE_ADD` and `F_AGGREGATE_DATA_EXCHANGE_DELETE` authorities are required.

The aggregate data exchange service is introduced in version 2.39, which means that the source instance of DHIS 2 must be version 2.39 or later. Because the DHIS 2 data value set format is used when pushing data, the target instance can be any DHIS 2 version.

### Authentication

For data exchanges of type external, the base URL and authentication credentials for the target DHIS 2 instance must be specified. For authentication, basic authentication and personal access tokens (PAT) are supported.

It is recommended to either specify basic authentication or PAT authentication. If both are specified, PAT authentication takes precedence.

Note that PAT support was introduced in version 2.38, which means that in order to use PAT authentication, the target DHIS 2 instance must be version 2.38 or later.

 ### API

The aggregate data exchange API is covered in the following section.

#### Create aggregate data exchange

```
POST /api/aggregateDataExchanges
```

```
Content-Type: application/json
```

```
201 Created
```

Example of an internal data exchange payload, where event data is computed with program indicators and saved as aggregate data values: 

```json
{
  "name": "Internal data exchange",
  "source": {
    "requests": [
      {
        "name": "ANC",
        "visualization": null,
        "dx": [
          "fbfJHSPpUQD",
          "cYeuwXTCPkU",
          "Jtf34kNZhzP"
        ],
        "pe": [
          "LAST_12_MONTHS",
          "202201"
        ],
        "ou": [
          "ImspTQPwCqd"
        ],
        "filters": [
          {
            "dimension": "Bpx0589u8y0",
            "items": [
              "oRVt7g429ZO", 
              "MAs88nJc9nL"
            ]
          }
        ],
        "inputIdScheme": "UID",
        "outputDataElementIdScheme": "UID",
        "outputOrgUnitIdScheme": "UID",
        "outputIdScheme": "UID"
      }
    ]
  },
  "target": {
    "type": "INTERNAL",
    "request": {
      "dataElementIdScheme": "UID",
      "orgUnitIdScheme": "UID",
      "categoryOptionComboIdScheme": "UID",
      "idScheme": "UID"
    }
  }
}
```

Example external data exchange payload with basic authentication, where data is pushed to external DHIS 2 instance:

```json
{
  "name": "External data exchange with basic authentication",
  "source": {
    "requests": [
      {
        "name": "ANC",
        "visualization": null,
        "dx": [
          "fbfJHSPpUQD",
          "cYeuwXTCPkU",
          "Jtf34kNZhzP"
        ],
        "pe": [
          "LAST_12_MONTHS",
          "202201"
        ],
        "ou": [
          "ImspTQPwCqd"
        ],
        "inputIdScheme": "UID",
        "outputIdScheme": "UID"
      }
    ]
  },
  "target": {
    "type": "EXTERNAL",
    "api": {
        "url": "https://play.dhis2.org/2.38.1.1",
        "accessToken": "d2pat_XIrqgAGjW935LLPuSP2hXSZwpTxTW2pg3580716988"
    },
    "request": {
      "idScheme": "UID"
    }
  }
}
```

Example external data exchange payload with access token (PAT) authentication:

```json
{
  "name": "External data exchange with PAT authentication",
  "source": {
    "requests": [
      {
        "name": "ANC",
        "dx": [
          "fbfJHSPpUQD",
          "cYeuwXTCPkU",
          "Jtf34kNZhzP"
        ],
        "pe": [
          "LAST_12_MONTHS",
          "202201"
        ],
        "ou": [
          "ImspTQPwCqd"
        ]
      }
    ]
  },
  "target": {
    "type": "EXTERNAL",
    "api": {
        "url": "https://play.dhis2.org/2.38.1.1",
        "accessToken": "d2pat_XIrqgAGjW935LLPuSP2hXSZwpTxTW2pg3580716988"
    }
  }
}
```

#### Update aggregate data exchange

```
PUT /api/aggregateDataExchanges/{id}
```

```
Content-Type: application/json
```

```
200 OK
```

The payload is identical with the create operation.

#### Get aggregate data exchange

```
GET /api/aggregateDataExchanges/{id}
```

```
200 OK
```

The retrieval endpoints follow the regular metadata endpoint field filtering and object filtering semantics. Response paylads in JSON format only is supported.

#### Delete aggregate data exchange

```
DELETE /api/aggregateDataExchanges/{id}
```

```
204 No Content
```

#### Run aggregate data exchange

An aggregate data exchange can be run directly with a POST request to the following endpoint:

```
POST /api/aggregateDataExchanges/{id}/exchange
```

```
200 OK
```

An import summary describing the outcome of the data exchange will be returned.

#### Get source data

The aggregate data for the source request of an aggregated data exchange can be retrieved with a GET request to the following endpoint:

```
GET /api/aggregateDataExchanges/{id}/sourceData
```

```
200 OK
```

The response payload format is identical with the analytics API endpoint. This endpoint is useful for debugging purposes. 
