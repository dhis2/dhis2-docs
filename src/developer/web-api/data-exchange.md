# Data exchange

## Aggregate data exchange

This section describes the aggregate data exchange service and API, referred to as _ADE_. 

### Overview

The aggregate data exchange service offers the ability to exchange data between instances of DHIS 2, and possibly other software which supports the DHIS 2 data value set JSON format. It also allows for data exchange within a single instance of DHIS 2, for instance for aggregation of tracker data and saving the result as aggregate data. 

The ADE service is suitable for use-cases such as:

* Data exchange between an HMIS instance to a data portal or data warehouse instance of DHIS 2.
* Data exchange between a DHIS 2 tracker instance with individual data to an aggregate HMIS instance.
* Pre-computation of tracker data with program indicators saved as aggregate data values.
* Data reporting from a national HMIS to a global donor.

The ADE service allows for data exchange between a *source* instance of DHIS 2 and a *target* instance of DHIS 2. A data exchange can be *external*, for which the target instance is different/external to the source instance. A data exchange can also be *internal*, for which the target is the same as the source instance. The ADE source can contain multiple source requests, where a source request corresponds roughly to an analytics API request.

The data value will be retrieved and transformed into the *data value set* format, and then pushed to the target instance of DHIS 2. The ADE service supports *identifier schemes* to allow for flexibility in mapping metadata between instances.

Data will be retrieved and aggregated from the source instance using the analytics engine. This implies that data elements, aggregate indicators, data set reporting rates and program indicators can be referenced in the request to the source instance. A source request also contains periods, where both fixed and relative periods are supported, and organisation units. 

A data exchange can be run as a scheduled job, where the data exchange can be set to run at a specific interval. A data exchange can also be run on demand through the API.

To create and manipulate ADEs, the `F_AGGREGATE_DATA_EXCHANGE_PUBLIC_ADD` or `F_AGGREGATE_DATA_EXCHANGE_PRIVATE_ADD` and `F_AGGREGATE_DATA_EXCHANGE_DELETE` authorities are required.

The ADE service is introduced in version 2.39, which means that the source instance of DHIS 2 must be version 2.39 or later. Because the DHIS 2 data value set format is used when pushing data, the target instance can be any DHIS 2 version.

### Authentication

For data exchanges of type external, the base URL and authentication credentials for the target DHIS 2 instance must be specified. For authentication, basic authentication and personal access tokens (PAT) are supported. Note that PAT support was introduced in version 2.38, which means that in order t use PAT authentication, the target DHIS 2 instance must be version 2.38 or later.

 ### API

The ADE API is covered in the following section.

#### Create data exchange

```
POST /api/aggregateDataExchanges
```

```
Content-Type: application/json
```

```
```

