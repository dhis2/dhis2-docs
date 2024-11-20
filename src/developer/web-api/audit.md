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
| auditType | UPDATE &#124; DELETE | Filter by one or more audit types |
| skipPaging | false &#124; true | Turn paging on / off |
| paging | false \| true | Enable or disable paging |
| page | Number | Page number (default 1) |
| pageSize | Number | Page size (default 50) |

Example: Get audits for a data set `lyLU2wR22tC` and audit type `CREATE` or `UPDATE`:

    /api/33/audits/dataValue?ds=lyLU2wR22tC&auditType=CREATE,UPDATE

Example: Get audits for data element `BOSZApCrBni`, org unit `DiszpKrYNg8` and category option combination `TkDhg29x18A`:

    /api/33/audits/dataValue?de=BOSZApCrBni&ou=DiszpKrYNg8&co=TkDhg29x18A

### Tracked entity data value audits { #webapi_tracked_entity_data_value_audits }
**deprecated for removal in version 43 use [tracked entity data value change log endpoint](https://github.com/dhis2/dhis2-docs/blob/master/src/developer/web-api/tracker.md#event-data-value-change-logs--webapi_event_data_value_change_logs-)**

The endpoint for tracked entity data value audits is located at:

```
/api/audits/trackedEntityDataValue
```

Table: Tracked entity data value query parameters

| Parameter | Option | Description |
|---|---|---|
| de | Data element ID | One or more data element identifiers |
| ou | Organisation unit ID | One or more organisation unit identifiers of the audited event |
| events | Events ID | One or more event identifiers of the audited event (comma separated) |
| ps | Program stage ID | One or more program sages of the audit event program |
| startDate | Start date | Return only audit records created after date |
| endDate | End date | Return only audit records created before date |
| ouMode | Organisation unit selection mode | SELECTED \| DESCENDANTS |
| auditType | UPDATE &#124; DELETE | Filter by one or more audit types |
| skipPaging | false &#124; true | Turn paging on / off |
| paging | false \| true | Whether to enable or disable paging |
| page | Number | Page number (default 1) |
| pageSize | Number | Page size (default 50) |

Example: Get audits for data elements `eMyVanycQSC` and `qrur9Dvnyt5`:

    /api/33/audits/trackedEntityDataValue?de=eMyVanycQSC&de=qrur9Dvnyt5

Example: Get audits for org unit `O6uvpzGd5pu` including descendant org units in the org unit hierarchy:

    /api/audits/trackedEntityDataValue?ou=O6uvpzGd5pu&ouMode=DESCENDANTS

### Tracked entity attribute value audits { #webapi_tracked_entity_attribute_value_audits }

**deprecated for removal in version 43 use [tracked entity attribute change log endpoint](https://github.com/dhis2/dhis2-docs/blob/master/src/developer/web-api/tracker.md#tracked-entity-attribute-value-change-logs--webapi_tracker_attribute_change_logs-)**

The endpoint for tracked entity attribute value audits is located at:

```
/api/audits/trackedEntityAttributeValue
```

Table: Tracked entity attribute value query parameters

| Parameter | Option | Description |
|---|---|---|
| tea | Tracked entity attribute ID | One or more tracked entity attribute identifiers |
| trackedEntities | Tracked entity ID | One or more tracked entity identifiers (comma separated) |
| auditType | UPDATE &#124; DELETE | Filter by one or more audit types |
| skipPaging | false &#124; true | Turn paging on / off |
| paging | false \| true | Whether to enable or disable paging |
| page | Number | Page number (default 1) |
| pageSize | Number | Page size (default 50) |

Example: Get audits for tracked entity attribute `VqEFza8wbwA`:

    /api/33/audits/trackedEntityAttributeValue?tea=VqEFza8wbwA

Example: Get audits for tracked entity instance `wNiQ2coVZ39` and audit type `DELETE`:

    /api/33/audits/trackedEntityAttributeValue?trackedEntities=wNiQ2coVZ39&auditType=DELETE

### Tracked entity instance audits { #webapi_tracked_entity_instance_audits }

Once auditing is enabled for tracked entities (by setting `allowAuditLog` of tracked entity types to `true`), all read and search operations are logged. The endpoint for accessing audit logs is located at:

```
/api/audits/trackedEntity
```

Table: Tracked entity audit query parameters

| Parameter | Option | Description |
|---|---|---|
| trackedEntities | Tracked Entity UIDS | One or more tracked entity identifiers (comma separated) |
| user | User | One or more user identifiers |
| auditType | SEARCH &#124; READ | Filter by one or more audit types |
| startDate | Start date | Start date for audits in `yyyy-mm-dd` format |
| endDate | End date | End date for audits in `yyyy-mm-dd` format |
| skipPaging | false &#124; true | Turn paging on / off. |
| paging | false \| true | Whether to enable or disable paging |
| page | Number | Page number  (default 1) |
| pageSize | Number | Page size  (default 50) |

Example: Get audits of audit type `READ` with `startDate` 2018-03-01 and `endDate` 2018-04-24 with a page size of 5:

    /api/33/audits/trackedEntity.json?startDate=2021-03-01&endDate=2022-04-24&auditType=READ&pageSize=5

Example: Get audits for tracked entity `wNiQ2coVZ39`:

    /api/33/audits/trackedEntity.json?trackedEntities=wNiQ2coVZ39

### ***DEPRECATED*** Tracked entity instance audits { #webapi_tracked_entity_instance_audits }

Once auditing is enabled for tracked entity instances (by setting `allowAuditLog` of tracked entity types to `true`), all read and search operations are logged. The endpoint for accessing audit logs is located at:

```
/api/audits/trackedEntityInstance
```

Table: Tracked entity instance audit query parameters

| Parameter | Option | Description |
|---|---|---|
| trackedEntities | Tracked Entity UIDS | One or more tracked entity identifiers (comma separated) |
| user | User | One or more user identifiers |
| auditType | SEARCH &#124; READ | Filter by one or more audit types |
| startDate | Start date | Start date for audits in `yyyy-mm-dd` format |
| endDate | End date | End date for audits in `yyyy-mm-dd` format |
| skipPaging | false &#124; true | Turn paging on / off. |
| paging | false \| true | Whether to enable or disable paging |
| page | Number | Page number  (default 1) |
| pageSize | Number | Page size  (default 50) |

Example: Get audits of audit type `READ` with `startDate` 2018-03-01 and `endDate` 2018-04-24 with a page size of 5:

    /api/33/audits/trackedEntityInstance.json?startDate=2021-03-01&endDate=2022-04-24&auditType=READ&pageSize=5

Example: Get audits for tracked entity `wNiQ2coVZ39`:

    /api/33/audits/trackedEntityInstance.json?trackedEntities=wNiQ2coVZ39


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

Example: Get audits for data approval workflow `i5m0JPw4DQi`:

    /api/33/audits/dataApproval?wf=i5m0JPw4DQi

Exaple: Get audits between `2021-01-01` and `2022-01-01` for org unit `DiszpKrYNg8`:

    /api/33/audits/dataApproval?ou=DiszpKrYNg8&startDate=2021-01-01&endDate=2022-01-01
