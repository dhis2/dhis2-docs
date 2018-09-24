# Configure programs in the Programs/Attributes app (legacy app)

<!--DHIS2-SECTION-ID:configure_programs_in_legacy_app-->

> **Note**
> 
>   - You create program indicators and program rules in the
>     **Maintenance** app. It's no longer possible to create program
>     indicators and program rules in the legacy **Program /
>     Attributes** app.
> 
>   - You can create event programs (programs without registration) in
>     the **Maintenance** app. The old version of this functionality is
>     also available in the legacy **Program / Attributes** app.

## About programs

<!--DHIS2-SECTION-ID:about_program_legacy_app-->

There are three type of programs:

  - Multi events with registration program (MEWR):
    
    Used for programs with many stages, for example Mother Health
    Program with stages such as ANC Visit (2-4+), Delivery, PNC Visit.

  - Single event with registration program (SEWR):
    
    Used for birth certificate and death certificate. This type of
    programs have only one stage. An TEI just can enroll into the
    program one time.

  - Single event without registration program (anonymous program or
    SEWoR):
    
    Used for saving health cases without registering any information
    into the system. This type of programs have only one stage.

A program must be specified with only one tracked entity. Only tracked
entity as same as the tracked entity of program can enroll into that
program.

A program needs several types of metadata that you create in the
**Program / Attributes** and **Maintenance** apps.

<table>
<caption>Program metadata objects in the Program / Attributes app</caption>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Object type</p></th>
<th>Description</th>
<th><p>Available functions</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Program</p></td>
<td><p>A program consist of program stages.</p></td>
<td><p>Create, edit, share, delete, assign to organisation units, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Program stage</p></td>
<td><p>A program stage defines which actions should be taken at each stage.</p></td>
<td><p>Create, edit, change sort order, delete, show details and translate</p></td>
</tr>
<tr class="odd">
<td><p>Program stage section</p></td>
<td><p>N/A</p></td>
<td><p>Create, edit, change sort order, delete, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Program indicator group</p></td>
<td><p>A group of program indicators</p></td>
<td><p>Create, edit, delete, show details and translate</p></td>
</tr>
<tr class="odd">
<td><p>Validation rule</p></td>
<td><p>A validation rule is based on an expression which defines a relationship between data element values.</p></td>
<td><p>Create, edit and delete</p></td>
</tr>
<tr class="even">
<td><p>Program notification</p></td>
<td><p>Automated message reminder</p>
<p>Set reminders to be automatically sent to enrolled tracked entity instances before scheduled appointments and after missed visits.</p></td>
<td><p>Create, edit and delete</p></td>
</tr>
<tr class="odd">
<td><p>Program stage notification</p></td>
<td><p>-</p></td>
<td><p>Create, edit and delete</p></td>
</tr>
<tr class="even">
<td><p>Design custom registration form</p></td>
<td><p>-</p></td>
<td><p>-</p></td>
</tr>
</tbody>
</table>

<table>
<caption>Program metadata objects in the Maintenance app</caption>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Object type</p></th>
<th>Description</th>
<th><p>Available functions</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Event program</p></td>
<td><p>A single event without registration program</p></td>
<td><p>Create, edit, share, delete, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Program indicator</p></td>
<td><p>An expression based on data elements and attributes of tracked entities which can be used to calculate values based on a formula.</p></td>
<td><p>Create, edit, share, delete, show details and translate</p></td>
</tr>
<tr class="odd">
<td><p>Program rule</p></td>
<td><p>Allows you to create and control dynamic behavior of the user interface in the <strong>Tracker Capture</strong> and <strong>Event Capture</strong> apps.</p></td>
<td><p>Create, edit, delete, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Relationship type</p></td>
<td><p>Defines the relationship between tracked entity A and tracked entity B, for example mother and child.</p></td>
<td><p>Create, edit, clone, delete, show details and translate</p></td>
</tr>
<tr class="odd">
<td><p>Tracked entity</p></td>
<td><p>Types of entities which can be tracked through the system. Can be anything from persons to commodities, for example a medicine or a person.</p>
<p>A program must have one tracked entity. And entity registered must be specified an tracked entity. To enrol a tracked entity instance into a program, the tracked entity of an entity and tracked entity of a program must be the same.</p></td>
<td><p>Create, edit, clone, delete, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Tracked entity attribute</p></td>
<td><p>Used to register extra information for a tracked entity.</p>
<p>Can be shared between programs.</p></td>
<td><p>Create, edit, clone, share, delete, show details and translate</p></td>
</tr>
</tbody>
</table>

To learn how you create program metadata in the Maintenance app, see
[Configure programs in the Maintenance
app](https://docs.dhis2.org/master/en/user/html/configure_programs_in_Maintenance_app.html)

## Manage programs

<!--DHIS2-SECTION-ID:manage_program-->

### Create a program

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click **Add new**.

3.  Enter program details:
    
    1.  Enter a program **Name**.
    
    2.  Enter a **Short name**.
    
    3.  Enter a **Description** of the program.
    
    4.  Select a **Type**.
    
    5.  Select a **Tracked entity**.
    
    6.  Select a **Combination of categories**.
    
    7.  Select a **Data approval workflow**.
    
    8.  Select if you want to **Display front page list**.
    
    9.  Select if **First stage appears on registration page**.
    
    10. Enter number of **Completed events expiry days**.
        
        Defines the number of days for which you can edit a completed
        event. This means that when an event is completed and the
        specified number of expiry days has passed, the event is locked.
        
        If you set "Completed events expiry days" to 10", an event is
        locked ten days after the completion date. After this date you
        can no longer edit the event.
    
    11. Select an **Expiry period type** and enter number of **Expiry
        days**.
        
        The expiry days defines for how many days after the end of the
        previous period, an event can be edited. The period type is
        defined by the expiry period type. This means that when the
        specified number of expiry days has passed since the end date of
        the previous period, the events from that period are locked.
        
        If you set the expiry type to "Monthly" and the expiry days to
        "10" and the month is October, then you can't add or edit an
        event to October after the 10th of November.

4.  Enter enrollment details:
    
    1.  Select if you want to **Allow future enrollment dates**.
    
    2.  Select if you want to **Allow future incident dates**.
    
    3.  If you want a tracked entity to be able to enroll only once in a
        program, select **Only enroll once (per tracked entity instance
        lifetime)**
        
        This setting is useful for example in child vaccination or
        post-mortem examination programs where it wouldn't make sense to
        enroll a tracked entity more than once.
    
    4.  Select if you want to **Show incident date**.
        
        This setting allows you to show or hide the incident date field
        when a tracked entity enroll in the program.
    
    5.  Enter a **Description of incident date**.
        
          - In an immunization program for child under 1 year old, the
            incident date is the child's birthday,
        
          - In a maternal program, the incident date is the date of last
            menstrual period.
    
    6.  Enter a **Description of enrollment date**.
        
        The date when a tracked entity is registered to the system.
    
    7.  Select if you want to **Capture coordinates**.

5.  Enter relationship shortcut details:
    
    1.  Select a **Relationship** type.
        
        When a baby is born, you can register the baby and enroll
        him/her into the Child program from the "Delivery" event of the
        mother. After that, create a relationship as Mother/Child for
        this mother and the baby.
    
    2.  Enter a **Shortcut link label**.
        
        The shortcut link label is displayed in Relation tab in the
        tracked entity instance (TEI) dashboard.
    
    3.  Select **Who is the new relative to the existing entity?**.
    
    4.  Select the **Program for new relative to be enrolled in**.
        
        Specify a program that new relatives of the tracked entity will
        be enrolled in

6.  Select if you want to **Skip generation of events that are overdue
    (before enrollment date)**.
    
    When a tracked entity enrolls into the program, the events
    corresponding to the program stages are created. If you select this
    field, the system will not generate overdue events.

7.  Assign tracked entity attributes.
    
    1.  In the list of **Available attributes**, double-click the
        attributes you want to assign to the program.
    
    2.  For each assigned attribute, review the settings. You can
        select:
        
          - Display in list
            
            This is the required field. Verify that at least one
            attribute has this property.
        
          - Mandatory
        
          - Date in future

8.  Click **Add**.

### Assign a program to organisation units

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the program you want to modify and select **Assign program to
    organisation units**.

3.  Select organisation units.

4.  Click **Save**.

### Edit programs

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the program you want to modify and select **Edit**.

3.  Modify the options you want.

4.  Click **Update**.

### Change sharing settings for programs

To set the authority for sharing a program:

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the program you want to modify and select **Sharing
    settings**.

3.  (Optional) Add a user group:
    
    1.  Search for a user group and select it.
    
    2.  Click the plus icon.
        
        The user group is added to the list.

4.  (Optional) If you want to allow external access, select **External
    access (without login)**.

5.  Change the settings for the user groups you want to modify.
    
      - **None**: The program is private. Only the user who created it
        can see and use it.
    
      - **Can view**: Everyone in the user group can view the program.
    
      - **Can edit and view**: Everyone in the user group can view and
        edit the program.

6.  Click **Save**.

### Delete programs

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the relevant program and select **Remove**.

3.  Click **OK** to confirm.

### Display programs

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the relevant program and select **Show details**.

### Translate program names

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the relevant program and select **Translate**.

3.  Select a locale.

4.  Type a **Name**, **Short name** and **Description**.

5.  Click **Save**.

## Manage program stages

<!--DHIS2-SECTION-ID:manage_program_stage-->

### About program stages

A program consist of program stages. A program stage defines which
actions should be taken at each stage.

### Create a program stage

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the program you want to add a program stage to and select
    **View program stages**.
    
    A list of existing stages for the selected program opens. If the
    program doesn't have any program stages, the list is empty.

3.  Click **Add new**.

4.  Enter program stage details:
    
    1.  Enter a **Name**.
    
    2.  (Optional) select a **Color** and an **Icon** that will be used
        by the data capture apps to identify this program stage.
    
    3.  Enter a **Description**.
    
    4.  In the **Scheduled days from start** field, enter the minimum
        number of days to wait for starting the program stage.

5.  Enter repeatable program stage details.
    
    1.  Specify if the program stage is **Repeatable** or not.
    
    2.  Select a **Period type**.
    
    3.  Enter **Standard interval days**.
        
        The number of days to repeat the repeatable program stage.
    
    4.  Clear **Display generate event box after completed** if you
        don't want to display *Create new event box* to create new event
        for a repeatable stage after you click *Complete* for an event
        of the stage in data entry form. This field is select by
        default.

6.  Enter form details.
    
    <table>
    <colgroup>
    <col width="50%" />
    <col width="50%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th><p>Option</p></th>
    <th><p>Action</p></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><p><strong>Auto-generate event</strong></p></td>
    <td><p>Clear check box to prevent creating an event of this program stage automatically when a entity enroll in the program.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Open data entry form after enrollment</strong></p></td>
    <td><p>Select check box to automatically open the event of this stage as soon as the entity has enrolled into the program.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Report date to use</strong></p></td>
    <td>If you have selected the <strong>Open data entry form after enrollment</strong> check box, also select a <strong>Report date to use</strong>: <strong>Date of incident</strong> or <strong>Date of enrollment</strong>.
    <p>This is the date used as report date for an event that has been opened automatically.</p>
    <p>If the <strong>Report date to use</strong> is selected as one of those two ('incident date'/'enrollment date'), in Dashboard, the 'Report date' of the event will be set as one of those two.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Block entry form after completed</strong></p></td>
    <td><p>Select check box to block the entry form after completion of the event of this stage.</p>
    <p>This means that the data in the entry form can't be changed until you reset the status to incomplete.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Ask user to complete program when stage is completed</strong></p></td>
    <td><p>Select check box to trigger a pop-up which asks the user if he/she wants to create the event of next stage.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Ask user to create new event when stage is complete</strong></p></td>
    <td><p>Select check box to trigger a pop-up which asks the users if he/she wants to create a new event of this stage when an event of this stage is completed.</p>
    <p>This property is active only if you have selected <strong>Repeatable</strong>.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Generate events by enrollment date</strong></p></td>
    <td><p>Check on it for auto-generating due dates of events from program-stages of this program based on the enrollment date. If it is not checked, the due dates are generated based on incident date.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Capture coordinates</strong></p></td>
    <td>Select check box to capture an event's coordinates.
    <p>Many types of events may be recorded at a facility or be <em>owned-by</em> a health worker at a facility, but actually take place somewhere in the community.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Complete allowed only if validation passes</strong></p></td>
    <td><p>Select check box to enforce that an event created by this program stage is only completed when all validation rules have passed.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Pre-generate event UID</strong></p></td>
    <td><p>Select check box to pre-generate unique event id numbers.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Description of report date</strong></p></td>
    <td><p>Type a description of the report date.</p>
    <p>This description is displayed in the case entry form.</p></td>
    </tr>
    </tbody>
    </table>

7.  Assign data elements:
    
    1.  In the list of **Available data elements**, double-click the
        data elements you want to assign to the program stage.
    
    2.  For each assigned data element, review the properties. You can
        select:
        
        <table>
        <colgroup>
        <col width="50%" />
        <col width="50%" />
        </colgroup>
        <thead>
        <tr class="header">
        <th><p>Option</p></th>
        <th><p>Description</p></th>
        </tr>
        </thead>
        <tbody>
        <tr class="odd">
        <td><p><strong>Compulsory</strong></p></td>
        <td><p>The value of this data element must be filled into data entry form before completing the event.</p></td>
        </tr>
        <tr class="even">
        <td><p><strong>Allow provided elsewhere</strong></p></td>
        <td><p>Specify if the value of this data element comes from other facility, not in the facility where this data is entered.</p></td>
        </tr>
        <tr class="odd">
        <td><p><strong>Display in reports</strong></p></td>
        <td><p>Display the value of this data element into the single event without registration data entry function.</p></td>
        </tr>
        <tr class="even">
        <td><p><strong>Date in future</strong></p></td>
        <td><p>Allow to select a date in future for date data elements.</p></td>
        </tr>
        </tbody>
        </table>

8.  Click **Add**.

### Create a program stage section

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the program you want to add a program stage section to and
    select **View program stages**.
    
    A list of existing stages for the selected program opens. If the
    program doesn't have any program stages, the list is empty.

3.  Click a program stage and select **Section management**.

4.  Click **Add new**.

5.  Enter a program stage section **Name**.

6.  In the list of **Available data elements**, double-click the data
    elements you want to assign to the program stage section.

7.  In the list of **Available indicators**, double-click the indicators
    you want to assign to the program stage section.

8.  Click **Add**.

### Change program stage sort order

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the relevant program and select **View program stages**.
    
    A list of existing stages for the selected program opens. If the
    program doesn't have any program stages, the list is empty.

3.  Click **Sort order**.

4.  Modify the order of the program stages with the up and down arrows.

5.  Click **Save**.

### Change program stage section sort order

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the relevant program and select **View program stages**.
    
    A list of existing stages for the selected program opens. If the
    program doesn't have any program stages, the list is empty.

3.  Click a program stage and select **Section management**.

4.  Click **Sort order**.

5.  Modify the order of the program stage sections with the up and down
    arrows.

6.  Click **Save**.

### Edit program stages

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the relevant program and select **View program stages**.
    
    A list of existing stages for the selected program opens. If the
    program doesn't have any program stages, the list is empty.

3.  Click the program stage you want to modify and select **Edit**.

4.  Modify the options you want.

5.  Click **Update**.

### Display program stages

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the relevant program and select **View program stages**.
    
    A list of existing stages for the selected program opens. If the
    program doesn't have any program stages, the list is empty.

3.  Click the program stage you want to display and select **Show
    details**.

### Translate program stages

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the relevant program and select **View program stages**.
    
    A list of existing stages for the selected program opens. If the
    program doesn't have any program stages, the list is empty.

3.  Click the program stage you want to modify and select **Translate**.

4.  Select a locale.

5.  Type a **Name**.

6.  Click **Save**.

## Manage program notifications

<!--DHIS2-SECTION-ID:manage_program_notification-->

### About program notifications

You can create program notifications for programs with registration and
their program stages. The notifications are sent either via the internal
DHIS2 messaging system, via e-mail or via text messages (SMS). You can
use program notifications to, for example, send an automatic reminder to
a tracked entity 10 days before a scheduled appointment. You use the
program’s tracked entity attributes (for example first name) and program
parameters (for example enrollment date) to create a notification
template.

In the **Parameters** field, you'll find a list of available tracked
entity attributes and the following program parameters:

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Notification type</p></th>
<th><p>Variable name</p></th>
<th><p>Variable code</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Program</p></td>
<td><p>Current date</p></td>
<td><pre><code>V{current_date}</code></pre></td>
</tr>
<tr class="even">
<td></td>
<td><p>Days since enrollment date</p></td>
<td><pre><code>V{days_since_enrollment_date}</code></pre></td>
</tr>
<tr class="odd">
<td></td>
<td><p>Enrollment date</p></td>
<td><pre><code>V{enrollment_date}</code></pre></td>
</tr>
<tr class="even">
<td></td>
<td><p>Incident date</p></td>
<td><pre><code>V{incident_date}</code></pre></td>
</tr>
<tr class="odd">
<td></td>
<td><p>Organisation unit name</p></td>
<td><pre><code>V{org_unit_name}</code></pre></td>
</tr>
<tr class="even">
<td></td>
<td><p>Program name</p></td>
<td><pre><code>V{program_name}</code></pre></td>
</tr>
<tr class="odd">
<td></td>
<td><p>Tracked Entity Attributes</p></td>
<td><pre><code>A{pWEEfUJUjej}</code></pre></td>
</tr>
<tr class="even">
<td><p>Program stage</p></td>
<td><p>Current date</p></td>
<td><pre><code>V{current_date}</code></pre></td>
</tr>
<tr class="odd">
<td></td>
<td><p>Days since due date</p></td>
<td><pre><code>V{days_since_due_date}</code></pre></td>
</tr>
<tr class="even">
<td></td>
<td><p>Days until due date</p></td>
<td><pre><code>V{days_until_due_date}</code></pre></td>
</tr>
<tr class="odd">
<td></td>
<td><p>Due date</p></td>
<td><pre><code>V{due_date}</code></pre></td>
</tr>
<tr class="even">
<td></td>
<td><p>Organisation unit name</p></td>
<td><pre><code>V{org_unit_name}</code></pre></td>
</tr>
<tr class="odd">
<td></td>
<td><p>Program name</p></td>
<td><pre><code>V{program_name}</code></pre></td>
</tr>
<tr class="even">
<td></td>
<td><p>Program stage name</p></td>
<td><pre><code>V{program_stage_name}</code></pre></td>
</tr>
<tr class="odd">
<td></td>
<td><p>Data Element</p></td>
<td><pre><code>#{X8zyunlgUfM}</code></pre></td>
</tr>
</tbody>
</table>

### Create a program notification

![](resources/images/program/what_to_send.png)

![](resources/images/program/where_to_send.png)

![](resources/images/program/who_to_send.png)

1.  Open the **Maintenance** app and click **Program and then
    notifications**.
    
    A list of existing program notifications for the selected program
    opens. If the program doesn't have any program notifications, the
    list is empty.

2.  Click on add button and select**Program notification**.

3.  Enter a **Name**.

4.  In the **When-to-send it** field, select what should trigger the
    notification.
    
    <table>
    <colgroup>
    <col width="33%" />
    <col width="33%" />
    <col width="33%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th><p>Trigger</p></th>
    <th><p>Description</p></th>
    <th><p>Note</p></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><p>Program enrollment</p></td>
    <td><p>The program notification is sent when the TEI enrols in the program.</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="even">
    <td><p>Program completion</p></td>
    <td><p>The program notification is sent when the program of TEI is completed</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="odd">
    <td><p>Days scheduled (incident date)</p></td>
    <td><p>The program notification is sent XX number of days before or after the incident date</p></td>
    <td><p>You need to enter the number of days before or after the scheduled date that the notification will be send.</p></td>
    </tr>
    <tr class="even">
    <td><p>Days scheduled (enrollment date)</p></td>
    <td><p>The program notification is sent XX number of days before or after the enrollment date</p></td>
    <td><p>You need to enter the number of days before or after the scheduled date that the notification will be send.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Program Rule</p></td>
    <td><p>Notification will be triggered as a result of program rule exeuction.</p></td>
    <td><p>Program rule with ProgramRuleActionType.SENDMESSAGE need to be in place to make this trigger successful.</p></td>
    </tr>
    </tbody>
    </table>

5.  In the **Who-to-send-it** field, select who should receive the
    program notification.
    
    <table>
    <colgroup>
    <col width="33%" />
    <col width="33%" />
    <col width="33%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th><p>Recipient type</p></th>
    <th><p>Description</p></th>
    <th><p>Note</p></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><p>Tracked entity instance</p></td>
    <td><p>Receives program notifications via e-mail or text message.</p></td>
    <td><p>To receive a program notification, the recipient must have an e-mail address or a phone number attribute.</p></td>
    </tr>
    <tr class="even">
    <td><p>Organisation unit contact</p></td>
    <td><p>Receives program notifications via e-mail or text message.</p></td>
    <td><p>To receive a program notification, the receiving organisation unit must have a registered contact person with e-mail address and phone number.</p></td>
    </tr>
    <tr class="odd">
    <td>Users at organisation unit:</td>
    <td><p>All users registered to the selected organisation unit receive program notifications via the internal DHIS2 messaging system.</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="even">
    <td><p>User group</p></td>
    <td><p>All members of the selected user group receive the program notifications via the internal DHIS2 messaging system</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="odd">
    <td><p>Limit To Hierarchy</p></td>
    <td><p>Send notification only to those users who belong to any of the organisation unit in the hierarchy.</p></td>
    <td><p>This option is only available when User Group is selected as recipient.</p></td>
    </tr>
    <tr class="even">
    <td><p>Parent OrgUnit Only</p></td>
    <td><p>Send notification only to those users who belong to parent organisation unit.</p></td>
    <td><p>This option is only available when User Group is selected as recipient.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Program Attribute</p></td>
    <td><p>TrackedEntityAttribute can also be selected as recipient.</p></td>
    <td><p>This parameter will only be effective if TrackedEntityAttribute value type is PHONE_NUMBER/EMAIL.</p></td>
    </tr>
    </tbody>
    </table>

6.  Create the **Subject template**.
    
    Double-click the parameters in the **Parameters** field to add them
    to your subject.
    
    > **Note**
    > 
    > The subject is not included in text messages.

7.  Create the **Message template**.
    
    Double-click the parameter names in the **Parameters** field to add
    them to your message.
    
    Dear A{w75KJ2mc4zz}, You're now enrolled in V{program\_name}.

8.  Click **Save**.

> **Note**
> 
> You configure when the program notifications are sent in the **Data
> Administration** app \> **Scheduling** \> **Program notifications
> scheduler**.
> 
>   - Click **Run now** to send the program notifications immediately.
> 
>   - Select a time and click **Start** to schedule the program
>     notifications to be send at a specific time.

### Create a program stage notification

![](resources/images/program/what_to_send-psnt.png)

![](resources/images/program/what_to_send-psnt.png)

![](resources/images/program/what_to_send-psnt.png)

1.  Open the **Maintenance** app and click **Program and then
    notifications**.
    
    A list of existing program stage notifications for the selected
    program stage opens. If the program stage doesn't have any program
    stage notifications, the list is empty.

2.  Click on add button and select**Program stage notification**.

3.  Click **Add new**.

4.  Enter a **Name**.

5.  In the **When-to-send-it** field, select what should trigger the
    notification.
    
    <table>
    <colgroup>
    <col width="33%" />
    <col width="33%" />
    <col width="33%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th><p>Trigger</p></th>
    <th><p>Description</p></th>
    <th><p>Note</p></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><p>Program stage completion</p></td>
    <td><p>The program stage notification is sent when the program stage is completed</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="even">
    <td><p>Days scheduled (due date)</p></td>
    <td><p>The program stage notification is sent XX number of days before or after the due date</p></td>
    <td><p>You need to enter the number of days before or after the scheduled date that the notification will be send.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Program Rule</p></td>
    <td><p>Notification will be triggered as a result of program rule exeuction.</p></td>
    <td><p>Program rule with ProgramRuleActionType.SENDMESSAGE need to be in place to make this trigger successful.</p></td>
    </tr>
    </tbody>
    </table>

6.  In the **Recipients** field, select who should receive the program
    stage notification. You can select:
    
    <table>
    <colgroup>
    <col width="33%" />
    <col width="33%" />
    <col width="33%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th><p>Recipient type</p></th>
    <th><p>Description</p></th>
    <th><p>Note</p></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><p>Tracked entity instance</p></td>
    <td><p>Receives program notifications via e-mail or text message.</p></td>
    <td><p>To receive a program stage notification, the recipient must have an e-mail address or a phone number attribute.</p></td>
    </tr>
    <tr class="even">
    <td><p>Organisation unit contact</p></td>
    <td><p>Receives program notifications via e-mail or text message.</p></td>
    <td><p>To receive a program stage notification, the receiving organisation unit must have a registered contact person with e-mail address and phone number.</p>
    <p>The system selects the same organisation unit as where the event took place.</p></td>
    </tr>
    <tr class="odd">
    <td>Users at organisation unit:</td>
    <td><p>All users registered to the selected organisation unit receive program notifications via the internal DHIS2 messaging system.</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="even">
    <td><p>User group</p></td>
    <td><p>All members of the selected user group receive the program notifications via the internal DHIS2 messaging system</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="odd">
    <td><p>Limit To Hierarchy</p></td>
    <td><p>Send notification only to those users who belong to any of the organisation unit in the hierarchy.</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="even">
    <td><p>Parent OrgUnit Only</p></td>
    <td><p>Send notification only to those users who belong to parent organisation unit.</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="odd">
    <td><p>Data Element</p></td>
    <td><p>Data Element associated with ProgramStage can be selected as recipient.</p></td>
    <td><p>Data Element will only be effective if DataElement has value type PHONE_NUMBER/EMAIL.</p></td>
    </tr>
    </tbody>
    </table>

7.  Create the **Subject template**.
    
    Double-click the parameter names in the **Parameters** field to add
    them to your subject.
    
    > **Note**
    > 
    > The subject is not included in text messages.

8.  Create the **Message template**.
    
    Double-click the parameter names in the **Parameters** field to add
    them to your message.
    
    Dear A{w75KJ2mc4zz}, please come to your appointment the
    V{due\_date}.

9.  Click **Save**.

> **Note**
> 
> You configure when the program stage notifications are sent in the
> **Data Administration** app \> **Scheduling** \> **Program
> notifications scheduler**.
> 
>   - Click **Run now** to send the program notifications immediately.
> 
>   - Select a time and click **Start** to schedule the program
>     notifications to be send at a specific time.

## Manage custom registration forms

<!--DHIS2-SECTION-ID:manage_custom_registration_forms-->

### About program custom registration forms

You can create custom registration form for each available program in
system or for normal registration form which is used to register any
entity without having program information and this entity can enroll
into a certain program after that.

> **Note**
> 
> Check on*Auto save registration form* check box in *Design tracked
> entity form*to save the custom registration form to being designed
> automatically.

### About program stage data entry forms

A program stage has three types of data entry forms:

1.  *Custom data entry form*: Define a data entry form as HTML page.
    Click on the program stage which you would like and select to define
    custom data entry form. The system supports to define a custom entry
    form with multi stages. So this form can be re-used in other stages
    of the same program.

2.  *Section data entry form*: Group some data elements which belong to
    the program stage as sections and display data elements by each
    section. Click on the program stage which you would like and select
    *Section management* link to define section data entry form.

3.  *Default data entry form*: List all data elements which belong to
    the program stage.

### Create a custom program registration form

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the program you want to add a custom registration form to and
    select **Design custom registration form**.

3.  Enter a **Name**.

4.  Create the form in the built-in WYSIWYG HTML editor. If you select
    **Source**, you can paste HTML code directly in the editing area.
    You can also insert images.

5.  Click **Save**.

### Create a program stage data entry form

1.  Open the **Program / Attributes** app and click **Program**.

2.  Click the program you want to add a program stage data entry form to
    and select **View program stages**.
    
    A list of existing stages for the selected program opens. If the
    program doesn't have any program stages, the list is empty.

3.  Click the program stage you want to add a program stage entry form
    to and select **Design data entry form**.

4.  Enter a **Name**.

5.  Create the form in the built-in WYSIWYG HTML editor. If you select
    **Source**, you can paste HTML code directly in the editing area.
    You can also insert images.

6.  Click **Save**.

