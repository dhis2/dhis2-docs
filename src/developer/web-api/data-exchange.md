# Data exchange

## Aggregate data exchange

This section describes the aggregate data exchange service and API.

### Introduction

The aggregate data exchange service offers the ability to exchange data between instances of DHIS 2, and possibly other software which supports the DHIS 2 data value set JSON format. It also allows for data exchange within a single instance of DHIS 2, for instance for aggregation of tracker data and saving the result as aggregate data. 

The aggregate data exchange service is suitable for use-cases such as:

* Data exchange between an HMIS instance to a data portal or data warehouse instance of DHIS 2.
* Data exchange between a DHIS 2 tracker instance with individual data to an aggregate HMIS instance.
* Precomputation of tracker data with program indicators saved as aggregate data values.
* Data reporting from a national HMIS to a global donor.

### Overview

The aggregate data exchange service allows for data exchange between a *source* instance of DHIS 2 and a *target* instance of DHIS 2. A data exchange can be *external*, for which the target instance is different/external to the source instance. A data exchange can also be *internal*, for which the target instance is the same as the source instance. The aggregate data exchange source can contain multiple source requests, where a source request roughly corresponds to an analytics API request.

The data value will be retrieved and transformed into the *data value set* format, and then pushed to the target instance of DHIS 2. The aggregate data exchange service supports *identifier schemes* to allow for flexibility in mapping metadata between instances.

Data will be retrieved and aggregated from the source instance using the analytics engine. This implies that data elements, aggregate indicators, data set reporting rates and program indicators can be referenced in the request to the source instance. A source request also contains periods, where both fixed and relative periods are supported, and organisation units. Any number of *filters* can be applied to a source request.

A data exchange can be run as a scheduled job, where the data exchange can be set to run at a specific interval. A data exchange can also be run on demand through the API.

To create and manipulate aggregate data exchanges, the `F_AGGREGATE_DATA_EXCHANGE_PUBLIC_ADD` / `F_AGGREGATE_DATA_EXCHANGE_PRIVATE_ADD` and `F_AGGREGATE_DATA_EXCHANGE_DELETE` authorities are required.

The aggregate data exchange definitions are regular metadata in DHIS 2, meaning that the definitions can be imported and exported between instances of DHIS 2. The exception is credentials (usernames and access tokens) which will not be exposed in metadata exports. Credentials are encrypted in storage to provide an additional layer of security.

The aggregate data exchange service was introduced in version 2.39, which means that the source instance of DHIS 2 must be version 2.39 or later. The target instance of DHIS 2 must be version 2.38 or later.

### Authentication

For data exchanges of type external, the base URL and authentication credentials for the target DHIS 2 instance must be specified. For authentication, basic authentication and personal access tokens (PAT) are supported.

It is recommended to either specify basic authentication or PAT authentication. If both are specified, PAT authentication takes precedence.

Note that PAT support was introduced in version 2.38.1, which means that in order to use PAT authentication, the target DHIS 2 instance must be version 2.38.1 or later.

### Sharing
Like other metadata objects, fine-grained security can be associated with aggregate data exchanges. Each exchange can be shared with individual users and/or user groups to control which users have access to the specific exchange. External data exchanges contain authentication details of users on the target system, thus great care should be
taken to ensure that only authorized users have access to actually submit data which results from the exchange.

The following table summarizes how sharing can be used with aggregate data exchanges.


| Sharing | Effective permissions                                                              |
| -------- |-----------------------------------------------------------------------------------|
| "r-------" | Can view metadata of the data exchange. |
| "-w------" | Can edit metadata of the data exchange. |
| "--r-----" | Can view data which is part of the exchange. |
| "---w----" | Can submit data which is part of the exchange. |

### API

The aggregate data exchange API is covered in the following section.

#### Create aggregate data exchange

```
POST /api/aggregateDataExchanges
```

```
Content-Type: application/json
```

Example internal data exchange payload, where event data is computed with program indicators and saved as aggregate data values: 

```json
{
  "name": "Internal data exchange",
  "source": {
    "params": {
      "periodTypes": [
        "MONTHLY",
        "QUARTERLY"
      ]
    },
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

Example external data exchange payload with basic authentication and ID scheme *code*, where data is pushed to an external DHIS 2 instance:

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
        "outputIdScheme": "CODE"
      }
    ]
  },
  "target": {
    "type": "EXTERNAL",
    "api": {
        "url": "https://play.dhis2.org/2.38.2.1",
        "username": "admin",
        "password": "district"
    },
    "request": {
      "idScheme": "CODE"
    }
  }
}
```

Example external data exchange payload with PAT authentication and ID scheme *code*, where data is pushed to an external DHIS 2 instance:

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
        ],
        "inputIdScheme": "UID",
        "outputIdScheme": "CODE"
      }
    ]
  },
  "target": {
    "type": "EXTERNAL",
    "api": {
        "url": "https://play.dhis2.org/2.38.2.1",
        "accessToken": "d2pat_XIrqgAGjW935LLPuSP2hXSZwpTxTW2pg3580716988"
    },
    "request": {
      "idScheme": "CODE"
    }
  }
}
```

The syntax for the source requests follow the analytics endpoint API syntax. This means that for the `dx` part, data elements, indicators, data set reporting rates, program data elements and program indicators are supported. Note that for program data elements, the data element must be prefixed with the program identifier. For the `pe` part, relative periods as well as fixed periods are supported. For the `ou` part, user org units, org unit levels and org unit groups as well as individual org units are supported. Consult the *Analytics* chapter > the *Dimensions and items* and *The dx dimension* sections for a full explanation.

##### Response

```
201 Created
```

```json
{
  "httpStatus": "Created",
  "httpStatusCode": 201,
  "status": "OK",
  "response": {
    "responseType": "ObjectReport",
    "uid": "pG4bBTMiCqO",
    "klass": "org.hisp.dhis.dataexchange.aggregate.AggregateDataExchange",
    "errorReports": []
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

The request payload is identical to the create operation.

##### Response

```
200 OK
```

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "response": {
    "responseType": "ObjectReport",
    "uid": "pG4bBTMiCqO",
    "klass": "org.hisp.dhis.dataexchange.aggregate.AggregateDataExchange",
    "errorReports": []
  }
}
```

#### Get aggregate data exchange

```
GET /api/aggregateDataExchanges/{id}
```

``` 
Accept: application/json
```

The retrieval endpoints follow the regular metadata endpoint field filtering and object filtering semantics. JSON is the only supported response format.

##### Response

```
200 OK
```

#### Delete aggregate data exchange

```
DELETE /api/aggregateDataExchanges/{id}
```

##### Response

```
204 No Content
```

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "response": {
    "responseType": "ObjectReport",
    "uid": "pG4bBTMiCqO",
    "klass": "org.hisp.dhis.dataexchange.aggregate.AggregateDataExchange",
    "errorReports": []
  }
}
```

#### Run aggregate data exchange

An aggregate data exchange can be run directly with a POST request to the following endpoint:

```
POST /api/aggregateDataExchanges/{id}/exchange
```

##### Response

```
200 OK
```

```json
{
  "responseType": "ImportSummaries",
  "status": "SUCCESS",
  "imported": 36,
  "updated": 0,
  "deleted": 0,
  "ignored": 0,
  "importSummaries": ["<import summaries here>"]
}
```

An import summary describing the outcome of the data exchange will be returned, including the number of data values which were imported, updated, deleted and ignored.

#### Get source data

The aggregate data for the source request of an aggregated data exchange can be retrieved in the analytics data format with a GET request to the following endpoint:

```
GET /api/aggregateDataExchanges/{id}/sourceData
```

```
Accept: application/json
```

##### Response

```
200 OK
```

##### Query parameters

| Query parameter | Required | Description                                                  | Options                       |
| --------------- | -------- | ------------------------------------------------------------ | ----------------------------- |
| outputIdScheme  | No       | Override the output identifier scheme for the data response. | UID \| CODE \| ATTRIBUTE:{ID} |

The response payload format is identical with the analytics API endpoint. This endpoint is useful for debugging purposes. Consult the analytics API guide for additional details.

#### Get source data value sets

The aggregate data for the source request of an aggregated data exchange can be retrieved in the data value set format with a GET request to the following endpoint:

```
GET /api/aggregateDataExchanges/{id}/sourceDataValueSets
```

```
Accept: application/json
```

##### Response

```
200 OK
```

##### Query parameters

| Query parameter | Required | Description                                                  | Options                       |
| --------------- | -------- | ------------------------------------------------------------ | ----------------------------- |
| outputIdScheme  | No       | Override the output identifier scheme for the data response. | UID \| CODE \| ATTRIBUTE:{ID} |

The response payload format is identical with the data value sets API endpoint. This endpoint is useful for debugging purposes. Consult the data value sets API guide for additional details.

### Data model

The aggregate data exchange data model / payload is described in the following section.

| Field                                             | Data type      | Mandatory   | Description                                                  |
| ------------------------------------------------- | -------------- | ----------- | ------------------------------------------------------------ |
| name                                              | String         | Yes         | Name of aggregate data exchange. Unique.                     |
| source                                            | Object         | Yes         | Source for aggregate data exchange.                          |
| source.params                                     | Object         | No          | Parameters for source request.                               |
| source.params.periodTypes                         | Array/String   | No          | Allowed period types for overriding periods in source request. |
| source.requests                                   | Array/Object   | Yes         | Source requests.                                             |
| source.requests.name                              | String         | Yes         | Name of source request.                                      |
| source.requests.visualization                     | String         | No          | Identifier of associated visualization object.               |
| source.requests.dx                                | Array/String   | Yes         | Identifiers of data elements, indicators, data sets and program indicators for the source request. |
| source.requests.pe                                | Array/String   | Yes         | Identifiers of fixed and relative periods for the source request. |
| source.requests.ou                                | Array/String   | Yes         | Identifiers of organisation units for the source request.    |
| source.requests.filters                           | Array (Object) | No          | Filters for the source request.                              |
| source.requests.filters.dimension                 | String         | No          | Dimension identifier for the filter.                         |
| source.requests.filters.items                     | Array/String   | No          | Item identifiers for the filter.                             |
| source.requests.inputIdScheme                     | String         | No          | Input ID scheme, can be `UID`, `CODE`, `ATTRIBUTE:{ID}`.     |
| source.requests.outputDataElementIdScheme         | String         | No          | Output data element ID scheme, can be `UID`, `CODE`, `ATTRIBUTE:{ID}`. |
| source.requests.outputDataItemIdScheme         | String         | No          | Output data item ID scheme applies to data elements, indicators and program indicators, can be `UID`, `CODE`, `ATTRIBUTE:{ID}`. |
| source.requests.outputOrgUnitIdScheme             | String         | No          | Output org unit ID scheme, can be `UID`, `CODE`, `ATTRIBUTE:{ID}`. |
| source.requests.outputIdScheme                    | String         | No          | Output general ID scheme, can be `UID`, `CODE`, `ATTRIBUTE:{ID}`. |
| source.target                                     | Object         | Yes         | Target for  aggregate data exchange.                         |
| source.target.type                                | String         | Yes         | Type of target, can be `EXTERNAL`, `INTERNAL`.               |
| source.target.api                                 | Object         | Conditional | Target API information, only mandatory for type `EXTERNAL`.  |
| source.target.api.url                             | String         | Conditional | Base URL of target DHIS 2 instance, do not include the `/api` part. |
| source.target.api.accessToken                     | String         | Conditional | Access token (PAT) for target DHIS 2 instance, used for PAT authentication. |
| source.target.api.username                        | String         | Conditional | Username for target DHIS 2 instance, used for basic authentication. |
| source.target.api.password                        | String         | Conditional | Password for target DHIS 2 instance, used for basic authentication. |
| source.target.request                             | Object         | No          | Target request information.                                  |
| source.target.request.dataElementIdScheme         | String         | No          | Input data element ID scheme, can be `UID`, `CODE`, `ATTRIBUTE:{ID}`. |
| source.target.request.orgUnitIdScheme             | String         | No          | Input org unit ID scheme, can be `UID`, `CODE`, `ATTRIBUTE:{ID}`. |
| source.target.request.categoryOptionComboIdScheme | String         | No          | Input category option combo ID scheme, can be `UID`, `CODE`, `ATTRIBUTE:{ID}`. |
| source.target.request.idScheme                    | String         | No          | Input general ID scheme, can be `UID`, `CODE`, `ATTRIBUTE:{ID}`. |
| source.target.request.importStrategy                    | String         | No          | Import strategy, can be `CREATE_AND_UPDATE`, `CREATE`, `UPDATE`, `DELETE`. |
| source.target.request.skipAudit                    | Boolean         | No          | Skip audit, meaning audit values will not be generated. Improves performance at the cost of ability to audit changes. Requires authority "F_SKIP_DATA_IMPORT_AUDIT". |
| source.target.request.dryRun                    | Boolean         | No          | Whether to save changes on the server or just return the import summary. |

### Error handling

When running a data exchange by identifier, information about the outcome of the operation will be available in the response payload. The response will contain a list of import summaries, i.e. one import summary per source request. The import summary will indicate any potential conflicts as a result of data retrieval from the source instance and data import in the target instance.

### Examples

#### External data exchange with identifier scheme code

This example will demonstrate how to exchange data based on program indicators in the source DHIS 2 instance and data elements in the target instance. The `code` identifier scheme, which means the data exchange will use the `code` property on the metadata to reference the data. Using codes is useful when the ID properties don't match across DHIS 2 instances. The example will demonstrate how data can be aggregated in the source instance, including aggregation in time and the unit hierarchy, before being exchanged with the target instance.

The example will exchange data using the DHIS 2 play environment, and refer to the 2.39 version at `https://play.dhis2.org/2.39` as the *source instance*, and the 2.38 version at `https://play.dhis2.org/2.38.2.1` as the *target instance*. Note that the URLs will change over time as new patch versions are released, so make sure to update the target URLs.

* Log in to the **source** instance, navigate to the Maintenance app and observe that three program indicators exist.

  * _BCG doses_ with code `BCG_DOSE`
  * _Measles doses_ with code `MEASLES_DOSE` 
  * _Yellow fever doses_ with code `YELLOW_FEVER_DOSE`

* Observe that the root org unit is `Sierra Leone` with code `OU_525`.

* Log in to the **target** instance and navigate to the *Maintenance* app. Create three data elements, where the codes match the previously mentioned program indicators:

  * Name _BCG doses_ and code `BCG_DOSE`
  * Name _Measles doses_ and code `MEASLES_DOSE`
  * Name _Yellow fever doses_ with code `YELLOW_FEVER_DOSE`

* In the **target** instance, create a new data set with any name, e.g. _Data exchange_, select the tree newly created data elements, and assign the data set to the root org unit _Sierra Leone_.

* Observe that the root org unit `Sierra Leone` has the code `OU_525`, which is equal to the source instance.

* Open an HTTP tool such as _Postman_ and put together the following aggregate data exchange payload in JSON.
  ```
  POST /api/aggregateDataExchanges
  ```

  ```
  Content-Type: application/json
  ```

  ```json
  {
    "name": "Immunization doses program indicators to data elements",
    "source": {
      "requests": [
        {
          "name": "Immunization doses",
          "dx": [
            "BCG_DOSE",
            "MEASLES_DOSE",
            "YELLOW_FEVER_DOSE"
          ],
          "pe": [
            "202201"
          ],
          "ou": [
            "OU_525"
          ],
          "inputIdScheme": "code",
          "outputIdScheme": "code"
        }
      ]
    },
    "target": {
      "type": "EXTERNAL",
      "api": {
        "url": "https://play.dhis2.org/2.38.2.1",
        "username": "admin",
        "password": "district"
      },
      "request": {
        "idScheme": "code"
      }
    }
  }
  ```

* In this payload, observe that for the source request, program indicators are referred to using codes. The `inputIdScheme` is set to `code`, which means that the DHIS 2 analytics engine will use the `code` property to reference metadata, such as program indicators. The `outputIdScheme` is set to `code`, which means that the `code` property will be used to reference metadata in the output. For the target request, the `idScheme` is also set to `code`, which means that the `code` property will be used to reference metadata during the data value import. Note that ID schemes can be specified per entity type, such as `dataElementIdScheme` and `orgUnitIdScheme`. 

* Note that the period is `202201` or _January 2022_. Note that the period might have to be updated over time.

* Run the POST request to create the aggregate data exchange definition. Confirm that the API response status code is 201. Note that the name of the data exchange is unique. Take a note of the ID of the newly created object by looking at `response` > `uid` in the response body.

* Run the newly created data exchange with a POST request (replace `{id}` with the ID of the data exchange):
  ```
  POST /api/aggregateDataExchanges/{id}/exchange
  ```
  
* Confirm that the API response indicates that three data values were successfully imported. 
  ```json
  {
    "responseType": "ImportSummaries",
    "status": "SUCCESS",
    "imported": 3,
    "updated": 0,
    "deleted": 0,
    "ignored": 0
  }
  ```
  
* In the **target** instance, navigate to the *Data entry* app, select org unit _Sierra Leone_, data set _Data exchange_ and period _January 2022_. Observe that the exchanged data values are visible in the form.

To summarize, in this example, event data records were aggregated from the facility level to the national level in the org unit hierarchy and from event data to monthly data values using program indicators. The data values were exchanged with a target DHIS 2 instance by using the `code` property to reference metadata.
