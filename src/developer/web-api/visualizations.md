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
  "layout": {
    "spacing": {
      "column": 5,
      "row": 5
    },
    "columns": [{
      "index": 0,
      "span": 2
    }, {
      "index": 1,
      "span": 1
    }]
  },
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
*/dashboards/q* or */dashboards/search* resources. 
These resources let you search for matches on
the name property of the following objects: visualizations, eventVisualizations maps,
users, reports and resources. You can do a search by making a *GET*
request on the following resource URL pattern, where my-query should be
replaced by the preferred search query:

    /api/dashboards/q/my-query.json
    /api/dashboards/search?q=my-query

For example, this query:

    /api/dashboards/q/ma?count=6&maxCount=20&max=REPORT&max=MAP
    /api/dashboards/search?q=ma?count=6&maxCount=20&max=REPORT&max=MAP

Will search for the following:

* Analytical object name contains the string "ma"
* Return up to 6 of each type
* For REPORT and MAP types, return up to 20 items



Table: dashboards/q and dashboards/search query parameters

| Query parameter | Description | Type | Default |
|---|---|---|---|
| count | The number of items of each type to return | Positive integer | 6 |
| maxCount | The number of items of max types to return | Positive integer | 25 |
| max | The type to return the maxCount for | String [MAP&#124;USER&#124;REPORT&#124;RESOURCE&#124;VISUALIZATION#124;EVENT_VISUALIZATION,EVENT_CHART,EVENT_REPORT] | N/A |

JSON and XML response formats are supported. The response in JSON format
will contain references to matching resources and counts of how many
matches were found in total and for each type of resource. It will look
similar to this:

```json
{
  "visualizations": [{
    "name": "ANC: ANC 3 Visits Cumulative Numbers",
    "id": "arf9OiyV7df",
    "type": "LINE"
  }, {
    "name": "ANC: 1st and 2rd trends Monthly",
    "id": "jkf6OiyV7el",
    "type": "PIVOT_TABLE"
  }],
  "eventVisualizations": [{
    "name": "Inpatient: Cases 5 to 15 years this year (case)",
    "id": "TIuOzZ0ID0V",
    "type": "LINE_LIST"
  }, {
    "name": "Inpatient: Cases last quarter (case)",
    "id": "R4wAb2yMLik",
    "type": "LINE_LIST"
  }],
  "maps": [{
    "name": "ANC: 1st visit at facility (fixed) 2013",
    "id": "YOEGBvxjAY0"
  }, {
    "name": "ANC: 3rd visit coverage 2014 by district",
    "id": "ytkZY3ChM6J"
  }],
  "reports": [{
    "name": "ANC: 1st Visit Cumulative Chart",
    "id": "Kvg1AhYHM8Q"
  }, {
    "name": "ANC: Coverages This Year",
    "id": "qYVNH1wkZR0"
  }],
  "searchCount": 8,
  "visualizationCount": 2,
  "eventVisualizationCount": 2,
  "mapCount": 2,
  "reportCount": 2,
  "userCount": 0,
  "eventReports": 0,
  "eventCharts" :0,
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

As *DashboardItem* is an **embedded** object of *Dashboard*, all operations must be performed through the `/api/dashboards/{uid}` endpoint.  

#### Add a Visualization
To add a visualization to a specific dashboard, send a **PUT** request to:  

```
 /api/dashboards/ChZ236jPgXs
```

The request payload must include the full *Dashboard* object, including all existing and new *DashboardItems*.  

```json
{
    "name": "test",
    "layout": {
        "columns": []
    },
    "itemConfig": {
        "insertPosition": "END"
    },
    "restrictFilters": false,
    "allowedFilters": [],
    "favorites": [],
    "displayName": "test",
    "user": {
        "id": "xE7jOejl9FI",
        "code": null,
        "name": "John Traore",
        "username": "admin"
    },
    "id": "ChZ236jPgXs",
    "dashboardItems": [
        {
            "x": 0,
            "y": 0,
            "w": 20,
            "h": 29,
            "id": "cKd9PKBuHv6",
            "type": "VISUALIZATION",
            "position": null,
            "visualization": {
                "id": "LW0O27b7TdD",
                "name": "ANC: 1-3 dropout rate Yearly"
            },
            "i": "cKd9PKBuHv6",
            "minH": 4,
            "firstOfType": true,
            "width": 20,
            "height": 29
        }
    ],
    "starred": false
}
```

#### Update an Item
To update properties of any item inside a dashboard, send a **PUT** request to:

```
 /api/dashboards/ChZ236jPgXs
```

The payload must be the latest *Dashboard* object, including all its items with updated property value.

#### Remove an Item
To remove an item from a dashboard, remove it from the *Dashboard* payload and send a **PUT** request to:

```
 /api/dashboards/ChZ236jPgXs
```


### Defining a dashboard layout { #webapi_dasboard_layout } 

You can define and save a layout for each dashboard. The following object is responsible to hold this setting.

    {
      "layout": {
        "spacing": {
          "column": 5,
          "row": 5
        },
        "columns": [{
          "index": 0,
          "span": 2
        }, {
          "index": 1,
          "span": 1
        }]
      }
    }

The layout definition will be applied for all dashboard items related to the given dashboard, respecting layout attributes like spacing, columns, span and so on. See, below, a brief description of each attribute.

Table: Layout attributes

| Attribute | Description | Type |
|---|---|---|
| layout | This is the root object | Object |
| spacing | Defines the spacing for specific layout components. Currently, it supports columns and rows. | Object |
| columns | Stores specific parameters related to columns (at the moment, index and span) | Array of objects |

## Visualization { #webapi_visualization } 

The Visualization API is designed to help clients to interact with charts and pivot/report tables. The endpoints of this API are used by the Data Visualization application which allows the creation, configuration and management of charts and pivot tables based on the client's definitions. The main idea is to enable clients and users to have a unique and centralized API providing all types of charts and pivot tables as well as specific parameters and configuration for each type of visualization.

This API was introduced to unify both `charts` and `reportTables` APIs and entirely replace them by the `visualizations` API.

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
| fixColumnHeaders | Keeps the columns' headers fixed (or not) in a Pivot Table. Boolean value. |
| fixRowHeaders | Keeps the rows' headers fixed (or not) in a Pivot Table. Boolean value. |
| completedOnly | Flag used in analytics requests. If true, only completed events/enrollments will be taken into consideration. Boolean value. |
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
  "fixColumnHeaders": true,
  "fixRowHeaders": false,
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

## Event visualization
<!--DHIS2-SECTION-ID:webapi_event_visualization-->
The EventVisualization API is designed to help clients to interact with event charts and reports. The endpoints of this API are used by the Event Visualization application which allows the creation, configuration and management of charts and reports based on the client's definitions. The main idea is to enable clients and users to have a unique and centralized API providing all types of event charts and reports as well as specific parameters and configuration for each type of event visualization.
This API was introduced with the expectation to unify both `eventCharts` and `eventReports` APIs and entirely replace them in favour of the `eventVisualizations` API (which means that the usage of `eventCharts` and `eventReports` APIs should be avoided). In summary, the following resources/APIs:
    /api/eventCharts, /api/eventReports
*are being replaced by*
    /api/eventVisualizations

> **Note**
>
> New applications and clients should avoid using the `eventCharts` and `eventReports` APIs because they are deprecated. Use the `eventVisualizations` API instead.

An EventVisualization object is composed of many attributes (some of them related to charting and others related to reporting), but the most important ones responsible to reflect the core information of the object are: *"id", "name", "type", "dataDimensionItems", "columns", "rows" and "filters".*
The root endpoint of the API is `/api/eventVisualizations`, and the list of current attributes and elements are described in the table below.



Table: EventVisualization attributes

| Field | Description |
|---|---|
| id | The unique identifier. |
| code | A custom code to identify the EventVisualiation. |
| name | The name of the EventVisualiation |
| type | The type of the EventVisualiation. The valid types are: COLUMN, STACKED_COLUMN, BAR, STACKED_BAR, LINE, LINE_LIST, AREA, STACKED_AREA, PIE, RADAR, GAUGE, YEAR_OVER_YEAR_LINE, YEAR_OVER_YEAR_COLUMN, SINGLE_VALUE, PIVOT_TABLE, SCATTER, BUBBLE. |
| title | A custom title. |
| subtitle | A custom subtitle. |
| description | Defines a custom description for the EventVisualiation. |
| created | The date/time of the EventVisualiation creation. |
| startDate | The beginning date used during the filtering. |
| endDate | The ending date used during the filtering. |
| sortOrder | The sorting order of this EventVisualiation. Integer value. |
| user | An object representing the creator of the Visualization. |
| publicAccess | Sets the permissions for public access. |
| displayDensity | The display density of the text. |
| fontSize | The font size of the text. |
| relativePeriods | An object representing the relative periods used in the analytics query. |
| legend | An object representing the definitions for the legend and legend set, display style (FILL or TEXT) and display strategy (FIXED or BY_DATA_ITEM). |
| aggregationType | Determines how the values are aggregated (if applicable). Valid options: SUM, AVERAGE, AVERAGE_SUM_ORG_UNIT, LAST, LAST_AVERAGE_ORG_UNIT, FIRST, FIRST_AVERAGE_ORG_UNIT, COUNT, STDDEV, VARIANCE, MIN, MAX, NONE, CUSTOM or DEFAULT. |
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
| externalAccess | Indicates whether the EventVisualization is available as external read-only. Boolean value. |
| userOrganisationUnit | Indicates if the user has an organisation unit. Boolean value. |
| userOrganisationUnitChildren | Indicates if the user has a children organisation unit. Boolean value. |
| userOrganisationUnitGrandChildren | Indicates if the user has a grand children organisation unit. Boolean value. |
| rowTotals | Displays (or not) the row totals. Boolean value. |
| colTotals | Displays (or not) the columns totals. Boolean value. |
| rowSubTotals | Displays (or not) the row sub-totals. Boolean value. |
| colSubTotals | Displays (or not) the columns sub-totals. Boolean value. |
| cumulativeValues | Indicates whether the EventVisualization is using cumulative values. Boolean value. |
| hideEmptyRows | Indicates whether to hide rows with no data values. Boolean value. |
| completedOnly | Flag used in analytics requests. If true, only completed events/enrollments will be taken into consideration. Boolean value. |
| showDimensionLabels | Shows the dimension labels or not. Boolean value. |
| hideTitle | Hides the title or not. Boolean value. |
| hideSubtitle | Hides the subtitle or not. Boolean value. |
| showHierarchy | Displays (or not) the organisation unit hierarchy names. Boolean value. |
| showData | Used by charts to hide or not data/values within the rendered model. Boolean value. |
| lastUpdatedBy | Object that represents the user that applied the last changes to the EventVisualization. |
| lastUpdated | The date/time of the last time the EventVisualization was changed. |
| favorites | List of user ids who have marked this object as a favorite. |
| subscribers | List of user ids who have subscribed to this EventVisualization. |
| translations | Set of available object translation, normally filtered by locale. |
| program | The program associated. |
| programStage | The program stage associated. |
| programStatus | The program status. It can be ACTIVE, COMPLETED, CANCELLED. |
| eventStatus | The event status. It can be ACTIVE, COMPLETED, VISITED, SCHEDULE, OVERDUE, SKIPPED. |
| dataType | The event data type. It can be AGGREGATED_VALUES or EVENTS. |
| columnDimensions | The dimensions defined for the columns. |
| rowDimensions | The dimensions defined for the rows. |
| filterDimensions | The dimensions defined for the filters. |
| outputType | Indicates output type of the EventVisualization. It can be EVENT, ENROLLMENT or TRACKED_ENTITY_INSTANCE. |
| collapseDataDimensions | Indicates whether to collapse all data dimensions into a single dimension. Boolean value. |
| hideNaData | Indicates whether to hide N/A data. Boolean value. |

### Retrieving event visualizations
<!--DHIS2-SECTION-ID:webapi_event_visualization_retrieving_event_visualizations-->
To retrieve a list of all existing event visualizations, in JSON format, with some basic information (including identifier, name and pagination) you can make a `GET` request to the URL below. You should see a list of all public/shared event visualizations plus your private ones.
    GET /api/eventVisualizations.json
If you want to retrieve the JSON definition of a specific EventVisualization you can add its respective identifier to the URL:
    GET /api/eventVisualizations/hQxZGXqnLS9.json
The following representation is an example of a response in JSON format (for brevity, certain information has been removed). For the complete schema, please use `GET /api/schemas/eventVisualization`.

```json
{
    "lastUpdated": "2021-11-25T17:18:03.834",
    "href": "http://localhost:8080/dhis/api/eventVisualizations/EZ5jbRTxRGh",
    "id": "EZ5jbRTxRGh",
    "created": "2021-11-25T17:18:03.834",
    "name": "Inpatient: Mode of discharge by facility type this year",
    "publicAccess": "rw------",
    "userOrganisationUnitChildren": false,
    "type": "STACKED_COLUMN",
    "subscribed": false,
    "userOrganisationUnit": false,
    "rowSubTotals": false,
    "cumulativeValues": false,
    "showDimensionLabels": false,
    "sortOrder": 0,
    "favorite": false,
    "topLimit": 0,
    "collapseDataDimensions": false,
    "userOrganisationUnitGrandChildren": false,
    "displayName": "Inpatient: Mode of discharge by facility type this year",
    "percentStackedValues": false,
    "noSpaceBetweenColumns": false,
    "showHierarchy": false,
    "hideTitle": false,
    "showData": true,
    "hideEmptyRows": false,
    "hideNaData": false,
    "regressionType": "NONE",
    "completedOnly": false,
    "colTotals": false,
    "sharing": {
      "owner": "GOLswS44mh8",
      "external": false,
      "users": {},
      "userGroups": {},
      "public": "rw------"
    },
    "programStatus": "CANCELLED",
    "hideEmptyRowItems": "NONE",
    "hideSubtitle": false,
    "outputType": "EVENT",
    "hideLegend": false,
    "externalAccess": false,
    "colSubTotals": false,
    "rowTotals": false,
    "digitGroupSeparator": "SPACE",
    "program": {
      "id": "IpHINAT79UW"
    },
    "access": {
      "read": true,
      "update": true,
      "externalize": true,
      "delete": true,
      "write": true,
      "manage": true
    },
    "lastUpdatedBy": {
      "displayName": "John Traore",
      "name": "John Traore",
      "id": "xE7jOejl9FI",
      "username": "admin"
    },
    "relativePeriods": {
      "thisYear": false,
      ...
    },
    "programStage": {
      "id": "A03MvHHogjR"
    },
    "createdBy": {
      "displayName": "Tom Wakiki",
      "name": "Tom Wakiki",
      "id": "GOLswS44mh8",
      "username": "system"
    },
    "user": {
      "displayName": "Tom Wakiki",
      "name": "Tom Wakiki",
      "id": "GOLswS44mh8",
      "username": "system"
    },
    "attributeDimensions": [],
    "translations": [],
    "legend": {
      "set": {
        "id": "gFJUXah1uRH"
      },
      "showKey": false,
      "style": "FILL",
      "strategy": "FIXED"
    },
    "filterDimensions": [
      "ou",
      "H6uSAMO5WLD"
    ],
    "interpretations": [],
    "userGroupAccesses": [],
    "subscribers": [],
    "columns": [
      {
        "id": "X8zyunlgUfM"
      }
    ]
    "periods": [],
    "categoryDimensions": [],
    "rowDimensions": [
      "pe"
    ],
    "itemOrganisationUnitGroups": [],
    "programIndicatorDimensions": [],
    "attributeValues": [],
    "columnDimensions": [
      "X8zyunlgUfM"
    ],
    "userAccesses": [],
    "favorites": [],
    "dataDimensionItems": [],
    "categoryOptionGroupSetDimensions": [],
    "organisationUnitGroupSetDimensions": [],
    "organisationUnitLevels": [],
    "organisationUnits": [
      {
        "id": "ImspTQPwCqd"
      }
    ],
    "filters": [
      {
        "id": "ou"
      },
      {
        "id": "H6uSAMO5WLD"
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
    GET /api/eventVisualizations/hQxZGXqnLS9.json?fields=interpretations
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

### Creating, updating and removing event visualizations
<!--DHIS2-SECTION-ID:webapi_event_visualization_add_update_remove_event_visualizations-->
These operations follow the standard *REST* semantics. A new EventVisualization can be created through a `POST` request to the `/api/eventVisualizations` resource with a valid JSON payload. An example of payload could be:

```json
{
    "name": "Inpatient: Cases under 10 years last 4 quarters",
    "publicAccess": "rw------",
    "userOrganisationUnitChildren": false,
    "type": "STACKED_COLUMN",
    "subscribed": false,
    "userOrganisationUnit": false,
    "rowSubTotals": false,
    "cumulativeValues": false,
    "showDimensionLabels": false,
    "sortOrder": 0,
    "favorite": false,
    "topLimit": 0,
    "collapseDataDimensions": false,
    "userOrganisationUnitGrandChildren": false,
    "displayName": "Inpatient: Cases under 10 years last 4 quarters",
    "percentStackedValues": false,
    "noSpaceBetweenColumns": false,
    "showHierarchy": false,
    "hideTitle": false,
    "showData": true,
    "hideEmptyRows": false,
    "userAccesses": [],
    "userGroupAccesses": [],
    "hideNaData": false,
    "regressionType": "NONE",
    "completedOnly": false,
    "colTotals": false,
    "programStatus": "CANCELLED",
    "sharing": {
      "owner": "GOLswS44mh8",
      "external": false,
      "users": {},
      "userGroups": {},
      "public": "rw------"
    },
    "displayFormName": "Inpatient: Cases under 10 years last 4 quarters",
    "hideEmptyRowItems": "NONE",
    "hideSubtitle": false,
    "outputType": "EVENT",
    "hideLegend": false,
    "externalAccess": false,
    "colSubTotals": false,
    "rowTotals": false,
    "digitGroupSeparator": "SPACE",
    "access": {
      "read": true,
      "update": true,
      "externalize": false,
      "delete": true,
      "write": true,
      "manage": true
    },
    "lastUpdatedBy": {
      "displayName": "Tom Wakiki",
      "name": "Tom Wakiki",
      "id": "GOLswS44mh8",
      "username": "system"
    },
    "legend": {
      "set": {
        "id": "gFJUXah1uRH"
      },
      "showKey": false,
      "style": "FILL",
      "strategy": "FIXED"
    },
    "relativePeriods": {
      "thisYear": false,
    ...
    },
    "program": {
      "id": "IpHINAT79UW",
      "enrollmentDateLabel": "Date of enrollment",
      "incidentDateLabel": "Date of birth",
      "name": "Child Programme"
    },
    "programStage": {
      "id": "A03MvHHogjR",
      "executionDateLabel": "Report date",
      "name": "Birth"
    },
    "createdBy": {
      "displayName": "Tom Wakiki",
      "name": "Tom Wakiki",
      "id": "GOLswS44mh8",
      "username": "system"
    },
    "user": {
      "displayName": "Tom Wakiki",
      "name": "Tom Wakiki",
      "id": "GOLswS44mh8",
      "username": "system"
    },
    "translations": [],
    "filterDimensions": [
      "ou"
    ],
    "interpretations": [],
    "dataElementDimensions": [
      {
        "filter": "LE:10",
        "dataElement": {
          "id": "qrur9Dvnyt5"
        }
      }
    ],
    "periods": [],
    "categoryDimensions": [],
    "rowDimensions": [
      "pe"
    ],
    "columnDimensions": [
      "qrur9Dvnyt5"
    ],
    "organisationUnits": [
      {
        "id": "ImspTQPwCqd"
      }
    ],
    "filters": [
      {
        "dimension": "ou",
        "items": [
          {
            "id": "ImspTQPwCqd"
          }
        ]
      },
      {
        "dimension": "H6uSAMO5WLD",
        "items": []
      }
    ],
    "columns": [
      {
        "dimension": "X8zyunlgUfM",
        "items": [],
        "repetition": {
          "indexes": [1, 2, 3, -2, -1, 0]
        }
      },
      {
        "dimension": "eventDate",
        "items": [
          {
            "id": "2021-07-21_2021-08-01"
          },
          {
            "id": "2021-01-21_2021-02-01"
          }
        ]
      },
      {
        "dimension": "incidentDate",
        "items": [
          {
            "id": "2021-10-01_2021-10-30"
          }
        ]
      },
      {
        "dimension": "eventStatus",
        "items": [
          {
            "id": "ACTIVE"
          },
          {
            "id": "COMPLETED"
          }
        ]
      },
      {
        "dimension": "createdBy",
        "items": [
          {
            "id": "userA"
          }
        ]
      },
      {
        "dimension": "lastUpdatedBy",
        "items": [
          {
            "id": "userB"
          }
        ]
      }
    ],
    "rows": [
      {
        "dimension": "pe",
        "items": [
          {
            "id": "LAST_12_MONTHS"
          }
        ]
      }
    ]
}
```

For multi-program support, the root `program` should not be specified. This will turn the `eventVisualization` into a multi-program. Consequently, we have to specify the `program` and `programStage` (when applicable) for each `dimension` in `rows`, `columns`, and `filters`.

Example:

```json
"program": null,
"columns": [
  {
    "dimension": "ou",
    "items": [
        {
            "id": "O6uvpzGd5pu"
        }
    ],
    "program": {
        "id": "IpHINAT79UW"
    }
  },
  {
    "dimensionType": "CATEGORY_OPTION_GROUP_SET",
    "items": [
      {
          "id": "JLGV7lRQRAg"
      },
      {
          "id": "p916ZCVGNyq"
      }
    ],
    "dimension": "C31vHZqu0qU",
    "program": {
        "id": "kla3mAPgvCH"
    },
    "programStage": {
        "id": "aNLq9ZYoy9W"
    }
  }
]
```

> **Note**
>
> The `repetition` attribute (in `rows`, `columns` or `filters`) indicates the events indexes to be retrieved. Taking the example above (in the previous `json` payload), it can be read as follows:
> 
    1 = First event
    2 = Second event
    3 = Third event
    ...
    -2 = Third latest event
    -1 = Second latest event
    0 = Latest event (default)

To update a specific EventVisualization, you can send a `PUT` request to the same `/api/eventVisualizations` resource with a similar payload `PLUS` the respective EventVisualization's identifier, ie.:
    PUT /api/eventVisualizations/hQxZGXqnLS9
Finally, to delete an existing EventVisualization, you can make a `DELETE` request specifying the identifier of the EventVisualization to be removed, as shown:
    DELETE /api/eventVisualizations/hQxZGXqnLS9

## Interpretations { #webapi_interpretations } 

For resources related to data analysis in DHIS2, such as visualizations, maps, event reports, event charts and even visualizations you can write and share data interpretations. An interpretation can be a comment, question, observation or interpretation about a data report or visualization.

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
      "type": "MAP",
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
      "type": "VISUALIZATION",
      "likes": 3,
      "user": {
        "id": "uk7diLujYif"
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
| type | The type of analytical object being interpreted. Valid options: VISUALIZATION, MAP, EVENT_REPORT, EVENT_CHART, EVENT_VISUALIZATION, DATASET_REPORT. |
| user | Association to the user who created the interpretation. |
| visualization | Association to the visualization if type is VISUALIZATION |
| eventVisualization | Association to the event visualization if type is EVENT_VISUALIZATION |
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

Valid options for object type are *visualization*, *map*,
*eventReport*, *eventChart*, *eventVisualization* and *dataSetReport*.

Some valid examples for interpretations are listed below.

> **Note**
>
> The `eventCharts` and `eventReports` APIs are deprecated. We recommend using the `eventVisualizations` API instead.

    /api/interpretations/visualization/hQxZGXqnLS9
    /api/interpretations/map/FwLHSMCejFu
    /api/interpretations/eventReport/xJmPLGP3Cde
    /api/interpretations/eventChart/nEzXB2M9YBz
    /api/interpretations/eventVisualization/nEzXB2M9YBz
    /api/interpretations/dataSetReport/tL7eCjmDIgM

As an example, we will start by writing an interpretation for the visualization with identifier *EbRN2VIbPdV*. To write visualization interpretations we will interact with the `/api/interpretations/visualization/{visualizationId}` resource.
The interpretation will be the request body. Based on this we can put
together the following request using cURL:

```bash
curl -d "This visualization shows a significant ANC 1-3 dropout" -X POST
  "https://play.dhis2.org/demo/api/interpretations/visualization/EbRN2VIbPdV" -H "Content-Type:text/plain" -u admin:district
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
curl -d "This visualization shows a high dropout" -X PUT
  "https://play.dhis2.org/demo/api/interpretations/visualization/EV08iI1cJRA" -H "Content-Type:text/plain" -u admin:district
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
  "type": "VISUALIZATION",
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
select ou.name as orgunit, par.name as parent, ou.coordinates, ous.level, oul.name 
from organisationunit ou
inner join _orgunitstructure ous on ou.organisationunitid = ous.organisationunitid
inner join organisationunit par on ou.parentid = par.organisationunitid
inner join orgunitlevel oul on ous.level = oul.level
where ou.coordinates is not null
order by oul.level, par.name, ou.name;
```

We will use *curl* to first execute the view on the DHIS2 server. This
is essentially a materialization process, and ensures that we have the
most recent data available through the SQL view when it is retrieved
from the server. You can first look up the SQL view from the
api/sqlViews resource, then POST using the following command:

```bash
curl "https://play.dhis2.org/demo/api/sqlViews/dI68mLkP1wN/execute" -X POST -u admin:district
```

The next step in the process is the retrieval of the data. The endpoint is available at:

    /api/sqlViews/{id}/data(.csv)

The `id` path represents the SQL view identifier. The path extensions refers to the format of the data download. Append either `data` for JSON data or `data.csv` for comma separated  values. Support response formats are json, xml, csv, xls, html and html+css. 

As an example, the following command would retrieve CSV data for the SQL view defined above.

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
organisation units at level 4 you can use the following URL:

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
order by ou.path;
```

### Filtering { #webapi_sql_view_filtering } 

The SQL view API supports data filtering, equal to the [metadata object_filter](#webapi_metadata_object_filter). For a complete list of filter operators you can look at the documentation for [metadata object_filter](#webapi_metadata_object_filter).

To use filters, simply add them as parameters at the end of the request URL for your SQL view like this. This request will return a result including org units with "bo" in the name at level 2 of the org unit hierarchy:

    /api/sqlViews/w3UxFykyHFy/data.json?filter=orgunit_level:eq:2&filter=orgunit_name:ilike:bo

The following example will return all org units with `orgunit_level` 2 or 4:

    /api/sqlViews/w3UxFykyHFy/data.json?filter=orgunit_level:in:[2,4]

And last, an example to return all org units that does not start with "Bo":

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

### Endpoint responses { #webapi_data_items_possible_responses } 

Base on the `GET` request/query, the following status codes and responses are can be returned.

#### Results found (status code 200)

```json
{
  "pager": {
    "page": 1,
    "pageCount": 27,
    "total": 1339,
    "pageSize": 50
  },
  "dataItems": [
    {
      "simplifiedValueType": "TEXT",
      "displayName": "TB program Gender",
      "displayShortName": "TB prog. Gen.",
      "valueType": "TEXT",
      "name": "TB program Gender",
      "shortName": "TB prog Gen",
      "id": "ur1Edk5Oe2n.cejWyOfXge6",
      "programId": "ur1Edk5Oe2n",
      "dimensionItemType": "PROGRAM_ATTRIBUTE"
    }
  ]
}
```

#### Results not found (status code 200)

```json
{
  "pager": {
    "page": 1,
    "pageCount": 1,
    "total": 0,
    "pageSize": 50
  },
  "dataItems": [
  ]
}
```

#### Invalid query (status code 409)

```json
{
  "httpStatus": "Conflict",
  "httpStatusCode": 409,
  "status": "ERROR",
  "message": "Unable to parse element `INVALID_TYPE` on filter dimensionItemType`. The values available are: [INDICATOR, DATA_ELEMENT, DATA_ELEMENT_OPERAND, DATA_SET, PROGRAM_INDICATOR, PROGRAM_DATA_ELEMENT, PROGRAM_ATTRIBUTE]",
  "errorCode": "E2016"
}
```

### Pagination { #webapi_data_items_pagination } 

This endpoint also supports pagination as a default option. If needed, you can disable pagination by adding `paging=false` to the `GET` request, i.e.: `/api/dataItems?filter=dimensionItemType:in:[INDICATOR]&paging=false`.

Here is an example of a payload when the pagination is enabled. Remember that pagination is the default option and does not need to be explicitly set.

```json
{
  "pager": {
    "page": 1,
    "pageCount": 20,
    "total": 969,
    "pageSize": 50
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
*maps*, *visualizations*, *eventVisualizations*, *reports* and *documents*. By visiting these resources you will retrieve information about the resource. For instance, by navigating to `/api/visualizations/R0DVGvXDUNP` the response will contain the name, last date of modification and so on for the chart. To retrieve the analytical representation, for instance, a PNG representation of the visualization, you can append */data* to all these resources. For instance, by visiting `/api/visualizations/R0DVGvXDUNP/data` the system will return a PNG image of the visualization.

Table: Analytical resources

| Resource | Description | Data URL | Resource representations |
|---|---|---|---|
| eventCharts | Event charts | /api/eventCharts/<identifier\>/data | png |
| maps | Maps | /api/maps/<identifier\>/data | png |
| visualizations | Pivot tables and charts | /api/visualizations/<identifier\>/data | json &#124; jsonp &#124; html &#124; xml &#124; pdf &#124; xls &#124; csv 
| eventVisualizations | Event charts | /api/eventVisualizations/<identifier\>/data | png 
| png |
| reports | Standard reports | /api/reports/<identifier\>/data | pdf &#124; xls &#124; html |
| documents | Resources | /api/documents/<identifier\>/data | <follows document\> |

The data content of the analytical representations can be modified by
providing a *date* query parameter. This requires that the analytical
resource is set up for relative periods for the period dimension.

Table: Data query parameters

| Query parameter | Value | Description |
|---|---|---|
| date | Date in yyyy-MM-dd format | Basis for relative periods in report (requires relative periods) |

Table: Query parameters for png / image types (visualizations, maps)

| Query parameter | Description |
|---|---|
| width | Width of image in pixels |
| height | Height of image in pixels |

Some examples of valid URLs for retrieving various analytical
representations are listed below.

    /api/visualizations/R0DVGvXDUNP/data
    /api/visualizations/R0DVGvXDUNP/data?date=2013-06-01
    
    /api/visualizations/jIISuEWxmoI/data.html
    /api/visualizations/jIISuEWxmoI/data.html?date=2013-01-01
    /api/visualizations/FPmvWs7bn2P/data.xls
    /api/visualizations/FPmvWs7bn2P/data.pdf
    
    /api/eventVisualizations/x5FVFVt5CDI/data
    /api/eventVisualizations/x5FVFVt5CDI/data.png
    
    /api/maps/DHE98Gsynpr/data
    /api/maps/DHE98Gsynpr/data?date=2013-07-01
    
    /api/reports/OeJsA6K1Otx/data.pdf
    /api/reports/OeJsA6K1Otx/data.pdf?date=2014-01-01
