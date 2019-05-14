# Features supported

The following is a comprehensive list of all features available for Programs with and without registration in DHIS2, and notes on whether or not these have been implemented in the Android Capture app.

In the notes, ‘admin’ refers to someone who develops and configures a DHIS2 system, and ‘user’ refers to someone who uses apps to capture data, update it, and review reports.

|legend|description|
|:--:|:------|
|✓|Feature implemented|
|&ndash;|Feature not implemented&nbsp;(will be ignored)|
|n/a|Not applicable|
|![](resources/images/image3_icon.png)|Work in progress. Feature not completely implemented yet or with unexpected behaviour already reported.|


## Program features
|Feature|Description of feature|Program with registration|Program without registration|Notes on implementation|
|-|-|-|-|-|
|Data entry method for option sets|Enables an admin to choose how options will be displayed on-screen across the entire program (ie either as drop-down lists or as radio buttons)|&ndash;|&ndash;|This will be replaced by the new rendering options.|
|Combination of categories<br />(Attribute CatCombo)|Allows an admin to attach a Category (set of Options) to the Program, requiring users to categorize each enrolment. (This is called an Attribute Category Combination in DHIS2.)|✓|✓||
|Data approval workflow|If an admin selects a pre-configured Data Approval Workflow, this will be used to enforce an &lsquo;approval&rsquo; or &lsquo;acceptance and approval&rsquo; cascade, enabling users to sign-off and lock data.|&ndash;|&ndash;||
|Display front page list|If this option is ticked, the landing page displays a list of active enrolments once an Org Unit and Program have been chosen. (Attributes shown are those ticked as &lsquo;display in list&rsquo;.)|✓|n/a||
|First stage appears on registration page|When this option is chosen, then during Program enrolment, the screen for the first Program Stage is also shown (enrolment and the first event are captured together on one screen).|✓|n/a| In Android, this is implemented by opening automatically the event after enrollment is completed, instead of adding the form to the same screen.|
|Completed events expiry days|Enables admins to lock data-entry a certain number of days after an event has been completed.|✓|✓||
|Expiry period type + expiry days|Enables admins to set a period (eg weekly, monthly), and to lock data-entry a certain number of days after the end of the period.|✓|✓||
|Allow future enrolment dates|If ticked, this enables a user to enter future Enrolment dates during enrolment in a Program; otherwise users are restricted to today or past dates.|✓|n/a||


</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Allow future incident dates</p>
</td>
<td>
<p>If ticked, this enables a user to enter future Incident dates during enrolment in a Program; otherwise users are restricted to today or past dates.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Only enrol once (per tracked entity instance lifetime)</p>
</td>
<td>
<p>If ticked, prevents a TEI (eg person) from being enrolled in this Program more than once.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Show incident date</p>
</td>
<td>
<p>If ticked, both Enrolment and Incident dates are shown to the user for data capture; otherwise, only the Enrolment date is shown/captured.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Description of incident date</p>
</td>
<td>
<p>Allows an admin to customize the label that is used for the incident date.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Description of enrolment date</p>
</td>
<td>
<p>Allows an admin to customize the label that is used for the enrollment date.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Capture coordinates (enrolment)</p>
</td>
<td>
<p>Enables users to capture geographical coordinates during enrolment in the program.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Relationships &ndash; create and update</p>
</td>
<td>
<p>Enables users to create relationship types (eg mother-child, doctor-patient) which link two TEIs (eg patients); users can use this relationship to add links to other TEIs (eg patients).</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Relationships - shortcut link to add a relative</p>
</td>
<td>
<p>This enables admins to add a link for one specific relationship to the Dashboard, enabling users to directly create a linked TEI (eg &lsquo;child&rsquo; patient).</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Attributes &ndash; display in list</p>
</td>
<td>
<p>This setting determines whether an Attribute can be viewed in lists such as search results, and whether it can be seen in the shortlist of Attributes shown under &lsquo;Profile&rsquo; in the Dashboard.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>
<p><img title="" src="images/image1.png" alt="" />The first 3 attributes will be shown.</p>
</td>
</tr>
<tr>
<td>
<p>Attributes &ndash; mandatory</p>
</td>
<td>
<p>This enables an admin to mark an Attribute as &lsquo;mandatory&rsquo;, meaning the enrolment can&rsquo;t be saved until a value is captured.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Attributes &ndash; date in future</p>
</td>
<td>
<p>For date Attributes, this enables an admin to either prevent or allow future dates to be captured.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Registration form - default</p>
</td>
<td>
<p>The default data entry form simply lists all attributes defined for the TEI.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Registration form - custom</p>
</td>
<td>
<p>This enables an admin to define a custom layout (using HTML) for the registration form.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>
<p>Custom layouts are not supported in the Android App.</p>
</td>
</tr>
<tr>
<td>
<p>Program notifications</p>
</td>
<td>
<p>You can set up automated notifications for when program enrolments or completions occur, or at a set interval before/after incident or enrolment dates. These can be sent as internal DHIS2 messages, emails or SMSs.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>
<p><img title="" src="images/image1.png" alt="" />&nbsp;This functionality is executed on the server side, once data is received. Will not work when the app is working offline.</p>
</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
</tr>
<tr>
<td>
<p>Activate/deactivate enrolment</p>
</td>
<td>
<p>Deactivating a TEI dashboard will cause the TEI to become &ldquo;read-only&rdquo;. This means you can&rsquo;t enter data, enrol the TEI or edit the TEI&rsquo;s profile.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Complete allowed only if validation passes</p>
</td>
<td>
<p>Select check box to enforce that an event created by this program is only completed when all validation rules have passed.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Org unit opening/closing dates</p>
</td>
<td>
<p>Enables an admin to set opening and closing dates for an Org Unit, which blocks users from adding or editing events outside of these dates.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Data sharing levels / Can capture data</p>
</td>
<td>
<p>Enables the user to add new event, edit data and delete events in the program.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Data sharing levels / Can view data</p>
</td>
<td>
<p>Enables the user to see list of events within the program.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Data sharing levels / No access</p>
</td>
<td>
<p>The user won&rsquo;t be able to see the program</p>
<p>&nbsp;</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td colspan="5" rowspan="1">
<h3>Program stage features</h3>
</td>
</tr>
<tr>
<td>
<p>Event form - default</p>
</td>
<td>
<p>The default data entry form simply lists all attributes belonging to a program registration</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Event form &ndash; section forms</p>
<p>&nbsp;</p>
</td>
<td>
<p>Sections forms allow you to split existing forms into segments</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Event form &ndash; custom</p>
</td>
<td>
<p>Define a custom event form as a HTML page.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>
<p>Custom layouts are not supported in the Android App.</p>
</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>&ndash;</p>
</td>
</tr>
<tr>
<td>
<p>Program stage notifications</p>
<p>&nbsp;</p>
</td>
<td>
<p>You can set up automated notifications for when the program stage is completed, or at a set interval before/after scheduled event dates. These can be sent as internal DHIS2 messages, emails or SMS messages.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>
<p><img title="" src="images/image1.png" alt="" />&nbsp;This functionality is executed on the server side, once data is received. Will not work when the app is working offline.</p>
</td>
</tr>
<tr>
<td>
<p>Repeatable</p>
</td>
<td>
<p>If Repeatable Is ticked, this stage can be repeated during one program enrollment. If t is not, then the stage can only happen once during a program enrollment.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Repeatable + Standard interval days</p>
</td>
<td>
<p>The system will suggest the due date as the calculation of the last event + standard interval dates.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>&nbsp;</p>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Period type</p>
</td>
<td>
<p>Enables an admin to configure a set of periods (e.g. weeks or months) for each event in the program stage, instead of just a date. When creating events, users are then asked to choose a period (instead of a date) for each new event they create within that program stage.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Auto-generate event</p>
</td>
<td>
<p>If ticked, a &lsquo;booking&rsquo; is generated for this Program Stage upon enrolment, based on the &lsquo;Scheduled days from start&rsquo;.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Generate events based on enrolment date (not incident date)</p>
</td>
<td>
<p>Check on it for auto-generating due dates of events from program-stages of this program based on the enrollment date. If it is not checked, the due dates are generated based on incident date.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Open data entry form after enrolment + report date to use</p>
</td>
<td>
<p>If selected, once an enrolment is complete, an event&rsquo;s data entry form should open directly afterwards.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Ask user to complete program when stage is complete.</p>
</td>
<td>
<p>If selected, upon completing the program stage the user should be asked to complete the program. (This setting is ignored if &lsquo;Ask user to create new event&hellip;&rsquo; is also ticked.)</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Ask user to create new event when stage is complete</p>
</td>
<td>
<p>If selected, when the Program Stage is completed the user is prompted to book.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Hide due date</p>
</td>
<td>
<p>Only shows the actual date for events, hiding the due date.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Capture coordinates (event)/ Feature Type-Point</p>
</td>
<td>
<p>Enables the user to capture geographical coordinates when each event is created &ndash; particularly useful in devices that have GPS (eg Android), as instead of having to type in coordinates, the user can automatically populate them with the press of a button.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Description of report date</p>
</td>
<td>
<p>Allows an admin to customize the label that is used for the event&rsquo;s date.</p>
<p>&nbsp;</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Data elements &ndash; compulsory</p>
</td>
<td>
<p>This enables an admin to mark a data element as &lsquo;compulsory&rsquo;, meaning an event can&rsquo;t be saved until a value is captured.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
</tr>
<tr>
<td>
<p>Data elements &ndash; allow provided elsewhere</p>
</td>
<td>
<p>On the form, this places a tick-box next to the selected data element, and enables previous data to be pulled into the data element.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Data elements &ndash; display in reports</p>
</td>
<td>
<p>Displays the value of this data element into the single event without registration data entry function</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Data elements &ndash; date in future</p>
</td>
<td>
<p>For date Data Elements, this enables an admin to either prevent or allow future dates to be captured.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Data elements &ndash; render options as radio</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</td>
<td>
<p>Enables an admin to choose how options will be displayed on-screen for each Data Element<br />(i.e. either as drop-down list or as radio buttons).</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>
<p>This will be replaced by the new rendering options.</p>
</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>&ndash;</p>
</td>
</tr>
<tr>
<td>
<p>Block entry form after completed</p>
</td>
<td>
<p>Prevents all edits to events after they have been completed.</p>
</td>
<td>
<p>Program with registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Program without registration</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Event comments</p>
</td>
<td>
<p>Enables the user to add overall comments to an event. These comments are cumulative (new comments are added below existing comments).</p>
</td>
<td>
<p>Program without registration</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>&nbsp;</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<hr />
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<table>
<tbody>
<tr>
<td>
<p>Feature</p>
</td>
<td>
<p>Description of feature</p>
</td>
<td>
<p>Status</p>
</td>
<td>
<p>Notes on implementation</p>
</td>
</tr>
<tr>
<td colspan="4" rowspan="1">
<h3>Program with registration: Tracked entity dashboard features</h3>
</td>
</tr>
<tr>
<td>
<p>Messaging</p>
</td>
<td>
<p>Enables users to send ad-hoc free-text messages to TEIs (e.g. patients) via SMS or email.</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Mark for follow-up (button with exclamation triangle)</p>
</td>
<td>
<p>Enables a user to mark a TEI (e.g. patient) as requiring follow-up.</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Display TEI audit history</p>
</td>
<td>
<p>Enables a user to see a history of all edits to Attributes for this TEI (e.g. patient).</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Inline program indicators</p>
</td>
<td>
<p>If a program indicator &lsquo;display in form&rsquo; box is ticked, the indicator appears on the Tracker Capture dashboard, and is updated live as data capture occurs.</p>
</td>
<td>
<p>✓</p>
</td>
<td>
<p>! <a href="https://www.google.com/url?q=https://jira.dhis2.org/browse/ANDROAPP-1723&amp;sa=D&amp;ust=1557433016354000">ANDROAPP-1723</a>: Some program indicators are not been shown even if display in form is selected</p>
</td>
</tr>
<tr>
<td>
<p>Delete events</p>
</td>
<td>
<p>Enables the user to delete an event.</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Schedule events</p>
</td>
<td>
<p>In the event generation dialogue, the user should also see the option to schedule an event. The process is like creating an event, but the user will be sent back to the TEI dashboard after the event is scheduled.</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Referral of patients</p>
</td>
<td>
<p>In the event generation dialogue, the user should also see the option to refer a patient. The process is like creating/scheduling an event, but the user can change the org unit and has to specify if is a one-time or permanent referral.<br /><br />One time will just create the event in the specified OU,</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Reset search fields</p>
</td>
<td>
<p>User is able to clean up the search fields by pressing on the rounded arrow icon on the top right corner of the search screen.</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Search screen for all TE Type</p>
</td>
<td>
<p>User is able to search across all program of one tracked entity type (TET). In the Search screen there is a drop down which shows all the programs available for the active TET (active TET is defined by the selection of the program in the home screen). That drop down should also have an option with TET name. (Person in our server)<br /><br />When the user selects that option, the search fields available will only be the TET attributes (no program specific attributes). All search restrictions do not apply, because they belong to the programs.</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>TEI Dashboard without program</p>
</td>
<td>
<p>User can see the TEI dashboard without any program by selecting the TEI in the list if the search was without program.<br /><br />The dashboards will show the TET attributes in the details card followed by a list of active enrollments.</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>TEI enrollment history and new enrollment</p>
</td>
<td>
<p>User is able to see the complete historical record of the TEI. By clicking on the top right corner icon they will see a list of Active enrolments, followed by a list of past enrolments (completed or cancelled), followed by the programs in which the TEI could be enrolled.<br /><br />Users should be able to navigate to the different enrolments from the list.</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td colspan="4" rowspan="1">
<h3>Program without registration: Single event program specific features</h3>
</td>
</tr>
<tr>
<td>
<p>Events listing (grid)</p>
<p>&nbsp;</p>
</td>
<td>
<p>A listing of existing events that is displayed once a program is selected.</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Sort and filter events in grid</p>
</td>
<td>
<p>Allows the user to sort listed events, or to filter events based on keywords or specific ranges of dates/numbers.</p>
</td>
<td>
<p>✓</p>
</td>
<td>
<p><img title="" src="images/image1.png" alt="" />&nbsp;Events are sorted chronologically. The user can filter by period and organisation unit.</p>
<p>&nbsp;</p>
</td>
</tr>
<tr>
<td>
<p>Edit events in grid</p>
</td>
<td>
<p>Allows the user to directly edit the data elements shown in the events listing/grid.</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>View event audit history</p>
</td>
<td>
<p>Enables the user to see a history of all changes to the event&rsquo;s data elements.</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Show/hide columns [in event list/grid]</p>
</td>
<td>
<p>Enables the user to modify the data elements shown in the event listing/grid (applies to that user only).</p>
</td>
<td>
<p>&ndash;</p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>
<p>Field completion percentage</p>
</td>
<td>
<p>The percentage of data completed in each event is shown in the top right corner of an event when it is opened after first registration.<br /><br />The percentages should be adapted to the effects of the program rules in the forms.</p>
</td>
<td>
<p>✓</p>
</td>
<td>
<p><img title="" src="images/image1.png" alt="" />The percentage of completion does not take into account the not-supported value types in the forms.</p>
<p>&nbsp;</p>
</td>
</tr>
<tr>
<td>
<p>Delete events</p>
</td>
<td>
<p>Enables the user to delete an event.</p>
</td>
<td>
<p>✓</p>
</td>
<td>&nbsp;</td>
</tr>
</tbody>
</table>
