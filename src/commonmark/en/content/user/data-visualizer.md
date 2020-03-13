# Using the Data Visualizer app

<!--DHIS2-SECTION-ID:data_visualizer-->

![](resources/images/data-visualizer/data-visualizer-overview.png)

## Creating and editing visualizations

When you open the data-visualizer app from the dhis2 menu, you are presented with a blank slate and you can start creating your visualization right away.

![](resources/images/data-visualizer/data-visualizer-new.png)

### Select visualization type

Select the desired visualization type from the selector in the upper left corner:

![](resources/images/data-visualizer/data-visualizer-visualization-type.png)

<br/>
<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Visualization type</p></th>
<th><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Column</p></td>
<td><p>Displays information as vertical rectangular columns with lengths proportional to the values they represent.</p>
<p>Useful when you want to, for example, compare performance of different districts.</p></td>
</tr>
<tr class="even">
<td><p>Stacked column</p></td>
<td><p>Displays information as vertical rectangular columns, where bars representing multiple categories are stacked on top of each other.</p>
<p>Useful when you want to, for example, display trends or sums of related data elements.</p></td>
</tr>
<tr class="odd">
<td><p>Bar</p></td>
<td><p>Same as column, only with horizontal bars.</p></td>
</tr>
<tr class="even">
<td><p>Stacked bar</p></td>
<td><p>Same as stacked column, only with horizontal bars.</p></td>
</tr>
<tr class="odd">
<td><p>Line</p></td>
<td><p>Displays information as a series of points connected by straight lines. Also referred to as time series.</p>
<p>Useful when you want to, for example, visualize trends in indicator data over multiple time periods.</p></td>
</tr>
<tr class="even">
<td><p>Area</p></td>
<td><p>Is based on a line (above), with the space between the axis and the line filled with colors and the lines stacked on top of each other.</p>
<p>Useful when you want to compare the trends of related indicators.</p></td>
</tr>
<tr class="odd">
<td><p>Pie</p></td>
<td><p>Circle divided into sectors (or slices).</p>
<p>Useful when you want to, for example, visualize the proportion of data for individual data elements compared to the total sum of all data elements.</p></td>
</tr>
<tr class="even">
<td><p>Radar</p></td>
<td><p>Displays data on axes starting from the same point. Also known as spider chart.</p></td>
</tr>
<tr class="odd">
<td><p>Gauge</p></td>
<td><p>Semi-circle which displays values out of 100 %.</p></td>
</tr>
<tr class="even">
<td><p>Year over year (line)</p></td>
<td><p></p></td>
</tr>
<tr class="odd">
<td><p>Year over year (column)</p></td>
<td><p></p></td>
</tr>
<tr class="even">
<td><p>Single value</p></td>
<td><p></p></td>
</tr>
<tr class="odd">
<td><p>Pivot table</p></td>
<td><p></p></td>
</tr>
</tbody>
</table>
<br/>

### Select dimensions

From the dimension menu on the left you can select the dimension you want to show in your visualization, including data, period, organisation units and dynamic dimensions. These can be added by clicking on a dimension, by dragging and dropping a dimension to the layout area or by hovering over a dimension and using on its' context menu (three dots).

![](resources/images/data-visualizer/data-visualizer-dimensions.png)

Just like in the dimensions menu, in the layout area you can also change the selections by clicking on a dimension, dragging and dropping a dimension or by using a dimension's context menu (three dots).

![](resources/images/data-visualizer/data-visualizer-layout-area.png)

- Series: A series is a set of continuous, related elements (for
  example periods or data elements) which you want to visualize in
  order to emphasize trends or relations in its data. Also known as Columns for Pivot table visualizations.

<!-- end list -->

- Categories: A category is a set of elements (for example indicators
  or organisation units) for which you want to compare its data. Also known as Rows for Pivot table visualizations.

<!-- end list -->

- Filter: The filter selection will filter the data displayed in the
  visualization. Note that if you use the data dimension as filter, you can
  only specify a single indicator or data set as filter item, whereas
  with other dimension types you can select any number of items.

### Select dimension items

<!--DHIS2-SECTION-ID:data_vis_select_dim_items-->

A dimension refers to the elements which describe the data values in the system. There are three main dimensions in the system:

- Data: Includes data elements, indicators and datasets (reporting
  rates), describing the phenomena or event of the data.

<!-- end list -->

- Periods: Describes when the event took place.

<!-- end list -->

- Organisation units: Describes where the event took place.

Data Visualizer lets you use these dimensions completely flexible in terms of appearing as series, categories and filter.

To select items for each one, open the dimension modal window by clicking on a dimension. This window will also be opened automatically when adding a dimension with out items to the layout. Select which items to add to the visualization by double-clicking an item or by selecting an item with a single click and using the arrows in the middle. The order of appearance will be the same as the order in which they are selected. Selected items can be reordered by dragging and dropping them in the Selected section.

![](resources/images/data-visualizer/data-visualizer-dimension-modal.png)

#### Select periods

When selecting a Period you have to option to choose between fixed periods and relative periods. These can also be combined. Overlapping periods are filtered so that they only appear once. For relative periods the names are relative to the current date, e.g. if the current month is March and **Last month** is selected, the month of February is added.

![](resources/images/data-visualizer/data-visualizer-period-dimension-modal.png)

#### Select organisation units

NEEDS INFO

![](resources/images/data-visualizer/data-visualizer-organisation-unit-dimension-modal.png)

## Adding more axes

When combining data with different measurement scales you will get a more meaningful visualization by having more than a single axis. For "column", "bar" and "line" charts you can do so by clicking "Manage chart axes" in the Data dimension's context menu. If the option is disabled, make sure that the Data dimension is on the Series axis and that at least two items have been added.

![](resources/images/data-visualizer/data-visualizer-axis-management-menu-option.png)

In the axis management dialog you can assign data items to the two axes.

![](resources/images/data-visualizer/data-visualizer-axis-management-dialog.png)

## Viewing visualization interpretations

When viewing a visualization, you can expand the interpretations on the right
side by clicking on the Interpretations button in the upper right corner.
The visualization description will also be shown. The description supports rich text format.

To view the visualization according to the date of a particular interpretation,
click on the interpretation or its "View" button. This will regenerate the visualization with the
relevant date, which is indicated next to the visualization title.

![](resources/images/data-visualizer/data-visualizer-view-interpretation.png)

Clicking on "Back to all interpretations" or the "Exit View" button inside the interpretations panel will clear the
interpretation and regenerate the visualization with the current date.

## See visualization as map

Sometimes it can be useful to see how visualization would look like on map. To achieve this you can select "Open as Map" visualization type after you build your visualization.

![](resources/images/data-visualizer/data-visualizer-open-as-map.png)
