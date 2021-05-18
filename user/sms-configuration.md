# Configuring SMS
<!--DHIS2-SECTION-ID:sms-configuration-intro-->

## SMS Commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-->

SMS commands process SMS messages received by a DHIS2 instance, taking certain
actions depending on the command and message content. Multiple SMS commands can
be set up to process and handle data in multiple ways. A SMS command is an
object containing the configurations for each SMS form: reporting data from
phones or j2me apps, alerting users, registering patient or user, etc.

### Listing available commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-list-->

To see all available commands, navigate to the "SMS Commands" page.
All commands will be listed in a paginated table. On this page the following
actions are available:

* Add commands (1)
* Edit commands (2)
* Delete commands (3)
* Batch-delete commands (4)

![SMS Commands - List](resources/images/sms-configuration/commands-list.png)

### Delete available commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-delete-->

Deleting commands can be done by individually checking the checkboxes of each
command (1) that should be deleted or by selecting all displayed commands by
checking the checkbox in the table head (2). After selecting the commands to
delete, the "Delete selected" button needs to be clicked (3).

![SMS Commands - Delete selection](resources/images/sms-configuration/commands-delete-selection.png)

To prevent accidental deletions, a confirmation dialog will show up.

![SMS Commands - Delete confirmation](resources/images/sms-configuration/commands-delete-confirmation.png)

### Adding commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-add-->

&#9888; &#9888; &#9888; **WARNING!** &#9888; &#9888; &#9888;<br />
Commands are not working after they've been added!
Most of the configurable fields are only displayed when editing the command!

After clicking on the "Add command" in the command overview page, a dynamic
form will appear. Depending on the parser type, different inputs will be
displayed:

| Parser type | User group | Program | Program Stage | Data set |
|-|-|-|-|-|
| Alert parter | &#10003; | &#10005; | &#10005; | &#10005; |
| Event registration parser | &#10005; | &#10003; | &#10003; | &#10005; |
| J2ME parser | &#10005; | &#10005; | &#10005; | &#10003; |
| Key value parser | &#10005; | &#10005; | &#10005; | &#10003; |
| Program stage data entry parser | &#10005; | &#10003; | &#10003; | &#10005; |
| Tracked entity registration parser | &#10005; | &#10003; | &#10005; | &#10005; |
| Unregistered parser | &#10003; | &#10005; | &#10005; | &#10005; |

#### Event registration parser

These commands can have short codes for their associated program stage.
Only programs of type "Event program" can be chosen for this command.
Therefore only one program stage exists, which will be selected automatically.

### Editing commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-edit-->

When editing commands, changing the parser type as well as the additional data
supplied when adding the command is not possible. The only way this is
currently possible is by creating a new command and deleting the old one.

Most commands share the same input fields, with a few exceptions that will be
explained a bit below.

These common fields are:

* Name (required)
* Field separator
* Reply message
* Wrong format message
* No user message
* More than one org unit message
* Success message

Some commands have the option to add short codes, which are explained in the
individual sections for each parser type down below.

#### Editing alert parser commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-edit-alertparser-->

When editing an alert parser command, only two fields are editable, the fields
that are shared between most parser types are not present:

* Name (required)
* Confirm message

Both are text fields.

#### Editing event registration parser commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-edit-parser-->

Commands of this parser type have all the shared fields.
Additionally short codes can be defined.
A short code can be added for every data element connected to the program stage
that was selected when adding the command:

![SMS Commands - Event registration parser short codes](resources/images/sms-configuration/commands-edit-eventregistrationparse-shortcodes.png)

#### Editing J2ME parser commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-edit-parser-->

#### Editing key value parser commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-edit-parser-->

This command type works identically to J2ME parser commands work. Please check
the documentation above.

#### Editing program stage data entry parser commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-edit-parser-->

#### Editing tracked entity registration parser commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-edit-parser-->

#### Editing unregistered parser commands
<!--DHIS2-SECTION-ID:sms-configuration-commands-edit-parser-->

## SMS Gateways
<!--DHIS2-SECTION-ID:sms-configuration-gateways-->

An SMS gateway lets a DHIS2 instance send and receive SMS messages. Different
gateway types can be added and configured below. At least one gateway is needed
to send and receive SMS messages. Load balancing will use all gateways if there
are multiple available.

There are four types of Gateways supported by the SMS Service.

### Managing gateways
<!--DHIS2-SECTION-ID:sms-configuration-gateways-manage-->

### Adding gateways
<!--DHIS2-SECTION-ID:sms-configuration-gateways-add-->

### Editing gateways
<!--DHIS2-SECTION-ID:sms-configuration-gateways-edit-->

## View inbound SMS
<!--DHIS2-SECTION-ID:sms-configuration-inbound-->

## View outbound SMS
<!--DHIS2-SECTION-ID:sms-configuration-outbound-->
