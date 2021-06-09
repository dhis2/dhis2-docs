# Data approval

## Data approval { #webapi_data_approval } 

This section explains how to approve, unapprove and check approval
status using the *dataApprovals* resource. Approval is done per data
approval workflow, period, organisation unit and attribute option combo.

    /api/33/dataApprovals

A data approval workflow is associated with several entities:

* A period type which defines the frequency of approval
* An optional category combination
* One or many data approval levels which are part of the workflow
* One or many data sets which are used for data collection

### Get approval status { #webapi_data_approval_get_status } 

To get approval information for a data set you can issue a GET request:

    /api/dataApprovals?wf=rIUL3hYOjJc&pe=201801&ou=YuQRtpLP10I



Table: Data approval query parameters

| Query parameter | Required | Description |
|---|---|---|
| wf | Yes | Data approval workflow identifier |
| pe | Yes | Period identifier |
| ou | Yes | Organisation unit identifier |
| aoc | No | Attribute option combination identifier |

> **Note**
>
> For backward compatibility, the parameter `ds` for data set may be given instead of `wf` for workflow in this and other data approval requests as described below. If the data set is given, the workflow associated with that data set will be used.

This will produce a response similar to this:

```json
{
  "mayApprove": false,
  "mayUnapprove": false,
  "mayAccept": false,
  "mayUnaccept": false,
  "state": "UNAPPROVED_ELSEWHERE"
}
```

The returned parameters are:



Table: Data approval returned parameters

| Return Parameter | Description |
|---|---|
| mayApprove | Whether the current user may approve this data selection. |
| mayUnapprove | Whether the current user may unapprove this data selection. |
| mayAccept | Whether the current user may accept this data selection. |
| mayUnaccept | Whether the current user may unaccept this data selection. |
| state | One of the data approval states from the table below. |



Table: Data approval states

| State | Description |
|---|---|
| UNAPPROVABLE | Data approval does not apply to this selection. (Data is neither approved nor unapproved.) |
| UNAPPROVED_WAITING | Data could be approved for this selection, but is waiting for some lower-level approval before it is ready to be approved. |
| UNAPPROVED_ELSEWHERE | Data is unapproved, and is waiting for approval somewhere else (not approvable here.) |
| UNAPPROVED_READY | Data is unapproved, and is ready to be approved for this selection. |
| APPROVED_HERE | Data is approved, and was approved here (so could be unapproved here.) |
| APPROVED_ELSEWHERE | Data is approved, but was not approved here (so cannot be unapproved here.) This covers the following cases: <br> * Data is approved at a higher level.<br> * Data is approved for wider scope of category options.<br> * Data is approved for all sub-periods in selected period.<br>  In the first two cases, there is a single data approval object that covers the selection. In the third case there is not. |
| ACCEPTED_HERE | Data is approved and accepted here (so could be unapproved here.) |
| ACCEPTED_ELSEWHERE | Data is approved and accepted, but elsewhere. |

Note that when querying for the status of data approval, you may specify
any combination of the query parameters. The combination you specify
does not need to describe the place where data is to be approved at one
of the approval levels. For example:

  - The organisation unit might not be at an approval level. The
    approval status is determined by whether data is approved at an
    approval level for an ancestor of the organisation unit.

  - You may specify individual attribute category options. The approval
    status is determined by whether data is approved for an attribute
    category option combination that includes one or more of these
    options.

  - You may specify a time period that is longer than the period for the
    data set at which the data is entered and approved. The approval
    status is determined by whether the data is approved for all the
    data set periods within the period you specify.

For data sets which are associated with a category combo you might want
to fetch data approval records for individual attribute option combos
from the following resource with a GET request:

    /api/dataApprovals/categoryOptionCombos?wf=rIUL3hYOjJc&pe=201801&ou=YuQRtpLP10I

### Bulk get approval status

To get a list of multiple approval statuses, you can issue a GET request similar to this:

    /api/dataApprovals/approvals?wf=rIUL3hYOjJc&pe=201801,201802&ou=YuQRtpLP10I

The parameters `wf`, `pe`, `ou`, and `aoc` are the same as for getting a single approval status, except that you can provide a comma-separated list of one or more values for each parameter.

This will give you a response containing a list of approval parameters and statuses, something like this:

```json
[
  {
    "aoc": "HllvX50cXC0",
    "pe": "201801",
    "level": "KaTJLhGmU95",
    "ou": "YuQRtpLP10I",
    "permissions": {
      "mayApprove": false,
      "mayUnapprove": true,
      "mayAccept": true,
      "mayUnaccept": false,
      "mayReadData": true
    },
    "state": "APPROVED_HERE",
    "wf": "rIUL3hYOjJc"
  },
  {
    "aoc": "HllvX50cXC0",
    "pe": "201802",
    "ou": "YuQRtpLP10I",
    "permissions": {
      "mayApprove": true,
      "mayUnapprove": false,
      "mayAccept": false,
      "mayUnaccept": false,
      "mayReadData": true
    },
    "state": "UNAPPROVED_READY",
    "wf": "rIUL3hYOjJc"
  }
]
```

The returned fields are described in the table below.

| Field       | Description |
| ----------- | ----------- |
| aoc         | Attribute option combination identifier |
| pe          | Period identifier |
| ou          | Organisation Unit identifier |
| permissions | The permissions: 'mayApprove', 'mayUnapprove', 'mayAccept', 'mayUnaccept', and 'mayReadData' (same definitions as for get single approval status). |
| state       | One of the data approval states (same as for get single approval status.) |
| wf          | Data approval workflow identifier |

### Approve data { #webapi_data_approval_approve_data } 

To approve data you can issue a *POST* request to the *dataApprovals*
resource. To un-approve data, you can issue a *DELETE* request to the
dataApprovals resource.

    POST DELETE /api/33/dataApprovals

To accept data that is already approved you can issue a *POST* request
to the *dataAcceptances* resource. To un-accept data, you can issue a
*DELETE* request to the *dataAcceptances* resource.

    POST DELETE /api/33/dataAcceptances

These requests contain the following parameters:



Table: Data approval action parameters

| Action parameter | Required | Description |
|---|---|---|
| wf | Yes | Data approval workflow identifier |
| pe | Yes | Period identifier |
| ou | Yes | Organisation unit identifier |
| aoc | No | Attribute option combination identifier |

Note that, unlike querying the data approval status, you must specify
parameters that correspond to a selection of data that could be
approved. In particular, both of the following must be true:

  - The organisation unit's level must be specified by an approval level
    in the workflow.

  - The time period specified must match the period type of the
    workflow.

### Bulk approve data { #webapi_data_approval_bulk_approve_data } 

You can approve a bulk of data records by posting to
the `/api/dataApprovals/approvals` resource.

    POST /api/33/dataApprovals/approvals

You can unapprove a bulk of data records by posting to the
`/api/dataApprovals/unapprovals` resource.

    POST /api/33/dataApprovals/unapprovals

You can accept a bulk of records by posting to the
`/api/dataAcceptances/acceptances` resource.

    POST /api/33/dataAcceptances/acceptances

You can unaccept a bulk of records by posting to the
`/api/dataAcceptances/unacceptances` resource.

    POST /api/33/dataAcceptances/unacceptances

The approval payload is supported as JSON and looks like this:

```json
{
  "wf": [
    "pBOMPrpg1QX", "lyLU2wR22tC"
  ],
  "pe": [
    "201601", "201602"
  ],
  "approvals": [
    {
      "ou": "cDw53Ej8rju",
      "aoc": "ranftQIH5M9"
    },
    {
      "ou": "cDw53Ej8rju",
      "aoc": "fC3z1lcAW5x"
    }
  ]
}
```

### Get data approval levels

To retrieve data approval workflows and their data approval levels you
can make a GET request similar to this:

    /api/dataApprovalWorkflows?
      fields=id,name,periodType,dataApprovalLevels[id,name,level,orgUnitLevel]
