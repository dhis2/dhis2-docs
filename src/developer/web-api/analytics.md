# Analytics

## Analytics { #webapi_analytics } 

To access analytical, aggregated data in DHIS2 you can work with the
*analytics* resource. The analytics resource is powerful as it lets you
query and retrieve data aggregated along all available data dimensions.
For instance, you can ask the analytics resource to provide the
aggregated data values for a set of data elements, periods and
organisation units. Also, you can retrieve the aggregated data for a
combination of any number of dimensions based on data elements and
organisation unit group sets.

    /api/33/analytics

### Request query parameters { #webapi_analytics_query_parameters } 

The analytics resource lets you specify a range of query parameters:

<table>
<caption>Query parameters</caption>
<colgroup>
<col style="width: 17%" />
<col style="width: 10%" />
<col style="width: 45%" />
<col style="width: 27%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options (default first)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dimension</td>
<td>Yes</td>
<td>Dimensions and dimension items to be retrieved, repeated for each.</td>
<td>Any dimension</td>
</tr>
<tr class="even">
<td>filter</td>
<td>No</td>
<td>Filters and filter items to apply to the query, repeated for each.</td>
<td>Any dimension</td>
</tr>
<tr class="odd">
<td>aggregationType</td>
<td>No</td>
<td>Aggregation type to use in the aggregation process.</td>
<td>SUM | AVERAGE | AVERAGE_SUM_ORG_UNIT | LAST | LAST_AVERAGE_ORG_UNIT | COUNT | STDDEV | VARIANCE | MIN | MAX</td>
</tr>
<tr class="even">
<td>measureCriteria</td>
<td>No</td>
<td>Filters for the data/measures.</td>
<td>EQ | GT | GE | LT | LE</td>
</tr>
<tr class="odd">
<td>preAggregationMeasureCriteria</td>
<td>No</td>
<td>Filters for the data/measure, applied before aggregation is performed.</td>
<td>EQ | GT | GE | LT | LE</td>
</tr>
<tr>
<td>startDate</td>
<td>No</td>
<td>Start date for a date range. Will be applied as a filter. Can not be used together with a period dimension or filter.</td>
<td>Date</td>
</tr>
<tr>
<td>endDate</td>
<td>No</td>
<td>End date for date range. Will be applied as a filter. Can not be used together with a period dimension or filter.</td>
<td>Date</td>
</tr>
<tr class="even">
<td>skipMeta</td>
<td>No</td>
<td>Exclude the metadata part of the response (improves performance).</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>skipData</td>
<td>No</td>
<td>Exclude the data part of the response.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>skipRounding</td>
<td>No</td>
<td>Skip rounding of data values, i.e. provide full precision.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>hierarchyMeta</td>
<td>No</td>
<td>Include names of organisation unit ancestors and hierarchy paths of organisation units in the metadata.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>ignoreLimit</td>
<td>No</td>
<td>Ignore limit on max 50 000 records in response - use with care.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>tableLayout</td>
<td>No</td>
<td>Use plain data source or table layout for the response.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>hideEmptyRows</td>
<td>No</td>
<td>Hides empty rows in response, applicable when table layout is true.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>hideEmptyColumns</td>
<td>No</td>
<td>Hides empty columns in response, applicable when table layout is true.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>showHierarchy</td>
<td>No</td>
<td>Display full org unit hierarchy path together with org unit name.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>includeNumDen</td>
<td>No</td>
<td>Include the numerator and denominator used to calculate the value in the response.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>includeMetadataDetails</td>
<td>No</td>
<td>Include metadata details to raw data response.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>displayProperty</td>
<td>No</td>
<td>Property to display for metadata.</td>
<td>NAME | SHORTNAME</td>
</tr>
<tr class="even">
<td>outputIdScheme</td>
<td>No</td>
<td>Identifier scheme used for metadata items in the query response. It accepts identifier, code or attributes.</td>
<td>UID | UUID | CODE | NAME | ATTRIBUTE:&lt;ID&gt;</td>
</tr>
<tr class="odd">
<td>outputOrgUnitIdScheme</td>
<td>No</td>
<td>Identifier scheme used for metadata items in the query response. This parameter overrides the &quot;outputIdScheme&quot; specifically for for Org Units. It accepts identifier, code or attributes.</td>
<td>UUID | CODE | NAME | ATTRIBUTE:&lt;ID&gt;</td>
</tr>
<tr class="even">
<td>outputDataElementIdScheme</td>
<td>No</td>
<td>Identifier scheme used for metadata items in the query response. This parameter overrides the &quot;outputIdScheme&quot; specifically for Data Elements. It accepts identifier, code or attributes.</td>
<td>UUID | CODE | NAME | ATTRIBUTE:&lt;ID&gt;</td>
</tr>
<tr class="odd">
<td>inputIdScheme</td>
<td>No</td>
<td>Identifier scheme to use for metadata items in the query request, can be an identifier, code or attributes.</td>
<td>UID | CODE | ATTRIBUTE:&lt;ID&gt;</td>
</tr>
<tr class="even">
<td>approvalLevel</td>
<td>No</td>
<td>Include data which has been approved at least up to the given approval level, refers to identifier of approval level.</td>
<td>Identifier of approval level</td>
</tr>
<tr class="odd">
<td>relativePeriodDate</td>
<td>No</td>
<td>Date used as basis for relative periods.</td>
<td>Date.</td>
</tr>
<tr class="even">
<td>userOrgUnit</td>
<td>No</td>
<td>Explicitly define the user org units to utilize, overrides organisation units associated with the current user, multiple identifiers can be separated by semicolon.</td>
<td>Organisation unit identifiers.</td>
</tr>
<tr class="odd">
<td>columns</td>
<td>No</td>
<td>Dimensions to use as columns for table layout.</td>
<td>Any dimension (must be query dimension)</td>
</tr>
<tr class="even">
<td>rows</td>
<td>No</td>
<td>Dimensions to use as rows for table layout.</td>
<td>Any dimension (must be query dimension)</td>
</tr>
<tr class="odd">
<td>order</td>
<td>No</td>
<td>Specify the ordering of rows based on value.</td>
<td>ASC | DESC</td>
</tr>
<tr class="even">
<td>timeField</td>
<td>No</td>
<td>The time field to base event aggregation on. Applies to event data items only. Can be a predefined option or the ID of an attribute or data element with a time-based value type.</td>
<td>EVENT_DATE | ENROLLMENT_DATE | INCIDENT_DATE | DUE_DATE | COMPLETED_DATE | CREATED | LAST_UPDATED | &lt;Attribute ID&gt; | &lt;Data element ID&gt;</td>
</tr>
<tr>
<td>orgUnitField</td>
<td>No</td>
<td>The organisation unit field to base event aggregation on. Applies to event data items only. Can be the ID of an attribute or data element with the Organisation unit value type. The default option is specified as omitting the query parameter.
<td>&lt;Attribute ID&gt; | &lt;Data element ID&gt;</td>
</tr>
</tbody>
</table>

The *dimension* query parameter defines which dimensions should be
included in the analytics query. Any number of dimensions can be
specified. The dimension parameter should be repeated for each dimension
to include in the query response. The query response can potentially
contain aggregated values for all combinations of the specified
dimension items.

The *filter* parameter defines which dimensions should be used as
filters for the data retrieved in the analytics query. Any number of
filters can be specified. The filter parameter should be repeated for
each filter to use in the query. A filter differs from a dimension in
that the filter dimensions will not be part of the query response
content, and that the aggregated values in the response will be
collapsed on the filter dimensions. In other words, the data in the
response will be aggregated on the filter dimensions, but the filters
will not be included as dimensions in the actual response. As an
example, to query for certain data elements filtered by the periods and
organisation units you can use the following URL:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU&filter=pe:2014Q1;2014Q2
      &filter=ou:O6uvpzGd5pu;lc3eMKXaEfw

The *aggregationType* query parameter lets you define which aggregation
operator should be used for the query. By default, the aggregation
operator defined for data elements included in the query will be used.
If your query does not contain any data elements but does include data
element groups, the aggregation operator of the first data element in
the first group will be used. The order of groups and data elements is
undefined. This query parameter allows you to override the default and
specify a specific aggregation operator. As an example, you can set the
aggregation operator to "count" with the following URL:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD&dimension=pe:2014Q1&dimension=ou:O6uvpzGd5pu
      &aggregationType=COUNT

The *measureCriteria* query parameter lets you filter out ranges of data
records to return. You can instruct the system to return only records
where the aggregated data value is equal, greater than, greater or
equal, less than or less or equal to certain values. You can specify any
number of criteria on the following format, where *criteria* and
*value* should be substituted with real values:

    /api/33/analytics?measureCriteria=criteria:value;criteria:value

As an example, the following query will return only records where the
data value is greater or equal to 6500 and less than 33000:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU&dimension=pe:2014
      &dimension=ou:O6uvpzGd5pu;lc3eMKXaEfw&measureCriteria=GE:6500;LT:33000

Similar to *measureCriteria*, the *preAggregationMeasureCriteria* query
parameter lets you filter out data, only before aggregation is
performed. For example, the following query only aggregates data where
the original value is within the criteria defined:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU&dimension=pe:2014
      &dimension=ou:O6uvpzGd5pu;lc3eMKXaEfw&preAggregationMeasureCriteria=GE:10;LT:100

The *startDate* and *endDate* parameters can be used to specify a custom
date range to aggregate over. When specifying a date range you can not
specify relative nor fixed periods as dimension or filter. The date range
will filter the analytics response. You can use it like this:

    /api/33/analytics.json?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &dimension=ou:ImspTQPwCqd&startDate=2018-01-01&endDate=2018-06-01

In order to have the analytics resource generate the data in the shape
of a ready-made table, you can provide the *tableLayout* parameter with
true as value. Instead of generating a plain, normalized data source,
the analytics resource will now generate the data in a table layout. You
can use the *columns* and *rows* parameters with dimension identifiers
separated by semi-colons as values to indicate which ones to use as
table columns and rows. The column and rows dimensions must be present
as a data dimension in the query (not a filter). Such a request can look
like this:

    /api/33/analytics.html?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU&dimension=pe:2014Q1;2014Q2
      &dimension=ou:O6uvpzGd5pu&tableLayout=true&columns=dx;ou&rows=pe

The *order* parameter can be used for analytics resource to generate
ordered data. The data will be ordered in ascending (or descending) order
of values. An example request for ordering the values in descending
order is:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD&dimension=pe:LAST_12_MONTHS
      &dimension=ou:O6uvpzGd5pu&order=DESC

### Dimensions and items { #webapi_analytics_dimensions_and_items } 

DHIS2 features a multi-dimensional data model with several fixed and
dynamic data dimensions. The fixed dimensions are the data element,
period (time) and organisation unit dimension. You can dynamically add
dimensions through categories, data element group sets and organisation
unit group sets. The table below displays the available data dimensions
in DHIS2. Each data dimension has a corresponding *dimension
identifier*, and each dimension can have a set of *dimension items*:

<table>
<caption>Dimensions and dimension items</caption>
<colgroup>
<col style="width: 38%" />
<col style="width: 12%" />
<col style="width: 49%" />
</colgroup>
<thead>
<tr class="header">
<th>Dimension</th>
<th>Dimension id</th>
<th>Dimension items</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Data elements, indicators, data set reporting rate metrics, data element operands, program indicators, program data elements, program attributes, validation rules</td>
<td>dx</td>
<td>Data element, indicator, data set reporting rate metrics, data element operand, program indicator, program attribute identifiers, keyword DE_GROUP-&lt;group-id&gt;, IN_GROUP-&lt;group-id&gt;, use &lt;dataelement-id&gt;.&lt;optioncombo-id&gt; for data element operands, &lt;program-id&gt;.&lt;dataelement-id&gt; for program data elements, &lt;program-id&gt;.&lt;attribute-id&gt; for program attributes, &lt;validationrule-id&gt; for validation results.</td>
</tr>
<tr class="even">
<td>Periods (time)</td>
<td>pe</td>
<td>ISO periods and relative periods, see &quot;date and period format&quot;</td>
</tr>
<tr class="odd">
<td>Organisation unit hierarchy</td>
<td>ou</td>
<td>Organisation unit identifiers, and keywords USER_ORGUNIT, USER_ORGUNIT_CHILDREN, USER_ORGUNIT_GRANDCHILDREN, LEVEL-&lt;level&gt; and OU_GROUP-&lt;group-id&gt;</td>
</tr>
<tr class="even">
<td>Category option combinations</td>
<td>co</td>
<td>Category option combo identifiers  (omit to get all items)</td>
</tr>
<tr class="odd">
<td>Attribute option combinations</td>
<td>ao</td>
<td>Category option combo identifiers (omit to get all items)</td>
</tr>
<tr class="even">
<td>Categories</td>
<td>&lt;category id&gt;</td>
<td>Category option identifiers (omit to get all items)</td>
</tr>
<tr class="odd">
<td>Data element group sets</td>
<td>&lt;group set id&gt;</td>
<td>Data element group identifiers (omit to get all items)</td>
</tr>
<tr class="even">
<td>Organisation unit group sets</td>
<td>&lt;group set id&gt;</td>
<td>Organisation unit group identifiers (omit to get all items)</td>
</tr>
<tr class="odd">
<td>Category option group sets</td>
<td>&lt;group set id&gt;</td>
<td>Category option group identifiers (omit to get all items)</td>
</tr>
</tbody>
</table>

It is not necessary to be aware of which objects are used for the
various dynamic dimensions when designing analytics queries. You can get
a complete list of dynamic dimensions by visiting this URL in the Web API:

    /api/33/dimensions

If you want to retrieve only the dimensional items for a given dynamic dimension you can
use the exemple below. The pagination is disabled by default. It can be enabled by adding
the pagination parameter `paging=true` to the URL.

    /api/33/dimensions/J5jldMd8OHv/items?paging=true

The base URL to the analytics resource is `/api/analytics`. To request
specific dimensions and dimension items you can use a query string on
the following format, where `dim-id` and `dim-item` should be substituted with real values:

    /api/33/analytics?dimension=dim-id:dim-item;dim-item&dimension=dim-id:dim-item;dim-item

As illustrated above, the dimension identifier is followed by a colon
while the dimension items are separated by semi-colons. As an example, a
query for two data elements, two periods and two organisation units can
be done with the following URL:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &dimension=pe:2016Q1;2016Q2&dimension=ou:O6uvpzGd5pu;lc3eMKXaEfw

To query for data broken down by category option combinations instead of
data element totals you can include the category dimension in the query
string, for instance like this:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &dimension=co&dimension=pe:201601&dimension=ou:O6uvpzGd5pu;lc3eMKXaEfw

When selecting data elements you can also select all data elements in a
group as items by using the DE_GROUP-<id> syntax:

    /api/33/analytics?dimension=dx:DE_GROUP-h9cuJOkOwY2
      &dimension=pe:201601&dimension=ou:O6uvpzGd5pu

When selecting data set reporting rates, the syntax contains a data
set identifier followed by a reporting rate metric:

    /api/33/analytics?dimension=dx:BfMAe6Itzgt.REPORTING_RATE;BfMAe6Itzgt.ACTUAL_REPORTS
      &dimension=pe:201601&dimension=ou:O6uvpzGd5pu

To query for program data elements (of tracker domain type) you can get
those by specifying the program for each data element using the
<program-id>.<dataelement-id> syntax:

    /api/33/analytics.json?dimension=dx:eBAyeGv0exc.qrur9Dvnyt5;eBAyeGv0exc.GieVkTxp4HH
      &dimension=pe:LAST_12_MONTHS&filter=ou:ImspTQPwCqd

To query for program attributes (tracked entity attributes) you can get
those by specifying the program for each attribute using the
<program.id>.<attribute-id> syntax:

    /api/33/analytics.json?dimension=dx:IpHINAT79UW.a3kGcGDCuk6;IpHINAT79UW.UXz7xuGCEhU
      &dimension=pe:LAST_4_QUARTERS&dimension=ou:ImspTQPwCqd

To query for organisation unit group sets and data elements you can use
the following URL. Notice how the group set identifier is used as
a dimension identifier and the groups as dimension items:

    /api/33/analytics?dimension=Bpx0589u8y0:oRVt7g429ZO;MAs88nJc9nL
      &dimension=pe:2016&dimension=ou:ImspTQPwCqd

To query for data elements and categories you can use this URL. Use the
category identifier as a dimension identifier and the category options as
dimension items:

    /api/33/analytics?dimension=dx:s46m5MS0hxu;fClA2Erf6IO&dimension=pe:2016
      &dimension=YNZyaJHiHYq:btOyqprQ9e8;GEqzEKCHoGA&filter=ou:ImspTQPwCqd

To query using relative periods and organisation units associated with
the current user you can use a URL like this:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &dimension=pe:LAST_12_MONTHS&dimension=ou:USER_ORGUNIT

When selecting organisation units for a dimension you can select an
entire level optionally constrained by any number of boundary
organisation units with the `LEVEL-<level>` syntax. Boundary refers to a
top node in a sub-hierarchy, meaning that all organisation units at the
given level below the given boundary organisation unit in the hierarchy
will be included in the response, and is provided as regular organisation unit
dimension items. The level value can either be a numerical level or refer to the identifier
of the organisation unit level entity. A simple query for all org units at level three:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD&dimension=pe:2016&dimension=ou:LEVEL-3

A query for level three and four with two boundary org units can be
specified like this:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD&dimension=pe:2016
      &dimension=ou:LEVEL-3;LEVEL-4;O6uvpzGd5pu;lc3eMKXaEf

When selecting organisation units you can also select all organisation
units in an organisation unit group to be included as dimension items
using the OU_GROUP-<id> syntax. The organisation units in the groups
can optionally be constrained by any number of boundary organisation
units. Both the level and the group items can be repeated any number of
times:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD&dimension=pe:2016
      &dimension=ou:OU_GROUP-w0gFTTmsUcF;OU_GROUP-EYbopBOJWsW;O6uvpzGd5pu;lc3eMKXaEf

You can utilize identifier schemes for the metadata part of the
analytics response with the outputIdScheme property like this. You can
use ID, code and attributes as identifier scheme:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &dimension=pe:2017Q1;2017Q2&dimension=ou:O6uvpzGd5pu&outputIdScheme=CODE

A few things to be aware of when using the analytics resource are listed
below.

  - Data elements, indicator, data set reporting rates, program data
    elements and program indicators are part of a common data dimension,
    identified as "dx". This means that you can use any of data
    elements, indicators and data set identifiers together with the "dx"
    dimension identifier in a query.

  - For the category, data element group set and organisation unit group
    set dimensions, all dimension items will be used in the query if no
    dimension items are specified.

  - For the period dimension, the dimension items are ISO period
    identifiers and/or relative periods. Please refer to the section
    above called "Date and period format" for the period format and
    available relative periods.

  - For the organisation unit dimension, you can specify the items to be
    the organisation unit or sub-units of the organisation unit
    associated with the user currently authenticated for the request
    using the keys `USER_ORGUNIT` or `USER_ORGUNIT_CHILDREN` as items,
    respectively. You can also specify organisation unit identifiers
    directly, or a combination of both.

  - For the organisation unit dimension, you can specify the organisation
    hierarchy level and the boundary unit to use for the request on the
    format `LEVEL-<level>-<boundary-id>`; as an example
    `LEVEL-3-ImspTQPwCqd` implies all organisation units below the given
    boundary unit at level 3 in the hierarchy.

  - For the organisation unit dimension, the dimension items are the
    organisation units and their sub-hierarchy - data will be aggregated
    for all organisation units below the given organisation unit in the
    hierarchy.

  - You cannot specify dimension items for the category option
    combination dimension. Instead, the response will contain the items
    which are linked to the data values.

### The dx dimension { #webapi_analytics_dx_dimension } 

The `dx` dimension is a special dimension which can contain all of the
following data types.

<table>
<caption>Data dx dimension types</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 23%" />
<col style="width: 27%" />
<col style="width: 23%" />
</colgroup>
<thead>
<tr class="header">
<th>Type</th>
<th>Syntax</th>
<th>Description</th>
<th>Data source</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Indicator</td>
<td>&lt;indicator-id&gt;</td>
<td>Indicator identifier.</td>
<td>Aggregated data</td>
</tr>
<tr class="even">
<td>Indicator grop</td>
<td>IN_GROUP-&lt;indicatorgroup-id&gt;</td>
<td>Keyword followed by an indicator group identifier. Will include all indicators in the group in the response.</td>
<td>Aggregated data</td>
</tr>
<tr class="odd">
<td>Data element</td>
<td>&lt;dataelement-id&gt;</td>
<td>Data element identifier.</td>
<td>Aggregated data</td>
</tr>
<tr class="even">
<td>Data element group</td>
<td>DE_GROUP-&lt;dataelementgroup-id&gt;</td>
<td>Keyword followed by a data element group identifier. Will include all data elements in the group in the response.</td>
<td>Aggregated data</td>
</tr>
<tr class="odd">
<td>Data element operand</td>
<td>&lt;dataelement-id&gt;.&lt;categoryoptcombo-id&gt;.&lt;attributeoptcombo-id&gt;</td>
<td>Data element identifier followed by one or both of category option combination and attribute option combo identifier. Wildcard &quot;*&quot; symbol can be used to indicate any option combination value. The attribute option combination identifier can be completely left out.</td>
<td>Aggregate data</td>
</tr>
<tr class="even">
<td>Data set</td>
<td>&lt;dataset-id&gt;.&lt;reporting-rate-metric&gt;</td>
<td>Data set identifier followed by reporting rate metric. Can be REPORTING_RATE | REPORTING_RATE_ON_TIME | ACTUAL_REPORTS | ACTUAL_REPORTS_ON_TIME | EXPECTED_REPORTS.</td>
<td>Data set completeness registrations</td>
</tr>
<tr class="odd">
<td>Program data element</td>
<td>&lt;program-id&gt;.&lt;dataelement-id&gt;</td>
<td>Program identifier followed by data element identifier. Reads from events within the specified program.</td>
<td>Events from the given program</td>
</tr>
<tr class="even">
<td>Program indicator</td>
<td>&lt;programindicator-id&gt;</td>
<td>Program indicator identifier. Reads from events from within the program associated with the program identifier.</td>
<td>Events from the program of the program indicator</td>
</tr>
<tr class="odd">
<td>Validation result</td>
<td>&lt;validationrule-id&gt;</td>
<td>Validation rule identifier. Will include validation rule violations for the validation rule, requires that validation results are generated and persisted.</td>
<td>Validation results</td>
</tr>
</tbody>
</table>

Items from all of the various `dx` types can be combined in an analytics
request. An example looks like this:

    /api/33/analytics.json
      ?dimension=dx:Uvn6LCg7dVU;BfMAe6Itzgt.REPORTING_RATE;IpHINAT79UW.a3kGcGDCuk6
      &dimension=pe:LAST_12_MONTHS&filter=ou:ImspTQPwCqd

The group syntax can be used together with any other item as well. An
example looks like this:

    /api/33/analytics.json
      ?dimension=dx:DE_GROUP-qfxEYY9xAl6;IN_GROUP-oehv9EO3vP7;BfMAe6Itzgt.REPORTING_RATE
      &dimension=pe:LAST_12_MONTHS&filter=ou:ImspTQPwCqd

Data element operands can optionally specify attribute option
combinations and use wildcards e.g. to specify all category option
combination values:

    /api/33/analytics.json
      ?dimension=dx:Uvn6LCg7dVU.*.j8vBiBqGf6O;Uvn6LCg7dVU.Z4oQs46iTeR
      &dimension=pe:LAST_12_MONTHS&filter=ou:ImspTQPwCqd

> **Tip**
>
> A great way to learn how to use the analytics API is to use the DHIS2
> *pivot table* app. You can play around with pivot tables using the
> various dimensions and items and click Download > Plain data source > JSON
> to see the resulting analytics API calls in the address bar of
> your Web browser.

### Response formats { #webapi_analytics_response_formats } 

The analytics response containing aggregate data can be returned in
various representation formats. As usual, you can indicate interest in a
specific format by appending a file extension to the URL, through the
`Accept` HTTP header or through the `format` query parameter. The
default format is JSON. The available formats and content-types are
listed below.

  - json (application/json)

  - jsonp (application/javascript)

  - xml (application/xml)

  - csv (application/csv)

  - html (text/html)

  - html+css (text/html)

  - xls (application/vnd.ms-excel)

As an example, to request an analytics response in XML format you can
use the following URL:

    /api/33/analytics.xml?dimension=dx:fbfJHSPpUQD
      &dimension=pe:2016&dimension=ou:O6uvpzGd5pu;lc3eMKXaEfw

The analytics responses must be retrieved using the HTTP *GET* method.
This allows for direct linking to analytics responses from Web pages as
well as other HTTP-enabled clients. To do functional testing we can use
the cURL library. By executing this command against the demo database
you will get an analytics response in JSON format:

```bash
curl "play.dhis2.org/demo/api/analytics.json?dimension=dx:eTDtyyaSA7f;FbKK4ofIv5R
  &dimension=pe:2016Q1;2016Q2&filter=ou:ImspTQPwCqd" -u admin:district
```

The JSON response will look like this:

```json
{
  "headers": [
    {
      "name": "dx",
      "column": "Data",
      "meta": true,
      "type": "java.lang.String"
    },
    {
      "name": "pe",
      "column": "Period",
      "meta": true,
      "type": "java.lang.String"
    },
    {
      "name": "value",
      "column": "Value",
      "meta": false,
      "type": "java.lang.Double"
    }
  ],
  "height": 4,
  "metaData": {
    "pe": [
      "2016Q1",
      "2016Q2"
    ],
    "ou": [
      "ImspTQPwCqd"
    ],
    "names": {
      "2016Q1": "Jan to Mar 2016",
      "2016Q2": "Apr to Jun 2016",
      "FbKK4ofIv5R": "Measles Coverage <1 y",
      "ImspTQPwCqd": "Sierra Leone",
      "eTDtyyaSA7f": "Fully Immunized Coverage"
    }
  },
  "rows": [
    [
      "eTDtyyaSA7f",
      "2016Q2",
      "81.1"
    ],
    [
      "eTDtyyaSA7f",
      "2016Q1",
      "74.7"
    ],
    [
      "FbKK4ofIv5R",
      "2016Q2",
      "88.9"
    ],
    [
      "FbKK4ofIv5R",
      "2016Q1",
      "84.0"
    ]
  ],
  "width": 3
}
```

The response represents a table of dimensional data. The *headers* array
gives an overview of which columns are included in the table and what
the columns contain. The *column* property shows the column dimension
identifier, or if the column contains measures, the word "Value". The
*meta* property is *true* if the column contains dimension items or
*false* if the column contains a measure (aggregated data values). The
*name* property is similar to the column property, except it displays
"value" in case the column contains a measure. The *type* property
indicates the Java class type of column values.

The *height* and *width* properties indicate how many data columns and
rows are contained in the response, respectively.

The *metaData periods* property contains a unique, ordered array of the
periods included in the response. The *metaData ou* property contains an
array of the identifiers of organisation units included in the response.
The *metaData names* property contains a mapping between the identifiers
used in the data response and the names of the objects they represent.
It can be used by clients to substitute the identifiers within the data
response with names in order to give a more meaningful view of the data
table.

The *rows* array contains the dimensional data table. It contains
columns with dimension items (object or period identifiers) and a column
with aggregated data values. The example response above has a
data/indicator column, a period column and a value column. The first
column contains indicator identifiers, the second contains ISO period
identifiers and the third contains aggregated data values.

### Constraints and validation { #webapi_analytics_constraints } 

There are several constraints to the input parameters you can provide to the
analytics resource. If any of the constraints are violated, the API will
return a *409 Conflict* response and a response message looking similar to this:

```json
{
  "httpStatus": "Conflict",
  "httpStatusCode": 409,
  "status": "ERROR",
  "message": "Only a single indicator can be specified as filter",
  "errorCode": "E7108"
}
```

The `httpStatus` and `httpStatusCode` fields indicate the HTTP status and
status code per the HTTP specification. The `messsage` field provides a
human-readable description of the validation error. The `errorCode` field
provides a machine-readable code which can be used by clients to handle
validation errors. The possible validation errors for the aggregate analytics
API are described in the table below.

| Error code | Message |
| ---------- | ------- |
| E7100      | Query parameters cannot be null |
| E7101      | At least one dimension must be specified |
| E7102      | At least one data dimension item or data element group set dimension item must be specified |
| E7103      | Dimensions cannot be specified as dimension and filter simultaneously |
| E7104      | At least one period as dimension or filter, or start and dates, must be specified |
| E7105      | Periods and start and end dates cannot be specified simultaneously |
| E7106      | Start date cannot be after end date |
| E7107      | Start and end dates cannot be specified for reporting rates |
| E7108      | Only a single indicator can be specified as filter |
| E7109      | Only a single reporting rate can be specified as filter |
| E7110      | Category option combos cannot be specified as filter |
| E7111      | Dimensions cannot be specified more than once |
| E7112      | Reporting rates can only be specified together with dimensions of type |
| E7113      | Assigned categories cannot be specified when data elements are not specified |
| E7114      | Assigned categories can only be specified together with data elements, not indicators or reporting rates |
| E7115      | Data elements must be of a value and aggregation type that allow aggregation |
| E7116      | Indicator expressions cannot contain cyclic references |
| E7117      | A data dimension 'dx' must be specified when output format is DATA_VALUE_SET |
| E7118      | A period dimension 'pe' must be specified when output format is DATA_VALUE_SET |
| E7119      | An organisation unit dimension 'ou' must be specified when output format is DATA_VALUE_SET |
| E7120      | User is not allowed to view org unit |
| E7121      | User is not allowed to read data for object |
| E7122      | Data approval level does not exist |
| E7123      | Current user is constrained by a dimension but has access to no dimension items |
| E7124      | Dimension is present in query without any valid dimension options |
| E7125      | Dimension identifier does not reference any dimension |
| E7126      | Column must be present as dimension in query |
| E7127      | Row must be present as dimension in query |
| E7128      | Query result set exceeded max limit |
| E7129      | Program is specified but does not exist |
| E7130      | Program stage is specified but does not exist |
| E7131      | Query failed, likely because the query timed out |

### Data value set format { #webapi_analytics_data_value_set_format } 

The analytics *dataValueSet* resource allows for returning aggregated
data in the data value set format. This format represents raw data
values, as opposed to data which has been aggregated along various
dimensions. Exporting aggregated data as regular data values is useful
for data exchange between systems when the target system contains data
of finer granularity compared to what the destination system is storing.

As an example, one can specify an indicator in the target system to
summarize data for multiple data elements and import this data for a
single data element in the destination system. As another example, one
can aggregate data collected at organisation unit level 4 in the target
system to level 2 and import that data in the destination system.

You can retrieve data in the raw data value set format from the
dataValueSet resource:

    /api/33/analytics/dataValueSet

The following resource representations are supported:

  - json (application/json)

  - xml (application/xml)

When using the data value set format, exactly three dimensions must be
specified as analytics dimensions with at least one dimension item each:

  - Data (dx)

  - Period (pe)

  - Organisation unit (ou)

Any other dimension will be ignored. Filters will be applied as with
regular analytics requests. Note that any data dimension type can be
specified, including indicators, data elements, data element operands,
data sets and program indicators.

An example request which aggregates data for specific indicators,
periods and organisation units and returns it as regular data values in
XML looks like this:

    api/analytics/dataValueSet.xml?dimension=dx:Uvn6LCg7dVU;OdiHJayrsKo
      &dimension=pe:LAST_4_QUARTERS&dimension=ou:lc3eMKXaEfw;PMa2VCrupOd

A request which aggregates data for data element operands and uses CODE
as output identifier scheme looks like the below. When defining the
output identifier scheme, all metadata objects part of the response are
affected:

    api/analytics/dataValueSet.json?dimension=dx:fbfJHSPpUQD.pq2XI5kz2BY;fbfJHSPpUQD.PT59n8BQbqM
      &dimension=pe:LAST_12_MONTHS&dimension=ou:ImspTQPwCqd&outputIdScheme=CODE

When using attribute-based identifier schemes for export there is a risk
of producing duplicate data values. The boolean query parameter
duplicatesOnly can be used for debugging purposes to return only
duplicates data values. This response can be used to clean up the
duplicates:

    api/analytics/dataValueSet.xml?dimension=dx:Uvn6LCg7dVU;OdiHJayrsKo
      &dimension=pe:LAST_4_QUARTERS&dimension=ou:lc3eMKXaEfw&duplicatesOnly=true

### Raw data format { #webapi_analytics_raw_data } 

The analytics *rawData* resource allows for returning the data stored in
the analytics data tables without any aggregation being performed. This
is useful for clients which would like to perform aggregation and
filtering on their own without having to denormalize data in the
available data dimensions themselves.

    /api/analytics/rawData

The following resource representations are supported:

  - json (application/json)

  - csv (application/csv)

This resource follows the syntax of the regular analytics resource. Only
a subset of the query parameters are supported. Additionally, a
*startDate* and *endDate* parameter are available. The supported
parameters are listed in the table below.

<table>
<caption>Query parameters</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required / Notes</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dimension</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>startDate</td>
<td>No / yyyy-MM-dd</td>
</tr>
<tr class="odd">
<td>endDate</td>
<td>No / yyyy-MM-dd</td>
</tr>
<tr class="even">
<td>skipMeta</td>
<td>No</td>
</tr>
<tr class="odd">
<td>skipData</td>
<td>No</td>
</tr>
<tr class="even">
<td>hierarchyMeta</td>
<td>No</td>
</tr>
<tr class="odd">
<td>showHierarchy</td>
<td>No</td>
</tr>
<tr class="even">
<td>displayProperty</td>
<td>No</td>
</tr>
<tr class="odd">
<td>outputIdScheme</td>
<td>No</td>
</tr>
<tr class="even">
<td>outputOrgUnitIdScheme</td>
<td>No</td>
</tr>
<tr class="odd">
<td>outputDataElementIdScheme</td>
<td>No</td>
</tr>
<tr class="even">
<td>inputIdScheme</td>
<td>No</td>
</tr>
<tr class="odd">
<td>userOrgUnit</td>
<td>No</td>
</tr>
</tbody>
</table>

The *dimension* query parameter defines which dimensions (table columns)
should be included in the response. It can optionally be constrained
with items. The *filter* query parameter defines which items and
dimensions (table columns) should be used as a filter for the response.

For the organisation unit dimension, the response will contain data
associated with the organisation unit and all organisation units in the
sub-hierarchy (children in the tree). This is different compared to the
regular analytics resource, where only the explicitly selected
organisation units are included.

To retrieve a response with specific data elements, specific periods,
specific organisation units and all data for two custom dimensions you
can issue a request like this:

    /api/analytics/rawData.json?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU;Jtf34kNZhzP
      &dimension=J5jldMd8OHv&dimension=Bpx0589u8y0
      &dimension=pe:LAST_12_MONTHS
      &dimension=ou:O6uvpzGd5pu;fdc6uOvgoji

The *startDate* and *endDate* parameters allow for fetching data linked
to any period between those dates. This avoids the need for defining all
periods explicitly in the
    request:

    /api/analytics/rawData.json?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU;Jtf34kNZhzP
      &dimension=J5jldMd8OHv&dimension=Bpx0589u8y0
      &startDate=2015-01-01&endDate=2015-12-31
      &dimension=ou:O6uvpzGd5pu;fdc6uOvgoji

The *filter* parameter can be used to filter a response without
including that dimension as part of the response, this time in CSV
format:

    /api/analytics/rawData.csv?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU;Jtf34kNZhzP
      &filter=J5jldMd8OHv:uYxK4wmcPqA;tDZVQ1WtwpA
      &startDate=2015-01-01&endDate=2015-12-31
      &dimension=ou:O6uvpzGd5pu

The *outputIdScheme* parameter is useful if you want human readable data
responses as it can be set to *NAME* like this:

    /api/analytics/rawData.csv?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &filter=J5jldMd8OHv:uYxK4wmcPqA;tDZVQ1WtwpA
      &startDate=2017-01-01&endDate=2017-12-31
      &dimension=ou:O6uvpzGd5pu
      &outputIdScheme=NAME

The response from the *rawData* resource will look identical to the
regular analytics resource; the difference is that the response contains
raw, non-aggregated data, suitable for further aggregation by
third-party systems.

### Debugging { #webapi_analytics_debugging } 

When debugging analytics requests it can be useful to examine the data
value source of the aggregated analytics response. The
*analytics/debug/sql* resource will provide an SQL statement that
returns the relevant content of the datavalue table. You can produce
this SQL by doing a GET request with content type "text/html" or
"text/plain" like below. The dimension and filter syntax are identical to
regular analytics queries:

    /api/analytics/debug/sql?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &filter=pe:2016Q1;2016Q2&filter=ou:O6uvpzGd5pu

## Event analytics { #webapi_event_analytics } 

The event analytics API lets you access aggregated event data and query
*events* captured in DHIS2. This resource lets you retrieve events based
on a program and optionally a program stage, and lets you retrieve and
filter events on any event dimensions.

    /api/33/analytics/events

### Dimensions and items { #webapi_event_analytics_dimensions_items } 

Event dimensions include data elements, attributes, organisation units
and periods. The aggregated event analytics resource will return
aggregated information such as counts or averages. The query analytics
resource will simply return events matching a set of criteria and does
not perform any aggregation. You can specify dimension items in the form
of options from option sets and legends from legend sets for data
elements and attributes which are associated with such. The event
dimensions are listed in the table below.

<table>
<caption>Event dimensions</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 11%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr class="header">
<th>Dimension</th>
<th>Dimension id</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Data elements</td>
<td>&lt;id&gt;</td>
<td>Data element identifiers</td>
</tr>
<tr class="even">
<td>Attributes</td>
<td>&lt;id&gt;</td>
<td>Attribute identifiers</td>
</tr>
<tr class="odd">
<td>Periods</td>
<td>pe</td>
<td>ISO periods and relative periods, see &quot;date and period format&quot;</td>
</tr>
<tr class="even">
<td>Organisation units</td>
<td>ou</td>
<td>Organisation unit identifiers and keywords USER_ORGUNIT, USER_ORGUNIT_CHILDREN, USER_ORGUNIT_GRANDCHILDREN, LEVEL-&lt;level&gt; and OU_GROUP-&lt;group-id&gt;</td>
</tr>
<tr class="odd">
<td>Organisation unit group sets</td>
<td>&lt;org unit group set id&gt;</td>
<td>Organisation unit group set identifiers</td>
</tr>
<tr class="even">
<td>Categories</td>
<td>&lt;category id&gt;</td>
<td>Category identifiers (program attribute categories only)</td>
</tr>
</tbody>
</table>

### Request query parameters { #webapi_event_analytics_request_query_parameters } 

The analytics event API lets you specify a range of query parameters.

<table>
<caption>Query parameters for both event query and aggregate analytics</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 11%" />
<col style="width: 48%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options (default first)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>program</td>
<td>Yes</td>
<td>Program identifier.</td>
<td>Any program identifier</td>
</tr>
<tr class="even">
<td>stage</td>
<td>No</td>
<td>Program stage identifier.</td>
<td>Any program stage identifier</td>
</tr>
<tr class="odd">
<td>startDate</td>
<td>Yes</td>
<td>Start date for events.</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>Yes</td>
<td>End date for events.</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr class="odd">
<td>dimension</td>
<td>Yes</td>
<td>Dimension identifier including data elements, attributes, program indicators, periods, organisation units and organisation unit group sets. Parameter can be repeated any number of times. Item filters can be applied to a dimension on the format &lt;item-id&gt;:&lt;operator&gt;:&lt;filter&gt;. Filter values are case-insensitive.</td>
<td>Operators can be EQ | GT | GE | LT | LE | NE | LIKE | IN</td>
</tr>
<tr class="even">
<td>filter</td>
<td>No</td>
<td>Dimension identifier including data elements, attributes, periods, organisation units and organisation unit group sets. Parameter can be repeated any number of times. Item filters can be applied to a dimension on the format &lt;item-id&gt;:&lt;operator&gt;:&lt;filter&gt;. Filter values are case-insensitive.</td>
<td></td>
</tr>
<tr class="odd">
<td>hierarchyMeta</td>
<td>No</td>
<td>Include names of organisation unit ancestors and hierarchy paths of organisation units in the metadata.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>eventStatus</td>
<td>No</td>
<td>Specify status of events to include.</td>
<td>ACTIVE | COMPLETED | SCHEDULE | OVERDUE | SKIPPED</td>
</tr>
<tr class="odd">
<td>programStatus</td>
<td>No</td>
<td>Specify enrollment status of events to include.</td>
<td>ACTIVE | COMPLETED | CANCELLED</td>
</tr>
<tr class="even">
<td>relativePeriodDate</td>
<td>string</td>
<td>No</td>
<td>Date identifier e.g: &quot;2016-01-01&quot;. Overrides the start date of the relative period</td>
</tr>
<tr class="odd">
<td>columns</td>
<td>No</td>
<td>Dimensions to use as columns for table layout.</td>
<td>Any dimension (must be query dimension)</td>
</tr>
<tr class="even">
<td>rows</td>
<td>No</td>
<td>Dimensions to use as rows for table layout.</td>
<td>Any dimension (must be query dimension)</td>
</tr>
</tbody>
</table>

<table>
<caption>Query parameters for event query analytics only</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 11%" />
<col style="width: 48%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ouMode</td>
<td>No</td>
<td>The mode of selecting organisation units. Default is DESCENDANTS, meaning all sub units in the hierarchy. CHILDREN refers to immediate children in the hierarchy; SELECTED refers to the selected organisation units only.</td>
<td>DESCENDANTS, CHILDREN, SELECTED</td>
</tr>
<tr class="even">
<td>asc</td>
<td>No</td>
<td>Dimensions to be sorted ascending, can reference event date, org unit name and code and any item identifiers.</td>
<td>EVENTDATE | OUNAME | OUCODE | item identifier</td>
</tr>
<tr class="odd">
<td>desc</td>
<td>No</td>
<td>Dimensions to be sorted descending, can reference event date, org unit name and code and any item identifiers.</td>
<td>EVENTDATE | OUNAME | OUCODE | item identifier</td>
</tr>
<tr class="even">
<td>coordinatesOnly</td>
<td>No</td>
<td>Whether to only return events which have coordinates.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>dataIdScheme</td>
<td>No</td>
<td>Id scheme to be used for data, more specifically data elements and attributes which have an option set or legend set, e.g. return the name of the option instead of the code, or the name of the legend instead of the legend ID, in the data response.</td>
<td>NAME | CODE | UID</td>
</tr>
<tr class="even">
<td>page</td>
<td>No</td>
<td>The page number. Default page is 1.</td>
<td>Numeric positive value</td>
</tr>
<tr class="odd">
<td>pageSize</td>
<td>No</td>
<td>The page size. Default size is 50 items per page.</td>
<td>Numeric zero or positive value</td>
</tr>
</tbody>
</table>

<table>
<caption>Query parameters for aggregate event analytics only</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 11%" />
<col style="width: 48%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>value</td>
<td>No</td>
<td>Value dimension identifier. Can be a data element or an attribute which must be of numeric value type.</td>
<td>Data element or attribute identifier</td>
</tr>
<tr class="even">
<td>aggregationType</td>
<td>No</td>
<td>Aggregation type for the value dimension. Default is AVERAGE.</td>
<td>SUM | AVERAGE | AVERAGE_SUM_ORG_UNIT | LAST | LAST_AVERAGE_ORG_UNIT | COUNT | STDDEV | VARIANCE | MIN | MAX</td>
</tr>
<tr class="odd">
<td>showHierarchy</td>
<td>No</td>
<td>Display full org unit hierarchy path together with org unit name.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>displayProperty</td>
<td>No</td>
<td>Property to display for metadata.</td>
<td>NAME | SHORTNAME</td>
</tr>
<tr class="odd">
<td>sortOrder</td>
<td>No</td>
<td>Sort the records on the value column in ascending or descending order.</td>
<td>ASC | DESC</td>
</tr>
<tr class="even">
<td>limit</td>
<td>No</td>
<td>The maximum number of records to return. Cannot be larger than 10 000.</td>
<td>Numeric positive value</td>
</tr>
<tr class="odd">
<td>outputType</td>
<td>No</td>
<td>Specify output type for analytical data which can be events, enrollments or tracked entity instances. The two last options apply to programs with registration only.</td>
<td>EVENT | ENROLLMENT | TRACKED_ENTITY_INSTANCE</td>
</tr>
<tr class="even">
<td>collapseDataDimensions</td>
<td>No</td>
<td>Collapse all data dimensions (data elements and attributes) into a single dimension in the response.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>skipMeta</td>
<td>No</td>
<td>Exclude the meta data part of the response (improves performance).</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>skipData</td>
<td>No</td>
<td>Exclude the data part of the response.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>skipRounding</td>
<td>No</td>
<td>Skip rounding of aggregate data values.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>aggregateData</td>
<td>No</td>
<td>Produce aggregate values for the data dimensions (as opposed to dimension items).</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>timeField</td>
<td>No</td>
<td>The time field to base event aggregation on. Applies to event data items only. Can be a predefined option or the ID of an attribute or data element having a time-based value type.</td>
<td>EVENT_DATE | ENROLLMENT_DATE | INCIDENT_DATE | DUE_DATE | COMPLETED_DATE | &lt;Attribute ID&gt; | &lt;Data element ID&gt;</td>
</tr>
<tr>
<td>orgUnitField</td>
<td>No</td>
<td>The organisation unit field to base event aggregation on. Applies to event data items only. Can be the ID of an attribute or data element with the Organisation unit value type. The default option is specified as omitting the query parameter.
<td>&lt;Attribute ID&gt; | &lt;Data element ID&gt;</td>
</tr>
</tbody>
</table>

<table>
<caption>Query parameters for cluster event analytics only</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 11%" />
<col style="width: 49%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>clusterSize</td>
<td>Yes</td>
<td>Size of clusters in meters.</td>
<td>Numeric positive value</td>
</tr>
<tr class="even">
<td>coordinateField</td>
<td>No</td>
<td>Field to base geospatial event analytics on. Default is event. Can be set to identifiers of attributes and data elements of value type coordinate.</td>
<td>EVENT | &lt;attribute-id&gt; | &lt;dataelement-id&gt;</td>
</tr>
<tr class="odd">
<td>bbox</td>
<td>Yes</td>
<td>Bounding box / area of events to include in the response on the format &quot;min longitude, min latitude, max longitude , max latitude&quot;.</td>
<td>String</td>
</tr>
<tr class="even">
<td>includeClusterPoints</td>
<td>No</td>
<td>Include information about underlying points for each cluster, be careful if cluster represent a very high number of points.</td>
<td>false | true</td>
</tr>
</tbody>
</table>

### Event query analytics { #webapi_event_query_analytics } 

The *analytics/events/query* resource lets you query for captured
events. This resource does not perform any aggregation, rather it lets
you query and filter for information about events.

    /api/33/analytics/events/query

You can specify any number of dimensions and any number of filters in a
query. Dimension item identifiers can refer to any of data elements,
person attributes, person identifiers, fixed and relative periods and
organisation units. Dimensions can optionally have a query operator and
a filter. Event queries should be on the format described
    below.

    /api/33/analytics/events/query/<program-id>?startDate=yyyy-MM-dd&endDate=yyyy-MM-dd
      &dimension=ou:<ou-id>;<ou-id>&dimension=<item-id>&dimension=<item-id>:<operator>:<filter>

For example, to retrieve events from the "Inpatient morbidity and
mortality" program between January and October 2016, where the "Gender"
and "Age" data elements are included and the "Age" dimension is filtered
on "18", you can use the following
    query:

    /api/33/analytics/events/query/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:O6uvpzGd5pu;fdc6uOvgoji&dimension=oZg33kd9taw&dimension=qrur9Dvnyt5:EQ:18

To retrieve events for the "Birth" program stage of the "Child
programme" program between March and December 2016, where the "Weight"
data element, filtered for values larger than
    2000:

    /api/33/analytics/events/query/IpHINAT79UW?stage=A03MvHHogjR&startDate=2016-03-01
      &endDate=2016-12-31&dimension=ou:O6uvpzGd5pu&dimension=UXz7xuGCEhU:GT:2000

Sorting can be applied to the query for the event date of the event and
any dimensions. To sort descending on the event date and ascending on
the "Age" data element dimension you can
    use:

    /api/33/analytics/events/query/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:O6uvpzGd5pu&dimension=qrur9Dvnyt5&desc=EVENTDATE&asc=qrur9Dvnyt5

Paging can be applied to the query by specifying the page number and the
page size parameters. If page number is specified but page size is not,
a page size of 50 will be used. If page size is specified but page
number is not, a page number of 1 will be used. To get the third page of
the response with a page size of 20 you can use a query like
    this:

    /api/33/analytics/events/query/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:O6uvpzGd5pu&dimension=qrur9Dvnyt5&page=3&pageSize=20

#### Filtering

Filters can be applied to data elements, person attributes and person
identifiers. The filtering is done through the query parameter value on
the following format:

    &dimension=<item-id>:<operator>:<filter-value>

As an example, you can filter the "Weight" data element for values
greater than 2000 and lower than 4000 like this:

    &dimension=UXz7xuGCEhU:GT:2000&dimension=UXz7xuGCEhU:LT:4000

You can filter the "Age" data element for multiple, specific ages using
the IN operator like this:

    &dimension=qrur9Dvnyt5:IN:18;19;20

You can specify multiple filters for a given item by repeating the
operator and filter components, all separated with semi-colons:

    &dimension=qrur9Dvnyt5:GT:5:LT:15

The available operators are listed below.

<table>
<caption>Filter operators</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr class="header">
<th>Operator</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>EQ</td>
<td>Equal to</td>
</tr>
<tr class="even">
<td>GT</td>
<td>Greater than</td>
</tr>
<tr class="odd">
<td>GE</td>
<td>Greater than or equal to</td>
</tr>
<tr class="even">
<td>LT</td>
<td>Less than</td>
</tr>
<tr class="odd">
<td>LE</td>
<td>Less than or equal to</td>
</tr>
<tr class="even">
<td>NE</td>
<td>Not equal to</td>
</tr>
<tr class="odd">
<td>LIKE</td>
<td>Like (free text match)</td>
</tr>
<tr class="even">
<td>IN</td>
<td>Equal to one of multiple values separated by &quot;;&quot;</td>
</tr>
</tbody>
</table>

#### Response formats

The default response representation format is JSON. The requests must be
using the HTTP *GET* method. The following response formats are
supported.

  - json (application/json)

  - jsonp (application/javascript)

  - xls (application/vnd.ms-excel)

As an example, to get a response in Excel format you can use a file
extension in the request URL like this:

    /api/33/analytics/events/query/eBAyeGv0exc.xls?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:O6uvpzGd5pu&dimension=oZg33kd9taw&dimension=qrur9Dvnyt5

You can set the hierarchyMeta query parameter to true in order to
include names of all ancestor organisation units in the meta-section of
the response:

    /api/33/analytics/events/query/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:YuQRtpLP10I&dimension=qrur9Dvnyt5:EQ:50&hierarchyMeta=true

The default response JSON format will look similar to this:

```json
{
  "headers": [
    {
      "name": "psi",
      "column": "Event",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "ps",
      "column": "Program stage",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "eventdate",
      "column": "Event date",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "coordinates",
      "column": "Coordinates",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "ouname",
      "column": "Organisation unit name",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "oucode",
      "column": "Organisation unit code",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "ou",
      "column": "Organisation unit",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "oZg33kd9taw",
      "column": "Gender",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "qrur9Dvnyt5",
      "column": "Age",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    }
  ],
  "metaData": {
    "names": {
      "qrur9Dvnyt5": "Age",
      "eBAyeGv0exc": "Inpatient morbidity and mortality",
      "ImspTQPwCqd": "Sierra Leone",
      "O6uvpzGd5pu": "Bo",
      "YuQRtpLP10I": "Badjia",
      "oZg33kd9taw": "Gender"
    },
    "ouHierarchy": {
      "YuQRtpLP10I": "/ImspTQPwCqd/O6uvpzGd5pu"
    }
  },
  "width": 8,
  "height": 4,
  "rows": [
    [
      "yx9IDINf82o",
      "Zj7UnCAulEk",
      "2016-08-05",
      "[5.12, 1.23]",
      "Ngelehun",
      "OU_559",
      "YuQRtpLP10I",
      "Female",
      "50"
    ],
    [
      "IPNa7AsCyFt",
      "Zj7UnCAulEk",
      "2016-06-12",
      "[5.22, 1.43]",
      "Ngelehun",
      "OU_559",
      "YuQRtpLP10I",
      "Female",
      "50"
    ],
    [
      "ZY9JL9dkhD2",
      "Zj7UnCAulEk",
      "2016-06-15",
      "[5.42, 1.33]",
      "Ngelehun",
      "OU_559",
      "YuQRtpLP10I",
      "Female",
      "50"
    ],
    [
      "MYvh4WAUdWt",
      "Zj7UnCAulEk",
      "2016-06-16",
      "[5.32, 1.53]",
      "Ngelehun",
      "OU_559",
      "YuQRtpLP10I",
      "Female",
      "50"
    ]
  ]
}
```

The *headers* section of the response describes the content of the query
result. The event unique identifier, the program stage identifier, the
event date, the organisation unit name, the organisation unit code and
the organisation unit identifier appear as the first six dimensions in
the response and will always be present. Next comes the data elements,
person attributes and person identifiers which were specified as
dimensions in the request, in this case, the "Gender" and "Age" data
element dimensions. The header section contains the identifier of the
dimension item in the "name" property and a readable dimension
description in the "column" property.

The *metaData* section, *ou* object contains the identifiers of all
organisation units present in the response mapped to a string
representing the hierarchy. This hierarchy string lists the identifiers
of the ancestors (parents) of the organisation unit starting from the
root. The *names* object contains the identifiers of all items in the
response mapped to their names.

The *rows* section contains the events produced by the query. Each row
represents exactly one event.

In order to have the event analytics resource generate the data in the
shape of a ready-made table, you can provide *rows* and *columns*
parameters with requested dimension identifiers separated by semi-colons
as values to indicate which ones to use as table columns and rows.
Instead of generating a plain, normalized data source, the event
analytics resource will now generate the data in table layout. The
column and rows dimensions must be present as a data dimension in the
query (not a filter). Such a request can look like this:

    /api/33/analytics.html+css?dimension=dx:cYeuwXTCPkU;fbfJHSPpUQD&dimension=pe:WEEKS_THIS_YEAR
      &filter=ou:ImspTQPwCqd&displayProperty=SHORTNAME&columns=dx&rows=pe

### Event aggregate analytics { #webapi_event_aggregate_analytics } 

The `/analytics/events/aggregate` resource lets you retrieve *aggregated
numbers* of events captured in DHIS2. This resource lets you retrieve
aggregate data based on a program and optionally a program stage, and
lets you filter on any event dimension.

    /api/33/analytics/events/aggregate

The events aggregate resource does not return the event information
itself, rather the aggregate numbers of events matching the request
query. Event dimensions include data elements, person attributes, person
identifiers, periods and organisation units. Aggregate event queries
should be on the format described below.

    /api/33/analytics/events/aggregate/<program-id>?startDate=yyyy-MM-dd&endDate=yyyy-MM-dd
      &dimension=ou:<ou-id>;<ou-id>&dimension=<item-id>&dimension=<item-id>:<operator>:<filter>

For example, to retrieve aggregate numbers for events from the
"Inpatient morbidity and mortality" program between January and October
2016, where the "Gender" and "Age" data elements are included, the "Age"
dimension item is filtered on "18" and the "Gender" item is filtered on
"Female", you can use the following query:

    /api/33/analytics/events/aggregate/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:O6uvpzGd5pu&dimension=oZg33kd9taw:EQ:Female&dimension=qrur9Dvnyt5:GT:50

To retrieve data for fixed and relative periods instead of start and end
date, in this case, May 2016 and last 12 months, and the organisation
unit associated with the current user, you can use the following query:

    /api/33/analytics/events/aggregate/eBAyeGv0exc?dimension=pe:201605;LAST_12_MONTHS
      &dimension=ou:USER_ORGUNIT;fdc6uOvgo7ji&dimension=oZg33kd9taw

In order to specify "Female" as a filter for "Gender" for the data
response, meaning "Gender" will not be part of the response but will
filter the aggregate numbers in it, you can use the following syntax:

    /api/33/analytics/events/aggregate/eBAyeGv0exc?dimension=pe:2016;
      &dimension=ou:O6uvpzGd5pu&filter=oZg33kd9taw:EQ:Female

To specify the "Bo" organisation unit and the period "2016" as filters,
and the "Mode of discharge" and Gender" as dimensions, where "Gender" is
filtered on the "Male" item, you can use a query like this:

    /api/33/analytics/events/aggregate/eBAyeGv0exc?filter=pe:2016&filter=ou:O6uvpzGd5pu
      &dimension=fWIAEtYVEGk&dimension=oZg33kd9taw:EQ:Male

To create a "Top 3 report" for _Mode of discharge_ you can use the limit
and sortOrder query parameters similar to this:

    /api/33/analytics/events/aggregate/eBAyeGv0exc?filter=pe:2016&filter=ou:O6uvpzGd5pu
      &dimension=fWIAEtYVEGk&limit=3&sortOrder=DESC

To specify a value dimension with a corresponding aggregation type you
can use the value and aggregationType query parameters. Specifying a
value dimension will make the analytics engine return aggregate values
for the values of that dimension in the response as opposed to counts of
events.

    /api/33/analytics/events/aggregate/eBAyeGv0exc.json?stage=Zj7UnCAulEk
      &dimension=ou:ImspTQPwCqd&dimension=pe:LAST_12_MONTHS&dimension=fWIAEtYVEGk
      &value=qrur9Dvnyt5&aggregationType=AVERAGE

To base event analytics aggregation on a specific data element or attribute
of value type date or date time you can use the `timeField` parameter:

    /api/33/analytics/events/aggregate/IpHINAT79UW.json?dimension=ou:ImspTQPwCqd
      &dimension=pe:LAST_12_MONTHS&dimension=cejWyOfXge6&stage=A03MvHHogjR
      &timeField=ENROLLMENT_DATE

To base event analytics aggregation on a specific data element or attribute
of value type organisation unit you can use the `orgUnitField` parameter:

    /api/33/analytics/events/aggregate/eBAyeGv0exc.json?dimension=ou:ImspTQPwCqd
      &dimension=pe:THIS_YEAR&dimension=oZg33kd9taw&stage=Zj7UnCAulEk
      &orgUnitField=S33cRBsnXPo

#### Ranges / legend sets

For aggregate queries, you can specify a range / legend set for numeric
data element and attribute dimensions. The purpose is to group the
numeric values into ranges. As an example, instead of generating data
for an "Age" data element for distinct years, you can group the
information into age groups. To achieve this, the data element or
attribute must be associated with the legend set. The format is
described below:

    ?dimension=<item-id>-<legend-set-id>

An example looks like this:

    /api/33/analytics/events/aggregate/eBAyeGv0exc.json?stage=Zj7UnCAulEk
      &dimension=qrur9Dvnyt5-Yf6UHoPkdS6&dimension=ou:ImspTQPwCqd&dimension=pe:LAST_MONTH

#### Response formats

The default response representation format is JSON. The requests must be
using the HTTP *GET* method. The response will look similar to this:

```json
{
  "headers": [
    {
      "name": "oZg33kd9taw",
      "column": "Gender",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "qrur9Dvnyt5",
      "column": "Age",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "pe",
      "column": "Period",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "ou",
      "column": "Organisation unit",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "value",
      "column": "Value",
      "type": "java.lang.String",
      "meta": false
    }
  ],
  "metaData": {
    "names": {
      "eBAyeGv0exc": "Inpatient morbidity and mortality"
    }
  },
  "width": 5,
  "height": 39,
  "rows": [
    [
      "Female",
      "95",
      "201605",
      "O6uvpzGd5pu",
      "2"
    ],
    [
      "Female",
      "63",
      "201605",
      "O6uvpzGd5pu",
      "2"
    ],
    [
      "Female",
      "67",
      "201605",
      "O6uvpzGd5pu",
      "1"
    ],
    [
      "Female",
      "71",
      "201605",
      "O6uvpzGd5pu",
      "1"
    ],
    [
      "Female",
      "75",
      "201605",
      "O6uvpzGd5pu",
      "14"
    ],
    [
      "Female",
      "73",
      "201605",
      "O6uvpzGd5pu",
      "5"
    ]
  ]
}
```

Note that the max limit for rows to return in a single response is 10 000.
If the query produces more than the max limit, a *409 Conflict* status code
will be returned.

### Event clustering analytics { #webapi_event_clustering_analytics } 

The *analytics/events/cluster* resource provides clustered geospatial
event data. A request looks like this:

    /api/33/analytics/events/cluster/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:LEVEL-2&clusterSize=100000
      &bbox=-13.2682125,7.3721619,-10.4261178,9.904012&includeClusterPoints=false

The cluster response provides the count of underlying points, the center
point and extent of each cluster. If the `includeClusterPoints` query
parameter is set to true, a comma-separated string with the identifiers
of the underlying events is included. A sample response looks like this:

```json
{
  "headers": [
    {
      "name": "count",
      "column": "Count",
      "type": "java.lang.Long",
      "meta": false
    },
    {
      "name": "center",
      "column": "Center",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "extent",
      "column": "Extent",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "points",
      "column": "Points",
      "type": "java.lang.String",
      "meta": false
    }
  ],
  "width": 3,
  "height": 4,
  "rows": [
    [
      "3",
      "POINT(-13.15818 8.47567)",
      "BOX(-13.26821 8.4St7215,-13.08711 8.47807)",
      ""
    ],
    [
      "9",
      "POINT(-13.11184 8.66424)",
      "BOX(-13.24982 8.51961,-13.05816 8.87696)",
      ""
    ],
    [
      "1",
      "POINT(-12.46144 7.50597)",
      "BOX(-12.46144 7.50597,-12.46144 7.50597)",
      ""
    ],
    [
      "7",
      "POINT(-12.47964 8.21533)",
      "BOX(-12.91769 7.66775,-12.21011 8.49713)",
      ""
    ]
  ]
}
```

### Event count and extent analytics { #webapi_event_count_extent_analytics } 

The *analytics/events/count* resource is suitable for geometry-related
requests for retrieving the count and extent (bounding box) of events
for a specific query. The query syntax is equal to the *events/query*
resource. A request looks like
    this:

    /api/33/analytics/events/count/eBAyeGv0exc?startDate=2016-01-01
      &endDate=2016-10-31&dimension=ou:O6uvpzGd5pu

The response will provide the count and extent in JSON format:

```json
{
  extent: "BOX(-13.2682125910096 7.38679562779441,-10.4261178860988 9.90401290212795)",
  count: 59
}
```

### Constraints and validation { #webapi_event_analytics_constraints } 

There are several constraints to the input parameters you can provide to the
event analytics resource. If any of the constraints are violated, the API will
return a *409 Conflict* response and a response message looking similar to this:

```json
{
  "httpStatus": "Conflict",
  "httpStatusCode": 409,
  "status": "ERROR",
  "message": "At least one organisation unit must be specified",
  "errorCode": "E7200"
}
```

The possible validation errors for the event analytics API are described
in the table below.

| Error code | Message |
| ---------- | ------- |
| E7200      | At least one organisation unit must be specified |
| E7201      | Dimensions cannot be specified more than once |
| E7202      | Query items cannot be specified more than once |
| E7203      | Value dimension cannot also be specified as an item or item filter |
| E7204      | Value dimension or aggregate data must be specified when aggregation type is specified |
| E7205      | Start and end date or at least one period must be specified |
| E7206      | Start date is after end date |
| E7207      | Page number must be a positive number |
| E7208      | Page size must be zero or a positive number |
| E7209      | Limit is larger than max limit |
| E7210      | Time field is invalid |
| E7211      | Org unit field is invalid |
| E7212      | Cluster size must be a positive number |
| E7213      | Bbox is invalid, must be on format: 'min-lng,min-lat,max-lng,max-lat' |
| E7214      | Cluster field must be specified when bbox or cluster size are specified |
| E7215      | Query item cannot specify both legend set and option set |
| E7216      | Query item must be aggregateable when used in aggregate query |
| E7217      | User is not allowed to view event analytics data |
| E7218      | Spatial database support is not enabled |
| E7219      | Data element must be of value type coordinate in order to be used as coordinate field |
| E7220      | Attribute must be of value type coordinate to in order to be used as coordinate field |
| E7221      | Coordinate field is invalid |
| E7222      | Query item or filter is invalid |
| E7223      | Value does not refer to a data element or attribute which are numeric and part of the program |
| E7224      | Item identifier does not reference any data element, attribute or indicator part of the program |
| E7225      | Program stage is mandatory for data element dimensions in enrollment analytics queries |
| E7226      | Dimension is not a valid query item |
| E7227      | Relationship entity type not supported |

## Enrollment analytics { #webapi_enrollment_analytics } 

The enrollment analytics API lets you access aggregated event data and query *enrollments with their event data* captured in DHIS2. This resource lets you retrieve data for a program based on program stages and data elements - in addition to tracked entity attributes. When querying event data for a specific programstages within each enrollment, the data element values for each program stage will be returned as one row in the response from the api. If querying a data element in a program stage that is repeatable, the newest data element value will be used for that data element in the api response.

### Dimensions and items { #webapi_enrollment_analytics_dimensions } 

Enrollment dimensions include data elements, attributes, organisation units and periods. The query analytics resource will simply return enrollments matching a set of criteria and does not perform any aggregation.

<table>
<caption>Enrollment dimensions</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 11%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr class="header">
<th>Dimension</th>
<th>Dimension id</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>Data elements in program stages</td>
<td>&lt;program stage id&gt;.&lt;data element id&gt;</td>
<td>Data element identifiers must include the program stage when querying data for enrollments.

    dimension=edqlbukwRfQ.vANAXwtLwcT

</td>
</tr>
<tr>
<td>Attributes</td>
<td>&lt;id&gt;</td>
<td>Attribute identifiers</td>
</tr>
<tr>
<td>Periods</td>
<td>pe</td>
<td>ISO periods and relative periods, see &quot;date and period format&quot;</td>
</tr>
<tr>
<td>Organisation units</td>
<td>ou</td>
<td>Organisation unit identifiers and keywords USER_ORGUNIT, USER_ORGUNIT_CHILDREN, USER_ORGUNIT_GRANDCHILDREN, LEVEL-&lt;level&gt; and OU_GROUP-&lt;group-id&gt;</td>
</tr>
</tbody>
</table>

### Enrollment query analytics { #webapi_enrollment_query_analytics } 

The *analytics/enrollments/query* resource lets you query for captured enrollments. This resource does not perform any aggregation, rather it lets you query and filter for information about enrollments.

    /api/33/analytics/enrollments/query

You can specify any number of dimensions and any number of filters in a query. Dimension item identifiers can refer to any of the data elements in program stages, tracked entity attributes, fixed and relative periods and organisation units. Dimensions can optionally have a query operator and a filter. Enrollment queries should be on the format described below.

    /api/33/analytics/enrollments/query/<program-id>?startDate=yyyy-MM-dd&endDate=yyyy-MM-dd
      &dimension=ou:<ou-id>;<ou-id>&dimension=<item-id>&dimension=<item-id>:<operator>:<filter>

For example, to retrieve enrollments in the from the "Antenatal care" program from January 2019, where the "First name" is picked up from attributes, "Chronic conditions" and "Smoking" data elements are included from the first program stage, and "Hemoglobin value" from the following program stage, and only women that have "Cronic conditions" would be included, you can use the following query:

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.json?dimension=ou:ImspTQPwCqd
      &dimension=w75KJ2mc4zz&dimension=WZbXY0S00lP.de0FEHSIoxh:eq:1&dimension=w75KJ2mc4zz
      &dimension=WZbXY0S00lP.sWoqcoByYmD&dimension=edqlbukwRfQ.vANAXwtLwcT
      &startDate=2019-01-01&endDate=2019-01-31

To retrieve enrollments in the from the "Antenatal care" program from last month (relative to the point in time the query is executed), where the "Chronic conditions" and "Smoking" data elements are included from the first program stage, and "Hemoglobin value" from the followup program stage, only including smoking women with hemoglobin less than 20:

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.json?dimension=ou:ImspTQPwCqd
      &dimension=WZbXY0S00lP.de0FEHSIoxh&dimension=w75KJ2mc4zz
      &dimension=WZbXY0S00lP.sWoqcoByYmD:eq:1&dimension=edqlbukwRfQ.vANAXwtLwcT:lt:20
      &dimension=pe:LAST_MONTH

Sorting can be applied to the query for the enrollment and incident dates of the enrollment:

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.xls?dimension=ou:ImspTQPwCqd
      &columns=w75KJ2mc4zz&dimension=WZbXY0S00lP.sWoqcoByYmD&dimension=pe:LAST_MONTH
      &stage=WZbXY0S00lP&pageSize=10&page=1&asc=ENROLLMENTDATE&ouMode=DESCENDANTS

Paging can be applied to the query by specifying the page number and the page size parameters. If page number is specified but page size is not, a page size of 50 will be used. If page size is specified but page number is not, a page number of 1 will be used. To get the second page of the response with a page size of 10 you can use a query like this:

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.json?dimension=ou:ImspTQPwCqd
      &dimension=WZbXY0S00lP.de0FEHSIoxh&dimension=w75KJ2mc4zz&dimension=pe:LAST_MONTH
      &dimension=WZbXY0S00lP.sWoqcoByYmD&pageSize=10&page=2

#### Filtering

Filters can be applied to data elements, person attributes and person identifiers. The filtering is done through the query parameter value on the following format:

    &dimension=<item-id>:<operator>:<filter-value>

As an example, you can filter the "Weight" data element for values greater than 2000 and lower than 4000 like this:

    &dimension=WZbXY0S00lP.UXz7xuGCEhU:GT:2000&dimension=WZbXY0S00lP.UXz7xuGCEhU:LT:4000

You can filter the "Age" attribute for multiple, specific ages using the IN operator like this:

    &dimension=qrur9Dvnyt5:IN:18;19;20

You can specify multiple filters for a given item by repeating the operator and filter components, all separated with semi-colons:

    &dimension=qrur9Dvnyt5:GT:5:LT:15

The available operators are listed below.

<table>
<caption>Filter operators</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr class="header">
<th>Operator</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>EQ</td>
<td>Equal to</td>
</tr>
<tr>
<td>GT</td>
<td>Greater than</td>
</tr>
<tr>
<td>GE</td>
<td>Greater than or equal to</td>
</tr>
<tr>
<td>LT</td>
<td>Less than</td>
</tr>
<tr>
<td>LE</td>
<td>Less than or equal to</td>
</tr>
<tr>
<td>NE</td>
<td>Not equal to</td>
</tr>
<tr>
<td>LIKE</td>
<td>Like (free text match)</td>
</tr>
<tr>
<td>IN</td>
<td>Equal to one of multiple values separated by &quot;;&quot;</td>
</tr>
</tbody>
</table>

### Request query parameters { #webapi_enrollment_analytics_query_parameters } 

The analytics enrollment query API lets you specify a range of query parameters.

<table>
<caption>Query parameters for enrollment query endpoint</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 11%" />
<col style="width: 48%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options (default first)</th>
</tr>
</thead>
<tbody>
<tr>
<td>program</td>
<td>Yes</td>
<td>Program identifier.</td>
<td>Any program identifier</td>
</tr>
<tr>
<td>startDate</td>
<td>No</td>
<td>Start date for enrollments.</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr>
<td>endDate</td>
<td>No</td>
<td>End date for enrollments.</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr>
<td>dimension</td>
<td>Yes</td>
<td>Dimension identifier including data elements, attributes, program indicators, periods, organisation units and organisation unit group sets. Parameter can be repeated any number of times. Item filters can be applied to a dimension on the format &lt;item-id&gt;:&lt;operator&gt;:&lt;filter&gt;. Filter values are case-insensitive.</td>
<td>Operators can be EQ | GT | GE | LT | LE | NE | LIKE | IN</td>
</tr>
<tr>
<td>filter</td>
<td>No</td>
<td>Dimension identifier including data elements, attributes, periods, organisation units and organisation unit group sets. Parameter can be repeated any number of times. Item filters can be applied to a dimension on the format &lt;item-id&gt;:&lt;operator&gt;:&lt;filter&gt;. Filter values are case-insensitive.</td>
<td></td>
</tr>
<tr>
<td>programStatus</td>
<td>No</td>
<td>Specify enrollment status of enrollments to include.</td>
<td>ACTIVE | COMPLETED | CANCELLED</td>
</tr>
<tr>
<td>relativePeriodDate</td>
<td>string</td>
<td>No</td>
<td>Date identifier e.g: &quot;2016-01-01&quot;. Overrides the start date of the relative period</td>
</tr>
<tr>
<td>ouMode</td>
<td>No</td>
<td>The mode of selecting organisation units. Default is DESCENDANTS, meaning all sub units in the hierarchy. CHILDREN refers to immediate children in the hierarchy; SELECTED refers to the selected organisation units only.</td>
<td>DESCENDANTS, CHILDREN, SELECTED</td>
</tr>
<tr>
<td>asc</td>
<td>No</td>
<td>Dimensions to be sorted ascending, can reference enrollment date, incident date, org unit name and code.</td>
<td> ENROLLMENTDATE | INCIDENTDATE| OUNAME | OUCODE </td>
</tr>
<tr>
<td>desc</td>
<td>No</td>
<td>Dimensions to be sorted descending, can reference enrollment date, incident date, org unit name and code.</td>
<td> ENROLLMENTDATE | INCIDENTDATE| OUNAME | OUCODE </td>
</tr>
<td>hierarchyMeta</td>
<td>No</td>
<td>Include names of organisation unit ancestors and hierarchy paths of organisation units in the metadata.</td>
<td>false | true</td>
</tr>
<tr>
<td>coordinatesOnly</td>
<td>No</td>
<td>Whether to only return enrollments which have coordinates.</td>
<td>false | true</td>
</tr>
<tr>
<td>page</td>
<td>No</td>
<td>The page number. Default page is 1.</td>
<td>Numeric positive value</td>
</tr>
<tr>
<td>pageSize</td>
<td>No</td>
<td>The page size. Default size is 50 items per page.</td>
<td>Numeric zero or positive value</td>
</tr>
</tbody>
</table>

#### Response formats

The default response representation format is JSON. The requests must be using the HTTP *GET* method. The following response formats are supported.

  - json (application/json)
  - xml (application/xml)
  - xls (application/vnd.ms-excel)
  - csv  (application/csv)
  - html (text/html)
  - html+css (text/html)

As an example, to get a response in Excel format you can use a file extension in the request URL like this:

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.xls?dimension=ou:ImspTQPwCqd
      &dimension=WZbXY0S00lP.de0FEHSIoxh&columns=w75KJ2mc4zz
      &dimension=WZbXY0S00lP.sWoqcoByYmD&dimension=pe:LAST_MONTH&stage=WZbXY0S00lP
      &pageSize=10&page=1&asc=ENROLLMENTDATE&ouMode=DESCENDANTS

The default response JSON format will look similar to this:

```json
{
  "headers": [
    {
      "name": "pi",
      "column": "Enrollment",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "tei",
      "column": "Tracked entity instance",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "enrollmentdate",
      "column": "Enrollment date",
      "valueType": "DATE",
      "type": "java.util.Date",
      "hidden": false,
      "meta": true
    },
    {
      "name": "incidentdate",
      "column": "Incident date",
      "valueType": "DATE",
      "type": "java.util.Date",
      "hidden": false,
      "meta": true
    },
    {
      "name": "geometry",
      "column": "Geometry",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "longitude",
      "column": "Longitude",
      "valueType": "NUMBER",
      "type": "java.lang.Double",
      "hidden": false,
      "meta": true
    },
    {
      "name": "latitude",
      "column": "Latitude",
      "valueType": "NUMBER",
      "type": "java.lang.Double",
      "hidden": false,
      "meta": true
    },
    {
      "name": "ouname",
      "column": "Organisation unit name",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "oucode",
      "column": "Organisation unit code",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "ou",
      "column": "Organisation unit",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "de0FEHSIoxh",
      "column": "WHOMCH Chronic conditions",
      "valueType": "BOOLEAN",
      "type": "java.lang.Boolean",
      "hidden": false,
      "meta": true
    },
    {
      "name": "sWoqcoByYmD",
      "column": "WHOMCH Smoking",
      "valueType": "BOOLEAN",
      "type": "java.lang.Boolean",
      "hidden": false,
      "meta": true
    }
  ],
  "metaData": {
    "pager": {
      "page": 2,
      "total": 163,
      "pageSize": 4,
      "pageCount": 41
    },
    "items": {
      "ImspTQPwCqd": {
        "name": "Sierra Leone"
      },
      "PFDfvmGpsR3": {
        "name": "Care at birth"
      },
      "bbKtnxRZKEP": {
        "name": "Postpartum care visit"
      },
      "ou": {
        "name": "Organisation unit"
      },
      "PUZaKR0Jh2k": {
        "name": "Previous deliveries"
      },
      "edqlbukwRfQ": {
        "name": "Antenatal care visit"
      },
      "WZbXY0S00lP": {
        "name": "First antenatal care visit"
      },
      "sWoqcoByYmD": {
        "name": "WHOMCH Smoking"
      },
      "WSGAb5XwJ3Y": {
        "name": "WHO RMNCH Tracker"
      },
      "de0FEHSIoxh": {
        "name": "WHOMCH Chronic conditions"
      }
    },
    "dimensions": {
      "pe": [],
      "ou": [
        "ImspTQPwCqd"
      ],
      "sWoqcoByYmD": [],
      "de0FEHSIoxh": []
    }
  },
  "width": 12,
  "rows": [
    [
      "A0cP533hIQv",
      "to8G9jAprnx",
      "2019-02-02 12:05:00.0",
      "2019-02-02 12:05:00.0",
      "",
      "0.0",
      "0.0",
      "Tonkomba MCHP",
      "OU_193264",
      "xIMxph4NMP1",
      "0",
      "1"
    ],
    [
      "ZqiUn2uXmBi",
      "SJtv0WzoYki",
      "2019-02-02 12:05:00.0",
      "2019-02-02 12:05:00.0",
      "",
      "0.0",
      "0.0",
      "Mawoma MCHP",
      "OU_254973",
      "Srnpwq8jKbp",
      "0",
      "0"
    ],
    [
      "lE747mUAtbz",
      "PGzTv2A1xzn",
      "2019-02-02 12:05:00.0",
      "2019-02-02 12:05:00.0",
      "",
      "0.0",
      "0.0",
      "Kunsho CHP",
      "OU_193254",
      "tdhB1JXYBx2",
      "",
      "0"
    ],
    [
      "nmcqu9QF8ow",
      "pav3tGLjYuq",
      "2019-02-03 12:05:00.0",
      "2019-02-03 12:05:00.0",
      "",
      "0.0",
      "0.0",
      "Korbu MCHP",
      "OU_678893",
      "m73lWmo5BDG",
      "",
      "1"
    ]
  ],
  "height": 4
}
```

The *headers* section of the response describes the content of the query result. The enrollment unique identifier, the tracked entity instance identifier, the enrollment date, the incident date, geometry, latitude, longitude, the organisation unit name and the organisation unit code appear as the first dimensions in the response and will always be present. Next comes the data elements, and tracked entity attributes which were specified as dimensions in the request, in this case, the "WHOMCH Chronic conditions" and "WHOMCH smoking" data element dimensions. The header section contains the identifier of the dimension item in the "name" property and a readable dimension description in the "column" property.

The *metaData* section, *ou* object contains the identifiers of all organisation units present in the response mapped to a string representing the hierarchy. This hierarchy string lists the identifiers of the ancestors (parents) of the organisation unit starting from the root. The *names* object contains the identifiers of all items in the response mapped to their names.

The *rows* section contains the enrollments produced by the query. Each row represents exactly one enrollment.

### Analytics across TEI relationships with program indicators

The non-aggregation enrollment analytics API also supports linking Program Indicators to Relationship Types, in order to show the result of a calculation of a specific Program Indicator applied to the related entities of the listed Tracked Entity Instance.

![](resources/images/enrollments/enrollments-pi-relationship.jpg)

For the Program Indicator/Relationship Type link to work, the `/api/33/analytics/enrollments/query` API requires an additional dimension which must include the chosen Relationship Type UID and the chosen Program Indicator UID:

    /api/33/analytics/enrollments/query/<program-id>
      ?dimension=<relationshiptype-id>.<programindicator-id>

For example, to retrieve a list of enrollments from the "WHO RMNCH Tracker" program for January 2019 and display the count of Malaria Cases linked to that Enrollment by "Malaria case linked to person" type of relationship, you can use the following query

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.json?dimension=mxZDvSZYxlw.nFICjJluo74
      &startDate=2019-01-01&endDate=2019-01-31    

The API supports using program indicators which are not associated to the "main" program (that is the program ID specified after `/query/`).

## Org unit analytics { #webapi_org_unit_analytics } 

The org unit analytics API provides statistics on org units classified by org unit group sets, i.e. counts of org units per org unit group within org unit group sets.

    GET /api/orgUnitAnalytics?ou=<org-unit-id>&ougs=<org-unit-group-set-id>

The API requires at least one organisation unit and at least one organisation unit group set. Multiple org units and group sets can be provided separated by a semicolon.

### Request query parameters

The org unit analytics resource lets you specify a range of query parameters:

<table>
<caption>Org unit analytics query parameters</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 60%" />
<col style="width: 20%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
<th>Required</th>
</tr>
</thead>
<tbody>
<tr>
<td>ou</td>
<td>Org unit identifiers, potentially separated by a semicolon.</td>
<td>Yes</td>
</tr>
<tr>
<td>ougs</td>
<td>Org unit group set identifiers, potentially separated by a semicolon.</td>
<td>Yes</td>
</tr>
<tr>
<td>columns</td>
<td>Org unit group set identifiers, potentially separated by a semicolon. Defines which group sets are rendered as columns in a table layout.</td>
<td>No</td>
</tr>
</tbody>
</table>

The response will contain a column for the parent org unit, columns for each org unit group set part of the request and a column for the count. The statistics include the count of org units which are part of the sub-hierarchy of the org units specified in the request. The response contains a metadata section which specifies the name of each org unit and org unit group part of the response referenced by their identifiers.

The default response is normalized with a single `count` column. The response can be rendered in a table layout by specifying at least one org unit group set using the `columns` query parameter.

### Response formats

The org unit analytics endpoint supports the following representation formats:

- json (application/json)
- csv (application/csv)
- xls (application/vnd.ms-excel)
- pdf (application/pdf)

### Examples

To fetch org unit analytics for an org unit and org unit group set:

    GET /api/orgUnitAnalytics?ou=lc3eMKXaEfw&ougs=J5jldMd8OHv

To fetch org unit analytics data for two org units and two org unit group sets:

    GET /api/orgUnitAnalytics?ou=lc3eMKXaEfw;PMa2VCrupOd&ougs=J5jldMd8OHv;Bpx0589u8y0

To fetch org unit analytics data in table mode with one group set rendered as columns:

    GET /api/orgUnitAnalytics?ou=fdc6uOvgoji;jUb8gELQApl;lc3eMKXaEfw;PMa2VCrupOd
      &ougs=J5jldMd8OHv&columns=J5jldMd8OHv

### Constraints and validation

The possible validation errors specifically for the org unit analytics API are described in the table below. Some errors specified for the aggregate analytics API are also relevant.

| Error code | Message |
| ---------- | ------- |
| E7300      | At least one organisation unit must be specified |
| E7301      | At least one organisation unit group set must be specified |

## Data set report { #webapi_data_set_report } 

Data set reports can be generated through the web api using the
`/dataSetReport` resource. This resource generates reports on data set
and returns the result in the form of an HTML table.

    /api/33/dataSetReport

### Request query parameters

The request supports the following parameters:

<table>
<caption>Data set report query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 50%" />
<col style="width: 17%" />
<col style="width: 17%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Description</th>
<th>Type</th>
<th>Required</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ds</td>
<td>Data set to create the report from.</td>
<td>Data set UID</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>pe</td>
<td>Period to create the report from.</td>
<td>ISO String</td>
<td>Yes</td>
</tr>
<tr class="odd">
<td>ou</td>
<td>Organisation unit to create the report from.</td>
<td>Organisation unit UID</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>filter</td>
<td>Filters to be used as filters for the report. Can be repeated any number of times. Follows the analytics API syntax.</td>
<td>One or more UIDs</td>
<td>No</td>
</tr>
<tr class="odd">
<td>selectedUnitOnly</td>
<td>Whether to use captured data only or aggregated data.</td>
<td>Boolean</td>
<td>No</td>
</tr>
</tbody>
</table>

The data set report resource accepts `GET` requests only. The response content type is `application/json` and returns data in a grid. This endpoint works for all types of data sets, including default, section and custom forms.

An example request to retrieve a report for a data set and org unit for 2018 looks like this:

    GET /api/33/dataSetReport?ds=BfMAe6Itzgt&pe=201810&ou=ImspTQPwCqd&selectedUnitOnly=false

To get a data set report with a filter you can use the `filter` parameter. In this case, the filter is based on an org unit group set and two org unit groups:

    GET /api/33/dataSetReport?ds=BfMAe6Itzgt&pe=201810&ou=ImspTQPwCqd
      &filter=J5jldMd8OHv:RXL3lPSK8oG;tDZVQ1WtwpA

### Response formats

The data set report endpoint supports output in the following formats. You can retrieve a specific endpoint using the file extension or `Accept` HTTP header.

- json (application/json)
- pdf (application/pdf)
- xls (application/vnd.ms-excel)

### Custom forms

A dedicated endpoint is available for data sets with custom HTML forms. This endpoint returns the HTML form content with content type `text/html` with data inserted into it. Note that you can use the general data set report endpoint also for data sets with custom forms; however, that will return the report in JSON format as a grid. This endpoint only works for data sets with custom HTML forms.

    GET /api/33/dataSetReport/custom

The syntax for this endpoint is otherwise equal to the general data set report endpoint. To retrieve a custom HTML data set report you can issue a request like this:

    GET /api/33/dataSetReport/custom?ds=lyLU2wR22tC&pe=201810&ou=ImspTQPwCqd


## Push Analysis { #webapi_push_analysis } 

The push analysis API includes endpoints for previewing a push analysis
report for the logged in user and manually triggering the system to
generate and send push analysis reports, in addition to the normal CRUD
operations. When using the create and update endpoints for push
analysis, the push analysis will be scheduled to run based on the
properties of the push analysis. When deleting or updating a
push analysis to be disabled, the job will also be stopped from running
in the future.

To get an HTML preview of an existing push analysis, you can do a GET
request to the following endpoint:

    /api/33/pushAnalysis/<id>/render

To manually trigger a push analysis job, you can do a POST request to
this endpoint:

    /api/33/pushAnalysis/<id>/run

A push analysis consists of the following properties, where some are
required to automatically run push analysis jobs:

<table>
<caption>Push analysis properties</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
<th>Type</th>
<th>Required</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dashboard</td>
<td>Dashboard on which reports are based</td>
<td>Dashboard UID</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>message</td>
<td>Appears after title in reports</td>
<td>String</td>
<td>No</td>
</tr>
<tr class="odd">
<td>recipientUserGroups</td>
<td>A set of user groups who should receive the reports</td>
<td>One or more user Group UID</td>
<td>No. Scheduled jobs without any recipient will be skipped.</td>
</tr>
<tr class="even">
<td>enabled</td>
<td>Indicated whether this push analysis should be scheduled or not. False by default.</td>
<td>Boolean</td>
<td>Yes. Must be true to be scheduled.</td>
</tr>
<tr class="odd">
<td>schedulingFrequency</td>
<td>The frequency of which reports should be scheduled.</td>
<td>&quot;DAILY&quot;, &quot;WEEKLY&quot;, &quot;MONTHLY&quot;</td>
<td>No. Push analysis without a frequency will not be scheduled</td>
</tr>
<tr class="even">
<td>schedulingDayOfFrequency</td>
<td>The day in the frequency the job should be scheduled.</td>
<td>Integer. Any value when frequency is &quot;DAILY&quot;. 0-7 when frequency is &quot;WEEKLY&quot;. 1-31 when frequency is &quot;MONTHLY&quot;</td>
<td>No. Push analysis without a valid day of frequency for the frequency set will not be scheduled.</td>
</tr>
</tbody>
</table>

## Data usage analytics { #webapi_usage_analytics } 

The usage analytics API lets you access information about how people are
using DHIS2 based on data analysis. When users access favorites, an
event is recorded. The event consists of the user name, the UID of the
favorite, when the event took place, and the type of event. The
different types of events are listed in the table.

    /api/33/dataStatistics

The usage analytics API lets you retrieve aggregated snapshots of usage
analytics based on time intervals. The API captures user views (for
example the number of times a chart or pivot table has been viewed by a
user) and saved analysis favorites (for example favorite charts and
pivot tables). DHIS2 will capture nightly snapshots which are then
aggregated at request.

### Request query parameters { #webapi_usage_analytics_request_query_parameters } 

The usage analytics (data statistics) API supports two operations:

  - *POST:* creates a view event

  - *GET:* retrieves aggregated statistics

### Create view events (POST) { #webapi_usage_analytics_create_view_events } 

The usage analytics API lets you create event views. The
dataStatisticsEventType parameter describes what type of item was
viewed. The favorite parameter indicates the identifier of the relevant
favorite.

URL that creates a new event view of
    charts:

    POST /api/33/dataStatistics?eventType=CHART_VIEW&favorite=LW0O27b7TdD

A successful save operation returns an HTTP status code 201. The table
below shows the supported types of events.

<table>
<caption>Supported event types</caption>
<colgroup>
<col style="width: 38%" />
<col style="width: 61%" />
</colgroup>
<thead>
<tr class="header">
<th>Key</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>REPORT_TABLE_VIEW</td>
<td>Report table (pivot table) view</td>
</tr>
<tr class="even">
<td>CHART_VIEW</td>
<td>Chart view</td>
</tr>
<tr class="odd">
<td>MAP_VIEW</td>
<td>Map view (GIS)</td>
</tr>
<tr class="even">
<td>EVENT_REPORT_VIEW</td>
<td>Event report view</td>
</tr>
<tr class="odd">
<td>EVENT_CHART_VIEW</td>
<td>Event chart view</td>
</tr>
<tr class="even">
<td>DASHBOARD_VIEW</td>
<td>Dashboard view</td>
</tr>
<tr class="odd">
<td>PASSIVE_DASHBOARD_VIEW</td>
<td>Dashboard view (when not explicitly selecting the dashboard)</td>
</tr>
<tr class="even">
<td>DATA_SET_REPORT_VIEW</td>
<td>Data set report view</td>
</tr>
</tbody>
</table>

### Retrieve aggregated usage analytics report (GET) { #webapi_aggregated_usage_analytics } 

The usage analytics (data statistics) API lets you specify certain query
parameters when asking for an aggregated report.

<table>
<caption>Query parameters for aggregated usage analytics (data statistics)</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>startDate</td>
<td>Yes</td>
<td>Start date for period</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>Yes</td>
<td>End date for period</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr class="odd">
<td>interval</td>
<td>Yes</td>
<td>Type of interval to be aggregated</td>
<td>DAY, WEEK, MONTH, YEAR</td>
</tr>
</tbody>
</table>

The startDate and endDate parameters specify the period for which
snapshots are to be used in the aggregation. You must format the dates
as shown above. If no snapshots are saved in the specified period, an
empty list is sent back. The parameter called interval specifies what
type of aggregation will be done.

API query that creates a query for a monthly
    aggregation:

    GET /api/33/dataStatistics?startDate=2014-01-02&endDate=2016-01-01&interval=MONTH

### Retrieve top favorites { #webapi_usage_analytics_top_favorites } 

The usage analytics API lets you retrieve the top favorites used in
DHIS2, and by user.

<table>
<caption>Query parameters for top favorites</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>eventType</td>
<td>Yes</td>
<td>The data statistics event type</td>
<td>See above table</td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>No</td>
<td>Size of the list returned</td>
<td>For example 5, 10, 25. Default is 25</td>
</tr>
<tr class="odd">
<td>sortOrder</td>
<td>No</td>
<td>Descending or ascending</td>
<td>ASC or DESC. Default is DESC.</td>
</tr>
<tr class="even">
<td>username</td>
<td>No</td>
<td>If specified, the response will only contain favorites by this user.</td>
<td>For example 'admin'</td>
</tr>
</tbody>
</table>

The API query can be used without a username, and will then find the top
favorites of the system.

    /api/33/dataStatistics/favorites?eventType=CHART_VIEW&pageSize=25&sortOrder=ASC

If the username is specified, the response will only contain the top favorites of that user.

    /api/33/dataStatistics/favorites?eventType=CHART_VIEW&pageSize=25
      &sortOrder=ASC&username=admin

### Response format { #webapi_usage_analytics_response_format } 

You can return the aggregated data in a usage analytics response in
several representation formats. The default format is JSON. The
available formats and content types are:

  - json (application/json)

  - xml (application/xml)

  - html (text/html)

API query that requests a usage analytics response in XML
    format:

    /api/33/dataStatistics.xml?startDate=2014-01-01&endDate=2016-01-01&interval=WEEK

You must retrieve the aggregated usage analytics response with the HTTP
GET method. This allows you to link directly from Web pages and other
HTTP-enabled clients to usage analytics responses. To do functional
testing use the cURL library.

To get an usage analytics response in JSON format:

    /api/33/dataStatistics?startDate=2016-02-01&endDate=2016-02-14&interval=WEEK

The JSON response looks like this:

```json
[
  {
    "year": 2016,
    "week": 5,
    "mapViews": 2181,
    "chartViews": 2227,
    "reportTableViews": 5633,
    "eventReportViews": 6757,
    "eventChartViews": 9860,
    "dashboardViews": 10082,
    "passiveDashboardViews": 0,
    "totalViews": 46346,
    "averageViews": 468,
    "averageMapViews": 22,
    "averageChartViews": 22,
    "averageReportTableViews": 56,
    "averageEventReportViews": 68,
    "averageEventChartViews": 99,
    "averageDashboardViews": 101,
    "averagePassiveDashboardViews": 0,
    "savedMaps": 1805,
    "savedCharts": 2205,
    "savedReportTables": 1995,
    "savedEventReports": 1679,
    "savedEventCharts": 1613,
    "savedDashboards": 0,
    "savedIndicators": 1831,
    "activeUsers": 99,
    "users": 969
  },
  {
    "year": 2016,
    "week": 6,
    "mapViews": 2018,
    "chartViews": 2267,
    "reportTableViews": 4714,
    "eventReportViews": 6697,
    "eventChartViews": 9511,
    "dashboardViews": 12181,
    "passiveDashboardViews": 0,
    "totalViews": 47746,
    "averageViews": 497,
    "averageMapViews": 21,
    "averageChartViews": 23,
    "averageReportTableViews": 49,
    "averageEventReportViews": 69,
    "averageEventChartViews": 99,
    "averageDashboardViews": 126,
    "averagePassiveDashboardViews": 0,
    "savedMaps": 1643,
    "savedCharts": 1935,
    "savedReportTables": 1867,
    "savedEventReports": 1977,
    "savedEventCharts": 1714,
    "savedDashboards": 0,
    "savedIndicators": 1646,
    "activeUsers": 96,
    "users": 953
  }
]
```

### Retrieve statistics for a favorite { #webapi_usage_analytics_retrieve_favorite_statistics } 

You can retrieve the number of view for a specific favorite by using the
*favorites* resource, where *{favorite-id}* should be substituted with
the identifier of the favorite of interest:

    /api/33/dataStatistics/favorites/{favorite-id}.json

The response will contain the number of views for the given favorite and
look like this:

```json
{
  "views": 3
}
```

## Geospatial features { #webapi_geospatial_features } 

The *geoFeatures* resource lets you retrieve geospatial information from
DHIS2. Geospatial features are stored together with organisation units.
The syntax for retrieving features is identical to the syntax used for
the organisation unit dimension for the analytics resource. It is
recommended to read up on the analytics api resource before continuing
to read this section. You must use the GET request type, and only JSON
response format is supported.

As an example, to retrieve geo features for all organisation units at
level 3 in the organisation unit hierarchy you can use a GET request
with the following URL:

    /api/33/geoFeatures.json?ou=ou:LEVEL-3

To retrieve geo features for organisation units at a level within the
boundary of an organisation unit (e.g. at level 2) you can use this URL:

    /api/33/geoFeatures.json?ou=ou:LEVEL-4;O6uvpzGd5pu

The semantics of the response properties are described in the following
table.

<table>
<caption>Geo features response</caption>
<colgroup>
<col style="width: 14%" />
<col style="width: 85%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>id</td>
<td>Organisation unit / geo feature identifier</td>
</tr>
<tr class="even">
<td>na</td>
<td>Organisation unit / geo feature name</td>
</tr>
<tr class="odd">
<td>hcd</td>
<td>Has coordinates down, indicating whether one or more children organisation units exist with coordinates (below in the hierarchy)</td>
</tr>
<tr class="even">
<td>hcu</td>
<td>Has coordinates up, indicating whether the parent organisation unit has coordinates (above in the hierarchy)</td>
</tr>
<tr class="odd">
<td>le</td>
<td>Level of this organisation unit / geo feature.</td>
</tr>
<tr class="even">
<td>pg</td>
<td>Parent graph, the graph of parent organisation unit identifiers up to the root in the hierarchy</td>
</tr>
<tr class="odd">
<td>pi</td>
<td>Parent identifier, the identifier of the parent of this organisation unit</td>
</tr>
<tr class="even">
<td>pn</td>
<td>Parent name, the name of the parent of this organisation unit</td>
</tr>
<tr class="odd">
<td>ty</td>
<td>Geo feature type, 1 = point and 2 = polygon or multi-polygon</td>
</tr>
<tr class="even">
<td>co</td>
<td>Coordinates of this geo feature</td>
</tr>
</tbody>
</table>

### GeoJSON

To export GeoJSON, you can simply add *.geosjon* as an extension to the
endpoint */api/organisationUnits*, or you can use the *Accept* header
*application/json+geojson*.

Two parameters are supported: `level` (default is 1) and `parent` (default is root organisation units). Both can be included multiple times. Some examples:

Get all features at level 2 and 4:

    /api/organisationUnits.geojson?level=2&level=4

Get all features at level 3 with a boundary organisation unit:

    /api/organisationUnits.geojson?parent=fdc6uOvgoji&level=3

## Analytics table hooks { #webapi_analytics_table_hooks } 

Analytics table hooks provide a mechanism for invoking SQL scripts
during different phases of the analytics table generation process. This
is useful for customizing data in resource and analytics tables, e.g. in
order to achieve specific logic for calculations and aggregation.
Analytics table hooks can be manipulated at the following API endpoint:

    /api/analyticsTableHooks

The analytics table hooks API supports the standard HTTP CRUD operations
for creating (POST), updating (PUT), retrieving (GET) and deleting
(DELETE) entities.

### Hook fields { #webapi_analytics_table_hook_fields } 

Analytics table hooks have the following fields:

<table style="width:100%;">
<caption>Analytics table hook fields</caption>
<colgroup>
<col style="width: 22%" />
<col style="width: 30%" />
<col style="width: 46%" />
</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Options</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>Text</td>
<td>Name of the hook.</td>
</tr>
<tr class="even">
<td>phase</td>
<td>RESOURCE_TABLE_POPULATED, ANALYTICS_TABLE_POPULATED</td>
<td>The phase for when the SQL script should be invoked.</td>
</tr>
<tr class="odd">
<td>resourceTableType</td>
<td><p>See column &quot;Table type&quot; in table &quot;Phases, table types and temporary tables&quot; below</p></td>
<td>The type of resource table for which to invoke the SQL script. Applies only for hooks defined with the RESOURCE_TABLE_POPULATED phase.</td>
</tr>
<tr class="even">
<td>analyticsTableType</td>
<td>See column &quot;Table type&quot; in table &quot;Phases, table types and temporary tables&quot; below</td>
<td>The type of analytics table for which to invoke the SQL script. Applies only for hooks defined with the ANALYTICS_TABLE_POPULATED phase.</td>
</tr>
<tr class="odd">
<td>sql</td>
<td>Text</td>
<td>The SQL script to invoke.</td>
</tr>
</tbody>
</table>

The *ANALYTICS_TABLE_POPULATED* phase takes place after the analytics
table has been populated, but before indexes have been created and the
temp table has been swapped with the main table. As a result, the SQL
script should refer to the analytics temp table, e.g. *analytics_temp*,
*analytics_completeness_temp*.

This applies also to the *RESOURCE_TABLE_POPULATED* phase, which takes
place after the resource table has been populated, but before indexes
have been created and the temp table has been swapped with the main
table. As a result, the SQL script should refer to the resource temp
table, e.g. *_orgunitstructure_temp*, *_categorystructure_temp*.

You should define only one of the *resourceTableType* and
*analyticsTableType* fields, depending on which *phase* is defined.

You can refer to the temporary database table which matches the
specified hook table type only (other temporary tables will not be
available). As an example, if you specify *ORG_UNIT_STRUCTURE* as the
resource table type, you can refer to the *_orgunitstructure_temp*
temporary database table only.

The following table shows the valid combinations of phases, table types
and temporary tables.

<table>
<caption>Phases, table types and temporary tables</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 39%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Phase</th>
<th>Table type</th>
<th>Temporary table</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td rowspan="12">RESOURCE_TABLE_POPULATED</td>
<td>ORG_UNIT_STRUCTURE</td>
<td>_orgunitstructure_temp</td>
</tr>
<tr class="even">
<td>DATA_SET_ORG_UNIT_CATEGORY</td>
<td>_datasetorgunitcategory_temp</td>
</tr>
<tr class="odd">
<td>CATEGORY_OPTION_COMBO_NAME</td>
<td>_categoryoptioncomboname_temp</td>
</tr>
<tr class="even">
<td>DATA_ELEMENT_GROUP_SET_STRUCTURE</td>
<td>_dataelementgroupsetstructure_temp</td>
</tr>
<tr class="odd">
<td>INDICATOR_GROUP_SET_STRUCTURE</td>
<td>_indicatorgroupsetstructure_temp</td>
</tr>
<tr class="even">
<td>ORG_UNIT_GROUP_SET_STRUCTURE</td>
<td>_organisationunitgroupsetstructure_temp</td>
</tr>
<tr class="odd">
<td>CATEGORY_STRUCTURE</td>
<td>_categorystructure_temp</td>
</tr>
<tr class="even">
<td>DATA_ELEMENT_STRUCTURE</td>
<td>_dataelementstructure_temp</td>
</tr>
<tr class="odd">
<td>PERIOD_STRUCTURE</td>
<td>_periodstructure_temp</td>
</tr>
<tr class="even">
<td>DATE_PERIOD_STRUCTURE</td>
<td>_dateperiodstructure_temp</td>
</tr>
<tr class="odd">
<td>DATA_ELEMENT_CATEGORY_OPTION_COMBO</td>
<td>_dataelementcategoryoptioncombo_temp</td>
</tr>
<tr class="even">
<td>DATA_APPROVAL_MIN_LEVEL</td>
<td>_dataapprovalminlevel_temp</td>
</tr>
<tr class="odd">
<td rowspan="7">ANALYTICS_TABLE_POPULATED</td>
<td>DATA_VALUE</td>
<td>analytics_temp</td>
</tr>
<tr class="even">
<td>COMPLETENESS</td>
<td>analytics_completeness_temp</td>
</tr>
<tr class="odd">
<td>COMPLETENESS_TARGET</td>
<td>analytics_completenesstarget_temp</td>
</tr>
<tr class="even">
<td>ORG_UNIT_TARGET</td>
<td>analytics_orgunittarget_temp</td>
</tr>
<tr class="odd">
<td>EVENT</td>
<td>analytics_event_temp_&lt;program-uid&gt;</td>
</tr>
<tr class="even">
<td>ENROLLMENT</td>
<td>analytics_enrollment_temp_&lt;program-uid&gt;</td>
</tr>
<tr class="odd">
<td>VALIDATION_RESULT</td>
<td>analytics_validationresult_temp</td>
</tr>
</tbody>
</table>

### Creating hooks { #webapi_create_analytics_table_hook } 

To create a hook which should run after the resource tables have been
populated you can do a *POST* request like this using *JSON* format:

```bash
curl -d @hooks.json "localhost/api/analyticsTableHooks" -H "Content-Type:application/json" -u admin:district
```

```json
{
  "name": "Update 'Area' in org unit group set resource table",
  "phase": "RESOURCE_TABLE_POPULATED",
  "resourceTableType": "ORG_UNIT_GROUP_SET_STRUCTURE",
  "sql": "update _organisationunitgroupsetstructure_temp set \"uIuxlbV1vRT\" = 'b0EsAxm8Nge'"
}
```

To create a hook which should run after the data value analytics table
has been populated you can do a *POST* request like this using *JSON*
format:

```json
{
  "name": "Update 'Currently on treatment' data in analytics table",
  "phase": "ANALYTICS_TABLE_POPULATED",
  "analyticsTableType": "DATA_VALUE",
  "sql": "update analytics_temp set monthly = '200212' where \"monthly\" in ('200210', '200211')"
}
```

## SVG conversion { #webapi_svg_conversion } 

The Web API provides a resource which can be used to convert SVG content
into more widely used formats such as PNG and PDF. Ideally this
conversion should happen on the client side, but not all client side
technologies are capable of performing this task. Currently PNG and PDF
output formats are supported. The SVG content itself should be passed with
a *svg* query parameter, and an optional query parameter *filename* can
be used to specify the filename of the response attachment file. Note
that the file extension should be omitted. For PNG you can send a *POST*
request to the following URL with Content-type
`application/x-www-form-urlencoded`, identical to a regular HTML form
submission.

    api/svg.png

For PDF you can send a *POST* request to the following URL with
content-type `application/x-www-form-urlencoded`.

    api/svg.pdf

<table>
<caption>Query parameters</caption>
<colgroup>
<col style="width: 21%" />
<col style="width: 11%" />
<col style="width: 67%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>svg</td>
<td>Yes</td>
<td>The SVG content</td>
</tr>
<tr class="even">
<td>filename</td>
<td>No</td>
<td>The file name for the returned attachment without file extension</td>
</tr>
</tbody>
</table>


