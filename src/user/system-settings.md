# System settings { #settings } 

## General settings { #system_general_settings } 



Table: General settings

| Setting | Description |
|---|---|
| **Maximum number of analytics records** | Increase this number to provide more records from the analytics.<br> <br>The default value is 50,000.<br>      <br>    **Warning**<br>     <br>    Use the setting **Unlimited** carefully, it might result in a very high load on your server. |
| **Maximum number of SQL view records** | Set the maximum number of records in a SQL view.<br> <br>The default value is Unlimited. |
| **Cache strategy** | Decides for how long reports analytics responses should be cached.<br> <br>If you use the scheduled, nightly analytics update, you may want to select **Cache until 6 AM tomorrow**. This is because data in reports change at that time, and you can safely cache data up to the moment when the analytics tables are updated.<br> <br>If you are loading data continuously into the analytics tables, select **No cache**.<br> <br>For other cases select the amount of time you want the data to be cached. |
| **Infrastructural indicators** | Defines an indicator group where the member indicators should describe data about the organisation units' infrastructure.<br> <br>You can view the infrastructural data in the **GIS** app: right-click a facility and click **Show information**. |
| **Infrastructural data elements** | Defines a data element group where the member data elements should describe data about the organisation units' infrastructure.<br> <br>Infrastructural data elements can be population, doctors, beds, Internet connectivity and climate.<br> <br>You can view the infrastructural data in the **GIS** app: right-click a facility and click **Show information**. |
| **Infrastructural period type** | Sets the frequency for which the data elements in the infrastructural data elements group are captured.<br> <br>This will typically be yearly. When viewing the infrastructural data you will be able to select the time period of the data source.<br> <br>You can view the infrastructural data in the **GIS** app: right-click a facility and click **Show information**. |
| **Default relative period for analysis** | Setting this value will determine which relative period is selected as the default in the analytics apps. |
| **Feedback recipients** | Defines a user group where the members will receive all messages sent via the feedback function in the **Dashboard** app.<br> <br>This will typically be members of the super user team who are able to support and answer questions coming from end-users. |
| **Max offline organisation unit levels** | Defines how many levels in the organisation unit hierarchy will be available offline in the organisation unit tree widget.<br> <br>Under normal circumstances you can leave this on the lowest level, which is default is the default setting.<br> <br>It can be useful to set it to a higher level to reduce initial load time in cases where you have a large number of organisation units, typically more than 30 000. |
| **Data analysis std dev factor** | Sets the number of standard deviations used in the outlier analysis performed on the captured data in the **Data Entry** app.<br> <br>The default value is 2. A high value will catch less outlier values than a low value. |
| **Phone number area code** | The area code for the area in which your deployment is located.<br> <br>Used for sending and receiving SMS. Typically, this is a country code.<br> <br>*+260* (country code for Zambia) |
| **Enable multi-organisation unit forms** | Enables support to enter data forms for multiple organisation units at the same time in the **Data Entry** app.<br> <br>If you've enabled this setting, you can in the **Data Entry** app, click on the parent organisation unit for the children that you want to enter data for, and the data set list will include data sets that are assigned to the children of that parent. |
| **Acceptance required before approval** | When this setting is selected, acceptance of data will be required first before submission to the next approval level is possible. |
| **Gather analytical object statistics in dashboard views** | Gather usage analytics data when analytical objects (e.g., maps, charts, etc.) are viewed within a dashboard. Without this setting, analytics data on the objects  is gathered only when the objects are viewed outside of a dashboard. |
| **Include passive dashboard views in usage analytics statistics** | Gather usage analytics data on the first dashboard shown when the Dashboard app is launched (otherwise only explicit dashboard selections are counted). |

## Analytics settings { #system_analytics_settings } 



Table: Analytics settings

| Setting | Description |
|---|---|
| **Default relative period for analysis** | Defines the relative period to use by default in analytics app: **Data Visualizer**, **Event Reports**, **Event Visualizer**, **GIS** and **Pivot Table** apps. The relative period will be automatically selected when you open these apps.<br> <br>Recommended setting: the most commonly used relative period among your users. |
| **Hide daily periods** | Hide daily periods in the analysis tools |
| **Hide weekly periods** | Hide weekly periods in the analysis tools |
| **Hide monthly periods** | Hide monthly periods in the analysis tools |
| **Hide bimonthly periods** | Hide bimonthly periods in the analysis tools |
| **Financial year relative start month** | Defines which month (April, July or October) the the relative financial year in the analytics apps should begin on. |
| **Cacheability** | Sets whether analytics data responses should be served with public or private visibility.<br> <br>**Private**: Any node or server between the DHIS2 server and the end user which has the ability to cache can NOT cache the web page. This is useful if the page served can or do contain sensitive information. This means that each time you want a web page, either you get a new page from the DHIS2 server, or the DHIS2 server caches the page. No other server than the DHIS2 server are allowed to cache the page.<br> <br>**Public**: Any node or server between the DHIS2 server and the end user which has the ability to cache can cache the web page. This relives the traffic to the DHIS2 server and potentially speeds up the subsequent page loading speed. |
| **Analytics cache mode** | Support two different modes:<br> <br>**Progressive**: this relates to the new progressive caching feature for analytics. When enabled, it OVERRIDES the global caching strategy for analytics requests. This mode will trigger HTTP and data layer caching for all analytics requests. When enabling this mode, the *caching factor* is MANDATORY.<br> <br>**Fixed**: the requests will be cached based on the period of time defined in *cache strategy.* |
| **Caching factor** | Select a value for the caching factor. This field is only available when the analytics cache mode has been set to *progressive*.<br> <br>It shows a list of integers where each integer represents an absolute caching factor. This integer will be used internally to calculate the final expiration time for each analytics request. Higher the caching factor, for longer the request will be cached. |
| **Max number of years to hide unapproved data in analytics** | Sets whether and for how long back in time analytics should respect the approval level of the data. Typically, data which is several years old would be considered to be approved by default. In order to speed up analytics requests, you can choose to ignore the actual approval level of historical data.<br> <br>**Never check approval**: no data will be hidden, irrespective of its data approval status.<br> <br>**Check approval for all data**: approval status will always be checked.<br> <br>Other options, for example **Last 3 years**: approval status will be checked for data which is newer than 3 years old; older data will not be checked. |
| **Threshold for analytics data caching** | Sets whether to enable caching data older than the specified number of years only.<br> <br>This allows for returning the most recent data directly with no caching, while serving cached version of older data for performance concerns. |
| **Respect category option start and end date in analytics table export** | This setting controls whether analytics should filter data which is associated with a category option with a start and end date, but which is not associated with a period within the category options interval of validity. |
| **Put analytics in maintenance mode** | Places the analytics and web API of DHIS2 in maintenance mode. This means that "503 Service Unavailable" will be returned for all requests. <br>This is useful when you need to perform maintenance on the server, for example rebuilding indexes while the server is running in production, in order to reduce load and more efficiently carry out the maintenance. |
| **Allow users to switch dashboard favorite view type** | Allows users to switch dashboard favorites' view between charts, pivot tables and maps, using the dashboard item menu. |
| **Allow users to open dashboard favorite in relevant app** | Allows users to open dashboard items in the app for that type of item, using the dashboard item menu. |
| **Allow users to show dashboard favorite interpretations and details** | Allows users to see dashboard favorites' interpretations and details, using the dashboard item menu. |
| **Allow users to view dashboard favorite in fullscreen** | Allows users to view dashboard favorites in fullscreen, using the dashboard item menu. |

## Server settings { #system_server_settings } 



Table: Server settings

| Setting | Description |
|---|---|
| **Number of database server CPUs** | Sets the number of CPU cores of your database server.<br> <br>This allows the system to perform optimally when the database is hosted on a different server than the application server, since analytics in DHIS2 scales linearly with the number of available cores. |
| **System notifications email address** | Defines the email address which will receive system notifications.<br> <br>Notifications about failures in processes such as analytics table generation will be sent here. This is useful for application monitoring. |
| **Google Analytics (Universal Analytics) key** | Sets the Google UA key to provide usage analytics for your DHIS2 instance through the Google Analytics platform. It should be noted that currently, not all apps in DHIS2 support Google Analytics, so certain activity of your users may not appear in this platform.<br> <br>You can read more about Google Analytics at [http://google.com/analytics](http://google.com/analytics). |
| **Google Maps API key** | Defines the API key for the Google Maps API. This is used to display maps within DHIS2. |
| **Bing Maps API key** | Defines the API key for the Bing Maps API. This is used to display maps within DHIS2. |

## Appearance settings { #system_appearance_settings } 



Table: Appearance settings

| Setting | Description |
|---|---|
| **Select language** | Sets the language for which you can then enter translations of the following settings:<br>       * **Application introduction**<br> * **Application title**<br> * **Application notification**<br> * **Application left-side footer**<br> * **Application right-side footer**      <br>    **Note**     <br>    Before each of these settings can accept a translated value, they first need to have a default/fallback value. This value can be set by selecting *System default (fallback)* in this dropdown. |
| **Application title** | Sets the application title on the top menu. |
| **Application introduction** | Sets an introduction of the system which will be visible on the top-left part of the login page. |
| **Application notification** | Sets a notification which will be visible on the front page under the login area. |
| **Application left-side footer** | Sets a text in the left-side footer area of the login page. |
| **Application right-side footer** | Sets a text in the right-side footer area of the login page. |
| **Style** | Sets the style (look-and-feel) of the system.<br> <br>The user can override this setting in the **Settings** app: **User settings** \> **Style**.<br>      <br>    **Note**<br>     <br>    Due to technical reasons, it's not possible to change the color of the newest version of the header bar. The apps with the newest header bar will retain the blue header bar. |
| **Start page** | Sets the page or app which the user will be redirected to after log in.<br> <br>Recommended setting: the **Dashboard** app. |
| **Help page link** | Defines the URL which users will see when they click **Profile** \>**Help**. |
| **Flag** | Sets the flag which is displayed in the left menu of the **Dashboard** app. |
| **Interface language** | Sets the language used in the user interface.<br> <br>The user can override this setting in the **Settings** app: **User settings** \> **Interface language**. |
| **Database language** | Sets the language used in the database.<br> <br>The user can override this setting in the **Settings** app: **User settings** \> **Database language**. |
| **Property to display in analysis modules** | Sets whether you want to display the metadata objects' names or short names in the analytics apps: **Data Visualizer**, **Event Reports**, **Event Visualizer**, **GIS** and **Pivot Table** apps.<br> <br>The user can override this setting in the **Settings** app: **User settings** \> **Property to display in analysis modules**. |
| **Default digit group separator to display in analysis modules** | Sets the default digit group separator in the analytics apps: **Data Visualizer**, **Event Reports**, **Event Visualizer**, **GIS** and **Pivot Table** apps. |
| **Require authority to add to view object lists** | If you select this option, you'll hide menu and index page items and links to lists of objects if the current user doesn't have the authority to create the type of objects (privately or publicly). |
| **Custom login page logo** | Select this option and upload an image to add your logo to the login page. |
| **Custom top menu logo** | Select this option and upload an image to add your logo to the left in the top menu. |

## Email settings { #system_email_settings } 



Table: Email settings

| Setting | Description |
|---|---|
| **Host name** | Sets the host name of the SMTP server.<br> <br>When you use Google SMTP services, the host name should be *smtp.gmail.com*. |
| **Port** | Sets the port to connect to the SMTP server. |
| **User name** | The user name of the user account with the SMTP server.<br> <br>mail@dhis2.org |
| **Password** | The password of the user account with the SMTP server. |
| **TLS** | Select this option if the SMPT server requires TLS for connections. |
| **Email sender** | The email address to use as sender when sending out emails. |
| **Send me a test email** | Sends a test email to the current user logged into DHIS2. |

## Access settings { #system_access_settings } 



Table: Access settings

| Setting | Description |
|---|---|
| **Self registration account user role** | Defines which user role should be given to self-registered user accounts.<br> <br>To enable self-registration of users: select any user role from the list. A link to the self-registration form will be displayed on the login page.<br>      <br>    **Note**<br>     <br>    To enable self-registration, you must also select a **Self registration account organisation unit**.<br>  <br>To disable self-registration of users: select **Disable self registration**. |
| **Self registration account organisation unit** | Defines which organisation unit should be associated with self-registered users.<br>      <br>    **Note**<br>     <br>    To enable self-registration, you must also select a **Self registration account user role**. |
| **Do not require reCAPTCHA for self registration** | Defines whether you want to use reCAPTCHA for user self-registration. This is enabled by default. |
| **Enable user account recovery** | Defines whether users can restore their own passwords.<br> <br>When this setting is enabled, a link to the account recovery form will be displayed on the front page.<br>      <br>    **Note**<br>     <br>    User account recovery requires that you have configured email settings (SMTP). |
| **Lock user account temporarily after multiple failed login attempts** | Defines whether the system should lock user accounts after five successive failed login attempts over a timespan of 15 minutes.<br> <br>The account will be locked for 15 minutes, then the user can attempt to log in again. |
| **Allow users to grant own user roles** | Defines whether users can grant user roles which they have themselves to others when creating new users. |
| **Allow assigning object to related objects during add or update** | Defines whether users should be allowed to assign an object to a related object when they create or edit metadata objects.<br> <br>You can allow users to assign an organisation unit to data sets and organisation unit group sets when creating or editing the organisation unit. |
| **Require user account password change** | Defines whether users should be forced to change their passwords every 3, 6 or 12 months.<br> <br>If you don't want to force users to change password, select **Never**. |
| **Enable password expiry alerts** | When set, users will receive a notification when their password is about to expire. |
| **Minimum characters in password** | Defines the minimum number of characters users must have in their passwords.<br> <br>You can select 8 (default), 10, 12 or 14. |
| **CORS whitelist** | Whitelists a set of URLs which can access the DHIS2 API from another domain. Each URL should be entered on separate lines. Cross-origin resource sharing (CORS) is a mechanism that allows restricted resources (e.g. javascript files) on a web page to be requested from another domain outside the domain from which the first resource was served. |

## Calendar settings { #system_calendar_settings } 



Table: Calendar settings

| Setting | Description |
|---|---|
| **Calendar** | Defines which calendar the system will use.<br> <br>The system supports the following calendars: Coptic, Ethiopian, Gregorian, Islamic (Lunar Hijri), ISO 8601, Julian, Nepali, Persian (Solar Hijri) and Thai.<br>      <br>    **Note**<br>     <br>    This is a system wide setting. It is not possible to have multiple calendars within a single DHIS2 instance. |
| **Date format** | Defines which date format the system will use. |

## Data import settings { #system_data_import_settings } 

The data import settings apply to extra controls which can be enabled to
validate aggregate data which is imported through the web API. They
provide optional constraints on what should be considered a conflict
during import. The constraints are applied to each individual data value
in the import.



Table: Data import settings

| Setting | Description |
|---|---|
| **Require periods to match period type of data set** | Require period of data value to be of the same period type as the data sets for which the data element of data value is assigned to. |
| **Require category option combos to match category combo of data element** | Require category option combination of data value to be part of the category combination of the data element of the data value. |
| **Require organisation units to match assignment of data set** | Require organisation unit of data value to be assigned to one or more of the data sets which the data element of data value is assigned to. |
| **Require attribute option combos to match category combo of data set** | Require attribute option combination of data value to be part of the category combination of the data set which the data element of data value is assigned to. |
| **Require category option combo to be specified** | Require category option combination of data value to be specified.<br> <br>By default it will fall back to default category option combination if not specified. |
| **Require attribute option combo to be specified** | Require attribute option combination of data value to be specified.<br> <br>By default it will fall back to default attribute option combination if not specified. |

## Synchronization settings

The following settings are used for both data and metadata
synchronization.

> **Note**
>
> For more information about how you configure metadata synchronization,
> refer to [Configure metadata
> synchronizing](https://docs.dhis2.org/master/en/user/html/metadata_sync.html)



Table: Synchronization settings

| Setting | Description |
|---|---|
| **Remote server URL** | Defines the URL of the remote server running DHIS2 to upload data values to.<br> <br>It is recommended to use of SSL/HTTPS since user name and password are sent with the request (using basic authentication).<br> <br>The system will attempt to synchronize data once every minute.<br> <br>The system will use this setting for metadata synchronization too.<br>      <br>    **Note**<br>     <br>    To enable data and metadata synchronization, you must also enable jobs for **Data synchronization** and **Metadata synchronization** in the **Scheduler** app. |
| **Remote server user name** | The user name of the DHIS2 user account on the remote server to use for data synchronization.<br>      <br>    **Note**<br>     <br>    If you've enabled metadata versioning, you must make sure that the configured user has the authority "F_METADATA_MANAGE". |
| **Remote server password** | The password of the DHIS2 user account on the remote server. The password will be stored encrypted. |
| **Enable versioning for metadata sync** | Defines whether to create versions of metadata when you synchronize metadata between central and local instances. |
| **Don't sync metadata if DHIS versions differ** | The metadata schema changes between versions of DHIS2 which could make different metadata versions incompatible.<br> <br>When enabled, this option will not allow metadata synchronization to occur if the central and local instance(s) have different DHIS2 versions. This apply to metadata synchronization done both via the user interface and the API.<br> <br>The only time it might be valuable to disable this option is when synchronizing basic entities, for example data elements, that have not changed across DHIS2 versions. |
| **Best effort** | A type of metadata version which decides how the importer on local instance(s) will handle the metadata version.<br> <br>*Best effort* means that if the metadata import encounters missing references (for example missing data elements on a data element group import) it ignores the errors and continues the import. |
| **Atomic** | A type of metadata version which decides how the importer on local instance(s) will handle the metadata version.<br> <br>*Atomic* means all or nothing - the metadata import will fail if any of the references do not exist. |

## OAuth2 clients { #system_oauth2_settings } 

You create, edit and delete OAuth2 clients in the **System Settings**
app.

1.  Open the **System Settings** apps and click **OAuth2 clients**.

2.  Click the add button.

3.  Enter **Name**, **Client ID** and **Client secret**.

4.  Select **Grant types**.


    | Grant type | Description |
    |---|---|
    | **Password** | TBA |
    | **Refresh token** | TBA |
    | **Authorization code** | TBA |

5.  Enter **Redirect URIs**. If you've multiple URIs, separate them with
    a line.
