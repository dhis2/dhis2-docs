# Asynchronous Auditing Service

## Introduction

<!--DHIS2-SECTION-ID:audit-->

From version 2.34 DHIS2 has implemented new Audit service that based on Apache ActiveMQ Artemis as an asynchronous messaging system.

Basically, after an entity is saved to database, an Audit message will be sent to Artemis message consumer service. The message will then be processed in a different thread.

By this, the audit service will not block current application thread, thus improves system performance.

Currently, there is no UI or API endpoint to retrive Audit entries. It's only available in database.

`Note that by default the Auditing service is disabled. `


## Single Audit table

<!--DHIS2-SECTION-ID:audit_table-->

All audit entries will be saved into one single table named `audit`  as below

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

<!--DHIS2-SECTION-ID:audit_configuration-->

The audit matrix configuration can be defined in `dhis.conf`  file as below. By default those audit settings are disabled.
 
```
# ------------------------------------------------
# Audit
# ------------------------------------------------

metadata.audit.persist = on
tracker.audit.persist = on
audit.metadata=CREATE;UPDATE;DELETE
audit.tracker=READ;CREATE;UPDATE;DELETE

```

## Audit Scope

<!--DHIS2-SECTION-ID:audit_scope-->

Currently AuditScope includes: 

- `METADATA`: all Metadata objects in DHIS2 ( DataElement, DataSet, Cagegory, etc. )
- `TRACKER`: TrackedEntityInstance, Event, Enrollment, TrackedEntityAttributeValue, TrackedEntityDataValue.
- `AGGREGATE`: aggregate data value