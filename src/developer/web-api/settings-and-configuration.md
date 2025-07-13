# Settings and configuration

## System settings { #webapi_system_settings } 

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

Table: System settings

| Key | Description | Translatable |
|---|---|---|
| keyUiLocale | Locale for the user interface | No |
| keyDbLocale | Locale for the database | No |
| keyAnalysisDisplayProperty | The property to display in analysis. Default: "name" | No |
| keyAnalysisDigitGroupSeparator | The separator used to separate digit groups | No |
| keyCurrentDomainType | Not yet in use | No |
| keyTrackerDashboardLayout | Used by tracker capture | No |
| applicationTitle | The application title. Default: "DHIS2" | Yes |
| keyApplicationIntro | The application introduction | Yes |
| keyApplicationNotification | Application notification | Yes |
| keyApplicationFooter | Application left footer | Yes |
| keyApplicationRightFooter | Application right footer | Yes |
| keyFlag | Application flag | No |
| keyFlagImage | Flag used in dashboard menu | No |
| startModule | The startpage of the application. Default: "dhis-web-dashboard-integration" | No |
| startModuleEnableLightweight | The starting page app to render a light-weight landing page. Default: "false" | No |
| factorDeviation | Data analysis standard deviation factor. Default: "2d" | No |
| keyEmailHostName | Email server hostname | No |
| keyEmailPort | Email server port | No |
| keyEmailTls | Use TLS. Default: "true" | No |
| keyEmailSender | Email sender | No |
| keyEmailUsername | Email server username | No |
| keyEmailPassword | Email server password | No |
| minPasswordLength | Minimum length of password | No |
| maxPasswordLength | Maximum length of password | No |
| keySmsSetting | SMS configuration | No |
| keyCacheStrategy | Cache strategy. Default: "CACHE_6AM_TOMORROW" | No |
| keyCacheability | PUBLIC or PRIVATE. Determines if proxy servers are allowed to cache data or not. | No |
| phoneNumberAreaCode | Phonenumber area code | No |
| multiOrganisationUnitForms | Enable multi-organisation unit forms. Default: "false" | No |
| keyConfig || No |
| keyAccountRecovery | Enable user account recovery. Default: "false" | No |
| keyLockMultipleFailedLogins | Enable locking access after multiple failed logins | No |
| googleAnalyticsUA | Google Analytic UA key for tracking site-usage | No |
| credentialsExpires | Require user account password change. Default: "0" (Never) | No |
| credentialsExpiryAlert | Enable alert when credentials are close to expiration date | No |
| credentialsExpiresReminderInDays | Number of days the credential expiry alert should be send in advance of the actual expiry. Default: 28 | No |
| accountExpiryAlert | Send an alert email to users whose account is about to expire due to expiry date being set. Default: "false" | No |
| accountExpiresInDays | Number of days the account expiry alert should be send in advance of the actual expiry. Default: 7 | No |
| keySelfRegistrationNoRecaptcha | Do not require recaptcha for self registration. Default: "false" | No |
| recaptchaSecret | Google API recaptcha secret. Default: dhis2 play instance API secret, but this will only works on you local instance and not in production. | No |
| recaptchaSite | Google API recaptcha site. Default: dhis2 play instance API site, but this will only works on you local instance and not in production. | No |
| keyCanGrantOwnUserAuthorityGroups | Allow users to grant own user roles. Default: "false" | No |
| keySqlViewMaxLimit | Max limit for SQL view | No |
| keyRespectMetaDataStartEndDatesInAnalyticsTableExport | When "true", analytics will skip data not within category option's start and end dates. Default: "false" | No |
| keySkipDataTypeValidationInAnalyticsTableExport | Skips data type validation in analytics table export | No |
| keyCustomLoginPageLogo | Logo for custom login page | No |
| keyCustomTopMenuLogo | Logo for custom top menu | No |
| keyCacheAnalyticsDataYearThreshold | Analytics data older than this value (in years) will always be cached. "0" disabled this setting. Default: 0 | No |
| analyticsFinancialYearStart | Set financial year start. Default: October | No |
| keyIgnoreAnalyticsApprovalYearThreshold | "0" check approval for all data. "-1" disable approval checking. "1" or higher checks approval for all data that is newer than "1" year. | No |
| keyAnalyticsMaxLimit | Maximum number of analytics records. Default: "50000" | No |
| keyAnalyticsPeriodYearsOffset | Defines the years' offset to be used in the analytics export process. If the year of a respective date is out of the offset the system sends back a warning message during the process. At this point, the period generation step is skipped. ie.: suppose the system user sets the offset value to `5`, and we are in the year 2023. It means that analytics will accept exporting dates from 2018 (inclusive) to 2028 (inclusive). Which translates to: [2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028]. NOTE: The offset will have a significant influence on resource usage. Higher values will trigger higher usage of memory RAM/HEAP and CPU. Setting negative numbers to this key will disable any kind of validation (which means no warnings) and the internal range of years will be used (1970 to current year plus 10) Default: 22 | No |
| keyDatabaseServerCpus | Number of database server CPUs. Default: "0" (Automatic) | No |
| keyLastSuccessfulAnalyticsTablesRuntime | Keeps timestamp of last successful analytics tables run | No |
| keyLastSuccessfulLatestAnalyticsPartitionRuntime | Keeps timestamp of last successful latest analytics partition run | No |
| keyLastMonitoringRun | Keeps timestamp of last monitoring run | No |
| keyLastSuccessfulDataSynch | Keeps timestamp of last successful data values synchronization | No |
| keyLastSuccessfulEventsDataSynch | Keeps timestamp of last successful Event programs data synchronization | No |
| keyLastCompleteDataSetRegistrationSyncSuccess | Keeps timestamp of last successful completeness synchronization | No |
| syncSkipSyncForDataChangedBefore | Specifies timestamp used to skip synchronization of all the data changed before this point in time | No |
| keyLastSuccessfulAnalyticsTablesUpdate | Keeps timestamp of last successful analytics tables update | No |
| keyLastSuccessfulLatestAnalyticsPartitionUpdate | Keeps timestamp of last successful latest analytics partition update | No |
| keyLastSuccessfulResourceTablesUpdate | Keeps timestamp of last successful resource tables update | No |
| keyLastSuccessfulSystemMonitoringPush | Keeps timestamp of last successful system monitoring push | No |
| keyLastSuccessfulMonitoring | Keeps timestamp of last successful monitoring | No |
| keyNextAnalyticsTableUpdate | Keeps timestamp of next analytics table update | No |
| helpPageLink | Link to help page. Default: "[https://dhis2.github.io/dhis2-docs/master/en/user/html/dhis2_user_manual_en.html](http://dhis2.github.io/dhis2-docs/master/en/user/html/dhis2_user_manual_en.html) | No |
| keyAcceptanceRequiredForApproval | Acceptance required before approval. Default: "false" | No |
| keySystemNotificationsEmail | Where to email system notifications | No |
| keyAnalysisRelativePeriod | Default relative period for analysis. Default: "LAST_12_MONTHS" | No |
| keyRequireAddToView | Require authority to add to view object lists. Default: "false" | No |
| keyAllowObjectAssignment | Allow assigning object to related objects during add or update. Default: "false" | No |
| keyUseCustomLogoFront | Enables the usage of a custom logo on the front page. Default: "false" | No |
| keyUseCustomLogoBanner | Enables the usage of a custom banner on the website. Default: "false" | No |
| keyDataImportStrictPeriods || No |
| keyDataImportStrictPeriods | Require periods to match period type of data set. Default: "false" | No |
| keyDataImportStrictDataElements | Require data elements to be part of data set. Default: "false" | No |
| keyDataImportStrictCategoryOptionCombos | Require category option combos to match category combo of data element. Default: "false" | No |
| keyDataImportStrictOrganisationUnits | Require organisation units to match assignment of data set. Default: "false" | No |
| keyDataImportStrictAttributeOptionsCombos | Require attribute option combis to match category combo of data set. Default: "false" | No |
| keyDataImportStrictDataSetApproval | true: If an already approved dataset exists for a given data value entry is not permitted; false: If a not yet approved dataset exists for a given data value entry is permitted. Default: "true" | No |
| keyDataImportStrictDataSetLocking | true: If a dataset exists for which entry expired without lock exception for a given data value entry is not permitted; false: If a dataset exists for which entry is not expired or a lock exception applies for a given data value entry is permitted. Default: "true" | No |
| keyDataImportStrictDataSetInputPeriods | true: If a dataset exists for which the input period is closed for a given data value entry is not permitted; false: If a dataset exists for which data the input period is open for a given data value entry is permitted. Default: "true" | No |
| keyDataImportRequireCategoryOptionCombo | Require category option combo to be specified. Default: "false" | No |
| keyDataImportRequireAttributeOptionCombo | Require attribute option combo to be specified. Default: "false" | No |
| keyCustomJs | Custom JavaScript to be used on the website | No |
| keyCustomCss | Custom CSS to be used on the website | No |
| keyCalendar | The calendar type. Default: "iso8601". | No |
| keyDateFormat | The format in which dates should be displayed. Default: "yyyy-MM-dd". | No |
| keyStyle | The style used on the DHIS2 webpages. Default: "light_blue/light_blue.css". | No |
| keyRemoteInstanceUrl | Url used to connect to remote instance | No |
| keyRemoteInstanceUsername | Username used to connect to remote DHIS2 instance | No |
| keyRemoteInstancePassword | Password used to connect to remote DHIS2 instance | No |
| keyGoogleMapsApiKey | Google Maps API key | No |
| keyGoogleCloudApiKey | Google Cloud API key | No |
| keyLastMetaDataSyncSuccess | Keeps timestamp of last successful metadata synchronization | No |
| keyVersionEnabled | Enables metadata versioning | No |
| keyMetadataFailedVersion | Keeps details about failed metadata version sync | No |
| keyMetadataLastFailedTime | Keeps timestamp of last metadata synchronization failure | No |
| keyLastSuccessfulScheduledProgramNotifications || No |
| keyLastSuccessfulScheduledDataSetNotifications || No |
| keyRemoteMetadataVersion | Details about metadata version of remote instance | No |
| keySystemMetadataVersion | Details about metadata version of the system | No |
| keyStopMetadataSync | Flag to stop metadata synchronization | No |
| keyFileResourceRetentionStrategy | Determines how long file resources associated with deleted or updated values are kept. NONE, THREE_MONTHS, ONE_YEAR, or FOREVER. | No |
| syncMaxRemoteServerAvailabilityCheckAttempts | Specifies how many times the availability of remote server will be checked before synchronization jobs fail. | No |
| syncMaxAttempts | Specifies max attempts for synchronization jobs | No |
| syncDelayBetweenRemoteServerAvailabilityCheckAttempts | Delay between remote server availability checks | No |
| lastSuccessfulDataStatistics | Keeps timestamp of last successful data analytics | No |
| keyHideDailyPeriods | Not in use | No |
| keyHideWeeklyPeriods || No |
| keyHideBiWeeklyPeriods | Boolean flag used to hide/show bi-weekly periods | No |
| keyHideMonthlyPeriods || No |
| keyHideBiMonthlyPeriods || No |
| keyGatherAnalyticalObjectStatisticsInDashboardViews | Whether to gather analytical statistics on objects when they are viewed within a dashboard | No |
| keyCountPassiveDashboardViewsInUsageAnalytics | Counts "passive" dashboard views (not selecting a particular dashboard) in usage analytics | No |
| keyDashboardContextMenuItemSwitchViewType | Allow users to switch dashboard favorites' view type | Yes |
| keyDashboardContextMenuItemOpenInRelevantApp | Allow users to open dashboard favorites in relevant apps | Yes |
| keyDashboardContextMenuItemShowInterpretationsAndDetails | Allow users to show dashboard favorites' interpretations and details | Yes |
| keyDashboardContextMenuItemViewFullscreen | Allow users to view dashboard favorites in fullscreen | Yes |
| keyParallelJobsInAnalyticsTableExport | Returns the number of parallel jobs to use for processing analytics tables. It takes priority over "keyDatabaseServerCpus". Default: -1 | No |

## User settings { #webapi_user_settings } 

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



Table: User settings

| Key | Options | Description |
|---|---|---|
| keyStyle | light_blue/light_blue.css &#124; green/green.css &#124; vietnam/vietnam.css | User interface stylesheet. |
| keyMessageEmailNotification | false &#124; true | Whether to send email notifications. |
| keyMessageSmsNotification | false &#124; true | Whether to send SMS notifications. |
| keyUiLocale | Locale value | User interface locale. |
| keyDbLocale | Locale value | Database content locale. |
| keyAnalysisDisplayProperty | name &#124; shortName | Property to display for metadata in analysis apps. |
| keyCurrentDomainType | all &#124; aggregate &#124; tracker | Data element domain type to display in lists. |
| keyAutoSaveCaseEntryForm | false &#124; true | Save case entry forms periodically. |
| keyAutoSaveTrackedEntityForm | false &#124; true | Save person registration forms periodically. |
| keyAutoSaveDataEntryForm | false &#124; true | Save aggregate data entry forms periodically. |
| keyTrackerDashboardLayout | false &#124; true | Tracker dasboard layout. |

## Configuration { #webapi_configuration } 

To access configuration you can interact with the *configuration*
resource. You can get XML and JSON responses through the *Accept* header
or by using the .json or .xml extensions. You can *GET* all properties
of the configuration from:

    /api/33/configuration

You can send *GET* and *POST* requests to the following specific
resources:

    GET /api/33/configuration/systemId

    GET POST DELETE /api/configuration/feedbackRecipients

    GET POST DELETE /api/configuration/offlineOrganisationUnitLevel

    GET POST /api/configuration/infrastructuralDataElements

    GET POST /api/configuration/infrastructuralIndicators

    GET POST /api/configuration/infrastructuralPeriodType

    GET POST DELETE /api/configuration/selfRegistrationRole

    GET POST DELETE /api/configuration/selfRegistrationOrgUnit
    
    GET POST /api/facilityOrgUnitGroupSet
    
    GET POST /api/facilityOrgUnitLevel

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



Table: Configuration values

| Configuration property | Value |
|---|---|
| feedbackRecipients | User group ID |
| offlineOrganisationUnitLevel | Organisation unit level ID |
| infrastructuralDataElements | Data element group ID |
| infrastructuralIndicators | Indicator group ID |
| infrastructuralPeriodType | Period type name (e.g. "Monthly") |
| selfRegistrationRole | User role ID |
| selfRegistrationOrgUnit | Organisation unit ID |
| smtpPassword | SMTP email server password |
| remoteServerUrl | URL to remote server |
| remoteServerUsername | Username for remote server authentication |
| remoteServerPassword | Password for remote server authentication |
| corsWhitelist | JSON list of URLs |

As an example, to set the feedback recipients user group you can invoke
the following curl command:

```bash
curl "localhost/api/33/configuration/feedbackRecipients" -d "wl5cDMuUhmF"
  -H "Content-Type:text/plain"-u admin:district
```

## Tokens { #webapi_tokens } 

The *tokens* resource provides access tokens to various services.

### Google Service Account { #webapi_tokens_google_service_account } 

You can retrieve a Google service account OAuth 2.0 access token with a
GET request to the following resource.

    GET /api/tokens/google

The token will be valid for a certain amount of time, after which
another token must be requested from this resource. The response
contains a cache control header which matches the token expiration. The
response will contain the following properties in JSON format.



Table: Token response

| Property | Description |
|---|---|
| access_token | The OAuth 2.0 access token to be used when authentication against Google services. |
| expires_in | The number of seconds until the access token expires, typically 3600 seconds (1 hour). |
| client_id | The Google service account client id. |

This assumes that a Google service account has been set up and configured for DHIS2. Please consult the installation guide for more info.

## Static content { #webapi_static_content } 

The *staticContent* resource allows you to upload and retrieve custom
logos used in DHIS2. The resource lets the user upload a file with an
associated key, which can later be retrieved using the key. Only PNG
files are supported and can only be uploaded to the `logo_banner` and
`logo_front` keys.

    /api/33/staticContent



Table: Static content keys

| Key | Description |
|---|---|
| logo_banner | Logo in the application top menu on the left side. |
| logo_front | Logo on the login-page above the login form. |

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

## UI customization { #webapi_ui_customization } 

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

### Javascript { #webapi_customization_javascript } 

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

### CSS { #webapi_customization_css } 

To insert CSS from a file called *style.css* you can interact with the
*files/style* resource with a POST-request:

```bash
curl --data-binary @style.css "localhost/api/33/files/style"
  -H "Content-Type:text/css" -u admin:district
```

You can fetch the CSS content with a GET-request:

    /api/33/files/style

To remove the JavaScript content you can use a DELETE request.
