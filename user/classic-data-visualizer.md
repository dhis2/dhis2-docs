# Classic Data Visualizer (deprecated) { #data_vis } 

This chapter refers to the legacy version of the data visualizer. For
the current version, please refer to the [new data visualizer](./data_visualizer.html)
chapter.

## About the Classic Data Visualizer app { #data_vis_intro } 

![](resources/images/visualizer/column_chart.png)

With the ** Classic Data Visualizer** app, you can select content, for example
indicators, data elements, periods and organisation units, for an
analysis. The app works well over poor Internet connections and
generates charts in the web browser.

> **Tip**
>
>   - Hide and show individual data series in the chart by clicking
>     directly on the series label in the chart. They appear either at
>     the top or to the right of the chart.
>
>   - Click the triple left-arrow button on the top centre menu. This
>     collapses the left side menu and gives more space for the chart.
>     You can get the menu back by clicking on the same button again.

## Create a chart { #datavis_create_chart } 

1.  Open the **Classic Data Visualizer** app and select a chart type.

2.  In the menu to the left, select the metadata you want to analyse.
    You must select one or more elements from all of the three
    dimensions - data (indicators, data elements, reporting rates),
    periods (relative, fixed) and organisation units (units or groups).

    > **Note**
    >
    > If you've access to the system settings, you can change the
    > default period type under **General settings \> Default relative
    > period for analysis.**

    **Last 12 Months** from the period dimension and the root
    organisation unit are selected by default.

3.  Click **Layout** and arrange the dimensions.

    You can keep the default selection if you want.

4.  Click **Update**.

## Select a chart type { #datavis_chart_types } 

The **Classic Data Visualizer** app has nine different chart types, each with
different characteristics. To select a chart type:

1.  In **Chart type**, click the chart type you need.

    

    Table: Chart types

    | Chart type | Description |
    |---|---|
    | Column chart | Displays information as vertical rectangular columns with lengths proportional to the values they represent.<br>     <br>Useful when you want to, for example, compare performance of different districts. |
    | Stacked column chart | Displays information as vertical rectangular columns, where bars representing multiple categories are stacked on top of each other.<br>     <br>Useful when you want to, for example, display trends or sums of related data elements. |
    | Bar chart | Same as column chart, only with horizontal bars. |
    | Stacked bar chart | Same as stacked column chart, only with horizontal bars. |
    | Line chart | Displays information as a series of points connected by straight lines. Also referred to as time series.<br>     <br>Useful when you want to, for example, visualize trends in indicator data over multiple time periods. |
    | Area chart | Is based on line chart, with the space between the axis and the line filled with colors and the lines stacked on top of each other.<br>     <br>Useful when you want to compare the trends of related indicators. |
    | Pie chart | Circular chart divided into sectors (or slices).<br>     <br>Useful when you want to, for example, visualize the proportion of data for individual data elements compared to the total sum of all data elements in the chart. |
    | Radar chart | Displays data on axes starting from the same point. Also known as spider chart. |
    | Speedometer chart | Semi-circle chart which displays values out of 100 %. Also referred to as a gauge chart. |

2.  Click **Update**.

## Select dimension items { #data_vis_select_dim_items } 

A dimension refers to the elements which describe the data values in the
system. There are three main dimensions in the system:

  - Data: Includes data elements, indicators and datasets (reporting
    rates), describing the phenomena or event of the data.

<!-- end list -->

  - Periods: Describes when the event took place.

<!-- end list -->

  - Organisation units: Describes where the event took place.

The Classic Data Visualizer app lets you use these dimensions completely
flexible in terms of appearing as series, categories and filter.

> **Note**
>
> You can select dimension items in different ways:
>
>   - Double-click a dimension item name.
>
>   - Highlight one or several dimension items and click the
>     single-arrow.
>
>   - To select all dimension items in a list, click the double-arrow.
>
>   - To clear dimension items, use the arrows or double-click the names
>     in the **Selected** list.

### Select indicators

The Classic Data Visualizer app can display any number of indicators and data
elements in a chart. You can select both indicators and data elements to
appear together in the same chart, with their order of appearance the
same as the order in which they are selected.

1.  Click **Data** and select **Indicators**.

2.  Select an indicator group.

    The indicators in the selected group appear in the **Available**
    list.

3.  Select one or several indicators by double-clicking the name.

    The indicator moves to the **Selected** list.

### Select data elements

The Classic Data Visualizer app can display any number of indicators and data
elements in a chart. You can select both indicators and data elements to
appear together in the same chart, with their order of appearance the
same as the order in which they are selected.

1.  Click **Data** and select **Data elements**.

2.  Select a data element group.

    The data elements in the selected group appear in the **Available**
    list.

3.  Select one or several data elements by double-clicking the name.

    The data element moves to the **Selected** list.

### Select reporting rates

The Classic Data Visualizer app can display reporting rates in a chart, by
itself or together with indicators and data elements. Reporting rates
are defined by data sets.

1.  Click **Data** and select **Reporting rates**.

    The reporting rates appear in the **Available** list.

2.  Select one or several reporting rates by double-clicking the name.

    The reporting rate moves to the **Selected** list.

### Select fixed and relative periods

1.  Click **Periods**.

2.  Select one or several periods.

    You can combine fixed periods and relative periods in the same
    chart. Overlapping periods are filtered so that they only appear
    once.

      - Fixed periods: In the **Select period type** box, select a
        period type. You can select any number of fixed periods from any
        period type.

    <!-- end list -->

      - Relative periods: In the lower part of the **Periods** section,
        select as many relative periods as you like. The names are
        relative to the current date. This means that if the current
        month is March and you select **Last month**, the month of
        February is included in the chart.

### Select organisation units

1.  Click **Organisation units**.

2.  Click the gearbox icon.

3.  Select a **Selection mode** and an organisation unit.

    There are three different selection modes:

    

    Table: Selection modes

    | Selection mode | Description |
    |---|---|
    | **Select organisation units** | Lets you select the organisation units you want to appear in the chart from the organization tree.<br>     <br>Select **User org unit** to disable the organisation unit tree and only select the organisation unit that is related to your profile.<br>     <br>Select **User sub-units** to disable the organisation unit tree and only select the sub-units of the organisation unit that is related to your profile.<br>     <br>Select **User sub-x2-units** to disable the organisation unit tree and only select organisation units two levels down from the organisation unit that is related to your profile.<br>     <br>This functionality is useful for administrators to create a meaningful "system" favorite. With this option checked all users find their respective organisation unit when they open the favorite. |
    | **Select levels** | Lets you select all organisation units at one or more levels, for example national or district level.<br>     <br>You can also select the parent organisation unit in the tree, which makes it easy to select for example, all facilities inside one or more districts. |
    | **Select groups** | Lets you select all organisation units inside one or several groups and parent organisation units at the same time, for example hospitals or chiefdoms. |

4.  Click **Update**.

### Select additional dimension items

Depending on the settings for your organisation unit group sets and data
element group sets, you can select additional dimension items from the
left menu.

Here you can add dimension items such as age, sex, etc. without having
to add them as detailed data element selections. This is useful when you
want to separate these categories in your analysis.

The additional dimension items you select are available in **Chart
layout** as dimensions.

## Select series, category and filter { #data_vis_series_category_filter } 

![](resources/images/visualizer/chart_layout.png)

You can define which dimension of the data you want to appear as series,
category and filter.

1.  Click **Layout**.

2.  Drag and drop the dimensions to the appropriate space. Only one
    dimension can be in each section.

3.  Click **Update**.

![](resources/images/visualizer/series_category_filter.png)

  - Series: A series is a set of continuous, related elements (for
    example periods or data elements) which you want to visualize in
    order to emphasize trends or relations in its data.

  - Categories: A category is a set of elements (for example indicators
    or organisation units) for which you want to compare its data.

  - Filter: The filter selection will filter the data displayed in the
    chart. Note that if you use the data dimension as filter, you can
    only specify a single indicator or data set as filter item, whereas
    with other dimension types you can select any number of items.

\</example\>

## Change the display of your chart { #datavis_change_display } 

1.  Click **Options**.

2.  Set the options as required.

    

    Table: Chart options

    | Option | Description ||
    |---|---|---|
    | **Data** | **Show values** | Shows the values above the series in the chart. |
    || **Use 100% stacked values** | Displays 100 % stacked values in column charts. |
    || **Use cumulative values** | Displays cumulative values in line charts. |
    || **Hide empty categories** | Hides the category items with no data from the chart.<br>     <br>**None**: doesn't hide any of the empty categories<br>     <br>**Before first**: hides missing values only before the first value<br>     <br>**After last**: hides missing values only after the last value<br>     <br>**Before first and after last**: hides missing values only before the first value and after the last value<br>     <br>**All**: hides all missing values<br>     <br>This is useful for example when you create column and bar charts. |
    || **Trend line** | Displays the trend line which visualizes how your data evolves over time. For example if performance is improving or deteriorating. Useful when periods are selected as category. |
    || **Target line value/title** | Displays a horizontal line at the given domain value. Useful for example when you want to compare your performance to the current target. |
    || **Base line value/title** | Displays a horizontal line at the given domain value. Useful for example when you want to visualize how your performance has evolved since the beginning of a process. |
    || **Sort order** | Allows you to sort the values on your chart from either low to high or high to low. |
    || **Aggregation type** | Defines how the data elements or indicators will be aggregated within the chart. Some of the aggregation types are **By data element**, **Count**, **Min** and **Max**. |
    | **Events** | **Include only completed events** | Includes only completed events in the aggregation process. This is useful when you want for example to exclude partial events in indicator calculations. |
    | **Axes** | **Range axis min/max** | Defines the maximum and minimum value which will be visible on the range axis. |
    || **Range axis tick steps** | Defines the number of ticks which will be visible on the range axis. |
    || **Range axis decimals** | Defines the number of decimals which will be used for range axis values. |
    || **Range axis title** | Type a title here to display a label next to the range axis (also referred to as the Y axis). Useful when you want to give context information to the chart, for example about the unit of measure. |
    || **Domain axis title** | Type a title here to display a label below the domain axis (also referred to as the X axis). Useful when you want to give context information to the chart, for example about the period type. |
    | **Style** | **No space between columns/bars** | Removes the space between the columns or bars in the chart. Useful for displaying the chart as an EPI curve. |
    | **General** | **Hide chart legend** | Hides the legend and leaves more room for the chart itself. |
    || **Hide chart title** | Hides the title (default or custom) of your chart. |
    || **Chart title** | Type a title here to display a custom title above the chart. If you don't enter a title, the default title is displayed. |
    || **Hide chart subtitle** | Hides the subtitle of your chart. |
    || **Chart subtitle** | Type a subtitle here to display a custom subtitle above the chart but below the title. If you don't enter a subtitle, no subtitle is displayed in the chart. |

3.  Click **Update**.

## Manage favorites

Saving your charts or pivot tables as favorites makes it easy to find
them later. You can also choose to share them with other users as an
interpretation or display them on the dashboard.

You view the details and interpretations of your favorites in the
**Pivot Table**, **Data Visualizer**, **Event Visualizer**, **Event
Reports** apps. Use the **Favorites** menu to manage your favorites.

### Open a favorite

1.  Click **Favorites** \> **Open**.

2.  Enter the name of a favorite in the search field, or click **Prev**
    and **Next** to display favorites.

3.  Click the name of the favorite you want to open.

### Save a favorite

1.  Click **Favorites** \> **Save as**.

2.  Enter a **Name** and a **Description** for your favorite. The description field supports a rich text format, see the interpretations section for more details.

3.  Click **Save**.

### Rename a favorite

1.  Click **Favorites** \> **Rename**.

2.  Enter the new name for your favorite.

3.  Click **Update**.

### Write an interpretation for a favorite

An interpretation is a link to a resource with a description of the data
at a given period. This information is visible in the **Dashboard** app.
To create an interpretation, you first need to create a favorite. If
you've shared your favorite with other people, the interpretation you
write is visible to those people.

1.  Click **Favorites** \> **Write interpretation**.

2.  In the text field, type a comment, question or interpretation. You
    can also mention other users with '@username'. Start by typing '@'
    plus the first letters of the username or real name and a mentioning
    bar will display the available users. Mentioned users will receive
    an internal DHIS2 message with the interpretation or comment. You
    can see the interpretation in the **Dashboard** app.

    It is possible to format the text with **bold**, *italic* by using the
    Markdown style markers \* and \_ for **bold** and *italic* respectively.
    Keyboard shortcuts are also available: Ctrl/Cmd + B and Ctrl/Cmd + I. A
    limited set of smilies is supported and can be used by typing one of the
    following character combinations: :) :-) :( :-( :+1 :-1. URLs are
    automatically detected and converted into a clickable link.

3.  Search for a user group that you want to share your favorite with,
    then click the **+** icon.

4.  Change sharing settings for the user groups you want to modify.

      - **Can edit and view**: Everyone can view and edit the object.

      - **Can view only**: Everyone can view the object.

      - **None**: The public won't have access to the object. This
        setting is only applicable to **Public access**.

5.  Click **Share**.

### Subscribe to a favorite

When you are subscribed to a favorite, you receive internal messages
whenever another user likes/creates/updates an interpretation or
creates/update an interpretation comment of this favorite.

1.  Open a favorite.

2.  Click **\>\>\>** in the top right of the workspace.

3.  Click on the upper-right bell icon to subscribe to this favorite.

### Create a link to a favorite

1.  Click **Favorites** \> **Get link**.

2.  Select one of the following:

      - **Open in this app**: You get a URL for the favorite which you
        can share with other users by email or chat.

      - **Open in web api**: You get a URL of the API resource. By
        default this is an HTML resource, but you can change the file
        extension to ".json" or ".csv".

### Delete a favorite

1.  Click **Favorites** \> **Delete**.

2.  Click **OK**.

### View interpretations based on relative periods

To view interpretations for relative periods, such as a year ago:

1.  Open a favorite with interpretations.

2.  Click **\>\>\>** in the top right of the workspace.

3.  Click an interpretation. Your chart displays the data and the date
    based on when the interpretation was created.To view other
    interpretations, click them.

## Download a chart as an image or a PDF { #data_vis_save_chart } 

After you have created a chart you can download it to your local
computer as an image or PDF file.

1.  Click **Download**.

2.  Under **Graphics**, click **Image (.png)** or **PDF (.pdf)**.

    The file is automatically downloaded to your computer. Now you can
    for example embed the image file into a text document as part of a
    report.

## Download chart data source { #data_vis_download_chart_data } 

You can download the data source behind a chart in JSON, XML, Excel,
CSV, JXRML or Raw data SQL formats with different identification schemes
(ID, Code, and Name). The data document uses identifiers of the
dimension items and opens in a new browser window to display the URL of
the request to the Web API in the address bar. This is useful for
developers of apps and other client modules based on the DHIS2 Web API
or for those who require a plan data source, for instance for import
into statistical packages.

To download plain data source formats:

1.  Click **Download**.

2.  Under **Plain data source**, click the format you want to download.

    

    Table: Available formats

    | Format | Action | Description |
    |---|---|---|
    | JSON | Click **JSON** | Downloads JSON format based on ID property.<br>     <br>You can also download JSON format based on **Code** or **Name** property. |
    | XML | Click **XML** | Downloads XML format based on ID property.<br>     <br>You can also download XML format based on **Code** or **Name** property. |
    | Microsoft Excel | Click **Microsoft Excel** | Downloads Microsoft Excel format based on ID property.<br>     <br>You can also download Microsoft Excel format based on **Code** or **Name** property. |
    | CSV | Click **CSV** | Downloads CSV format based on ID property.<br>     <br>You can also download CSV format based on **Code** or **Name** property. |
    | JRXML | Put the cursor on **Advanced** and click **JRXML** | Produces a template of a Jasper Report which can be further customized based on your exact needs and used as the basis for a standard report in DHIS 2. |
    | Raw data SQL | Put the cursor on **Advanced** and click **Raw data SQL** | Provides the actual SQL statement used to generate the data visualization. You can use it as a data source in a Jasper report, or as the basis for a SQL view. |

## Embed charts in any web page { #data_vis_embedding } 

Certain analysis-related resources in DHIS2, like pivot tables, charts
and maps, can be embedded in any web page by using a plug-in. You will
find more information about the plug-ins in the Web API chapter in the
*DHIS2 Developer Manual*.

To generate a HTML fragment that you can use to display the chart in an
external web page:

1.  Click **Share** \> **Embed in web page**.

    The **Embed in web page** window opens.

2.  Click **Select** to highlight the HTML fragment.

## Open a chart as a pivot table or as a map

  - Open a **Chart** and click **Chart** or click **Map**.
