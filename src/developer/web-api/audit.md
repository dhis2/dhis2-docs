# Audit

## Auditing { #webapi_auditing } 

DHIS2 does automatic auditing on all updates and deletions of aggregate
data values, tracked entity data values, tracked entity attribute
values, and data approvals. This section explains how to fetch this
data.

### Aggregate data value audits { #webapi_auditing_aggregate_audits } 

The endpoint for aggregate data value audits is located at
`/api/audits/dataValue`, and the available parameters are displayed in
the table below.



Table: Aggregate data value query parameters

| Parameter | Option | Description |
|---|---|---|
| ds | Data Set | One or more data set identifiers to get data elements from. |
| de | Data Element | One or more data element identifiers. |
| pe | ISO Period | One or more period ISO identifiers. |
| ou | Organisation Unit | One or more org unit identifiers. |
| auditType | UPDATE &#124; DELETE | Filter by audit type. |
| skipPaging | false &#124; true | Turn paging on / off |
| page | 1 (default) | If paging is enabled, this parameter decides which page to show |

Get all audits for data set with ID *lyLU2wR22tC*:

    /api/33/audits/dataValue?ds=lyLU2wR22tC

### Tracked entity data value audits { #webapi_tracked_entity_data_value_audits } 

The endpoint for tracked entity data value audits is located at
`/api/audits/trackedEntityDataValue`, and the available parameters are
displayed in the table below.



Table: Tracked entity data value query parameters

| Parameter | Option | Description |
|---|---|---|
| de | Data Element | One or more data element identifiers. |
| ps | Program Stage Entity | One or more program stage instance identifiers. |
| auditType | UPDATE &#124; DELETE | Filter by audit type. |
| skipPaging | false &#124; true | Turn paging on / off |
| page | 1 (default) | If paging is enabled, this parameter decides which page to show |

Get all audits which have data element ID eMyVanycQSC or qrur9Dvnyt5:

    /api/33/audits/trackedEntityDataValue?de=eMyVanycQSC&de=qrur9Dvnyt5

### Tracked entity attribute value audits { #webapi_tracked_entity_attribute_value_audits } 

The endpoint for tracked entity attribute value audits is located at
`/api/audits/trackedEntityAttributeValue`, and the available parameters
are displayed in the table below.



Table: Tracked entity attribute value query parameters

| Parameter | Option | Description |
|---|---|---|
| tea | Tracked Entity Attributes | One or more tracked entity attribute identifiers. |
| te | Tracked Entity Instances | One or more tracked entity instance identifiers. |
| auditType | UPDATE &#124; DELETE | Filter by audit type. |
| skipPaging | false &#124; true | Turn paging on / off |
| page | 1 (default) | If paging is enabled, this parameter decides which page to show |

Get all audits which have attribute with ID VqEFza8wbwA:

    /api/33/audits/trackedEntityAttributeValue?tea=VqEFza8wbwA

### Tracked entity instance audits { #webapi_tracked_entity_instance_audits } 

Once auditing is enabled for tracked entity instances (by setting
allowAuditLog of tracked entity types to true), all read and search
operations are logged. The endpoint for accessing audit logs is
api/audits/trackedEntityInstance. Below are available parameters to
interact with this endpoint.



Table: Tracked entity instance audit query parameters

| Parameter | Option | Description |
|---|---|---|
| tei | Tracked Entity Instance | One or more tracked entity instance identifiers |
| user | User | One or more user identifiers |
| auditType | SEARCH &#124; READ | Audit type to filter for |
| startDate | Start date | Start date for audit filtering in yyyy-mm-dd format. |
| endDate | End date | End date for audit filtering in yyyy-mm-dd format. |
| skipPaging | false &#124; true | Turn paging on / off. |
| page | 1 (default) | Specific page to ask for. |
| pageSize | 50 (default) | Page size. |

Get all tracked entity instance audits of type READ with
startDate=2018-03-01 and endDate=2018-04-24 in a page size of 5:

    /api/33/audits/trackedEntityInstance.json?startDate=2018-03-01
      &endDate=2018-04-24&auditType=READ&pageSize=5

### Enrollment audits { #webapi_enrollment_audits } 

Once auditing is enabled for enrollments (by setting allowAuditLog of
tracker programs to true), all read operations are logged. The
endpoint for accessing audit logs is api/audits/enrollment. Below are
available parameters to interact with this endpoint.



Table: Enrollment audit query parameters

| Parameter | Option | Description |
|---|---|---|
| en | Enrollment | One or more tracked entity instance identifiers |
| user | User | One or more user identifiers |
| startDate | Start date | Start date for audit filtering in yyyy-mm-dd format. |
| endDate | End date | End date for audit filtering in yyyy-mm-dd format. |
| skipPaging | false &#124; true | Turn paging on / off. |
| page | 1 (default) | Specific page to ask for. |
| pageSize | 50 (default) | Page size. |

Get all enrollment audits with startDate=2018-03-01 and
endDate=2018-04-24 in a page size of 5:

    /api/audits/enrollment.json?startDate=2018-03-01&endDate=2018-04-24&pageSize=5

Get all enrollment audits for user admin:

    /api/audits/enrollment.json?user=admin

### Data approval audits

The endpoint for data approval audits is located at
/api/audits/dataApproval, and the available parameters are displayed in
the table below.



Table: Data approval query parameters

| Parameter | Option | Description |
|---|---|---|
| dal | Data Approval Level | One or more data approval level identifiers. |
| wf | Workflow | One or more data approval workflow identifiers. |
| ou | Organisation Unit | One or more organisation unit identifiers. |
| aoc | Attribute Option Combo | One or more attribute option combination identifiers. |
| startDate | Start Date | Starting Date for approvals in yyyy-mm-dd format. |
| endDate | End Date | Ending Date for approvals in yyyy-mm-dd format. |
| skipPaging | false &#124; true | Turn paging on / off |
| page | 1 (default) | If paging is enabled, this parameter decides which page to show. |

Get all audits for data approval workflow RwNpkAM7Hw7:

    /api/33/audits/dataApproval?wf=RwNpkAM7Hw7

