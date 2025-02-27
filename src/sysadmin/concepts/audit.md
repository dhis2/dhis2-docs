# Audit

## Introduction

DHIS2 supports a new audit service based on _Apache ActiveMQ Artemis_. Artemis is used as an asynchronous messaging system by DHIS2.

After an entity is saved to database, an audit message will be created and sent to the Artemis message consumer service. The message will then be processed in a different thread.

Audit logs can be retrieved from the DHIS2 database. Currently there is no UI or API endpoint available for retrieving audit entries.

Detailed explanation of the audit system architecture can be found [here](https://github.com/dhis2/wow-backend/blob/master/guides/auditing.md).

## What we log { #what_we_log }

This is the list of operations we log as part of the audit system:

- Operations on user accounts (like but not limited to creation, profile edits)
- Operations on user roles, groups and authority groups
- Operations on metadata objects (like but not limited to categories, organization units, reports)
- Operations on tracked objects (like but not limited to instances, attributes, data values)
- Jobs configuration
- Breaking the glass operations

## Single Audit table { #audit_table }

All audit entries, except the ones related to tracked entities, will be saved into one single table named `audit`

| Column | Type | Description |
| --- | --- | --- |
| auditid | integer | Primary key. |
| audittype | text | READ, CREATE, UPDATE, DELETE, SEARCH |
| auditscope | text | METADATA, AGGREGATE, TRACKER |
| klass | text | Audit Entity Java class name. |
| attributes | jsonb | A JSON string with attributes of the audited object. Example: `{"valueType":"TEXT", "categoryCombo":"SWQW313FQY", "domainType":"TRACKER"}`. |
| data | bytea | Compressed JSON string of the audit entity in byte array format (not humanly readable). |
| createdat | timestamp without time zone | Time of creation. |
| createdby | text | Username of the user performing the audited operation. |
| uid | text | The UID of the audited object. |
| code | text | The code of the audited object. |

The audit service makes use of two new concepts: _Audit Scope_ and _Audit Type_.

## Audit Scope { #audit_scope }

An audit scope is a logical area of the application which can be audited. Currently there are three audit scopes.

| **Scope** | Key       | Audited objects                                              |
| --------- | --------- | ------------------------------------------------------------ |
| Tracker   | TRACKER   | Tracked Entity Instance, Tracked Entity Attribute Value, Enrollment, Event. |
| Metadata  | METADATA  | All metadata objects (e.g. Data Element, Organisation Unit). |
| Aggregate | AGGREGATE | Aggregate Data Value.                                        |

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

## Tracked entity audits

Operations on tracked entities like instances, attributes and values are stored, respectively in the `trackedentityinstanceaudit`, `trackedentityattributevalueaudit` and `trackedentitydatavalueaudit` tables.

### trackedentityinstanceaudit

| Column | Type | Description |
| --- | --- | --- |
| trackedentityinstanceauditid | integer | Primary key. |
| trackedentityinstance | text | Tracked entity instance name. |
| created | timestamp without time zone | Time of creation. |
| accessedby | text | Username of the user performing the audited operation. |
| audittype | text | READ, CREATE, UPDATE, DELETE, SEARCH |
| comment | text | The code of the audited object. |

This data can be retrieved via [API](#webapi_tracked_entity_instance_audits).

### trackedentityattributevalueaudit

| Column | Type | Description |
| --- | --- | --- |
| trackedentityattributevalueauditid | integer | Primary key. |
| trackedentityinstanceid | integer | Instance ID of which the attribute value belongs to. |
| trackedentityattributeid | integer | Attribute ID. |
| created | timestamp without time zone | Time of creation. |
| modifiedby | text | Username of the user performing the audited operation. |
| audittype | text | READ, CREATE, UPDATE, DELETE, SEARCH |
| value | text | The value of the audited object. |
| encryptedvalue | text | The encrypted value if confidentiality flag is set. |

This data can be retrieved via [API](#webapi_tracked_entity_attribute_value_audits).

### trackedentitydatavalueaudit

| Column | Type | Description |
| --- | --- | --- |
| trackedentitydatavalueauditid | integer | Primary key. |
| programstageinstanceid | integer | Program stage ID of which the data value belongs to. |
| dataelementid | integer | ID of the data element. |
| created | timestamp without time zone | Time of creation. |
| modifiedby | text | Username of the user performing the audited operation. |
| audittype | text | READ, CREATE, UPDATE, DELETE, SEARCH |
| value | text | The value of the audited object. |
| providedelsewhere | bool | Indicates whether the user provided the value elsewhere or not. |

This data can be retrieved via [API](#webapi_tracked_entity_data_value_audits).

## Breaking the glass

Breaking the glass features allows to access records a DHIS2 user doesn't have access in special circumstances. As a result of such, users must enter a reason to access such records.

A video explaining how it works can be found in our Youtube channel [here](https://www.youtube.com/watch?v=rTwg5Ix_E_M).

The breaking the glass event is stored in the `programtempownershipaudit` table, described below:

| Column | Type | Description |
| --- | --- | --- |
| programtempownershipauditid | integer | Primary key. |
| programid | integer | Program ID of which the tracked entity belongs to. |
| trackedentityinstanceid | integer | Instance ID of which the attribute value belongs to. |
| created | timestamp without time zone | Time of creation. |
| accessedby | text | Username of the user performing the audited operation. |
| reason | text | The reason as inserted in the dialog. |

## Setup { #audit_configuration }

The audit system is enabled by default for the following scopes and types.

Scopes (case sensitive):

- `READ`
- `CREATE`
- `UPDATE`
- `DELETE`
- `SEARCH`
- `DISABLED`

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

- `audit.metadata`
- `audit.tracker`
- `audit.aggregate`

### Artemis

[Apache ActiveMQ Artemis](https://activemq.apache.org/components/artemis/documentation/) is an open source project to build a multi-protocol, embeddable, very high performance, clustered, asynchronous messaging system. It has been part of DHIS2 since version 2.31 and used as a system to consume audit logs.

By default, DHIS2 will start an embedded Artemis server, which is used internally by the application to store and access audit events.

However, if you have already an Artemis server, you can connect to it from DHIS2 to send audit events, as described in our [official documentation](#webapi_amqp_configuration): in this setup, audit events will flow from DHIS2 to the external Artemis system.

### log4j2

[log4j2](https://logging.apache.org/log4j/2.x/index.html) is the default DHIS2 logging library used to handle output messages. It's used to control what events are recored in which file.

The application ships a [log4j2 default configuration file](https://github.com/dhis2/dhis2-core/blob/master/dhis-2/dhis-web/dhis-web-commons-resources/src/main/webapp/WEB-INF/classes/log4j2.xml), which instructs what information to log and where (console). DHIS2 then takes care of import that file and instruction logging as described in the [log4j configuration class](https://github.com/dhis2/dhis2-core/blob/2.38/dhis-2/dhis-support/dhis-support-system/src/main/java/org/hisp/dhis/system/log/Log4JLogConfigInitializer.java), that is, redirecting output from console to files.

From 2.36 to 2.38, audit log file `dhis-audit.log` is rotated [every day at midnight](https://github.com/dhis2/dhis2-core/blob/2.38/dhis-2/dhis-support/dhis-support-system/src/main/java/org/hisp/dhis/system/log/Log4JLogConfigInitializer.java#L171).

An example of custom log4j2 configuration can be found [here](): it shows how to configure DHIS2 to save all logs into an external storage location, rotate them on a weekly basis and retain them for 30 days. Please read the [application logging section](#install_application_logging) on how to use it.

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

We recommend keeping the audit trails into a file, as by default in version 2.38. For older versions, the following configuration saves the audit logs into the `$DHIS2_HOME/logs/dhis-audit.log` file:

```properties
audit.database = off
audit.logger = on
```

To store audit data into the database, add the following to your `dhis.conf` file (default up until version 2.38):

```properties
audit.database = on
audit.logger = off
```

To extract logs from the `audit` table, you can use [`dhis2-audit-data-extractor`](https://github.com/dhis2/dhis2-utils/tree/master/tools/dhis2-audit-data-extractor) from the system where DHIS2 is running:

```
$ python extract_audit.py extract
```

Please read the documentation for full details.

To parse entries from log file, you can use the python script as follow:

```
$ grep "auditType" dhis-audit.log | python extract_audit.py parse
```

Or use `jq` as follow:

```
$ grep "auditType" dhis-audit.log | jq -r .
```

To select events within a specific date, you can use `jq` as follow (in this example, we're selecting all events happened between January 2022 and end of June 2022):

```
$ grep "auditType" dhis-audit.log | jq -r '.[] | select ( (.datetime >="2022-01-01") and (.datetime <= "2022-06-30") )'
```

Same with `extract_audit`:

```
$ python3 extract_audit.py extract -m stdout -f JSON | jq -r '.[] | select ( (.datetime >="2022-01-01") and (.datetime <= "2022-06-30") )'
```
