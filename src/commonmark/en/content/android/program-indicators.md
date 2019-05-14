# Program Indicators

The following is a comprehensive list of all Program indicator variables available in DHIS2, and notes on whether or not these have been implemented in the Android Capture app.

Any issues around using a particular feature with Android are highlighted with an exclamation mark \!.

Everytime the icon ![](resources/images/image1_icon.png) is presented, a tip will be provided for a better use and understanding of the app.

---

|        |  |
| ---- | -- |
| ✓    | Component implemented   |
| –    | Component not implemented (rule fails)    |
| N/A  | Non-applicable |
| ![](resources/images/image3_icon.png) | Work in progress. Feature not completely implemented yet or with unexpected behaviour already reported . |

## Variables to use in a program indicator expression or filter

<table>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>Variable type</p></td>
<td><p>Description of variable type</p></td>
<td><p>Status</p></td>
<td><p>Notes on implementation</p></td>
</tr>
<tr class="even">
<td><p>Event Date<br />
event_date</p></td>
<td><p>The date of when the event took place.</p></td>
<td><p>✓</p></td>
<td><p></p></td>
</tr>
<tr class="odd">
<td><p>Due Date<br />
due_date</p></td>
<td><p>The date of when an event is due.</p></td>
<td><p><img src="resources/images/image3_icon.png" /></p></td>
<td><p></p></td>
</tr>
<tr class="even">
<td><p>Incident date</p>
<p>incident_date</p></td>
<td><p>The date of the incidence of the event.</p></td>
<td><p>✓</p></td>
<td><p></p></td>
</tr>
<tr class="odd">
<td><p>Enrollment date</p>
<p>(not visible on UI)</p>
<p>enrollment_date</p></td>
<td><p>The date of when the tracked entity instance was enrolled in the program.</p></td>
<td><p>✓</p></td>
<td><p></p></td>
</tr>
<tr class="even">
<td><p>Enrollment Status<br />
enrollment_status</p></td>
<td><p>Can be used to include or exclude enrollments in certain statuses.</p></td>
<td><p>–</p></td>
<td><p></p></td>
</tr>
<tr class="odd">
<td><p>Current date</p>
<p>current_date</p></td>
<td><p>The current date.</p></td>
<td><p>✓</p></td>
<td><p></p></td>
</tr>
<tr class="even">
<td><p>Completed date</p>
<p></p></td>
<td><p>The date the event is completed.</p></td>
<td><p><img src="resources/images/image3_icon.png" /></p></td>
<td><p></p></td>
</tr>
<tr class="odd">
<td><p>Value Count</p>
<p>value_count</p></td>
<td><p>The number of non-null values in the expression part of the event.</p></td>
<td><p>✓</p></td>
<td><p></p></td>
</tr>
<tr class="even">
<td><p>Zero or positive value count</p>
<p>zero_pos_value_count</p></td>
<td><p>The number of numeric positive values in the expression part of the event.</p></td>
<td><p>✓</p></td>
<td><p></p></td>
</tr>
<tr class="odd">
<td><p>Event Count</p>
<p>event_count</p></td>
<td><p>The count of events (useful in combination with filters).</p></td>
<td><p>✓</p></td>
<td><p></p></td>
</tr>
<tr class="even">
<td><p>Enrollment Count</p>
<p>enrollment_count</p></td>
<td><p>The count of enrollments (useful in combination with filters).</p></td>
<td><p>N/A</p></td>
<td><p>Indicators in the Android App are calculated in the domain of one TEI enrollment. Value always 1.</p></td>
</tr>
<tr class="odd">
<td><p>TEI Count</p>
<p>tei_count</p></td>
<td><p>The count of tracked entity instances (useful in combination with filters).</p></td>
<td><p>N/A</p></td>
<td><p>Indicators in the Android App are calculated in the domain of one TEI enrollment. Value always 1.</p></td>
</tr>
<tr class="even">
<td><p>Program Stage Name<br />
program_stage_name</p></td>
<td><p>Can be used in filters for including only certain program stages in a filter for tracker programs. </p></td>
<td><p><img src="resources/images/image3_icon.png" /></p></td>
<td><p></p></td>
</tr>
<tr class="odd">
<td><p>Program stage id</p>
<p>program_stage_id</p></td>
<td><p>Can be used in filters for including only certain program stages in a filter for tracker programs</p></td>
<td><p><img src="resources/images/image3_icon.png" /></p></td>
<td><p></p></td>
</tr>
<tr class="even">
<td><p>Reporting Period Start</p>
<p>reporting_period_start</p></td>
<td><p>Can be used in filters or expressions for comparing any date to the first date in each reporting period.</p></td>
<td><p>N/A</p></td>
<td><p>Indicators in the Android App are calculated in the domain of one TEI enrollment.</p></td>
</tr>
<tr class="odd">
<td><p>Reporting Period End</p>
<p>reporting_period_end</p></td>
<td><p>Can be used in filters or expressions for comparing any date to the last inclusive date in each reporting period.</p></td>
<td><p>N/A</p></td>
<td><p>Indicators in the Android App are calculated in the domain of one TEI enrollment.</p></td>
</tr>
</tbody>
</table>

\*[Documentation Reference](https://www.google.com/url?q=https://docs.dhis2.org/master/en/user/html/configure_program_indicator.html%23program_indicator_functions_variables_operators&sa=D&ust=1557433016643000)

<div>

</div>
