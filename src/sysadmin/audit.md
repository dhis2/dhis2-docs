# Audit

## Introduction

DHIS2 supports a new audit service based on _Apache ActiveMQ Artemis_. Artemis is used as an asynchronous messaging system by DHIS2.

After an entity is saved to database, an audit message will be created and sent to the Artemis message consumer service. The message will then be processed in a different thread.

Audit logs can be retrieved from the DHIS2 database. Currently there is no UI or API endpoint available for retrieving audit entries.


## Single Audit table { #audit_table } 

All audit entries will be saved into one single table named `audit`

| Column     | Type                        | Description |   |
|------------|-----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|---|
| auditid    | integer                     | Primary key. |   |
| audittype  | text                        | READ, CREATE, UPDATE, DELETE, SEARCH                                                                                                                  |   |
| auditscope | text                        | METADATA, AGGREGATE, TRACKER                                                                                                                        |   |
| klass      | text                        | Audit Entity Java class name.                                                                                                                     |   |
| attributes | jsonb                       | A JSON string with attributes of the audited object. Example: `{"valueType":"TEXT", "categoryCombo":"SWQW313FQY", "domainType":"TRACKER"}`. |   |
| data       | bytea                       | Compressed JSON string of the audit entity in byte array format (not humanly readable).                                                                                             |   |
| createdat  | timestamp without time zone | Time of creation. |   |
| createdby  | text                        | Username of the user performing the audited operation. |   |
| uid        | text                        | The UID of the audited object. |   |
| code       | text                        | The code of the audited object. |   |

The audit service makes use of two new concepts: *Audit Scope* and *Audit Type*.

## Audit Scope { #audit_scope } 

An audit scope is a logical area of the application which can be audited. Currently there are three audit scopes.

| **Scope** | Key       | Audited objects                                              |
| --------- | --------- | ------------------------------------------------------------ |
| Tracker   | tracker   | Tracked Entity Instance, Tracked Entity Attribute Value, Enrollment, Event. |
| Metadata  | metadata  | All metadata objects (e.g. Data Element, Organisation Unit). |
| Aggregate | aggregate | Aggregate Data Value.                                        |


## Audit Type { #audit_type } 

An audit type is an action that triggers an audit operation. Currently we support the following four types.

| Name     | Key      | Description         |
| -------- | -------- | ------------------- |
| Read     | READ     | Object was read.    |
| Create   | CREATE   | Object was created. |
| Update   | UPDATE   | Object was updated. |
| Delete   | DELETE   | Object was deleted. |
| Disabled | DISABLED | Disable audit.      |

> **Caution**
>
> The READ audit type may generate a lot of data in the database and may have an impact on the performance.

## Setup { #audit_configuration } 

The audit system is enabled by default for the following scopes and types.

Scopes:

- `CREATE`
- `UPDATE`
- `DELETE`

Types:

- `METADATA`
- `TRACKER`
- `AGGREGATE`

This means that **no action is required** to enable the default audit system. The default setting is equivalent to the following `dhis.conf` configuration.

```properties
audit.metadata = CREATE;UPDATE;DELETE
audit.tracker = CREATE;UPDATE;DELETE
audit.aggregate = CREATE;UPDATE;DELETE
```

The audit can be configured using the _audit matrix_. The audit matrix represents the valid combinations of scopes and types, and is defined with the following properties in the `dhis.conf` configuration file. Each property accepts a semicolon (`;`) delimited list of audit types.

* `audit.metadata`
* `audit.tracker`
* `audit.aggregate`

## Examples

This section demonstrates how to configure the audit system in `dhis.conf`.

To enable audit of create and update of metadata and tracker only:

```properties
audit.metadata = CREATE;UPDATE
audit.tracker = CREATE;UPDATE
audit.aggregate = DISABLED
```

To only audit tracker related objects create and delete:

```properties
audit.metadata = DISABLED
audit.tracker = CREATE;DELETE
audit.aggregate = DISABLED
```

To completely disable audit for all scopes:
```properties
audit.metadata = DISABLED
audit.tracker = DISABLED
audit.aggregate = DISABLED
```

