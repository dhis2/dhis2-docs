# Using the Maps app

<!--DHIS2-SECTION-ID:using_maps-->

## About the Maps app

<!--DHIS2-SECTION-ID:about_maps-->

The Maps App is introduced in release 2.29 and serves as a replacement
of the GIS App offering a more intuitive and user-friendly interface.

With the Maps app you can overlay multiple layers and choose among
different base maps. You can create thematic maps of areas and points,
view facilities based on classifications, and visualize catchment areas
for each facility. You can add labels to areas and points, and search
and filter using various criteria. You can move points and set locations
on the fly. Maps can be saved as favorites and shared with other users
and groups.

> **Note**
>
> To use predefined legends in the **Maps** app, you need to create them
> first in the **Maintenance** app.

![](resources/images/maps/maps_main.png)

  - The **layer panel** on the left side of the workspace shows an
    overview of the layers for the current map:

      - As layers are added, using the (+) Add layer button, they are
        arranged and managed in this panel.

      - The **basemap** is always shown in the panel. The default
        basemap is OSM Light and is selected by default. OpenStreetMap
        Detailed, Google Streets and Google Hybrid are also available.
        You can use these maps as background maps and layers. Switch
        between them by selecting the desired image.

      - The small arrow button to the right of the layer panel, at the
        top, allows the panel to be hidden or shown.

<!-- end list -->

  - The **Favorites** button near the top left allows you to save and
    open maps:

      - New  
      
        will clear any existing map layers to create a new thematic map.

      - Open  
      
        will display a **Favorites** dialog to select an existing
        thematic map. Favorites can also be renamed, shared and deleted
        through the Favorites dialog. *The title of the current favorite
        is displayed in the header bar above the Favorites button.*

      - Save  
    
        will save any changes to the current favorite.

      - Save as  
      
        will save the current thematic map as a new favorite.

      - Write interpretation  
      
        will open a dialog where an interpretation for the current favorite can be written.

      - Get link  
      
        will provide a direct link and API link to the current favorite.

<!-- end list -->

  - The **+** and **-** buttons on the map allow you to zoom in and out
    of the map respectively. The mouse scroll wheel can also be used for
    altering the zoom.

  - **Zoom to content** (bounded magnifying glass symbol) automatically
    adjusts the zoom level and map center position to put the data on
    your map in focus.

  - **Search** (magnifying glass symbol) allows searching for and
    jumping to a location on the map.

  - The **ruler** button allows you to find the distance between two
    locations on the map.

  - To view information for an event, simply click the event.

  - Right-click on the map to display the longitude and latitude of that
    location.

  - The home icon on the top right of the workspace will take you back
    to the DHIS2 dashboard.

  - The About button will display system version information.

**Basemaps**

Basemap layers are represented by layer *cards* in the layer panel such
as:


![](resources/images/maps/maps_basemap_card.png)

Along the top of the basemap card from left to right are:

  - The title of the selected basemap

  - An eye symbol for toggling the visibility of the layer

  - An arrow symbol to collapse and expand the basemap card

In the middle of the basemap card is the list of available basemaps. The
current basemap is highlighted.

Along the bottom of the basemap card is:

  - A slider for modifying the layer transparency

## Create a new map

<!--DHIS2-SECTION-ID:using_maps_create_map-->

1.  In the **Apps** menu, click **Maps**. The **DHIS2 Maps** window
    opens.

2.  Click the (+) Add layer button in the top left. You are presented
    with the layer selection dialog:

    ![](resources/images/maps/maps_layer_selection.png)

3.  Select a layer to add to the current map. Possible options are:

      - [Events](#using_maps_event_layer)

      - [Facilities](#using_maps_facility_layer)

      - [Thematic](#using_maps_thematic_layer)

      - [Boundaries](#using_maps_thematic_layer)

    In addition, there are several layers provided by Google Earth
    Engine and other services:

      - Population density

      - Elevation

      - Temperature

      - Precipitation

      - Landcover

      - Nighttime lights

    *Labels overlay* is an [external
    layer](#using_maps_external_map_layers) defined in the database used
    for the above example

## Manage event layers

<!--DHIS2-SECTION-ID:using_maps_event_layer-->

The event layer displays the geographical location of events registered
in the DHIS2 tracker. Provided that events have associated GPS
coordinates, you can use this layer to drill down from the aggregated
data displayed in the thematic layers to the underlying individual
events or cases.

You can also display aggregated events at the facility or at the
boundary level. You do this through a thematic layer using event data
items. This is useful when you only have the coordinates for the Org
Unit under which the events are recorded.

![](resources/images/maps/maps_event_layer.png)

Event layers are represented by layer *cards* in the layer panel such
as:

Along the top of the event card from left to right are:

  - A grab field to allow dragging and re-ordering layers with the mouse

  - The title and period associated with the layer

  - An eye symbol for toggling the visibility of the layer

  - An arrow symbol to collapse and expand the event card

In the middle of the event card is a legend indicating the styling of
the layer.

Along the bottom of the event card from left to right are:

  - An edit (pencil) button to open the layer configuration dialog

  - A slider for modifying the layer transparency

  - A delete (trash can) icon to remove the layer from the current
    thematic map.

### Create an event layer

<!--DHIS2-SECTION-ID:maps_create_event_layer-->

To create an event layer, choose **Events** on the **Add
layer**selection. This opens the Events layer configuration dialog.

1.  In the **DATA** tab:

    ![](resources/images/maps/maps_event_layer_dialog_DATA.png)

      - Select a program and then select a program stage. The **Stage**
        field is only shown once a program is selected.

        If there is only one stage available for the selected program,
        the stage is automatically selected.

      - Select a value from the **Coordinate field** for the positions
        shown on the map. By default, "Event location" is selected.
        Depending on the data elements or attributes that belong to a
        program, other coordinates such as "Household position" are
        available.

2.  In the **PERIOD** tab

    ![](resources/images/maps/maps_event_layer_dialog_PERIOD.png)

      - select the time span for when the events took place. You can
        select either a fixed period or a relative period.

          - Fixed period  

            In the **Period** field, select **Start/end dates** and fill
            in a start date and an end date.

          - Relative period  

            In the **Period** field, select one of the relative periods,
            for example **This month** or **Last year**.

3.  In the **FILTER** tab:

    ![](resources/images/maps/maps_event_layer_dialog_FILTER.png)

      - Click ADD FILTER and select an available data item to add a new
        filter to the data set.

          - For data item of type *text* you will get two choices:
            **Contains** implies that the query will match all values
            which contains your search value, and **Is exact** implies
            that only values which is completely identical to your
            search query will be returned.

          - For data item of type *option set*, you can select any of
            the options from the drop down box by using the down-wards
            arrow or by start typing directly in the box to filter for
            options.

        Multiple filters may be added. Click the X on the far right of
        the filter to remove it.

4.  In the **ORG UNITS** tab:

    ![](resources/images/maps/maps_event_layer_dialog_ORG_UNITS.png)

      - Select the organisation units you want to include in the layer.
        It is possible to select either

          - One or more specific organisation units, or

          - A relative level in the organisation unit hierarchy, with
            respect to the user. By selecting a **User organisation
            unit** the map data will appear differently for users at
            different levels in the organisation unit hierarchy.

5.  In the **STYLE** tab:

    ![](resources/images/maps/maps_event_layer_dialog_STYLE.png)

      - Select **Group events** to group nearby events, or **View all
        events** to display events individually.

      - Select a color for the event or cluster points.

      - Select the radius (between 1 and 20) for grouped events; also
        known as **clusters**.

6.  Click **ADD LAYER**.

### Modify an event layer

1.  In the layer panel, click the edit (pencil) icon on the event layer
    card.

2.  Modify the setting on the DATA, PERIOD, FILTER, ORG UNIT and STYLE
    tabs as desired.

3.  Click **UPDATE LAYER**.

### Modify information in event pop-up windows

For events in a cluster map, you can modify the information displayed in
the event pop-up window.


![](resources/images/maps/maps_eventlayer_eventinfopopup.png)

1.  Open the **Programs / Attributes** app.

2.  Click **Program**.

3.  Click the program you want to modify and select **View program
    stages**.

4.  Click the program stage name and select **Edit**.

5.  Scroll down to the **Selected data elements** section.

6.  For every data element you want to display in the pop-up window,
    select corresponding **Display in reports**.

7.  Click **Update**.

### Clear event layer

To clear all event layer data in a map:

1.  In the layer panel, click the delete (trash can) icon on the event
    layer card.

    The layer is removed from the current map.

## Manage facility layers

<!--DHIS2-SECTION-ID:using_maps_facility_layer-->

The facility layer displays icons that represent types of facilities.
Polygons do not show up on the map, so make sure that you select an
organisation unit level that has facilities.

*A polygon is an enclosed area on a map representing a country, a
district or a park.*


![](resources/images/maps/maps_facility_layer.png)

Facility layers are represented by layer *cards* in the layer panel such
as:

Along the top of the facilities card from left to right are:

  - A grab field to allow dragging and re-ordering layers with the mouse

  - The **Facilities** title

  - An eye symbol for toggling the visibility of the layer

  - An arrow symbol to collapse and expand the facilities card

In the middle of the facilities card is a legend indicating the group
set representation.

Along the bottom of the facilities card from left to right are:

  - An edit (pencil) button to open the layer configuration dialog

  - A **data table** toggle button to show or hide the data table
    associated with the layer

  - A slider for modifying the layer transparency

  - A delete (trash can) icon to remove the layer from the current
    thematic map.

### Create a facility layer

To create facility layer, choose **Facilities** on the **Add
layer**selection. This opens the Facility layer configuration dialog.

1.  In the **GROUP SET** tab:

    ![](resources/images/maps/maps_facility_layer_dialog_GROUPSET.png)

      - Select a **Group set** from the list of organisation unit group
        sets defined for your DHIS2 instance.

2.  In the **ORGANISATION UNITS** tab

    ![](resources/images/maps/maps_facility_layer_dialog_ORG_UNITS.png)

      - select the organisation unit level(s) and/or group(s) from the
        selection fields on the right hand side.

      - Select the organisation units you want to include in the layer.
        It is possible to select either

          - One or more specific organisation units, or

          - A relative level in the organisation unit hierarchy, with
            respect to the user. By selecting a **User organisation
            unit** the map data will appear differently for users at
            different levels in the organisation unit hierarchy.

3.  In the **STYLE** tab:

    ![](resources/images/maps/maps_facility_layer_dialog_STYLE.png)

      - select any styling you wish to apply to the facilities.

          - Show labels  

            Allows labels to be shown on the layer. Font size, weight
            and color can be modified here.

          - Show buffer  

            Allows a visual buffer to be displayed on the layer around
            each facility. The radius of the buffer can be modified
            here.

4.  Click **ADD LAYER**.

### Create or modify a facility layer

1.  In the layer panel, click the edit (pencil) icon on the facility
    layer card.

2.  Modify the setting on the GROUP SET, ORGANISATION UNITS and STYLE
    tabs as desired.

3.  Click **UPDATE LAYER**.

### Filter values in a facility layer

Facility layers have a **data table** option that can be toggled on or
off from the facility layer card.

![](resources/images/maps/maps_facility_layer_data_table.png)

The data table displays the data forming the facility layer.

  - clicking on a title will sort the table based on that column;
    toggling between ascending and descending.

  - entering text or expressions into the filter fields below the titles
    will apply those filters to the data, and the display will adjust
    according to the filter. The filters are applied as follows:

      - NAME  

        filter by name containing the given text

      - ID  

        filter by IDs containing the given text

      - TYPE  

        filter by GIS display types containing the given text

> **Note**
>
> Data table filters are temporary and are not saved with the map layers
> as part of the favourite.

### Search for a facility

The NAME filter field in the data table provides an effective way of
searching for individual facilities.

### Remove facility layer

To clear all data in a facility layer:

1.  In the layer panel, click the delete (trash can) icon on the
    facility layer card.

    The layer is removed from the current map.

### Manage facilities in a layer

You can have facilities in **Facility**, **Boundary** and **Thematic**
layers.

#### Relocate a facility

1.  Right-click a facility and click **Relocate**.

2.  Put the cursor in the new location.

    The new coordinate is stored permanently. This cannot be undone.

#### Swap longitude and latitude of a facility

1.  Right-click a facility and click **Swap longitude/latitude**.

    This is useful if a user inverted latitude and longitude coordinates
    when creating the organisation unit.

#### Display facility information

You can view organisation unit information set by the administrator as
follows:

<table>
<caption>View organisation unit information</caption>
<colgroup>
<col width="40%" />
<col width="59%" />
</colgroup>
<thead>
<tr class="header">
<th>Function</th>
<th>Action</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>View information for the current period</p></td>
<td><ol style="list-style-type: decimal">
<li><p>Click a facility.</p></li>
</ol></td>
</tr>
<tr class="even">
<td><p>View information for a selected period</p></td>
<td><ol style="list-style-type: decimal">
<li><p>Right-click a facility and click <strong>Show information</strong>.</p></li>
<li><p>In the <strong>Infrastructural data</strong> section, select a period.</p></li>
</ol>
<blockquote>
<p><strong>Note</strong></p>
<p>You configure the displayed infrastructural data in the <strong>System Settings</strong> app.</p>
</blockquote></td>
</tr>
</tbody>
</table>

## Manage thematic layers

<!--DHIS2-SECTION-ID:using_maps_thematic_layer-->

*Thematic maps* represent spatial variation of geographic distributions.
Select your desired combination of indicator/data element, period and
organisation unit level. If your database has coordinates and aggregated
data values for these organisation units, they will appear on the map.

> **Note**
>
> You must refresh the DHIS2 analytics tables to have aggregated data
> values available.


![](resources/images/maps/maps_thematic_mapping.png)

Thematic layers are represented by layer *cards* in the layer panel such
as:

Along the top of the thematic card from left to right are:

  - A grab field to allow dragging and re-ordering layers with the mouse

  - The title and period associated with the layer

  - An eye symbol for toggling the visibility of the layer

  - An arrow symbol to collapse and expand the thematic card

In the middle of the thematic card is a legend indicating the value
ranges displayed on the layer.

Along the bottom of the thematic card from left to right are:

  - An edit (pencil) button to open the layer configuration dialog

  - A **data table** toggle button to show or hide the data table
    associated with the layer

  - A slider for modifying the layer transparency

  - A delete (trash can) icon to remove the layer from the current
    thematic map.

### Create a thematic layer

To create an event layer, choose **Thematic** on the **Add
layer**selection. This opens the Events layer configuration dialog.

1.  In the **DATA** tab:

    ![](resources/images/maps/maps_thematic_layer_dialog_DATA.png)

      - Select a data type and then select respectively the group and
        the target element. The available fields depend on the type of
        item selected.

      - Select a value from the **Aggregation type** field for the data
        values to be shown on the map. By default, "By data element" is
        selected. Alternative values are: Count; Average; Sum; Standard
        deviation; Variance; Min; Max. See also [Aggregation
        operators](https://dhis2.github.io/dhis2-docs/master/en/user/html/ch10s05.html#d0e8082).

2.  In the **PERIOD** tab

    ![](resources/images/maps/maps_thematic_layer_dialog_PERIOD.png)

      - select the time span over which the thematic data is aggregated.
        You can select either a fixed period or a relative period.

          - Fixed period  

            In the **Period type** field select period length, then
            select the target in the **Period** field.

          - Relative period  

            In the **Period type** field select **Relative**, then
            select one of the relative periods, for example **This
            month** or **Last year**, in the **Period** field.

3.  In the **ORG UNITS** tab:

    ![](resources/images/maps/maps_thematic_layer_dialog_ORG_UNITS.png)

      - Select the organisation units you want to include in the layer.
        It is possible to select either

          - One or more specific organisation units, or

          - A relative level in the organisation unit hierarchy, with
            respect to the user. By selecting a **User organisation
            unit** the map data will appear differently for users at
            different levels in the organisation unit hierarchy.

4.  In the **STYLE** tab:

    ![](resources/images/maps/maps_thematic_layer_dialog_STYLE.png)

      - Select either **Automatic** or **Predefined** legend.

          - Automatic legend types means that the application will
            create a legend set for you based on your what method,
            number of classes, low color and high color you select.
            Method alludes to the size of the legend classes. Set to

              - Equal intervals  

                the range of each interval will be **(highest data value - lowest data value / number of classes)**

            <!-- end list -->

              - Equal counts  

                the legend creator will try to distribute the
                organisation units evenly.

          - If you have facilities in your thematic layer, you can set
            the radius for minimum and maximum values by changing the
            values in the **Low size** and **High size** boxes
            respectively.

5.  Click **ADD LAYER**.

### Modify a thematic layer

1.  In the layer panel, click the edit (pencil) icon on the thematic
    layer card.

2.  Modify the setting on the DATA, PERIOD, ORG UNITS and STYLE tabs as
    desired.

3.  Click **UPDATE LAYER**.

### Filter values in a thematic layer

Thematic layers have a **data table** option that can be toggled on or
off from the thematic layer card.

![](resources/images/maps/maps_thematic_layer_data_table0.png)

The data table displays the data forming the thematic layer.

  - clicking on a title will sort the table based on that column;
    toggling between ascending and descending.

  - entering text or expressions into the filter fields below the titles
    will apply those filters to the data, and the display will adjust
    according to the filter. The filters are applied as follows:

      - NAME  

        filter by name containing the given text

      - VALUE  

        filter values by given numbers and/or ranges, for example:
        2,\>3&\<8

      - LEGEND  

        filter by legend containing the given text

      - RANGE  

        filter by ranges containing the given text

      - LEVEL  

        filter level by numbers and/or ranges, for example: 2,\>3&\<8

      - PARENT  

        filter by parent names containing the given text

      - ID  

        filter by IDs containing the given text

      - TYPE  

        filter by GIS display types containing the given text

      - COLOR  

        filter by color names containing the given text

![](resources/images/maps/maps_thematic_layer_data_table1.png)

> **Note**
>
> Data table filters are temporary and are not saved with the map layers
> as part of the favourite.

### Search for an organisation unit

The NAME filter field in the data table provides an effective way of
searching for individual organisation units.

### Navigate between organisation hierarchies

When there are visible organisation units on the map, you can easily
navigate up and down in the hierarchy without using the level/parent
user interface.

1.  Right-click one of the organisation units.

2.  Select **Drill up one level** or **Drill down one level**.

    The drill down option is disabled if you are on the lowest level or
    if there are no coordinates available on the level below. Likewise
    the drill up option is disabled from the highest level.

### Remove thematic layer

To clear all data in a thematic layer:

1.  In the layer panel, click the delete (trash can) icon on the
    thematic layer card.

    The layer is removed from the current map.

## Manage boundary layers

The boundary layer displays the borders and locations of your
organisation units. This layer is particularly useful if you are offline
and don't have access to background maps.


![](resources/images/maps/maps_bound_layers.png)

Boundary layers are represented by layer *cards* in the layer panel such
as:

Along the top of the boundary card from left to right are:

  - A grab field to allow dragging and re-ordering layers with the mouse

  - The **Boundaries** title

  - An eye symbol for toggling the visibility of the layer

  - An arrow symbol to collapse and expand the boundary card

Along the bottom of the boundary card from left to right are:

  - An edit (pencil) button to open the layer configuration dialog

  - A **data table** toggle button to show or hide the data table
    associated with the layer

  - A slider for modifying the layer transparency

  - A delete (trash can) icon to remove the layer from the current
    thematic map.

### Create a boundary layer

To create boundary layer, choose **Boundaries** on the **Add
layer**selection. This opens the Boundary layer configuration dialog.

1.  In the **ORGANISATION UNITS** tab

    ![](resources/images/maps/maps_boundary_layer_dialog_ORG_UNITS.png)

      - select the organisation unit level(s) and/or group(s) from the
        selection fields on the right hand side.

      - Select the organisation units you want to include in the layer.
        It is possible to select either

          - One or more specific organisation units, or

          - A relative level in the organisation unit hierarchy, with
            respect to the user. By selecting a **User organisation
            unit** the map data will appear differently for users at
            different levels in the organisation unit hierarchy.

2.  In the **STYLE** tab:

    ![](resources/images/maps/maps_boundary_layer_dialog_STYLE.png)

      - select any styling you wish to apply to the boundaries.

          - Show labels  

            Allows labels to be shown on the layer. Font size and weight
            can be modified here.

          - Point radius  

            Sets the base radius when point type elements, such as
            facilities, are presented on the boundary layer.

3.  Click **ADD LAYER**.

### Modify a boundary layer

1.  In the layer panel, click the edit (pencil) icon on the boundary
    layer card.

2.  Modify the setting on the ORGANISATION UNITS and STYLE tabs as
    desired.

3.  Click **UPDATE LAYER**.

### Filter values in a boundary layer

Boundary layers have a **data table** option that can be toggled on or
off from the boundary layer card.

![](resources/images/maps/maps_bound_layer_data_table.png)

The data table displays the data forming the boundary layer.

  - clicking on a title will sort the table based on that column;
    toggling between ascending and descending.

  - entering text or expressions into the filter fields below the titles
    will apply those filters to the data, and the display will adjust
    according to the filter. The filters are applied as follows:

      - NAME  

        filter by name containing the given text

      - LEVEL  

        filter level by numbers and/or ranges, for example: 2,\>3&\<8

      - PARENT  

        filter by parent names containing the given text

      - ID  

        filter by IDs containing the given text

      - TYPE  

        filter by GIS display types containing the given text

> **Note**
>
> Data table filters are temporary and are not saved with the map layers
> as part of the favourite.

### Search for an organisational unit

The NAME filter field in the data table provides an effective way of
searching for individual organisational units displayed in the boundary
layer.

### Navigate between organisation hierarchies

You can modify the target of the boundary layer in the hierarchy without
using the level/parent user interface.

1.  Right-click one of the boundaries.

2.  Select **Drill up one level** or **Drill down one level**.

    The drill down option is disabled if you are on the lowest level.
    Likewise the drill up option is disabled from the highest level.

### Remove boundary layer

To clear all data in a boundary layer:

1.  In the layer panel, click the delete (trash can) icon on the
    boundary layer card.

    The layer is removed from the current map.

## Manage Earth Engine layer

<!--DHIS2-SECTION-ID:using_maps_gee-->


![](resources/images/maps/maps_earth_eng_layer.png)

The Google Earth Engine layer lets you display satellite imagery and
geospatial datasets from Google's vast catalog. These layers is useful
in combination with thematic and event layers to enhance analysis. The
following layers are supported:

  - Population density estimates with national totals adjusted to match
    UN population division estimates. Population in 100 x 100 m grid
    cells (from 2010).

  - Elevation above sea-level. You can adjust the min and max values so
    it better representes the terrain in your region.

  - Temperature: Land surface temperatures collected from satellite.
    Blank spots will appear in areas with a persistent cloud cover.

  - Precipitation collected from satellite and weather stations on the
    ground. The values are in millimeters within 5 days periods. Updated
    monthly, during the 3rd week of the following month.

  - Land cover: 17 distinct landcover types collected from satellites.

  - Nighttime lights: Lights from cities, towns, and other sites with
    persistent lighting, including gas flares (from 2013).

### Create an Earth Engine layer

To create an Earth Engine layer, choose the desired layer from the **Add
layer**selection. This opens the layer configuration dialog.

1.  In the **STYLE** tab

    ![](resources/images/maps/maps_ee_layer_dialog_POPULATION.png)

      - Modify the parameters specific to the layer type.

      - Adjust the legend range, steps and colors, as desired.

2.  Click **ADD LAYER**.

## Add external map layers

<!--DHIS2-SECTION-ID:using_maps_external_map_layers-->

External map layers are represented as either:

  - Basemaps  

    These are available in the **basemap** card in the layers panel and
    are selected as any other basemap.

  - Overlays  

    These are available in the **Add layer** selection. Unlike basemaps,
    overlays can be placed above or below any other overlay layers.

Overlay layers are represented by additional layer *cards* in the layer
panel such as:

Along the top of the overlay card from left to right are:

  - A grab field to allow dragging and re-ordering layers with the mouse

  - The title of the external map layer

  - An eye symbol for toggling the visibility of the layer

  - An arrow symbol to collapse and expand the overlay card

Along the bottom of the overlay card from left to right are:

  - A slider for modifying the layer transparency

  - A delete (trash can) icon to remove the layer from the current
    thematic map.

Here are some examples of external layers:


![](resources/images/maps/maps_black_basemap_and_nighttime_lights.png)

![](resources/images/maps/maps_terrain_imagery.png)

![](resources/images/maps/maps_aerial_imagery.png)

> **Note**
>
> To define external map layers, see the
> [???](#manage_external_maplayer).

## Manage map favorites

<!--DHIS2-SECTION-ID:using_maps_favorites-->

Saving your maps as favorites makes it easy to restore them later. It
also gives you the opportunity to share them with other users as an
interpretation or put it on the dashboard. You can save all types of
layer configurations as a favorite.

### Open a favorite

1.  Select **Open** from the **Favorites** menu.

    The **Favorites** dialog box opens.

2.  Find the favorite you want to open. You can either use **\<** and
    **\>** or the search field to find a saved favorite. The list is
    filtered on every character that you enter.

3.  Click the name to open that favorite.

### Save a map as a new favorite

When you have created a map it is convenient to save it as a favorite:

1.  Select **Save as** from the **Favorites** menu.

    The **Save as new favorite** dialog box opens.

2.  In the text field, type the name you want to give your map favorite.

3.  Click **SAVE**.

    Your favorite is added to the list.

### Overwrite the current favorite

Select **Save** from the **Favorites** menu.

### Rename a favorite

1.  Select **Open** from the **Favorites** menu.

    The **Favorites** dialog box opens.

2.  Find the favorite you want to rename.

    You can either use **\<** and **\>** or the search field to find a
    saved favorite.

3.  Click the more options icon (three dots) at the right of the
    favorite row, and select **Rename**.

    The **Rename favorite** dialog box opens.

4.  Edit the name and/or description.

5.  Click **SAVE**.

    The favorite is updated.

### Delete a favorite

1.  Select **Open** from the **Favorites** menu.

    The **Favorites** dialog box opens.

2.  Find the favorite you want to delete.

    You can either use **\<** and **\>** or the search field to find a
    saved favorite.

3.  Click the more options icon (three dots) at the right of the
    favorite row, and select **Delete**.

    A confirmation dialog is displayed.

4.  Click **DELETE** to confirm that you want to delete the favorite.

### Modify sharing settings for a favorite

After you have created a map and saved it as a favorite, you can share
the favorite with everyone or a user group. To modify the sharing
settings:

1.  Select **Open** from the **Favorites** menu.

    The **Favorites** dialog box opens.

2.  Find the favorite you want to share.

    You can either use **\<** and **\>** or the search field to find a
    saved favorite.

3.  Click the more options icon (three dots) at the right of the
    favorite row, and select **Share**.

    The **Sharing settings** dialog box opens.

4.  In the text box, search for the name of the user or group you want
    to share your favorite with and select it.

    The chosen user or group is added to the list of recipients.

    Repeat the step to add more user groups.

5.  If you want to allow external access, select the corresponding box.

6.  For each user group, choose an access setting. The options are:

      - None (for default groups only, as they cannot be removed)

      - Can view

      - Can edit and view

7.  Click **CLOSE** to close the dialog.

### Share a map interpretation

<!--DHIS2-SECTION-ID:mapsInterpretation-->

For certain analysis-related resources in DHIS2, you can share a data
interpretation. An interpretation is a link to the relevant resource
together with a text expressing some insight about the data.

To create an interpretation of a map and share it with all users of the
system:

1.  Select **Write interpretation** from the **Favorites** menu.

    The **Write interpretation** dialog box opens.

2.  In the text field, type a comment, question or interpretation.

3.  Click **SAVE**.

    The dialog box closes automatically. You can see the interpretation
    on the **Dashboard**.

## Save a map as an image

<!--DHIS2-SECTION-ID:using_maps_image_export-->

1.  Take a screenshot of the map with the tool of your choice.

2.  Save the screenshot in desired format.

## Search for a location

<!--DHIS2-SECTION-ID:using_maps_search-->

The place search function allows you to search for almost any location
or address. This function is useful in order to locate for example
sites, facilities, villages or towns on the map.


![](resources/images/maps/maps_place_search.png)

1.  On the right side of the Maps window, click the magnifier icon.

2.  Type the location you're looking.

    A list of matching locations appear as you type.

3.  From the list, select a location. A pin indicates the location on
    the map.

## Measure distances and areas in a map

<!--DHIS2-SECTION-ID:using_maps_measure_distance-->

1.  In the upper left part of the map, put the cursor on the **Measure
    distances and areas** (ruler) icon and click **Create new
    measurement**.

2.  Add points to the map.

3.  Click **Finish measurement**.


![](resources/images/maps/maps_measure_distance.png)

## Get the latitude and longitude at any location

<!--DHIS2-SECTION-ID:using_maps_latitude_longitude-->

Right-click a point on the map and select **Show longitude/latitude**.
The values display in a pop-up window.

## See also

  - [Manage
    legends](https://docs.dhis2.org/master/en/user/html/manage_legend.html)
