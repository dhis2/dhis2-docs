# Using the Capture app { #capture_app } 

## About the Capture app { #about_capture_app } 

> **Note**
>
> The Capture app serves as a replacement for the Event Capture app. In the future, the Tracker Capture app and the Data Entry app will also be incorporated into the Capture app.

In the Capture app you register events that occurred at a particular time and place. An event can happen at any given point in time. This stands in contrast to routine data, which is captured for predefined, regular intervals. Events are sometimes called cases or records. In DHIS2, events are linked to a program. The Capture app lets you select the organisation unit and program and specify a date when an event happened, before entering information for the event.

## Register an event { #capture_register_event } 

1. Open the **Capture** app.

2. Select an organisation unit.

3. Select a program.

    You will only see programs associated with the selected organisation unit and programs you have access to, and that are shared with your user group through data level sharing.

4. If the program has a category combination set the category option will have to be selected.

5. Click **New**.

    ![create new event](resources/images/capture_app/create_new_event.png)

6. Fill in the required information. If the programs program stage is configured to capture a location:

    - If the field is a coordinate field you can either enter the coordinates
    directly or you can click the **map** icon to the left of the coordinate field.
    The latter one will open a map where you can search for a location or set on
    directly by clicking on the map.

    - If the field is a polygon field you can click the **map** icon to the left of
    the field. This will open a map where you can search for a location and capture
    a polygon (button in the upper right corner of the map).

7. If desired you can add a comment by clicking the **Write comment** button at the bottom of the form.

8. If desired you can add a relationship by clicking the **Add relationship** button at the bottom of the form.
   See the section about **Adding a relationship** for more information.

9. Click **Save and exit** or click the arrow next to the button to select **Save and add another**.

    - **Save and add another** will save the current event and clear the form.
    All the events that you have captured will be displayed in a list at the bottom of the page.
    When you want to finish capturing events you can, if the form is blank,
    click the finish button or if your form contains data click the arrow
    next to **Save and add another** and select **Save and exit**.

> **Note**
>
> Some data elements in an event might be mandatory (marked with a red star next to the data element label).
> All mandatory data elements must be filled in before the user is allowed to complete the event.
> The exception to this is if the user has the authority called __"Ignore validation of required fields in Tracker and Event Capture".__
> If the user has this authority, the mandatory data elements will not be required and
> the red star will not be displayed next to the data element label. Note that super user that have the __"ALL"__ authority automatically
> have this authority.

> **Tip**
>
> The data entry form can also be displayed in **row view**. In this mode the data elements are arranged horizontally. This can be
> achieved by clicking the **Switch to row view** button on the top right of the data entry form. If you are currently in **row view** you
> can switch to the default form view by clicking the **Switch to form view** button on the top right of the data entry form.

## Register a tracked entity instance

There are two different ways one can register a tracked entity instance under an organisation unit.
The first way, is to register a tracked entity instance without enrolling it to a tracker program.
The second option, is to register a tracked entity instance with program and enroll it. 

### Without a program enrollment 

1. Open the **Capture** app.

2. Select an organisation unit.

3. Click the "New" button.

    ![image](resources/images/capture_app/register-without-enrollment-new-button.png)

    You'll now be navigated to the registration page. In that page you will see a drop down 
    menu similar to the one in the image below. From the dropdown menu you can select a tracked entity 
    type, eg. Building, Person etc.
    
    ![image](resources/images/capture_app/register-without-enrollment-dropdown-menu.png)

4. Select the tracked entity type which you want to create a new instance for.
 
    ![image](resources/images/capture_app/register-without-enrollment-dropdown-menu-with-arrow.png)
    
5. The moment you select a tracked entity type, a form will be shown on the screen. 
    
    The "Profile" section will be shown. In this section you can add data relevant to the 
    tracked entity instance. The profile section mainly contains all the tracked entity attributes
    linked to the tracked entity type. 

    ![image](resources/images/capture_app/register-without-enrollment-form.png)

6. Fill in the required information.

    If the tracked entity type is configured to capture a location:

    - If the field is a coordinate field you can either enter the coordinates
    directly or you can click the **map** icon to the left of the coordinate field.
    The latter one will open a map where you can search for a location or set on
    directly by clicking on the map.

    - If the field is a polygon field you can click the **map** icon to the left of
    the field. This will open a map where you can search for a location and capture
    a polygon (button in the upper right corner of the map).

7. Click the **Save new** button to register the tracked entity instance.
    
8. You will now be prompted to the tracked entity instance dashboard. 

    The dashboard will show relevant information about the newly created tracked entity instance.

### With a program enrollment

1. Open the **Capture** app.

2. Select an organisation unit.

3. Select a tracker program of your choice similar to the image below.

    ![create new event](resources/images/capture_app/register-and-enroll-program-selection.png)

4. Click the "New" dropdown button and then click the first option. 

    The first option will look something similar to the image below. 
    The text in our example is "New person in Child programme". 
    Clicking this option will prompt you to the registration and enrollment 
    page of the program you selected. 
    ![create new event](resources/images/capture_app/register-and-enroll-dropdown-button-new-person-in-program.png)
 
5. Now, you will be able to see a form similar to the image below. 

    The enrollment form has different layouts depending on how the program is customized. The top section has the title "Enrollment",
    and it holds all the relevant information about the enrollment details. This section will always be present, regardless of layout.
    Underneath, the different data input fields relevant to the tracked entity instance will be displayed. 
    These fields will either be displayed within sections or as a completely custom form. 
    The sections, or custom form, mainly contains all the tracked entity attributes linked to the program or tracked entity type.

      ![create new event](resources/images/capture_app/register-and-enroll-form.png)

6. Fill in the required information for the enrollment.
    If the tracked entity type is configured to capture a location:

    - If the field is a coordinate field you can either enter the coordinates
    directly or you can click the **map** icon to the left of the coordinate field.
    The latter one will open a map where you can search for a location or set on
    directly by clicking on the map.

    - If the field is a polygon field you can click the **map** icon to the left of
    the field. This will open a map where you can search for a location and capture
    a polygon (button in the upper right corner of the map).

7. Click **Save new** to register the tracked entity instance.
    
8. You will now be prompted to the tracked entity instance dashboard. 

    The dashboard will show relevant information about the newly created tracked entity instance.

> **Note**
>
> Some data elements in an event might be mandatory (marked with a red star next to the data element label).
> All mandatory data elements must be filled in before the user is allowed to complete the event.
> The exception to this is if the user has the authority called __"Ignore validation of required fields in Tracker and Event Capture".__
> If the user has this authority, the mandatory data elements will not be required and
> the red star will not be displayed next to the data element label. Note that super user that have the __"ALL"__ authority automatically
> have this authority.

> **Tip**
>
> The data entry form can also be displayed in **row view**. In this mode the data elements are arranged horizontally. This can be
> achieved by clicking the **Switch to row view** button on the top right of the data entry form. If you are currently in **row view** you
> can switch to the default form view by clicking the **Switch to form view** button on the top right of the data entry form.

### Enrollment with auto generated events 

A program can be configured to have zero or more program stages which are automatically generated upon a new enrollment. 
These stages will be auto generated based on the metadata configuration, as explained below.

To configure the auto generation of an event you need to take the following steps. 
1. Open the maintenance app

2. Select the Program tab
![](resources/images/capture_app/auto-generated-01.png)

3. Select a Tracker program
![](resources/images/capture_app/auto-generated-02.png)

4. Select the Program stages tab
![](resources/images/capture_app/auto-generated-03.png)

5. Click on the stage you would like to configure
![](resources/images/capture_app/auto-generated-04.png)

6. Mark the stage as Auto-generated
![](resources/images/capture_app/auto-generated-05.png)

Now, for every new enrollment in this program one event will be auto generated. One program can also have multiple stages marked as auto generated.
For all the auto generated events 

 a) the organisation unit will be the same as the user is reporting for, during the enrollment and 
 
 b) all the events will be part of the current enrollment. 
 
Based on configuration, the status of the auto generated event can either be ACTIVE or SCHEDULE.

#### Active type of event

If the stage has the "Open data entry form after enrollment" selected, then the event will be generated into the ACTIVE status. Also its execution date will be calculated for the event, in addition to a due date.
The generation happens based on either the enrollment date or the incident date. You can choose the reporting date from the dropdown menu "Report date to use".
![](resources/images/capture_app/auto-generated-06.png)

As shown in the image you have three options, a) Incident date b) Enrollment date or c) No value. 
Choosing reporting date as "Incident date" indicates that both the event execution date and due date will be the same as the incident date.
Choosing reporting date as either "Enrollment date" or "No value" indicates that both the event execution date and due date will be the same as the enrollment date.

#### Schedule type of event

When the "Open data entry after enrollment" is not checked, it means that the event generated will be a SCHEDULE event. 
The scheduled event does not have an execution date, but only a due date. The due date for these future events are calculated based on either enrollment date or incident date. If the flag below is checked, the reference date is the enrollment date, if the flag is not checked, the incident date is used.
![](resources/images/capture_app/auto-generated-07.png)

When there is no incident date, the reference date will fall back on the enrollment date regardless of whether the flag above is checked.

On SCHEDULE type of events the user can also configure the "Scheduled days from start". Which means if a stage has a number in "Scheduled days from start" the reference date will increased by that number. 
In the example below we increase the due date by 30 days.
![](resources/images/capture_app/auto-generated-08.png)

When the "Scheduled days from start" does not contain a number or contains 0 the reference date is used without adding any days to it.


### Possible duplicates detection

In both cases of registering a tracked entity instance, (with enrollment or without enrollment) the system will warn you for possible duplicates.
Note that, programs need to be correctly configured through the maintenance app for the duplicates warning to appear. 

To configure a program through the maintenance app you will have to: 


1. Open the maintenance app.
![](resources/images/capture_app/duplicates-maintenance-config-00.png)

2. In the program section select your program. We select Child Programme for this example.
![](resources/images/capture_app/duplicates-maintenance-config-01.png)

3. Select the Attributes tab.
![](resources/images/capture_app/duplicates-maintenance-config-02.png)

4. Enable duplicates search by checking program attributes as searchable
![](resources/images/capture_app/duplicates-maintenance-config-03.png)


The attributes you have selected as "Searchable" will be the ones which the system will use to detect possible duplicates against.  
Let us explain this with an example that demonstrates the detection of possible duplicates while enrolling a child in the Child Programme. 

1. Open the **Capture** app.
![](resources/images/capture_app/duplicates-on-creation-00.png)

2. Select your organisation unit and program from the menu on the top.
![](resources/images/capture_app/duplicates-on-creation-01.png)

3. Click "New" -> "New person in Child Programme"
![](resources/images/capture_app/duplicates-on-creation-02.png)

4. Fill in the first name in the form. **Remember, the first name we have checked as "Searchable" in the maintenance app.** 
It is because we have checked the first name as "Searchable" that the system will start looking for possible 
duplicates that match the name Sarah as you see in the image below.
![](resources/images/capture_app/duplicates-on-creation-03.png)

5. Click the link with text "Possible duplicates"
![](resources/images/capture_app/duplicates-on-creation-04.png)

6. View the possible duplicates
![](resources/images/capture_app/duplicates-on-creation-05.png)

> **Tip**
>
> You can configure duplicates detection for tracked entity types the same way as we did for programs. 


### Program rules execution

In both cases of registering a tracked entity instance, (with enrollment or without enrollment) the system will run program rules you have configured.
Note that, rules can be configured in the maintenance app.

To see a rule being executed while enrolling a tracked entity instance you will have to take the following steps. 

1. Configure a rule in the maintenance app. For the example below we configured a rule that throws a warning when the date of birth is less than a year.

2. Open the **Capture** app.
![](resources/images/capture_app/duplicates-on-creation-00.png)

3. Select your organisation unit and program from the menu on the top.
![](resources/images/capture_app/program-rules-on-creation-00.png)

4. Fill in the date of birth with a value which is less than a year. In our case this is 27th of January 2021. 
![](resources/images/capture_app/program-rules-on-creation-01.png)

5. You will now be able to see the warning produced by the program rule underneath the birth date field. 
![](resources/images/capture_app/program-rules-on-creation-02.png)


## Adding a relationship { #capture_add_relationship } 

Relationships can be added either during registration, editing or viewing of an event.
Currently the **Capture App** only supports *Event to Tracked Entity Instance* relationships.

1. While in an event, click **Add relationship**.

2. Select the relationship type you want to create.

You now have two options: 

- **Link to an existing Tracked Entity Instance** or 

- **Create new Tracked Entity Instance**.

![relationship options](resources/images/capture_app/relationship_options.png)

### Link to an existing Tracked Entity Instance

1. Click **Link to an existing Tracked Entity Instance**.

- You will be presented with some options for searching for a **Tracked Entity Instance**.
  You have the option to select a **program**. If a **program** is selected the attributes are derived from the selected **program**.
  If no **program** is selected, only the attributes that belong to the **Tracked Entity Instance** will be visible.

    ![search for Tracked Entity Instance](resources/images/capture_app/search_tei.png)

    - If the **Tracked Entity Instance** or **program** is configured with a unique attribute, this attribute can be
      used for finding a specific **Tracked Entity Instance** or **program**. This attribute should be presented alone.
      When the unique attribute field has been filled out, click the **Search** button located right below
      the unique attribute field.

    - If the **Tracked Entity Instance** or **program** has attibutes these can be used for searching by expanding the **Search by attributes** box.
      When all desired attribute fields have been filled out, click the **Search by attributes** button located at the bottom. You can also limit the search by setting the **Organisation unit scope**. If set to *All accessible* you will search for the **Tracked Entity Instance** in all organisation units you have access to. If you select *Selected*, you will be asked to select which organisation units to search within.

2. After a successful search you will be presented with a list of **Tracked Entity Instances** matching the search criteria.
   To create a relationship click the **Link** button on the **Tracked Entity Instance** you would like to create a relationship to.

- If you did not find the **Tracked Entity Instance** you were looking for, you can either click the **New search** or **Edit search** buttons.
  **New search** will take you to new blank search while **Edit search** will take you back to the search you just performed keeping the search criteria.

### Create new Tracked Entity Instance

1. Click **Create new Tracked Entity Instance**.

- You are now presented with a form for registering a new **Tracked Entity Instance**. You can choose to either register with or without a program.
  If a program is selected, the new **Tracked Entity Instance** will be enrolled in said program. You can also change the **Organisation unit** by removing the one that is automatically set and selecting a new one.

  ![register new Tracked Entity Instance](resources/images/capture_app/register_tei.png)

2. Fill in the desired (and possibly mandatory) attributes and enrollment details.

3. Click **Create Tracked Entity Instance and Link**.

> **Note**
>
> When filling in data you might face a warning telling you that a possible duplicate has been found. You can click the warning to see these
> duplicates and if the duplicate is a match you can choose to link that **Tracked Entity Instance** by clicking the **Link** button.
> If the warning is still present when you are done filling in data, you will not see the **Create Tracked Entity Instance and Link** button.
> Instead you will be presented with a button called **Review duplicates**. When you click this button a list of possible duplicates will be displayed.
> If any of these duplicates matches the **Tracked Entity Instance** you are trying to create you can click the **Link** button, if not you can click
> the **Save as new person** button to register a new **Tracked Entity Instance**.


## Edit an event { #capture_edit_event } 

1. Open the **Capture** app.

2. Select an organisation unit.

3. Select a program.

    All events registered to the selected program show up in a list.

4. Click the event you want to modify.

5. Click the **Edit event** button.

6. Modify the event details and click **Save**.

## Delete an event { #capture_delete_event } 

1. Open the **Capture** app.

2. Select an organisation unit.

3. Select a program.

    All events registered to the selected program show up in a list.

4. Click the **triple dot** icon on the event you want to delete.

5. In the menu that is displayed click **Delete event**.

    ![delete event](resources/images/capture_app/delete_event.png)

## Modify an event list layout { #capture_modify_event_list_layout } 

You can select which columns to show or hide in an event list. This can
be useful for example when you have a long list of data elements
assigned to a program stage.

1. Open the **Capture** app.

2. Select an organisation unit.

3. Select a program.

    All events registered to the selected program show up in a list.

4. Click the **gear** icon on the top right of the event list.

5. Select the columns you want to display and click **Save**.

    ![modify event list](resources/images/capture_app/modify_event_list.png)

> **Tip**
>
> You can reorganize the order of the data elements by draging and dropping them in the list.

## Filter an event list { #capture_filter_event_list } 

1. Open the **Capture** app.

2. Select an organisation unit.

3. Select a program.

    All events registered to the selected program show up in a list.

    Along the top of the event list are buttons with the same names as the column headers in the list.

4. Use the buttons on the top of the list to filter based on a report date or a specific data element.

    ![filter event](resources/images/capture_app/filter_event.png)

> **Note**
>
> Different data element types are fitered in different ways. A **Number** data element will for instance show a rang to filter on while a **Text** data element will ask you to enter a search query to filter on.

## Sort an event list { #capture_sort_event_list } 

1. Open the **Capture** app.

2. Select an organisation unit.

3. Select a program.
    All events registered to the selected program show up in a list.

4. Click one of the column headers to sort the list on that data element in ascending order.

    A small upward arrow is displayed next to the column to show that the list is sorted in ascending order.

5. Click the column header again to sort the list on that data element in descending order.

    A small downward arrow is displayed next to the column to show that the list is sorted in descending order.

    ![sort event](resources/images/capture_app/sort_event.png)

## Download an event list { #capture_download_event_list } 

1. Open the **Capture** app.

2. Select an organisation unit.

3. Select a program.
    All events registered to the selected program show up in a list.

4. Click the **downward arrow** icon on the top right of the event list.

5. Select the format you want to download.

    ![download event list](resources/images/capture_app/download_event_list.png)

> **Note**
>
> You can download an event list in JSON, XML or CSV formats.

## Predefined list views { #capture_views } 

You can set up your own views and save them for later use. The views can also be shared with others. A view consists of filters, column order and event sort order.

### Saving a new view { #capture_view_save } 

1. Select an organisation unit and a program.

2. Set filters using the filter buttons above the event list (described in detail [here](#capture_filter_event_list)).

    ![](resources/images/capture_app/view_save_filters.png)

3. Set the column order by clicking the cog icon and then, in the pop-up, specify the layout according to your preference (how to modify the layout is described in detail [here](#capture_modify_event_list_layout)).

    ![](resources/images/capture_app/view_save_column_order.png)

4. Sort the events by clicking on one of the column headers (described in detail [here](#capture_sort_event_list)).

    ![](resources/images/capture_app/view_save_sort_order.png)

5. Open the more menu (three dots icon) to the right and then select "Save current view..."

    ![](resources/images/capture_app/view_save_menu.png)

6. Fill in a name for the view and click save.

    ![](resources/images/capture_app/view_save_name.png)

### Loading a view { #capture_view_load } 

1. Select an organisation unit and a program with a predefined view.

2. The views should be available above the event list itself. Click on a view to load it.

    ![](resources/images/capture_app/view_load_unselected.png)

3. An example of a loaded view.

    ![](resources/images/capture_app/view_load_selected.png)

### Updating a view { #capture_view_update } 

1. Load the view you would like to update (see [loading a view](#capture_view_load)).

2. Make your changes to filters, column order and/or event sort order.

    > **Note**
    >
    > An asterisk(*) is appended to the view name when the view has unsaved changes.

3. Open the more menu (three dots icon) to the right and then select "Update view".

    ![](resources/images/capture_app/view_update.png)

### Sharing a view { #capture_view_share } 

1. Load the view you would like to share (see [loading a view](#capture_view_load)).

2. Open the more menu (three dot icon) to the right and then select "Share view..."

    ![](resources/images/capture_app/view_share.png)

3. Make your changes. You would typically add users/groups (1) and/or change the access rights of users/groups added earlier (2).

    ![](resources/images/capture_app/view_share_access.png)

### Deleting a view { #capture_view_delete } 

1. Load the view you would like to delete (see [loading a view](#capture_view_load)).

2. Open the more menu (three dots icon) to the right and then select "Delete view".

    ![](resources/images/capture_app/view_delete.png)

## User assignment { #capture_user_assignment } 

Events can be assigned to users. This feature must be enabled per program.

### Assigning new events { #capture_user_assignment_new } 

1. Select an organisation unit and a program with user assignment enabled.

2. Click **New Event** in the upper right corner.

3. You will find the assignee section near the bottom of the data entry page. Search for and select the user you would like to assign the event to. The assignee will be preserved when you save the event.

    ![](resources/images/capture_app/user_assignment_new.png)

    ![](resources/images/capture_app/user_assignment_new_filled.png)

### Change assignee { #capture_user_assignment_edit } 

1. Select an organisation unit and a program with user assignment enabled.

2. Click an event in the list

3. In the right column you will find the assignee section.

    ![](resources/images/capture_app/user_assignment_edit.png)

4. Click the edit button, or the **Assign** button if the event is not currently assigned to anyone.

    ![](resources/images/capture_app/user_assignment_edit_button.png)

    ![](resources/images/capture_app/user_assignment_edit_add.png)

5. Search for and select the user you would like to reassign the event to. The assignment is saved immediately.

### Assignee in the event list { #capture_user_assignment_event_list } 

In the event list you will be able to view the assignee per event. Moreover, you can sort and filter the list by the assignee.

#### Filter by assignee

1. Click the **Assigned to** filter.

    ![](resources/images/capture_app/user_assignment_event_list.png)

2. Select your preferred assignee filter and then click update.

    ![](resources/images/capture_app/user_assignment_event_list_options.png)

## Tracker programs { #capture_tracker_programs } 

The Capture app does not support tracker programs yet, but the tracker programs are still listed. If you select a tracker program, the app will lead you to the Tracker Capture app as shown below.

![](resources/images/capture_app/tracker_program.png)


## Search for tracked entity instances

### In Program scope

1. Open the **Capture** app.

2. Select a program.

    You will only see programs associated with the selected organisation unit and programs you have access to, and that are shared with your user group through data level sharing.

3. If the program has a category combination set the category option will have to be selected.

4. Click the Find button.

5. From the dropdown menu click the first option.

    ![](resources/images/capture_app/search-by-attributes-find-button.png)

    These steps will take you to the search page. There, based on the configuration of your organisation, will see the different attributes you can search with. An example of how this looks is the following.

    ![](resources/images/capture_app/search-by-attributes-on-scope-program-overview-0.png)

    To execute a search now:

1. Fill in the attributes you want to search with.

2. Click the **Search by attributes** button.

    ![](resources/images/capture_app/search-by-attributes-on-scope-program-overview-1.png)

3. The results of the search will be displayed as follows.

    ![](resources/images/capture_app/search-by-attributes-on-scope-program-overview-2.png)

    In this list you can see the entries that match your search. For each entry you can have a total of three options.

    a. You can choose to view the dashboard for the **Tracked Entity Instance** by clicking the "View dashboard" button

    ![](resources/images/capture_app/search-by-attributes-on-scope-program-overview-5.png)

    b. You can view the the active enrollment of a **Tracked Entity Instance** by clicking the "View active enrollment" button

    ![](resources/images/capture_app/search-by-attributes-on-scope-program-overview-3.png)

    c. You can re-enroll a **Tracked Entity Instance** to the current program you are searching within.

    ![](resources/images/capture_app/search-by-attributes-on-scope-program-overview-4.png)


#### Fallback search

Execute a full search as described above. If the search you have made has results they will be displayed. However, the actual **Tracked Entity Instance** you are searching for may be within a different program. In that case, you may want to extend the search to other programs. This is known as a fallback search.

To execute a fallback search, simply press the button on the bottom saying "Search in all programs".

> **Note**
>
> The fallback search is only possible when searching within a Program.

![](resources/images/capture_app/search-by-attributes-fallback-overview-0.png)

### In Tracked entity type scope

1. Open the **Capture** app.

2. Click the **Find** button to open the search page.

3. Click on the drop down menu and select the type of entity you want to search for.

    ![](resources/images/capture_app/search-by-attributes-domain-selector-overview-0.png)

4. Make a selection from the list.

    ![](resources/images/capture_app/search-by-attributes-domain-selector-overview-1.png)

    Based on the configuration of your organisation you will see the different attributes you can search with. An example of how this looks is the following.

    ![](resources/images/capture_app/search-by-attributes-on-scope-tetype-overview-0.png)

    To execute a search now:

1. Fill in the attributes you want to search with.

2. Click the Search by attributes button.

    ![](resources/images/capture_app/search-by-attributes-on-scope-tetype-overview-1.png)

3. The results of the search will be displayed as follows.

    ![](resources/images/capture_app/search-by-attributes-on-scope-tetype-overview-2.png)

    In this list you can see the entries that match your search. For each entry you have the option to click the "View Dashboard" button to view the dashboard for the **Tracked Entity Instance**.


### Too many results functionality

The program or tracked entitiy type you are searching within may be configured with a limit on the number of results that are retrurned from a search. If your search results exceed this limit you will be shown a warning message like the one below.

![](resources/images/capture_app/search-by-attributes-on-scope-program-overview-too-many-results-message.png)

### Pagination

The results page shows up to five results at a time. You should try to use specific search criteria so that there are not too many matches. However, if there are more than five results, you can see the next results by using the **>** button at the end of the page.

![](resources/images/capture_app/search-by-attributes-on-scope-program-overview-pagination.png)

## List tracked entity instances enrolled in program

1. Open the **Capture** app.

2. Select an organisation unit.

3. Select a tracker program.

4. The program can have categories associated with it (implementing partner would be an example of such a category). If this is the case, fill them in.

### Filter the list

Use the buttons above the list itself to filter it.

![](resources/images/capture_app/tei_list_filters.png)

As an example, you could filter the list to show only tracked entity instances where you have been assigned an event: Click the "Assigned to" filter (1), select "Me" (2) and then "Apply" the changes (3).

![](resources/images/capture_app/tei_list_filter_example.png)

### Sort the list

Click one of the column headers to sort the list by that column. A small arrow is displayed next to the column header to indicate the current sort order. Click again to change between ascending and descending order.

![](resources/images/capture_app/tei_list_sort_order.png)

### Modify the list layout

You can select which columns to show in the list and also reorganize the order of the columns.

Click the **gear** icon in the top right corner of the list. Tick the checkboxes for the the columns you would like to display (1) and reorgainze the columns by dragging and dropping (2).

![](resources/images/capture_app/tei_list_column_layout.png)

### Loading a predefined list view

You will find the predefined list views above the filters for the list. Click to load a view. 

![](resources/images/capture_app/tei_list_predefined_views.png)

## Implementer / administrator info { #implementer_info } 

### Metadata caching { #metadata_caching } 

For performance reasons the Capture app caches metadata in the client browser. When metadata is updated on the server the changes needs to be propagated to the clients that have already cached the metadata. Depending on the change, this is done in one of three ways:

1. If the change is bound to a program you will need to increase the program version for that particular program. For example, if you change the data elements in a program or a program rule, the version for the bound program needs be increased.

2. If the change is NOT bound to a program you will need to increase ANY program version for the change to be propagated to the clients. Examples here are changes to constants, organisation unit levels or organisation unit groups.

3. The exception to the two rules above is option sets. Option sets have their own version property, i.e. increasing the option set version should ensure the option set metadata are propagated to the clients.


## Enrollment dashboard

### Reaching the enrollment dashboard via url

You reach the enrollment dashboard either by typing in the address bar of your browser or using the user interface of the capture app.
In this section we are focusing on the first use-case, where you type or paste the url you want to access in the Address bar.

![](resources/images/capture_app/enrollment-dash-01.png)

One way to reach the enrollment dashboard and view a specific tracked entity instance's enrollment is by using _only_ the enrollment id. For example the link .../dhis-web-capture/#/?enrollmentId=wBU0RAsYjKE will 
take you the dashboard for the enrollment with id `wBU0RAsYjKE`. 

The top of the dashboard defines your context. For example in the image below the context is as follows, the selected program is "Child Programme", the organisation unit is "Ngelehun CHC", the selected person is "Anna Jones" and the selected enrollment is "2017-11-16 11:38".

![](resources/images/capture_app/enrollment-dash-02.png)

You can change your context by clicking the "x" button.

![](resources/images/capture_app/enrollment-dash-03.png)

#### Deselecting the program

When you deselect the program you see the following

![](resources/images/capture_app/enrollment-dash-05.png)

##### Selecting a program with enrollments

When program _and_ enrollment selections are empty, you first have to select a program. 
If the tracked entity instance (in this case "Anna Jones") has enrollments under the program you select you will see the following message.

![](resources/images/capture_app/enrollment-dash-09.png)

##### Selecting a program with zero enrollments

If the tracked entity instance (in this case "Anna Jenkins") does not have enrollments under the program you select you will see a message explaining that there are no enrollments for that program.
You will also be given the option to enroll "Anna Jenkins" in that program.

![](resources/images/capture_app/enrollment-dash-10.png)

##### Selecting an event program 

When you select an event program you will see the following. (Remember event programs do not have enrollments in the system, only tracker programs do).

![](resources/images/capture_app/enrollment-dash-11.png)

You will also be given the option to either create a new event for the selected program or view the working lists for the selected program.

##### Selecting a program with a different tracked entity type 

When your selected tracked entity type is a person, as in our example with Anna Jenkins, and you select a program that is not of type person but for example of a type Malaria case you will see the following.

![](resources/images/capture_app/enrollment-dash-12.png)

You are also given the option to enroll a tracked entity instance in the program you selected.

#### Deselecting the organisation unit

When you deselect the organisation unit you see the following

![](resources/images/capture_app/enrollment-dash-06.png)

#### Deselecting the tracked entity instance

When you deselect the tracked entity instance, in this case "Anna Jones" you are taken to the working lists in that Tracker program.

![](resources/images/capture_app/enrollment-dash-07.png)

#### Deselecting the enrollment

When you deselect the enrollment you see the following

![](resources/images/capture_app/enrollment-dash-08.png)

### Enrollment widget

On the enrollment page you can see the enrollment widget

![](resources/images/capture_app/enrollment-dash-enrollment-widget-1.png)

#### Enrollment actions

When you click on the enrollment actions button, a menu with all the available actions will open. You can change the enrollment status to Active, Canceled or Completed using the buttons in the menu. You can mark or remove the enrollment for a follow-up.

![](resources/images/capture_app/enrollment-dash-enrollment-widget-2.png)

#### Delete the enrollment

You can delete the enrollment by clicking the delete button and confirming the action in the modal. 

![](resources/images/capture_app/enrollment-dash-enrollment-widget-3.png)

#### Enrollment comment widget

![](resources/images/capture_app/enrollment-widget-comment.png)

The enrollment comment widget displays comments and allows addition of comments, associated with the current enrollment. 

By clicking in the text field, you will be able to enter new text and see action buttons **Save comment** and **Cancel**.

#### Person profile widget

On the enrollment dashboard, you can view the Person Profile widget.

![](resources/images/capture_app/enrollment-dash-tei-profile-widget.png)

The Person profile widget is used for viewing key attributes but not for editing. In order to edit the person profile, you must select the `Edit` button to open an edit window. 


### Feedback widget

![](resources/images/capture_app/enrollment-dash-feedback-widget-1.png)

On the enrollment dashboard, the feedback widget displays text and values that are triggered by certain conditions. 
If the current dashboard triggers some rules set up in the program, the text or values will be automatically displayed.

#### Empty state
If there isn't any feedback for the current dashboard, the widget shows a short _empty_ message.
If there aren't any program rules that could show feedback for the current dashboard then the widget is hidden.


### Indicator widget

![](resources/images/capture_app/enrollment-dash-indicator-widget-1.png)

On the enrollment dashboard, the indicator widget displays indicator text and values output related to the current dashboard.
The indicators will be sorted alphabetically.

#### Empty state
If there aren't any related indicators or indicator output for the current dashboard, the widget shows a short _empty_ message.
If the current dashboard can't show any indicator output (because it has no related indicators) then the widget is hidden.

#### Legends
Some indicator values show a colored circle next to the value. 
The colored circle shows the related legend color for that indicator value. 
Colored legend circles are only shown for indicator values that have them set up.


### Warning widget

![](resources/images/capture_app/enrollment-dash-warning-widget-1.png)

On the enrollment dashboard, the warning widget displays warnings related to the current dashboard. The widget shows warnings that are not associated with any specific data item.
If there aren't any warnings to show for the current dashboard then the widget is hidden.


## Enrollment event view and edit page

You can reach the enrollment event form by typing in the address bar of your browser. You have to specify the `programId`, `orgUnitId`, `teiId`, `enrollmentId`, `stageId` and `eventId`

![](resources/images/capture_app/enrollment-event-view-edit-url.png)

### Event Comment Widget

![](resources/images/capture_app/event-widget-comment.png)

The event comments widget displays and allows the addition of comments related to the currently selected event. The widget is displayed in the right sidebar when both viewing and editing events.

### Error Widget

![](resources/images/capture_app/enrollment-dash-error-widget-1.png)

On the enrollment dashboard, the errors widget displays errors related to the current dashboard. The widget shows errors that are not associated with any specific data item.
If there aren't any errors to show for the current dashboard then the widget is hidden.

### View/Edit event form 

This is the form where you can see and edit the enrollment event details.

#### Form header 

In the view/edit event form you can see the stage name and icon.

![](resources/images/capture_app/enrollment-event-view-edit-header.png)
