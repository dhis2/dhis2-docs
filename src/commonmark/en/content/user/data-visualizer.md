# Using the Data Visualizer app

<!--DHIS2-SECTION-ID:data_visualizer-->

![](resources/images/data-visualizer/data-visualizer-overview.png)

## Creating and editing visualizations

When you open the data-visualizer app from the dhis2 menu, you are presented with a blank slate and you can start creating your visualization right away.

![](resources/images/data-visualizer/data-visualizer-new.png)

### Select visualization type

Select the desired visualization type from the selector in the upper left corner.
For each visualization type there is a brief description with suggestions about where to use the main dimensions in the layout.

![](resources/images/data-visualizer/data-visualizer-visualization-type.png)  


|Visualization type|Description|
|--- |--- |
|Column|Displays information as vertical rectangular columns with lengths proportional to the values they represent.<br><br>Example: comparing performance of different districts.<br><br>Layout restrictions: exactly 1 dimension as series, exactly 1 dimension as category.|
|Stacked column|Displays information as vertical rectangular columns, where bars representing multiple categories are stacked on top of each other.<br><br>Example: displaying trends or sums of related data elements.<br><br>Layout restrictions: same as Column.|
|Bar|Same as Column, only with horizontal bars.|
|Stacked bar|Same as Stacked column, only with horizontal bars.|
|Line|Displays information as a series of points connected by straight lines. Also referred to as time series.<br><br>Example: visualizing trends in indicator data over intervals of time.<br><br>Layout restrictions: same as Column.|
|Area|Is based on a line (above), with the space between the axis and the line filled with colors and the lines stacked on top of each other.<br><br>Example: comparing the trends of related indicators.<br><br>Layout restrictions: same as Column.|
|Stacked area|Same as Area, but the areas of the various dimension items are stacked on top of each other.<br><br>Example: comparing the trends of related indicators.<br><br>Layout restrictions: same as Area.|
|Pie|Circle divided into sectors (or slices).<br><br>Example: visualizing the proportion of data for individual data elements compared to the total sum of all data elements.<br><br>Layout restrictions: exactly 1 dimension as series, has no category.|
|Radar|Displays data on axes starting from the same point. Also known as spider chart.<br><br>Layout restrictions: same as Column.|
|Gauge|Semi-circle which displays a single value, typically out of 100% (start and end values are configurable).<br><br>Layout restrictions: exactly 1 dimension with exactly 1 item as series, data dimension is locked to series.|
|Year over year (line)|Useful when you want to compare one year of data to other years of data. Based on calendar years.<br><br>Layout restrictions: period dimension is disabled.|
|Year over year (column)|Same as Year over year (line), only with columns.|
|Single value|Displays a single value in a dashboard friendly way.<br><br>Layout restrictions: same as Gauge.|
|Pivot table|Summarizes the data of a more extensive table and might include sums, averages, or other statistics, which the pivot table groups together in a meaningful way.<br><br>Layout restrictions: none.|

### Select dimensions

From the dimensions menu on the left you can select the dimensions you want to show in your visualization, including data, period, organisation units and dynamic dimensions. These can be added by clicking on a dimension, by dragging and dropping a dimension to the layout area or by hovering over a dimension and using on its context menu (three dots).

![](resources/images/data-visualizer/data-visualizer-dimensions.png)

Just like in the dimensions menu, in the layout area you can also change the selections by clicking on a dimension, dragging and dropping a dimension or by using a dimension's context menu (three dots).

![](resources/images/data-visualizer/data-visualizer-layout-area.png)

- **Series**: A series is a set of continuous, related elements (for
  example periods or data elements) that you want to visualize in
  order to emphasize trends or relations in its data. Also known as Columns for Pivot table visualizations.

<!-- end list -->

- **Categories**: A category is a set of elements (for example indicators
  or organisation units) for which you want to compare its data. Also known as Rows for Pivot table visualizations.

<!-- end list -->

- **Filter**: The filter selection will filter the data displayed in the
  visualization. Note that if you use the data dimension as filter, you can
  only specify a single indicator or data set as filter item, whereas
  with other dimension types you can select any number of items.

### Select dimension items

<!--DHIS2-SECTION-ID:data_vis_select_dim_items-->

A dimension refers to the elements that describe the data values in the system. There are three main dimensions in the system:

- **Data**: Includes data elements, indicators and datasets (reporting
  rates), describing the phenomena or event of the data.

<!-- end list -->

- **Periods**: Describes when the event took place.

<!-- end list -->

- **Organisation units**: Describes where the event took place.

Data Visualizer is highly flexible in terms of allowing you to use these dimensions as series, categories and filter.

To select items for a dimension, open the dimension modal window by clicking on a dimension. This window will also be opened automatically when adding a dimension without selected items to the layout. Select which items to add to the visualization by double-clicking an item or by selecting an item with a single click and using the arrows in the middle. The order of appearance will be the same as the order in which they are selected. Selected items can be reordered by dragging and dropping them in the Selected section.

![](resources/images/data-visualizer/data-visualizer-dimension-modal.png)

#### Select periods

When selecting a Period you have to option to choose between fixed periods and relative periods. These can also be combined. Overlapping periods are filtered so that they only appear once. For relative periods the names are relative to the current date, e.g. if the current month is March and **Last month** is selected, the month of February is shown in the visualization.

![](resources/images/data-visualizer/data-visualizer-period-dimension-modal.png)

#### Select organisation units

The organisation units dialog is flexible, offering essentially three ways of selecting organisation units:

- Explicit selection: Use the **tree** to explicitly select the organisation units you want to appear in the visualization. If you right-click on an organisation unit you can easily choose to select all org units below it.

- Levels and groups: The **Level** and **Group** dropdowns are a convenient way to select all units in one or more org unit groups or at specific levels. Example: select _Chiefdom_ (level 3) to get all org units at that level.

  Please note that as soon as at least one level or group has been selected the org unit tree now acts as the boundary for the levels/groups. Example: if you select _Chiefdom_ (level 3) and _Kailahun_ org unit (at level 2) in the tree you get all chiefdom units inside Kailahun district.

- The user's organisation units:

  - User organisation unit: This is a way to dynamically select the org units that the logged in user is associated to.

  - User sub-units: Selects the sub-units of the user organisation unit.

  - User sub-x2-units: Selects the units two levels below the user organisation unit.

![](resources/images/data-visualizer/data-visualizer-organisation-unit-dimension-modal.png)

### Two category charts

Most chart visualization types can show two categories.
Switching from Pivot Table to Column, Bar, Area (and their stacked versions) and Line is keeping the first two dimensions in Category, any additional dimension is moved to Filter.
The labels for the first dimension in Category are shown at the top of the chart, and the ones for the second dimension at the bottom.
The resulting visualization is composed of separate charts, one for each item in the first dimension.

![](resources/images/data-visualizer/data-visualizer-two-category.png)

## Change the display of your visualization

The display of a visualization can be changed by enabling/disabling and configuring several options. Each visualization type can have a different set of available options. The options are organised in tabs in the **Options dialog** and in sections within each tab.

1.  Click **Options** to open the **Options dialog**.

2.  Navigate the tabs in the dialog to see the available options.

3.  Configure the desired options as required.

4.  Click **Update** to apply the changes to the visualization.

### List of available options

|Option|Description|
|--- |--- |
||**Data tab**|
|Aggregation type|Defines how the data elements or indicators will be aggregated within the visualization. Some of the aggregation types are By data element, Count, Min and Max.|
|Base line|Displays a horizontal line at the given domain value. Useful for example when you want to visualize how your performance has evolved since the beginning of a process.|
|Column sub-totals|Displays sub-totals in a Pivot table for each dimension.<br>If you only select one dimension, sub-totals will be hidden for those columns. This is because the values will be equal to the sub-totals.|
|Column totals|Displays total values in a Pivot table for each column, as well as a total for all values in the table.|
|Cumulative values|Displays cumulative values in Column, Stacked column, Bar, Stacked bar, Line and Area visualizations|
|Custom sort order|Controls the sort order of the values.|
|Dimension labels|Shows the dimension names as part of a Pivot table.|
|Hide empty categories|Hides the category items with no data from the visualization.<br>**Before first**: hides missing values only before the first value<br>**After last**: hides missing values only after the last value<br>**Before first and after last**: hides missing values only before the first value and after the last value<br>**All**: hides all missing values<br>This is useful for example when you create Column and Bar visualizations.|
|Hide empty columns|Hides empty columns from a Pivot table. This is useful when you look at large tables where a large portion of the dimension items don't have data in order to keep the table more readable.|
|Hide empty rows|Hides empty rows from a Pivot table. This is useful when you look at large tables where a large portion of the dimension items don't have data in order to keep the table more readable.|
|Number type|Sets the type of value you want to display in a Pivot table: Value, Percentage of row or Percentage of column.<br>The options Percentage of row and Percentage of column mean that you'll display values as percentages of row total or percentage of column total instead of the aggregated value. This is useful when you want to see the contribution of data elements, categories or organisation units to the total value.|
|Only include completed events|Includes only completed events in the aggregation process. This is useful for example to exclude partial events in indicator calculations.|
|Row sub-totals|Displays sub-totals in a Pivot table for each dimension.<br>If you only select one dimension, sub-totals will be hidden for those rows. This is because the values will be equal to the sub-totals.|
|Row totals|Displays total values in a Pivot table for each row, as well as a total for all values in the table.|
|Skip rounding|Skips the rounding of data values, offering the full precision of data values. Can be useful for finance data where the full dollar amount is required.|
|Stacked values add up to 100%|Displays 100 % stacked values in Stacked column and Stacked bar visualizations.|
|Target line|Displays a horizontal line at the given domain value. Useful for example when you want to compare your performance to the current target.|
|Trend line|Displays the trend line that visualizes how your data evolves over time. For example if performance is improving or deteriorating. Useful when periods are selected as category.|
|Value labels|Shows the values above the series in the visualization.|
||Axes tab|
|Axis range|Defines the maximum and minimum value that will be visible on the range axis.|
|Axis title|Type a title here to display a label next to the x or y axis. Useful when you want to give context information to the visualization, for example about the unit of measure.|
|Decimals|Defines the number of decimals that will be used for range axis values.|
|Steps|Defines the number of ticks that will be visible on the range axis.|
||**Legend tab**|
|Display legend|Applies a legend to the values. This means that you can apply a color to the values. You configure legends in the Maintenance app.<br>The Legend type section allows to control which color is applied. Select Use pre-defined legend per data item to color a data point individually according to each data element or indicator. Select Select a single legend for entire visualization to use a single legend, chosen in a drop-down list of available legends.<br>The Legend style section allows to control where the color is applied, the text or background based on the selected legend. You can use this option for scorecards to identify high and low values at a glance. Not applicable for Single Value visualizations.|
||**Series tab**|
||Options for adding more axes and changing how different series are displayed are set in this tab. Please see a detailed description of how this works in the corresponding sections below.|
||**Style tab**|
|Digit group separator|Controls which character to use to separate groups of digits or "thousands". You can set it to Comma, Space or None.|
|Display density|Controls the size of the cells in a Pivot table. You can set it to Comfortable, Normal or Compact.<br>Compact is useful when you want to fit large tables into the browser screen.|
|Display organisation unit hierarchy|Shows the name of all ancestors for organisation units, for example "Sierra Leone / Bombali / Tamabaka / Sanya CHP" for "Sanya CHP".<br>The organisation units are then sorted alphabetically which will order the organisation units according to the hierarchy.<br>When you download a pivot table with organisation units as rows and you've selected Display organisation unit hierarchy, each organisation unit level is rendered as a separate column. This is useful for example when you create Excel pivot tables on a local computer.|
|Font size|Controls the size of a Pivot table text font. You can set it to Large, Normal or Small.|
|Chart/Table title|Controls the title that appears above the visualization.<br>Auto generated uses the default title generated from the visualization's dimensions/filters.<br>None removes the title.<br>The Custom option allows you to type a custom title.|
|Chart/Table subtitle|Controls the subtitle that appears above the visualization.<br>Auto generated uses the default subtitle generated from the visualization's dimensions/filters.<br>None removes the subtitle.<br>The Custom option allows you to type a custom subtitle.|
|Show legend key|Toggles the legend on and off leaving more room for the visualization itself.|
|No space between bars/columns|Removes the space between the columns or bars in the visualization. Useful for displaying the visualization as an EPI curve.|
|Value labels|Shows the values above the series in the visualization.|
|Chart/Table title|Controls the title that appears above the visualization.<br>Auto generated uses the default title generated from the visualization's dimensions/filters.<br>None removes the title.<br>The Custom option allows you to type a custom title.|
|Color set|Controls the colors used in the chart. A list of available color sets is shown with a preview of the colors. There is also a "Mono patterns" option which uses colored patterns instead of solid colors.|
||**Limit values tab**|
|Limit minimum/maximum values|Allows for the data to be filtered on the server side.<br>You can instruct the system to return only records where the aggregated data value is equal, greater than, greater or equal, less than or less or equal to certain values.<br>If both parts of the filter are used, it's possible to filter out a range of data records.|
||**Parameters tab**|
|Custom sort order|Controls the sort order of the values.|
|Include cumulative|Includes a column with cumulative values to a Pivot table.|
|Include regression|Includes a column with regression values to a Pivot table.|
|Organisation unit|Controls whether to ask user to enter an organisation unit when creating a standard report in Reports app.|
|Parent organisation unit|Controls whether to ask user to enter a parent organisation unit when creating a standard report in Reports app.|
|Reporting period|Controls whether to ask user to enter a report period when creating a standard report in Reports app.|
|Top limit|Controls the maximum number of rows to include in a Pivot table.|

### Custom styling for text and legend in charts

The following options can be customized using the text styling tool: `Chart title`, `Chart subtitle`, `Show legend key`, `Target line`, `Base line`, `Axis title` and `Labels` for both horizontal and vertical axes.
The text styling tool allows to choose a font size, color and italic/bold variants. It's also possible to choose the position of the text.

![](resources/images/data-visualizer/data-visualizer-text-styling-tool.png)

## Adding Assigned Categories

Assigned Categories is a composite dimension that represents associated category option combinations to the selected data element's category combination. This can be added by dragging the **Assigned Categories** dimension from the left side dimensions menu and into the visualization layout:

![](resources/images/data-visualizer/data-visualizer-assigned-categories.png)

Another way of adding assigned categories is by accessing the **Add Assigned Categories** option from the `Data` dimension's context menu (not available for `Gauge`, `Year over year` or `Single value`).

## Adding more axes

When combining data with different measurement scales you will get a more meaningful visualization by having more than a single axis. For `Column`, `Bar`, `Area` and `Line` you can do so by clicking the **Series tab** in the `Options` dialog. If the option is disabled, make sure that the `Data` dimension is on the `Series` axis and that at least two items have been added.

Four axes are available, two on the left side (axis 1 and 3) of the chart and two on the right side (axis 2 and 4).
Each axis has a different color and the chart items are going to be colored accordingly.

Note: When multiple axes are in use, some options like `Lines`, `Vertical (y) axis` and `Color set` in the other option tabs will be disabled.

![](resources/images/data-visualizer/data-visualizer-series-tab-multi-axis.png)

## Using multiple visualization types

It's possible to combine a `Column` chart with `Line` items and vice versa. This is done by clicking the **Series tab** in the `Options` dialog and changing the `Visualization type`. This can also be combined with using multiple axes (as described in the section above).

![](resources/images/data-visualizer/data-visualizer-series-tab-multi-axis-multi-type.png)

This results in a chart that combines the `Column` and `Line` types.

![](resources/images/data-visualizer/data-visualizer-multi-type-chart.png)

## Data drilling

This feature is enabled for the `Pivot Table` visualization type and allows to drill in the data by clicking on a value cell in the table. A contextual menu opens with various options.

You can drill the data by organisation unit, meaning navigating up and down the org unit tree. The data drill affects the current dimension selection in the layout area.

![](resources/images/data-visualizer/data-visualizer-pt-drill.png)

## Manage saved visualizations

Saving your visualizations makes it easy to find them later. You can also choose to share them with other users or display them on a dashboard.

### Open a visualization

1.  Click **File** \> **Open**.

2.  Enter the name of a visualization in the search field, or click the **<** and **>** arrows to navigate between different pages. The result can also be filtered by type and owner by using the corresponding menus in the top right corner.

3.  Click the name of the one you want to open.

![](resources/images/data-visualizer/data-visualizer-open-dialog.png)

### Save a visualization

1. a) Click **File** \> **Save**.

2. Enter a **Name** and a **Description** for your visualization.

3. Click **Save**.

![](resources/images/data-visualizer/data-visualizer-save-dialog.png)

### Rename a visualization

1.  Click **File** \> **Rename**.

2.  Enter the new name and/or description.

3.  Click **Rename**.

![](resources/images/data-visualizer/data-visualizer-rename-dialog.png)

### Delete a visualization

1.  Click **File** \> **Delete**.

2.  Click **Delete**.

### Get the link to the visualization

1. Click **File** \> **Get Link**.

2. The URL can be copied via the browser's context menu that opens when right clicking on the link.

![](resources/images/data-visualizer/data-visualizer-delete-dialog.png)

## Visualization interpretations

When viewing a saved visualization, you can expand the interpretations on the right side by clicking on the Interpretations button in the upper right corner. The visualization description will also be shown. The description supports rich text format.

New interpretations can be added by typing in the text field in the bottom right corner. Other users can be mentioned with `@username`. Start by typing `@` plus the first letters of the username or real name and a list of matching users will be displayed. Mentioned users will receive an internal DHIS2 message with the interpretation or comment. Interpretations can also be seen in the **Dashboard** app.

It is possible to format the text with **bold**, _italic_ by using the Markdown style markers `*` and `_` for **bold** and _italic_ respectively (keyboard shortcuts are also available: `Ctrl`/`Cmd` + `B` and `Ctrl`/`Cmd` + `I`). A limited set of emojis is supported and can be used by typing one of the following character combinations: `:)` `:-)` `:(` `:-(` `:+1` `:-1`. URLs are automatically detected and converted into a clickable link.

To view the visualization according to the date of a particular interpretation, click on the interpretation or its `View` button. This will regenerate the visualization with the relevant date, which is indicated next to the visualization title. Clicking on `Back to all interpretations` will regenerate the visualization with the current date.

To subscribe to the saved visualization, click the bell icon in the upper right corner. You will then receive internal messages whenever another user likes/creates/updates an interpretation in this saved visualization.

![](resources/images/data-visualizer/data-visualizer-view-interpretation.png)

## Share a visualization

Sharing settings can be accessed by clicking **File** \> **Share**. Change sharing settings for the user groups you want to modify, the available settings are:

- **Can edit and view**: Can view and edit the visualization.

- **Can view only**: Can only view the visualization.

- **No access**: Won't have access to the visualization. This
  setting is only applicable to **Public access** and **External access**.

New users can be added by searching for them by name under `Add users and user groups`.

![](resources/images/data-visualizer/data-visualizer-share-dialog.png)

## Download

Visualizations can be downloaded using the **Download** menu. All visualization types support `Graphics` and `Plain data source` downloads, except for the `Pivot table` type, which can be downloaded as `Table layout` and `Plain data source`.

### `Graphics` download

Downloads an image (.png) or a PDF (.pdf) file to your computer.

### `Table layout` download

Downloads a Excel (.xls), CSV (.csv) or HTML (.html) file to your computer.

### `Plain data source` download

You can download the data source of a visualization in JSON, XML, Excel,
CSV, JXRML or Raw data SQL formats with different identification schemes
(ID, Code, and Name). The data document uses identifiers of the
dimension items and opens in a new browser window to display the URL of
the request to the Web API in the address bar. This is useful for
developers of apps and other client modules based on the DHIS2 Web API
or for those who require a plan data source, for instance for import
into statistical packages.

**Available formats**

|Format|Action|Description|
|--- |--- |------ |
|JSON|Click JSON|Downloads JSON format based on the ID, Code or Name property.|
|XML|Click XML|Downloads XML format based on the ID, Code or Name property.|
|Microsoft Excel|Click Microsoft Excel|Downloads Microsoft Excel format based on the ID, Code or Name property.|
|CSV|Click CSV|Downloads CSV format based on the ID, Code or Name property.|
|XML data value set|Click Advanced > XML|Downloads the raw data values as XML, as opposed to data which has been aggregated along various dimensions.|
|JSON data value set|Click Advanced > JSON|Downloads the raw data values as JSON, as opposed to data which has been aggregated along various dimensions.|
|JRXML|Click Advanced > JRXML|Produces a template of a Jasper Report which can be further customized based on your exact needs and used as the basis for a standard report in DHIS 2.|
|Raw data SQL|Click Advanced > Raw data SQL|Provides the actual SQL statement used to generate the data visualization. You can use it as a data source in a Jasper report, or as the basis for a SQL view.|


## See visualization as map

To see how a visualization would look on map, select the `Open as Map` Visualization type after you're finished building your visualization.

![](resources/images/data-visualizer/data-visualizer-open-as-map.png)
