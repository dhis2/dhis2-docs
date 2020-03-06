# Asynchronous Auditing Service

## Introduction

DHIS2 supports a new audit service which is based on Apache ActiveMQ Artemis. Artemis is used as an asynchronous messaging system by DHIS2.

Aafter an entity is saved to database, an audit message will be sent to the Artemis message consumer service. The message will then be processed in a different thread.

Audit logs can be retrieved from the DHIS2 database. Currently there is no UI or API endpoint available for retriving audit entries.

Note that by default, the auditing service is disabled.


## Single Audit table

All audit entries will be saved into one single table named `audit`.

| Column     | Type                        |                                                                                                                                                   |   |
|------------|-----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|---|
| auditid    | integer                     |                                                                                                                                                   |   |
| audittype  | text                        | READ, CREATE, UPDATE, DELETE, SEARCH                                                                                                                  |   |
| auditscope | text                        | METADATA, AGGREGATE, TRACKER                                                                                                                        |   |
| klass      | text                        | Audit Entity Java class name                                                                                                                      |   |
| attributes | jsonb                       | Json string stores attributes of the audit entity, used for searching. Example: {"valueType":"TEXT", "categoryCombo":"SWQW313FQY", "domainType":"TRACKER"} |   |
| data       | bytea                       | Compressed Json string of the Audit Entity                                                                                                        |   |
| createdat  | timestamp without time zone |                                                                                                                                                   |   |
| createdby  | text                        |                                                                                                                                                   |   |
| uid        | text                        |                                                                                                                                                   |   |
| code       | text                        |                                                                                                                                                   |   |
|            |                             |   


## Setup

The audit matrix configuration can be defined in `dhis.conf`  file as below. By default, audit is disabled.
 
```properties
metadata.audit.persist = on
tracker.audit.persist = on
audit.metadata=CREATE;UPDATE;DELETE
audit.tracker=READ;CREATE;UPDATE;DELETE
```

## Audit Scope

Currently AuditScope includes: 

- `METADATA`: All metadata objects in DHIS2 (DataElement, DataSet, Cagegory, and more).
- `TRACKER`: TrackedEntityInstance, Event, Enrollment, TrackedEntityAttributeValue, TrackedEntityDataValue.
- `AGGREGATE`: Aggregate DataValue.
