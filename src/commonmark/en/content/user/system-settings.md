# System settings

<!--DHIS2-SECTION-ID:settings-->

## General settings

<!--DHIS2-SECTION-ID:system_general_settings-->

<table>
<caption>General settings</caption>
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
<td><p><strong>Maximum number of analytics records</strong></p></td>
<td><p>Increase this number to provide more records from the analytics.</p>
<p>The default value is 50,000.</p>
<blockquote>
<p><strong>Warning</strong></p>
<p>Use the setting <strong>Unlimited</strong> carefully, it might result in a very high load on your server.</p>
</blockquote></td>
</tr>
<tr class="even">
<td><p><strong>Maximum number of SQL view records</strong></p></td>
<td><p>Set the maximum number of records in a SQL view.</p>
<p>The default value is Unlimited.</p>
</tr>
<tr class="odd">
<td><p><strong>Cache strategy</strong></p></td>
<td><p>Decides for how long reports analytics responses should be cached.</p>
<p>If you use the scheduled, nightly analytics update, you may want to select <strong>Cache until 6 AM tomorrow</strong>. This is because data in reports change at that time, and you can safely cache data up to the moment when the analytics tables are updated.</p>
<p>If you are loading data continuously into the analytics tables, select <strong>No cache</strong>.</p>
<p>For other cases select the amount of time you want the data to be cached.</p></td>
</tr>
<tr class="even">
<td><p><strong>Infrastructural indicators</strong></p></td>
<td><p>Defines an indicator group where the member indicators should describe data about the organisation units' infrastructure.</p>
<p>You can view the infrastructural data in the <strong>GIS</strong> app: right-click a facility and click <strong>Show information</strong>.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Infrastructural data elements</strong></p></td>
<td><p>Defines a data element group where the member data elements should describe data about the organisation units' infrastructure.</p>
<p>Infrastructural data elements can be population, doctors, beds, Internet connectivity and climate.</p>
<p>You can view the infrastructural data in the <strong>GIS</strong> app: right-click a facility and click <strong>Show information</strong>.</p></td>
</tr>
<tr class="even">
<td><p><strong>Infrastructural period type</strong></p></td>
<td><p>Sets the frequency for which the data elements in the infrastructural data elements group are captured.</p>
<p>This will typically be yearly. When viewing the infrastructural data you will be able to select the time period of the data source.</p>
<p>You can view the infrastructural data in the <strong>GIS</strong> app: right-click a facility and click <strong>Show information</strong>.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Default relative period for analysis</strong></p></td>
<td><p>Setting this value will determine which relative period is selected as the default in the analytics apps.</p></td>
</tr>
<tr class="even">
<td><p><strong>Feedback recipients</strong></p></td>
<td><p>Defines a user group where the members will receive all messages sent via the feedback function in the <strong>Dashboard</strong> app.</p>
<p>This will typically be members of the super user team who are able to support and answer questions coming from end-users.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Max offline organisation unit levels</strong></p></td>
<td><p>Defines how many levels in the organisation unit hierarchy will be available offline in the organisation unit tree widget.</p>
<p>Under normal circumstances you can leave this on the lowest level, which is default is the default setting.</p>
<p>It can be useful to set it to a higher level to reduce initial load time in cases where you have a large number of organisation units, typically more than 30 000.</p></td>
</tr>
<tr class="even">
<td><p><strong>Data analysis std dev factor</strong></p></td>
<td><p>Sets the number of standard deviations used in the outlier analysis performed on the captured data in the <strong>Data Entry</strong> app.</p>
<p>The default value is 2. A high value will catch less outlier values than a low value.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Phone number area code</strong></p></td>
<td><p>The area code for the area in which your deployment is located.</p>
<p>Used for sending and receiving SMS. Typically, this is a country code.</p>
<p><em>+260</em> (country code for Zambia)</p></td>
</tr>
<tr class="even">
<td><p><strong>Enable multi-organisation unit forms</strong></p></td>
<td><p>Enables support to enter data forms for multiple organisation units at the same time in the <strong>Data Entry</strong> app.</p>
<p>If you've enabled this setting, you can in the <strong>Data Entry</strong> app, click on the parent organisation unit for the children that you want to enter data for, and the data set list will include data sets that are assigned to the children of that parent.</p></td>
</tr>
<tr class="odd">
<td><strong>Acceptance required before approval</strong></td>
<td>When this setting is selected, acceptance of data will be required first before submission to the next approval level is possible.</td>
</tr>
</tbody>
</table>

## Analytics settings

<!--DHIS2-SECTION-ID:system_analytics_settings-->

<table>
<caption>Analytics settings</caption>
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
<td><p><strong>Default relative period for analysis</strong></p></td>
<td><p>Defines the relative period to use by default in analytics app: <strong>Data Visualizer</strong>, <strong>Event Reports</strong>, <strong>Event Visualizer</strong>, <strong>GIS</strong> and <strong>Pivot Table</strong> apps. The relative period will be automatically selected when you open these apps.</p>
<p>Recommended setting: the most commonly used relative period among your users.</p></td>
</tr>
<tr class="even">
    <td><p><strong>Hide daily periods</strong></p></td>
    <td><p>Hide daily periods in the analysis tools</p></td>
</tr>
<tr class="odd">
    <td><p><strong>Hide weekly periods</strong></p></td>
    <td><p>Hide weekly periods in the analysis tools</p></td>
</tr>
<tr class="even">
    <td><p><strong>Hide monthly periods</strong></p></td>
    <td><p>Hide monthly periods in the analysis tools</p></td>
</tr>
<tr class="odd">
    <td><p><strong>Hide bimonthly periods</strong></p></td>
    <td><p>Hide bimonthly periods in the analysis tools</p></td>
</tr>
<tr class="even">
<td><strong>Financial year relative start month</strong></td>
<td>Defines which month (April, July or October) the the relative financial year in the analytics apps should begin on.</td>
</tr>
<tr class="odd">
<td><p><strong>Cacheability</strong></p></td>
<td><p>Sets whether analytics data responses should be served with public or private visibility.</p>
<p><strong>Private</strong>: Any node or server between the DHIS2 server and the end user which has the ability to cache can NOT cache the web page. This is useful if the page served can or do contain sensitive information. This means that each time you want a web page, either you get a new page from the DHIS2 server, or the DHIS2 server caches the page. No other server than the DHIS2 server are allowed to cache the page.</p>
<p><strong>Public</strong>: Any node or server between the DHIS2 server and the end user which has the ability to cache can cache the web page. This relives the traffic to the DHIS2 server and potentially speeds up the subsequent page loading speed.</p></td>
</tr>
<tr class="even">
<td><p><strong>Analytics cache mode</strong></p></td>
<td><p>Support two different modes:</p>
<p><strong>Progressive</strong>: this relates to the new progressive caching feature for analytics. When enabled, it OVERRIDES the global caching strategy for analytics requests. This mode will trigger HTTP and data layer caching for all analytics requests. When enabling this mode, the <em>caching factor</em> is MANDATORY.</p>
<p><strong>Fixed</strong>: the requests will be cached based on the period of time defined in <em>cache strategy.</em></p></td>
</tr>
<tr class="odd">
<td><p><strong>Caching factor</strong></p></td>
<td><p>Select a value for the caching factor. This field is only available when the analytics cache mode has been set to <em>progressive</em>.</p>
<p>It shows a list of integers where each integer represents an absolute caching factor. This integer will be used internally to calculate the final expiration time for each analytics request. Higher the caching factor, for longer the request will be cached.</p></td>
</tr>
<tr class="even">
<td><p><strong>Max number of years to hide unapproved data in analytics</strong></p></td>
<td><p>Sets whether and for how long back in time analytics should respect the approval level of the data. Typically, data which is several years old would be considered to be approved by default. In order to speed up analytics requests, you can choose to ignore the actual approval level of historical data.</p>
<p><strong>Never check approval</strong>: no data will be hidden, irrespective of its data approval status.</p>
<p><strong>Check approval for all data</strong>: approval status will always be checked.</p>
<p>Other options, for example <strong>Last 3 years</strong>: approval status will be checked for data which is newer than 3 years old; older data will not be checked.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Threshold for analytics data caching</strong></p></td>
<td><p>Sets whether to enable caching data older than the specified number of years only.</p>
<p>This allows for returning the most recent data directly with no caching, while serving cached version of older data for performance concerns.</p></td>
</tr>
<tr class="even">
<td><p><strong>Respect category option start and end date in analytics table export</strong></p></td>
<td><p>This setting controls whether analytics should filter data which is associated with a category option with a start and end date, but which is not associated with a period within the category options interval of validity.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Put analytics in maintenance mode</strong></p></td>
<td>Places the analytics and web API of DHIS2 in maintenance mode. This means that &quot;503 Service Unavailable&quot; will be returned for all requests.
<p>This is useful when you need to perform maintenance on the server, for example rebuilding indexes while the server is running in production, in order to reduce load and more efficiently carry out the maintenance.</p></td>
</tr>
<tr class="even">
<td><p><strong>Skip zero data values in analytics tables</strong></p></td>
<td><p>Does not include in analytics tables any aggregate data values that are zero. This can reduce analytics tables sizes, and speed up the building and accessing of the analytics tables, if you have aggregate data values that are zero and stored (the data element is configured to store zero values).</p></td>
</tr>
</tbody>
</table>

## Server settings

<!--DHIS2-SECTION-ID:system_server_settings-->

<table>
<caption>Server settings</caption>
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
<td><p><strong>Number of database server CPUs</strong></p></td>
<td><p>Sets the number of CPU cores of your database server.</p>
<p>This allows the system to perform optimally when the database is hosted on a different server than the application server, since analytics in DHIS2 scales linearly with the number of available cores.</p></td>
</tr>
<tr class="even">
<td><p><strong>System notifications email address</strong></p></td>
<td><p>Defines the email address which will receive system notifications.</p>
<p>Notifications about failures in processes such as analytics table generation will be sent here. This is useful for application monitoring.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Google Analytics (Universal Analytics) key</strong></p></td>
<td><p>Sets the Google UA key to provide usage analytics for your DHIS2 instance through the Google Analytics platform. It should be noted that currently, not all apps in DHIS2 support Google Analytics, so certain activity of your users may not appear in this platform.</p>
<p>You can read more about Google Analytics at <a href="http://google.com/analytics" class="uri">http://google.com/analytics</a>.</p></td>
</tr>
<tr class="even">
<td><p><strong>Google Maps API key</strong></p></td>
<td><p>Defines the API key for the Google Maps API. This is used to display maps within DHIS2.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Bing Maps API key</strong></p></td>
<td><p>Defines the API key for the Bing Maps API. This is used to display maps within DHIS2.</p></td>
</tr>
</tbody>
</table>

## Appearance settings

<!--DHIS2-SECTION-ID:system_appearance_settings-->

<table>
<caption>Appearance settings</caption>
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
<td><p><strong>Select language</strong></p></td>
<td>
    <p>Sets the language for which you can then enter translations of the following settings:</p>
    <ul>
        <li><p><strong>Application introduction</strong></p></li>
        <li><p><strong>Application title</strong></p></li>
        <li><p><strong>Application notification</strong></p></li>
        <li><p><strong>Application left-side footer</strong></p></li>
        <li><p><strong>Application right-side footer</strong></p></li>
    </ul>
    <blockquote>
        <p><strong>Note</strong></p>
        <p>Before each of these settings can accept a translated value, they first need to have a default/fallback value. This value can be set by selecting <em>System default (fallback)</em> in this dropdown.</p>
    </blockquote>
</td>
</tr>
<tr class="even">
<td><p><strong>Application title</strong></p></td>
<td><p>Sets the application title on the top menu.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Application introduction</strong></p></td>
<td><p>Sets an introduction of the system which will be visible on the top-left part of the login page.</p></td>
</tr>
<tr class="even">
<td><p><strong>Application notification</strong></p></td>
<td><p>Sets a notification which will be visible on the front page under the login area.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Application left-side footer</strong></p></td>
<td><p>Sets a text in the left-side footer area of the login page.</p></td>
</tr>
<tr class="even">
<td><p><strong>Application right-side footer</strong></p></td>
<td><p>Sets a text in the right-side footer area of the login page.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Style</strong></p></td>
<td><p>Sets the style (look-and-feel) of the system.</p>
<p>The user can override this setting in the <strong>Settings</strong> app: <strong>User settings</strong> &gt; <strong>Style</strong>.</p>
<blockquote>
<p><strong>Note</strong></p>
<p>Due to technical reasons, it's not possible to change the color of the newest version of the header bar. The apps with the newest header bar will retain the blue header bar.</p>
</blockquote></td>
</tr>
<tr class="even">
<td><p><strong>Start page</strong></p></td>
<td><p>Sets the page or app which the user will be redirected to after log in.</p>
<p>Recommended setting: the <strong>Dashboard</strong> app.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Help page link</strong></p></td>
<td><p>Defines the URL which users will see when they click <strong>Profile</strong> &gt;<strong>Help</strong>.</p></td>
</tr>
<tr class="even">
<td><p><strong>Flag</strong></p></td>
<td><p>Sets the flag which is displayed in the left menu of the <strong>Dashboard</strong> app.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Interface language</strong></p></td>
<td><p>Sets the language used in the user interface.</p>
<p>The user can override this setting in the <strong>Settings</strong> app: <strong>User settings</strong> &gt; <strong>Interface language</strong>.</p></td>
</tr>
<tr class="even">
<td><p><strong>Database language</strong></p></td>
<td><p>Sets the language used in the database.</p>
<p>The user can override this setting in the <strong>Settings</strong> app: <strong>User settings</strong> &gt; <strong>Database language</strong>.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Property to display in analysis modules</strong></p></td>
<td><p>Sets whether you want to display the metadata objects' names or short names in the analytics apps: <strong>Data Visualizer</strong>, <strong>Event Reports</strong>, <strong>Event Visualizer</strong>, <strong>GIS</strong> and <strong>Pivot Table</strong> apps.</p>
<p>The user can override this setting in the <strong>Settings</strong> app: <strong>User settings</strong> &gt; <strong>Property to display in analysis modules</strong>.</p></td>
</tr>
<tr class="even">
<td><p><strong>Default digit group separator to display in analysis modules</strong></p></td>
<td><p>Sets the default digit group separator in the analytics apps: <strong>Data Visualizer</strong>, <strong>Event Reports</strong>, <strong>Event Visualizer</strong>, <strong>GIS</strong> and <strong>Pivot Table</strong> apps.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Require authority to add to view object lists</strong></p></td>
<td><p>If you select this option, you'll hide menu and index page items and links to lists of objects if the current user doesn't have the authority to create the type of objects (privately or publicly).</p></td>
</tr>
<tr class="even">
<td><p><strong>Custom login page logo</strong></p></td>
<td><p>Select this option and upload an image to add your logo to the login page.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Custom top menu logo</strong></p></td>
<td><p>Select this option and upload an image to add your logo to the left in the top menu.</p></td>
</tr>
</tbody>
</table>

## Email settings

<!--DHIS2-SECTION-ID:system_email_settings-->

<table>
<caption>Email settings</caption>
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
<td><p><strong>Host name</strong></p></td>
<td><p>Sets the host name of the SMTP server.</p>
<p>When you use Google SMTP services, the host name should be <em>smtp.gmail.com</em>.</p></td>
</tr>
<tr class="even">
<td><p><strong>Port</strong></p></td>
<td><p>Sets the port to connect to the SMTP server.</p></td>
</tr>
<tr class="odd">
<td><p><strong>User name</strong></p></td>
<td><p>The user name of the user account with the SMTP server.</p>
<p>mail@dhis2.org</p></td>
</tr>
<tr class="even">
<td><p><strong>Password</strong></p></td>
<td><p>The password of the user account with the SMTP server.</p></td>
</tr>
<tr class="odd">
<td><p><strong>TLS</strong></p></td>
<td><p>Select this option if the SMPT server requires TLS for connections.</p></td>
</tr>
<tr class="even">
<td><p><strong>Email sender</strong></p></td>
<td><p>The email address to use as sender when sending out emails.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Send me a test email</strong></p></td>
<td><p>Sends a test email to the current user logged into DHIS2.</p></td>
</tr>
</tbody>
</table>

## Access settings

<!--DHIS2-SECTION-ID:system_access_settings-->

<table>
<caption>Access settings</caption>
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
<td><p><strong>Self registration account user role</strong></p></td>
<td><p>Defines which user role should be given to self-registered user accounts.</p>
<p>To enable self-registration of users: select any user role from the list. A link to the self-registration form will be displayed on the login page.</p>
<blockquote>
<p><strong>Note</strong></p>
<p>To enable self-registration, you must also select a <strong>Self registration account organisation unit</strong>.</p>
</blockquote>
<p>To disable self-registration of users: select <strong>Disable self registration</strong>.</p></td>
</tr>
<tr class="even">
<td><p><strong>Self registration account organisation unit</strong></p></td>
<td><p>Defines which organisation unit should be associated with self-registered users.</p>
<blockquote>
<p><strong>Note</strong></p>
<p>To enable self-registration, you must also select a <strong>Self registration account user role</strong>.</p>
</blockquote></td>
</tr>
<tr class="odd">
<td><p><strong>Do not require reCAPTCHA for self registration</strong></p></td>
<td><p>Defines whether you want to use reCAPTCHA for user self-registration. This is enabled by default.</p></td>
</tr>
<tr class="even">
<td><p><strong>Enable user account recovery</strong></p></td>
<td><p>Defines whether users can restore their own passwords.</p>
<p>When this setting is enabled, a link to the account recovery form will be displayed on the front page.</p>
<blockquote>
<p><strong>Note</strong></p>
<p>User account recovery requires that you have configured email settings (SMTP).</p>
</blockquote></td>
</tr>
<tr class="odd">
<td><p><strong>Lock user account temporarily after multiple failed login attempts</strong></p></td>
<td><p>Defines whether the system should lock user accounts after five successive failed login attempts over a timespan of 15 minutes.</p>
<p>The account will be locked for 15 minutes, then the user can attempt to log in again.</p></td>
</tr>
<tr class="even">
<td><p><strong>Allow users to grant own user roles</strong></p></td>
<td><p>Defines whether users can grant user roles which they have themselves to others when creating new users.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Allow assigning object to related objects during add or update</strong></p></td>
<td><p>Defines whether users should be allowed to assign an object to a related object when they create or edit metadata objects.</p>
<p>You can allow users to assign an organisation unit to data sets and organisation unit group sets when creating or editing the organisation unit.</p></td>
</tr>
<tr class="even">
<td><p><strong>Require user account password change</strong></p></td>
<td><p>Defines whether users should be forced to change their passwords every 3, 6 or 12 months.</p>
<p>If you don't want to force users to change password, select <strong>Never</strong>.</p></td>
</tr>
<tr class="odd">
<td><strong>Enable password expiry alerts</strong></td>
<td>When set, users will receive a notification when their password is about to expire.</td>
</tr>
<tr class="even">
<td><p><strong>Minimum characters in password</strong></p></td>
<td><p>Defines the minimum number of characters users must have in their passwords.</p>
<p>You can select 8 (default), 10, 12 or 14.</p></td>
</tr>
<tr class="odd">
<td><p><strong>CORS whitelist</strong></p></td>
<td><p>Whitelists a set of URLs which can access the DHIS2 API from another domain. Each URL should be entered on separate lines. Cross-origin resource sharing (CORS) is a mechanism that allows restricted resources (e.g. javascript files) on a web page to be requested from another domain outside the domain from which the first resource was served.</p></td>
</tr>
</tbody>
</table>

## Calendar settings

<!--DHIS2-SECTION-ID:system_calendar_settings-->

<table>
<caption>Calendar settings</caption>
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
<td><p><strong>Calendar</strong></p></td>
<td><p>Defines which calendar the system will use.</p>
<p>The system supports the following calendars: Coptic, Ethiopian, Gregorian, Islamic (Lunar Hijri), ISO 8601, Julian, Nepali, Persian (Solar Hijri) and Thai.</p>
<blockquote>
<p><strong>Note</strong></p>
<p>This is a s system wide setting. It is not possible to have multiple calendars within a single DHIS2 instance.</p>
</blockquote></td>
</tr>
<tr class="even">
<td><p><strong>Date format</strong></p></td>
<td><p>Defines which date format the system will use.</p></td>
</tr>
</tbody>
</table>

## Data import settings

<!--DHIS2-SECTION-ID:system_data_import_settings-->

The data import settings apply to extra controls which can be enabled to
validate aggregate data which is imported through the web API. They
provide optional constraints on what should be considered a conflict
during import. The constraints are applied to each individual data value
in the import.

<table>
<caption>Data import settings</caption>
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
<td><p><strong>Require periods to match period type of data set</strong></p></td>
<td><p>Require period of data value to be of the same period type as the data sets for which the data element of data value is assigned to.</p></td>
</tr>
<tr class="even">
<td><p><strong>Require category option combos to match category combo of data element</strong></p></td>
<td><p>Require category option combination of data value to be part of the category combination of the data element of the data value.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Require organisation units to match assignment of data set</strong></p></td>
<td><p>Require organisation unit of data value to be assigned to one or more of the data sets which the data element of data value is assigned to.</p></td>
</tr>
<tr class="even">
<td><p><strong>Require attribute option combos to match category combo of data set</strong></p></td>
<td><p>Require attribute option combination of data value to be part of the category combination of the data set which the data element of data value is assigned to.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Require category option combo to be specified</strong></p></td>
<td><p>Require category option combination of data value to be specified.</p>
<p>By default it will fall back to default category option combination if not specified.</p></td>
</tr>
<tr class="even">
<td><p><strong>Require attribute option combo to be specified</strong></p></td>
<td><p>Require attribute option combination of data value to be specified.</p>
<p>By default it will fall back to default attribute option combination if not specified.</p></td>
</tr>
</tbody>
</table>

## Synchronization settings

The following settings are used for both data and metadata
synchronization.

> **Note**
>
> For more information about how you configure metadata synchronization,
> refer to [Configure metadata
> synchronizing](https://docs.dhis2.org/master/en/user/html/metadata_sync.html)

<table>
<caption>Synchronization settings</caption>
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
<td><p><strong>Remote server URL</strong></p></td>
<td><p>Defines the URL of the remote server running DHIS2 to upload data values to.</p>
<p>It is recommended to use of SSL/HTTPS since user name and password are sent with the request (using basic authentication).</p>
<p>The system will attempt to synchronize data once every minute.</p>
<p>The system will use this setting for metadata synchronization too.</p>
<blockquote>
<p><strong>Note</strong></p>
<p>To enable data and metadata synchronization, you must also enable jobs for <strong>Data synchronization</strong> and <strong>Metadata synchronization</strong> in the <strong>Scheduler</strong> app.</p>
</blockquote></td>
</tr>
<tr class="even">
<td><p><strong>Remote server user name</strong></p></td>
<td><p>The user name of the DHIS2 user account on the remote server to use for data synchronization.</p>
<blockquote>
<p><strong>Note</strong></p>
<p>If you've enabled metadata versioning, you must make sure that the configured user has the authority &quot;F_METADATA_MANAGE&quot;.</p>
</blockquote></td>
</tr>
<tr class="odd">
<td><p><strong>Remote server password</strong></p></td>
<td><p>The password of the DHIS2 user account on the remote server. The password will be stored encrypted.</p></td>
</tr>
<tr class="even">
<td><p><strong>Enable versioning for metadata sync</strong></p></td>
<td><p>Defines whether to create versions of metadata when you synchronize metadata between central and local instances.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Don't sync metadata if DHIS versions differ</strong></p></td>
<td><p>The metadata schema changes between versions of DHIS2 which could make different metadata versions incompatible.</p>
<p>When enabled, this option will not allow metadata synchronization to occur if the central and local instance(s) have different DHIS2 versions. This apply to metadata synchronization done both via the user interface and the API.</p>
<p>The only time it might be valuable to disable this option is when synchronizing basic entities, for example data elements, that have not changed across DHIS2 versions.</p></td>
</tr>
<tr class="even">
<td><p><strong>Best effort</strong></p></td>
<td><p>A type of metadata version which decides how the importer on local instance(s) will handle the metadata version.</p>
<p><em>Best effort</em> means that if the metadata import encounters missing references (for example missing data elements on a data element group import) it ignores the errors and continues the import.</p></td>
</tr>
<tr class="odd">
<td><p><strong>Atomic</strong></p></td>
<td><p>A type of metadata version which decides how the importer on local instance(s) will handle the metadata version.</p>
<p><em>Atomic</em> means all or nothing - the metadata import will fail if any of the references do not exist.</p></td>
</tr>
</tbody>
</table>

## OAuth2 clients

<!--DHIS2-SECTION-ID:system_oauth2_settings-->

You create, edit and delete OAuth2 clients in the **System Settings**
app.

1.  Open the **System Settings** apps and click **OAuth2 clients**.

2.  Click the add button.

3.  Enter **Name**, **Client ID** and **Client secret**.

4.  Select **Grant types**.

    <table>
    <colgroup>
    <col style="width: 50%" />
    <col style="width: 50%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th><p>Grant type</p></th>
    <th><p>Description</p></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><p><strong>Password</strong></p></td>
    <td><p>TBA</p></td>
    </tr>
    <tr class="even">
    <td><p><strong>Refresh token</strong></p></td>
    <td><p>TBA</p></td>
    </tr>
    <tr class="odd">
    <td><p><strong>Authorization code</strong></p></td>
    <td><p>TBA</p></td>
    </tr>
    </tbody>
    </table>

5.  Enter **Redirect URIs**. If you've multiple URIs, separate them with
    a line.
