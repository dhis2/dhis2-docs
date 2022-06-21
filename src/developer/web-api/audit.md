# Audit

## Auditing { #webapi_auditing } 

DHIS2 will audit updates and deletions of aggregate data values, tracked entity data values, tracked entity attribute values and data approval records. This section explains how to retrieve audit records for the mentioned entities. Note that several of the query parameters can be repeated any number of times.

### Aggregate data value audits { #webapi_auditing_aggregate_audits } 

The endpoint for aggregate data value audits is located at:

```
/api/audits/dataValue
```

Table: Aggregate data value query parameters

| Parameter | Option | Description |
|---|---|---|
| ds | Data set ID | One or more data set identifiers to get data elements from |
| de | Data element ID | One or more data element identifiers |
| pe | ISO period | One or more period ISO identifiers |
| ou | Organisation unit ID | One or more org unit identifiers |
| auditType | UPDATE &#124; DELETE | Filter by audit type |
| skipPaging | false &#124; true | Turn paging on / off |
| paging | false \| true | Whether to enable or disable paging |
| page | Number | Page number (default 1) |
| pageSize | Number | Page size (default 50) |

Example: Get all audits for data set with ID `lyLU2wR22tC`:

    /api/33/audits/dataValue?ds=lyLU2wR22tC

### Tracked entity data value audits { #webapi_tracked_entity_data_value_audits } 

The endpoint for tracked entity data value audits is located at:

```
/api/audits/trackedEntityDataValue
```

Table: Tracked entity data value query parameters

| Parameter | Option | Description |
|---|---|---|
| de | Data element ID | One or more data element identifiers |
| ou | Organisation unit ID | One or more organisation unit identifiers of the audited event |
| psi | Program stage instance ID | One or more program stage instance identifiers of the audited event |
| ps | Program stage ID | One or more program sages of the audit event program |
| startDate | Start date | Return only audit records created after date |
| endDate | End date | Return only audit records created before date |
| auditType | UPDATE &#124; DELETE | Filter by audit type |
| skipPaging | false &#124; true | Turn paging on / off |
| paging | false \| true | Whether to enable or disable paging |
| page | Number | Page number (default 1) |
| pageSize | Number | Page size (default 50) |

Example: Get all audits which have data element ID `eMyVanycQSC` or `qrur9Dvnyt5`:

    /api/33/audits/trackedEntityDataValue?de=eMyVanycQSC&de=qrur9Dvnyt5

### Tracked entity attribute value audits { #webapi_tracked_entity_attribute_value_audits } 

The endpoint for tracked entity attribute value audits is located at:

```
/api/audits/trackedEntityAttributeValue
```

Table: Tracked entity attribute value query parameters

| Parameter | Option | Description |
|---|---|---|
| tea | Tracked entity attribute ID | One or more tracked entity attribute identifiers |
| tei | Tracked entity instance ID | One or more tracked entity instance identifiers |
| auditType | UPDATE &#124; DELETE | Filter by audit type |
| skipPaging | false &#124; true | Turn paging on / off |
| paging | false \| true | Whether to enable or disable paging |
| page | Number | Page number (default 1) |
| pageSize | Number | Page size (default 50) |

Example: Get all audits which have attribute with ID `VqEFza8wbwA`:

    /api/33/audits/trackedEntityAttributeValue?tea=VqEFza8wbwA

### Tracked entity instance audits { #webapi_tracked_entity_instance_audits } 

Once auditing is enabled for tracked entity instances (by setting `allowAuditLog` of tracked entity types to `true`), all read and search operations are logged. The endpoint for accessing audit logs is located at:

```
/api/audits/trackedEntityInstance
```

Table: Tracked entity instance audit query parameters

| Parameter | Option | Description |
|---|---|---|
| tei | Tracked Entity Instance | One or more tracked entity instance identifiers |
| user | User | One or more user identifiers |
| auditType | SEARCH &#124; READ | Audit type to filter for |
| startDate | Start date | Start date for audits in `yyyy-mm-dd` format |
| endDate | End date | End date for audits in `yyyy-mm-dd` format |
| skipPaging | false &#124; true | Turn paging on / off. |
| paging | false \| true | Whether to enable or disable paging |
| page | Number | Page number  (default 1) |
| pageSize | Number | Page size  (default 50) |

Example: Get all tracked entity instance audits of type read with `startDate` 2018-03-01 and `endDate` 2018-04-24 with a page size of 5:

    /api/33/audits/trackedEntityInstance.json?startDate=2018-03-01&endDate=2018-04-24&auditType=READ&pageSize=5

### Enrollment audits { #webapi_enrollment_audits } 

Once auditing is enabled for enrollments (by setting `allowAuditLog` of tracker programs to `true`), all read operations are logged. The endpoint for accessing audit logs is located at:

```
/api/audits/enrollment
```

Table: Enrollment audit query parameters

| Parameter | Option | Description |
|---|---|---|
| en | Enrollment | One or more tracked entity instance identifiers |
| user | User | One or more user identifiers |
| startDate | Start date | Start date for audit filtering in `yyyy-mm-dd` format |
| endDate | End date | End date for audit filtering in `yyyy-mm-dd` format |
| skipPaging | false &#124; true | Turn paging on / off |
| page | Number | Page number (default 1) |
| pageSize | Number | Page size (default 50) |

Example: Get all enrollment audits with `startDate`2018-03-01 and `endDate` with a page size of 5:

    /api/audits/enrollment?startDate=2018-03-01&endDate=2018-04-24&pageSize=5

Example: Get all enrollment audits for user admin:

    /api/audits/enrollment?user=admin

### Data approval audits

The endpoint for data approval audits is located at:

```
/api/audits/dataApproval
```

Table: Data approval query parameters

| Parameter | Option | Description |
|---|---|---|
| dal | Data approval level ID | One or more data approval level identifiers |
| wf | Data approval workflow ID | One or more data approval workflow identifiers |
| ou | Organisation unit ID | One or more organisation unit identifiers |
| aoc | Attribute option combo ID | One or more attribute option combination identifiers |
| startDate | Start date | Start date for approvals in `yyyy-mm-dd` format |
| endDate | End date | End date for approvals in `yyyy-mm-dd` format |
| skipPaging | false &#124; true | Turn paging on / off |
| page | Number | Page number (default 1) |
| pageSize | Number | Page size (default 50) |

Example: Get all audits for data approval workflow `RwNpkAM7Hw7`:

    /api/33/audits/dataApproval?wf=RwNpkAM7Hw7

