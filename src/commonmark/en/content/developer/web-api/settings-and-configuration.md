# Settings and configuration

## System settings

<!--DHIS2-SECTION-ID:webapi_system_settings-->

You can manipulate system settings by interacting with the
*systemSettings* resource. A system setting is a simple key-value pair,
where both the key and the value are plain text strings. To save or
update a system setting you can make a *POST* request to the following URL:

    /api/33/systemSettings/my-key?value=my-val

Alternatively, you can submit the setting value as the request body,
where content type is set to "text/plain". As an example, you can use
curl like this:

```bash
curl "play.dhis2.org/demo/api/33/systemSettings/my-key" -d "My long value"
  -H "Content-Type: text/plain" -u admin:district
```

To set system settings in bulk you can send a JSON object with a
property and value for each system setting key-value pair using a POST request:

```json
{
  "keyApplicationNotification": "Welcome",
  "keyApplicationIntro": "DHIS2",
  "keyApplicationFooter": "Read more at dhis2.org"
}
```

Translations for translatable Setting keys can be set by specifying locale as
a query parameter and translated value which can be specified
either as a query param or withing the body payload. See an example URL:

    /api/33/systemSettings/<my-key>?locale=<my-locale>&value=<my-translated-value>

You should replace my-key with your real key and my-val with your real
value. To retrieve the value for a given key (in JSON or plain text)
you can make a *GET* request to the following URL:

    /api/33/systemSettings/my-key

Alternatively, you can specify the key as a query parameter:

    /api/33/systemSettings?key=my-key

You can retrieve specific system settings as JSON by repeating the key
query parameter:

```bash
curl "play.dhis2.org/demo/api/33/systemSettings?key=keyApplicationNotification&key=keyApplicationIntro"
  -u admin:district
```

You can retrieve all system settings with a GET request:

    /api/33/systemSettings

To retrieve a specific translation for a given translatable key you can specify
a locale as query param:

    /api/33/systemSettings/<my-key>?locale=<my-locale>

If present, the translation for the given locale is returned. Otherwise, a default
value is returned. If no locale is specified for the translatable key, the user default
UI locale is used to fetch the correct translation. If the given translation is not
present, again, the default value is returned.

The priority for translatable keys is the following:

    specified locale > user's default UI locale > defaut value

To delete a system setting, you can make a *DELETE* request to the URL
similar to the one used above for retrieval. If a translatable key is
used, all present translations will be deleted as well.

To delete only a specific translation of translatable key, the same URL
as for adding a translation should be used and the empty value should be
provided:

    /api/33/systemSettings/<my-key>?locale=<my-locale>&value=

The available system settings are listed below.

<table>
<caption>System settings</caption>
<colgroup>
<col style="width: 43%" />
<col style="width: 43%" />
<col style="width: 14%" />
</colgroup>
<thead>
<tr class="header">
<th>Key</th>
<th>Description</th>
<th>Translatable</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>keyUiLocale</td>
<td>Locale for the user interface</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyDbLocale</td>
<td>Locale for the database</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyAnalysisDisplayProperty</td>
<td>The property to display in analysis. Default: &quot;name&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyAnalysisDigitGroupSeparator</td>
<td>The separator used to separate digit groups</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyCurrentDomainType</td>
<td>Not yet in use</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyTrackerDashboardLayout</td>
<td>Used by tracker capture</td>
<td>No</td>
</tr>
<tr class="odd">
<td>applicationTitle</td>
<td>The application title. Default: &quot;DHIS2&quot;</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>keyApplicationIntro</td>
<td>The application introduction</td>
<td>Yes</td>
</tr>
<tr class="odd">
<td>keyApplicationNotification</td>
<td>Application notification</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>keyApplicationFooter</td>
<td>Application left footer</td>
<td>Yes</td>
</tr>
<tr class="odd">
<td>keyApplicationRightFooter</td>
<td>Application right footer</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>keyFlag</td>
<td>Application flag</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyFlagImage</td>
<td>Flag used in dashboard menu</td>
<td>No</td>
</tr>
<tr class="even">
<td>startModule</td>
<td>The startpage of the application. Default: &quot;dhis-web-dashboard-integration&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>factorDeviation</td>
<td>Data analysis standard deviation factor. Default: &quot;2d&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyEmailHostName</td>
<td>Email server hostname</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyEmailPort</td>
<td>Email server port</td>
<td>No</td>
<tr class="even">
<td>keyEmailTls</td>
<td>Use TLS. Default: &quot;true&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyEmailSender</td>
<td>Email sender</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyEmailUsername</td>
<td>Email server username</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyEmailPassword</td>
<td>Email server password</td>
<td>No</td>
</tr>
<tr class="even">
<td>minPasswordLength</td>
<td>Minimum length of password</td>
<td>No</td>
</tr>
<tr class="odd">
<td>maxPasswordLength</td>
<td>Maximum length of password</td>
<td>No</td>
</tr>
<tr class="even">
<td>keySmsSetting</td>
<td>SMS configuration</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyCacheStrategy</td>
<td>Cache strategy. Default: &quot;CACHE_6AM_TOMORROW&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyCacheability</td>
<td>PUBLIC or PRIVATE. Determines if proxy servers are allowed to cache data or not.</td>
<td>No</td>
</tr>
<tr class="odd">
<td>phoneNumberAreaCode</td>
<td>Phonenumber area code</td>
<td>No</td>
</tr>
<tr class="even">
<td>multiOrganisationUnitForms</td>
<td>Enable multi-organisation unit forms. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyConfig</td>
<td></td>
<td>No</td>
</tr>
<tr class="even">
<td>keyAccountRecovery</td>
<td>Enable user account recovery. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyLockMultipleFailedLogins</td>
<td>Enable locking access after multiple failed logins</td>
<td>No</td>
</tr>
<tr class="even">
<td>googleAnalyticsUA</td>
<td>Google Analytic UA key for tracking site-usage</td>
<td>No</td>
</tr>
<tr class="odd">
<td>credentialsExpires</td>
<td>Require user account password change. Default: &quot;0&quot; (Never)</td>
<td>No</td>
</tr>
<tr class="even">
<td>credentialsExpiryAlert</td>
<td>Enable alert when credentials are close to expiration date</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keySelfRegistrationNoRecaptcha</td>
<td>Do not require recaptcha for self registration. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>recaptchaSecret</td>
<td>Google API recaptcha secret. Default: dhis2 play instance API secret, but this will only works on you local instance and not in production.</td>
<td>No</td>
</tr>
<tr class="odd">
<td>recaptchaSite</td>
<td>Google API recaptcha site. Default: dhis2 play instance API site, but this will only works on you local instance and not in production.</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyCanGrantOwnUserAuthorityGroups</td>
<td>Allow users to grant own user roles. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keySqlViewMaxLimit</td>
<td>Max limit for SQL view</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyRespectMetaDataStartEndDatesInAnalyticsTableExport</td>
<td>When &quot;true&quot;, analytics will skip data not within category option's start and end dates. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keySkipDataTypeValidationInAnalyticsTableExport</td>
<td>Skips data type validation in analytics table export</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyCustomLoginPageLogo</td>
<td>Logo for custom login page</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyCustomTopMenuLogo</td>
<td>Logo for custom top menu</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyCacheAnalyticsDataYearThreshold</td>
<td>Analytics data older than this value (in years) will always be cached. &quot;0&quot; disabled this setting. Default: 0</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyCacheAnalyticsDataYearThreshold</td>
<td>Analytics data older than this value (in years) will always be cached. &quot;0&quot; disabled this setting. Default: 0</td>
<td>No</td>
</tr>
<tr class="even">
<td>analyticsFinancialYearStart</td>
<td>Set financial year start. Default: October</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyIgnoreAnalyticsApprovalYearThreshold</td>
<td>&quot;0&quot; check approval for all data. &quot;-1&quot; disable approval checking. &quot;1&quot; or higher checks approval for all data that is newer than &quot;1&quot; year.</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyAnalyticsMaxLimit</td>
<td>Maximum number of analytics recors. Default: &quot;50000&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyAnalyticsMaintenanceMode</td>
<td>Put analytics in maintenance mode. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyDatabaseServerCpus</td>
<td>Number of database server CPUs. Default: &quot;0&quot; (Automatic)</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyLastSuccessfulAnalyticsTablesRuntime</td>
<td>Keeps timestamp of last successful analytics tables run</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyLastSuccessfulLatestAnalyticsPartitionRuntime</td>
<td>Keeps timestamp of last successful latest analytics partition run</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyLastMonitoringRun</td>
<td>Keeps timestamp of last monitoring run</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyLastSuccessfulDataSynch</td>
<td>Keeps timestamp of last successful data values synchronization</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyLastSuccessfulEventsDataSynch</td>
<td>Keeps timestamp of last successful Event programs data synchronization</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyLastCompleteDataSetRegistrationSyncSuccess</td>
<td>Keeps timestamp of last successful completeness synchronization</td>
<td>No</td>
</tr>
<tr class="odd">
<td>syncSkipSyncForDataChangedBefore</td>
<td>Specifies timestamp used to skip synchronization of all the data changed before this point in time</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyLastSuccessfulAnalyticsTablesUpdate</td>
<td>Keeps timestamp of last successful analytics tables update</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyLastSuccessfulLatestAnalyticsPartitionUpdate</td>
<td>Keeps timestamp of last successful latest analytics partition update</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyLastSuccessfulResourceTablesUpdate</td>
<td>Keeps timestamp of last successful resource tables update</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyLastSuccessfulSystemMonitoringPush</td>
<td>Keeps timestamp of last successful system monitoring push</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyLastSuccessfulMonitoring</td>
<td>Keeps timestamp of last successful monitoring</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyNextAnalyticsTableUpdate</td>
<td>Keeps timestamp of next analytics table update</td>
<td>No</td>
</tr>
<tr class="even">
<td>helpPageLink</td>
<td>Link to help page. Default: &quot;<a href="http://dhis2.github.io/dhis2-docs/master/en/user/html/dhis2_user_manual_en.html">https://dhis2.github.io/dhis2-docs/master/en/user/html/dhis2_user_manual_en.html</a></td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyAcceptanceRequiredForApproval</td>
<td>Acceptance required before approval. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keySystemNotificationsEmail</td>
<td>Where to email system notifications</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyAnalysisRelativePeriod</td>
<td>Default relative period for analysis. Default: &quot;LAST_12_MONTHS&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyRequireAddToView</td>
<td>Require authority to add to view object lists. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyAllowObjectAssignment</td>
<td>Allow assigning object to related objects during add or update. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyUseCustomLogoFront</td>
<td>Enables the usage of a custom logo on the front page. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyUseCustomLogoBanner</td>
<td>Enables the usage of a custom banner on the website. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyDataImportStrictPeriods</td>
<td></td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyDataImportStrictPeriods</td>
<td>Require periods to match period type of data set. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyDataImportStrictDataElements</td>
<td>Require data elements to be part of data set. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyDataImportStrictCategoryOptionCombos</td>
<td>Require category option combos to match category combo of data element. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyDataImportStrictOrganisationUnits</td>
<td>Require organisation units to match assignment of data set. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyDataImportStrictAttributeOptionsCombos</td>
<td>Require attribute option combis to match category combo of data set. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyDataImportRequireCategoryOptionCombo</td>
<td>Require category option combo to be specified. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyDataImportRequireAttributeOptionCombo</td>
<td>Require attribute option combo to be specified. Default: &quot;false&quot;</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyCustomJs</td>
<td>Custom JavaScript to be used on the website</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyCustomCss</td>
<td>Custom CSS to be used on the website</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyCalendar</td>
<td>The calendar type. Default: &quot;iso8601&quot;.</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyDateFormat</td>
<td>The format in which dates should be displayed. Default: &quot;yyyy-MM-dd&quot;.</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyStyle</td>
<td>The style used on the DHIS2 webpages. Default: &quot;light_blue/light_blue.css&quot;.</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyRemoteInstanceUrl</td>
<td>Url used to connect to remote instance</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyRemoteInstanceUsername</td>
<td>Username used to connect to remote DHIS2 instance</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyRemoteInstancePassword</td>
<td>Password used to connect to remote DHIS2 instance</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyGoogleMapsApiKey</td>
<td>Google Maps API key</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyGoogleCloudApiKey</td>
<td>Google Cloud API key</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyLastMetaDataSyncSuccess</td>
<td>Keeps timestamp of last successful metadata synchronization	</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyVersionEnabled</td>
<td>Enables metadata versioning</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyMetadataFailedVersion</td>
<td>Keeps details about failed metadata version sync</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyMetadataLastFailedTime</td>
<td>Keeps timestamp of last metadata synchronization failure</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyLastSuccessfulScheduledProgramNotifications</td>
<td></td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyLastSuccessfulScheduledDataSetNotifications</td>
<td></td>
<td>No</td>
</tr>
<tr class="even">
<td>keyRemoteMetadataVersion</td>
<td>Details about metadata version of remote instance</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keySystemMetadataVersion</td>
<td>Details about metadata version of the system</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyStopMetadataSync</td>
<td>Flag to stop metadata synchronization</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyFileResourceRetentionStrategy</td>
<td>Determines how long file resources associated with deleted or updated values are kept. NONE, THREE_MONTHS, ONE_YEAR, or FOREVER.</td>
<td>No</td>
</tr>
<tr class="even">
<td>syncMaxRemoteServerAvailabilityCheckAttempts</td>
<td>Specifies how many times the availability of remote server will be checked before synchronization jobs fail.</td>
<td>No</td>
</tr>
<tr class="odd">
<td>syncMaxAttempts</td>
<td>Specifies max attempts for synchronization jobs</td>
<td>No</td>
</tr>
<tr class="even">
<td>syncDelayBetweenRemoteServerAvailabilityCheckAttempts</td>
<td>Delay between remote server availability checks</td>
<td>No</td>
</tr>
<tr class="odd">
<td>lastSuccessfulDataStatistics</td>
<td>Keeps timestamp of last successful data analytics</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyHideDailyPeriods</td>
<td>Not in use</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyHideWeeklyPeriods</td>
<td></td>
<td>No</td>
</tr>
<tr class="even">
<td>keyHideMonthlyPeriods</td>
<td></td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyHideBiMonthlyPeriods</td>
<td></td>
<td>No</td>
</tr>
<tr class="even">
<td>keyGatherAnalyticalObjectStatisticsInDashboardViews</td>
<td>Whether to gather analytical statistics on objects when they are viewed within a dashboard</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyCountPassiveDashboardViewsInUsageAnalytics</td>
<td>(Reserved for future use)</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyDashboardContextMenuItemSwitchViewType</td>
<td>Allow users to switch a dashboard favorite view type</td>
<td>Yes</td>
</tr>
<tr class="odd">
<td>keyDashboardContextMenuItemOpenInRelevantApp</td>
<td>Allow users to open a dashboard favorite in relevant app</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>keyDashboardContextMenuItemShowInterpretationsAndDetails</td>
<td>Allow users to show dashboard favorite interpretations and details</td>
<td>Yes</td>
</tr>
<tr class="odd">
<td>keyDashboardContextMenuItemViewFullscreen</td>
<td>Allow users to view dashboard favorite in fullscreen</td>
<td>Yes</td>
</tr>
</tbody>
</table>


## User settings

<!--DHIS2-SECTION-ID:webapi_user_settings-->

You can manipulate user settings by interacting with the *userSettings*
resource. A user setting is a simple key-value pair, where both the key
and the value are plain text strings. The user setting will be linked to
the user who is authenticated for the Web API request. To return a list
of all user settings, you can send a *GET* request to the following URL:

    /api/33/userSettings

User settings not set by the user, will fall back to the equivalent
system setting. To only return the values set explicitly by the user,
you can append ?useFallback=false to the above URL, like this:

    /api/33/userSettings?useFallback=false

To save or update a setting for the currently authenticated user you can
make a *POST* request to the following URL:

    /api/33/userSettings/my-key?value=my-val

You can specify the user for which to save the setting explicitly with
this syntax:

    /api/33/userSettings/my-key?user=username&value=my-val

Alternatively, you can submit the setting value as the request body,
where content type is set to "text/plain". As an example, you can use
curl like this:

```bash
curl "https://play.dhis2.org/demo/api/33/userSettings/my-key" -d "My long value"
  -H "Content-Type: text/plain" -u admin:district
```

As an example, to set the UI locale of the current user to French you
can use the following command.

```bash
curl "https://play.dhis2.org/demo/api/33/userSettings/keyUiLocale?value=fr"
  -X POST -u admin:district
```

You should replace my-key with your real key and my-val with your real
value. To retrieve the value for a given key in plain text you can make
a *GET* request to the following URL:

    /api/33/userSettings/my-key

To delete a user setting, you can make a *DELETE* request to the URL
similar to the one used above for retrieval.

The available system settings are listed below.

<table style="width:100%;">
<caption>User settings</caption>
<colgroup>
<col style="width: 21%" />
<col style="width: 28%" />
<col style="width: 49%" />
</colgroup>
<thead>
<tr class="header">
<th>Key</th>
<th>Options</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>keyStyle</td>
<td>light_blue/light_blue.css | green/green.css | vietnam/vietnam.css</td>
<td>User interface stylesheet.</td>
</tr>
<tr class="even">
<td>keyMessageEmailNotification</td>
<td>false | true</td>
<td>Whether to send email notifications.</td>
</tr>
<tr class="odd">
<td>keyMessageSmsNotification</td>
<td>false | true</td>
<td>Whether to send SMS notifications.</td>
</tr>
<tr class="even">
<td>keyUiLocale</td>
<td>Locale value</td>
<td>User interface locale.</td>
</tr>
<tr class="odd">
<td>keyDbLocale</td>
<td>Locale value</td>
<td>Database content locale.</td>
</tr>
<tr class="even">
<td>keyAnalysisDisplayProperty</td>
<td>name | shortName</td>
<td>Property to display for metadata in analysis apps.</td>
</tr>
<tr class="odd">
<td>keyCurrentDomainType</td>
<td>all | aggregate | tracker</td>
<td>Data element domain type to display in lists.</td>
</tr>
<tr class="even">
<td>keyAutoSaveCaseEntryForm</td>
<td>false | true</td>
<td>Save case entry forms periodically.</td>
</tr>
<tr class="odd">
<td>keyAutoSaveTrackedEntityForm</td>
<td>false | true</td>
<td>Save person registration forms periodically.</td>
</tr>
<tr class="even">
<td>keyAutoSaveDataEntryForm</td>
<td>false | true</td>
<td>Save aggregate data entry forms periodically.</td>
</tr>
<tr class="odd">
<td>keyTrackerDashboardLayout</td>
<td>false | true</td>
<td>Tracker dasboard layout.</td>
</tr>
</tbody>
</table>

## Configuration

<!--DHIS2-SECTION-ID:webapi_configuration-->

To access configuration you can interact with the *configuration*
resource. You can get XML and JSON responses through the *Accept* header
or by using the .json or .xml extensions. You can *GET* all properties
of the configuration from:

    /api/33/configuration

You can send *GET* and *POST* requests to the following specific
resources:

    GET /api/33/configuration/systemId
    
    GET POST DELETE /api/33/configuration/feedbackRecipients
    
    GET POST DELETE /api/33/configuration/offlineOrganisationUnitLevel
    
    GET POST /api/33/configuration/infrastructuralDataElements
    
    GET POST /api/33/configuration/infrastructuralIndicators
    
    GET POST /api/33/configuration/infrastructuralPeriodType
    
    GET POST DELETE /api/33/configuration/selfRegistrationRole
    
    GET POST DELETE /api/33/configuration/selfRegistrationOrgUnit

For the CORS whitelist configuration you can make a POST request with an
array of URLs to whitelist as payload using "application/json" as
content-type, for instance:

```json
["www.google.com", "www.dhis2.org", "www.who.int"]
```

    GET POST /api/33/configuration/corsWhitelist

For POST requests, the configuration value should be sent as the request
payload as text. The following table shows appropriate configuration
values for each property.

<table>
<caption>Configuration values</caption>
<colgroup>
<col style="width: 30%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th>Configuration property</th>
<th>Value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>feedbackRecipients</td>
<td>User group ID</td>
</tr>
<tr class="even">
<td>offlineOrganisationUnitLevel</td>
<td>Organisation unit level ID</td>
</tr>
<tr class="odd">
<td>infrastructuralDataElements</td>
<td>Data element group ID</td>
</tr>
<tr class="even">
<td>infrastructuralIndicators</td>
<td>Indicator group ID</td>
</tr>
<tr class="odd">
<td>infrastructuralPeriodType</td>
<td>Period type name (e.g. &quot;Monthly&quot;)</td>
</tr>
<tr class="even">
<td>selfRegistrationRole</td>
<td>User role ID</td>
</tr>
<tr class="odd">
<td>selfRegistrationOrgUnit</td>
<td>Organisation unit ID</td>
</tr>
<tr class="even">
<td>smtpPassword</td>
<td>SMTP email server password</td>
</tr>
<tr class="odd">
<td>remoteServerUrl</td>
<td>URL to remote server</td>
</tr>
<tr class="even">
<td>remoteServerUsername</td>
<td>Username for remote server authentication</td>
</tr>
<tr class="odd">
<td>remoteServerPassword</td>
<td>Password for remote server authentication</td>
</tr>
<tr class="even">
<td>corsWhitelist</td>
<td>JSON list of URLs</td>
</tr>
</tbody>
</table>

As an example, to set the feedback recipients user group you can invoke
the following curl command:

```bash
curl "localhost/api/33/configuration/feedbackRecipients" -d "wl5cDMuUhmF"
  -H "Content-Type:text/plain"-u admin:district
```

## Read-only configuration

<!--DHIS2-SECTION-ID:webapi_readonly_configuration_interface-->

To access all configuration settings and properties you can use the read-only configuration endpoint. This will provide read-only access to *UserSettings, SystemSettings and DHIS2 server configurations* You can get XML and JSON responses through the *Accept* header. You can *GET* all settings from:

    /api/33/configuration/settings

You can get filtered settings based on setting type:

    GET /api/33/configuration/settings/filter?type=USER_SETTING
    
    GET /api/33/configuration/settings/filter?type=CONFIGURATION

More than one type can be provided:

    GET /api/33/configuration/settings/filter?type=USER_SETTING&type=SYSTEM_SETTING

<table>
<caption>SettingType values</caption>
<colgroup>
<col style="width: 30%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>USER_SETTING</td>
<td>To get user settings</td>
</tr>
<tr class="even">
<td>SYSTEM_SETTING</td>
<td>To get system settings</td>
</tr>
<tr class="odd">
<td>CONFIGURATION</td>
<td>To get DHIS server settings</td>
</tr>
</tbody>
</table>

> **Note**
>
> Fields which are confidential will be provided in the output but without values.

## Tokens

<!--DHIS2-SECTION-ID:webapi_tokens-->

The *tokens* resource provides access tokens to various services.

### Google Service Account

<!--DHIS2-SECTION-ID:webapi_tokens_google_service_account-->

You can retrieve a Google service account OAuth 2.0 access token with a
GET request to the following resource.

    GET /api/tokens/google

The token will be valid for a certain amount of time, after which
another token must be requested from this resource. The response
contains a cache control header which matches the token expiration. The
response will contain the following properties in JSON format.

<table>
<caption>Token response</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>access_token</td>
<td>The OAuth 2.0 access token to be used when authentication against Google services.</td>
</tr>
<tr class="even">
<td>expires_in</td>
<td>The number of seconds until the access token expires, typically 3600 seconds (1 hour).</td>
</tr>
<tr class="odd">
<td>client_id</td>
<td>The Google service account client id.</td>
</tr>
</tbody>
</table>

This assumes that a Google service account has been set up and configured for DHIS2. Please consult the installation guide for more info.

## Static content

<!--DHIS2-SECTION-ID:webapi_static_content-->

The *staticContent* resource allows you to upload and retrieve custom
logos used in DHIS2. The resource lets the user upload a file with an
associated key, which can later be retrieved using the key. Only PNG
files are supported and can only be uploaded to the `logo_banner` and
`logo_front` keys.

    /api/33/staticContent

<table>
<caption>Static content keys</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>Key</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>logo_banner</td>
<td>Logo in the application top menu on the left side.</td>
</tr>
<tr class="even">
<td>logo_front</td>
<td>Logo on the login-page above the login form.</td>
</tr>
</tbody>
</table>

To upload a file, send the file with a *POST* request to:

    POST /api/33/staticContent/<key>

Example request to upload logo.png to the `logo_front` key:

```bash
curl -F "file=@logo.png;type=image/png" "https://play.dhis2.org/demo/api/33/staticContent/logo_front"
  -X POST -H "Content-Type: multipart/form-data" -u admin:district
```

Uploading multiple files with the same key will overwrite the existing
file. This way, retrieving a file for any given key will only return the
latest file uploaded.

To retrieve a logo, you can *GET* the following:

    GET /api/33/staticContent/<key>

Example of requests to retrieve the file stored for `logo_front`:

* Adding "Accept: text/html" to the HTTP header.*__ In this case, the endpoint will return a default image if nothing is defined. Will return an image stream when a custom or default image is found.

```bash
curl "https://play.dhis2.org/demo/api/33/staticContent/logo_front"
  -H "Accept: text/html" -L -u admin:district
```

* Adding "Accept: application/json" to the HTTP header.*__ With this parameter set, the endpoint will never return a default image if the custom logo is not found. Instead, an error message will be returned. When the custom image is found this endpoint will return a JSON response containing the path/URL to the respective image.

```bash
curl "https://play.dhis2.org/demo/api/33/staticContent/logo_front"
  -H "Accept: application/json" -L -u admin:district
```

Success and error messages will look like this:

```json
{
  "images": {
    "png": "http://localhost:8080/dhis/api/staticContent/logo_front"
  }
}
```

```json
{
  "httpStatus": "Not Found",
  "httpStatusCode": 404,
  "status": "ERROR",
  "message": "No custom file found."
}
```

To use custom logos, you need to enable the corresponding system
settings by setting it to *true*. If the corresponding setting is false,
the default logo will be served.

## UI customization

<!--DHIS2-SECTION-ID:webapi_ui_customization-->

To customize the UI of the DHIS2 application you can insert custom
JavaScript and CSS styles through the *files* resource.

```
POST GET DELETE /api/33/files/script
POST GET DELETE /api/33/files/style
```

The JavaScript and CSS content inserted through this resource will be loaded by the
DHIS2 web application. This can be particularly useful in certain situations:

  - Overriding the CSS styles of the DHIS2 application, such as the
    login page or main page.

  - Defining JavaScript functions which are common to several custom
    data entry forms and HTML-based reports.

  - Including CSS styles which are used in custom data entry forms and
    HTML-based reports.

### Javascript

<!--DHIS2-SECTION-ID:webapi_customization_javascript-->

To insert Javascript from a file called *script.js* you can interact
with the *files/script* resource with a POST request:

```bash
curl --data-binary @script.js "localhost/api/33/files/script"
  -H "Content-Type:application/javascript" -u admin:district
```

Note that we use the `--data-binary` option to preserve formatting of the
file content. You can fetch the JavaScript content with a GET request:

    /api/33/files/script

To remove the JavaScript content you can use a DELETE request.

### CSS

<!--DHIS2-SECTION-ID:webapi_customization_css-->

To insert CSS from a file called *style.css* you can interact with the
*files/style* resource with a POST-request:

```bash
curl --data-binary @style.css "localhost/api/33/files/style"
  -H "Content-Type:text/css" -u admin:district
```

You can fetch the CSS content with a GET-request:

    /api/33/files/style

To remove the JavaScript content you can use a DELETE request.



