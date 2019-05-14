# Features supported

The following is a comprehensive list of all features available for Programs with and without registration in DHIS2, and notes on whether or not these have been implemented in the Android Capture app.

In the notes, ‘admin’ refers to someone who develops and configures a DHIS2 system, and ‘user’ refers to someone who uses apps to capture data, update it, and review reports.

Any issues around using a particular feature with Android are highlighted with an exclamation mark \!.

Also, every time the icon ![](resources/images/image1_icon.png) is presented, a tip will be provided for a better use and understanding of the feature.

---

|        |  |
| ---- | -- |
| ✓    | Feature implemented     |
| –    | Feature not implemented (will be ignored) |
| ![](resources/images/image3_icon.png) | Work in progress. Feature not completely implemented yet or with unexpected behaviour already reported . |

Feature

Description of feature

Program type

Status

Notes on implementation

## Program features

Data entry method for option sets

Enables an admin to choose how options will be displayed on-screen across the entire program (ie either as drop-down lists or as radio buttons)

Program with registration

–

This will be replaced by the new rendering options.

Program without registration

–

Combination of categories

(Attribute CatCombo)

Allows an admin to attach a Category (set of Options) to the Program, requiring users to categorize each enrolment.  (This is called an Attribute Category Combination in DHIS2.)

Program with registration

✓

Program without registration

✓

Data approval workflow

If an admin selects a pre-configured Data Approval Workflow, this will be used to enforce an ‘approval’ or ‘acceptance and approval’ cascade, enabling users to sign-off and lock data.

Program with registration

–

Program without registration

–

Display front page list

If this option is ticked, the landing page displays a list of active enrolments once an Org Unit and Program have been chosen.  (Attributes shown are those ticked as ‘display in list’.)

Program with registration

✓

First stage appears on registration page

When this option is chosen, then during Program enrolment, the screen for the first Program Stage is also shown (enrolment and the first event are captured together on one screen).

Program with registration

✓

![](resources/images/image1_icon.png)In Android, this is implemented by opening automatically the event after enrollment is completed, instead of adding the form to the same screen.

Completed events expiry days

Enables admins to lock data-entry a certain number of days after an event has been completed.

Program with registration

✓

Program without registration

✓

Expiry period type + expiry days

Enables admins to set a period (eg weekly, monthly), and to lock data-entry a certain number of days after the end of the period.

Program with registration

✓

Program without registration

✓

Allow future enrolment dates

If ticked, this enables a user to enter future Enrolment dates during enrolment in a Program; otherwise users are restricted to today or past dates.

Program with registration

✓

Allow future incident dates

If ticked, this enables a user to enter future Incident dates during enrolment in a Program; otherwise users are restricted to today or past dates.

Program with registration

✓

Only enrol once (per tracked entity instance lifetime)

If ticked, prevents a TEI (eg person) from being enrolled in this Program more than once.

Program with registration

✓

Show incident date

If ticked, both Enrolment and Incident dates are shown to the user for data capture; otherwise, only the Enrolment date is shown/captured.

Program with registration

✓

Description of incident date

Allows an admin to customize the label that is used for the incident date.

Program with registration

✓

Description of enrolment date

Allows an admin to customize the label that is used for the enrollment date.

Program with registration

✓

Capture coordinates (enrolment)

Enables users to capture geographical coordinates during enrolment in the program.

Program with registration

✓

Relationships – create and update

Enables users to create relationship types (eg mother-child, doctor-patient) which link two TEIs (eg patients); users can use this relationship to add links to other TEIs (eg patients).

Program with registration

✓

Relationships - shortcut link to add a relative

This enables admins to add a link for one specific relationship to the Dashboard, enabling users to directly create a linked TEI (eg ‘child’ patient).

Program with registration

–

Attributes – display in list

This setting determines whether an Attribute can be viewed in lists such as search results, and whether it can be seen in the shortlist of Attributes shown under ‘Profile’ in the Dashboard.

Program with registration

✓

![](resources/images/image1_icon.png)The first 3 attributes will be shown.

Attributes – mandatory

This enables an admin to mark an Attribute as ‘mandatory’, meaning the enrolment can’t be saved until a value is captured.

Program with registration

✓

Attributes – date in future

For date Attributes, this enables an admin to either prevent or allow future dates to be captured.

Program with registration

✓

Registration form - default

The default data entry form simply lists all attributes defined for the TEI.

Program with registration

✓

Registration form - custom

This enables an admin to define a custom layout (using HTML) for the registration form.

Program with registration

–

Custom layouts are not supported in the Android App.

Program notifications

You can set up automated notifications for when program enrolments or completions occur, or at a set interval before/after incident or enrolment dates. These can be sent as internal DHIS2 messages, emails or SMSs.

Program with registration

✓

![](resources/images/image1_icon.png) This functionality is executed on the server side, once data is received. Will not work when the app is working offline.

Program without registration

✓

Activate/deactivate enrolment

Deactivating a TEI dashboard will cause the TEI to become “read-only”. This means you can’t enter data, enrol the TEI or edit the TEI’s profile.

Program with registration

✓

Complete allowed only if validation passes

Select check box to enforce that an event created by this program is only completed when all validation rules have passed.

Program with registration

–

Program without registration

–

Org unit opening/closing dates

Enables an admin to set opening and closing dates for an Org Unit, which blocks users from adding or editing events outside of these dates.

Program with registration

✓

Program without registration

✓

Data sharing levels / Can capture data

Enables the user to add new event, edit data and delete events in the program.

Program with registration

✓

Program without registration

✓

Data sharing levels / Can view data

Enables the user to see list of events within the program.

Program with registration

✓

Program without registration

✓

Data sharing levels / No access

The user won’t be able to see the program

Program with registration

✓

Program without registration

✓

## Program stage features

Event form - default

The default data entry form simply lists all attributes belonging to a program registration

Program with registration

✓

Program without registration

✓

Event form – section forms

Sections forms allow you to split existing forms into segments

Program with registration

✓

Program without registration

✓

Event form – custom

Define a custom event form as a HTML page.

Program with registration

–

Custom layouts are not supported in the Android App.

Program without registration

–

Program stage notifications

You can set up automated notifications for when the program stage is completed, or at a set interval before/after scheduled event dates. These can be sent as internal DHIS2 messages, emails or SMS messages.

Program with registration

✓

![](resources/images/image1_icon.png) This functionality is executed on the server side, once data is received. Will not work when the app is working offline.

Repeatable

If Repeatable Is ticked, this stage can be repeated during one program enrollment. If t is not, then the stage can only happen once during a program enrollment.

Program with registration

✓

Repeatable + Standard interval days

The system will suggest the due date as the calculation of the last event + standard interval dates.

Program with registration

✓

Period type

Enables an admin to configure a set of periods (e.g. weeks or months) for each event in the program stage, instead of just a date.  When creating events, users are then asked to choose a period (instead of a date) for each new event they create within that program stage.

Program with registration

✓

Auto-generate event

If ticked, a ‘booking’ is generated for this Program Stage upon enrolment, based on the ‘Scheduled days from start’.

Program with registration

✓

Generate events based on enrolment date (not incident date)

Check on it for auto-generating due dates of events from program-stages of this program based on the enrollment date. If it is not checked, the due dates are generated based on incident date.

Program with registration

✓

Open data entry form after enrolment + report date to use

If selected, once an enrolment is complete, an event’s data entry form should open directly afterwards.

Program with registration

✓

Ask user to complete program when stage is complete.

If selected, upon completing the program stage the user should be asked to complete the program.  (This setting is ignored if ‘Ask user to create new event…’ is also ticked.)

Program with registration

✓

Ask user to create new event when stage is complete

If selected, when the Program Stage is completed the user is prompted to book.

Program with registration

✓

Hide due date

Only shows the actual date for events, hiding the due date.

Program with registration

✓

Capture coordinates (event)/ Feature Type-Point

Enables the user to capture geographical coordinates when each event is created – particularly useful in devices that have GPS (eg Android), as instead of having to type in coordinates, the user can automatically populate them with the press of a button.

Program with registration

✓

Program without registration

✓

Description of report date

Allows an admin to customize the label that is used for the event’s date.

Program with registration

✓

Program without registration

✓

Data elements – compulsory

This enables an admin to mark a data element as ‘compulsory’, meaning an event can’t be saved until a value is captured.

Program with registration

✓

Program without registration

✓

Data elements – allow provided elsewhere

On the form, this places a tick-box next to the selected data element, and enables previous data to be pulled into the data element.

Program with registration

–

Data elements – display in reports

Displays the value of this data element into the single event without registration data entry function

Program with registration

–

Program without registration

✓

Data elements – date in future

For date Data Elements, this enables an admin to either prevent or allow future dates to be captured.

Program with registration

✓

Program without registration

✓

Data elements – render options as radio

Enables an admin to choose how options will be displayed on-screen for each Data Element  
(i.e. either as drop-down list or as radio buttons).

Program with registration

–

This will be replaced by the new rendering options.

Program without registration

–

Block entry form after completed

Prevents all edits to events after they have been completed.

Program with registration

✓

Program without registration

✓

Event comments

Enables the user to add overall comments to an event.  These comments are cumulative (new comments are added below existing comments).

Program without registration

–

---

Feature

Description of feature

Status

Notes on implementation

## Program with registration: Tracked entity dashboard features

Messaging

Enables users to send ad-hoc free-text messages to TEIs (e.g. patients) via SMS or email.

–

Mark for follow-up (button with exclamation triangle)

Enables a user to mark a TEI (e.g. patient) as requiring follow-up.

✓

Display TEI audit history

Enables a user to see a history of all edits to Attributes for this TEI (e.g. patient).

–

Inline program indicators

If a program indicator  ‘display in form’ box is ticked, the indicator appears on the Tracker Capture dashboard, and is updated live as data capture occurs.

✓

\! [ANDROAPP-1723](https://www.google.com/url?q=https://jira.dhis2.org/browse/ANDROAPP-1723&sa=D&ust=1557433016354000): Some program indicators are not been shown even if display in form is selected

Delete events

Enables the user to delete an event.

✓

Schedule events

In the event generation dialogue, the user should also see the option to schedule an event. The process is like creating an event, but the user will be sent back to the TEI dashboard after the event is scheduled.

✓

Referral of patients

In the event generation dialogue, the user should also see the option to refer a patient. The process is like creating/scheduling an event, but the user can change the org unit and has to specify if is a one-time or permanent referral.

One time will just create the event in the specified OU,

✓

Reset search fields

User is able to clean up the search fields by pressing on the rounded arrow icon on the top right corner of the search screen.

✓

Search screen for all TE Type

User is able to search across all program of one tracked entity type (TET). In the Search screen there is a drop down which shows all the programs available for the active TET (active TET is defined by the selection of the program in the home screen). That drop down should also have an option with TET name. (Person in our server)

When the user selects that option, the search fields available will only be the TET attributes (no program specific attributes). All search restrictions do not apply, because they belong to the programs.

✓

TEI Dashboard without program

User can see the TEI dashboard without any program by selecting the TEI in the list if the search was without program.

The dashboards will show the TET attributes in the details card followed by a list of active enrollments.

✓

TEI enrollment history and new enrollment

User is able to see the complete historical record of the TEI. By clicking on the top right corner icon they will see a list of Active enrolments, followed by a list of past enrolments (completed or cancelled), followed by the programs in which the TEI could be enrolled.

Users should be able to navigate to the different enrolments from the list.

✓

## Program without registration:  Single event program specific features

Events listing (grid)

A listing of existing events that is displayed once a program is selected.

✓

Sort and filter events in grid

Allows the user to sort listed events, or to filter events based on keywords or specific ranges of dates/numbers.

✓

![](resources/images/image1_icon.png) Events are sorted chronologically. The user can filter by period and organisation unit.

Edit events in grid

Allows the user to directly edit the data elements shown in the events listing/grid.

–

View event audit history

Enables the user to see a history of all changes to the event’s data elements.

–

Show/hide columns \[in event list/grid\]

Enables the user to modify the data elements shown in the event listing/grid (applies to that user only).

–

Field completion percentage

The percentage of data completed in each event is shown in the top right corner of an event when it is opened after first registration.

The percentages should be adapted to the effects of the program rules in the forms.

✓

![](resources/images/image1_icon.png)The percentage of completion does not take into account the not-supported value types in the forms.

Delete events

Enables the user to delete an event.

✓

---
