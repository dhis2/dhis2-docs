# Visualizations
## Dashboard { #webapi_dashboard } 

The dashboard is designed to give you an overview of multiple analytical
items like maps, charts, pivot tables and reports which together can
provide a comprehensive overview of your data. Dashboards are available
in the Web API through the *dashboards* resource. A dashboard contains a
list of dashboard *items*. An item can represent a single resource, like
a chart, map or report table, or represent a list of links to analytical
resources, like reports, resources, tabular reports and users. A
dashboard item can contain up to eight links. Typically, a dashboard
client could choose to visualize the single-object items directly in a
user interface, while rendering the multi-object items as clickable
links.

    /api/dashboards

### Browsing dashboards { #webapi_browsing_dashboards } 

To get a list of your dashboards with basic information including
identifier, name and link in JSON format you can make a *GET* request to
the following URL:

    /api/dashboards.json

The dashboards resource will provide a list of dashboards. Remember that
the dashboard object is shared so the list will be affected by the
currently authenticated user. You can retrieve more information about a
specific dashboard by following its link, similar to this:

    /api/dashboards/vQFhmLJU5sK.json

A dashboard contains information like name and creation date and an
array of dashboard items. The response in JSON format will look similar
to this response (certain information has been removed for the sake of
brevity).

```json
{
  "lastUpdated" : "2013-10-15T18:17:34.084+0000",
  "id": "vQFhmLJU5sK",
  "created": "2013-09-08T20:55:58.060+0000",
  "name": "Mother and Child Health",
  "href": "https://play.dhis2.org/demo/api/dashboards/vQFhmLJU5sK",
  "publicAccess": "--------",
  "restrictFilters": false,
  "externalAccess": false,
  "itemCount": 17,
  "displayName": "Mother and Child Health",
  "access": {
    "update": true,
    "externalize": true,
    "delete": true,
    "write": true,
    "read": true,
    "manage": true
  },
  "user": {
    "id": "xE7jOejl9FI",
    "name": "John Traore",
    "created": "2013-04-18T15:15:08.407+0000",
    "lastUpdated": "2014-12-05T03:50:04.148+0000",
    "href": "https://play.dhis2.org/demo/api/users/xE7jOejl9FI"
  },
  "dashboardItems": [{
    "id": "bu1IAnPFa9H",
    "created": "2013-09-09T12:12:58.095+0000",
    "lastUpdated": "2013-09-09T12:12:58.095+0000"
    }, {
    "id": "ppFEJmWWDa1",
    "created": "2013-09-10T13:57:02.480+0000",
    "lastUpdated": "2013-09-10T13:57:02.480+0000"
  }],
  "userGroupAccesses": []
}
```

A more tailored response can be obtained by specifying specific fields
in the request. An example is provided below, which would return more
detailed information about each object on a users dashboard.

    /api/dashboards/vQFhmLJU5sK/?fields=:all,dashboardItems[:all]

### Searching dashboards { #webapi_searching_dasboards } 

When a user is building a dashboard it is convenient
to be able to search for various analytical resources using the
*/dashboards/q* resource. This resource lets you search for matches on
the name property of the following objects: charts, maps, report tables,
users, reports and resources. You can do a search by making a *GET*
request on the following resource URL pattern, where my-query should be
replaced by the preferred search query:

    /api/dashboards/q/my-query.json

For example, this query:

    /api/dashboards/q/ma?count=6&maxCount=20&max=CHART&max=MAP

Will search for the following:

* Analytical object name contains the string "ma"
* Return up to 6 of each type
* For CHART and MAP types, return up to 20 items



Table: dashboards/q query parameters

| Query parameter | Description | Type | Default |
|---|---|---|---|
| count | The number of items of each type to return | Positive integer | 6 |
| maxCount | The number of items of max types to return | Positive integer | 25 |
| max | The type to return the maxCount for | String [CHART&#124;MAP&#124;REPORT_TABLE&#124;USER&#124;REPORT&#124;RESOURCE&#124;VISUALIZATION] | N/A |

JSON and XML response formats are supported. The response in JSON format
will contain references to matching resources and counts of how many
matches were found in total and for each type of resource. It will look
similar to this:

```json
{
  "charts": [{
    "name": "ANC: 1-3 dropout rate Yearly",
    "id": "LW0O27b7TdD"
  }, {
    "name": "ANC: 1 and 3 coverage Yearly",
    "id": "UlfTKWZWV4u"
  }, {
    "name": "ANC: 1st and 3rd trends Monthly",
    "id": "gnROK20DfAA"
  }],
  "visualizations": [{
    "name": "ANC: ANC 3 Visits Cumulative Numbers",
    "id": "arf9OiyV7df",
    "type": "LINE"
  }, {
    "name": "ANC: 1st and 2rd trends Monthly",
    "id": "jkf6OiyV7el",
    "type": "PIVOT_TABLE"
  }],
  "maps": [{
    "name": "ANC: 1st visit at facility (fixed) 2013",
    "id": "YOEGBvxjAY0"
  }, {
    "name": "ANC: 3rd visit coverage 2014 by district",
    "id": "ytkZY3ChM6J"
  }],
  "reportTables": [{
    "name": "ANC: ANC 1 Visits Cumulative Numbers",
    "id": "tWg9OiyV7mu"
  }],
  "reports": [{
    "name": "ANC: 1st Visit Cumulative Chart",
    "id": "Kvg1AhYHM8Q"
  }, {
    "name": "ANC: Coverages This Year",
    "id": "qYVNH1wkZR0"
  }],
  "searchCount": 8,
  "chartCount": 3,
  "mapCount": 2,
  "reportTableCount": 1,
  "reportCount": 2,
  "userCount": 0,
  "patientTabularReportCount": 0,
  "resourceCount": 0
}
```

### Creating, updating and removing dashboards { #webapi_creating_updating_removing_dashboards } 

Creating, updating and deleting dashboards follow standard REST
semantics. In order to create a new dashboard you can make a *POST*
request to the `/api/dashboards` resource. From a consumer perspective
it might be convenient to first create a dashboard and later add items
to it. JSON and XML formats are supported for the request payload. To
create a dashboard with the name "My dashboard" you can use a payload in
JSON like this:

    {
      "name": "My dashboard"
    }

To update, e.g. rename, a dashboard, you can make a *PUT* request with a
similar request payload the same api/dashboards resource.

To remove a dashboard, you can make a *DELETE* request to the specific
dashboard resource similar to this:

    /api/dashboards/vQFhmLJU5sK

### Adding, moving and removing dashboard items and content { #webapi_adding_moving_removing_dashboard_items } 

In order to add dashboard items a consumer can use the
`/api/dashboards/<dashboard-id>/items/content` resource, where
<dashboard-id\> should be replaced by the relevant dashboard
identifier. The request must use the *POST* method. The URL syntax and
parameters are described in detail in the following table.



Table: Items content parameters

| Query parameter | Description | Options |
|---|---|---|
| type | Type of the resource to be represented by the dashboard item | chart &#124; visualization &#124; map &#124; reportTable &#124; users &#124; reports &#124; reportTables &#124; resources &#124; patientTabularReports &#124; app |
| id | Identifier of the resource to be represented by the dashboard item | Resource identifier |

A *POST* request URL for adding a chart to a specific dashboard could
look like this, where the last id query parameter value is the chart
resource
    identifier:

    /api/dashboards/vQFhmLJU5sK/items/content?type=chart&id=LW0O27b7TdD

When adding resource of type map, chart, report table and app, the API
will create and add a new item to the dashboard. When adding a resource
of type users, reports, report tables and resources, the API will try to
add the resource to an existing dashboard item of the same type. If no
item of same type or no item of same type with less than eight resources
associated with it exists, the API will create a new dashboard item and
add the resource to it.

In order to move a dashboard item to a new position within the list of
items in a dashboard, a consumer can make a *POST* request to the
following resource URL, where `<dashboard-id>` should be replaced by the
identifier of the dashboard, `<item-id>` should be replaced by the
identifier of the dashboard item and `<index>` should be replaced by the
new position of the item in the dashboard, where the index is
zero-based:

    /api/dashboards/<dashboard-id>/items/<item-id>/position/<index>

To remove a dashboard item completely from a specific dashboard a
consumer can make a *DELETE* request to the below resource URL, where
`<dashboard-id>` should be replaced by the identifier of the dashboard
and `<item-id>` should be replaced by the identifier of the dashboard
item. The dashboard item identifiers can be retrieved through a GET
request to the dashboard resource URL.

    /api/dashboards/<dashboard-id>/items/<item-id>

To remove a specific content resource within a dashboard item a consumer
can make a *DELETE* request to the below resource URL, where
`<content-resource-id>` should be replaced by the identifier of a
resource associated with the dashboard item; e.g. the identifier of a
report or a user. For instance, this can be used to remove a single
report from a dashboard item of type reports, as opposed to removing the
dashboard item completely:

    /api/dashboards/<dashboard-id>/items/<item-id>/content/<content-resource-id>

## Visualization { #webapi_visualization } 

The Visualization API is designed to help clients to interact with charts and pivot/report tables. The endpoints of this API are used by the Data Visualization application which allows the creation, configuration and management of charts and pivot tables based on the client's definitions. The main idea is to enable clients and users to have a unique and centralized API providing all types of charts and pivot tables as well as specific parameters and configuration for each type of visualization.

This API was introduced with the expectation to unify both `charts` and `reportTables` APIs and entirely replace them in favour of the `visualizations` API (which means that the usage of `charts` and `reportTables` APIs should be avoided). In summary, the following resources/APIs:

    /api/charts, /api/reportTables

*are being replaced by*

    /api/visualizations

> **Note**
>
> New applications and clients should avoid using the `charts` and `reportTables` APIs because they are deprecated. Use the `visualizations` API instead.

A Visualization object is composed of many attributes (some of them related to charts and others related to pivot tables), but the most important ones responsible to reflect the core information of the object are: *"id", "name", "type", "dataDimensionItems", "columns", "rows" and "filters".*

The root endpoint of the API is `/api/visualizations`, and the list of current attributes and elements are described in the table below.



Table: Visualization attributes

| Field | Description |
|---|---|
| id | The unique identifier. |
| code | A custom code to identify the Visualization. |
| name | The name of the Visualization |
| type | The type of the Visualization. The valid types are: COLUMN, STACKED_COLUMN, BAR, STACKED_BAR, LINE, AREA, PIE, RADAR, GAUGE, YEAR_OVER_YEAR_LINE YEAR_OVER_YEAR_COLUMN, SINGLE_VALUE, PIVOT_TABLE. |
| title | A custom title. |
| subtitle | A custom subtitle. |
| description | Defines a custom description for the Visualization. |
| created | The date/time of the Visualization creation. |
| startDate | The beginning date used during the filtering. |
| endDate | The ending date used during the filtering. |
| sortOrder | The sorting order of this Visualization. Integer value. |
| user | An object representing the creator of the Visualization. |
| publicAccess | Sets the permissions for public access. |
| displayDensity | The display density of the text. |
| fontSize | The font size of the text. |
| fontStyle | Custom font styles for: visualizationTitle, visualizationSubtitle, horizontalAxisTitle, verticalAxisTitle, targetLineLabel, baseLineLabel, seriesAxisLabel, categoryAxisLabel, legend. |
| relativePeriods | An object representing the relative periods used in the analytics query. |
| legendSet | An object representing the definitions for the legend. |
| legendDisplayStyle | The legend's display style. It can be: FILL or TEXT. |
| legendDisplayStrategy | The legend's display style. It can be: FIXED or BY_DATA_ITEM. |
| aggregationType | Determines how the values in the pivot table are aggregated. Valid options: SUM, AVERAGE, AVERAGE_SUM_ORG_UNIT, LAST, LAST_AVERAGE_ORG_UNIT, FIRST, FIRST_AVERAGE_ORG_UNIT, COUNT, STDDEV, VARIANCE, MIN, MAX, NONE, CUSTOM or DEFAULT. |
| regressionType | A valid regression type: NONE, LINEAR, POLYNOMIAL or LOESS. |
| targetLineValue | The chart target line. Accepts a Double type. |
| targetLineLabel | The chart target line label. |
| rangeAxisLabel | The chart vertical axis (y) label/title. |
| domainAxisLabel | The chart horizontal axis (x) label/title. |
| rangeAxisMaxValue | The chart axis maximum value. Values outside of the range will not be displayed. |
| rangeAxisMinValue | The chart axis minimum value. Values outside of the range will not be displayed. |
| rangeAxisSteps | The number of axis steps between the minimum and maximum values. |
| rangeAxisDecimals | The number of decimals for the axes values. |
| baseLineValue | A chart baseline value. |
| baseLineLabel | A chart baseline label. |
| digitGroupSeparator | The digit group separator. Valid values: COMMA, SPACE or NONE. |
| topLimit | The top limit set for the Pivot table. |
| measureCriteria | Describes the criteria applied to this measure. |
| percentStackedValues | Uses stacked values or not. More likely to be applied for graphics/charts. Boolean value. |
| noSpaceBetweenColumns | Show/hide space between columns. Boolean value. |
| regression | Indicates whether the Visualization contains regression columns. More likely to be applicable to Pivot/Report. Boolean value. |
| externalAccess | Indicates whether the Visualization is available as external read-only. Only applies when no user is logged in. Boolean value. |
| userOrganisationUnit | Indicates if the user has an organisation unit. Boolean value. |
| userOrganisationUnitChildren | Indicates if the user has a children organisation unit. Boolean value. |
| userOrganisationUnitGrandChildren | Indicates if the user has a grand children organisation unit . Boolean value. |
| reportingParams | Object used to define boolean attributes related to reporting. |
| rowTotals | Displays (or not) the row totals. Boolean value. |
| colTotals | Displays (or not) the columns totals. Boolean value. |
| rowSubTotals | Displays (or not) the row sub-totals. Boolean value. |
| colSubTotals | Displays (or not) the columns sub-totals. Boolean value. |
| cumulativeValues | Indicates whether the visualization is using cumulative values. Boolean value. |
| hideEmptyColumns | Indicates whether to hide columns with no data values. Boolean value. |
| hideEmptyRows | Indicates whether to hide rows with no data values. Boolean value. |
| completedOnly | Indicates whether to hide columns with no data values. Boolean value. |
| skipRounding | Apply or not rounding. Boolean value. |
| showDimensionLabels | Shows the dimension labels or not. Boolean value. |
| hideTitle | Hides the title or not. Boolean value. |
| hideSubtitle | Hides the subtitle or not. Boolean value. |
| hideLegend | Show/hide the legend. Very likely to be used by charts. Boolean value. |
| showHierarchy | Displays (or not) the organisation unit hierarchy names. Boolean value. |
| showData | Used by charts to hide or not data/values within the rendered model. Boolean value. |
| lastUpdatedBy | Object that represents the user that applied the last changes to the Visualization. |
| lastUpdated | The date/time of the last time the Visualization was changed. |
| favorites | List of user ids who have marked this object as a favorite. |
| subscribers | List of user ids who have subscribed to this Visualization. |
| translations | Set of available object translation, normally filtered by locale. |
| outlierAnalysis | Object responsible to keep settings related to outlier analysis. The internal attribute 'outlierMethod' supports: IQR, STANDARD_Z_SCORE, MODIFIED_Z_SCORE. The 'normalizationMethod' accepts only Y_RESIDUALS_LINEAR for now. |
| seriesKey | Styling options for and whether or not to display the series key. |
| legend | Options for and whether or not to apply legend colors to the chart series. |

### Retrieving visualizations { #webapi_visualization_retrieving_visualizations } 

To retrieve a list of all existing visualizations, in JSON format, with some basic information (including identifier, name and pagination) you can make a `GET` request to the URL below. You should see a list of all public/shared visualizations plus your private ones.

    GET /api/visualizations.json

If you want to retrieve the JSON definition of a specific Visualization you can add its respective identifier to the URL:

    GET /api/visualizations/hQxZGXqnLS9.json

The following representation is an example of a response in JSON format (for brevity, certain information has been removed). For the complete schema, please use `GET /api/schemas/visualization`.

```json
{
  "lastUpdated": "2020-02-06T11:57:09.678",
  "href": "http://my-domain/dhis/api/visualizations/hQxZGXqnLS9",
  "id": "hQxZGXqnLS9",
  "created": "2017-05-19T17:22:00.785",
  "name": "ANC: ANC 1st visits last 12 months cumulative values",
  "publicAccess": "rw------",
  "userOrganisationUnitChildren": false,
  "type": "LINE",
  "access": {},
  "reportingParams": {
    "parentOrganisationUnit": false,
    "reportingPeriod": false,
    "organisationUnit": false,
    "grandParentOrganisationUnit": false
  },
  "dataElementGroupSetDimensions": [],
  "attributeDimensions": [],
  "yearlySeries": [],
  "axes": [
    {
      "index": 0,
      "type": "RANGE",
      "title": {
        "textMode": "CUSTOM",
        "text": "Any Title"
      }
    }
  ],
  "filterDimensions": [
    "dx"
  ],
  "columns": [
    {
      "id": "ou"
    }
  ],
  "dataElementDimensions": [],
  "categoryDimensions": [],
  "rowDimensions": [
    "pe"
  ],
  "columnDimensions": [
    "ou"
  ],
  "dataDimensionItems": [
    {
      "dataDimensionItemType": "DATA_ELEMENT",
      "dataElement": {
        "id": "fbfJHSPpUQD"
      }
    }
  ],
  "filters": [
    {
      "id": "dx"
    }
  ],
  "rows": [
    {
      "id": "pe"
    }
  ]
}
```
A more tailored response can be obtained by specifying, in the URL, the fields you want to extract. Ie.:

    GET /api/visualizations/hQxZGXqnLS9.json?fields=interpretations

will return

```json
{
  "interpretations": [
    {
      "id": "Lfr8I2RPU0C"
    },
    {
      "id": "JuwgdJlJPGb"
    },
    {
      "id": "WAoU2rSpyZp"
    }
  ]
}
```

As seen, the `GET` above will return only the interpretations related to the given identifier (in this case `hQxZGXqnLS9`).

### Creating, updating and removing visualizations { #webapi_visualization_add_update_remove_visualizations } 

These operations follow the standard *REST* semantics. A new Visualization can be created through a `POST` request to the `/api/visualizations` resource with a valid JSON payload. An example of payload could be:

```json
{
  "columns": [
    {
      "dimension": "J5jldMd8OHv",
      "items": [
        {
          "name": "CHP",
          "id": "uYxK4wmcPqA",
          "displayName": "CHP",
          "displayShortName": "CHP",
          "dimensionItemType": "ORGANISATION_UNIT_GROUP"
        },
        {
          "name": "Hospital",
          "id": "tDZVQ1WtwpA",
          "displayName": "Hospital",
          "displayShortName": "Hospital",
          "dimensionItemType": "ORGANISATION_UNIT_GROUP"
        }
      ]
    }
  ],
  "rows": [
    {
      "dimension": "SooXFOUnciJ",
      "items": [
        {
          "name": "DOD",
          "id": "B0bjKC0szQX",
          "displayName": "DOD",
          "displayShortName": "DOD",
          "dimensionItemType": "CATEGORY_OPTION_GROUP"
        },
        {
          "name": "CDC",
          "id": "OK2Nr4wdfrZ",
          "displayName": "CDC",
          "displayShortName": "CDC",
          "dimensionItemType": "CATEGORY_OPTION_GROUP"
        }
      ]
    }
  ],
  "filters": [
    {
      "dimension": "ou",
      "items": [
        {
          "name": "Sierra Leone",
          "id": "ImspTQPwCqd",
          "displayName": "Sierra Leone",
          "displayShortName": "Sierra Leone",
          "dimensionItemType": "ORGANISATION_UNIT"
        },
        {
          "name": "LEVEL-1",
          "id": "LEVEL-H1KlN4QIauv",
          "displayName": "LEVEL-1"
        }
      ]
    }
  ],
  "name": "HIV Cases Monthly",
  "description": "Cases of HIV across the months",
  "category": "XY1vwCQskjX",
  "showDimensionLabels": true,
  "hideEmptyRows": true,
  "hideEmptyColumns": true,
  "skipRounding": true,
  "aggregationType": "SUM",
  "regressionType": "LINEAR",
  "type": "PIVOT_TABLE",
  "numberType": "VALUE",
  "measureCriteria": "Some criteria",
  "showHierarchy": true,
  "completedOnly": true,
  "displayDensity": "NORMAL",
  "fontSize": "NORMAL",
  "digitGroupSeparator": "SPACE",
  "legendDisplayStyle": "FILL",
  "legendDisplayStrategy": "FIXED",
  "hideEmptyRowItems": "BEFORE_FIRST_AFTER_LAST",
  "regression": false,
  "cumulative": true,
  "sortOrder": 1,
  "topLimit": 2,
  "rowTotals": true,
  "colTotals": true,
  "hideTitle": true,
  "hideSubtitle": true,
  "hideLegend": true,
  "showData": true,
  "percentStackedValues": true,
  "noSpaceBetweenColumns": true,
  "rowSubTotals": true,
  "colSubTotals": true,
  "userOrgUnitType": "TEI_SEARCH",
  "externalAccess": false,
  "publicAccess": "--------",
  "reportingParams": {
    "reportingPeriod": true,
    "organisationUnit": true,
    "parentOrganisationUnit": true,
    "grandParentOrganisationUnit": true
  },
  "parentGraphMap": {
    "ImspTQPwCqd": ""
  },
  "access": {
    "read": true,
    "update": true,
    "externalize": true,
    "delete": false,
    "write": true,
    "manage": false
  },
  "optionalAxes": [
    {
      "dimensionalItem": "fbfJHSPpUQD",
      "axis": 1
    },
    {
      "dimensionalItem": "cYeuwXTCPkU",
      "axis": 2
    }
  ],
  "relativePeriods": {
    "thisYear": false,
    "quartersLastYear": true,
    "last52Weeks": false,
    "thisWeek": false,
    "lastMonth": false,
    "last14Days": false,
    "biMonthsThisYear": false,
    "monthsThisYear": false,
    "last2SixMonths": false,
    "yesterday": false,
    "thisQuarter": false,
    "last12Months": false,
    "last5FinancialYears": false,
    "thisSixMonth": false,
    "lastQuarter": false,
    "thisFinancialYear": false,
    "last4Weeks": false,
    "last3Months": false,
    "thisDay": false,
    "thisMonth": false,
    "last5Years": false,
    "last6BiMonths": false,
    "last4BiWeeks": false,
    "lastFinancialYear": false,
    "lastBiWeek": false,
    "weeksThisYear": false,
    "last6Months": false,
    "last3Days": false,
    "quartersThisYear": false,
    "monthsLastYear": false,
    "lastWeek": false,
    "last7Days": false,
    "thisBimonth": false,
    "lastBimonth": false,
    "lastSixMonth": false,
    "thisBiWeek": false,
    "lastYear": false,
    "last12Weeks": false,
    "last4Quarters": false
  },
  "user": {},
  "yearlySeries": [
    "THIS_YEAR"
  ],
  "userGroupAccesses": [
    {
      "access": "rwx-----",
      "userGroupUid": "ZoHNWQajIoe",
      "displayName": "Bo District M&E officers",
      "id": "ZoHNWQajIoe"
    }
  ],
  "userAccesses": [
    {
      "access": "--------",
      "displayName": "John Barnes",
      "id": "DXyJmlo9rge",
      "userUid": "DXyJmlo9rge"
    }
  ],
  "legendSet": {
    "name": "Death rate up",
    "id": "ham2eIDJ9k6",
    "legends": [
      {
        "startValue": 1,
        "endValue": 2,
        "color": "red",
        "image": "some-image"
      },
      {
        "startValue": 2,
        "endValue": 3,
        "color": "blue",
        "image": "other-image"
      }
    ]
  },
  "outlierAnalysis": {
    "enabled": true,
    "outlierMethod": "IQR",
    "thresholdFactor": 1.5,
    "normalizationMethod": "Y_RESIDUALS_LINEAR",
    "extremeLines": {
      "enabled": true,
      "value": 3.5
    }
  },
  "legend": {
    "strategy": "FIXED",
    "style": "FILL",
    "set": {
      "id": "fqs276KXCXi",
      "displayName": "ANC Coverage"
    },
    "showKey": false
  },
  "seriesKey": {
    "hidden": true,
    "label": {
      "fontStyle": {
        "textColor": "#cccddd"
      }
    }
  },
  "axes": [
    {
      "index": 0,
      "type": "RANGE",
      "label": {
        "fontStyle": {
          "textColor": "#cccddd"
        }
      },
      "title": {
        "text": "Range axis title",
        "textMode": "CUSTOM",
        "fontStyle": {
          "textColor": "#000000"
        }
      },
      "decimals": 1,
      "maxValue": 100,
      "minValue": 20,
      "steps": 5,
      "baseLine": {
        "value": 50,
        "title": {
          "text": "My baseline",
          "fontStyle": {
            "textColor": "#000000"
          }
        }
      },
      "targetLine": {
        "value": 80,
        "title": {
          "text": "My targetline",
          "fontStyle": {
            "textColor": "#cccddd"
          }
        }
      }
    },
    {
      "index": 1,
      "type": "DOMAIN",
      "label": {
        "fontStyle": {
          "textColor": "#000000"
        }
      },
      "title": {
        "text": "Domain axis title",
        "textMode": "CUSTOM",
        "fontStyle": {
          "textColor": "#cccddd"
        }
      }
    }
  ],
  "axes": [
    {
      "index": 0,
      "type": "RANGE",
      "label": {
        "fontStyle": {
          "textColor": "#cccddd"
        }
      },
      "title": {
        "text": "Range axis title",
        "fontStyle": {
          "textColor": "#000000"
        }
      },
      "decimals": 1,
      "maxValue": 100,
      "minValue": 20,
      "steps": 5,
      "baseLine": {
        "value": 50,
        "title": {
          "text": "My baseline",
          "fontStyle": {
            "textColor": "#000000"
          }
        }
      },
      "targetLine": {
        "value": 80,
        "title": {
          "text": "My targetline",
          "fontStyle": {
            "textColor": "#cccddd"
          }
        }
      }
    },
    {
      "index": 1,
      "type": "DOMAIN",
      "label": {
        "fontStyle": {
          "textColor": "#000000"
        }
      },
      "title": {
        "text": "Domain axis title",
        "fontStyle": {
          "textColor": "#cccddd"
        }
      }
    }
  ]
}
```

To update a specific Visualization, you can send a `PUT` request to the same `/api/visualizations` resource with a similar payload `PLUS` the respective Visualization's identifier, ie.:

    PUT /api/visualizations/hQxZGXqnLS9

Finally, to delete an existing Visualization, you can make a `DELETE` request specifying the identifier of the Visualization to be removed, as shown:

    DELETE /api/visualizations/hQxZGXqnLS9

## Interpretations { #webapi_interpretations } 

For resources related to data analysis in DHIS2, such as pivot tables,
charts, maps, event reports and event charts, you can write and share
data interpretations. An interpretation can be a comment, question,
observation or interpretation about a data report or visualization.

    /api/interpretations

### Reading interpretations { #webapi_reading_interpretations } 

To read interpretations we will interact with the
`/api/interpretations` resource. A typical GET request using field
filtering can look like this:

    GET /api/interpretations?fields=*,comments[id,text,user,mentions]

The output in JSON response format could look like below (additional
fields omitted for brevity):

```json
{
  "interpretations": [
    {
      "id": "XSHiFlHAhhh",
      "created": "2013-05-30T10:24:06.181+0000",
      "text": "Data looks suspicious, could be a data entry mistake.",
      "type": "REPORT_TABLE",
      "likes": 2,
      "user": {
        "id": "uk7diLujYif"
      },
      "reportTable": {
        "id": "LcSxnfeBxyi"
      },
      "visualization": {
        "id": "LcSxnfeBxyi"
      }
    }, {
      "id": "kr4AnZmYL43",
      "created": "2013-05-29T14:47:13.081+0000",
      "text": "Delivery rates in Bo looks high.",
      "type": "CHART",
      "likes": 3,
      "user": {
        "id": "uk7diLujYif"
      },
      "chart": {
        "id": "HDEDqV3yv3H"
      },
      "visualization": {
        "id": "HDEDqV3yv3H"
      },
      "mentions": [
        {
          "created": "2018-06-25T10:25:54.498",
          "username": "boateng"
        }
      ],
      "comments": [
        {
          "id": "iB4Etq8yTE6",
          "text": "This report indicates a surge.",
          "user": {
            "id": "B4XIfwOcGyI"
          }
        },
        {
          "id": "iB4Etq8yTE6",
          "text": "Likely caused by heavy rainfall.",
          "user": {
            "id": "B4XIfwOcGyI"
          }
        },
        {
          "id": "SIjkdENan8p",
          "text": "Have a look at this @boateng.",
          "user": {
            "id": "xE7jOejl9FI"
          },
          "mentions": [
            {
              "created": "2018-06-25T10:03:52.316",
              "username": "boateng"
            }
          ]
        }
      ]
    }
  ]
}
```



Table: Interpretation fields

| Field | Description |
|---|---|
| id | The interpretation identifier. |
| created | The time of when the interpretation was created. |
| type | The type of analytical object being interpreted. Valid options: REPORT_TABLE, CHART, MAP, EVENT_REPORT, EVENT_CHART, DATASET_REPORT. |
| user | Association to the user who created the interpretation. |
| reportTable | Association to the report table if type is REPORT_TABLE. |
| chart | Association to the chart if type is CHART. |
| visualization | Association to the visualization if type is CHART or REPORT_TABLE (**both types are in deprecation process in favour of VISUALIZATION**). |
| map | Association to the map if type is MAP. |
| eventReport | Association to the event report is type is EVENT_REPORT. |
| eventChart | Association to the event chart if type is EVENT_CHART. |
| dataSet | Association to the data set if type is DATASET_REPORT. |
| comments | Array of comments for the interpretation. The text field holds the actual comment. |
| mentions | Array of mentions for the interpretation. A list of users identifiers. |

For all analytical objects you can append */data* to the URL to retrieve
the data associated with the resource (as opposed to the metadata). As
an example, by following the map link and appending /data one can
retrieve a PNG (image) representation of the thematic map through the
following URL:

    https://play.dhis2.org/demo/api/maps/bhmHJ4ZCdCd/data

For all analytical objects you can filter by *mentions*. To retrieve all
the interpretations/comments where a user has been mentioned you have
three options. You can filter by the interpretation mentions (mentions
in the interpretation
    description):

    GET /api/interpretations?fields=*,comments[*]&filter=mentions.username:in:[boateng]

You can filter by the interpretation comments mentions (mentions in any
comment):

    GET /api/interpretations?fields=*,comments[*]
      &filter=comments.mentions.username:in:[boateng]

You can filter by intepretations which contains the mentions either
in the interpretation or in any comment (OR junction):

    GET /api/interpretations?fields=*,comments[*]&filter=mentions:in:[boateng]

### Writing interpretations { #webapi_writing_interpretations } 

When writing interpretations you will supply the interpretation text as
the request body using a POST request with content type "text/plain".
The URL pattern looks like the below, where {object-type} refers to the
type of the object being interpreted and {object-id} refers to the
identifier of the object being interpreted.

    /api/interpretations/{object-type}/{object-id}

Valid options for object type are *reportTable*, *chart*, *map*,
*eventReport*, *eventChart* and *dataSetReport*.

Some valid examples for interpretations are listed below.

> **Note**
>
> The `charts` and `reportTables` APIs are deprecated. We recommend using the `visualizations` API instead.

    /api/interpretations/reportTable/yC86zJxU1i1
    /api/interpretations/chart/ZMuYVhtIceD
    /api/interpretations/visualization/hQxZGXqnLS9
    /api/interpretations/map/FwLHSMCejFu
    /api/interpretations/eventReport/xJmPLGP3Cde
    /api/interpretations/eventChart/nEzXB2M9YBz
    /api/interpretations/dataSetReport/tL7eCjmDIgM

As an example, we will start by writing an interpretation for the chart
with identifier *EbRN2VIbPdV*. To write chart interpretations we will
interact with the `/api/interpretations/chart/{chartId}` resource.
The interpretation will be the request body. Based on this we can put
together the following request using cURL:

```bash
curl -d "This chart shows a significant ANC 1-3 dropout" -X POST
  "https://play.dhis2.org/demo/api/interpretations/chart/EbRN2VIbPdV"
  -H "Content-Type:text/plain" -u admin:district
```

Notice that the response provides a Location header with a value
indicating the location of the created interpretation. This is useful
from a client perspective when you would like to add a comment to the
interpretation.

### Updating and removing interpretations { #webapi_updating_removing_interpretations } 

To update an existing interpretation you can use a PUT request where the
interpretation text is the request body using the following URL pattern,
where {id} refers to the interpretation identifier:

    /api/interpretations/{id}

Based on this we can use curl to update the interpretation:

```bash
curl -d "This charts shows a high dropout" -X PUT
  "https://play.dhis2.org/demo/api/interpretations/chart/EV08iI1cJRA"
  -H "Content-Type:text/plain" -u admin:district
```

You can use the same URL pattern as above using a DELETE request to
remove the interpretation.

### Creating interpretation comments { #webapi_creating_interpretation_comments } 

When writing comments to interpretations you will supply the comment
text as the request body using a POST request with content type
"text/plain". The URL pattern looks like the below, where
{interpretation-id} refers to the interpretation identifier.

    /api/interpretations/{interpretation-id}/comments

Second, we will write a comment to the interpretation we wrote in the
example above. By looking at the interpretation response you will see
that a *Location* header is returned. This header tells us the URL of
the newly created interpretation and from that, we can read its
identifier. This identifier is randomly generated so you will have to
replace the one in the command below with your own. To write a comment
we can interact with the `/api/interpretations/{id}/comments`
resource like this:

```bash
curl -d "An intervention is needed" -X POST
  "https://play.dhis2.org/demo/api/interpretations/j8sjHLkK8uY/comments"
  -H "Content-Type:text/plain" -u admin:district
```

### Updating and removing interpretation comments { #webapi_updating_removing_interpretation_comments } 

To updating an interpretation comment you can use a PUT request where
the comment text is the request body using the following URL pattern:

    /api/interpretations/{interpretation-id}/comments/{comment-id}

Based on this we can use curl to update the comment:

```bash
curl "https://play.dhis2.org/demo/api/interpretations/j8sjHLkK8uY/comments/idAzzhVWvh2"
  -d "I agree with that." -X PUT -H "Content-Type:text/plain" -u admin:district
```

You can use the same URL pattern as above using a DELETE request to the
remove the interpretation comment.

### Liking interpretations { #webapi_liking_interpretations } 

To like an interpretation you can use an empty POST request to the
*like* resource:

    POST /api/interpretations/{id}/like

A like will be added for the currently authenticated user. A user can
only like an interpretation once.

To remove a like for an interpretation you can use a DELETE request to
the same resource as for the like operation.

The like status of an interpretation can be viewed by looking at the
regular Web API representation:

    GET /api/interpretations/{id}

The like information is found in the *likes* field, which represents the
number of likes, and the *likedBy* array, which enumerates the users who
have liked the interpretation.

```json
{
  "id": "XSHiFlHAhhh",
  "text": "Data looks suspicious, could be a data entry mistake.",
  "type": "REPORT_TABLE",
  "likes": 2,
  "likedBy": [
    {
      "id": "k7Hg12fJ2f1"
    },
    {
      "id": "gYhf26fFkjFS"
    }
  ]
}
```
## SQL views { #webapi_sql_views } 

The SQL views resource allows you to create and retrieve the result set
of SQL views. The SQL views can be executed directly against the
database and render the result set through the Web API resource.

    /api/sqlViews

SQL views are useful for creating data views which may be more easily
constructed with SQL compared combining the multiple objects of the Web
API. As an example, lets assume we have been asked to provide a view of
all organization units with their names, parent names, organization unit
level and name, and the coordinates listed in the database. The view
might look something like this:

```sql
SELECT ou.name as orgunit, par.name as parent, ou.coordinates, ous.level, oul.name from organisationunit ou
INNER JOIN _orgunitstructure ous ON ou.organisationunitid = ous.organisationunitid
INNER JOIN organisationunit par ON ou.parentid = par.organisationunitid
INNER JOIN orgunitlevel oul ON ous.level = oul.level
WHERE ou.coordinates is not null
ORDER BY oul.level, par.name, ou.name
```

We will use *curl* to first execute the view on the DHIS2 server. This
is essentially a materialization process, and ensures that we have the
most recent data available through the SQL view when it is retrieved
from the server. You can first look up the SQL view from the
api/sqlViews resource, then POST using the following command:

```bash
curl "https://play.dhis2.org/demo/api/sqlViews/dI68mLkP1wN/execute" -X POST -u admin:district
```

The next step in the process is the retrieval of the data.The basic
structure of the URL is as follows

    http://{server}/api/sqlViews/{id}/data(.csv)

The `{server}` parameter should be replaced with your own server. The
next part of the URL `/api/sqlViews/` should be appended with the
specific SQL view identifier. Append either `data` for XML data or
`data.csv` for comma delimited values. Support response formats are
json, xml, csv, xls, html and html+css. As an example, the following
command would retrieve XML data for the SQL view defined above.

```bash
curl "https://play.dhis2.org/demo/api/sqlViews/dI68mLkP1wN/data.csv" -u admin:district
```

There are three types of SQL views:

  - *SQL view:* Standard SQL views.

  - *Materialized SQL view:* SQL views which are materialized, meaning
    written to disk. Needs to be updated to reflect changes in
    underlying tables. Supports criteria to filter result set.

  - *SQL queries:* Plain SQL queries. Support inline variables for
    customized queries.

### Criteria { #webapi_sql_view_criteria } 

You can do simple filtering on the columns in the result set by
appending *criteria* query parameters to the URL, using the column names
and filter values separated by columns as parameter values, on the
following format:

    /api/sqlViews/{id}/data?criteria=col1:value1&criteria=col2:value2

As an example, to filter the SQL view result set above to only return
organisation units at level 4 you can use the following
    URL:

    https://play.dhis2.org/demo/api/sqlViews/dI68mLkP1wN/data.csv?criteria=level:4

### Variables { #webapi_sql_view_variables } 

SQL views support variable substitution. Variable substitution is only
available for SQL view of type *query*, meaning SQL views which are not
created in the database but simply executed as regular SQL queries.
Variables can be inserted directly into the SQL query and must be on
this format:

    ${variable-key}

As an example, an SQL query that retrieves all data elements of a given
value type where the value type is defined through a variable can look
like this:

    select * from dataelement where valuetype = '${valueType}';

These variables can then be supplied as part of the URL when requested
through the *sqlViews* Web API resource. Variables can be supplied on
the following format:

    /api/sqlViews/{id}/data?var=key1:value1&var=key2:value2

An example query corresponding to the example above can look like this:

    /api/sqlViews/dI68mLkP1wN/data.json?var=valueType:int

The *valueType* variable will be substituted with the *int* value, and
the query will return data elements with int value type.

The variable parameter must contain alphanumeric characters only. The
variables must contain alphanumeric, dash, underscore and whitespace
characters only.

SQL Views of type *query* also support two system-defined variables that allow the query to access information about the user executing the view:

| variable | means |
| -------- | ----- |
| ${_current_user_id} | the user's database id |
| ${_current_username} | the user's username |

Values for these variables cannot be supplied as part of the URL. They are always filled with information about the user.

For example, the following SQL view of type *query* shows all the organisation units that are assigned to the user:

```sql
    select ou.path, ou.name
    from organisationunit ou_user
    join organisationunit ou on ou.path like ou_user.path || '%'
    join usermembership um on um.organisationunitid = ou_user.organisationunitid
    where um.userinfoid = ${_current_user_id}
    order by ou.path
```

### Filtering { #webapi_sql_view_filtering } 

The SQL view api supports data filtering, equal to the [metadata object
filter](#webapi_metadata_object_filter). For a complete list of filter
operators you can look at the documentation for [metadata object
filter](#webapi_metadata_object_filter).

To use filters, simply add them as parameters at the end of the request
url for your SQL view like
    this:

    /api/sqlViews/w3UxFykyHFy/data.json?filter=orgunit_level:eq:2&filter=orgunit_name:ilike:bo

This request will return a result including org units with "bo" in the
name and which has org unit level 2.

The following example will return all org units with `orgunit_level` 2 or
4:

    /api/sqlViews/w3UxFykyHFy/data.json?filter=orgunit_level:in:[2,4]

And last, an example to return all org units that does not start with
"Bo"

    /api/sqlViews/w3UxFykyHFy/data.json?filter=orgunit_name:!like:Bo


## Data items { #webapi_data_items } 

This endpoint allows the user to query data related to a few different dimensional items. These items are: `INDICATOR`, `DATA_ELEMENT`, `DATA_SET`, `PROGRAM_INDICATOR`, `PROGRAM_DATA_ELEMENT`, `PROGRAM_ATTRIBUTE`. The endpoint supports only `GET` requests and, as other endpoints, can return responses in JSON or XML format.

The URL is `/api/dataItems` and as you can imagine, it is able to retrieve different objects through the same endpoint in the same `GET` request. For this reason, some queriable attributes available will differ depending on the dimensional item(s) being queried.

To understand the statement above let's have a look at the followings request examples:

1) `GET /api/dataItems?filter=dimensionItemType:eq:DATA_ELEMENT&filter=valueType:eq:TEXT`
In this example the item type `DATA_ELEMENT` has a `valueType` attribute which can be used in the query.

2) `GET /api/dataItems?pageSize=50&order=displayName:asc&filter=dimensionItemType:eq:PROGRAM_INDICATOR&filter=displayName:ilike:someName&filter=programId:eq:WSGAb5XwJ3Y`

Here, the `PROGRAM_INDICATOR` allows filtering by `programId`.

So, based on the examples `1)` and `2)` if you try filtering a `DATA_ELEMENT` by `programId` or filter a `PROGRAM_INDICATOR` by `valueType`, you should get no results.
In other words, the filter will be applied only when the attribute actually exists for the respective data item.

Another important aspect to be highlighted is that this endpoint does NOT follow the same querying standards as other existing endpoints, like [Metadata object filter](#webapi_metadata_object_filter) for example. As a consequence, it supports a smaller set of features and querying.
The main reason for that is the need for querying multiple different items that have different relationships, which is not possible using the existing filtering components (used by the others endpoints).

### Possible endpoint responses { #webapi_data_items_possible_responses } 

Base on the `GET` request/query, a few different responses are possible. Below we are summarizing each possibility.

#### Results found (HTTP status code 200)

```
{
  "pager": {
    "page": 1,
    "pageCount": 27,
    "total": 1339,
    "pageSize": 50,
    "nextPage": "https://play.dhis2.org/dev/api/36/dataItems?page=2&filter=displayName:ilike:a&filter=id:eq:nomatch&rootJunction=OR&displayName:asc=&paging=true"
  },
  "dataItems": [
    {
      "simplifiedValueType": "TEXT",
      "displayName": "TB program Gender",
      "displayShortName": "TB prog. Gen.",
      "valueType": "TEXT",
      "name": "TB program Gender",
      "shortName": ""TB prog. Gen.",
      "id": "ur1Edk5Oe2n.cejWyOfXge6",
      "programId": "ur1Edk5Oe2n",
      "dimensionItemType": "PROGRAM_ATTRIBUTE"
    },
    ...
  ]
}
```

#### Results not found (HTTP status code 200)

```
{
  "pager": {
    "page": 1,
    "pageCount": 1,
    "total": 0,
    "pageSize": 50
  },
  "dataItems": []
}
```

#### Invalid query (HTTP status code 409)

```
{
  "httpStatus": "Conflict",
  "httpStatusCode": 409,
  "status": "ERROR",
  "message": "Unable to parse element `INVALID_TYPE` on filter `dimensionItemType`. The values available are: [INDICATOR, DATA_ELEMENT, DATA_ELEMENT_OPERAND, DATA_SET, PROGRAM_INDICATOR, PROGRAM_DATA_ELEMENT, PROGRAM_ATTRIBUTE]",
  "errorCode": "E2016"
}
```

#### Unhandled error (HTTP status code 500)

```
{
  "httpStatus": "Internal Server Error",
  "httpStatusCode": 500,
  "status": "ERROR"
}
```

### Pagination { #webapi_data_items_pagination } 

This endpoint also supports pagination as a default option. If needed, you can disable pagination by adding `paging=false` to the `GET` request.
ie.: `/api/dataItems?filter=dimensionItemType:in:[INDICATOR]&paging=false`.

Here is an example of a payload when the pagination is enabled. Remember that pagination is the default option and does not need to be explicitly set.

```
{
  "pager": {
    "page": 1,
    "pageCount": 20,
    "total": 969,
    "pageSize": 50,
    "nextPage": "https://play.dhis2.org/dev/api/dataItems?page=2&filter=dimensionItemType:in:[INDICATOR]"
  },
  "dataItems": [...]
}
```

> **Note**
>
> For elements where there is an associated Program, the program name should also be returned as part of the element name (as a prefix). The only exception is `Program Indicators`. We will not prefix the element name in this case, in order to keep the same behavior as existing endpoints.
>
> The /dataItems endpoint will bring only data items that are defined as aggregatable type. The current list of valid aggregatable types is:
`TEXT, LONG_TEXT`, `LETTER`, `BOOLEAN`, `TRUE_ONLY`, `NUMBER`, `UNIT_INTERVAL`, `PERCENTAGE`, `INTEGER`, `INTEGER_POSITIVE`, `INTEGER_NEGATIVE`, `INTEGER_ZERO_OR_POSITIVE`, `COORDINATE`.
>
> Even though the response returns several different attributes, the filtering can only be applied to specific ones: `displayName`, `name`, `valueType`, `id`, `dimensionItemType`, `programId`.
>
> The `order` will be considered invalid if it is set on top of `name` (ie.: order=*name:asc*) and a `filter` is set to `displayName` (ie.: filter=*displayName:ilike:aName*), and vice-versa.

### Response attributes { #webapi_data_items_response_attributes } 

Now that we have a good idea of the main features and usage of this endpoint let's have a look in the list of attributes returned in the response.



Table: Data items attributes

| Field | Description |
|---|---|
| id | The unique identifier. |
| code | A custom code to identify the dimensional item. |
| name | The name given for the item. |
| displayName | The display name defined. |
| shortName | The short name given for the item. |
| displayShortName | The display short name defined. |
| dimensionItemType | The dimension type. Possible types: INDICATOR, DATA_ELEMENT, REPORTING_RATE, PROGRAM_INDICATOR, PROGRAM_DATA_ELEMENT, PROGRAM_ATTRIBUTE. |
| valueType | The item value type (more specific definition). Possitble types: TEXT, LONG_TEXT, LETTER, BOOLEAN, TRUE_ONLY, UNIT_INTERVAL, PERCENTAGE, INTEGER, INTEGER_POSITIVE, INTEGER_NEGATIVE, INTEGER_ZERO_OR_POSITIVE, COORDINATE |
| simplifiedValueType | The genereal representation of a value type. Valid values: NUMBER, BOOLEAN, DATE, FILE_RESOURCE, COORDINATE, TEXT |
| programId | The associated programId. |

## Viewing analytical resource representations { #webapi_viewing_analytical_resource_representations } 

DHIS2 has several resources for data analysis. These resources include
*charts*, *maps*, *reportTables*, *reports* and *documents*. By visiting
these resources you will retrieve information about the resource. For
instance, by navigating to `/api/charts/R0DVGvXDUNP` the response will
contain the name, last date of modification and so on for the chart. To
retrieve the analytical representation, for instance, a PNG
representation of the chart, you can append */data* to all these
resources. For instance, by visiting `/api/charts/R0DVGvXDUNP/data` the
system will return a PNG image of the chart.



Table: Analytical resources

| Resource | Description | Data URL | Resource representations |
|---|---|---|---|
| charts | Charts | /api/charts/<identifier\>/data | png |
| eventCharts | Event charts | /api/eventCharts/<identifier\>/data | png |
| maps | Maps | /api/maps/<identifier\>/data | png |
| reportTables | Pivot tables | /api/reportTables/<identifier\>/data | json &#124; jsonp &#124; html &#124; xml &#124; pdf &#124; xls &#124; csv |
| reports | Standard reports | /api/reports/<identifier\>/data | pdf &#124; xls &#124; html |
| documents | Resources | /api/documents/<identifier\>/data | <follows document\> |

The data content of the analytical representations can be modified by
providing a *date* query parameter. This requires that the analytical
resource is set up for relative periods for the period dimension.



Table: Data query parameters

| Query parameter | Value | Description |
|---|---|---|
| date | Date in yyyy-MM-dd format | Basis for relative periods in report (requires relative periods) |



Table: Query parameters for png / image types (charts, maps)

| Query parameter | Description |
|---|---|
| width | Width of image in pixels |
| height | Height of image in pixels |

Some examples of valid URLs for retrieving various analytical
representations are listed below.

    /api/charts/R0DVGvXDUNP/data
    /api/charts/R0DVGvXDUNP/data?date=2013-06-01

    /api/reportTables/jIISuEWxmoI/data.html
    /api/reportTables/jIISuEWxmoI/data.html?date=2013-01-01
    /api/reportTables/FPmvWs7bn2P/data.xls
    /api/reportTables/FPmvWs7bn2P/data.pdf

    /api/maps/DHE98Gsynpr/data
    /api/maps/DHE98Gsynpr/data?date=2013-07-01

    /api/reports/OeJsA6K1Otx/data.pdf
    /api/reports/OeJsA6K1Otx/data.pdf?date=2014-01-01

## Plugins { #webapi_plugins } 

DHIS2 comes with plugins which enable you to embed live data directly in
your web portal or web site. Currently, plugins exist for charts, maps
and pivot tables.

Please be aware that all of the code examples in this section are for
demonstration purposes only. They should not be used as is in
production systems. To make things simple, the credentials
(admin/district) have been embedded into the scripts. In a real scenario,
you should never expose credentials in javascript as it opens a
vulnerability to the application. In addition, you would create a user
with more minimal privileges rather than make use of a superuser to
fetch resources for your portal.

It is possible to workaround exposing the credentials by using a reverse
proxy such as nginx or apache2. The proxy can be configured to inject
the required Authorization header for only the endpoints that you wish
to make public. There is some documentation to get you started in the
section of the implementers manual which describes [reverse
proxy](https://docs.dhis2.org/master/en/implementer/html/install_reverse_proxy_configuration.html#install_making_resources_available_with_nginx)
configuration.

### Embedding pivot tables with the Pivot Table plug-in { #webapi_pivot_table_plugin } 

In this example, we will see how we can embed good-looking, light-weight
html pivot tables with data served from a DHIS2 back-end into a Web
page. To accomplish this we will use the Pivot table plug-in. The
plug-in is written in Javascript and depends on the jQuery library only.
A complete working example can be found at
<http://play.dhis2.org/portal/table.html>. Open the page in a web
browser and view the source to see how it is set up.

We start by having a look at what the complete html file could look
like. This setup puts two tables in our web page. The first one is
referring to an existing table. The second is configured inline.

```html
<!DOCTYPE html>
<html>
<head>
  <script src="https://dhis2-cdn.org/v227/plugin/jquery-2.2.4.min.js"></script>
  <script src="https://dhis2-cdn.org/v227/plugin/reporttable.js"></script>

  <script>
    reportTablePlugin.url = "https://play.dhis2.org/demo";
    reportTablePlugin.username = "admin";
    reportTablePlugin.password = "district";
    reportTablePlugin.loadingIndicator = true;

    // Referring to an existing table through the id parameter, render to "report1" div

    var r1 = { el: "report1", id: "R0DVGvXDUNP" };

    // Table configuration, render to "report2" div

    var r2 = {
      el: "report2",
      columns: [
        {dimension: "dx", items: [{id: "YtbsuPPo010"}, {id: "l6byfWFUGaP"}]}
      ],
      rows: [
        {dimension: "pe", items: [{id: "LAST_12_MONTHS"}]}
      ],
      filters: [
        {dimension: "ou", items: [{id: "USER_ORGUNIT"}]}
      ],

      // All following properties are optional
      title: "My custom title",
      showColTotals: false,
      showRowTotals: false,
      showColSubTotals: false,
      showRowSubTotals: false,
      showDimensionLabels: false,
      hideEmptyRows: true,
      skipRounding: true,
      aggregationType: "AVERAGE",
      showHierarchy: true,
      completedOnly: true,
      displayDensity: "COMFORTABLE",
      fontSize: "SMALL",
      digitGroupSeparator: "COMMA",
      legendSet: {id: "fqs276KXCXi"}
    };

    reportTablePlugin.load([r1, r2]);
  </script>
</head>

<body>
  <div id="report1"></div>
  <div id="report2"></div>
</body>
</html>
```

Two files are included in the header section of the HTML document. The
first file is the jQuery JavaScript library (we use the DHIS2 content
delivery network in this case). The second file is the Pivot table
plug-in. Make sure the path is pointing to your DHIS2 server
installation.

Now let us have a look at the various options for the Pivot tables. One
property is required: *el* (please refer to the table below). Now, if
you want to refer to pre-defined tables already made inside DHIS2 it is
sufficient to provide the additional *id* parameter. If you instead want
to configure a pivot table dynamically you should omit the id parameter
and provide data dimensions inside a *columns* array, a *rows* array and
optionally a *filters* array instead.

A data dimension is defined as an object with a text property called
*dimension*. This property accepts the following values: *dx*
(indicator, data element, data element operand, data set, event data
item and program indicator), *pe* (period), *ou* (organisation unit) or
the id of any organisation unit group set or data element group set (can
be found in the web api). The data dimension also has an array property
called *items* which accepts objects with an *id* property.

To sum up, if you want to have e.g. "ANC 1 Coverage", "ANC 2 Coverage"
and "ANC 3 Coverage" on the columns in your table you can make the
following *columns* config:

```json
columns: [{
  dimension: "dx",
  items: [
    {id: "Uvn6LCg7dVU"}, // the id of ANC 1 Coverage
    {id: "OdiHJayrsKo"}, // the id of ANC 2 Coverage
    {id: "sB79w2hiLp8"}  // the id of ANC 3 Coverage
  ]
}]
```



Table: Pivot table plug-in configuration

| Param | Type | Required | Options (default first) | Description |
|---|---|---|---|---|
| url | string | Yes || Base URL of the DHIS2 server |
| username | string | Yes (if cross-domain) || Used for authentication if the server is running on a different domain |
| password | string | Yes (if cross-domain) || Used for authentication if the server is running on a different domain |
| loadingIndicator | boolean | No || Whether to show a loading indicator before the table appears |



Table: Pivot table configuration

| Param | Type | Required | Options (default first) | Description |
|---|---|---|---|---|
| el | string | Yes || Identifier of the HTML element to render the table in your web page |
| id | string | No || Identifier of a pre-defined table (favorite) in DHIS2 |
| columns | array | Yes (if no id provided) || Data dimensions to include in table as columns |
| rows | array | Yes (if no id provided) || Data dimensions to include in table as rows |
| filter | array | No || Data dimensions to include in table as filters |
| title | string | No || Show a custom title above the table |
| showColTotals | boolean | No | true &#124; false | Whether to display totals for columns |
| showRowTotals | boolean | No | true &#124; false | Whether to display totals for rows |
| showColSubTotals | boolean | No | true &#124; false | Whether to display sub-totals for columns |
| showRowSubTotals | boolean | No | true &#124; false | Whether to display sub-totals for rows |
| showDimensionLabels | boolean | No | true &#124; false | Whether to display the name of the dimension top-left in the table |
| hideEmptyRows | boolean | No | false &#124; true | Whether to hide rows with no data |
| skipRounding | boolean | No | false &#124; true | Whether to skip rounding of data values |
| completedOnly | boolean | No | false &#124; true | Whether to only show completed events |
| showHierarchy | boolean | No | false &#124; true | Whether to extend orgunit names with the name of all anchestors |
| aggregationType | string | No | "SUM" &#124;"AVERAGE" &#124; "AVERAGE_SUM_ORG_UNIT"&#124;"LAST"&#124;"LAST_AVERAGE_ORG_UNIT"&#124; "COUNT" &#124; "STDDEV" &#124; "VARIANCE" &#124; "MIN" &#124; "MAX" | Override the data element's default aggregation type |
| displayDensity | string | No | "NORMAL" &#124; "COMFORTABLE" &#124; "COMPACT" | The amount of space inside table cells |
| fontSize | string | No | "NORMAL" &#124; "LARGE" &#124; "SMALL" | Table font size |
| digitGroupSeparator | string | No | "SPACE" &#124; "COMMA" &#124; "NONE" | How values are formatted: 1 000 &#124; 1,000 &#124; 1000 |
| legendSet | object | No || Color the values in the table according to the legend set |
| userOrgUnit | string / array | No || Organisation unit identifiers, overrides organisation units associated with curretn user, single or array |
| relativePeriodDate | string | No || Date identifier e.g: "2016-01-01". Overrides the start date of the relative period |

### Embedding charts with the Visualizer chart plug-in { #webapi_chart_plugin } 

In this example, we will see how we can embed good-looking Highcharts
charts (<http://www.highcharts.com>) with data served from a DHIS2
back-end into a Web page. To accomplish this we will use the DHIS2
Visualizer plug-in. The plug-in is written in JavaScript and depends on
the jQuery library. A complete working example can be found at
<http://play.dhis2.org/portal/chart.html>. Open the page in a web
browser and view the source to see how it is set up.

We start by having a look at what the complete html file could look
like. This setup puts two charts on our web page. The first one is
referring to an existing chart. The second is configured inline.

```html
<!DOCTYPE html>
<html>
<head>
  <script src="https://dhis2-cdn.org/v227/plugin/jquery-2.2.4.min.js"></script>
  <script src="https://dhis2-cdn.org/v227/plugin/chart.js"></script>

  <script>
    chartPlugin.url = "https://play.dhis2.org/demo";
    chartPlugin.username = "admin";
    chartPlugin.password = "district";
    chartPlugin.loadingIndicator = true;

    // Referring to an existing chart through the id parameter, render to "report1" div

    var r1 = { el: "report1", id: "R0DVGvXDUNP" };

    // Chart configuration, render to "report2" div

    var r2 = {
      el: "report2",
      columns: [
        {dimension: "dx", items: [{id: "YtbsuPPo010"}, {id: "l6byfWFUGaP"}]}
      ],
      rows: [
        {dimension: "pe", items: [{id: "LAST_12_MONTHS"}]}
      ],
      filters: [
        {dimension: "ou", items: [{id: "USER_ORGUNIT"}]}
      ],

      // All following properties are optional
      title: "Custom title",
      type: "line",
      showValues: false,
      hideEmptyRows: true,
      regressionType: "LINEAR",
      completedOnly: true,
      targetLineValue: 100,
      targetLineTitle: "My target line title",
      baseLineValue: 20,
      baseLineTitle: "My base line title",
      aggregationType: "AVERAGE",
      rangeAxisMaxValue: 100,
      rangeAxisMinValue: 20,
      rangeAxisSteps: 5,
      rangeAxisDecimals: 2,
      rangeAxisTitle: "My range axis title",
      domainAxisTitle: "My domain axis title",
      hideLegend: true
    };

    // Render the charts

    chartPlugin.load(r1, r2);
  </script>
</head>

<body>
  <div id="report1"></div>
  <div id="report2"></div>
</body>
</html>
```

Two files are included in the header section of the HTML document. The
first file is the jQuery JavaScript library (we use the DHIS2 content
delivery network in this case). The second file is the Visualizer chart
plug-in. Make sure the path is pointing to your DHIS2 server
installation.

Now let us have a look at the various options for the charts. One
property is required: *el* (please refer to the table below). Now, if
you want to refer to pre-defined charts already made inside DHIS2 it is
sufficient to provide the additional *id* parameter. If you instead want
to configure a chart dynamically you should omit the id parameter and
provide data dimensions inside a *columns* array, a *rows* array and
optionally a *filters* array instead.

A data dimension is defined as an object with a text property called
*dimension*. This property accepts the following values: *dx*
(indicator, data element, data element operand, data set, event data
item and program indicator), *pe* (period), *ou* (organisation unit) or
the id of any organisation unit group set or data element group set (can
be found in the web api). The data dimension also has an array property
called *items* which accepts objects with an *id* property.

To sum up, if you want to have e.g. "ANC 1 Coverage", "ANC 2 Coverage"
and "ANC 3 Coverage" on the columns in your chart you can make the
following *columns* config:

```json
columns: [{
  dimension: "dx",
  items: [
    {id: "Uvn6LCg7dVU"}, // the id of ANC 1 Coverage
    {id: "OdiHJayrsKo"}, // the id of ANC 2 Coverage
    {id: "sB79w2hiLp8"}  // the id of ANC 3 Coverage
  ]
}]
```



Table: Chart plug-in configuration

| Param | Type | Required | Options (default first) | Description |
|---|---|---|---|---|
| url | string | Yes || Base URL of the DHIS2 server |
| username | string | Yes (if cross-domain) || Used for authentication if the server is running on a different domain |
| password | string | Yes (if cross-domain) || Used for authentication if the server is running on a different domain |
| loadingIndicator | boolean | No || Whether to show a loading indicator before the chart appears |



Table: Chart configuration

| Param | Type | Required | Options (default first) | Description |
|---|---|---|---|---|
| el | string | Yes || Identifier of the HTML element to render the chart in your web page |
| id | string | No || Identifier of a pre-defined chart (favorite) in DHIS |
| type | string | No | column &#124; stackedcolumn &#124; bar &#124; stackedbar &#124; line &#124; area &#124; pie &#124; radar &#124; gauge | Chart type |
| columns | array | Yes (if no id provided) || Data dimensions to include in chart as series |
| rows | array | Yes (if no id provided) || Data dimensions to include in chart as category |
| filter | array | No || Data dimensions to include in chart as filters |
| title | string | No || Show a custom title above the chart |
| showValues | boolean | No | false &#124; true | Whether to display data values on the chart |
| hideEmptyRows | boolean | No | false &#124; true | Whether to hide empty categories |
| completedOnly | boolean | No | false &#124; true | Whether to only show completed events |
| regressionType | string | No | "NONE" &#124; "LINEAR" | Show trend lines |
| targetLineValue | number | No || Display a target line with this value |
| targetLineTitle | string | No || Display a title on the target line (does not apply without a target line value) |
| baseLineValue | number | No || Display a base line with this value |
| baseLineTitle | string | No || Display a title on the base line (does not apply without a base line value) |
| rangeAxisTitle | number | No || Title to be displayed along the range axis |
| rangeAxisMaxValue | number | No || Max value for the range axis to display |
| rangeAxisMinValue | number | No || Min value for the range axis to display |
| rangeAxisSteps | number | No || Number of steps for the range axis to display |
| rangeAxisDecimals | number | No || Bumber of decimals for the range axis to display |
| domainAxisTitle | number | No || Title to be displayed along the domain axis |
| aggregationType | string | No | "SUM" &#124;"AVERAGE" &#124; "AVERAGE_SUM_ORG_UNIT"&#124;"LAST"&#124;"LAST_AVERAGE_ORG_UNIT"&#124; "COUNT" &#124; "STDDEV" &#124; "VARIANCE" &#124; "MIN" &#124; "MAX" | Override the data element's default aggregation type |
| hideLegend | boolean | No | false &#124; true | Whether to hide the series legend |
| hideTitle | boolean | No | false &#124; true | Whether to hide the chart title |
| userOrgUnit | string / array | No || Organisation unit identifiers, overrides organisation units associated with curretn user, single or array |
| relativePeriodDate | string | No || Date identifier e.g: "2016-01-01". Overrides the start date of the relative period |

### Embedding maps with the GIS map plug-in { #webapi_map_plugin } 

In this example we will see how we can embed maps with data served from
a DHIS2 back-end into a Web page. To accomplish this we will use the GIS
map plug-in. The plug-in is written in JavaScript and depends on the Ext
JS library only. A complete working example can be found at
<http://play.dhis2.org/portal/map.html>. Open the page in a web browser
and view the source to see how it is set up.

We start by having a look at what the complete html file could look
like. This setup puts two maps on our web page. The first one is
referring to an existing map. The second is configured inline.

```html
<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" type="text/css" href="http://dhis2-cdn.org/v215/ext/resources/css/ext-plugin-gray.css" />
  <script src="http://dhis2-cdn.org/v215/ext/ext-all.js"></script>
  <script src="https://maps.google.com/maps/api/js?sensor=false"></script>
  <script src="http://dhis2-cdn.org/v215/openlayers/OpenLayers.js"></script>
  <script src="http://dhis2-cdn.org/v215/plugin/map.js"></script>

  <script>
    var base = "https://play.dhis2.org/demo";

    // Login - if OK, call the setLinks function

    Ext.onReady( function() {
      Ext.Ajax.request({
        url: base + "dhis-web-commons-security/login.action",
        method: "POST",
        params: { j_username: "portal", j_password: "Portal123" },
        success: setLinks
      });
    });

    function setLinks() {
      DHIS.getMap({ url: base, el: "map1", id: "ytkZY3ChM6J" });

      DHIS.getMap({
        url: base,
        el: "map2",
        mapViews: [{
          columns: [{dimension: "in", items: [{id: "Uvn6LCg7dVU"}]}], // data
          rows: [{dimension: "ou", items: [{id: "LEVEL-3"}, {id: "ImspTQPwCqd"}]}], // organisation units,
          filters: [{dimension: "pe", items: [{id: "LAST_3_MONTHS"}]}], // period
          // All following options are optional
          classes: 7,
          colorLow: "02079c",
          colorHigh: "e5ecff",
          opacity: 0.9,
          legendSet: {id: "fqs276KXCXi"}
        }]
      });
    }
  </script>
</head>

<body>
  <div id="map1"></div>
  <div id="map2"></div>
</body>
</html>
```

Four files and Google Maps are included in the header section of the
HTML document. The first two files are the Ext JS JavaScript library (we
use the DHIS2 content delivery network in this case) and its stylesheet.
The third file is the OpenLayers JavaScript mapping framework
(<http://openlayers.org>) and finally we include the GIS map plug-in.
Make sure the path is pointing to your DHIS2 server
    installation.

    <link rel="stylesheet" type="text/css" href="http://dhis2-cdn.org/v215/ext/resources/css/ext-plugin-gray.css" />
    <script src="http://dhis2-cdn.org/v215/ext/ext-all.js"></script>
    <script src="https://maps.google.com/maps/api/js?sensor=false"></script>
    <script src="http://dhis2-cdn.org/v215/openlayers/OpenLayers.js"></script>
    <script src="http://dhis2-cdn.org/v215/plugin/map.js"></script>

To authenticate with the DHIS2 server we use the same approach as in the
previous section. In the header of the HTML document we include the
following Javascript inside a script element. The *setLinks* method will
be implemented later. Make sure the *base* variable is pointing to your
DHIS2 installation.

    Ext.onReady( function() {
      Ext.Ajax.request({
        url: base + "dhis-web-commons-security/login.action",
        method: "POST",
        params: { j_username: "portal", j_password: "Portal123" },
        success: setLinks
      });
    });

Now let us have a look at the various options for the GIS plug-in. Two
properties are required: *el* and *url* (please refer to the table
below). Now, if you want to refer to pre-defined maps already made in
the DHIS2 GIS it is sufficient to provide the additional *id* parameter.
If you instead want to configure a map dynamically you should omit the id
parameter and provide *mapViews* (layers) instead. They should be
configured with data dimensions inside a *columns* array, a *rows* array
and optionally a *filters* array instead.

A data dimension is defined as an object with a text property called
*dimension*. This property accepts the following values: *in*
(indicator), *de* (data element), *ds* (data set), *dc* (data element
operand), *pe* (period), *ou* (organisation unit) or the id of any
organisation unit group set or data element group set (can be found in
the web api). The data dimension also has an array property called
*items* which accepts objects with an *id* property.

To sum up, if you want to have a layer with e.g. "ANC 1 Coverage" in
your map you can make the following *columns* config:

```json
columns: [{
  dimension: "in", // could be "in", "de", "ds", "dc", "pe", "ou" or any dimension id
  items: [{id: "Uvn6LCg7dVU"}], // the id of ANC 1 Coverage
}]
```



Table: GIS map plug-in configuration

| Param | Type | Required | Options (default first) | Description |
|---|---|---|---|---|
| el | string | Yes || Identifier of the HTML element to render the map in your web page |
| url | string | Yes || Base URL of the DHIS2 server |
| id | string | No || Identifier of a pre-defined map (favorite) in DHIS |
| baseLayer | string/boolean | No | 'gs', 'googlestreets' &#124; 'gh', 'googlehybrid' &#124; 'osm', 'openstreetmap' &#124; false, null, 'none', 'off' | Show background map |
| hideLegend | boolean | No | false &#124; true | Hide legend panel |
| mapViews | array | Yes (if no id provided) || Array of layers |

If no id is provided you must add map view objects with the following
config options:



Table: Map plug-in configuration

||||||
|---|---|---|---|---|
| layer | string | No | "thematic1" &#124; "thematic2" &#124; "thematic3" &#124; "thematic4" &#124; "boundary" &#124; "facility" &#124; | The layer to which the map view content should be added |
| columns | array | Yes || Indicator, data element, data operand or data set (only one will be used) |
| rows | array | Yes || Organisation units (multiple allowed) |
| filter | array | Yes || Period (only one will be used) |
| classes | integer | No | 5 &#124; 1-7 | The number of automatic legend classes |
| method | integer | No | 2 &#124; 3 | Legend calculation method where 2 = equal intervals and 3 = equal counts |
| colorLow | string | No | "ff0000" (red) &#124; Any hex color | The color representing the first automatic legend class |
| colorHigh | string | No | "00ff00" (green) &#124; Any hex color | The color representing the last automatic legend class |
| radiusLow | integer | No | 5 &#124; Any integer | Only applies for facilities (points) - radius of the point with lowest value |
| radiusHigh | integer | No | 15 &#124; Any integer | Only applies for facilities (points) - radius of the point with highest value |
| opacity | double | No | 0.8 &#124; 0 - 1 | Opacity/transparency of the layer content |
| legendSet | object | No || Pre-defined legend set. Will override the automatic legend set. |
| labels | boolean/object | No | false &#124; true &#124; object properties: fontSize (integer), color (hex string), strong (boolean), italic (boolean) | Show labels on the map |
| width | integer | No || Width of map |
| height | integer | No || Height of map |
| userOrgUnit | string / array | No || Organisation unit identifiers, overrides organisation units associated with current user, single or array |

We continue by adding one pre-defined and one dynamically configured map
to our HTML document. You can browse the list of available maps using
the Web API here: <http://play.dhis2.org/demo/api/33/maps>.

```javascript
function setLinks() {
  DHIS.getMap({ url: base, el: "map1", id: "ytkZY3ChM6J" });

  DHIS.getMap({
 url: base,
 el: "map2",
 mapViews: [
   columns: [ // Chart series
  columns: [{dimension: "in", items: [{id: "Uvn6LCg7dVU"}]}], // data
   ],
   rows: [ // Chart categories
  rows: [{dimension: "ou", items: [{id: "LEVEL-3"}, {id: "ImspTQPwCqd"}]}], // organisation units
   ],
   filters: [
  filters: [{dimension: "pe", items: [{id: "LAST_3_MONTHS"}]}], // period
   ],
   // All following options are optional
   classes: 7,
   colorLow: "02079c",
   colorHigh: "e5ecff",
   opacity: 0.9,
   legendSet: {id: "fqs276KXCXi"}
 ]
  });
}
```

Finally we include some *div* elements in the body section of the HTML
document with the identifiers referred to in the plug-in JavaScript.

```html
<div id="map1"></div>
<div id="map2"></div>
```

To see a complete working example please visit
<http://play.dhis2.org/portal/map.html>.
