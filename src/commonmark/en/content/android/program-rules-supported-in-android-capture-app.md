# Program rules supported in Android Capture App

The following is a comprehensive list of all Program rule components (variable types and actions) available in DHIS 2, and notes on whether or not these have been implemented in the Android Capture app.

Any issues around using a particular feature with Android are highlighted with an exclamation mark \!.

||||
| :-: | :------ |
| ✓ | Value type implemented |
| - | Value type not implemented, but will be safely ignored (if not compulsory) |
| n/a | Non-applicable|
| ![](resources/images/image3_icon.png) | Work in progress. Feature not completely implemented yet or with unexpected behavior already reported |


## Program rule Variable source types supported
| Variable type| Description of variable type| Program with registration| Program without registration| Notes on implementation|
|-|-|-|-|-|
|Data element from the newest event for a program stage|This source type works the same way as "Data element from the newest event in the current program", except that it only evaluates values from a specific program stage.|![](resources/images/image3_icon.png)|n/a||
|Data element from the newest event in the current program (with registration)|This source type is populated with the newest data value collected for the specified data element within the enrolment.|![](resources/images/image3_icon.png)|n/a||
|Data element from the newest event in the current program (without registration)|This program rule variable will be populated with the newest data value found within the 10 newest events in the same organization unit.|n/a|![](resources/images/image3_icon.png)||
|Data element in current event (with registration)|Variable takes the data element&rsquo;s value from the current event.|✓|n/a||
|Data element in current event (without registration)|Contains the data value from the same event that the user currently has open.|n/a|✓||
|Data element from previous event (with registration)|Program rule variables with this source type will contain the newest value from all previous events for the specified data element. The event currently open is not evaluated.|✓|n/a||
|Data element from previous event (without registration)|This program rule variable will be populated with the newest data value found within the 10 events preceding the current event date (i.e. not including the current event).|n/a|✓||
|Tracked entity attribute|Populates the program rule variable with a specified tracked entity attribute for the current TEI (e.g. current patient).|✓|n/a||
|Calculated value|Calculated value.|✓|✓||

## Program rule Actions supported (Data element in current event)
!<a href="https://www.google.com/url?q=https://jira.dhis2.org/browse/ANDROAPP-1793&amp;sa=D&amp;ust=1557433016465000">ANDROAPP-1793</a>&nbsp;Program Rules support names and codes for option sets variables from 1.2.1

| Action| Description of action| Program with registration| Program without registration| Notes on implementation|
|-|-|-|-|-|
|Hide Field|Hides an individual data element if the rule is true.|✓|✓|! If you change the value after the field is hidden, it will revert the action depending on the value type rule engine default value. We recommend its use combined with the hasvalue function.||
|Hide Section|Hides a whole section and its data elements if the rule is true.|✓|✓||
|Hide Option|Hide a single option for an option set in a given data element/tracked entity attribute. When combined with show option group the hide option takes precedence|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)||
|Hide Option Group|Hide all options in a given option group and data element/tracked entity attribute. When combined with show option group the hide option takes precedence |![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)||
|Show option group|Used to show only options from a given option group in a given data element/tracked entity attribute. To show an option group implicitly hides all options that is not part of the group(s) that is shown.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)||
|Assign Value|Assigns a value to a specified data element or attribute if the rule is true.|✓|✓||
|Show Warning|Shows pop-up warning to the user if rule is true; does not prevent the user from continuing.|✓|✓||
|Warning on Complete|Shows a pop-up warning to the user if, at the point &lsquo;complete&rsquo; is clicked, a rule is true; this does not prevent the user from continuing.|✓|✓||
|Show Error|Shows a pop-up error message to the user as soon as a rule is true, and prevents user from continuing until rule is no longer true.|✓|✓||
|Error on Complete|Shows a pop-up warning to the user if, when "complete"; is clicked, a rule is true, and prevents user from continuing until rule is no longer true.|✓|✓||
|Make Field Mandatory|Sets a data element as "mandatory"; if rule is true.|✓|✓||
|Display Text (Event Programs)|Used to display information that is not an error or a warning, for example feedback.|✓|✓| Text is displayed in all sections.||
|Display Text (Tracker Programs)|Used to display information that is not an error or a warning, for example feedback.|✓|✓|Rules triggered by "Current event variables" are showing the text ONLY in the form. Rules triggered by "Built-in variables" display text ONLY on the indicators tab. The other Program rule variables are displaying the text in BOTH the form and the indicator tab.||
|Display Key Value/Pair (Event Programs)|Used to display information drawn from a data element.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|Key value / pair is not displayed in event programs||
|Display Key Value/Pair (Traker Programs)|Used to display information drawn from a data element.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|Rules triggered by "Current event variables" are not showing the key value / pair||
|Hide Program Stage|Hides a whole program stage from the user if the rule is true.|n/a|n/a|Action rule only supported for&nbsp;Data element from the newest event in the current program variable type.||
|Create event|Create an event within the same enrollment.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|This action will be available in future versions of DHIS2. <a href="https://www.google.com/url?q=https://jira.dhis2.org/browse/ANDROAPP-1131&amp;sa=D&amp;ust=1557433016497000">ANDROAPP-1131</a>||

## Program rule Actions supported (Other variables)

!<a href="https://www.google.com/url?q=https://jira.dhis2.org/browse/ANDROAPP-1793&amp;sa=D&amp;ust=1557433016498000">ANDROAPP-1793</a> Program Rules support names and codes for option sets variables from 1.2.1

| Action| Description of Action| Data Element from the Newest Event in the Current Program (with registration)|Data Element from the Newest Event in the Current Program (without registration)| Data Element from Previous Event (with registration) |Data Element from Previous Event (without registration)| Data Element from the Newest Event for a Program Stage (with registration)|Tracked Entity Atribute (with registration) |Notes on implementation|
|-|-|-|-|-|-|-|-|-|
|Hide Field|Hides an individual data element if the rule is true.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|✓|✓|![](resources/images/image3_icon.png)|✓||
|Hide Section|Hides a whole section and its data elements if the rule is true.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|✓|✓|![](resources/images/image3_icon.png)|✓||
|Hide Option|Hide a single option for an option set in a given data element/tracked entity attribute. When combined with show option group the hide option takes precedence.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)||
|Hide Option Group|Hide all options in a given option group and data element/tracked entity attribute.When combined with show option group the hide option takes precedence.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)||
|Assign Value|Assigns a value to a specified data element or attribute if the rule is true.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|✓|✓|![](resources/images/image3_icon.png)|✓||
|Show Warning|Shows pop-up warning to the user if rule is true; does not prevent the user from continuing.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|✓|✓|![](resources/images/image3_icon.png)|✓||
|Warning on Complete|Shows a pop-up warning to the user if, at the point "complete" is clicked, a rule is true; this does not prevent the user from continuing.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|✓|✓|![](resources/images/image3_icon.png)|n/a||
|Show Error|Shows a pop-up error message to the user as soon as a rule is true, and prevents user from continuing until rule is no longer true.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|✓|✓|![](resources/images/image3_icon.png)|✓|The rule will let the user to finish the enrollment but will prevent from completing the events until rule is no longer true.||
|Error on Complete|Shows a pop-up warning to the user if, at the point "complete" is clicked, a rule is true; this does not prevent the user from continuing.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|✓|✓|![](resources/images/image3_icon.png)|n/a||
|Make Field Mandatory|Sets a data element as "mandatory" if rule is true.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|✓|✓|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)||
|Display Text (Event Program)|Used to display information that is not an error or a warning, for example feedback.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|Text is displayed in all sections||
|Display Text (Tracker Program)|Used to display information that is not an error or a warning, for example feedback.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|Rules triggered by "Current event"; variables are showing the text ONLY in the form. Rules triggered by "Built-in variables" display text ONLY on the indicators tab. The other Program rule variables are displaying the text in BOTH the form and the indicator tab.||
|Display Key Value/Pair (Event Program)|Used to display information drawn from a data element.|✓|![](resources/images/image3_icon.png)|✓|![](resources/images/image3_icon.png)|✓|✓|Key value / pair is not displayed in event programs||
|Display Key Value/Pair (Tracker Program)|Used to display information drawn from a data element.|✓|![](resources/images/image3_icon.png)|✓|![](resources/images/image3_icon.png)|✓|✓|Rules triggered by built in variables or any variable type, with the exception of "Current event", display the key value / pair ONLY in the indicators tab.||
|Hide Program Stage|Hides a whole program stage from the user if the rule is true.|✓|n/a|n/a|n/a|n/a|✓|Action rule only supported for&nbsp;Data element from the newest event in the current program variable type. If the event is auto-generated, the rule will not apply.||
|Create event|Create an event within the same enrollment.|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|![](resources/images/image3_icon.png)|This action will be available in future versions of the App. <a href="https://www.google.com/url?q=https://jira.dhis2.org/browse/ANDROAPP-1131&amp;sa=D&amp;ust=1557433016558000">ANDROAPP-1131</a>||

## Functions to use in program rule expressions

| Function   | Description of function | Status        | Notes on implementation |
| ---- | ----------------------------- | ---- | -- |
| d2:ceil    | Rounds the input argument up to the nearest whole number.   | ✓    | |
| d2:floor   | Rounds the input argument down to the nearest whole number. | ✓    | |
| d2:round   | Rounds the input argument to the nearest whole number.      | ✓    | |
| d2:modulus | Produces the modulus when dividing the first with the second argument.        | ✓    | |
| d2:zing    | Evaluates the argument of type number to zero if the value is negative, otherwise to the value itself.   | ✓    | |
| d2:oizp    | Evaluates the argument of type number to one if the value is zero or positive, otherwise to zero.        | ✓    | |
| d2:concatenate      | Produces a string concatenated string from the input parameters. Supports any number of parameters.      | ✓    | |
| d2:daysBetween      | Produces the number of days between the first and second argument. If the second argument date is before the first argument,  the return value will be the negative number of days between the two dates. The static date format is 'yyyy-MM-dd'.        | ✓    | |
| d2:weeksBetween     | Produces the number of full weeks between the first and second argument. If the second argument date is before the first argument,  the return value will be the negative number of weeks between the two dates. The static date format is 'yyyy-MM-dd'. | ✓    | |
| d2:monthsBetween    | Produces the number of full months between the first and second argument. If the second argument date is before the first argument the return value will be the negative number of months between the two dates. The static date format is 'yyyy-MM-dd'. | ✓    | |
| d2:yearsBetween     | Produces the number of years between the first and second argument. If the second argument date is before the first argument, the return value will be the negative number of years between the two dates. The static date format is 'yyyy-MM-dd'.       | ✓    | |
| d2:addDays | Produces a date based on the first argument date, adding the second argument number of days.    | ✓    | |
| d2:count   | Counts the number of values that is entered for the source field in the argument.      | ✓    | |
| d2:countIfValue     | Counts the number of matching values that is entered for the source field in the first argument. Only occurrences that matches the second argument is counted. | ✓    | |
| d2:countIfZeroPos   | Counts the number of values that is zero or positive entered for the source field in the argument. The source field parameter is the name of one of the defined source fields in the program.      | ✓    | |
| d2:hasValue         | Returns the number of numeric zero and positive values among the given object arguments. Can be provided with any number of arguments.       | ✓    | |
| d2:validatePattern  | Evaluates to true if the input text is an exact match with the supplied regular expression pattern. The regular expression needs to be escaped.       | ✓    | |
| d2:left    | Evaluates to the left part of a text, num-chars from the first character.     | ✓    | |
| d2:right   | Evaluates to the right part of a text, num-chars from the last character.     | ✓    | |
| d2:substring        | Evaluates to the part of a string specified by the start and end character number.     | ✓    | |
| d2:split   | Split the text by delimiter, and keep the nth element (0 is the first).       | ✓    | |
| d2:length  | Find the length of a string.     | ✓    | |
| d2:zpvc    | Returns the number of numeric zero and positive values among the given object arguments. Can be provided any number of arguments.   | ✓    | |
| d2:inOrgUnitGroup\* | Evaluates whether the current organization unit is in the argument group. The argument can be defined with either ID or organization unit group code. | ![](resources/images/image3_icon.png) | |

\* Available in DHIS2 v2.30

## Standard variables to use in program rule expressions

\* Available in DHIS2 v2.30

| Variable     | Description of function       | Status | Notes on implementation |
| --- | -------------------------------------------- | --- | -- |
| V{current_date}       | Contains the current date whenever the rule is executed. | ✓      | |
| V{event_date}         | Contains the event date of the current event execution. Will not have a value at the moment the rule is executed as part of the registration form. | ✓      | |
| V{due_date} \*        | This variable will contain the current date when the rule is executed. Note: This means that the rule might produce different results at different times, even if nothing else has changed.     | ✓      | |
| V{event_count}        | Contains the total number of events in the enrollment.   | ✓      | |
| V{enrollment_date} \* | Contains the enrollment date of the current enrollment. Will not have a value for single event programs.       | ✓      | |
| V{incident_date} \*   | Contains the incident date of the current enrollment. Will not have a value for single event programs.         | ✓      | |
| V{enrollment_id} \*   | Universal identifier string(UID) of the current enrollment. Will not have a value for single event programs.   | ✓      | |
| V{event_id}  | Universal identifier string(UID) of the current event context. Will not have a value at the moment the rule is executed as part of the registration form.   | ✓      | |
| V{orgunit_code}       | Contains the code of the orgunit that is linked to the current enrollment. For single event programs the code from the current event Org Unit will be used instead.  | ✓      | |
| V{environment}        | Contains a code representing the current runtime environment for the rules. The possible values is "WebClient", "AndroidClient" and "Server". Can be used when a program rule is only supposed to run in one or more of the client types.    | ✓      | |
| V{program_stage_id}   | Contains the ID of the current program stage that triggered the rules. This can be used to run rules in specific program stages, or avoid execution in certain stages. When executing the rules in the context of a TEI registration form the variable will be empty.   | ✓      | |
| V{program_stage_name} | Contains the name of the current program stage that triggered the rules. This can be used to run rules in specific program stages, or avoid execution in certain stages. When executing the rules in the context of a TEI registration form the variable will be empty. | ✓      | |

\*Only applies to tracker

---
