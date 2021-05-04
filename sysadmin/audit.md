# Audit

## Introduction

DHIS2 supports a new audit service which is based on Apache ActiveMQ Artemis. Artemis is used as an asynchronous messaging system by DHIS2.

After an entity is saved to database, an audit message will be sent to the Artemis message consumer service. The message will then be processed in a different thread.

Audit logs can be retrieved from the DHIS2 database. Currently there is no UI or API endpoint available for retriving audit entries.


## Single Audit table

<!--DHIS2-SECTION-ID:audit_table-->

All audit entries will be saved into one single table named `audit`

| Column     | Type                        |                                                                                                                                                   |   |
|------------|-----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|---|
| auditid    | integer                     |                                                                                                                                                   |   |
| audittype  | text                        | READ, CREATE, UPDATE, DELETE, SEARCH                                                                                                                  |   |
| auditscope | text                        | METADATA, AGGREGATE, TRACKER                                                                                                                        |   |
| klass      | text                        | Audit Entity Java class name                                                                                                                      |   |
| attributes | jsonb                       | Json string stores attributes of the audit entity, used for searching. Example: {"valueType":"TEXT", "categoryCombo":"SWQW313FQY", "domainType":"TRACKER"} |   |
| data       | bytea                       | Compressed Json string of the Audit Entity. It is currently in byte array format and not human-readable.              |   |
| createdat  | timestamp without time zone |                                                                                                                                                   |   |
| createdby  | text                        |                                                                                                                                                   |   |
| uid        | text                        |                                                                                                                                                   |   |
| code       | text                        |                                                                                                                                                   |   |
|            |                             |   



The new Audit service makes use of two new concepts: Audit Scopes and Audit Type.

## Audit Scope

<!--DHIS2-SECTION-ID:audit_scope-->

An Audit Scope is a logical area of the application which can be audited. Currently there are three Audit Scopes:

```
Tracker

Metadata

Aggregate
```

- For the Tracker Audit Scope, the audited objects are:
Tracked Entity Instance, Tracked Entity Attribute Value, Enrollment, Event

- For the Metadata Scope, all "metadata" objects are audited.

- For the Aggregate Scope, the Aggregate Data Value objects are audited.


## Audit Type

<!--DHIS2-SECTION-ID:audit_type-->

An Audit Type is an action that triggers an audit operation. Currently we support the following types:

```
READ

CREATE

UPDATE

DELETE
```

As an example, when a new Tracked Entity Instance gets created, and if configured like so, the CREATE action is used to insert a new Audit entry in the audit db table.

> **Caution**
>
> The READ Audit Type will generate a lot of data in database and may have an impact on the performance.

## Setup

<!--DHIS2-SECTION-ID:audit_configuration-->

The audit system is automatically configured to audit for the following scopes and types:

- CREATE, UPDATE, DELETE

- METADATA, TRACKER, AGGREGATE

**No action is required to activate the audit.**
The audit can still be configured using the "audit matrix". The audit matrix is driven by 3 properties in dhis.conf:

```
audit.metadata

audit.tracker

audit.aggregate
```

Each property accepts a semicolon delimited list of valid Audit Types:

```
CREATE

UPDATE

DELETE

READ
```

For instance, in order to only audit Tracker related object creation and deletion, the following property should be added to `dhis.conf`:

```
audit.tracker = CREATE;DELETE
```

In order to completely disable auditing, this is the configuration to use:
```
audit.metadata = DISABLED 

audit.tracker = DISABLED 

audit.aggregate = DISABLED
```

