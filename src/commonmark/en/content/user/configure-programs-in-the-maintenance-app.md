# Configure programs in the Maintenance app

<!--DHIS2-SECTION-ID:configure_programs_in_maintenance_app-->

## About programs

<!--DHIS2-SECTION-ID:about_program_maintenance_app-->

Traditionally, public health information systems have been reporting
aggregated data of service provision across its health programs. This
does not allow you to trace the people provided with these services. In
DHIS2, you can define your own programs with stages. These programs are
a essential part of the "tracker" functionality which lets you track
individual records. You can also track other ‘entities’ such as wells or
insurances. You can create two types of programs:

<table>
<caption>Program types</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Program type</p></th>
<th><p>Description</p></th>
<th><p>Examples of use</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Event program</p></td>
<td><p>Single event <em>without</em> registration program (anonymous program or SEWoR)</p>
<p>Anonymous, individual events are tracked through the health system. No person or entity is attached to these individual transactions.</p>
<p>Has only one program stage.</p></td>
<td><p>To record health cases without registering any information into the system.</p>
<p>To record survey data or surveillance line-listing.</p></td>
</tr>
<tr class="even">
<td><p>Tracker program</p></td>
<td><p>Single event <em>with</em> registration program (SEWR)</p>
<p>An entity (person, commodity, etc.) is tracked through each individual transaction with the health system</p>
<p>Has only one program stage.</p>
<p>A tracked entity instance (TEI) can only enroll in the program once.</p></td>
<td><p>To record birth certificate and death certificate.</p></td>
</tr>
<tr class="odd">
<td></td>
<td><p>Multi events <em>with</em> registration program (MEWR)</p>
<p>An entity (person, commodity, etc.) is tracked through each individual transaction with the health system</p>
<p>Has multiple program stages.</p></td>
<td><p>Mother Health Program with stages as ANC Visit (2-4+), Delivery, PNC Visit.</p></td>
</tr>
</tbody>
</table>

To create a program, you must first configure several types of metadata
objects. You create these metadata objects in the **Maintenance** app.

<table>
<caption>Program metadata objects in the Maintenance app</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
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
<td><p>A program to record single event without registration</p></td>
<td><p>Create, edit, share, delete, show details and translate</p></td>
</tr>
<tr class="even">
+<td><p>Tracker program</p></td>
+<td><p>A program to record single or multiple events with registration</p></td>
+<td><p>Create, edit, share, delete, show details and translate</p></td>
+</tr>
<tr class="even">
<td><p>Program indicator</p></td>
<td><p>An expression based on data elements and attributes of tracked entities which you use to calculate values based on a formula.</p></td>
<td><p>Create, edit, clone, share, delete, show details and translate</p></td>
</tr>
<tr class="odd">
<td><p>Program rule</p></td>
<td><p>Allows you to create and control dynamic behaviour of the user interface in the <strong>Tracker Capture</strong> and <strong>Event Capture</strong> apps.</p></td>
<td><p>Create, edit, clone, delete, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Program rule variable</p></td>
<td><p>Variables you use to create program rule expressions.</p></td>
<td><p>Create, edit, clone, delete, show details and translate</p></td>
</tr>
<tr class="odd">
<td><p>Relationship type</p></td>
<td><p>Defines the relationship between tracked entity A and tracked entity B, for example mother and child.</p></td>
<td><p>Create, edit, clone, share, delete, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Tracked entity type</p></td>
<td><p>Types of entities which can be tracked through the system. Can be anything from persons to commodities, for example a medicine or a person.</p>
<p>A program must have one tracked entity. To enrol a tracked entity instance into a program, the tracked entity of an entity and tracked entity of a program must be the same.</p>
<blockquote>
<p><strong>Note</strong></p>
<p>A program must be specified with only one tracked entity. Only tracked entity as same as the tracked entity of program can enroll into that program.</p>
</blockquote></td>
<td><p>Create, edit, clone, share, delete, show details and translate</p></td>
</tr>
<tr class="odd">
<td><p>Tracked entity attribute</p></td>
<td><p>Used to register extra information for a tracked entity.</p>
<p>Can be shared between programs.</p></td>
<td><p>Create, edit, clone, share, delete, show details and translate</p></td>
</tr>
<tr class="odd">
<td><p>Program</p></td>
<td><p>A program consist of program stages.</p></td>
<td><p>Create, edit, share, delete, assign to organisation units, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Program stage</p></td>
<td><p>A program stage defines which actions should be taken at each stage.</p></td>
<td><p>Create, edit, share, change sort order, delete, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Program indicator group</p></td>
<td><p>A group of program indicators</p></td>
<td><p>Create, edit, clone, share, delete, show details and translate</p></td>
</tr>
<tr class="odd">
<td><p>Validation rule</p></td>
<td><p>A validation rule is based on an expression which defines a relationship between data element values.</p></td>
<td><p>Create, edit, clone, share, delete, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Program notification</p></td>
<td><p>Automated message reminder</p>
<p>Set reminders to be automatically sent to enrolled tracked entity instances before scheduled appointments and after missed visits.</p></td>
<td><p>Create, edit and delete</p></td>
</tr>
<tr class="odd">
<td><p>Program stage notification</p></td>
<td><p>Automated message reminder</p>
<p>Set reminders to be automatically sent whenever a program stage is completed, or before or after the due date.</p></td>
<td><p>Create, edit and delete</p></td>
</tr>
</tbody>
</table>

## Configure event programs in the Maintenance app

<!--DHIS2-SECTION-ID:configure_event_program_in_maintenance_app-->

### About event programs

<!--DHIS2-SECTION-ID:about_event_program-->

Single event *without* registration programs are called event programs.
You configure them in the **Maintenance** app. Event programs can have
three types of data entry forms:

<table>
<caption>Types of data entry forms for event programs</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Form type</p></th>
<th><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Basic</p></td>
<td><p>Lists all data elements which belong to the program. You can change the order of the data elements.</p></td>
</tr>
<tr class="even">
<td><p>Section</p></td>
<td><p>A section groups data elements. You can then arrange the order of the sections to create the desired layout of the data entry form.</p></td>
</tr>
<tr class="odd">
<td><p>Custom</p></td>
<td><p>Defines the data entry form as HTML page.</p></td>
</tr>
</tbody>
</table>

> **Note**
>
>   - Custom forms takes precedence over section forms if both are
>     present.
>
>   - If no custom or section form are defined, the basic form will be
>     used.
>
>   - The Android apps only supports section forms.

You can create *program notifications* for event programs. The
notifications are sent either via the internal DHIS2 messaging system,
via e-mail or via text messages (SMS). You can use program notifications
to, for example, send an automatic reminder to a tracked entity 10 days
before a scheduled appointment. You use the program’s tracked entity
attributes (for example first name) and program parameters (for example
enrollment date) to create a notification template. In the
**Parameters** field, you'll find a list of available tracked entity
attributes and program parameters.

### Workflow: Create an event program

<!--DHIS2-SECTION-ID:workflow_event_program-->

1.  Enter the event program details.

2.  Assign data elements.

3.  Create data entry form(s): **Basic**, **Section** or **Custom**.

4.  Assign the program to organisation unit(s).

5.  Create program notification(s).

### Create or edit an event program

<!--DHIS2-SECTION-ID:create_event_program-->

#### Enter event program details

1.  Open the **Maintenance** app and click **Program** \> **Program**.

2.  Click the add button and select **Event Program** in the popup menu.

3.  Enter program details, then click next.

    <table>
    <colgroup>
    <col style="width: 50%" />
    <col style="width: 50%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th><p>Field</p></th>
    <th><p>Description</p></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><p><strong>Name</strong></p></td>
    <td><p>The name of the program.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Color</strong></p></td>
    <td><p>Color used for this program in the data capture apps.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Icon</strong></p></td>
    <td><p>Icon used for this program in the data capture apps.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Short name</strong></p></td>
    <td><p>A short name of the program. The short name is used as the default chart or table title in the analytics apps.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Description</strong></p></td>
    <td><p>A detailed description of the program.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Version</strong></p></td>
    <td><p>The version of the program. This is used for example when people collect data offline in an Android implementation. When they go online and synchronize their metadata, they should get the latest version of the program.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Category combination</strong></p></td>
    <td><p>The category combination you want to use. The default setting is <strong>None</strong>.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Data approval workflow</strong></p></td>
    <td><p>The data approval workflow you want to use. The default setting is <strong>No value</strong>.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Completed events expiry date</strong></p></td>
    <td><p>Defines the number of days for which you can edit a completed event. This means that when an event is completed and the specified number of expiry days has passed, the event is locked.</p>
    <p>If you set &quot;Completed events expiry days&quot; to 10&quot;, an event is locked ten days after the completion date. After this date you can no longer edit the event.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Expiry period type</strong></p>
    <p><strong>Expiry days</strong></p></td>
    <td><p>The expiry days defines for how many days after the end of the previous period, an event can be edited. The period type is defined by the expiry period type. This means that when the specified number of expiry days has passed since the end date of the previous period, the events from that period are locked.</p>
    <p>If you set the expiry type to &quot;Monthly&quot; and the expiry days to &quot;10&quot; and the month is October, then you can't add or edit an event to October after the 10th of November.</p></td>
    </tr>
    <tr class="odd">
    <td><strong>Block entry form after completed</strong></td>
    <td><p>Select checkbox to block the entry form after completion of the event of this program.</p>
    <p>This means that the data in the entry form can't be changed until you reset the status to incomplete.</p></td>
    </tr>
    <tr class="even">
    <td><strong>Feature type</strong></td>
    <td><p>Sets wether the program is going to capture a geographical feature type or not.
- **None**
  Nothing is captured.
- **Polygon**
  An area is captured. For single event programs the area will be the area representing the event being captured. For tracker programs, the area will represent the area of the enrollment.
- **Point**
  A point/coordinate is captured. For single event programs the point will be representing the event being captured. For tracker programs, the point will represent the enrollment.
    </p></td>
    </tr>
    <tr class="odd">
    <td><strong>Validation strategy</strong></td>
    <td>Sets the server and client side validation requirement.
> Data type validations is always performed regardless of the validation strategy. An integer field is never stored containing text, for example.
- **On complete**
  This option will enforce required field and error messages to be fixed when completing the event, but the event can be saved to the server without passing these validation requirements.
  - For legacy reasons, this is always the validation strategy for tracker programs, where each data value in the event is stored to the server while entrering data.
- **On update and insert**
  This option will enforce required field validation when saving the event to the server regardless of the completion status. When using this option no events can be stored without passing validations.
    </td>
    </tr>
    <tr class="even">
    <td><strong>Pre-generate event UID</strong></td>
    <td>Select checkbox to pre-generate unique event id numbers.</td>
    </tr>
    <tr class="odd">
    <td><strong>Description of report date</strong></td>
    <td><p>Type a description of the report date.</p>
    <p>This description is displayed in the case entry form.</p></td>
    </tr>
    </tbody>
    </table>

1.  Click next.

#### Assign data elements

<!--DHIS2-SECTION-ID:assign_data_elements-->

1.  Click **Assign data elements**.

2.  In the list of available items, double-click the data elements you
    want to assign to the event program.

3.  (Optional) For each data element, add additional settings:

    <table>
    <colgroup>
    <col style="width: 50%" />
    <col style="width: 50%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th><p>Setting</p></th>
    <th><p>Description</p></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><p><strong>Compulsory</strong></p></td>
    <td><p>The value of this data element must be filled into data entry form before you can complete the event.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Allow provided elsewhere</strong></p></td>
    <td><p>Specify if the value of this data element comes from other facility, not in the facility where this data is entered.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Display in reports</strong></p></td>
    <td><p>Displays the value of this data element into the single event without registration data entry function.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Date in future</strong></p></td>
    <td><p>Will allow user to select a date in future for date data elements.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Mobile render type</strong></p></td>
    <td><p>Can be used to select different render types for mobile devices. Available options vary depending on the data element's value type. For example, for a numerical value you may select &quot;Default&quot;, &quot;Value&quot;, &quot;Slider&quot;, &quot;Linear scale&quot;, and &quot;Spinner&quot;.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Desktop render type</strong></p></td>
    <td><p>WARNING: NOT IMPLEMENTED YET.</p>
    <p>Can be used to select different render types for desktop (i.e. the web interface). Available options vary depending on the data element's value type. For example, for a numerical value you may select &quot;Default&quot;, &quot;Value&quot;, &quot;Slider&quot;, &quot;Linear scale&quot;, and &quot;Spinner&quot;.</p></td>
    </tr>
    </tbody>
    </table>

4.  Click next.

#### Create data entry forms

<!--DHIS2-SECTION-ID:create_data_entry_forms-->

The data entry forms decide how the data elements will be displayed to
the user in the **Event Capture** app.

1.  Click **Create data entry form**.

2.  Click **Basic**, **Section** or **Custom**.

3.  To create a **Basic** data entry form: Drag and drop the data
    elements in the order you want.

4.  To create a **Section** data entry form:

    1.  Click the add button and enter a section's name, description and
        render type for desktop and mobile.

    2.  Click the section so it's highlighted by a black line.

    3.  Add data elements by clicking the plus sign next to the data
        elements' names.

    4.  Repeat above steps until you've all the sections you need.

    5.  Change the section order: click the options menu, then drag the
        section to the place you want.

5.  To create a **Custom** data entry from: Use the WYSIWYG editor to
    create a completely customized form. If you select **Source**, you
    can paste HTML code directly in the editing area. You can also
    insert images for example flags or logos.

6.  Click next.

#### Access

<!--DHIS2-SECTION-ID:access-->

Access options decide who can capture data for the program or view/edit
the program's metadata. A program can be shared to organisation units,
and in addition, the main program and any program stages' access options
can be configured through the **Sharing dialog**. Access options are
available in the **Access** tab.

Assign organization units:

1.  In the organisation tree, double-click the organisation units you
    want to add to the program to.

    You can locate an organisation unit in the tree by expanding the
    branches (click on the arrow symbol), or by searching for it by
    name. The selected organisation units display in orange.

Change roles and access:

1.  Scroll down to the **Roles and access** section.

    The first row shows the main program's access options, and each
    subsequent row shows the options of one program stage. Program
    stages with a warning icon (exclamation mark) contain access options
    that deviate from the main program, meaning they are accessed by a
    different combination of users.

2.  Click on either of the rows and the **Sharing dialog** will show.

3.  Modify the access options accordingly. See documentation on the
    sharing dialog for details.

4.  Click the **Apply** button.

5.  Repeat the process for each program/program stage. You can also copy
    all access options from the main program to your child programs:

    1.  Select the program stages you want to have similar access
        options as the main program by toggling the checkboxes on the
        right hand side of the program stages. You can also choose to
        **Select all** program stages, **Deselect all** program stages
        or **Select similar** stages, in terms of access options, to
        that of the main program. Similar stages are toggled by default.

    2.  Click **Apply to selected stages**

#### Create program notifications

<!--DHIS2-SECTION-ID:create_program_notifications-->

1.  Create the message you want to send:

    1.  Click **What to send?**.

    2.  Enter a **Name**.

    3.  Create the **Subject template**: Double-click the parameters in
        the **Template variables** field to add them to your subject.

        > **Note**
        >
        > The subject is not included in text messages.

    4.  Create the **Message template**: Double-click the parameter
        names in the **Template variables** list to add them to your
        message.

        Dear A{w75KJ2mc4zz}, You're now enrolled in V{program\_name}.

2.  Define *when* you want to send the message:

    1.  Click **When to send it?**.

    2.  Select a **Notification trigger**.

        <table>
        <colgroup>
        <col style="width: 50%" />
        <col style="width: 50%" />
        </colgroup>
        <thead>
        <tr class="header">
        <th><p>Notification trigger</p></th>
        <th><p>Description</p></th>
        </tr>
        </thead>
        <tbody>
        <tr class="odd">
        <td><p>Program stage completion</p></td>
        <td><p>The program stage notification is sent when the program stage is completed</p></td>
        </tr>
        <tr class="even">
        <td><p>Days scheduled (due date)</p></td>
        <td><p>The program stage notification is sent XX number of days before or after the due date</p>
        <p>You need to enter the number of days before or after the scheduled date that the notification will be send.</p></td>
        </tr>
        </tbody>
        </table>

3.  Define *who* you want to send the message to:

    1.  Click **Who to send it to?**.

    2.  Select a **Notification recipient**.

        <table>
        <colgroup>
        <col style="width: 50%" />
        <col style="width: 50%" />
        </colgroup>
        <thead>
        <tr class="header">
        <th><p>Notification recipient</p></th>
        <th><p>Description</p></th>
        </tr>
        </thead>
        <tbody>
        <tr class="odd">
        <td><p>Tracked entity instance</p></td>
        <td><p>Receives program notifications via e-mail or text message.</p>
        <p>To receive a program notification, the recipient must have an e-mail address or a phone number attribute.</p></td>
        </tr>
        <tr class="even">
        <td><p>Organisation unit contact</p></td>
        <td><p>Receives program notifications via e-mail or text message.</p>
        <p>To receive a program notification, the receiving organisation unit must have a registered contact person with e-mail address and phone number.</p></td>
        </tr>
        <tr class="odd">
        <td><p>Users at organisation unit</p></td>
        <td><p>All users registered to the selected organisation unit receive program notifications via the internal DHIS2 messaging system.</p></td>
        </tr>
        <tr class="even">
        <td><p>User group</p></td>
        <td><p>All members of the selected user group receive the program notifications via the internal DHIS2 messaging system</p></td>
        </tr>
        <tr class="odd">
        <td><p>Program</p></td>
        <td><p>TBA</p></td>
        </tr>
        </tbody>
        </table>

    3.  Click **Save**.

4.  Repeat above steps to create all the program notifications you need.

5.  Click **Save**.

> **Note**
>
> You configure when the program notifications are sent in the **Data
> Administration** app \> **Scheduling** \> **Program notifications
> scheduler**.
>
>   - Click **Run now** to send the program notifications immediately.
>
>   - Select a time and click **Start** to schedule the program
>     notifications to be send at a specific
time.

### Reference information: Program notification parameters

<!--DHIS2-SECTION-ID:reference_information_event_program_notification_parameters-->

<table>
<caption>Program notification parameters to use in program notifications</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
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
<td><p>Program stage</p></td>
<td><p>Current date</p></td>
<td><pre><code>V{current_date}</code></pre></td>
</tr>
<tr class="even">
<td></td>
<td><p>Days since due date</p></td>
<td><pre><code>V{days_since_due_date}</code></pre></td>
</tr>
<tr class="odd">
<td></td>
<td><p>Days until due date</p></td>
<td><pre><code>V{days_until_due_date}</code></pre></td>
</tr>
<tr class="even">
<td></td>
<td><p>Due date</p></td>
<td><pre><code>V{due_date}</code></pre></td>
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
<td><p>Program stage name</p></td>
<td><pre><code>V{program_stage_name}</code></pre></td>
</tr>
</tbody>
</table>

## Configure tracker programs in the Maintenance app

<!--DHIS2-SECTION-ID:configure_tracker_program_in_Maintenance_app-->

### About Tracker programs
Single or multiple event programs *with* registration are called Tracker programs. A program must be specified with only one tracked entity. Only tracked entities that are the same as the tracked entity of program can enroll into that
program. A program needs several types of metadata that you create in the **Maintenance** apps.

### Workflow: Create a tracker program

<!--DHIS2-SECTION-ID:workflow_tracker_program-->

1.  Enter the tracker program details.

2.  Enter enrollment details.

3.  Assign attributes and create  **section** or **custom** registration form.

4. Create program stages.

5. Configure access, and assign to organisation units.

6. Create program and program stage notification(s).

### Create or edit a Tracker program

1. Open the **Maintenance** app and click **Program** \> **Program**.

2. Click the add button and select **Tracker Program** in the popup menu.

#### Enter program details

<!--DHIS2-SECTION-ID:tracker_enter_programs_details-->
<table>
    <colgroup>
        <col style="width: 50%" />
        <col style="width: 50%" />
    </colgroup>
    <thead>
        <tr class="header">
            <th><p>Field</p></th>
            <th><p>Description</p></th>
        </tr>
    </thead>
    <tbody>
        <tr class="odd">
            <td>
                <p><strong>Name</strong></p>
            </td>
            <td><p>The name of the program.</p></td>
        </tr>
        <tr class="even">
            <td>
                <p><strong>Color</strong></p>
            </td>
            <td><p>Color used for this program in Tracker capture.</p></td>
        </tr>
        <tr class="odd">
            <td>
                <p><strong>Icon</strong></p>
            </td>
            <td><p>Icon used for this program in Tracker capture</p></td>
        </tr>
        <tr class="even">
            <td>
                <p><strong>Short name</strong></p>
            </td>
            <td>
                <p>
                    A short name of the program. The short name is used as the
                    default chart or table title in the analytics apps.
                </p>
            </td>
        </tr>
        <tr class="odd">
            <td>
                <p><strong>Description</strong></p>
            </td>
            <td><p>A detailed description of the program.</p></td>
        </tr>
        <tr class="even">
            <td>
                <p><strong>Version</strong></p>
            </td>
            <td>
                <p>
                    The version of the program. This is used for example when
                    people collect data offline in an Android implementation.
                    When they go online and synchronize their metadata, they
                    should get the latest version of the program.
                </p>
            </td>
        </tr>
        <tr class="odd">
            <td>
                <p><strong>Tracked Entity Type</strong></p>
            </td>
            <td>
                <p>
                    The tracked entity type you want to use. A program can only
                    have one type of tracked entity.
                </p>
            </td>
        </tr>
        <tr class="even">
            <td>
                <p><strong>Category combination</strong></p>
            </td>
            <td>
                <p>
                    The category combination you want to use. The default
                    setting is <strong>None</strong>.
                </p>
            </td>
        </tr>
        <tr class="odd">
            <td>
                <p><strong>Display front page list</strong></p>
            </td>
            <td>
                <p>
                    Select checkbox to display a list of Tracked Entity
                    Instances in Tracker Capture. If not selected, the Search
                    will be displayed.
                </p>
            </td>
        </tr>
        <tr class="even">
            <td>
                <p><strong>First stage appears on registration page</strong></p>
            </td>
            <td>
                <p>
                    Select checkbox to display the first program stage together
                    with the registration (enrollment).
                </p>
            </td>
        </tr>
        <tr class="odd">
            <td>
                <p><strong>Access level</strong></p>
            </td>
            <td><p>Choose the access level of the program.</p></td>
        </tr>
        <tr class="even">
            <td>
                <p><strong>Completed events expiry days</strong></p>
            </td>
            <td>
                <p>
                    Defines the number of days for which you can edit a
                    completed event. This means that when an event is completed
                    and the specified number of expiry days has passed, the
                    event is locked.
                </p>
                <p>
                    If you set &quot;Completed events expiry days&quot; to
                    10&quot;, an event is locked ten days after the completion
                    date. After this date you can no longer edit the event.
                </p>
            </td>
        </tr>
        <tr class="odd">
            <td>
                <p><strong>Expiry period type</strong></p>
                <p><strong>Expiry days</strong></p>
            </td>
            <td>
                <p>
                    The expiry days defines for how many days after the end of
                    the previous period, an event can be edited. The period type
                    is defined by the expiry period type. This means that when
                    the specified number of expiry days has passed since the end
                    date of the previous period, the events from that period are
                    locked.
                </p>
                <p>
                    If you set the expiry type to &quot;Monthly&quot; and the
                    expiry days to &quot;10&quot; and the month is October, then
                    you can't add or edit an event to October after the 10th of
                    November.
                </p>
            </td>
        </tr>
        <tr class="even">
            <td>
                <strong>Minimum number of attributes required to search</strong>
            </td>
            <td>
                <p>
                    Specify the number of tracked entity attributes that needs
                    to be filled in to search for Tracked Entities in the
                    Program.
                </p>
            </td>
        </tr>
        <tr class="odd">
            <td>
                <strong>Maximum number of tracked entity instances to return in
                    search</strong>
            </td>
            <td>
                <p>
                    Specify the maximum number of tracked entity instances that
                    should be returned in a search. Enter 0 for no limit.
                </p>
            </td>
        </tr>
    </tbody>
</table>

#### Enter enrollment details

<!--DHIS2-SECTION-ID:enter_enrollment_details-->
<table>
    <colgroup>
        <col style="width: 50%" />
        <col style="width: 50%" />
    </colgroup>
    <thead>
        <tr class="header">
            <th><p>Field</p></th>
            <th><p>Description</p></th>
        </tr>
    </thead>
    <tbody>
        <tr class="odd">
            <td><strong>Allow future enrollment dates</strong></td>
            <td>
                <p>
                    Select checkbox if you want to allow tracked entity
                    instances to be enrolled in the program on a future date.
                </p>
            </td>
        </tr>
        <tr class="even">
            <td><strong>Allow future incident dates</strong></td>
            <td>
                <p>
                    Select checkbox if you want to allow the incident date in
                    the program to be on a future date.
                </p>
            </td>
        </tr>
        <tr class="odd">
            <td>
                <strong>Only enroll once (per tracked entity instance lifetime)</strong>
            </td>
            <td>
                <p>
                    Select checkbox if you want a tracked entity to be able to
                    enroll only once in a program. This setting is useful for
                    example in child vaccination or post-mortem examination
                    programs where it wouldn’t make sense to enroll a tracked
                    entity more than once.
                </p>
            </td>
        </tr>
        <tr class="even">
            <td><strong>Show incident date</strong></td>
            <td>
                <p>
                    This setting allows you to show or hide the incident date
                    field when a tracked entity enroll in the program.
                </p>
            </td>
        </tr>
        <tr class="odd">
            <td><strong>Description of incident date</strong></td>
            <td>
                <p>Type a description of the incident date</p>
                <p>For example:</p>
                <p>In an immunization program for child under 1 year old, the
                    incident date is the child's birthday. </p>
                <p>In a maternal program, the incident date is the date of last
                    menstrual period. </p>
            </td>
        </tr>
        <tr class="even">
            <td><strong>Type a description of the enrollment date</strong></td>
            <td>
                <p>
                    The date when the tracked entity is enrolled into the
                    program
                </p>
            </td>
        </tr>
        <tr class="odd">
            <td><strong>Ignore overdue events</strong></td>
            <td>
                <p>
                    When a tracked entity enrolls into the program, the events
                    corresponding to the program stages are created. If you
                    select this checkbox, the system will not generate overdue
                    events.
                </p>
            </td>
        </tr>
        <tr class="even">
            <td><strong>Feature type</strong></td>
            <td>
                <p>
                    Sets wether the program is going to capture a geographical
                    feature type or not.
                </p>
                <ul>
                <li><strong>None:</strong>Nothing is captured.</li>
                <li><strong>Polygon:</strong> An area is captured. For single
                event programs the area will be the area representing the
                event being captured. For tracker programs, the area will
                represent the area of the enrollment. </li>
                <li><strong>Point:</strong>: A point/coordinate is captured. For
                single event programs the point will be representing the
                event being captured. For tracker programs, the point will
                represent the enrollment. </li>
                </ul>
            </td>
        </tr>
        <tr class="odd">
            <td><strong>Related program</strong></td>
            <td>
                <p>
                    Choose a Tracker program which is related to the program you
                    are creating, for example an ANC and a Child program.
                </p>
            </td>
        </tr>
    </tbody>
</table>


#### Assign tracked entity attributes.

<!--DHIS2-SECTION-ID:assign_tracked_entity_attributes-->

  1. In the list of **Available program tracked entity attributes**, double-click the
        attributes you want to assign to the program.

  2. (Opptional) For each assigned attribute, add additional settings:
<table>
        <colgroup>
            <col style="width: 50%" />
            <col style="width: 50%" />
        </colgroup>
        <thead>
            <tr class="header">
                <th><p>Setting</p></th>
                <th><p>Description</p></th>
            </tr>
        </thead>
        <tbody>
            <tr class="odd">
                <td>
                    <p><strong>Display in list</strong></p>
                </td>
                <td>
                    <p>
                        Displays the value of this attribute in the list of tracked
                        entity instances in Tracker capture.
                    </p>
                </td>
            </tr>
            <tr class="even">
                <td>
                    <p><strong>Mandatory</strong></p>
                </td>
                <td>
                    <p>
                        The value of this attribute must be filled into data entry
                        form before you can complete the event.
                    </p>
                </td>
            </tr>
            <tr class="odd">
                <td>
                    <p><strong>Date in future</strong></p>
                </td>
                <td>
                    <p>
                        Will allow user to select a date in future for date
                        attributes.
                    </p>
                </td>
            </tr>
            <tr class="even">
                <td>
                    <p><strong>Mobile render type</strong></p>
                </td>
                <td>
                    <p>
                        Can be used to select different render types for mobile
                        devices. Available options vary depending on the attribute's
                        value type. For example, for a numerical value you may
                        select &quot;Default&quot;, &quot;Value&quot;,
                        &quot;Slider&quot;, &quot;Linear scale&quot;, and
                        &quot;Spinner&quot;.
                    </p>
                </td>
            </tr>
            <tr class="odd">
                <td>
                    <p><strong>Desktop render type</strong></p>
                </td>
                <td>
                    <p>WARNING: NOT IMPLEMENTED YET.</p>
                    <p>
                        Can be used to select different render types for desktop
                        (i.e. the web interface). Available options vary depending
                        on the attribute's value type. For example, for a numerical
                        value you may select &quot;Default&quot;, &quot;Value&quot;,
                        &quot;Slider&quot;, &quot;Linear scale&quot;, and
                        &quot;Spinner&quot;.
                    </p>
                </td>
            </tr>
        </tbody>
</table>

3. Create registration form

    The registration form defines how the attributes will be displayed to the user in consuming apps, such as Android and Tracker Capture.

    1. Click **Create registration form**.

    2. Click **Section** or **Custom**.

    3. To create a **Section** form:

        1. Click the add button and enter a section’s name, description and render type for desktop and mobile.
        2. Click the section so it is highlighted by a black border.
        3. Add data elements by clicking the plus sign next to the name of the data elements you wish to add.
        4. Repeat above steps until you have all the sections you need.
            To change the section order: click the options menu, then drag the section to the place you want.  
	
    4. To create a **Custom** registration form: Use the WYSIWYG editor to create a completely customized form. If you select Source, you can paste HTML code directly in the editing area. You can also insert images for example flags or logos.

    5. Click add stage.


#### Create program stages

<!--DHIS2-SECTION-ID:create_program_stages-->

A program consist of program stages. A program stage defines which
actions should be taken at each stage.

> **Note**
>
> Changes to a program stage is not saved until you save the program.

1. Click the plus sign to create a program stage.
2. Enter program stage details:
    1. Enter a **Name**.
    2.  (Optional) select a **Color** and an **Icon** that will be used
by the data capture apps to identify this program stage.
    3. Enter a **Description**.
    4. In the **Scheduled days from start** field, enter the minimum
number of days to wait for starting the program stage.
3. Enter repeatable program stage details.
    1. Specify if the program stage is **Repeatable** or not.
    2. Select a **Period type**.
    3. Clear **Display generate event box after completed** if you 
    don't want to display *Create new event box* to create new event
    for a repeatable stage after you click *Complete* for an event
    of the stage in data entry form. This field is selected by
    default.
    5. Enter **Standard interval days**. The number of days to repeat the repeatable program stage.  
    6. (Optional) Select a  **Default next scheduled date**. This will show a list of assigned data elements of type **date**. If an element is selected, the Tracker client will use this as the default starting date. The data element can be used by program rules to dynamically schedule intervals between events.
4. Enter form details

    <table>
        <colgroup>
            <col style="width: 50%" />
            <col style="width: 50%" />
        </colgroup>
        <thead>
            <tr class="header">
                <th><p>Option</p></th>
                <th><p>Action</p></th>
            </tr>
        </thead>
        <tbody>
            <tr class="odd">
                <td>
                    <p><strong>Auto-generate event</strong></p>
                </td>
                <td>
                    <p>
                        Clear check box to prevent creating an event of this program
                        stage automatically when a entity is enrolled in the program.
                    </p>
                </td>
            </tr>
            <tr class="even">
                <td>
                    <p><strong>Open data entry form after enrollment</strong></p>
                </td>
                <td>
                    <p>
                        Select check box to automatically open the event of this
                        stage as soon as the entity has enrolled into the program.
                    </p>
                </td>
            </tr>
            <tr class="odd">
                <td>
                    <p><strong>Report date to use</strong></p>
                </td>
                <td>
                    If you have selected the
                    <strong>Open data entry form after enrollment</strong> check
                    box, also select a <strong>Report date to use</strong>:
                    <strong>Date of incident</strong> or
                    <strong>Date of enrollment</strong>.
                    <p>
                        This is the date used as report date for an event that has
                        been opened automatically.
                    </p>
                    <p>
                        If the <strong>Report date to use</strong> is selected as
                        one of those two ('incident date'/'enrollment date'), in
                        Dashboard, the 'Report date' of the event will be set as one
                        of those two.
                    </p>
                </td>
            </tr>
            <tr class="even">
                <td>
                    <p><strong>User assignment of events</strong></p>
                </td>
                <td>
                    <p>
                        Select check box to enable user assignment of the program
                        stage.
                    </p>
                    <p>
                        This means that in Tracker capture there will be a list of
                        users to which the event can be assigned.
                    </p>
                </td>
            </tr>
            <tr class="odd">
                <td>
                    <p><strong>Block entry form after completed</strong></p>
                </td>
                <td>
                    <p>
                        Select check box to block the entry form after completion of
                        the event of this stage.
                    </p>
                    <p>
                        This means that the data in the entry form can't be changed
                        until you reset the status to incomplete.
                    </p>
                </td>
            </tr>
            <tr class="even">
                <td>
                    <p>
                        <strong>Ask user to complete program when stage is
                            completed</strong>
                    </p>
                </td>
                <td>
                    <p>
                        Select check box to trigger a pop-up which asks the user if
                        he/she wants to create the event of next stage.
                    </p>
                </td>
            </tr>
            <tr class="odd">
                <td>
                    <p>
                        <strong>Ask user to create new event when stage is
                            complete</strong>
                    </p>
                </td>
                <td>
                    <p>
                        Select check box to trigger a pop-up which asks the users if
                        he/she wants to create a new event of this stage when an
                        event of this stage is completed.
                    </p>
                    <p>
                        This property is active only if you have selected
                        <strong>Repeatable</strong>.
                    </p>
                </td>
            </tr>
            <tr class="even">
                <td>
                    <p><strong>Generate events by enrollment date</strong></p>
                </td>
                <td>
                    <p>
                        Check on it for auto-generating due dates of events from
                        program-stages of this program based on the enrollment date.
                        If it is not checked, the due dates are generated based on
                        incident date.
                    </p>
                </td>
            </tr>
            <tr class="odd">
                <td>
                    <p><strong>Hide due dates</strong></p>
                </td>
                <td><p>Select checkbox to hide due dates for events.</p></td>
            </tr>
            <tr class="even">
                <td><strong>Feature type</strong></td>
                <td>
                    <p>
                        Sets wether the program is going to capture a geographical
                        feature type or not.
                    </p>
                    <ul>
                    <li><strong>None:</strong>Nothing is captured.</li>
                    <li>
                        <strong>Polygon: </strong> An area is captured. For single
                        event programs the area will be the area representing the
                        event being captured. For tracker programs, the area will
                        represent the area of the enrollment.
                    </li>
                    <li>
                        <strong>Point:</strong>: A point/coordinate is captured. For
                        single event programs the point will be representing the
                        event being captured. For tracker programs, the point will
                        represent the enrollment.
                    </li>
                    </ul>
                </td>
            </tr>
            <tr class="odd">
                <td>
                    <p><strong>Pre-generate event UID</strong></p>
                </td>
                <td>
                    <p>Select check box to pre-generate unique event id numbers.</p>
                </td>
            </tr>
            <tr class="even">
                <td>
                    <p><strong>Description of report date</strong></p>
                </td>
                <td>
                    <p>Type a description of the report date.</p>
                    <p>This description is displayed in the data entry form.</p>
                </td>
            </tr>
            <tr class="odd">
                <td>
                    <p><strong>Description of due date</strong></p>
                </td>
                <td><p>Type a description of the due date.</p></td>
            </tr>
        </tbody>
    </table>

5.  Assign data elements to program stage:

    1.  In the list of **Available data elements**, double-click the
        data elements you want to assign to the program stage.

    2.  For each assigned data element, review the properties. You can
        select:

<table>
    <colgroup>
        <col style="width: 50%" />
        <col style="width: 50%" />
    </colgroup>
    <thead>
        <tr class="header">
            <th><p>Option</p></th>
            <th><p>Action</p></th>
        </tr>
    </thead>
    <tbody>
        <tr class="odd">
            <td>
                <p><strong>Compulsory</strong></p>
            </td>
            <td>
                <p>
                    The value of this data element must be filled into data
                    entry form before completing the event.
                </p>
            </td>
        </tr>
        <tr class="even">
            <td>
                <p><strong>Allow provided elsewhere</strong></p>
            </td>
            <td>
                <p>
                    Specify if the value of this data element comes from other
                    facility, not in the facility where this data is entered.
                </p>
            </td>
        </tr>
        <tr class="odd">
            <td>
                <p><strong>Display in reports</strong></p>
            </td>
            <td>
                <p>
                    Display the value of this data element into the single event
                    without registration data entry function.
                </p>
            </td>
        </tr>
        <tr class="even">
            <td>
                <p><strong>Date in future</strong></p>
            </td>
            <td>
                <p>Allow to select a date in future for date data elements.</p>
            </td>
        </tr>
        <tr class="odd">
            <td>
                <p><strong>Skip synchronization</strong></p>
            </td>
            <td>
                <p>
                    Allow data element to be skipped when running data
                    synchronization jobs.
                </p>
            </td>
        </tr>
        <tr class="even">
            <td>
                <p><strong>Mobile render type</strong></p>
            </td>
            <td>
                <p>
                    Can be used to select different render types for mobile
                    devices. Available options vary depending on the attribute's
                    value type. For example, for a numerical value you may
                    select &quot;Default&quot;, &quot;Value&quot;,
                    &quot;Slider&quot;, &quot;Linear scale&quot;, and
                    &quot;Spinner&quot;.
                </p>
            </td>
        </tr>
        <tr class="odd">
            <td>
                <p><strong>Desktop render type</strong></p>
            </td>
            <td>
                <p>WARNING: NOT IMPLEMENTED YET.</p>
                <p>
                    Can be used to select different render types for desktop
                    (i.e. the web interface). Available options vary depending
                    on the attribute's value type. For example, for a numerical
                    value you may select &quot;Default&quot;, &quot;Value&quot;,
                    &quot;Slider&quot;, &quot;Linear scale&quot;, and
                    &quot;Spinner&quot;.
                </p>
            </td>
        </tr>
    </tbody>
</table>

6. Create data entry forms for program stage

    The data entry forms decide how the data elements will be displayed to
    the user in the **Tracker Capture** app.

   1.  Click **Create data entry form**.

   2.  Click **Basic**, **Section** or **Custom**.

   3.  To create a **Basic** data entry form: Drag and drop the data
       elements in the order you want.

   4.  To create a **Section** data entry form:

       1.  Click the add button and enter a section's name, description and
           render type for desktop and mobile.

       2.  Click the section so it's highlighted by a black border.

       3.  Add data elements by clicking the plus sign next to the data
           elements' names.

       4.  Repeat above steps until you've all the sections you need.

       5.  Change the section order: click the options menu, then drag the
           section to the place you want.

   5.  To create a **Custom** data entry from: Use the WYSIWYG editor to
           create a completely customized form. If you select **Source**, you
           can paste HTML code directly in the editing area. You can also
           insert images for example flags or logos.

   6.  Click add stage.


#### Access

<!--DHIS2-SECTION-ID:tracker_program_access-->

Access options decide who can capture data for the program or view/edit
the program's metadata. A program can be shared to organisation units,
and in addition, the main program and any program stages' access options
can be configured through the **Sharing dialog**. Access options are
available in the **Access** tab.

Assign organization units:

1.  In the organisation tree, double-click the organisation units you
    want to add to the program to.

    You can locate an organisation unit in the tree by expanding the
    branches (click on the arrow symbol), or by searching for it by
    name. The selected organisation units display in orange.

Change roles and access:

1.  Scroll down to the **Roles and access** section.

    The first row shows the main program's access options, and each
    subsequent row shows the options of one program stage. Program
    stages with a warning icon (exclamation mark) contain access options
    that deviate from the main program, meaning they are accessed by a
    different combination of users.

2.  Click on either of the rows and the **Sharing dialog** will show.

3.  Modify the access options accordingly. See documentation on the
    sharing dialog for details.

4.  Click the **Apply** button.

5.  Repeat the process for each program/program stage. You can also copy
    all access options from the main program to your child programs:

    1.  Select the program stages you want to have similar access
        options as the main program by toggling the checkboxes on the
        right hand side of the program stages. You can also choose to
        **Select all** program stages, **Deselect all** program stages
        or **Select similar** stages, in terms of access options, to
        that of the main program. Similar stages are toggled by default.

    2.  Click **Apply to selected stages**

#### Create program notifications

<!--DHIS2-SECTION-ID:create_tracker_program_notifications-->

You can create program notifications for programs with registration and
their program stages. The notifications are sent either via the internal
DHIS2 messaging system, via e-mail or via text messages (SMS). You can
use program notifications to, for example, send an automatic reminder to
a tracked entity 10 days before a scheduled appointment. You use the
program’s tracked entity attributes (for example first name) and program
parameters (for example enrollment date) to create a notification
template.


1.  Open the **Maintenance** app and click **Program and then
    notifications**.

    A list of existing program notifications for the selected program
    opens. If the program doesn't have any program notifications, the
    list is empty.

2.  Click on add button and select **Program notification**.

	![](resources/images/program/what_to_send.png)
![](resources/images/program/where_to_send.png)
	![](resources/images/program/who_to_send.png)	

3.  Enter a **Name**.

4.  Create the **Subject template**.

    Double-click the parameters in the **Parameters** field to add them
    to your subject.

    > **Note**
    >
    > The subject is not included in text messages.

5.  Create the **Message template**.

    Double-click the parameter names in the **Parameters** field to add
    them to your message.

    Dear A{w75KJ2mc4zz}, You're now enrolled in V{program\_name}.

6.  In the **When-to-send it** field, select what should trigger the
    notification.

    <table>
    <colgroup>
    <col style="width: 33%" />
    <col style="width: 33%" />
    <col style="width: 33%" />
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


7.  In the **Who-to-send-it** field, select who should receive the
    program notification.

    <table>
    <colgroup>
    <col style="width: 33%" />
    <col style="width: 33%" />
    <col style="width: 33%" />
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

8.  Click **Save**.


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

5.  Create the **Subject template**.

    Double-click the parameter names in the **Parameters** field to add
    them to your subject.

    > **Note**
    >
    > The subject is not included in text messages.

6.  Create the **Message template**.

    Double-click the parameter names in the **Parameters** field to add
    them to your message.

    Dear A{w75KJ2mc4zz}, please come to your appointment the
    V{due\_date}.

7.  In the **When-to-send-it** field, select what should trigger the
    notification.

    <table>
    <colgroup>
    <col style="width: 33%" />
    <col style="width: 33%" />
    <col style="width: 33%" />
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
    <td><p>Notification will be triggered as a result of program rule execution.</p></td>
    <td><p>Program rule with ProgramRuleActionType.SENDMESSAGE need to be in place to make this trigger successful.</p></td>
    </tr>
    </tbody>
    </table>

8.  In the **Recipients** field, select who should receive the program
    stage notification. You can select:

    <table>
    <colgroup>
    <col style="width: 33%" />
    <col style="width: 33%" />
    <col style="width: 33%" />
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



9.  Click **Save**.


### Reference information: Program notification parameters

<!--DHIS2-SECTION-ID:reference_information_event_program_notification_parameters-->

<table>
<caption>Program notification parameters to use in program notifications</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
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
<td><p>Program stage</p></td>
<td><p>Current date</p></td>
<td><pre><code>V{current_date}</code></pre></td>
</tr>
<tr class="even">
<td></td>
<td><p>Days since due date</p></td>
<td><pre><code>V{days_since_due_date}</code></pre></td>
</tr>
<tr class="odd">
<td></td>
<td><p>Days until due date</p></td>
<td><pre><code>V{days_until_due_date}</code></pre></td>
</tr>
<tr class="even">
<td></td>
<td><p>Due date</p></td>
<td><pre><code>V{due_date}</code></pre></td>
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
<td><p>Program stage name</p></td>
<td><pre><code>V{program_stage_name}</code></pre></td>
</tr>
</tbody>
</table>

## Configure program indicators

<!--DHIS2-SECTION-ID:configure_program_indicator-->

### About program indicators

<!--DHIS2-SECTION-ID:about_program_indicators-->

Program indicators are expressions based on data elements and attributes
of tracked entities which can be used to calculate values based on a
formula. Program indicators consist of an aggregation type, an analytics
type, an expression and a filter.

Program indicators are evaluated based on the assigned aggregation type,
expression and filter. The order of evaluation is:

1.  The *filter* will filter the events which become part of the
    evaluation/aggregation routine.

2.  The *expression* will be evaluated per event.

3.  All evaluated expression values will be *aggregated* according to
    the aggregation type of the program indicator.

<table>
<caption>Program indicator components</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Program rule component</p></th>
<th><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Aggregation type</p></td>
<td><p>The aggregation type determines how the program indicator will be aggregated. The following aggregation types are available:</p>
<ul>
<li><p>Average</p></li>
<li><p>Average (number)</p></li>
<li><p>Average (number, disaggregation)</p></li>
<li><p>Average (sum in organisation unit hierarchy)</p></li>
<li><p>Average (sum of numbers)</p></li>
<li><p>Average (sum of numbers, disaggregation)</p></li>
<li><p>Average (Yes/No)</p></li>
<li><p>Count</p></li>
<li><p>Custom</p>
<p>The &quot;custom&quot; aggregation type allows you to specify the aggregation type in-line in the expression. All other aggregation  types are applied to the entire expression.</p>
<p>Using the &quot;custom&quot; aggregation type might lead to an exception of the order of evaluation described above where individual parts of the expression can be evaluated and aggregated, as opposed to the entire expression being evaluated prior to aggregation.</p></li>
<li><p>Default</p></li>
<li><p>Max</p></li>
<li><p>Min</p></li>
<li><p>None</p></li>
<li><p>Standard deviation</p></li>
<li><p>Sum</p></li>
<li><p>Variance</p></li>
</ul></td>
</tr>
<tr class="even">
<td><p>Analytics type</p></td>
<td><p>The available analytics types are <em>event</em> and <em>enrollment</em>.</p>
<p>The analytics type defines whether the program indicator is calculated based on events or program enrollments. This has an impact on what type of calculations can be made.</p>
<ul>
<li><p>Events implies a data source where each event exists as an independent row. This is suitable for performing aggregations such as counts and sums.</p></li>
<li><p>Enrollments implies a data source where all events for a single enrollment is combined on the same row. This allows for calculations which can compare event data from various program stages within a program enrollment.</p></li>
</ul></td>
</tr>
<tr class="odd">
<td><p>Analytics period boundaries</p></td>
<td><p>Defines the boundaries for the program indicator calculation. The boundaries determine which events or enrollments gets included in aggregations, always relative to the aggregate reporting period start and end. When creating the program indicator, the default boundaries will get preselected based on analytics type.</p>
<ul>
<li><p>For analytics type <em>event</em>, the default boundaries will be configured to encapsulate any events with an event date after the reporting period starts and before the reporting period ends.</p></li>
<li><p>For analytics type <em>enrollment</em>, the default boundaries will encapsulate all enrollments with an enrollment date after the reporting date starts and before the reporting period ends. In addition, the default enrollment program indicator evaluates the newest event for all program stages regardless of date.</p></li>
</ul>
<p>It is possible to change the upper and lower boundaries to include a longer or shorter period relative to the reporting period, or delete one of the boundaries - in effect returning all data before or after a certain period. It is also possible to add more constraints, for example to make an enrollment program indicator only include event data up to a given point in time.</p>
<ul>
<li><p>Boundary target: Can be <em>incident date</em>, <em>event date</em>, <em>enrollment date</em> or <em>custom</em>. Designates what is being constrained by the boundary.</p>
<p><em>custom</em> is used make boundary that target either a date data element, tracked entity attribute or the presence of an event in a program stage. This is done with a custom expression on the form:</p>
<ul>
<li><p>Data element of type date: #{programStageUid.dataElementUid}.</p>
<pre><code>#{A03MvHHogjR.a3kGcGDCuk6}</code></pre></li>
<li><p>Tracked entity attribute of type date: #{attributeUid}.</p>
<pre><code>A{GPkGfbmArby}</code></pre></li>
<li><p>Presence of one event in a specific program stage: PS_EVENTDATE:programStageUid.</p>
<pre><code>PS_EVENTDATE:A03MvHHogjR</code></pre>
<blockquote>
<p><strong>Note</strong></p>
This boundary target is only applicable to
Analytics type Enrollment
</blockquote></li>
</ul></li>
<li><p>Analytics period boundary type: Defines whether the boundary is an end boundary - starting with &quot;before...&quot;, or a start boundary - &quot;after...&quot;. Also defines whether the boundary relates to the end of the aggregate reporting period or the start of the aggregate reporting period.</p></li>
<li><p>Offset period by amount: In some cases, for example cohort analytics, the boundary should be offset relative to the aggregate reporting period when running pivots and reports. The offset period by amount is used to move the current boundary either back(negative) or forward(positive) in time. The amount and period type together will determine how big the offset will be. An example can be when making a simple enrollment cohort program indicator for a 1 year cohort, it might be enough to offset each boundary of the program indicator with &quot;-1&quot; and &quot;Years&quot;</p></li>
<li><p>Period type: See above. Can be any period, e.g. <em>Weekly</em> or <em>Quarterly</em>.</p></li>
</ul></td>
</tr>
<tr class="even">
<td><p>Expression</p></td>
<td><p>The expression defines how the indicator is being calculated. The expression can contain references to various entities which will be substituted with a related values when the indicator is calculated:</p>
<ul>
<li><p>Data elements: Will be substituted with the value of the data element for the time period and organisation unit for which the calculation is done. Refers to both program stage and data element.</p></li>
<li><p>Attributes: Will be substituted with the value of the attribute for the person / tracked entity for which the calculation is done.</p></li>
<li><p>Variables: Will be substituted with special values linked to the program, including incident date and date of enrollment for the person, current date and count of values in the expression for the time period and organisation unit for which the calculation is done.</p></li>
<li><p>Constants: Will be substituted with the value of the constant.</p></li>
</ul>
<p>The expression is a mathematical expression and can also contain operators.</p>
<p>For single event programs and tracker programs with analytics type <em>event</em>, the expression will be evaluated <em>per event</em>, then aggregated according to its aggregation type.</p>
<p>For tracker programs with analytics type <em>enrollment</em>, the expression will be evaluated <em>per enrollment</em>, then aggregated according to its aggregation type.</p></td>
</tr>
<tr class="odd">
<td><p>Filter</p></td>
<td><p>The filter is applied to events and filters the data source used for the calculation of the indicator. I.e. the filter is applied to the set of events before the indicator expression is being evaluated. The filter must evaluate to either true or false. It filter is applied to each individual event. If the filter evaluates to true then the event is included later in the expression evaluation, if not it is ignored. The filter can, in a similar way as expressions, contain references to data elements, attributes and constants.</p>
<p>The program indicator filter can in addition use logical operators. These operators can be used to form logical expressions which ultimately evaluate to either true or false. For example you can assert that multiple data elements must be a specific value, or that specific attributes must have numerical values less or greater than a constant.</p></td>
</tr>
</tbody>
</table>

In the **Maintenance** app, you manage the following program indicator
objects:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Object type</p></th>
<th><p>Available functions</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Program indicator</p></td>
<td><p>Create, edit, clone, share, delete, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Program indicator group</p></td>
<td><p>Create, edit, clone, share, delete, show details and translate</p></td>
</tr>
</tbody>
</table>

### Create or edit a program indicator

<!--DHIS2-SECTION-ID:create_program_indicator-->

> **Note**
>
> A program indicator belongs to exactly one program.

1.  Open the **Maintenance** app and click **Indicator** \> **Program
    indicator**.

2.  Click the add button.

3.  Select a **Program** and enter:

      - **Name**

      - **Short name**

      - **Code**

      - **Color**

      - **Icon**

      - **Description**
4.  Select number of **Decimals in data output**.

5.  Select an **Aggregation type**.

6.  Select a if you want to **Display in form**.

7.  Assign one or multiple **Legend**s.

8.  (Optional) Enter a **Category option combination for aggregate data
    export**.

9.  (Optional) Enter an **Attribute option combination for aggregate
    data export**.

10. Create the expression.

    1.  Click **Edit expression**.

    2.  Create the expression based on mathematical operators and the
        attributes, variables and constants listed to the right.

11. Create the filter.

    1.  Click **Edit filter**.

    2.  Create the expression based on mathematical operators and the
        attributes, variables and constants listed to the right.

12. Click **Save**.

### Create or edit a program indicator group

<!--DHIS2-SECTION-ID:create_program_indicator_group-->

1.  Open the **Maintenance** app and click **Indicator** \> **Program
    indicator group**.

2.  Click the add button.

3.  Enter **Name** and **Code**.

4.  In the list of available program indicators, double-click the
    program indicators you want to assign to your group.

5.  Click **Save**.

### Reference information: Expression and filter examples per value type

<!--DHIS2-SECTION-ID:reference_information_program_indicator-->

The table below shows examples of how to write expressions and filters
for different data element and attribute value types:

<table>
<caption>Expression and filter examples per value type</caption>
<thead>
<tr class="header">
<th>Value types</th>
<th>Example syntax</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Integer</p>
<p>Negative integer</p>
<p>Positive or zero integer</p>
<p>Positive integer</p>
<p>Number</p>
<p>Percentage</p></td>
<td><p>Numeric fields, can be used for aggregation as an expression, or in filters:</p>
<pre><code>#{mCXR7u4kNBW.K0A4BauXJDl} &gt;= 3</code></pre></td>
</tr>
<tr class="even">
<td><p>Yes/No</p>
<p>Yes only</p></td>
<td><p>Boolean fields. Yes is translated to numeric 1, No to numeric 0. Can be used for aggregation as an expression, or in filters:</p>
<pre><code>#{mCXR7u4kNBW.Popa3BauXJss} == 1</code></pre></td>
</tr>
<tr class="odd">
<td><p>Text</p>
<p>Long text</p>
<p>Phone number</p>
<p>Email</p></td>
<td><p>Text fields. Can be checked for equality in filters:</p>
<pre><code>#{mCXR7u4kNBW.L8K4BauIKsl} == &#39;LiteralValue&#39;</code></pre></td>
</tr>
<tr class="even">
<td><p>Date</p>
<p>Age</p></td>
<td><p>Date fields. Most useful when combined with a d2:daysBetween function, which produces a number that can be aggregated as an expression or used in filters:</p>
<pre><code>d2:daysBetween(#{mCXR7u4kNBW.JKJKBausssl},V{enrollment_date}) &gt; 100</code></pre>
<p>Can also directly be checked for equality in filters:</p>
<pre><code>#{mCXR7u4kNBW.JKJKBausssl} == &#39;2011-10-28&#39;</code></pre></td>
</tr>
</tbody>
</table>

### Reference information: Functions, variables and operators to use in program indicator expressions and filters

<!--DHIS2-SECTION-ID:program_indicator_functions_variables_operators-->

An expression that includes both attributes, data elements and constants
looks like this:

    (A{GPkGfbmArby} + #{mCXR7u4kNBW.NFkjsNiQ9PH}) * C{bCqvfPR02Im}

An expression which uses the custom aggregation type and hence can use
inline aggregation types looks like
    this:

    (sum(#{mCXR7u4kNBW.K0A4BauXJDl} * #{mCXR7u4kNBW.NFkjsNiQ9PH}) / sum(#{mCXR7u4kNBW.NFkjsNiQ9PH})) * 100

Note how the "sum" aggregation operator is used inside the expression
itself.

#### Functions to use in a program indicator expression or filter

The program indicator expression and filter support a range of
functions. The functions can be applied to data elements and attributes:

<table>
<caption>Functions to use in a program indicator expression or filter</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 30%" />
<col style="width: 54%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Function</p></th>
<th><p>Arguments</p></th>
<th><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>d2:hasValue</p></td>
<td><p>(object)</p></td>
<td><p>Returns true if the data element/attribute has a value. Can be used in filters to distinguish between the number 0 and no value, and to distinguish between explicit &quot;No&quot; and no selection for a Yes/No field.</p></td>
</tr>
<tr class="even">
<td><p>d2:minutesBetween</p></td>
<td><p>(datetime, datetime)</p></td>
<td><p>Produces the number of minutes between two data elements/attributes of type &quot;date and time&quot;. The static datetime format is 'yyyy-MM-dd hh:mm'. Any of the arguments can be replaced with PS_EVENTDATE:(programStageUid) to compare the latest event date from a given program stage.</p></td>
</tr>
<tr class="odd">
<td><p>d2:daysBetween</p></td>
<td><p>(date, date)</p></td>
<td><p>Produces the number of days between two data elements/attributes of type date. The static date format is 'yyyy-MM-dd'. Any of the arguments can be replaced with PS_EVENTDATE:(programStageUid) to compare the latest event date from a given program stage.</p></td>
</tr>
<tr class="even">
<td><p>d2:weeksBetween</p></td>
<td><p>(date, date)</p></td>
<td><p>Produces the number of full weeks between two data elements/attributes of type date. The static date format is 'yyyy-MM-dd'. Any of the arguments can be replaced with PS_EVENTDATE:(programStageUid) to compare the latest event date from a given program stage.</p></td>
</tr>
<tr class="odd">
<td><p>d2:monthsBetween</p></td>
<td><p>(date, date)</p></td>
<td><p>Produces the number of full months between two data elements/attributes of type date. The static date format is 'yyyy-MM-dd'. Any of the arguments can be replaced with PS_EVENTDATE:(programStageUid) to compare the latest event date from a given program stage.</p></td>
</tr>
<tr class="even">
<td><p>d2:yearsBetween</p></td>
<td><p>(date, date)</p></td>
<td><p>Produces the number of full years between two data elements/attributes of type date. The static date format is 'yyyy-MM-dd'. Any of the arguments can be replaced with PS_EVENTDATE:(programStageUid) to compare the latest event date from a given program stage.</p></td>
</tr>
<tr class="odd">
<td><p>d2:condition</p></td>
<td><p>(boolean-expr, true-expr, false-expr)</p></td>
<td><p>Evaluates the boolean expression and if true returns the true expression value, if false returns the false expression value. The conditional expression must be quoted. The true-expr and false-expr arguments must follow the rules of any program indicator expression (including functions).</p></td>
</tr>
<tr class="even">
<td><p>d2:zing</p></td>
<td><p>(expression)</p></td>
<td><p>Returns zero if the expression is negative, otherwise returns the expression value. The expression must follow the rules of any program indicator expression (including functions).</p></td>
</tr>
<tr class="odd">
<td><p>d2:oizp</p></td>
<td><p>(expression)</p></td>
<td><p>Returns one if the expression is zero or positive, otherwise returns zero. The expression must follow the rules of any program indicator expression (including functions).</p></td>
</tr>
<tr class="even">
<td><p>d2:zpvc</p></td>
<td><p>(object, [,object ...])</p></td>
<td><p>Returns the number of numeric zero and positive values among the given object arguments. Can be provided any number of arguments.</p></td>
</tr>
<tr class="odd">
<td><p>d2:relationshipCount</p></td>
<td><p>([relationshipTypeUid])</p></td>
<td><p>Produces the number of relationships of the given type that is connected to the enrollment or event. When no type is given, all types are counted.</p></td>
</tr>
<tr class="even">
<td><p>d2:count</p></td>
<td><p>(dataElement)</p></td>
<td><p>Useful only for enrollment program indicators. Counts the number of data values that has been collected for the given program stage and data element in the course of the enrollment. The argument data element is supplied with the #{programStage.dataElement} syntax.</p></td>
</tr>
<tr class="odd">
<td><p>d2:countIfValue</p></td>
<td><p>(dataElement, value)</p></td>
<td><p>Useful only for enrollment program indicators. Counts the number of data values that matches the given literal value for the given program stage and data element in the course of the enrollment. The argument data element is supplied with the #{programStage.dataElement} syntax. The value can be a hard coded text or number, for example 'No_anemia' if only the values containing this text should be counted.</p></td>
</tr>
<tr class="even">
<td><p>d2:countIfCondition</p></td>
<td><p>(dataElement, condition)</p></td>
<td><p>Useful only for enrollment program indicators. Counts the number of data values that matches the given condition criteria for the given program stage and data element in the course of the enrollment. The argument data element is supplied with the #{programStage.dataElement} syntax. The condition is supplied as a expression in single quotes, for example '&lt;10' if only the values less than 10 should be counted.</p></td>
</tr>
<tr class="odd">
<td><p>if</p></td>
<td><p>(boolean-expr, true-expr, false-expr)</p></td>
<td><p>Evaluates the boolean expression and if true returns the true expression value, if false returns the false expression value. This is identical to the d2:condition function except that the boolean-expr is not quoted.</p></td>
</tr>
<tr class="even">
<td><p>isNull</p></td>
<td><p>(object)</p></td>
<td><p>Returns true if the object value is missing (null), otherwise false.</p></td>
</tr>
<tr class="odd">
<td><p>isNotNull</p></td>
<td><p>(object)</p></td>
<td><p>Returns true if the object value is not missing (not null), otherwise false.</p></td>
</tr>
<tr class="even">
<td><p>firstNonNull</p></td>
<td><p>(object [, object ...])</p></td>
<td><p>Returns the value of the first object that is not missing (not null). Can be provided any number of arguments. Any argument may also be a numeric or string literal, which will be returned if all the previous objects have missing values.</p></td>
</tr>
<tr class="odd">
<td><p>greatest</p></td>
<td><p>(expression [, expression ...])</p></td>
<td><p>Returns the greatest (highest) value of the expressions given. Can be provided any number of arguments. Each expression must follow the rules of any program indicator expression (including functions).</p></td>
</tr>
<tr class="even">
<td><p>least</p></td>
<td><p>(expression [, expression ...])</p></td>
<td><p>Returns the least (lowest) value of the expressions given. Can be provided any number of arguments. Each expression must follow the rules of any program indicator expression (including functions).</p></td>
</tr>
</tbody>
</table>

A filter that uses the "hasValue" function looks like this:

    d2:hasValue(#{mCXR7u4kNBW.NFkjsNiQ9PH})

A filter that uses the "relationshipCount(relationshipTypeUid)" function looks like this:

    d2:relationshipCount('KLkjshoQ90U')

An expression that uses the "zing" and "oizp" functions looks like this:

    d2:zing(A{GPkGfbmArby}) + d2:oizp(#{mCXR7u4kNBW.NFkjsNiQ9PH}))

An expression that uses the "daysBetween" function looks like this:

    d2:daysBetween(#{mCXR7u4kNBW.k8ja2Aif1Ae},'2015-06-01')

An expression that uses the "yearBetween" function to compare the latest event of the program stage 'mCXR7u4kNBW' to the enrollment date looks like this:

    d2:daysBetween(V{enrollment_date},PS_EVENTDATE:mCXR7u4kNBW)

An expression that uses the "condition" function looks like this:

    d2:condition('#{mCXR7u4kNBW.NFkjsNiQ9PH} > 100',150,50)

An expression that uses the "countIfValue" function to only count the number of times the value 10 has been collected looks like this:

    d2:countIfValue(#{mCXR7u4kNBW.NFkjsNiQ9PH}),10)

An expression that uses the "zpvc" function looks like this:

    d2:zpvc(A{GPkGfbmArby}),#{mCXR7u4kNBW.NFkjsNiQ9PH}),4,-1)

An expression that uses the "if" and "isnull" functions looks like this:

    if(isNull(A{GPkGfbmArby}),10,20)

An expression that uses the "firstNonNull" function looks like this:

    firstNonNull(A{GPkGfbmArby}),#{mCXR7u4kNBW.NFkjsNiQ9PH},44)

An expression that uses the "greatest" function looks like this:

    greatest(#{mCXR7u4kNBW.k8ja2Aif1Ae},#{mCXR7u4kNBW.NFkjsNiQ9PH},1)

#### Variables to use in a program indicator expression or filter

The program indicator expression and filter support a range of
variables:

<table>
<caption>Variables to use in a program indicator expression or filter</caption>
<colgroup>
<col style="width: 21%" />
<col style="width: 78%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Variable</p></th>
<th><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr>
<td><p>event_date</p></td>
<td><p>The date of when the event or the last event in the enrollment took place.</p></td>
</tr>
<tr>
<td><p>creation_date</p></td>
<td><p>The date of when an event or enrollment was created in the system.</p></td>
</tr>
<tr>
<td><p>due_date</p></td>
<td><p>The date of when an event is due.</p></td>
</tr>
<tr>
<td><p>sync_date</p></td>
<td><p>The date of when the event or enrollment was last syncronized with the Android app.</p></td>
</tr>
<tr>
<td><p>incident_date</p></td>
<td><p>The date of the incidence of the event.</p></td>
</tr>
<tr>
<td><p>enrollment_date</p></td>
<td><p>The date of when the tracked entity instance was enrolled in the program.</p></td>
</tr>
<tr>
<td><p>enrollment_status</p></td>
<td><p>Can be used to include or exclude enrollments in certain statuses.</p>
<p>When calculating the haemoglobin improvement/deterioration throughout a pregnancy, it might make sense to only consider completed enrollments. If non-completed enrollments is not filtered out, these will represent half-finished ANC followups, where the final improvement/deterioration is not yet established.</p></td>
</tr>
<tr>
<td><p>current_date</p></td>
<td><p>The current date.</p></td>
</tr>
<tr>
<td><p>value_count</p></td>
<td><p>The number of non-null values in the expression part of the event.</p></td>
</tr>
<tr>
<td><p>zero_pos_value_count</p></td>
<td><p>The number of numeric positive values in the expression part of the event.</p></td>
</tr>
<tr>
<td><p>event_count</p></td>
<td><p>The count of events (useful in combination with filters).</p></td>
</tr>
<tr>
<td><p>enrollment_count</p></td>
<td><p>The count of enrollments (useful in combination with filters). Aggregation type for the program indicator must be COUNT. </p></td>
</tr>
<tr>
<td><p>tei_count</p></td>
<td><p>The count of tracked entity instances (useful in combination with filters). Aggregation type for the program indicator must be COUNT.</p></td>
</tr>
<tr>
<td><p>org_unit_count</p></td>
<td><p>The count of organisation units (useful in combination with filters). Aggregation type for the program indicator must be COUNT.</p></td>
</tr>
<tr>
<td><p>program_stage_name</p></td>
<td><p>Can be used in filters for including only certain program stages in a filter for tracker programs. Uses the name of the program stage:</p>
<pre><code>V{program_stage_name} == &#39;ANC first visit&#39;</code></pre></td>
</tr>
<tr>
<td><p>program_stage_id</p></td>
<td><p>Can be used in filters for including only certain program stages in a filter for tracker programs. Uses the unique identifier of the program stage:</p>
<pre><code>V{program_stage_id} == &#39;YPSSfbmAtt1&#39;</code></pre></td>
</tr>
<tr>
<td><p>analytics_period_start</p></td>
<td><p>Can be used in filters or expressions for comparing any date to the first date in each reporting period.</p>
<pre><code>d2:daysBetween(#{WZbXY0S00lP.w4ky6EkVahL}, V{analytics_period_start})</code></pre></td>
</tr>
<tr>
<td><p>analytics_period_end</p></td>
<td><p>Can be used in filters or expressions for comparing any date to the last inclusive date in each reporting period.</p></td>
</tr>
</tbody>
</table>

A filter that uses the "Analytics period end" variable to only include
women who has an LMP that would be in the first
    trimester:

    d2:daysBetween(#{WZbXY0S00lP.w4ky6EkVahL}, V{analytics_period_end}) <= 84

An expression that uses the "value count" variable looks like
    this:

    (#{A03MvHHogjR.a3kGcGDCuk6} + #{A03MvHHogjR.wQLfBvPrXqq}) / V{value_count}

An expression that uses the "event\_date" and "incident\_date" variables
looks like this:

    d2:daysBetween(V{incident_date},V{event_date})

#### Operators to use in a program indicator filter

<table>
<caption>Operators to use in a program indicator filter</caption>
<colgroup>
<col style="width: 16%" />
<col style="width: 83%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Operator</p></th>
<th><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>and</p></td>
<td><p>Logical AND</p></td>
</tr>
<tr class="even">
<td><p>or</p></td>
<td><p>Logical OR</p></td>
</tr>
<tr class="odd">
<td><p>==</p></td>
<td><p>Equal to</p></td>
</tr>
<tr class="even">
<td><p>!=</p></td>
<td><p>Not equal to</p></td>
</tr>
<tr class="odd">
<td><p>&lt;</p></td>
<td><p>Less than</p></td>
</tr>
<tr class="even">
<td><p>&lt;=</p></td>
<td><p>Less than or equal to</p></td>
</tr>
<tr class="odd">
<td><p>&gt;</p></td>
<td><p>Greater than</p></td>
</tr>
<tr class="even">
<td><p>&gt;=</p></td>
<td><p>Greater than or equal to</p></td>
</tr>
</tbody>
</table>

These operators can be used to form logical expressions which ultimately
evaluate to either true or false. For example you can assert that
multiple data elements must be a specific value, or that specific
attributes must have numerical values less or greater than a constant.

A filter that uses both attributes and data elements looks like this:

    A{cejWyOfXge6} == 'Female' and #{A03MvHHogjR.a3kGcGDCuk6} <= 2

> **Tip**
>
> DHIS2 is using the JEXL library for evaluating expressions which
> supports additional syntax beyond what is covered in this
> documentation. See the reference at the [project home
> page](http://commons.apache.org/proper/commons-jexl/reference/syntax.html)
> to learn how you can create more sophisticated expressions

## Configure program rules

<!--DHIS2-SECTION-ID:configure_program_rule-->

### About program rules

<!--DHIS2-SECTION-ID:about_program_rules-->

Program rules allows you to create and control dynamic behaviour of the
user interface in the **Tracker Capture** and **Event Capture** apps.
During data entry, the program rules expressions are evaluated each time
the user interface is displayed, and each time a data element is
changed. Most types of actions will take effect immediately when the
user enters values in the **Tracker Capture** and **Event Capture**
apps.

<table>
<caption>Program rule components</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Program rule component</p></th>
<th><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Program rule action</p></td>
<td><p>Each program rule contains one or multiple actions. These are the behaviours that are triggered in the user interface when the expression is true. Actions will be applied at once if the expression is true, and will be reverted if the expression is no longer true. There are several types of actions and you can have several actions in one program rule.</p></td>
</tr>
<tr class="even">
<td><p>Program rule expression</p></td>
<td><p>Each program rule has a single expression that determines whether the program rule actions should be triggered, if the expression evaluates to true. If the expression is true the program rule is in effect and the actions will be executed. If the expression is false, the program rule is no longer in effect and the actions will no longer be applied.</p>
<p>You create the expression with standard mathematical operators, custom functions, user-defined static values and program rule variables. The program rule variables represent attribute and data element values which will be evaluated as part of the expression.</p></td>
</tr>
<tr class="odd">
<td><p>Program rule variable</p></td>
<td><p>Program rule variables lets you include data values and attribute values in program rule expressions. Typically, you'll have to create one or several program rule variables before creating a program rule. This is because program rules expressions usually contain at least one data element or attribute value to be meaningful.</p>
<p>The program rule variables are shared between all rules in your program. When you create multiple program rules for the same program, these rules will share the same library of program rule variables.</p></td>
</tr>
</tbody>
</table>

In the **Maintenance** app, you manage the following program rule
objects:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Object type</p></th>
<th><p>Available functions</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>Program rule</p></td>
<td><p>Create, edit, clone, delete, show details and translate</p></td>
</tr>
<tr class="even">
<td><p>Program rule variable</p></td>
<td><p>Create, edit, clone, share, delete, show details and translate</p></td>
</tr>
</tbody>
</table>

### Workflow

<!--DHIS2-SECTION-ID:workflow_program_rule-->

1.  In the **Maintenance** app, create program rule variable(s) if
    needed.

2.  In the **Maintenance** app, create the program rule:

    1.  Enter the program rule details.

    2.  Create the program rule expression.

    3.  Define the program rule actions.

3.  In the **Tracker Capture** or **Event Capture** apps, verify that
    the program rule behaves as expected.

### Create or edit a program rule variable

<!--DHIS2-SECTION-ID:create_program_rule_variable-->

1.  Open the **Maintenance** app and click **Program** \> **Program rule
    variable**.

2.  Click the add button.

3.  Select a **Program** and enter a **Name**.

4.  Select if you want to **Use code for option set**.

    This option is only effective when the data element or tracked
    entity attribute is connected to an option set. If you don't select
    this option, the program rule variable will be populated with the
    option set's name. If you select the option, the program rule
    variable will be populated with the option set's code instead.

5.  Select a **Source type** and enter the required information.

    Depending on the source type, you'll have to select, for example, a
    **Program stage,** **Data element** or **Tracked entity attribute**.

    The source types determine how the program rule variable is
    populated with a value.

    <table>
    <colgroup>
    <col style="width: 50%" />
    <col style="width: 50%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th><p>Source type</p></th>
    <th><p>Description</p></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><p><strong>Data element from the newest event for a program stage</strong></p></td>
    <td><p>This source type works the same way as <strong>Data element from the newest event in the current program</strong>, except that it only evaluates values from one program stage.</p>
    <p>This source type can be useful in program rules where the same data element is used in several program stages, and a rule needs to evaluate the newest data value from within one specific stage.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Data element from the newest event in the current program</strong></p></td>
    <td><p>This source type is used when a program rule variable needs to reflect the newest known value of a data element, regardless of what event the user currently has open.</p>
    <p>This source type is populated slightly differently in <strong>Tracker Capture</strong> and <strong>Event Capture</strong> apps:</p>
    <p><strong>Tracker Capture</strong>: the program rule variable will be populated with the newest data value collected for the given data element within the enrollment.</p>
    <p><strong>Event Capture</strong>: the program rule variable will be populated with the newest data value found within the 10 newest events in the same organisation unit.</p>
    <p>The newest data value is determined with event date.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Data element in current event</strong></p></td>
    <td><p>Program rule variables with this source type will contain the data value from the same event that the user currently has open.</p>
    <p>This is the most commonly used source type, especially for skip logic (hide actions) and warning/error rules.</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Data element from previous event</strong></p></td>
    <td><p>Program rule variables with this source type will contain the value from a specified data element from a previous event. Only older events is evaluated, not including the event that the user currently has open.</p>
    <p>This source type is commonly used when a data element only should be collected once during an enrollment, and should be hidden in subsequent events.</p>
    <p>Another use case is making rules for validating input where there is an expected progression from one event to the next - a rule can evaluate whether the previous value is higher/lower and give a warning if an unexpected value is entered.</p>
    <p>This source type is populated slightly differently in <strong>Tracker Capture</strong> and <strong>Event Capture</strong> apps:</p>
    <p><strong>Tracker Capture</strong>: the program rule variable will be populated with the newest data value collected for the given data element within the enrollment - but only evaluating the events that comes before the current event date.</p>
    <p><strong>Event Capture</strong>: the program rule variable will be populated with the newest data value collected within the 10 events preceding the current event date - not including the current event.</p>
    <p>The newest data value is determined with event date.</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Calculated value</strong></p></td>
    <td><p>Program rule variable with this source type is not connected directly to any form data - but will be populated as a result of some other program rules <strong>ASSIGN</strong> action.</p>
    <p>This variable will be used for making preliminary calculations, having a <strong>ASSIGN</strong> program rule action and assigning a value, this value can be used by other program rules - potentially making the expressions simpler and more maintanable.</p>
    <p>These variables will not be persisted and will stay in memory only during the exectution of the set of program rules. Any program rule that assigns a data value to a preliminary calculated value would normally also have a <strong>priority</strong> assigned - to make sure that the preliminary caculation is done before the rule that consumes the calculated value.</p>
    </td>
    </tr>
    <tr class="even">
    <td><p><strong>Tracked entity attribute</strong></p></td>
    <td><p>Populates the program rule variable with a specified tracked entity attribute for the current enrollment.</p>
    <p>Use this is the source type to create program rules that evaluate data values entered during registration.</p>
    <p>This source type is also useful when you create program rules that compare data in events to data entered during registration.</p>
    <p>This source type is only used for tracker programs (programs with registration).</p></td>
    </tr>
    </tbody>
    </table>

6.  Click **Save**.

### Create or edit a program rule

<!--DHIS2-SECTION-ID:create_program_rule-->

> **Note**
>
> A program rule belongs to exactly one program.

1.  Open the **Maintenance** app and click **Program** \> **Program
    rule**.

2.  Click the add button.

3.  Enter the program rule details. These fields are not shown to the
    end user, they are only meant for the program administrator.

      - **Program**

      - **Trigger rule only for program stage**

        If a program stage is selected, the program rule will only run for the selected program stage,
        as opposed to being run for every program stage in the program.

      - **Name**

      - **Description**

      - **Priority**

        Let's say you have 16 program rules in your program. You
        configure the program rules with the following priority
        settings:

          - Priority 1 for program rule A

          - Priority 2 for program rules B - K

          - No priority for program rules L - P

        Result: the system runs the program rules in the following
        order:

        1.  Program rule A

        2.  Program rules B - K (you can't find out or configure in
            which order the system runs these program rules)

        3.  Program rules L - P.

4.  Click **Enter program rule expression** and create the program rule
    expression with the help of variables, functions and operators.

5.  Click **Define program rule actions** and create the actions
    executed when the expression is true.

    1.  Click the add button, select an **Action** and enter the
        required information.

        Depending on the action type, you'll have to perform different
        types of settings. For some action types, you must also enter
        free text or create expressions.

        <table>
        <colgroup>
        <col style="width: 33%" />
        <col style="width: 33%" />
        <col style="width: 33%" />
        </colgroup>
        <thead>
        <tr class="header">
        <th><p>Action type</p></th>
        <th><p>Required settings</p></th>
        <th><p>Description</p></th>
        </tr>
        </thead>
        <tbody>
        <tr class="odd">
        <td></td>
        <td></td>
        <td></td>
        </tr>
        <tr class="even">
        <td><p><strong>Assign value</strong></p></td>
        <td><p><strong>Data element to assign value to</strong></p>
        <p><strong>Program rule variable to assign value to</strong></p>
        <p><strong>Expression to evaluate and assign</strong></p></td>
        <td><p>Used to help the user calculate and fill out fields in the data entry form. The idea is that the user shouldn’t have to fill in values that the system can calculate, for example BMI.</p>
        <p>When a field is assigned a value, the user sees the value but the user can't edit it.</p>
        <p>Example from Immunization stock card i Zambia: The data element for vaccine stock outgoing balance is calculated based on the data element for incoming stock balance minus the data elements for consumption and wastage.</p>
        <p>Advanced use: configure an 'assign value' to do a part of a calculation and then assign the result of the calculation to a program rule variable. This is the purpose with the &quot;Calculated value&quot; program rule variable.</p></td>
        </tr>
        <tr class="odd">
        <td><p><strong>Display text</strong></p></td>
        <td><p><strong>Display widget</strong></p>
        <p><strong>Static text</strong></p>
        <p><strong>Expression to evaluate and display after static text</strong></p></td>
        <td><p>Used to display information that is not an error or a warning, for example feedback to the user. You can also use this action to display important information, for example the patient's allergies, to the user.</p></td>
        </tr>
        <tr class="even">
        <td><p><strong>Display key/value pair</strong></p></td>
        <td><p><strong>Display widget</strong></p>
        <p><strong>Key label</strong></p>
        <p><strong>Expression to evaluate and display as value</strong></p></td>
        <td><p>Used to display information that is not an error or a warning.</p>
        <p>Example: calculate number of weeks and days in a pregnancy and display it in the format the clinician is used to see it in. The calculation is based on previous recorded data.</p></td>
        </tr>
        <tr class="odd">
        <td><p><strong>Error on complete</strong></p></td>
        <td><p><strong>Data element to display error next to</strong></p>
        <p><strong>Tracked entity attribute to display error next to</strong></p>
        <p><strong>Static text</strong></p>
        <p><strong>Expression to evaluate and display after static text</strong></p></td>
        <td><p>Used whenever you've cross-consistencies in the form that must be strictly adhered to. This action prevents the user from continuing until the error is resolved.</p>
        <p>This action differs from the regular <strong>Show error</strong> since the error is not shown until the user tries to actually complete the form.</p>
        <p>If you don't select a data element or a tracked entity attribute to display the error next to, make sure you write a comprehensive error message that helps the user to fix the error.</p></td>
        </tr>
        <tr class="even">
        <td><p><strong>Hide field</strong></p></td>
        <td><p><strong>Data element to hide</strong></p>
        <p><strong>Tracked entity attribute to hide</strong></p>
        <p><strong>Custom message for blanked field</strong></p></td>
        <td><p>Used when you want to hide a field from the user.</p>
        <p><strong>Custom message for blanked field</strong> allows you to define a custom message displayed to the user in case the program rule hides and blanks out the field after the user typed in or selected a value.</p>
        <p>If a hide field action hides a field that contains a value, the field will always removed. If no message is defined, a standard message will be displayed to alert the user.</p></td>
        </tr>
        <tr class="odd">
        <td><p><strong>Hide section</strong></p></td>
        <td><p><strong>Program stage section to hide</strong></p></td>
        <td><p>TBA</p></td>
        </tr>
        <tr class="even">
        <td><p><strong>Hide program stage</strong></p></td>
        <td><p><strong>Program stage to hide</strong></p></td>
        <td><p>Used when you want to hide a program stage section from the user.</p></td>
        </tr>
        <tr class="odd">
        <td><p><strong>Make field mandatory</strong></p></td>
        <td><p><strong>Data element to make mandatory</strong></p>
        <p><strong>Tracked entity attribute to make mandatory</strong></p></td>
        <td><p>TBA</p></td>
        </tr>
        <tr class="even">
        <td><p><strong>Show error</strong></p></td>
        <td><p><strong>Data element to display error next to</strong></p>
        <p><strong>Tracked entity attribute to display error next to</strong></p>
        <p><strong>Static text</strong></p>
        <p><strong>Expression to evaluate and display after static text</strong></p></td>
        <td><p>Used whenever there are rules which must strictly be adhered to. The show error action prevents the user from continuing until the error is resolved.</p>
        <p>Such a strict validation should only be used when it's certain that the evaluated expression is never true unless the user has made a mistake in data entry.</p>
        <p>It's mandatory to define a message that is shown to the user when the expression is true and the action is triggered.</p>
        <p>You can select which data element or tracked entity attribute to link the error to. This will help the user to fix the error.</p>
        <p>In case several data elements or attributes are involved, select the one that is most likely that the user would need to change.</p></td>
        </tr>
        <tr class="odd">
        <td><p><strong>Show warning</strong></p></td>
        <td><p><strong>Data element to display warning next to</strong></p>
        <p><strong>Tracked entity attribute to display warning next to</strong></p>
        <p><strong>Static text</strong></p>
        <p><strong>Expression to evaluate and display after static text</strong></p></td>
        <td><p>Used to give the user a warning about the entered data, but at the same time to allow the user to save and continue.</p>
        <p>You can use warnings to help the user avoid errors in the entered data, while at the same time allow the user to consciously disregard the warnings and save a value that is outside preset expectations.</p>
        <p><strong>Static text</strong> defines the message shown to the user when the expression is true and the action is triggered.</p>
        <p>You can select which data element or tracked entity attribute to link the error to. This will help the user to fix the error.</p>
        <p>In case several data elements or attributes are involved, select the one that is most likely that the user would need to change.</p></td>
        </tr>
        <tr class="even">
        <td><p><strong>Warning on complete</strong></p></td>
        <td><p><strong>Data element to display warning next to</strong></p>
        <p><strong>Tracked entity attribute to display warning next to</strong></p>
        <p><strong>Static text</strong></p>
        <p><strong>Expression to evaluate and display after static text</strong></p></td>
        <td><p>Used to give the user a warning if he/she tries to complete inconsistent data, but at the same time to allow the user to continue. The warning is shown in a dialog when the user completes the form.</p>
        <p><strong>Static text</strong> defines the message shown to the user when the expression is true and the action is triggered. This field is mandatory.</p>
        <p>You can select which data element or tracked entity attribute to link the error to. This will help the user to fix the error.</p>
        <p>If you don't select a data element or a tracked entity attribute to display the error next to, make sure you write a comprehensive error message that helps the user to fix the error.</p></td>
        </tr>
        <tr class="odd">
        <td><p><strong>Send Message</strong></p></td>
        <td><p><strong>Message template to send</strong></p></td>
        <td><p>Send Message triggers a notification based on provided message template. This action will be taken when ever there is a change in <strong>data value</strong>. However this behaviour can be controlled by providing event/enrollment status in program rule expression for example.</p>
        <pre><code>V{event_status} == &#39;COMPLETED&#39;</code></pre>
        <p>Message template will be parsed and variables will be substituted with actual values.</p></td>
        </tr>
        <tr class="even">
        <td><p><strong>Schedule Message</strong></p></td>
        <td><p><strong>Message template to send</strong></p>
        <p><strong>Data field which contains expression to evaluate the date which notification should be sent at. If this expression results in any value other than Date, then resultant will be discarded and notification will not get scheduled.</strong></p></td>
        <td><p>Schedule Message will schedule notification at date provided by Expression in the data field. Sample expression is given below</p>
        <pre><code>d2:addDays( &#39;2018-04-20&#39;, &#39;2&#39; )</code></pre>
        <p>Message template will be parsed and variables will be substituted with actual values.</p></td>
        </tr>
        <tr class="odd">
        <td><p><strong>Hide option</strong></p></td>
        <td><p><strong>Data element to hide option for</strong></p>
        <p><strong>Tracked entity attribute to hide option for</strong></p>
        <p><strong>Option that should be hidden</strong></p></td>
        <td><p>Used to selectively hide a single option for an option set in a given data element/tracked entity attribute.</p>
        <p>When combined with <strong>show option group</strong> the <strong>hide option</strong> takes presedence.</p></td>
        </tr>
        <tr class="even">
        <td><p><strong>Hide option group</strong></p></td>
        <td><p><strong>Data element to hide option group for</strong></p>
        <p><strong>Tracked entity attribute to hide option group for</strong></p>
        <p><strong>Option group that should be hidden</strong></p></td>
        <td><p>Used to hide all options in a given option group and data element/tracked entity attribute.</p>
        <p>When combined with <strong>show option group</strong> the <strong>hide option group</strong> takes precedence.</p></td>
        </tr>
        <tr class="odd">
        <td><p><strong>Show option group</strong></p></td>
        <td><p><strong>Data element to show option group for</strong></p>
        <p><strong>Tracked entity attribute to show option group for</strong></p>
        <p><strong>Option group that should be shown</strong></p></td>
        <td><p>Used to show only options from a given option group in a given data element/tracked entity attribute. To show an option group implicitly hides all options that is not part of the group(s) that is shown.</p></td>
        </tr>
        </tbody>
        </table>

    2.  Click **Save**.

    3.  (Optional) Repeat above steps to add more actions.

6.  Click **Save**.

### Example: Program rules

<!--DHIS2-SECTION-ID:program_rule_examples-->

> **Note**
>
> You can view all examples on the demo server:
> <https://play.dhis2.org/dev/dhis-web-maintenance/#/list/programSection/programRule>

This example shows how to configure a program rule which calculate
number of weeks and days in a pregnancy and display the result in the
format the clinician is used to see it in. The calculation is based on
previous recorded
    data.

1.  ![](resources/images/maintainence/pg_rule_ex/keyvaluepair_details.png)

2.  ![](resources/images/maintainence/pg_rule_ex/keyvaluepair_expression.png)

3.  ![](resources/images/maintainence/pg_rule_ex/keyvaluepair_action.png)

    The full expression in the **Data** field:

        d2:concatenate(d2:weeksBetween(#{lmp}, V{current_date}), '+',
        d2:modulus(d2:daysBetween(#{lmp}, V{current_date}), 7))

![](resources/images/maintainence/pg_rule_ex/keyvaluepair_result.png)

This example shows how to configure a program rule to display text in
the Feedback widget in the **Tracker Capture**
    app.

1.  ![](resources/images/maintainence/pg_rule_ex/displaytext_pgrule_variable.png)

2.  ![](resources/images/maintainence/pg_rule_ex/displaytext_details.png)

3.  ![](resources/images/maintainence/pg_rule_ex/displaytext_expression.png)

4.  ![](resources/images/maintainence/pg_rule_ex/displaytext_action.png)

![](resources/images/maintainence/pg_rule_ex/displaytext_result.png)

This example shows how to configure a program rule to always display
certain data in the Feedback widget in the **Tracker Capture** app. This
is useful when you want to make sure that vital data, for example
medicine allergies, is always
    visible.

1.  ![](resources/images/maintainence/pg_rule_ex/displaytext2_pgrule_variable.png)

2.  ![](resources/images/maintainence/pg_rule_ex/displaytext2_details.png)

3.  ![](resources/images/maintainence/pg_rule_ex/displaytext2_expression.png)

4.  ![](resources/images/maintainence/pg_rule_ex/displaytext2_action.png)

![](resources/images/maintainence/pg_rule_ex/displaytext2_first_pgstage.png)

![](resources/images/maintainence/pg_rule_ex/displaytext2_result.png)

By using a program rule of type "Assign value" you can calculate the
"Gestational age at visit" value and fill it in the data entry form. You
configure the program rule to calculate "Gestational age at visit" based
on either "LMP date" or "Ultrasound estimated due
date".

1.  ![](resources/images/maintainence/pg_rule_ex/assign_details.png)

2.  ![](resources/images/maintainence/pg_rule_ex/assign_expression.png)

3.  ![](resources/images/maintainence/pg_rule_ex/assign_action.png)

![](resources/images/maintainence/pg_rule_ex/assign_result.png)

### Reference information: Operators and functions to use in program rule expression

<!--DHIS2-SECTION-ID:program_rules_operators_functions-->

> **Tip**
>
> You can nest functions within each other and with sub-expressions to
> form more complex conditions. An example that produces the gestational
> age in weeks, based on last menstrual date:
>
>     d2:floor( d2:daysBetween(#{lastMenstrualDate},V{event_date}) / 7 )

> **Tip**
>
> The source type will determine how the d2: function calls will
> evaluate a (sourcefield) parameter.
>
> Example: where \#{hemoglobinCurrent} is set to source type **Data
> element in current event**. The following function call with evaluate
> whether haemoglobin is entered in the current event.
>
>     d2:hasValue( 'hemoglobinCurrent' )
>
> Example: where \#{hemoglobin} is set to source type **Data element
> from the newest event in the current program**. The following function
> call with evaluate whether there exists a value for the haemoglobin in
> any event in the enrollment.
>
>     d2:hasValue( 'hemoglobin' )
>
> Example: where \#{hemoglobinPrevious} is set to source type **Data
> element from previous event** . The following function call with
> evaluate whether there exists a value for the haemoglobin among the
> events preceding the current event.
>
>     d2:hasValue( 'hemoglobinPrevious' )

<table>
<caption>Possible operators to use in a program rule expression</caption>
<colgroup>
<col style="width: 16%" />
<col style="width: 83%" />
</colgroup>
<thead>
<tr class="header">
<th>Operator</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>+</p></td>
<td><p>Add numbers together</p></td>
</tr>
<tr class="even">
<td><p>-</p></td>
<td><p>Subtract numbers from each other</p></td>
</tr>
<tr class="odd">
<td><p>*</p></td>
<td><p>Multiply two numbers</p></td>
</tr>
<tr class="even">
<td><p>/</p></td>
<td><p>Divide two numbers</p></td>
</tr>
<tr class="odd">
<td><p>%</p></td>
<td><p>The modulus of two numbers</p></td>
</tr>
<tr class="even">
<td><p>&amp;&amp;</p></td>
<td><p>Logical AND. True only when the expression on the left and right side is true. The left and right side can be yes/no, yes only or a sub-expression in parenthesis.</p></td>
</tr>
<tr class="odd">
<td><p>||</p></td>
<td><p>Logical OR. True when either the expression on the left or the expression on the right side is true. The left and right side can be yes/no, yes only or a sub-expression in parenthesis.</p></td>
</tr>
<tr class="even">
<td><p>&gt;</p></td>
<td><p>Left number greater than right number</p></td>
</tr>
<tr class="odd">
<td><p>&gt;=</p></td>
<td><p>Left number greater than or equal to right number</p></td>
</tr>
<tr class="even">
<td><p>&lt;</p></td>
<td><p>Left number less than right number</p></td>
</tr>
<tr class="odd">
<td><p>&lt;=</p></td>
<td><p>Left number less than or equal to right number.</p></td>
</tr>
<tr class="even">
<td><p>==</p></td>
<td><p>Left side equal to right side. Supports numbers, text, yes/no and yes only.</p></td>
</tr>
<tr class="odd">
<td><p>!=</p></td>
<td><p>Left side not equal to right side. Supports numbers, text, yes/no and yes only.</p></td>
</tr>
<tr class="even">
<td><p>!</p></td>
<td><p>Negates the following value. Can be used for yes/no, yes only or a sub-expression in parenthesis.</p></td>
</tr>
<tr class="odd">
<td><p>()</p></td>
<td><p>Parenthesis is used to group sub-expressions.</p></td>
</tr>
</tbody>
</table>

<table>
<caption>Custom functions to use in a program rule expression</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 30%" />
<col style="width: 54%" />
</colgroup>
<thead>
<tr class="header">
<th>Function</th>
<th>Arguments</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>d2:ceil</td>
<td>(number)</td>
<td>Rounds the input argument <strong>up</strong> to the nearest whole number.
<p>Example:</p>
<pre><code>d2:ceil(#{hemoglobinValue})</code></pre></td>
</tr>
<tr class="even">
<td>d2:floor</td>
<td>(number)</td>
<td>Rounds the input argument <strong>down</strong> to the nearest whole number.
<p>An example producing the number of weeks the woman is pregnant. Notice that the sub-expression #{gestationalAgeDays}/7 is evaluated before the floor function is executed:</p>
<pre><code>d2:floor(#{gestationalAgeDays}/7)</code></pre></td>
</tr>
<tr class="odd">
<td>d2:round</td>
<td>(number)</td>
<td>Rounds the input argument to the nearest whole number.</td>
</tr>
<tr class="even">
<td>d2:modulus</td>
<td>(number,number)</td>
<td>Produces the modulus when dividing the first with the second argument.
<p>An example producing the number of days the woman is into her current pregnancy week:</p>
<pre><code>d2:modulus(#{gestationalAgeDays},7)</code></pre></td>
</tr>
<tr class="odd">
<td>d2:zing</td>
<td>(number)</td>
<td>Evaluates the argument of type number to zero if the value is negative, otherwise to the value itself.</td>
</tr>
<tr class="even">
<td>d2:oizp</td>
<td>(number)</td>
<td>Evaluates the argument of type number to one if the value is zero or positive, otherwise to zero.</td>
</tr>
<tr class="odd">
<td>d2:concatenate</td>
<td>(object, [,object, object,...])</td>
<td>Produces a string concatenated string from the input parameters. Supports any number of parameters. Will mainly be in use in future action types, for example to display gestational age with d2:concatenate('weeks','+','gestationalageDays').</td>
</tr>
<tr class="even">
<td>d2:daysBetween</td>
<td>(date, date)</td>
<td>Produces the number of days between the first and second argument. If the second argument date is before the first argument the return value will be the negative number of days between the two dates. The static date format is 'yyyy-MM-dd'.
<p>Example, calculating the gestational age(in days) of a woman, based on the last menstrual period and the current event date:</p>
<pre><code>d2:daysBetween(#{lastMenstrualDate},V{event_date})</code></pre></td>
</tr>
<tr class="odd">
<td>d2:weeksBetween</td>
<td>(date, date)</td>
<td>Produces the number of full weeks between the first and second argument. If the second argument date is before the first argument the return value will be the negative number of weeks between the two dates. The static date format is 'yyyy-MM-dd'.</td>
</tr>
<tr class="even">
<td>d2:monthsBetween</td>
<td>(date, date)</td>
<td>Produces the number of full months between the first and second argument. If the second argument date is before the first argument the return value will be the negative number of months between the two dates. The static date format is 'yyyy-MM-dd'.</td>
</tr>
<tr class="odd">
<td>d2:yearsBetween</td>
<td>(date, date)</td>
<td>Produces the number of years between the first and second argument. If the second argument date is before the first argument the return value will be the negative number of years between the two dates. The static date format is 'yyyy-MM-dd'.</td>
</tr>
<tr class="even">
<td>d2:addDays</td>
<td>(date, number)</td>
<td>Produces a date based on the first argument date, adding the second argument number of days.
<p>An example calculating the pregnancy due date based on the last menstrual period:</p>
<pre><code>d2:addDays(#{lastMenstrualDate},283)</code></pre></td>
</tr>
<tr class="odd">
<td>d2:count</td>
<td>(sourcefield)</td>
<td>Counts the number of values that is entered for the source field in the argument. The source field parameter is the name of one of the defined source fields in the program - see example
<p>Example usage where #{previousPregnancyOutcome} is one of the source fields in a repeatable program stage &quot;previous pregnancy&quot;:</p>
<pre><code>d2:count(&#39;previousPregnancyOutcome&#39;)</code></pre></td>
</tr>
<tr class="even">
<td>d2:countIfValue</td>
<td>(sourcefield,text)</td>
<td>Counts the number of matching values that is entered for the source field in the first argument. Only occurrences that matches the second argument is counted. The source field parameter is the name of one of the defined source fields in the program - see example.
<p>Example usage where #{previousPregnancyOutcome} is one of the source fields in a repeatable program stage &quot;previous pregnancy&quot;. The following function will produce the number of previous pregnancies that ended with abortion:</p>
<pre><code>d2:countIfValue(&#39;previousPregnancyOutcome&#39;,&#39;Abortion&#39;)
                                    </code></pre></td>
</tr>
<tr class="odd">
<td>d2:countIfZeroPos</td>
<td>(sourcefield)</td>
<td>Counts the number of values that is zero or positive entered for the source field in the argument. The source field parameter is the name of one of the defined source fields in the program - see example.
<p>Example usage where #{fundalHeightDiscrepancy} is one of the source fields in program, and it can be either positive or negative. The following function will produce the number of positive occurrences:</p>
<pre><code>d2:countIfZeroPos(&#39;fundalHeightDiscrepancy&#39;)
                                    </code></pre></td>
</tr>
<tr class="even">
<td>d2:hasValue</td>
<td>(sourcefield)</td>
<td>Evaluates to true of the argument source field contains a value, false if no value is entered.
<p>Example usage, to find if the source field #{currentPregnancyOutcome} is yet filled in:</p>
<pre><code>d2:hasValue(&#39;currentPregnancyOutcome&#39;)
                                    </code></pre></td>
</tr>
<tr class="odd">
<td>d2:zpvc</td>
<td>(object, [,object, object,...])</td>
<td>Returns the number of numeric zero and positive values among the given object arguments. Can be provided with any number of arguments.</td>
</tr>
<tr class="even">
<td>d2:validatePattern</td>
<td>(text, regex-pattern)</td>
<td>Evaluates to true if the input text is an exact match with the supplied regular expression pattern. The regular expression needs to be escaped.
<p>Example expression, triggering actions if a number is not on the pattern 9999/99/9:</p>
<pre><code>!d2:validatePattern(A{nrc},&#39;\\d{6}\/\\d{2}\/\\d&#39;)</code></pre>
<p>Example expression, triggering actions that if the address is not consisting of letters or white spaces, then a white space, then a number:</p>
<pre><code>!d2:validatePattern(A{registrationAddress},&#39;[\\w ]+ \\d+&#39;)</code></pre>
<p>Example, triggering actions if a name contains any numbers:</p>
<pre><code>!d2:validatePattern(A{name},&#39;[^\\d]*&#39;)</code></pre>
<p>Example expression, triggering actions if a mobile number contains the illegal number sequence 555:</p>
<pre><code>d2:validatePattern(A{mobile} ,&#39;.*555.*&#39;)</code></pre></td>
</tr>
<tr class="odd">
<td>d2:left</td>
<td>(text, num-chars)</td>
<td>Evaluates to the left part of a text, num-chars from the first character.
<p>The text can be quoted or evaluated from a variable:</p>
<pre><code>d2:left(#{variableWithText}, 3)</code></pre></td>
</tr>
<tr class="even">
<td>d2:right</td>
<td>(text, num-chars)</td>
<td>Evaluates to the right part of a text, num-chars from the last character.
<p>The text can be quoted or evaluated from a variable:</p>
<pre><code>d2:right(#{variableWithText}, 2)</code></pre></td>
</tr>
<tr class="odd">
<td>d2:substring</td>
<td>(text, start-char-num, end-char-num)</td>
<td>Evaluates to the part of a string specified by the start and end character number.
<p>Example expression:</p>
<pre><code>d2:substring(#{variableWithText}, 1, 3)</code></pre>
If the #{variableWithText} in the above example was 'ABCD', then the result of the evaluation would be 'BC'</td>
</tr>
<tr class="even">
<td>d2:split</td>
<td>(text, delimiter, element-num)</td>
<td>Split the text by delimiter, and keep the nth element(0 is the first).
<p>The text can be quoted or evaluated from a variable, the delimiter must be quoted:</p>
<pre><code>d2:split(#{variableWithText}, &#39;-&#39;, 1)</code></pre>
<p>Note: comma delimiter(,) is not supported.</p></td>
</tr>
<tr class="odd">
<td>d2:length</td>
<td>(text)</td>
<td>Find the length of a string.
<p>Example:</p>
<pre><code>d2:length(#{variableWithText})</code></pre></td>
</tr>
<tr class="even">
<td>d2:inOrgUnitGroup</td>
<td>(text)</td>
<td>Evaluates whether the current organisation unit is in the argument group. The argument can be defined with either ID or organisation unit group code. The current organisation unit will be the event organisation unit when the rules is triggered in the context of an event, and the enrolling organisation unit when the rules is triggered in the event of a TEI registration form.
<p>Example expression:</p>
<pre><code>d2:inOrgUnitGroup(&#39;HIGH_RISK_FACILITY&#39;)</code></pre></td>
</tr>
<tr class="odd">
<td>d2:hasUserRole</td>
<td>(user role)</td>
<td>Returns true if current user has this role otherwise false
<p>Example expression:</p>
<pre><code>d2:hasUserRole(&#39;UYXOT4A3ASA&#39;)</code></pre></td>
</tr>
<tr class="even">
<td>d2:zScoreWFA</td>
<td>Z-Score weight for age indicator</td>
<td>Calculates z-score based on data provided by WHO weight-for-age indicator.
e varies between -3.5 to 3.5 depending upon the value of weight.
<p>Example expression:</p>
<pre><code>d2:zScoreWFA( ageInMonths, weight, gender )</code></pre>

> **Gender**
>
> Gender is concidered female by default. Any of the following codes can
> be used to denote male: 'Male', 'MALE', 'male', 'ma', 'm', 'M', 0, false

</td>
</tr>
<tr class="odd">
<td>d2:zScoreHFA</td>
<td>Z-Score height for age indicator</td>
<td>Calculates z-score based on data provided by WHO height-for-age indicator.
Its value varies between -3.5 to 3.5 depending upon the value of height.
<p>Example expression:</p>
<pre><code>d2:zScoreHFA( ageInMonths, height, gender )</code></pre></td>
</tr>
<tr class="even">
<td>d2:zScoreWFH</td>
<td>Z-Score weight for height indicator</td>
<td>Calculates z-score based on data provided by WHO weight-for-height indicator.
Its value varies between -3.5 to 3.5 depending upon the value of the weight.
<p>Example expression:</p>
<pre><code>d2:zScoreWFH( height, weight, gender )</code></pre></td>
</tr>
<tr class="odd">
<td>d2:minValue</td>
<td>Get minimum value for provided item</td>
<td>Function gets minimum value of provided data element across entire enrollment.
<p>Example expression:</p>
<pre><code>d2:minValue( 'blood-pressure' )</code></pre></td>
</tr>
<tr class="even">
<td>d2:maxValue</td>
<td>Get maximum value for provided item</td>
<td>Function gets maximum value of provided data element across entire enrollment.
<p>Example expression:</p>
<pre><code>d2:maxValue( 'blood-pressure' )</code></pre></td>
</tr>
</tbody>
</table>

<table>
<caption>Standard variables to use in program rule expressions</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 30%" />
<col style="width: 54%" />
</colgroup>
<thead>
<tr class="header">
<th>Variable</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>V{current_date}</td>
<td>(date)</td>
<td>Contains the current date whenever the rule is executed.
<p>Example expression:</p>
<pre><code>d2:daysBetween(#{symptomDate},V{current_date}) &lt; 0 </code></pre></td>
</tr>
<tr class="even">
<td>V{event_date}</td>
<td>(date)</td>
<td>Contains the event date of the current event execution. Will not have a value at the moment the rule is executed as part of the registration form.</td>
</tr>
<tr class="odd">
<td>V{event_status}</td>
<td>(string)</td>
<td>Contains status of the current event or enrollment.
<p>Example expression to check status is:</p>
<pre><code>V{event_status} == &#39;COMPLETED&#39;</code></pre></td>
</tr>
<tr class="even">
<td>V{due_date}</td>
<td>(date)</td>
<td>This variable will contain the current date when the rule is executed. Note: This means that the rule might produce different results at different times, even if nothing else has changed.</td>
</tr>
<tr class="odd">
<td>V{event_count}</td>
<td>(number)</td>
<td>Contains the total number of events in the enrollment.</td>
</tr>
<tr class="even">
<td>V{enrollment_date}</td>
<td>(date)</td>
<td>Contains the enrollment date of the current enrollment. Will not have a value for single event programs.</td>
</tr>
<tr class="odd">
<td>V{incident_date}</td>
<td>(date)</td>
<td>Contains the incident date of the current enrollment. Will not have a value for single event programs.</td>
</tr>
<tr class="even">
<td>V{enrollment_id}</td>
<td>(string)</td>
<td>Universial identifier string(UID) of the current enrollment. Will not have a value for single event programs.</td>
</tr>
<tr class="odd">
<td>V{event_id}</td>
<td>(string)</td>
<td>Universial identifier string(UID) of the current event context. Will not have a value at the moment the rule is executed as part of the registration form.</td>
</tr>
<tr class="even">
<td>V{orgunit_code}</td>
<td>(string)</td>
<td>Contains the code of the orgunit that is linked to the current enrollment. For single event programs the code from the current event orgunit will be used instead.
<p>Example expression to check whether orgunit code starts with WB_:</p>
<pre><code>d2:left(V{orgunit_code},3) == &#39;WB_&#39;</code></pre></td>
</tr>
<tr class="odd">
<td>V{environment}</td>
<td>(string)</td>
<td>Contains a code representing the current runtime environment for the rules. The possible values is &quot;WebClient&quot;, &quot;AndroidClient&quot; and &quot;Server&quot;. Can be used when a program rule is only supposed to run in one or more of the client types.</td>
</tr>
<tr class="even">
<td>V{program_stage_id}</td>
<td>(string)</td>
<td>Contains the ID of the current program stage that triggered the rules. This can be used to run rules in specific program stages, or avoid execution in certain stages. When executing the rules in the context of a TEI registration form the variable will be empty.</td>
</tr>
<tr class="odd">
<td>V{program_stage_name}</td>
<td>(string)</td>
<td>Contains the name of the current program stage that triggered the rules. This can be used to run rules in specific program stages, or avoid execution in certain stages. When executing the rules in the context of a TEI registration form the variable will be empty.</td>
</tr>
</tbody>
</table>

## Configure relationship types

<!--DHIS2-SECTION-ID:configure_relationship_type-->

### About relationship types

<!--DHIS2-SECTION-ID:about_relationship_types-->

A relationship represents a link between two entities in the Tracker-model. A relationship is considered data in DHIS2 and is based on a Relationship Type, similar to how a Tracked Entity Instance is based on a Tracked Entity Type.

Relationships always include two entities, and these entities can include Tracked Entity Instances, Enrollments and Events, and any combination of these. Note that not all of these combinations are available in the current apps.

In addition, relationships can be defined as unidirectional or bidirectional. The only functional difference is currently that these requires different levels of access to create. Unidirectional relationships requires the user to have data write access to the “from” entity and data read access for the “to” entity, while bidirectional relationships require data write access for both sides.

For more information about configuration and the meaning of 'From constraint' and 'To constraint', see [Relationship model](relationship_model#relationship_model_relationship_type).

### Create or edit a relationship type

<!--DHIS2-SECTION-ID:create_relationship_type-->

1.  Open the **Maintenance** app and click **Program** \> **Relationship
    type**.

2.  Click the add button.

3.  Type a **Name** of the relationship type.

4.  (Optional) Assign a **Code**.

5.  (Optional) Provide a **Description** of the relationship.

6. (Optional) Select whether the relationship should be bidirectional

7. Provide **Relationship name seen from inititating entity**. This is the name of the relationship that will be shown in the Data Entry app at the 'left' side of the relationship. E.g. in a Mother-child relationship this could be 'Mother of'.

8. (Optional) Provide **Relationship name seen from receiving entity**. This is the name of the relationship that will be shown at the 'right' side of the relationship in the Data Entry app. E.g. in a Mother-child relationship this could be 'Mother'.

9.  Select a 'From constraint'. This limits what kind of entities that can be included in the relationship. [Relationship model](relationship_model#relationship_model_relationship_type).

10. Select a 'To constraint'. This limits what kind of entities that can be included in the relationship. [Relationship model](relationship_model#relationship_model_relationship_type).

11. Click **Save**.

## Configure tracked entity types

<!--DHIS2-SECTION-ID:configure_tracked_entity-->

### About tracked entity types

<!--DHIS2-SECTION-ID:about_tracked_entity-->

A tracked entity is a types of entities which can be tracked through the
system. It can be anything from persons to commodities, for example a
medicine or a person.

A program must have one tracked entity. To enroll a tracked entity
instance into a program, the tracked entity type and tracked
entity type of a program must be the same.

Tracked entity attributes are used to register extra information for a
tracked entity. Tracked entity attributes can be shared between
programs.

### Create or edit a tracked entity attribute

<!--DHIS2-SECTION-ID:create_tracked_entity_attribute-->

1.  Open the **Maintenance** app and click **Program** \> **Tracked
    entity attribute**.

2.  Click the add button.

3.  In the **Name** field, type the tracked entity attribute name.

4.  (Optional) Type a **Short name**.

4.  (Optional) Type a **Form name**.

5.  (Optional) In the **Code** field, assign a code.

6.  (Optional) Type a **Description**.

7. (Optional) In the **Field mask** field, you may type a template that's used to provide
   hints for correct formatting of the attribute. **NOTE: So far only implemented in the DHIS2 Android Capture app, not in the Capture and Tracker Capture web apps.**
   The following are special characters that can be used in the mask. The special characters match exactly one character of the given type.

   | Character     |    Match       |
   | ------------- |----------------|
   |      \\d      |     digit      |
   |      \\x      |lower case letter|
   |      \\X      | capital letter |
   |      \\w      |any alphanumeric character|

  For example, the pattern can be used to show hyphens as needed in the input field of the data element. E.g "\d\d\d-\d\d\d-\d\d\d, would 
  show an hyphen for every third digit.

8.  Select an **Option set**.

9.  In the **Value type** field, select the type of data that the
    tracked entity attribute will record.

    <table>
    <caption>Value types</caption>
    <colgroup>
    <col style="width: 53%" />
    <col style="width: 46%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th><p>Value type</p></th>
    <th><p>Description</p></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><p>Age</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="even">
    <td><p>Coordinate</p></td>
    <td><p>A point coordinate specified as longitude and latitude in decimal degrees. All coordinate should be specified in the format &quot;-19.23 , 56.42&quot; with a comma separating the longitude and latitude.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Date</p></td>
    <td><p>Dates render as calendar widget in data entry.</p></td>
    </tr>
    <tr class="even">
    <td><p>Date &amp; time</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="odd">
    <td><p>E-mail</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="even">
    <td><p>File</p></td>
    <td><p>A file resource where you can store external files, for example documents and photos.</p></td>
    </tr>
    <tr class="odd">
    <td>Image</td>
    <td>Similar to File, but restricted to images.</td>
    </tr>
    <tr class="even">
    <td><p>Integer</p></td>
    <td><p>Any whole number (positive and negative), including zero.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Letter</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="even">
    <td><p>Long text</p></td>
    <td><p>Textual value. Renders as text area in forms.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Negative integer</p></td>
    <td><p>Any whole number less than (but not including) zero.</p></td>
    </tr>
    <tr class="even">
    <td><p>Number</p></td>
    <td><p>Any real numeric value with a single decimal point. Thousands separators and scientific notation is not supported.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Percentage</p></td>
    <td><p>Whole numbers inclusive between 0 and 100.</p></td>
    </tr>
    <tr class="even">
    <td><p>Phone number</p></td>
    <td></td>
    </tr>
    <tr class="odd">
    <td><p>Positive integer</p></td>
    <td><p>Any whole number greater than (but not including) zero.</p></td>
    </tr>
    <tr class="even">
    <td><p>Positive of zero integer</p></td>
    <td><p>Any positive whole number, including zero.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Organisation unit</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="even">
    <td><p>Unit interval</p></td>
    <td><p>Any real number greater than or equal to 0 and less than or equal to 1.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Text</p></td>
    <td><p>Textual value. The maximum number of allowed characters per value is 50,000.</p></td>
    </tr>
    <tr class="even">
    <td><p>Time</p></td>
    <td><p>Time is stored in HH:mm format.</p>
    <p>HH is a number between 0 and 23</p>
    <p>mm is a number between 00 and 59</p></td>
    </tr>
    <tr class="odd">
    <td><p>Tracker associate</p></td>
    <td><p>-</p></td>
    </tr>
    <tr class="even">
    <td><p>Username</p></td>
    <td><p> Rendered as a dialog with a list of users and a search field. The user will need the "View User" authority to be able to utilise this data type</p></td>
    </tr>
    <tr class="odd">
    <td><p>Yes/No</p></td>
    <td><p>Boolean values, renders as drop-down lists in data entry.</p></td>
    </tr>
    <tr class="even">
    <td><p>Yes only</p></td>
    <td><p>True values, renders as check-boxes in data entry.</p></td>
    </tr>
    </tbody>
    </table>

9.  Select an **Aggregation type**.

    <table>
    <caption>Aggregation operators</caption>
    <colgroup>
    <col style="width: 50%" />
    <col style="width: 50%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th><p>Aggregation operator</p></th>
    <th><p>Description</p></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><p>Average</p></td>
    <td><p>Average the values in both the period as and the organisation unit dimensions.</p></td>
    </tr>
    <tr class="even">
    <td><p>Average (sum in organisation unit hierarchy)</p></td>
    <td><p>Average of data values in the period dimension, sum in the organisation unit dimensions.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Count</p></td>
    <td><p>Count of data values.</p></td>
    </tr>
    <tr class="even">
    <td><p>Min</p></td>
    <td><p>Minimum of data values.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Max</p></td>
    <td><p>Maximum of data values.</p></td>
    </tr>
    <tr class="even">
    <td><p>None</p></td>
    <td><p>No aggregation is performed in any dimension.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Sum</p></td>
    <td><p>Sum of data values in the period and organisation unit dimension.</p></td>
    </tr>
    <tr class="even">
    <td><p>Standard deviation</p></td>
    <td><p>Standard deviation (population-based) of data values.</p></td>
    </tr>
    <tr class="odd">
    <td><p>Variance</p></td>
    <td><p>Variance (population-based) of data values.</p></td>
    </tr>
    </tbody>
    </table>

10. Select **Unique** to specify that the values of the tracked entity
    attribute is unique.

    There are two options for the unique setting:

      - **Entire system**: The values of the tracked entity attribute
        can duplicate with values which belong to other tracked entity
        attributes. But the values in this tracked entity attribute must
        not duplicate.

        Select **Automatically generated** to allow automatic generation
        of the tracked entity attribute value. When the generate setting
        is selected on, an optional field for specifying pattern also
        displays. This field should contain a pattern based on the
        TextPattern syntax. When the value is automatically generated,
        it will be unique for this attribute for the entire system. See
        the TextPattern section for more information on how it works.

      - **Organisation unit**: The values of the tracked entity
        attribute must not duplicate in the same organisation unit.

11. Select **Inherit** to registry a new entity for relationship with an
    available entity, all inherit entity attribute values of the entity
    will be pre-filled in the registration form.

12. (Optional) Select **Confidential**.

    This option is only available if you have configured encryption for
    the system.

13. (Optional) Select **Display in list without program**.

14. (Optional) Assign one or multiple **Legends**.

15. Click **Save**.

### Create or edit a tracked entity type

<!--DHIS2-SECTION-ID:create_tracked_entity-->

1.  Open the **Maintenance** app and click **Program** \> **Tracked
    entity type**.

2.  Click the add button or an already existing **tracked entity
    type**.

3.  Type a **Name** of the tracked entity.

4.  (Optional) select a **Color** and an **Icon** that will be used by
    the data capture apps to identify this tracked entity type.

5.  (Optional) Enter a **Description** of the tracked entity.

6.  (Optional) Enter a **Minimum number of attributes required to
    search**. This specifies the amount of attributes that need to be
    filled out in order to be able to search for this **tracked entity
    type** in a *global search*. See [Configure
    Search](../search/search.xml#configure_search) for more information.

7.  (Optional) Enter a **Maximum number of tracked entity instances to
    return in search**. This specifies the amount of tracked entity
    instances that will be returned in a *global search*. See [Configure
    Search](../search/search.xml#configure_search) for more information.

8.  (Optional) Add **Tracked entity type attributes**. This is used to
    configure search, see [Configure
    Search](configure_search) for more information.

9.  (Optional) Enter an **Alternative name** of the tracked entity.

10. Click **Save**.

## Configure search

<!--DHIS2-SECTION-ID:configure_search-->

Users can be given search organisation units, which makes it possible to
search for tracked entity instances outside their data capture
organisation units.

Searching can be done either in the context of a program, or in the
context of a tracked entity type. To be give users the option of
searching in the context of a program, it is necessary to configure
which of the programs tracked entity attributes is searchable. To give
users the option of searching in the context of a tracked entity type,
you will have to configure which of the tracked entity type attributes
is searchable.

### Configure search for tracker program

To be able to search with a program, you will have to make some of the
program attributes searchable. Unique program attributes will always be
searchable.

1.  Open **Program app**

2.  Open or create a tracker program

3.  Go to **Attributes**

4.  If you have no attributes, add one

5.  Set the attribute searchable

Searchable program attributes will assigned to a search group.

  - Unique group. One group per unique program attribute. Unique
    attributes cannot be combined with other program attributes in a
    search. The result from the search can only be 0 or 1 tracked entity
    instance.

  - Non-unique group. This group contains all non-unique program
    attributes and makes it possible to combine multiple attributes in a
    search.

There are two limits that can be set for a program search, as part of
the **Program** configuration.

  - Minimum number of attributes required to search: This property
    defines how many of the non-unique attributes that must be entered
    before a search can be performed.

<!-- end list -->

  - Maximum number of tracked entity instances to return: This property
    defines the maximum number of results a user will get in her search.
    If a too large number of tracked entity instances is found, the user
    must provide a more specific search.

### Configure search for tracked entity type

> **Note**
>
> TET = Tracked entity type

To be able to search without a program, you will have to make some of
the TET attributes searchable. Unique TET attributes will always be
searchable.

1.  Open **Tracked entity type app**

2.  Open a Tracked entity type

3.  If the TET has no attributes, add one

4.  Set the attribute searchable

Searchable TET attributes will assigned to a search group.

  - Unique group. One group per unique TET attribute. Unique attributes
    cannot be combined with other TET attributes in a search. The result
    from the search can only be 0 or 1 tracked entity instance.

  - Non-unique group. This group contains all non-unique TET attributes
    and makes it possible to combine multiple attributes in a search.

There are two limits that can be set for a TET search

  - Minimum number of attributes required to search: This property
    defines how many of the non-unique attributes that must be entered
    before a search can be performed.

<!-- end list -->

  - Maximum number of tracked entity instances to return: This property
    defines the maximum number of results a user will get in her search.
    If a too large number of tracked entity instances is found, the user
    must provide a more specific search.

### Configure search organisation units for a user

To be able to search in other organisation units than the users data
capture organisation units, the user must be assigned with search
organisation units. Giving a user a search organisation unit will also
give it access to search in all children of that organisation unit.

1.  Open **Users app**

2.  Click on a user

3.  Open **Assign search organisation units**

4.  Select organisation units

5.  Click **Save**

## Clone metadata objects

<!--DHIS2-SECTION-ID:clone_metadata-->

Cloning a data element or other objects can save time when you create
many similar objects.

1.  Open the **Maintenance** app and find the type of metadata object
    you want to clone.

2.  In the object list, click the options menu and select **Clone**.

3.  Modify the options you want.

4.  Click **Save**.

## Delete metadata objects

> **Note**
>
> You can only delete a data element and other data element objects if
> no data is associated to the data element itself.

> **Warning**
>
> Any data set that you delete from the system is irrevocably lost. All
> data entry forms, and section forms which may have been developed will
> also be removed. Make sure that you have made a backup of your
> database before deleting any data set in case you need to restore it
> at some point in time.

1.  Open the **Maintenance** app and find the type of metadata object
    you want to delete.

2.  In the object list, click the options menu and select **Delete**.

3.  Click **Confirm**.

## Change sharing settings for metadata objects

You can assign different sharing settings to metadata objects, for
example organisation units and tracked entity attributes. These sharing
settings control which users and users groups that can view or edit a
metadata object.

Some metadata objects also allows you to change the sharing setting of
data entry for the object. These additional settings control who can
view or enter data in form fields using the metadata.

> **Note**
>
> The default setting is that everyone (**Public access**) can find,
> view and edit metadata objects.

1.  Open the **Maintenance** app and find the type of metadata object
    you want to modify.

2.  In the object list, click the context menu and select **Sharing
    settings**.

3.  (Optional) Add users or user groups: search for a user or a user
    group and select it. The user or user group is added to the list.

4.  Change sharing settings for the access groups you want to modify.

      - **Can edit and view**: The access group can view and edit the
        object.

      - **Can view only**: The access group can view the object.

      - **No access** (only applicable to **Public access**): The public
        won't have access to the object.

5.  Change data sharing settings for the access groups you want to
    modify.

      - **Can capture data**: The access group can view and capture data
        for the object.

      - **Can view data**: The access group can view data for the
        object.

      - **No access**: The access group won't have access to data for
        the object.

6.  Click **Close**.

## Display details of metadata objects

1.  Open the **Maintenance** app and find the type of metadata object
    you want to view.

2.  In the object list, click the options menu and select **Show
    details**.

## Translate metadata objects

DHIS2 provides functionality for translations of database content, for
example data elements, data element groups, indicators, indicator groups
or organisation units. You can translate these elements to any number of
locales. A locale represents a specific geographical, political, or
cultural region.

> **Tip**
>
> To activate a translation, open the **System Settings** app, click \>
> **Appearance** and select a language.

1.  Open the **Maintenance** app and find the type of metadata object
    you want to translate.

2.  In the object list, click the options menu and select **Translate**.

    > **Tip**
    >
    > If you want to translate an organisation unit level, click
    > directly on the **Translate** icon next to each list item.

3.  Select a locale.

4.  Type a **Name**, **Short name** and **Description**.

5.  Click **Save**.
