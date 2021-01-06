# Audit

## Auditing

<!--DHIS2-SECTION-ID:webapi_auditing-->

DHIS2 does automatic auditing on all updates and deletions of aggregate
data values, tracked entity data values, tracked entity attribute
values, and data approvals. This section explains how to fetch this
data.

### Aggregate data value audits

<!--DHIS2-SECTION-ID:webapi_auditing_aggregate_audits-->

The endpoint for aggregate data value audits is located at
`/api/audits/dataValue`, and the available parameters are displayed in
the table below.

<table>
<caption>Aggregate data value query parameters</caption>
<colgroup>
<col style="width: 12%" />
<col style="width: 14%" />
<col style="width: 72%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ds</td>
<td>Data Set</td>
<td>One or more data set identifiers to get data elements from.</td>
</tr>
<tr class="even">
<td>de</td>
<td>Data Element</td>
<td>One or more data element identifiers.</td>
</tr>
<tr class="odd">
<td>pe</td>
<td>ISO Period</td>
<td>One or more period ISO identifiers.</td>
</tr>
<tr class="even">
<td>ou</td>
<td>Organisation Unit</td>
<td>One or more org unit identifiers.</td>
</tr>
<tr class="odd">
<td>auditType</td>
<td>UPDATE | DELETE</td>
<td>Filter by audit type.</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off</td>
</tr>
<tr class="odd">
<td>page</td>
<td>1 (default)</td>
<td>If paging is enabled, this parameter decides which page to show</td>
</tr>
</tbody>
</table>

Get all audits for data set with ID *lyLU2wR22tC*:

    /api/33/audits/dataValue?ds=lyLU2wR22tC

### Tracked entity data value audits

<!--DHIS2-SECTION-ID:webapi_tracked_entity_data_value_audits-->

The endpoint for tracked entity data value audits is located at
`/api/audits/trackedEntityDataValue`, and the available parameters are
displayed in the table below.

<table>
<caption>Tracked entity data value query parameters</caption>
<colgroup>
<col style="width: 12%" />
<col style="width: 16%" />
<col style="width: 71%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>de</td>
<td>Data Element</td>
<td>One or more data element identifiers.</td>
</tr>
<tr class="even">
<td>ps</td>
<td>Program Stage Entity</td>
<td>One or more program stage instance identifiers.</td>
</tr>
<tr class="odd">
<td>auditType</td>
<td>UPDATE | DELETE</td>
<td>Filter by audit type.</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off</td>
</tr>
<tr class="odd">
<td>page</td>
<td>1 (default)</td>
<td>If paging is enabled, this parameter decides which page to show</td>
</tr>
</tbody>
</table>

Get all audits which have data element ID eMyVanycQSC or qrur9Dvnyt5:

    /api/33/audits/trackedEntityDataValue?de=eMyVanycQSC&de=qrur9Dvnyt5

### Tracked entity attribute value audits

<!--DHIS2-SECTION-ID:webapi_tracked_entity_attribute_value_audits-->

The endpoint for tracked entity attribute value audits is located at
`/api/audits/trackedEntityAttributeValue`, and the available parameters
are displayed in the table below.

<table>
<caption>Tracked entity attribute value query parameters</caption>
<colgroup>
<col style="width: 12%" />
<col style="width: 16%" />
<col style="width: 70%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>tea</td>
<td>Tracked Entity Attributes</td>
<td>One or more tracked entity attribute identifiers.</td>
</tr>
<tr class="even">
<td>te</td>
<td>Tracked Entity Instances</td>
<td>One or more tracked entity instance identifiers.</td>
</tr>
<tr class="odd">
<td>auditType</td>
<td>UPDATE | DELETE</td>
<td>Filter by audit type.</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off</td>
</tr>
<tr class="odd">
<td>page</td>
<td>1 (default)</td>
<td>If paging is enabled, this parameter decides which page to show</td>
</tr>
</tbody>
</table>

Get all audits which have attribute with ID VqEFza8wbwA:

    /api/33/audits/trackedEntityAttributeValue?tea=VqEFza8wbwA

### Tracked entity instance audits

<!--DHIS2-SECTION-ID:webapi_tracked_entity_instance_audits-->

Once auditing is enabled for tracked entity instances (by setting
allowAuditLog of tracked entity types to true), all read and search
operations are logged. The endpoint for accessing audit logs is
api/audits/trackedEntityInstance. Below are available parameters to
interact with this endpoint.

<table>
<caption>Tracked entity instance audit query parameters</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>tei</td>
<td>Tracked Entity Instance</td>
<td>One or more tracked entity instance identifiers</td>
</tr>
<tr class="even">
<td>user</td>
<td>User</td>
<td>One or more user identifiers</td>
</tr>
<tr class="odd">
<td>auditType</td>
<td>SEARCH | READ</td>
<td>Audit type to filter for</td>
</tr>
<tr class="even">
<td>startDate</td>
<td>Start date</td>
<td>Start date for audit filtering in yyyy-mm-dd format.</td>
</tr>
<tr class="odd">
<td>endDate</td>
<td>End date</td>
<td>End date for audit filtering in yyyy-mm-dd format.</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off.</td>
</tr>
<tr class="odd">
<td>page</td>
<td>1 (default)</td>
<td>Specific page to ask for.</td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>50 (default)</td>
<td>Page size.</td>
</tr>
</tbody>
</table>

Get all tracked entity instance audits of type READ with
startDate=2018-03-01 and endDate=2018-04-24 in a page size of 5:

    /api/33/audits/trackedEntityInstance.json?startDate=2018-03-01
      &endDate=2018-04-24&auditType=READ&pageSize=5

### Enrollment audits

<!--DHIS2-SECTION-ID:webapi_enrollment_audits-->

Once auditing is enabled for enrollments (by setting allowAuditLog of
tracker programs to true), all read operations are logged. The
endpoint for accessing audit logs is api/audits/enrollment. Below are
available parameters to interact with this endpoint.

<table>
<caption>Enrollment audit query parameters</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>en</td>
<td>Enrollment</td>
<td>One or more tracked entity instance identifiers</td>
</tr>
<tr class="even">
<td>user</td>
<td>User</td>
<td>One or more user identifiers</td>
</tr>
<tr class="odd">
<td>startDate</td>
<td>Start date</td>
<td>Start date for audit filtering in yyyy-mm-dd format.</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>End date</td>
<td>End date for audit filtering in yyyy-mm-dd format.</td>
</tr>
<tr class="odd">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off.</td>
</tr>
<tr class="even">
<td>page</td>
<td>1 (default)</td>
<td>Specific page to ask for.</td>
</tr>
<tr class="odd">
<td>pageSize</td>
<td>50 (default)</td>
<td>Page size.</td>
</tr>
</tbody>
</table>

Get all enrollment audits with startDate=2018-03-01 and
endDate=2018-04-24 in a page size of 5:

    /api/audits/enrollment.json?startDate=2018-03-01&endDate=2018-04-24&pageSize=5

Get all enrollment audits for user admin:

    /api/audits/enrollment.json?user=admin

### Data approval audits

The endpoint for data approval audits is located at
/api/audits/dataApproval, and the available parameters are displayed in
the table below.

<table>
<caption>Data approval query parameters</caption>
<colgroup>
<col style="width: 12%" />
<col style="width: 16%" />
<col style="width: 70%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dal</td>
<td>Data Approval Level</td>
<td>One or more data approval level identifiers.</td>
</tr>
<tr class="even">
<td>wf</td>
<td>Workflow</td>
<td>One or more data approval workflow identifiers.</td>
</tr>
<tr class="odd">
<td>ou</td>
<td>Organisation Unit</td>
<td>One or more organisation unit identifiers.</td>
</tr>
<tr class="even">
<td>aoc</td>
<td>Attribute Option Combo</td>
<td>One or more attribute option combination identifiers.</td>
</tr>
<tr class="odd">
<td>startDate</td>
<td>Start Date</td>
<td>Starting Date for approvals in yyyy-mm-dd format.</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>End Date</td>
<td>Ending Date for approvals in yyyy-mm-dd format.</td>
</tr>
<tr class="odd">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off</td>
</tr>
<tr class="even">
<td>page</td>
<td>1 (default)</td>
<td><p>If paging is enabled, this parameter decides which page to show.</p></td>
</tr>
</tbody>
</table>

Get all audits for data approval workflow RwNpkAM7Hw7:

    /api/33/audits/dataApproval?wf=RwNpkAM7Hw7

