# Web API

<!--DHIS2-SECTION-ID:webapi-->

The Web API is a component which makes it possible for external systems
to access and manipulate data stored in an instance of DHIS2. More
precisely, it provides a programmatic interface to a wide range of
exposed data and service methods for applications such as third-party
software clients, web portals and internal DHIS2 modules.

## Introduction

<!--DHIS2-SECTION-ID:webapi_introduction-->

The Web API adheres to many of the principles behind the REST
architectural style. To mention some few and important ones:

1.  The fundamental building blocks are referred to as *resources*. A
    resource can be anything exposed to the Web, from a document to a
    business process - anything a client might want to interact with.
    The information aspects of a resource can be retrieved or exchanged
    through resource *representations*. A representation is a view of a
    resource's state at any given time. For instance, the *reportTable*
    resource in DHIS2 represents a tabular report of aggregated data for
    a certain set of parameters. This resource can be retrieved in a
    variety of representation formats including HTML, PDF, and MS Excel.

2.  All resources can be uniquely identified by a *URI* (also referred
    to as *URL*). All resources have a default representation. You can
    indicate that you are interested in a specific representation by
    supplying an *Accept* HTTP header, a file extension or a *format*
    query parameter. So in order to retrieve the PDF representation of a
    report table you can supply an *Accept: application/pdf* header or
    append *.pdf* or *?format=pdf* to your request URL.

3.  Interactions with the API requires the correct use of HTTP *methods* or
    *verbs*. This implies that for a resource you must issue a *GET*
    request when you want to retrieve it, *POST* request when you want
    to create one, *PUT* when you want to update it and *DELETE* when
    you want to remove it. So if you want to retrieve the default
    representation of a report table you can send a GET request to e.g.
    */reportTable/iu8j/hYgF6t*, where the last part is the report table
    identifier.

4.  Resource representations are *linkable*, meaning that
    representations advertise other resources which are relevant to the
    current one by embedding links into itself (please be aware that you
    need to request *href* in your field filter to have this working.
    This feature greatly improves the usability and robustness of the
    API as we will see later. For instance, you can easily navigate to
    the indicators which are associated with a report table from the
    *reportTable* resource through the embedded links using your
    preferred representation format.

While all of this might sound complicated, the Web API is actually very
simple to use. We will proceed with a few practical examples in a
minute.

## Authentication

<!--DHIS2-SECTION-ID:webapi_authentication-->

The DHIS2 Web API supports two protocols for authentication, Basic
Authentication and OAuth 2. You can verify and get information about the
currently authenticated user by making a GET request to the following
URL:

    /api/33/me

And more information about authorities (and if a user has a certain
authority) by using the endpoints:

    /api/33/me/authorities
    /api/33/me/authorities/ALL

### Basic Authentication

<!--DHIS2-SECTION-ID:webapi_basic_authentication-->

The DHIS2 Web API supports *Basic authentication*. Basic authentication
is a technique for clients to send login credentials over HTTP to a web
server. Technically speaking, the username is appended with a colon and
the password, Base64-encoded, prefixed Basic and supplied as the value
of the *Authorization* HTTP header. More formally that is:

    Authorization: Basic base64encode(username:password)

Most network-aware development environments provide support for Basic 
authentication, such as *Apache HttpClient* and *Spring RestTemplate*. 
An important note is that this authentication scheme provides no security 
since the username and password are sent in plain text and can be easily 
observed by an attacker. Using Basic is recommended only if the server is 
using SSL/TLS (HTTPS) to encrypt communication with clients. Consider this 
a hard requirement in order to provide secure interactions with the Web 
API.

### Two-factor authentication

<!--DHIS2-SECTION-ID:webapi_2fa-->

DHIS2 supports two-factor authentication. This can be enabled per user.
When enabled, users will be asked to enter a 2FA code when logging in. You 
can read more about 2FA [here](https://www.google.com/landing/2step/).

### OAuth2

<!--DHIS2-SECTION-ID:webapi_oauth2-->

DHIS2 supports the *OAuth2* authentication protocol. OAuth2 is an open
standard for authorization which allows third-party clients to
connect on behalf of a DHIS2 user and get a reusable *bearer token* for
subsequent requests to the Web API. DHIS2 does not support fine-grained
OAuth2 roles but rather provides applications access based on user roles
of the DHIS2 user.

Each client for which you want to allow OAuth 2 authentication must be
registered in DHIS2. To add a new OAuth2 client go to `Apps > Settings > OAuth2 Clients`
in the user interface, click *Add new* and enter the desired client name and the grant types.

#### Adding a client using the Web API

An OAuth2 client can be added through the Web API. As an example, we can
send a payload like this:

```json
{
  "name": "OAuth2 Demo Client",
  "cid": "demo",
  "secret": "1e6db50c-0fee-11e5-98d0-3c15c2c6caf6",
  "grantTypes": [
    "password",
    "refresh_token",
    "authorization_code"
  ],
  "redirectUris": [
    "http://www.example.org"
  ]
}
```

The payload can be sent with the following command:

```bash
SERVER="https://play.dhis2.org/dev"
curl -X POST -H "Content-Type: application/json" -d @client.json
  -u admin:district "$SERVER/api/oAuth2Clients"
```

We will use this client as the basis for our next grant type examples.

#### Grant type password

<!--DHIS2-SECTION-ID:webapi_oauth2_password-->

The simplest of all grant types is the *password* grant type. This
grant type is similar to basic authentication in the sense that it
requires the client to collect the user's username and password. As an
example we can use our demo server:

```bash
SERVER="https://play.dhis2.org/dev"
SECRET="1e6db50c-0fee-11e5-98d0-3c15c2c6caf6"

curl -X POST -H "Accept: application/json" -u demo:$SECRET "$SERVER/uaa/oauth/token"
  -d grant_type=password -d username=admin -d password=district
```

This will give you a response similar to this:

```json
{
  "expires_in": 43175,
  "scope": "ALL",
  "access_token": "07fc551c-806c-41a4-9a8c-10658bd15435",
  "refresh_token": "a4e4de45-4743-481d-9345-2cfe34732fcc",
  "token_type": "bearer"
}
```

For now, we will concentrate on the `access_token`, which is what we
will use as our authentication (bearer) token. As an example, we will get
all data elements using our token:

```bash
SERVER="https://play.dhis2.org/dev"
curl -H "Authorization: Bearer 07fc551c-806c-41a4-9a8c-10658bd15435" "$SERVER/api/33/dataElements.json"
```

#### Grant type refresh\_token

<!--DHIS2-SECTION-ID:webapi_refresh_token-->

In general the access tokens have limited validity. You can have a look
at the `expires_in` property of the response in the previous example
to understand when a token expires. To get a fresh `access_token` you
can make another round trip to the server and use `refresh_token`
which allows you to get an updated token without needing to ask for the
user credentials one more time.

```bash
SERVER="https://play.dhis2.org/dev"
SECRET="1e6db50c-0fee-11e5-98d0-3c15c2c6caf6"
REFRESH_TOKEN="a4e4de45-4743-481d-9345-2cfe34732fcc"

curl -X POST -H "Accept: application/json" -u demo:$SECRET "$SERVER/uaa/oauth/token"
  -d "grant_type=refresh_token" -d "refresh_token=$REFRESH_TOKEN"
```

The response will be exactly the same as when you get a token to start with.

#### Grant type authorization_code

<!--DHIS2-SECTION-ID:webapi_authorization_code-->

Authorized code grant type is the recommended approach if you don't want
to store the user credentials externally. It allows DHIS2 to collect the
username/password directly from the user instead of the client
collecting them and then authenticating on behalf of the user. Please be
aware that this approach uses the `redirectUris` part of the client
payload.

Step 1: Visit the following URL using a web browser. If you have more than one
redirect URIs, you might want to add `&redirect_uri=http://www.example.org` 
to the URL:

```bash
SERVER="https://play.dhis2.org/dev"
$SERVER/uaa/oauth/authorize?client_id=demo&response_type=code
```

Step 2: After the user has successfully logged in and accepted your
client access, it will redirect back to your redirect uri like this:

    http://www.example.org/?code=XYZ

Step 3: This step is similar to what we did in the password grant type,
using the given code, we will now ask for an access token:

```bash
SERVER="https://play.dhis2.org/dev"
SECRET="1e6db50c-0fee-11e5-98d0-3c15c2c6caf6"

curl -X POST -u demo:$SECRET -H "Accept: application/json" $SERVER/uaa/oauth/token
-d "grant_type=authorization_code" -d "code=XYZ"
```

## Error and info messages

<!--DHIS2-SECTION-ID:webapi_error_info_messages-->

The Web API uses a consistent format for all error/warning and
informational messages:

```json
{
  "httpStatus": "Forbidden",
  "message": "You don't have the proper permissions to read objects of this type.",
  "httpStatusCode": 403,
  "status": "ERROR"
}
```

Here we can see from the message that the user tried to access a
resource I did not have access to. It uses the http status code 403, the
http status message *forbidden* and a descriptive message.

<table>
<caption>WebMessage properties</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 86%" />
</colgroup>
<thead>
<tr class="header">
<th>Name</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>httpStatus</td>
<td>HTTP Status message for this response, see RFC 2616 (Section 10) for more information.</td>
</tr>
<tr class="even">
<td>httpStatusCode</td>
<td>HTTP Status code for this response, see RFC 2616 (Section 10) for more information.</td>
</tr>
<tr class="odd">
<td>status</td>
<td>DHIS2 status, possible values are <em>OK</em> | <em>WARNING</em> | <em>ERROR</em>, where `OK` means everything was successful, `ERROR` means that operation did not complete and `WARNING` means the operation was partially successful, if the message contains a `response` property, please look there for more information.</td>
</tr>
<tr class="even">
<td>message</td>
<td>A user-friendly message telling whether the operation was a success or not.</td>
</tr>
<tr class="odd">
<td>devMessage</td>
<td>A more technical, developer-friendly message (not currently in use).</td>
</tr>
<tr class="even">
<td>response</td>
<td>Extension point for future extension to the WebMessage format. This will be documented when it starts being used.</td>
</tr>
</tbody>
</table>

## Date and period format

<!--DHIS2-SECTION-ID:webapi_date_perid_format-->

Throughout the Web API, we refer to dates and periods. The date format
is:

    yyyy-MM-dd

For instance, if you want to express March 20, 2014, you must use
*2014-03-20*.

The period format is described in the following table (also available on
the API endpoint `/api/periodTypes`)

<table style="width:100%;">
<caption>Period format</caption>
<colgroup>
<col style="width: 24%" />
<col style="width: 21%" />
<col style="width: 18%" />
<col style="width: 35%" />
</colgroup>
<thead>
<tr class="header">
<th>Interval</th>
<th>Format</th>
<th>Example</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Day</td>
<td><em>yyyyMMdd</em></td>
<td>20040315</td>
<td>March 15, 2004</td>
</tr>
<tr class="even">
<td>Week</td>
<td><em>yyyy</em>W<em>n</em></td>
<td>2004W10</td>
<td>Week 10 2004</td>
</tr>
<tr class="odd">
<td>Week Wednesday</td>
<td><em>yyyy</em>WedW<em>n</em></td>
<td>2015WedW5</td>
<td>Week 5 with start Wednesday</td>
</tr>
<tr class="even">
<td>Week Thursday</td>
<td><em>yyyy</em>ThuW<em>n</em></td>
<td>2015ThuW6</td>
<td>Week 6 with start Thursday</td>
</tr>
<tr class="odd">
<td>Week Saturday</td>
<td><em>yyyy</em>SatW<em>n</em></td>
<td>2015SatW7</td>
<td>Week 7 with start Saturday</td>
</tr>
<tr class="even">
<td>Week Sunday</td>
<td><em>yyyy</em>SunW<em>n</em></td>
<td>2015SunW8</td>
<td>Week 8 with start Sunday</td>
</tr>
<tr class="odd">
<td>Bi-week</td>
<td><em>yyyy</em>BiW<em>n</em></td>
<td>2015BiW1</td>
<td>Week 1-2 20015</td>
</tr>
<tr class="even">
<td>Month</td>
<td><em>yyyyMM</em></td>
<td>200403</td>
<td>March 2004</td>
</tr>
<tr class="odd">
<td>Bi-month</td>
<td><em>yyyyMM</em>B</td>
<td>200401B</td>
<td>January-February 2004</td>
</tr>
<tr class="even">
<td>Quarter</td>
<td><em>yyyy</em>Q<em>n</em></td>
<td>2004Q1</td>
<td>January-March 2004</td>
</tr>
<tr class="odd">
<td>Six-month</td>
<td><em>yyyy</em>S<em>n</em></td>
<td>2004S1</td>
<td>January-June 2004</td>
</tr>
<tr class="even">
<td>Six-month April</td>
<td><em>yyyy</em>AprilSn</td>
<td>2004AprilS1</td>
<td>April-September 2004</td>
</tr>
<tr class="odd">
<td>Year</td>
<td>yyyy</td>
<td>2004</td>
<td>2004</td>
</tr>
<tr class="even">
<td>Financial Year April</td>
<td>yyyyApril</td>
<td>2004April</td>
<td>Apr 2004-Mar 2005</td>
</tr>
<tr class="odd">
<td>Financial Year July</td>
<td>yyyyJuly</td>
<td>2004July</td>
<td>July 2004-June 2005</td>
</tr>
<tr class="even">
<td>Financial Year Oct</td>
<td>yyyyOct</td>
<td>2004Oct</td>
<td>Oct 2004-Sep 2005</td>
</tr>
</tbody>
</table>


### Relative Periods

<!--DHIS2-SECTION-ID:webapi_date_relative_period_values-->


In some parts of the API, like for the analytics resource, you can
utilize relative periods in addition to fixed periods (defined above).
The relative periods are relative to the current date and allow e.g.
for creating dynamic reports. The available relative period values are:

    THIS_WEEK, LAST_WEEK, LAST_4_WEEKS, LAST_12_WEEKS, LAST_52_WEEKS,
    THIS_MONTH, LAST_MONTH, THIS_BIMONTH, LAST_BIMONTH, THIS_QUARTER, LAST_QUARTER,
    THIS_SIX_MONTH, LAST_SIX_MONTH, MONTHS_THIS_YEAR, QUARTERS_THIS_YEAR,
    THIS_YEAR, MONTHS_LAST_YEAR, QUARTERS_LAST_YEAR, LAST_YEAR, LAST_5_YEARS, LAST_12_MONTHS,
    LAST_3_MONTHS, LAST_6_BIMONTHS, LAST_4_QUARTERS, LAST_2_SIXMONTHS, THIS_FINANCIAL_YEAR,
    LAST_FINANCIAL_YEAR, LAST_5_FINANCIAL_YEARS

## Identifier schemes

<!--DHIS2-SECTION-ID:webapi_identifier_schemes-->

This section provides an explanation of the identifier scheme concept.
Identifier schemes are used to map metadata objects to other metadata
during import, and to render metadata as part of exports. Please note
that not all schemes work for all API calls, and not all
schemes can be used for both input and output. This is outlined in the
sections explaining the various Web APIs.

The full set of identifier scheme object types available are listed
below, using the name of the property to use in queries:

  - idScheme

  - dataElementIdScheme

  - categoryOptionComboIdScheme

  - orgUnitIdScheme

  - programIdScheme

  - programStageIdScheme

  - trackedEntityIdScheme

  - trackedEntityAttributeIdScheme

The general idScheme applies to all types of objects. It can be
overridden by specific object types.

The default scheme for all parameters is UID (stable DHIS2
identifiers). The supported identifier schemes are described in the
table below.

<table>
<caption>Scheme Values</caption>
<colgroup>
<col style="width: 14%" />
<col style="width: 85%" />
</colgroup>
<thead>
<tr class="header">
<th>Scheme</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ID, UID</td>
<td>Match on DHIS2 stable Identifier, this is the default id scheme.</td>
</tr>
<tr class="even">
<td>CODE</td>
<td>Match on DHIS2 Code, mainly used to exchange data with an external system.</td>
</tr>
<tr class="odd">
<td>NAME</td>
<td>Match on DHIS2 Name, please note that this uses what is available as <em>object.name</em>, and not the translated name. Also note that names are not always unique, and in that case, they can not be used.</td>
</tr>
<tr class="even">
<td>ATTRIBUTE:ID</td>
<td>Match on metadata attribute, this attribute needs to be assigned to the type you are matching on, and also that the unique property is set to <em>true</em>. The main usage of this is also to exchange data with external systems, it has some advantages over <em>CODE</em> since multiple attributes can be added, so it can be used to synchronize with more than one system.</td>
</tr>
</tbody>
</table>

Note that identifier schemes is not an independent feature but needs to
be used in combination with resources such as data value import and metadata import.

As an example, to specify CODE as the general id scheme and override
with UID for organisation unit id scheme you can use these query
parameters:

    ?idScheme=CODE&orgUnitIdScheme=UID

As another example, to specify an attribute for the organisation unit id
scheme, code for the data element id scheme and use the default UID id
scheme for all other objects you can use these parameters:

    ?orgUnitIdScheme=ATTRIBUTE:j38fk2dKFsG&dataElementIdScheme=CODE

## Browsing the Web API

<!--DHIS2-SECTION-ID:webapi_browsing_the_web_api-->

The entry point for browsing the Web API is `/api`. This resource
provides links to all available resources. Four resource representation
formats are consistently available for all resources: HTML, XML, JSON, 
and JSONP. Some resources will have other formats available, like MS
Excel, PDF, CSV, and PNG. To explore the API from a web browser, navigate
to the `/api` entry point and follow the links to your desired
resource, for instance `/api/dataElements`. For all resources which
return a list of elements certain query parameters can be used to modify
the response:

<table style="width:100%;">
<caption>Query parameters</caption>
<colgroup>
<col style="width: 11%" />
<col style="width: 20%" />
<col style="width: 12%" />
<col style="width: 54%" />
</colgroup>
<thead>
<tr class="header">
<th>Param</th>
<th>Option values</th>
<th>Default option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>paging</td>
<td>true | false</td>
<td>true</td>
<td>Indicates whether to return lists of elements in pages.</td>
</tr>
<tr class="even">
<td>page</td>
<td>number</td>
<td>1</td>
<td>Defines which page number to return.</td>
</tr>
<tr class="odd">
<td>pageSize</td>
<td>number</td>
<td>50</td>
<td>Defines the number of elements to return for each page.</td>
</tr>
<tr class="even">
<td>order</td>
<td>property:asc/iasc/desc/idesc</td>
<td></td>
<td>Order the output using a specified order, only properties that are both persisted and simple (no collections, idObjects etc) are supported. iasc and idesc are case insensitive sorting.</td>
</tr>
</tbody>
</table>

An example of how these parameters can be used to get a full list of
data element groups in XML response format is:

    /api/dataElementGroups.xml?links=false&paging=false

You can query for elements on the name property instead of returning
a full list of elements using the *query* query variable. In this example
we query for all data elements with the word "anaemia" in the name:

    /api/dataElements?query=anaemia

You can get specific pages and page sizes of objects like this:

    /api/dataElements.json?page=2&pageSize=20

You can completely disable paging like this:

    /api/indicatorGroups.json?paging=false

To order the result based on a specific property:

    /api/indicators.json?order=shortName:desc

You can find an object based on its ID across all object types through
the *identifiableObjects* resource:

    /api/identifiableObjects/<id>

### Translation

<!--DHIS2-SECTION-ID:webapi_translation-->

DHIS2 supports translations of database content, such as data elements,
indicators, and programs. All metadata objects in the Web API have
properties meant to be used for display / UI purposes, which include
*displayName*, *displayShortName* and *displayDescription*.

<table>
<caption>Translate options</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 16%" />
<col style="width: 62%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Values</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>translate</td>
<td>true | false</td>
<td>Translate display* properties in metadata output (displayName, displayShortName, displayDescription, and displayFormName for data elements). Default value is true.</td>
</tr>
<tr class="even">
<td>locale</td>
<td>Locale to use</td>
<td>Translate metadata output using a specified locale (requires translate=true).</td>
</tr>
</tbody>
</table>

### Translation API

<!--DHIS2-SECTION-ID:webapi_translation_api-->

The translations for an object is rendered as part of the object itself
in the *translations* array. Note that the *translations* array in the
JSON/XML payloads is normally pre-filtered for you, which means they
can not directly be used to import/export translations (as that would
normally overwrite locales other than current users).

Example of data element with translation array filtered on user locale:

```json
{
  "id": "FTRrcoaog83",
  "displayName": "Accute French",
  "translations": [
    {
      "property": "SHORT_NAME",
      "locale": "fr",
      "value": "Accute French"
    },
    {
      "property": "NAME",
      "locale": "fr",
      "value": "Accute French"
    }
  ]
}
```

Example of data element with translations turned off:

```json
{
  "id": "FTRrcoaog83",
  "displayName": "Accute Flaccid Paralysis (Deaths < 5 yrs)",
  "translations": [
    {
      "property": "FORM_NAME",
      "locale": "en_FK",
      "value": "aa"
    },
    {
      "property": "SHORT_NAME",
      "locale": "en_GB",
      "value": "Accute Flaccid Paral"
    },
    {
      "property": "SHORT_NAME",
      "locale": "fr",
      "value": "Accute French"
    },
    {
      "property": "NAME",
      "locale": "fr",
      "value": "Accute French"
    },
    {
      "property": "NAME",
      "locale": "en_FK",
      "value": "aa"
    },
    {
      "property": "DESCRIPTION",
      "locale": "en_FK",
      "value": "aa"
    }
  ]
}
```

Note that even if you get the unfiltered result, and are using the
appropriate type endpoint i..e `/api/dataElements` we do not allow
updates, as it would be too easy to make mistakes and overwrite the
other available locales.

To read and update translations you can use the special translations
endpoint for each object resource. These can be accessed by *GET* or
*PUT* on the appropriate `/api/<object-type>/<object-id>/translations` endpoint.

As an example, for a data element with identifier `FTRrcoaog83`, you could use
`/api/dataElements/FTRrcoaog83/translations` to get and update
translations. The fields available are `property` with options *NAME*,
*SHORT_NAME*, *DESCRIPTION*, `locale` which supports any valid
locale ID and the translated property `value`.

Example of NAME property for French locale:

```json
{
  "property": "NAME",
  "locale": "fr",
  "value": "Paralysie Flasque Aiguë (Décès <5 ans)"
}
```

This payload would then be added to a translation array, and sent back
to the appropriate endpoint:

```json
{
  "translations": [
    {
      "property": "NAME",
      "locale": "fr",
      "value": "Paralysie Flasque Aiguë (Décès <5 ans)"
    }
  ]
}
```

For a data element with ID *FTRrcoaog83* you can *PUT* this to
`/api/dataElements/FTRrcoaog83/translations`. Make sure to send all
translations for the specific object and not just for a single locale
(if not you will potentially overwrite existing locales for other
locales).

### Web API versions

<!--DHIS2-SECTION-ID:webapi_api_versions-->

The Web API is versioned starting from DHIS 2.25. The API versioning
follows the DHIS2 major version numbering. As an example, the API
version for DHIS 2.33 is `33`.

You can access a specific API version by including the version number
after the `/api` component, as an example like this:

    /api/33/dataElements

If you omit the version part of the URL, the system will use the current
API version. As an example, for DHIS 2.25, when omitting the API part,
the system will use API version 25. When developing API clients it is
recommended to use explicit API versions (rather than omitting the API
version), as this will protect the client from unforeseen API changes.

The last three API versions will be supported. As an example, DHIS
version 2.27 will support API version 27, 26 and 25.

Note that the metadata model is not versioned and that you might
experience changes e.g. in associations between objects. These changes
will be documented in the DHIS2 major version release notes.

## Metadata object filter

<!--DHIS2-SECTION-ID:webapi_metadata_object_filter-->

To filter the metadata there are several filter operations that can be
applied to the returned list of metadata. The format of the filter
itself is straight-forward and follows the pattern
*property:operator:value*, where *property* is the property on the
metadata you want to filter on, *operator* is the comparison operator
you want to perform and *value* is the value to check against (not all
operators require value). Please see the *schema* section to discover
which properties are available. Recursive filtering, ie. filtering on
associated objects or collection of objects, is supported as well.

<table>
<caption>Available Operators</caption>
<thead>
<tr class="header">
<th>Operator</th>
<th>Types</th>
<th>Value required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>eq</td>
<td>string | boolean | integer | float | enum | collection (checks for size) | date</td>
<td>true</td>
<td>Equality</td>
</tr>
<tr class="even">
<td>!eq</td>
<td>string | boolean | integer | float | enum | collection (checks for size) | date</td>
<td>true</td>
<td>Inequality</td>
</tr>
<tr class="odd">
<td>ne</td>
<td>string | boolean | integer | float | enum | collection (checks for size) | date</td>
<td>true</td>
<td>Inequality</td>
</tr>
<tr class="even">
<td>like</td>
<td>string</td>
<td>true</td>
<td>Case sensitive string, match anywhere</td>
</tr>
<tr class="odd">
<td>!like</td>
<td>string</td>
<td>true</td>
<td>Case sensitive string, not match anywhere</td>
</tr>
<tr class="even">
<td>\$like</td>
<td>string</td>
<td>true</td>
<td>Case sensitive string, match start</td>
</tr>
<tr class="odd">
<td>!\$like</td>
<td>string</td>
<td>true</td>
<td>Case sensitive string, not match start</td>
</tr>
<tr class="even">
<td>like\$</td>
<td>string</td>
<td>true</td>
<td>Case sensitive string, match end</td>
</tr>
<tr class="odd">
<td>!like\$</td>
<td>string</td>
<td>true</td>
<td>Case sensitive string, not match end</td>
</tr>
<tr class="even">
<td>ilike</td>
<td>string</td>
<td>true</td>
<td>Case insensitive string, match anywhere</td>
</tr>
<tr class="odd">
<td>!ilike</td>
<td>string</td>
<td>true</td>
<td>Case insensitive string, not match anywhere</td>
</tr>
<tr class="even">
<td>\$ilike</td>
<td>string</td>
<td>true</td>
<td>Case insensitive string, match start</td>
</tr>
<tr class="odd">
<td>!\$ilike</td>
<td>string</td>
<td>true</td>
<td>Case insensitive string, not match start</td>
</tr>
<tr class="even">
<td>ilike\$</td>
<td>string</td>
<td>true</td>
<td>Case insensitive string, match end</td>
</tr>
<tr class="odd">
<td>!ilike\$</td>
<td>string</td>
<td>true</td>
<td>Case insensitive string, not match end</td>
</tr>
<tr class="even">
<td>gt</td>
<td>string | boolean | integer | float | collection (checks for size) | date</td>
<td>true</td>
<td>Greater than</td>
</tr>
<tr class="odd">
<td>ge</td>
<td>string | boolean | integer | float | collection (checks for size) | date</td>
<td>true</td>
<td>Greater than or equal</td>
</tr>
<tr class="even">
<td>lt</td>
<td>string | boolean | integer | float | collection (checks for size) | date</td>
<td>true</td>
<td>Less than</td>
</tr>
<tr class="odd">
<td>le</td>
<td>string | boolean | integer | float | collection (checks for size) | date</td>
<td>true</td>
<td>Less than or equal</td>
</tr>
<tr class="even">
<td>null</td>
<td>all</td>
<td>false</td>
<td>Property is null</td>
</tr>
<tr class="odd">
<td>!null</td>
<td>all</td>
<td>false</td>
<td>Property is not null</td>
</tr>
<tr class="even">
<td>empty</td>
<td>collection</td>
<td>false</td>
<td>Collection is empty</td>
</tr>
<tr class="odd">
<td>token</td>
<td>string</td>
<td>true</td>
<td>Match on multiple tokens in search property</td>
</tr>
<tr class="even">
<td>!token</td>
<td>string</td>
<td>true</td>
<td>Not match on multiple tokens in search property</td>
</tr>
<tr class="odd">
<td>in</td>
<td>string | boolean | integer | float | date</td>
<td>true</td>
<td>Find objects matching 1 or more values</td>
</tr>
<tr class="even">
<td>!in</td>
<td>string | boolean | integer | float | date</td>
<td>true</td>
<td>Find objects not matching 1 or more values</td>
</tr>
</tbody>
</table>

Operators will be applied as logical *and* query, if you need a *or*
query, you can have a look at our *in* filter (also have a look at the
section below). The filtering mechanism allows for recursion. See below
for some examples.

Get data elements with id property ID1 or ID2:

    /api/dataElements?filter=id:eq:ID1&filter=id:eq:ID2

Get all data elements which have the dataSet with id ID1:

    /api/dataElements?filter=dataSetElements.dataSet.id:eq:ID1

Get all data elements with aggregation operator "sum" and value type
"int":

    /api/dataElements.json?filter=aggregationOperator:eq:sum&filter=type:eq:int

You can do filtering within collections, e.g. to get data elements which
are members of the "ANC" data element group you can use the following
query using the id property of the associated data element groups:

    /api/dataElements.json?filter=dataElementGroups.id:eq:qfxEYY9xAl6

Since all operators are *and* by default, you can't find a data
element matching more than one id, for that purpose you can use the *in*
operator.

    /api/dataElements.json?filter=id:in:[fbfJHSPpUQD,cYeuwXTCPkU]

### Logical operators

<!--DHIS2-SECTION-ID:webapi_metadata_logical_operator-->

As mentioned in the section before, the default logical operator applied
to the filters is *AND* which means that all object filters must be
matched. There are however cases where you want to match on one of
several filters (maybe id and code field) and in those cases, it is
possible to switch the root logical operator from *AND* to *OR*
using the *rootJunction* parameter.

Example: Normal filtering where both id and code must match to have a
result returned

    /api/dataElements.json?filter=id:in:[id1,id2]&filter=code:eq:code1

Example: Filtering where the logical operator has been switched to OR
and now only one of the filters must match to have a result
    returned

    /api/dataElements.json?filter=id:in:[id1,id2]&filter=code:eq:code1&rootJunction=OR

### Identifiable token filter

In addition to the specific property based filtering mentioned above,
we also have *token* based *AND* filtering across a set of
properties: id, code, and name (also shortName if available). These
properties are commonly referred to as *identifiable*. The idea is to
filter metadata whose id, name, code or short name containing something.

Example: Filter all data elements containing *2nd* in any of the
following: id,name,code, shortName

    /api/dataElements.json?filter=identifiable:token:2nd

It is also possible to specify multiple filtering values.

Example: Get all data elements where *ANC visit* is found in any of the *identifiable* properties. The system returns all data elements where both tokens (ANC and visit) are found anywhere in identifiable properties.

    /api/dataElements.json?filter=identifiable:token:ANC visit

It is also possible to combine the identifiable filter with property-based filter and expect the *rootJunction* to be applied.

    /api/dataElements.json?filter=identifiable:token:ANC visit&filter=displayName:ilike:tt1
    
    /api/dataElements.json?filter=identifiable:token:ANC visit
      &filter=displayName:ilike:tt1&rootJunction=OR

### Capture Scope filter

In addition to the filtering mentioned above, we have a special filtering query parameter named *restrictToCaptureScope*. If *restrictToCaptureScope* is set to true, only those metadata objects that are either unassigned to any organisation units or those that are assigned explicitly to the logged in users capture scope org units will be returned in the response. This filtering parameter can be used for any metadata that has organisation units association with it.

A special case exists for CategoryOptions api endpoint. In addition to filtering the metadata object lists, an additional filtering of the associated organisation units to only include the capture scoped organisation units will be done. Note that this second level of filtering only applies for CategoryOptions metadata.

Some examples

    /api/categoryOptions.json?restrictToCaptureScope=true&fields=*
    
    /api/programs.json?restrictToCaptureScope=true&fields=*

All existing filters will work in addition to the capture scope filter.

    /api/categoryOptions.json?restrictToCaptureScope=true&fields=*&filter=displayName:ilike:11

## Metadata field filter

<!--DHIS2-SECTION-ID:webapi_metadata_field_filter-->

In many situations, the default views of the metadata can be too
verbose. A client might only need a few fields from each object and want
to remove unnecessary fields from the response. To discover which fields
are available for each object please see the *schema* section.

The format for include/exclude allows for infinite recursion. To filter 
at the "root" level you can just use the name of the field, 
i.e. `?fields=id,name` which would only display the `id` and
`name` fields for every object. For objects that are either collections or
complex objects with properties on their own, you can use the format
`?fields=id,name,dataSets[id,name]` which would return `id`, `name` of
the root, and the `id` and `name` of every data set on that object.
Negation can be done with the exclamation operator, and we have a set of
presets of field select. Both XML and JSON are supported.

**Example**: Get `id` and `name` on the indicators resource:

    /api/indicators?fields=id,name

**Example**: Get `id` and `name` from dataElements, and `id` and `name`
from the dataSets on dataElements:

    /api/dataElements?fields=id,name,dataSets[id,name]

To exclude a field from the output you can use the exclamation `!`
operator. This is allowed anywhere in the query and will simply not
include that property as it might have been inserted in some of the
presets.

A few presets (selected fields groups) are available and can be applied
using the `:` operator.

<table>
<caption>Property operators</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 74%" />
</colgroup>
<thead>
<tr class="header">
<th>Operator</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>&lt;field-name&gt;</td>
<td>Include property with name, if it exists.</td>
</tr>
<tr class="even">
<td>&lt;object&gt;[&lt;field-name&gt;, ...]</td>
<td>Includes a field within either a collection (will be applied to every object in that collection), or just on a single object.</td>
</tr>
<tr class="odd">
<td>!&lt;field-name&gt;, &lt;object&gt;[!&lt;field-name&gt;</td>
<td>Do not include this field name, it also works inside objects/collections. Useful when you use a preset to include fields.</td>
</tr>
<tr class="even">
<td>*, &lt;object&gt;[*]</td>
<td>Include all fields on a certain object, if applied to a collection, it will include all fields on all objects on that collection.</td>
</tr>
<tr class="odd">
<td>:&lt;preset&gt;</td>
<td>Alias to select multiple fields. Three presets are currently available, see the table below for descriptions.</td>
</tr>
</tbody>
</table>

<table>
<caption>Field presets</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 74%" />
</colgroup>
<thead>
<tr class="header">
<th>Preset</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>all</td>
<td>All fields of the object</td>
</tr>
<tr class="even">
<td>*</td>
<td>Alias for all</td>
</tr>
<tr class="odd">
<td>identifiable</td>
<td>Includes id, name, code, created and lastUpdated fields</td>
</tr>
<tr class="even">
<td>nameable</td>
<td>Includes id, name, shortName, code, description, created and lastUpdated fields</td>
</tr>
<tr class="odd">
<td>persisted</td>
<td>Returns all persisted property on an object, does not take into consideration if the object is the owner of the relation.</td>
</tr>
<tr class="even">
<td>owner</td>
<td>Returns all persisted property on an object where the object is the owner of all properties, this payload can be used to update through the API.</td>
</tr>
</tbody>
</table>

**Example**: Include all fields from dataSets except organisationUnits:

    /api/dataSets?fields=:all,!organisationUnits

**Example**: Include only id, name and the collection of organisation units from a data set, but exclude the id from organisation units:

    /api/dataSets/BfMAe6Itzgt?fields=id,name,organisationUnits[:all,!id]

**Example**: Include nameable properties from all indicators:

    /api/indicators.json?fields=:nameable

### Field transformers

<!--DHIS2-SECTION-ID:webapi_field_transformers-->

In DHIS2.17 we introduced field transformers, the idea is to allow
further customization of the properties on the server-side.

    /api/dataElements/ID?fields=id~rename(i),name~rename(n)

This will rename the *id* property to *i* and *name* property to *n*.

Multiple transformers can be used by repeating the transformer syntax:

    /api/dataElementGroups.json?fields=id,displayName,dataElements~isNotEmpty~rename(haveDataElements)

<table>
<caption>Available Transformers</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 21%" />
<col style="width: 44%" />
</colgroup>
<thead>
<tr class="header">
<th>Name</th>
<th>Arguments</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>size</td>
<td></td>
<td>Gives sizes of strings (length) and collections</td>
</tr>
<tr class="even">
<td>isEmpty</td>
<td></td>
<td>Is string or collection empty</td>
</tr>
<tr class="odd">
<td>isNotEmpty</td>
<td></td>
<td>Is string or collection not empty</td>
</tr>
<tr class="even">
<td>rename</td>
<td>Arg1: name</td>
<td>Renames the property name</td>
</tr>
<tr class="odd">
<td>paging</td>
<td>Arg1: page,Arg2: pageSize</td>
<td>Pages a collection, default pageSize is 50.</td>
</tr>
<tr class="even">
<td>pluck</td>
<td>Optional Arg1: fieldName</td>
<td>Converts an array of objects to an array of a selected field of that object. By default, the first field that is returned by the collection is used (normally the ID).</td>
</tr>
</tbody>
</table>

#### Examples

<!--DHIS2-SECTION-ID:webapi_field_transformers_examples-->

Examples of transformer usage.

```
/api/dataElements?fields=dataSets~size

/api/dataElements?fields=dataSets~isEmpty

/api/dataElements?fields=dataSets~isNotEmpty

/api/dataElements/ID?fields=id~rename(i),name~rename(n)

/api/dataElementGroups?fields=id,displayName,dataElements~paging(1;20)

# Include array with IDs of organisation units:
/api/categoryOptions.json?fields=id,organisationUnits~pluck

# Include array with names of organisation units (collection only returns field name):
/api/categoryOptions.json?fields=id,organisationUnits~pluck[name]
```

## Metadata create, read, update, delete, validate

<!--DHIS2-SECTION-ID:webapi_metadata_crud-->

All metadata entities in DHIS2 have their own API endpoint which supports
*CRUD* operations (create, read, update and delete). The endpoint URLs
follows this format:

    /api/<entityName>

The _entityName_ uses the camel-case notation. As an example, the endpoint
for _data elements_ is:

    /api/dataElements

### Create / update parameters

<!--DHIS2-SECTION-ID:webapi_metadata_create_update-->

The following request query parameters are available across all metadata endpoints.

<table>
<caption>Available Query Filters</caption>
<thead>
<tr class="header">
<th>Param</th>
<th>Type</th>
<th>Required</th>
<th>Options (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>preheatCache</td>
<td>boolean</td>
<td>false</td>
<td>true | false</td>
<td>Turn cache-map preheating on/off. This is on by default, turning this off will make initial load time for importer much shorter (but will make the import itself slower). This is mostly used for cases where you have a small XML/JSON file you want to import, and don't want to wait for cache-map preheating.</td>
</tr>
<tr class="even">
<td>strategy</td>
<td>enum</td>
<td>false</td>
<td>CREATE_AND_UPDATE | CREATE | UPDATE | DELETE</td>
<td>Import strategy to use, see below for more information.</td>
</tr>
<tr class="odd">
<td>mergeMode</td>
<td>enum</td>
<td>false</td>
<td>REPLACE, MERGE</td>
<td>Strategy for merging of objects when doing updates. REPLACE will just overwrite the property with the new value provided, MERGE will only set the property if it is not null (only if the property was provided).</td>
</tr>
</tbody>
</table>

### Creating and updating objects

<!--DHIS2-SECTION-ID:webapi_creating_updating_objects-->

For creating new objects you will need to know the endpoint, the type
format, and make sure that you have the required authorities. As an
example, we will create and update a *constant*. To figure out the
format, we can use the new *schema* endpoint for getting format
description. So we will start with getting that info:

    http://<server>/api/schemas/constant.json

From the output, you can see that the required authorities for create
are `F_CONSTANT_ADD`, and the important properties are: *name* and
*value*. From this, we can create a JSON payload and save it as a file
called constant.json:

```json
{
  "name": "PI",
  "value": "3.14159265359"
}
```

The same content as an XML payload:

```xml
<constant name="PI" xmlns="http://dhis2.org/schema/dxf/2.0">
  <value>3.14159265359</value>
</constant>
```

We are now ready to create the new *constant* by sending a POST request to
the *constants*endpoint with the JSON payload using curl:

```bash
curl -d @constant.json "http://server/api/constants" -X POST
  -H "Content-Type: application/json" -u user:password
```

A specific example of posting the constant to the demo
    server:

```bash
curl -d @constant.json "https://play.dhis2.org/api/constants" -X POST
  -H "Content-Type: application/json" -u admin:district
```

If everything went well, you should see an output similar to:

```json
{
  "status": "SUCCESS",
  "importCount": {
    "imported": 1,
    "updated": 0,
    "ignored": 0,
    "deleted": 0
  },
  "type": "Constant"
}
```

The process will be exactly the same for updating, you make your changes
to the JSON/XML payload, find out the *ID* of the constant, and then
send a PUT request to the endpoint including ID:

```bash
curl -X PUT -d @pi.json -H "Content-Type: application/json"
  -u user:password "http://server/api/constants/ID"
```

### Deleting objects

<!--DHIS2-SECTION-ID:webapi_deleting_objects-->

Deleting objects is very straight forward, you will need to know the
*ID* and the endpoint of the type you want to delete, let's continue our
example from the last section and use a *constant*. Let's assume that
the id is *abc123*, then all you need to do is the send the DELETE
request to the endpoint + id:

```bash
curl -X DELETE -u user:password "http://server/api/constants/ID"
```

A successful delete should return HTTP status 204 (no content).

### Adding and removing objects in collections

<!--DHIS2-SECTION-ID:webapi_adding_removing_objects_collections-->

The collections resource lets you modify collections of
objects.

#### Adding or removing single objects

<!--DHIS2-SECTION-ID:webapi_collections_adding_removing_single_objects-->

In order to add or remove objects to or from a collection of objects you
can use the following
    pattern:

    /api/{collection-object}/{collection-object-id}/{collection-name}/{object-id}

You should use the POST method to add, and the DELETE method to remove
an object. When there is a many-to-many relationship between objects,
you must first determine which object owns the relationship. If it isn't
clear which object this is, try the call both ways to see which works.

The components of the pattern are:

  - collection object: The type of objects that owns the collection you
    want to modify.

  - collection object id: The identifier of the object that owns the
    collection you want to modify.

  - collection name: The name of the collection you want to modify.

  - object id: The identifier of the object you want to add or remove
    from the collection.

As an example, in order to remove a data element with identifier IDB
from a data element group with identifier IDA you can do a DELETE
request:

    DELETE /api/dataElementGroups/IDA/dataElements/IDB

To add a category option with identifier IDB to a category with
identifier IDA you can do a POST
request:

    POST /api/categories/IDA/categoryOptions/IDB

#### Adding or removing multiple objects

<!--DHIS2-SECTION-ID:webapi_collections_adding_removing_multiple_objects-->

You can add or remove multiple objects from a collection in one request
with a payload like this:

```json
{
  "identifiableObjects": [{
      "id": "IDA"
    }, {
      "id": "IDB"
    }, {
      "id": "IDC"
    }
  ]
}
```

Using this payload you can add, replace or delete items:

*Adding Items:*

    POST /api/categories/IDA/categoryOptions

*Replacing Items:*

    PUT /api/categories/IDA/categoryOptions

*Delete
Items:*

    DELETE /api/categories/IDA/categoryOptions

#### Adding and removing objects in a single request

<!--DHIS2-SECTION-ID:webapi_collections_adding_removing_objects_single_request-->

You can both add and remove objects from a collection in a single POST
request to the following URL:

    POST /api/categories/IDA/categoryOptions

The payload format is:

```json
{
  "additions": [{
      "id": "IDA"
    }, {
      "id": "IDB"
    }, {
      "id": "IDC"
    }
  ],
  "deletions": [{
      "id": "IDD"
    }, {
      "id": "IDE"
    }, {
      "id": "IDF"
    }
  ]
}
```

### Validating payloads

<!--DHIS2-SECTION-ID:webapi_validating_payloads-->

DHIS 2 supports system wide validation of metadata payloads, which means 
that create and update operations on the API endpoints will be checked for 
valid payload before allowing changes to be made. To find out what validations 
are in place for a specific endpoint, have a look at the `/api/schemas` 
endpoint, i.e. to figure out which constraints a data element have, you 
would go to `/api/schemas/dataElement`.

You can also validate your payload manually by sending it to the proper
schema endpoint. If you wanted to validate the constant from the create
section before, you would send it like this:

    POST /api/schemas/constant

A simple (non-validating) example would be:

```bash
curl -X POST -d "{\"name\": \"some name\"}" -H "Content-Type: application/json"
  -u admin:district "https://play.dhis2.org/dev/api/schemas/dataElement"
```

Which would yield the result:

```json
[
   {
      "message" : "Required property missing.",
      "property" : "type"
   },
   {
      "property" : "aggregationOperator",
      "message" : "Required property missing."
   },
   {
      "property" : "domainType",
      "message" : "Required property missing."
   },
   {
      "property" : "shortName",
      "message" : "Required property missing."
   }
]
```

### Partial updates

<!--DHIS2-SECTION-ID:webapi_partial_updates-->

For cases where you don't want or need to update all properties on a
object (which means downloading a potentially huge payload, change one
property, then upload again) we now support partial update, for one or
more properties.

The payload for doing partial updates are the same as when you are
doing a full update, the only difference is that you only include the
properties you want to update, i.e.:

```json
{
  "name": "Updated Name",
  "zeroIsSignificant": true
}
```

An example curl command looks like this:

```bash
curl -X PATCH -d @file.json -H "Content-Type: application/json"
  -u admin:district "https://play.dhis2.org/dev/api/dataElements/fbfJHSPpUQD"
```

## Metadata export

<!--DHIS2-SECTION-ID:webapi_metadata_export-->

This section explains the metatada API which is available at
`/api/metadata`. XML and JSON resource representations are supported.

    /api/metadata

The most common parameters are described below in the "Export Parameter"
table. You can also apply this to all available types by using
`type:fields=<filter>` and `type:filter=<filter>`. You can also
enable/disable the export of certain types by setting `type=true|false`.

<table>
<caption>Export Parameter</caption>
<colgroup>
<col style="width: 17%" />
<col style="width: 21%" />
<col style="width: 61%" />
</colgroup>
<thead>
<tr class="header">
<th>Name</th>
<th>Options</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>fields</td>
<td>Same as metadata field filter</td>
<td>Default field filter to apply for all types, default is `:owner`.</td>
</tr>
<tr class="even">
<td>filter</td>
<td>Same as metadata object filter</td>
<td>Default object filter to apply for all types, default is `none`.</td>
</tr>
<tr class="odd">
<td>order</td>
<td>Same as metadata order</td>
<td>Default order to apply to all types, default is `name` if available, or `created` if not.</td>
</tr>
<tr class="even">
<td>translate</td>
<td>false/true</td>
<td>Enable translations. Be aware that this is turned off by default (in other endpoints this is on by default).</td>
</tr>
<tr class="odd">
<td>locale</td>
<td>&lt;locale&gt;</td>
<td>Change from user locale, to your own custom locale.</td>
</tr>
<tr class="even">
<td>defaults</td>
<td>INCLUDE/EXCLUDE</td>
<td>Should auto-generated category object be included or not in the payload. If you are moving metadata between 2 non-synced instances, it might make sense to set this to EXCLUDE to ease the handling of these generated objects.</td>
</tr>
<tr class="odd">
<td>skipSharing</td>
<td>false/true</td>
<td>Enabling this will strip the sharing properties from the exported objects. This includes <em>user</em>, <em>publicAccess</em>, <em>userGroupAccesses</em>, <em>userAccesses</em>, and <em>externalAccess</em>.</td>
</tr>
<tr class="odd">
<td>download</td>
<td>false/true</td>
<td>Enabling this will add HTTP header Content-Disposition that specifies that the data should be handled as an attachment and will be offered by web browsers as a download.</td>
</tr>
</tbody>
</table>

### Metadata export examples

<!--DHIS2-SECTION-ID:webapi_metadata_export_examples-->

Export all metadata. Be careful as the response might be very large depending
on your metadata configuration:

    /api/metadata

Export all metadata ordered by lastUpdated descending:

    /api/metadata?defaultOrder=lastUpdated:desc

Export metadata only including indicators and indicator groups:

    /api/metadata?indicators=true&indicatorGroups=true

Export id and displayName for all data elements, ordered by displayName:

    /api/metadata?dataElements:fields=id,name&dataElements:order=displayName:desc

Export data elements and indicators where name starts with "ANC":

    /api/metadata?filter=name:^like:ANC&dataElements=true&indicators=true

### Metadata export with dependencies

<!--DHIS2-SECTION-ID:webapi_dataset_program_export_dependencies-->

When you want to exchange metadata for a data set, program or category combo
from one DHIS2 instance to another instance there are three dedicated endpoints available:

```
/api/dataSets/{id}/metadata.json

/api/programs/{id}/metadata.json

/api/categoryCombos/{id}/metadata.json

/api/dashboards/{id}/metadata.json
```

These exports can then be imported using `/api/metadata`.

These endpoints also support the following parameters:

<table>
<caption>Export Parameter</caption>
<colgroup>
<col style="width: 17%" />
<col style="width: 21%" />
<col style="width: 61%" />
</colgroup>
<thead>
<tr class="header">
<th>Name</th>
<th>Options</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>skipSharing</td>
<td>false/true</td>
<td>Enabling this will strip the sharing properties from the exported objects. This includes <em>user</em>, <em>publicAccess</em>, <em>userGroupAccesses</em>, <em>userAccesses</em>, and <em>externalAccess</em>.</td>
</tr>
<tr class="odd">
<td>download</td>
<td>false/true</td>
<td>Enabling this will add HTTP header Content-Disposition that specifies that the data should be handled as an attachment and will be offered by web browsers as a download.</td>
</tr>
</tbody>
</table>

## Metadata import

<!--DHIS2-SECTION-ID:webapi_metadata_import-->

This section explains the metadata import API. XML and JSON resource 
representations are supported. Metadata can be imported using a *POST* request. 

    /api/metadata

The importer allows you to import metadata payloads which may include many
different entities and any number of objects per entity. The metadata export
generated by the metadata export API can be imported directly.

The metadata import endpoint support a variety of parameters, which are 
listed below.

<table>
<caption>Import Parameter</caption>
<colgroup>
<col style="width: 17%" />
<col style="width: 21%" />
<col style="width: 61%" />
</colgroup>
<thead>
<tr class="header">
<th>Name</th>
<th>Options (first is default)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>importMode</td>
<td>COMMIT, VALIDATE</td>
<td>Sets overall import mode, decides whether or not to only `VALIDATE` or also `COMMIT` the metadata, this has similar functionality as our old dryRun flag.</td>
</tr>
<tr class="even">
<td>identifier</td>
<td>UID, CODE, AUTO</td>
<td>Sets the identifier scheme to use for reference matching. `AUTO` means try `UID` first, then `CODE`.</td>
</tr>
<tr class="odd">
<td>importReportMode</td>
<td>ERRORS, FULL, DEBUG</td>
<td>Sets the `ImportReport` mode, controls how much is reported back after the import is done. `ERRORS` only includes <em>ObjectReports</em> for object which has errors. `FULL` returns an <em>ObjectReport</em> for all objects imported, and `DEBUG` returns the same plus a name for the object (if available).</td>
</tr>
<tr class="even">
<td>preheatMode</td>
<td>REFERENCE, ALL, NONE</td>
<td>Sets the preheater mode, used to signal if preheating should be done for `ALL` (as it was before with <em>preheatCache=true</em>) or do a more intelligent scan of the objects to see what to preheat (now the default), setting this to `NONE` is not recommended.</td>
</tr>
<tr class="odd">
<td>importStrategy</td>
<td>CREATE_AND_UPDATE, CREATE, UPDATE, DELETE</td>
<td>Sets import strategy, `CREATE_AND_UPDATE` will try and match on identifier, if it doesn't exist, it will create the object.</td>
</tr>
<tr class="even">
<td>atomicMode</td>
<td>ALL, NONE</td>
<td>Sets atomic mode, in the old importer we always did a <em>best effort</em> import, which means that even if some references did not exist, we would still import (i.e. missing data elements on a data element group import). Default for new importer is to not allow this, and similar reject any validation errors. Setting the `NONE` mode emulated the old behavior.</td>
</tr>
<tr class="odd">
<td>mergeMode</td>
<td>REPLACE, MERGE</td>
<td>Sets the merge mode, when doing updates we have two ways of merging the old object with the new one, `MERGE` mode will only overwrite the old property if the new one is not-null, for `REPLACE` mode all properties are overwritten regardless of null or not.</td>
</tr>
<tr class="even">
<td>flushMode</td>
<td>AUTO, OBJECT</td>
<td>Sets the flush mode, which controls when to flush the internal cache. It is <em>strongly</em> recommended to keep this to `AUTO` (which is the default). Only use `OBJECT` for debugging purposes, where you are seeing hibernate exceptions and want to pinpoint the exact place where the stack happens (hibernate will only throw when flushing, so it can be hard to know which object had issues).</td>
</tr>
<tr class="odd">
<td>skipSharing</td>
<td>false, true</td>
<td>Skip sharing properties, does not merge sharing when doing updates, and does not add user group access when creating new objects.</td>
</tr>
<tr class="even">
<td>skipValidation</td>
<td>false, true</td>
<td>Skip validation for import. `NOT RECOMMENDED`.</td>
</tr>
<tr class="odd">
<td>async</td>
<td>false, true</td>
<td>Asynchronous import, returns immediately with a <em>Location</em> header pointing to the location of the <em>importReport</em>. The payload also contains a json object of the job created.</td>
</tr>
<tr class="even">
<td>inclusionStrategy</td>
<td>NON_NULL, ALWAYS, NON_EMPTY</td>
<td><em>NON_NULL</em> includes properties which are not null, <em>ALWAYS</em> include all properties, <em>NON_EMPTY</em> includes non empty properties (will not include strings of 0 length, collections of size 0, etc.)</td>
</tr>
<tr class="odd">
<td>userOverrideMode</td>
<td>NONE, CURRENT, SELECTED</td>
<td>Allows you to override the user property of every object you are importing, the options are NONE (do nothing), CURRENT (use import user), SELECTED (select a specific user using overrideUser=X)</td>
</tr>
<tr class="even">
<td>overrideUser</td>
<td>User ID</td>
<td>If userOverrideMode is SELECTED, use this parameter to select the user you want override with.</td>
</tr>
</tbody>
</table>

An example of a metadata payload to be imported looks like this. Note how
each entity type have their own property with an array of objects:

```json
{
  "dataElements": [
    {
      "name": "EPI - IPV 3 doses given",
      "shortName": "EPI - IPV 3 doses given",
      "aggregationType": "SUM",
      "domainType": "AGGREGATE",
      "valueType": "INTEGER_ZERO_OR_POSITIVE"
    },
    {
      "name": "EPI - IPV 4 doses given",
      "shortName": "EPI - IPV 4 doses given",
      "aggregationType": "SUM",
      "domainType": "AGGREGATE",
      "valueType": "INTEGER_ZERO_OR_POSITIVE"
    }
  ],
  "indicators": [
    {
      "name": "EPI - ADS stock used",
      "shortName": "ADS stock used",
      "numerator": "#{LTb8XeeqeqI}+#{Fs28ZQJET6V}-#{A3mHIZd2tPg}",
      "numeratorDescription": "ADS 0.05 ml used",
      "denominator": "1",
      "denominatorDescription": "1",
      "annualized": false,
      "indicatorType": {
        "id": "kHy61PbChXr"
      }
    }
  ]
}
```

When posting this payload to the metadata endpoint, the response will contain
information about the parameters used during the import and a summary per
entity type including how many objects were created, updated, deleted and
ignored:

```json
{
  "importParams": {
    "userOverrideMode": "NONE",
    "importMode": "COMMIT",
    "identifier": "UID",
    "preheatMode": "REFERENCE",
    "importStrategy": "CREATE_AND_UPDATE",
    "atomicMode": "ALL",
    "mergeMode": "REPLACE",
    "flushMode": "AUTO",
    "skipSharing": false,
    "skipTranslation": false,
    "skipValidation": false,
    "metadataSyncImport": false,
    "firstRowIsHeader": true,
    "username": "UNICEF_admin"
  },
  "status": "OK",
  "typeReports": [
    {
      "klass": "org.hisp.dhis.dataelement.DataElement",
      "stats": {
        "created": 2,
        "updated": 0,
        "deleted": 0,
        "ignored": 0,
        "total": 2
      }
    },
    {
      "klass": "org.hisp.dhis.indicator.Indicator",
      "stats": {
        "created": 1,
        "updated": 0,
        "deleted": 0,
        "ignored": 0,
        "total": 1
      }
    }
  ],
  "stats": {
    "created": 3,
    "updated": 0,
    "deleted": 0,
    "ignored": 0,
    "total": 3
  }
}
```

## Metadata audit

<!--DHIS2-SECTION-ID:webapi_metadata_audit-->

If you need information about who created, edited, or deleted DHIS2
metadata objects you can enable metadata audit. There are two
configuration options (dhis.conf) you can enable to support this:

```properties
metadata.audit.log = on
```

This enables additional log output in your servlet container (e.g.
tomcat catalina.log) which contains full information about the object
created, object edited, or object deleted including full JSON payload,
date of audit event, and the user who did the action.

```properties
metadata.audit.persist = on
```

This enables persisted audits, i.e. audits saved to the database. The
information stored is the same as with audit log; however this
information is now placed into the *metadataaudit* table in the
database.

We do not recommended enabling these options on a empty database if you
intend to bootstrap your system, as it slows down the import and the
audit might not be that useful.

### Metadata audit query

<!--DHIS2-SECTION-ID:webapi_metadata_audit_query-->

If you have enabled persisted metadata audits on your DHIS2 instance,
you can access metadata audits at the following endpoint:

    /api/33/metadataAudits

The endpoints supports the following query parameters:

<table>
<caption>Metadata audit API query parameters</caption>
<colgroup>
<col style="width: 22%" />
<col style="width: 27%" />
<col style="width: 51%" />
</colgroup>
<thead>
<tr class="header">
<th>Name</th>
<th>Values</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>uid</td>
<td></td>
<td>Object uid to query by (can be more than one)</td>
</tr>
<tr class="even">
<td>code</td>
<td></td>
<td>Object code to query by (can be more than one)</td>
</tr>
<tr class="odd">
<td>klass</td>
<td></td>
<td>Object class to query by (can be more than one), please note that the full java package name is required here (to avoid name collisions)</td>
</tr>
<tr class="even">
<td>createdAt</td>
<td></td>
<td>Query by creation date</td>
</tr>
<tr class="odd">
<td>createdBy</td>
<td></td>
<td>Query by who made the change (username)</td>
</tr>
<tr class="even">
<td>type</td>
<td>CREATE, UPDATE, DELETE</td>
<td>Query by audit type</td>
</tr>
</tbody>
</table>

## Render type (Experimental)

<!--DHIS2-SECTION-ID:webapi_render_type-->

Some metadata types have a property named *renderType*. The render type
property is a map between a *device* and a *renderingType*. Applications
can use this information as a hint on how the object should be rendered
on a specific device. For example, a mobile device might want to render
a data element differently than a desktop computer.

There is currently two different kinds of renderingTypes available:

1.  Value type rendering

2.  Program stage section rendering

There is also 2 device types available:

1.  MOBILE

2.  DESKTOP

The following table lists the metadata and rendering types available.
The value type rendering has addition constraints based on the metadata
configuration, which will be shown in a second table.

<table>
<caption>Metadata and RenderingType overview</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>Metadata type</th>
<th>Available RenderingTypes</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Program Stage Section</td>
<td><ul>
<li><p>LISTING (default)</p></li>
<li><p>SEQUENTIAL</p></li>
<li><p>MATRIX</p></li>
</ul></td>
</tr>
<tr class="even">
<td>Data element</td>
<td><ul>
<li><p>DEFAULT</p></li>
<li><p>DROPDOWN</p></li>
<li><p>VERTICAL_RADIOBUTTONS</p></li>
<li><p>HORIZONTAL_RADIOBUTTONS</p></li>
<li><p>VERTICAL_CHECKBOXES</p></li>
<li><p>HORIZONTAL_CHECKBOXES</p></li>
<li><p>SHARED_HEADER_RADIOBUTTONS</p></li>
<li><p>ICONS_AS_BUTTONS</p></li>
<li><p>SPINNER</p></li>
<li><p>ICON</p></li>
<li><p>TOGGLE</p></li>
<li><p>VALUE</p></li>
<li><p>SLIDER</p></li>
<li><p>LINEAR_SCALE</p></li>
</ul></td>
</tr>
</tbody>
</table>

Since handling the default rendering of data elements and tracked entity
attributes are depending on the value type of the object, there is also
a DEFAULT type to tell the client it should be handled as normal.
Program Stage Section is LISTING as default.

<table>
<caption>RenderingTypes allowed based on value types</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Value type</th>
<th>Is object an optionset?</th>
<th>RenderingTypes allowed</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>TRUE_ONLY</td>
<td>No</td>
<td>DEFAULT, VERTICAL_RADIOBUTTONS, HORIZONTAL_RADIOBUTTONS, VERTICAL_CHECKBOXES, HORIZONTAL_CHECKBOXES, TOGGLE</td>
</tr>
<tr class="even">
<td>BOOLEAN</td>
<td>No</td>
<td></td>
</tr>
<tr class="odd">
<td>-</td>
<td>Yes</td>
<td>DEFAULT, DROPDOWN, VERTICAL_RADIOBUTTONS, HORIZONTAL_RADIOBUTTONS, VERTICAL_CHECKBOXES, HORIZONTAL_CHECKBOXES, SHARED_HEADER_RADIOBUTTONS, ICONS_AS_BUTTONS, SPINNER, ICON</td>
</tr>
<tr class="even">
<td>INTEGER</td>
<td>No</td>
<td>DEFAULT, VALUE, SLIDER, LINEAR_SCALE, SPINNER</td>
</tr>
<tr class="odd">
<td>INTEGER_POSITIVE</td>
<td>No</td>
<td></td>
</tr>
<tr class="even">
<td>INTEGER_NEGATIVE</td>
<td>No</td>
<td></td>
</tr>
<tr class="odd">
<td>INTEGER_ZERO_OR_POSITIVE</td>
<td>No</td>
<td></td>
</tr>
<tr class="even">
<td>NUMBER</td>
<td>No</td>
<td></td>
</tr>
<tr class="odd">
<td>UNIT_INTERVAL</td>
<td>No</td>
<td></td>
</tr>
<tr class="even">
<td>PERCENTAGE</td>
<td>No</td>
<td></td>
</tr>
</tbody>
</table>

A complete reference of the previous table can also be retrieved using
the following endpoint:

    GET /api/staticConfiguration/renderingOptions

Value type rendering also has some additional properties that can be
set, which is usually needed when rendering some of the specific types:

<table>
<caption>renderType object properties</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
<th>Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>type</td>
<td>The RenderingType of the object, as seen in the first table. This property is the same for both value type and program stage section, but is the only property available for program stage section.</td>
<td>Enum (See list in the Metadata and Rendering Type table)</td>
</tr>
<tr class="even">
<td>min</td>
<td>Only for value type rendering. Represents the minimum value this field can have.</td>
<td>Integer</td>
</tr>
<tr class="odd">
<td>max</td>
<td>Only for value type rendering. Represents the maximum value this field can have.</td>
<td>Integer</td>
</tr>
<tr class="even">
<td>step</td>
<td>Only for value type rendering. Represents the size of the steps the value should increase, for example for SLIDER og LINEAR_SCALE</td>
<td>Integer</td>
</tr>
<tr class="odd">
<td>decimalPoints</td>
<td>Only for value type rendering. Represents the number of decimal points the value should use.</td>
<td>Integer</td>
</tr>
</tbody>
</table>

The *renderingType* can be set when creating or updating the metadata listed in the first table. An example payload for the rendering type for program stage section looks like this:

```json
{
  "renderingType": {
    "type": "MATRIX"
  }
}
```

For data element and tracked entity attribute:

```json
{
  "renderingType": {
    "type": "SLIDER",
    "min": 0,
    "max": 1000,
    "step": 50,
    "decimalPoints": 0
  }
}
```

## Object Style

<!--DHIS2-SECTION-ID:webapi_object_style-->

Most metadata have a property names "style". This property can be used
by clients to represent the object in a certain way. The properties
currently supported by style is as follows:

<table>
<caption>Style properties</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
<th>Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>color</td>
<td>A color, represented by a hexadecimal.</td>
<td>String (#000000)</td>
</tr>
<tr class="even">
<td>icon</td>
<td>An icon, represented by a icon-name.</td>
<td>String</td>
</tr>
</tbody>
</table>

Currently, there is no official list or support for icon-libraries, so
this is currently up to the client to provide. The following list shows
all objects that support style:

  - Data element

  - Data element category option

  - Data set

  - Indicator

  - Option

  - Program

  - Program Indicator

  - Program Section

  - Program Stage

  - Program Stage Section

  - Relationship (Tracker)

  - Tracked Entity Attribute

  - Tracked Entity Type

When creating or updating any of these objects, you can include the
following payload to change the style:

```json
{
  "style": {
    "color": "#ffffff",
    "icon": "my-beautiful-icon"
  }
}
```

## ActiveMQ Artemis / AMQP 1.0 integration

<!--DHIS2-SECTION-ID:webapi_amqp_integration-->

By default DHIS2 will start up an embedded instance of ActiveMQ Artemis when the
instance is booting up. For most use-cases, you do not need to configure anything
to make use of this, but if your infrastructure have an existing AMQP 1.0 compliant
service you want to use, you can change the defaults in your *dhis.conf* file using
the keys in the table down below.

<table>
  <caption>
    AMQP Configuration Keys
  </caption>
  <colgroup>
    <col style="width: 15%" />
    <col style="width: 30%" />
    <col style="width: 55%" />
  </colgroup>
  <thead>
    <tr class="header">
      <th>Key</th>
      <th>Value (default first)</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr class="odd">
      <td>amqp.mode</td>
      <td><code>EMBEDDED</code> | <code>NATIVE</code></td>
      <td>The default <code>EMBEDDED</code> starts up an internal AMQP service when the
      DHIS2 instance is starting up. If you want to connect to an external AMQP service
      you need to set the mode to <code>NATIVE</code>.</td>
    </tr>
    <tr class="odd">
      <td>amqp.host</td>
      <td><code>127.0.0.1</code></td>
      <td>Host to bind to.</td>
    </tr>
    <tr class="even">
      <td>amqp.port</td>
      <td><code>15672</code></td>
      <td>If mode is <code>EMBEDDED</code> then start the embedded server on this port,
      if <code>NATIVE</code> then the client will use this port to connect to.</td>
    </tr>
    <tr class="odd">
      <td>amqp.username</td>
      <td><code>guest</code></td>
      <td>Username to connect to if using <code>NATIVE</code> mode.</td>
    </tr>
    <tr class="even">
      <td>amqp.password</td>
      <td><code>guest</code></td>
      <td>Password to connect to if using <code>NATIVE</code> mode.</td>
    </tr>
    <tr class="odd">
      <td>amqp.embedded.persistence</td>
      <td><code>false</code> | <code>true</code></td>
      <td>If mode is <code>EMBEDDED</code>, this property controls persistence of
      the internal queue.</td>
    </tr>
  </tbody>
</table>

## CSV metadata import

<!--DHIS2-SECTION-ID:webapi_csv_metadata_import-->

DHIS2 supports import of metadata in the CSV format, such as data elements, organisation units and validation rules. Properties for the various metadata objects are identified based on the column order/column index (see below for details). You can omit non-required object properties/columns, but since the column order is significant, an empty column must be included. In other words, if you would like to specify properties/columns which appear late in the column order but not specify certain columns which appear early in the order you can include empty/blank columns for them.

The first row of the CSV file is considered to be a header and is ignored during import. The _comma_ character should be used as a text delimiter. Text which contains commas must be enclosed in _double quotes_.

To upload metadata in CSV format you can make a POST request to the metadata endpoint:

    POST /api/metadata?classKey=CLASS-KEY

The following object types are supported. The `classKey` query parameter is mandatory and can be found next to each object type in the table below.

<table>
<caption>Object types and keys</caption>
<tr>
<th>Object type</th>
<th>Class key</th>
</tr>
<tr>
<td>Data elements</td>
<td>DATA_ELEMENT</td>
</tr>
<tr>
<td>Data element groups</td>
<td>DATA_ELEMENT_GROUP
</tr>
<tr>
<td>Category options</td>
<td>CATEGORY_OPTION</td>
</tr>
<tr>
<td>Category option groups</td>
<td>CATEGORY_OPTION_GROUP</td>
</tr>
<tr>
<td>Organisation units</td>
<td>ORGANISATION_UNIT</td>
</tr>
<tr>
<td>Organisation unit groups</td>
<td>ORGANISATION_UNIT_GROUP</td>
</tr>
<tr>
<td>Validation rules</td>
<td>VALIDATION_RULE</td>
</tr>
<tr>
<td>Option sets</td>
<td>OPTION_SET</td>
</tr>
<tr>
<td>Translations</td>
<td>TRANSLATION</td>
</tr>
</table>

> **Tip**
>
> If using *curl*, the `--data-binary` option should be used as it preserves line breaks and newlines, which is essential for CSV data.

As an example, to upload a file of data elements in CSV format with `curl` you can use the following command:

```bash
curl --data-binary @data_elements.csv "http://localhost/api/metadata?classKey=DATA_ELEMENT"
  -H "Content-Type:application/csv" -u admin:district
```

The formats for the currently supported object types for CSV import are listed in the following sections.

### Data elements

<!--DHIS2-SECTION-ID:webapi_csv_data_elements-->

<table>
<caption>Data Element CSV Format</caption>
<colgroup>
<col />
<col style="width: 13%" />
<col style="width: 7%" />
<col style="width: 27%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>Index</th>
<th>Column</th>
<th>Required</th>
<th>Value (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>Name</td>
<td>Yes</td>
<td></td>
<td>Name. Max 230 char. Unique.</td>
</tr>
<tr class="even">
<td>2</td>
<td>UID</td>
<td>No</td>
<td>UID</td>
<td>Stable identifier. Exactly 11 alpha-numeric characters, beginning with a character. Will be generated by system if not specified.</td>
</tr>
<tr class="odd">
<td>3</td>
<td>Code</td>
<td>No</td>
<td></td>
<td>Stable code. Max 50 char.</td>
</tr>
<tr class="even">
<td>4</td>
<td>Short name</td>
<td>No</td>
<td>50 first char of name</td>
<td>Will fall back to first 50 characters of name if unspecified. Max 50 char. Unique.</td>
</tr>
<tr class="odd">
<td>5</td>
<td>Description</td>
<td>No</td>
<td></td>
<td>Free text description.</td>
</tr>
<tr class="even">
<td>6</td>
<td>Form name</td>
<td>No</td>
<td></td>
<td>Max 230 char.</td>
</tr>
<tr class="odd">
<td>7</td>
<td>Domain type</td>
<td>No</td>
<td>AGGREGATE | TRACKER</td>
<td>Domain type for data element, can be aggregate or tracker. Max 16 char.</td>
</tr>
<tr class="even">
<td>8</td>
<td>Value type</td>
<td>No</td>
<td>INTEGER | NUMBER | UNIT_INTERVAL | PERCENTAGE | INTEGER_POSITIVE | INTEGER_NEGATIVE | INTEGER_ZERO_OR_POSITIVE | FILE_RESOURCE | COORDINATE |TEXT | LONG_TEXT | LETTER | PHONE_NUMBER | EMAIL | BOOLEAN | TRUE_ONLY | DATE | DATETIME</td>
<td>Value type. Max 16 char.</td>
</tr>
<tr class="odd">
<td>9</td>
<td>Aggregation type</td>
<td>No</td>
<td>SUM | AVERAGE | AVERAGE_SUM_ORG_UNIT | COUNT | STDDEV | VARIANCE | MIN | MAX | NONE</td>
<td>Aggregation type indicating how to aggregate data in various dimensions. Max 16 char.</td>
</tr>
<tr class="even">
<td>10</td>
<td>Category combination</td>
<td>No</td>
<td>UID</td>
<td>UID of category combination. Will default to default category combination if not specified.</td>
</tr>
<tr class="odd">
<td>11</td>
<td>Url</td>
<td>No</td>
<td></td>
<td>URL to data element resource. Max 255 char.</td>
</tr>
<tr class="even">
<td>12</td>
<td>Zero is significant</td>
<td>No</td>
<td>false | true</td>
<td>Indicates whether zero values will be stored for this data element.</td>
</tr>
<tr class="odd">
<td>13</td>
<td>Option set</td>
<td>No</td>
<td>UID</td>
<td>UID of option set to use for data.</td>
</tr>
<tr class="even">
<td>14</td>
<td>Comment option set</td>
<td>No</td>
<td>UID</td>
<td>UID of option set to use for comments.</td>
</tr>
</tbody>
</table>

An example of a CSV file for data elements can be seen below. The first
row will always be ignored. Note how you can skip columns and rely on
default values to be used by the system. You can also skip columns which
you do not use which appear to the right of the ones

```csv
name,uid,code,shortname,description
"Women participated skill development training",,"D0001","Women participated in training"
"Women participated community organizations",,"D0002","Women participated in organizations"
```

### Organisation units

<!--DHIS2-SECTION-ID:webapi_csv_org_units-->

<table>
<caption>Organisation Unit CSV Format</caption>
<colgroup>
<col />
<col style="width: 14%" />
<col style="width: 10%" />
<col style="width: 21%" />
<col style="width: 53%" />
</colgroup>
<thead>
<tr class="header">
<th>Index</th>
<th>Column</th>
<th>Required</th>
<th>Value (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>Name</td>
<td>Yes</td>
<td></td>
<td>Name. Max 230 characters. Unique.</td>
</tr>
<tr class="even">
<td>2</td>
<td>UID</td>
<td>No</td>
<td>UID</td>
<td>Stable identifier. Max 11 char. Will be generated by system if not specified.</td>
</tr>
<tr class="odd">
<td>3</td>
<td>Code</td>
<td>No</td>
<td></td>
<td>Stable code. Max 50 char.</td>
</tr>
<tr class="even">
<td>4</td>
<td>Parent</td>
<td>No</td>
<td>UID</td>
<td>UID of parent organisation unit.</td>
</tr>
<tr class="odd">
<td>5</td>
<td>Short name</td>
<td>No</td>
<td>50 first char of name</td>
<td>Will fall back to first 50 characters of name if unspecified. Max 50 characters. Unique.</td>
</tr>
<tr class="even">
<td>6</td>
<td>Description</td>
<td>No</td>
<td></td>
<td>Free text description.</td>
</tr>
<tr class="odd">
<td>7</td>
<td>Opening date</td>
<td>No</td>
<td>1970-01-01</td>
<td>Opening date of organisation unit in YYYY-MM-DD format.</td>
</tr>
<tr class="even">
<td>8</td>
<td>Closed date</td>
<td>No</td>
<td></td>
<td>Closed date of organisation unit in YYYY-MM-DD format, skip if currently open.</td>
</tr>
<tr class="odd">
<td>9</td>
<td>Comment</td>
<td>No</td>
<td></td>
<td>Free text comment for organisation unit.</td>
</tr>
<tr class="even">
<td>10</td>
<td>Feature type</td>
<td>No</td>
<td>NONE | MULTI_POLYGON | POLYGON | POINT | SYMBOL</td>
<td>Geospatial feature type.</td>
</tr>
<tr class="odd">
<td>11</td>
<td>Coordinates</td>
<td>No</td>
<td></td>
<td>Coordinates used for geospatial analysis in Geo JSON format.</td>
</tr>
<tr class="even">
<td>12</td>
<td>URL</td>
<td>No</td>
<td></td>
<td>URL to organisation unit resource. Max 255 char.</td>
</tr>
<tr class="odd">
<td>13</td>
<td>Contact person</td>
<td>No</td>
<td></td>
<td>Contact person for organisation unit. Max 255 char.</td>
</tr>
<tr class="even">
<td>14</td>
<td>Address</td>
<td>No</td>
<td></td>
<td>Address for organisation unit. Max 255 char.</td>
</tr>
<tr class="odd">
<td>15</td>
<td>Email</td>
<td>No</td>
<td></td>
<td>Email for organisation unit. Max 150 char.</td>
</tr>
<tr class="even">
<td>16</td>
<td>Phone number</td>
<td>No</td>
<td></td>
<td>Phone number for organisation unit. Max 150 char.</td>
</tr>
</tbody>
</table>

A minimal example for importing organisation units with a parent unit
looks like this:

```csv
name,uid,code,parent
"West province",,"WESTP","ImspTQPwCqd"
"East province",,"EASTP","ImspTQPwCqd"
```

### Validation rules

<!--DHIS2-SECTION-ID:webapi_csv_validation_rules-->

<table>
<caption>Validation Rule CSV Format</caption>
<colgroup>
<col />
<col style="width: 17%" />
<col style="width: 7%" />
<col style="width: 28%" />
<col style="width: 46%" />
</colgroup>
<thead>
<tr class="header">
<th>Index</th>
<th>Column</th>
<th>Required</th>
<th>Value (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>Name</td>
<td>Yes</td>
<td></td>
<td>Name. Max 230 characters. Unique.</td>
</tr>
<tr class="even">
<td>2</td>
<td>UID</td>
<td>No</td>
<td>UID</td>
<td>Stable identifier. Max 11 char. Will be generated by system if not specified.</td>
</tr>
<tr class="odd">
<td>3</td>
<td>Code</td>
<td>No</td>
<td></td>
<td>Stable code. Max 50</td>
</tr>
<tr class="even">
<td>4</td>
<td>Description</td>
<td>No</td>
<td></td>
<td>Free text description.</td>
</tr>
<tr class="odd">
<td>5</td>
<td>Instruction</td>
<td>No</td>
<td></td>
<td>Free text instruction.</td>
</tr>
<tr class="even">
<td>6</td>
<td>Importance</td>
<td>No</td>
<td>MEDIUM | HIGH | LOW</td>
<td>Importance of validation rule.</td>
</tr>
<tr class="odd">
<td>7</td>
<td>Rule type (ignored)</td>
<td>No</td>
<td>VALIDATION | SURVEILLANCE</td>
<td>Type of validation rule.</td>
</tr>
<tr class="even">
<td>8</td>
<td>Operator</td>
<td>No</td>
<td>equal_to | not_equal_to | greater_than | greater_than_or_equal_to | less_than | less_than_or_equal_to | compulsory_pair | exclusive_pair</td>
<td>Expression operator.</td>
</tr>
<tr class="odd">
<td>9</td>
<td>Period type</td>
<td>No</td>
<td>Monthly | Daily | Weekly | Quarterly | SixMontly | Yearly</td>
<td>Period type.</td>
</tr>
<tr class="even">
<td>10</td>
<td>Left side expression</td>
<td>Yes</td>
<td></td>
<td>Mathematical formula based on data element and option combo UIDs.</td>
</tr>
<tr class="odd">
<td>11</td>
<td>Left side expression description</td>
<td>Yes</td>
<td></td>
<td>Free text.</td>
</tr>
<tr class="even">
<td>12</td>
<td>Left side missing value strategy</td>
<td>No</td>
<td>SKIP_IF_ANY_VALUE_MISSING | SKIP_IF_ALL_VALUES_MISSING | NEVER_SKIP</td>
<td>Behavior in case of missing values in left side expression.</td>
</tr>
<tr class="odd">
<td>13</td>
<td>Right side expression</td>
<td>Yes</td>
<td></td>
<td>Mathematical formula based on data element and option combo UIDs.</td>
</tr>
<tr class="even">
<td>14</td>
<td>Right side expression description</td>
<td>Yes</td>
<td></td>
<td>Free text.</td>
</tr>
<tr class="odd">
<td>15</td>
<td>Right side missing value strategy</td>
<td>No</td>
<td>SKIP_IF_ANY_VALUE_MISSING | SKIP_IF_ALL_VALUES_MISSING | NEVER_SKIP</td>
<td>Behavior in case of missing values in right side expression.</td>
</tr>
</tbody>
</table>

### Option sets

<!--DHIS2-SECTION-ID:webapi_csv_option_sets-->

<table style="width:100%;">
<caption>Option Set CSV Format</caption>
<colgroup>
<col />
<col style="width: 14%" />
<col style="width: 11%" />
<col style="width: 15%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th>Index</th>
<th>Column</th>
<th>Required</th>
<th>Value (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>OptionSetName</td>
<td>Yes</td>
<td></td>
<td>Name. Max 230 characters. Unique. Should be repeated for each option.</td>
</tr>
<tr class="even">
<td>2</td>
<td>OptionSetUID</td>
<td>No</td>
<td>UID</td>
<td>Stable identifier. Max 11 char. Will be generated by system if not specified. Should be repeated for each option.</td>
</tr>
<tr class="odd">
<td>3</td>
<td>OptionSetCode</td>
<td>No</td>
<td></td>
<td>Stable code. Max 50 char. Should be repeated for each option.</td>
</tr>
<tr class="even">
<td>4</td>
<td>OptionName</td>
<td>Yes</td>
<td></td>
<td>Option name. Max 230 characters.</td>
</tr>
<tr class="odd">
<td>5</td>
<td>OptionUID</td>
<td>No</td>
<td>UID</td>
<td>Stable identifier. Max 11 char. Will be generated by system if not specified.</td>
</tr>
<tr class="even">
<td>6</td>
<td>OptionCode</td>
<td>Yes</td>
<td></td>
<td>Stable code. Max 50 char.</td>
</tr>
</tbody>
</table>

The format for option sets is special. The three first values represent
an option set. The three last values represent an option. The first
three values representing the option set should be repeated for each
option.

```csv
optionsetname,optionsetuid,optionsetcode,optionname,optionuid,optioncode
"Color",,"COLOR","Blue",,"BLUE"
"Color",,"COLOR","Green",,"GREEN"
"Color",,"COLOR","Yellow",,"YELLOW"
"Sex",,,"Male",,"MALE"
"Sex",,,"Female",,"FEMALE"
"Sex",,,"Unknown",,"UNKNOWN"
"Result",,,"High",,"HIGH"
"Result",,,"Medium",,"MEDIUM"
"Result",,,"Low",,"LOW"
"Impact","cJ82jd8sd32","IMPACT","Great",,"GREAT"
"Impact","cJ82jd8sd32","IMPACT","Medium",,"MEDIUM"
"Impact","cJ82jd8sd32","IMPACT","Poor",,"POOR"
```

### Option group

<table style="width:100%;">
<caption>Option Group CSV Format</caption>
<colgroup>
<col />
<col style="width: 14%" />
<col style="width: 11%" />
<col style="width: 15%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th>Index</th>
<th>Column</th>
<th>Required</th>
<th>Value (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>OptionGroupName</td>
<td>Yes</td>
<td>Name. Max 230 characters. Unique. Should be repeated for each option.</td>
</tr>
<tr class="even">
<td>2</td>
<td>OptionGroupUid</td>
<td>No</td>
<td>Stable identifier. Max 11 char. Will be generated by system if not specified. Should be repeated for each option.</td>
</tr>
<tr class="odd">
<td>3</td>
<td>OptionGroupCode</td>
<td>No</td>
<td>Stable code. Max 50 char. Should be repeated for each option.</td>
</tr>
<tr class="even">
<td>4</td>
<td>OptionGroupShortName</td>
<td>Yes</td>
<td>Short Name. Max 50 characters. Unique. Should be repeated for each option.</td>
</tr>
<tr class="odd">
<td>5</td>
<td>OptionSetUid</td>
<td>Yes</td>
<td>Stable identifier. Max 11 char. Should be repeated for each option.</td>
</tr>
<tr class="even">
<td>6</td>
<td>OptionUid</td>
<td>No</td>
<td>Stable identifier. Max 11 char.</td>
</tr>
<tr class="odd">
<td>7</td>
<td>OptionCode</td>
<td>No</td>
<td>Stable code. Max 50 char.</td>
</tr>
</tbody>
</table>

Sample OptionGroup CSV payload

```csv
optionGroupName,optionGroupUid,optionGroupCode,optionGroupShortName,optionSetUid,optionUid,optionCode
optionGroupA,,,groupA,xmRubJIhmaK,,OptionA
optionGroupA,,,groupA,xmRubJIhmaK,,OptionB
optionGroupB,,,groupB,QYDAByFgTr1,,OptionC
```
### Option Group Set

<table style="width:100%;">
<caption>Option Group Set CSV Format</caption>
<colgroup>
<col />
<col style="width: 14%" />
<col style="width: 11%" />
<col style="width: 15%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th>Index</th>
<th>Column</th>
<th>Required</th>
<th>Value (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>OptionGroupSetName</td>
<td>Yes</td>
<td>Name. Max 230 characters. Unique. Should be repeated for each option.</td>
</tr>
<tr class="even">
<td>2</td>
<td>OptionGroupSetUid</td>
<td>No</td>
<td>Stable identifier. Max 11 char. Will be generated by system if not specified. Should be repeated for each option.</td>
</tr>
<tr class="odd">
<td>3</td>
<td>OptionGroupSetCode</td>
<td>No</td>
<td>Stable code. Max 50 char. Should be repeated for each option.</td>
</tr>
<tr class="even">
<td>4</td>
<td>OptionGroupSetDescription</td>
<td>No</td>
<td>Description. Should be repeated for each option.</td>
</tr>
<tr class="odd">
<td>5</td>
<td>DataDimension</td>
<td>No</td>
<td>TRUE, FALSE</td>
</tr>
<tr class="even">
<td>6</td>
<td>OptionSetUid</td>
<td>No</td>
<td>OptionSet UID. Stable identifier. Max 11 char.</td>
</tr>
</tbody>
</table>

Sample OptionGroupSet CSV payload

```csv
name,uid,code,description,datadimension,optionsetuid
optiongroupsetA,,,,,xmRubJIhmaK
optiongroupsetB,,,,false,QYDAByFgTr1
```
To add OptionGroups to an imported OptionGroupSet, follow the steps as importing collection membership 

### Collection membership

In addition to importing objects, you can also choose to only import the
group-member relationship between an object and a group. Currently, the
following group and object pairs are supported

  - Organisation Unit Group - Organisation Unit

  - Data Element Group - Data Element

  - Indicator Group - Indicator
  
  - Option Group Set - Option Group

The CSV format for these imports are the same

<table>
<caption>Collection membership CSV Format</caption>
<colgroup>
<col />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th>Index</th>
<th>Column</th>
<th>Required</th>
<th>Value (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>UID</td>
<td>Yes</td>
<td>UID</td>
<td>The UID of the collection to add an object to</td>
</tr>
<tr class="even">
<td>2</td>
<td>UID</td>
<td>Yes</td>
<td>UID</td>
<td>The UID of the object to add to the collection</td>
</tr>
</tbody>
</table>

### Other objects

<!--DHIS2-SECTION-ID:webapi_csv_other_objects-->

<table>
<caption>Data Element Group, Category Option, Category Option Group, Organisation Unit Group CSV Format</caption>
<colgroup>
<col />
<col style="width: 17%" />
<col style="width: 12%" />
<col style="width: 14%" />
<col style="width: 55%" />
</colgroup>
<thead>
<tr class="header">
<th>Index</th>
<th>Column</th>
<th>Required</th>
<th>Value (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>Name</td>
<td>Yes</td>
<td></td>
<td>Name. Max 230 characters. Unique.</td>
</tr>
<tr class="even">
<td>2</td>
<td>UID</td>
<td>No</td>
<td>UID</td>
<td>Stable identifier. Max 11 chars. Will be generated by system if not specified.</td>
</tr>
<tr class="odd">
<td>3</td>
<td>Code</td>
<td>No</td>
<td></td>
<td>Stable code. Max 50 char.</td>
</tr>
<tr class="even">
<td>4</td>
<td>Short name</td>
<td>No</td>
<td></td>
<td>Short name. Max 50 characters.</td>
</tr>
</tbody>
</table>

An example of category options looks like this:

```csv
name,uid,code,shortname
"Male",,"MALE"
"Female",,"FEMALE"
```

## Deleted objects

<!--DHIS2-SECTION-ID:webapi_deleted_objects-->

The deleted objects resource provides a log of metadata objects being
deleted.

    /api/deletedObjects

Whenever an object of type metadata is deleted, a log is being kept of
the uid, code, the type and the time of when it was deleted. This API is
available at `/api/deletedObjects` field filtering and object filtering
works similarly to other metadata resources.

Get deleted objects of type data elements:

    GET /api/deletedObjects.json?klass=DataElement

Get deleted object of type indicator which was deleted in 2015 and
forward:

    GET /api/deletedObjects.json?klass=Indicator&deletedAt=2015-01-01

## Favorites

<!--DHIS2-SECTION-ID:webapi_favorites-->

Certain types of metadata objects can be marked as favorites for the
currently logged in user. This applies currently for dashboards.

    /api/dashboards/<uid>/favorite

To make a dashboard a favorite you can make a *POST* request (no content
type required) to a URL like this:

    /api/dashboards/iMnYyBfSxmM/favorite

To remove a dashboard as a favorite you can make a *DELETE* request
using the same URL as above.

The favorite status will appear as a boolean *favorite* field on the
object (e.g. the dashboard) in the metadata response.

## Subscriptions

<!--DHIS2-SECTION-ID:webapi_subscription-->

A logged user can subscribe to certain types of objects. Currently
subscribable objects are those of type Chart, EventChart, EventReport,
Map, ReportTable and Visualization.

> **Note**
>
> The Chart and ReportTable objects are deprecated. Use Visualization instead.

To get the subscribers of an object (return an array of user IDs) you
can make a *GET* request:

    /api/<object-type>/<object-id>/subscribers

See example as follows:

    /api/charts/DkPKc1EUmC2/subscribers

To check whether the current user is subscribed to an object (returns a
boolean) you can perform a *GET* call:

    /api/<object-type>/<object-id>/subscribed

See example as follows:

    /api/charts/DkPKc1EUmC2/subscribed

To subscribe/de-subscribe to an object you perform a *POST/DELETE*
request (no content type required):

    /api/<object-type>/<object-id>/subscriber

## File resources

<!--DHIS2-SECTION-ID:webapi_file_resources-->

*File resources* are objects used to represent and store binary content.
The *FileResource* object itself contains the file meta-data (name,
Content-Type, size, etc.) as well as a key allowing retrieval of the
contents from a database-external file store. The *FileResource* object
is stored in the database like any other but the content (file) is
stored elsewhere and is retrievable using the contained reference
*(storageKey)*.

    /api/fileResources

The contents of file resources are not directly accessible but are
referenced from other objects (such as data values) to store binary
content of virtually unlimited size.

Creation of the file resource itself is done through the `/api/fileResources` endpoint as a multipart upload POST-request:

```bash
curl "https://server/api/fileResources" -X POST 
  -F "file=@/Path/to/file;filename=name-of-file.png" 
```

The only form parameter required is the *file* which is the file to
upload. The filename and content-type should also be included in the
request but will be replaced with defaults when not supplied.

On successfully creating a file resource the returned data will contain
a `response` field which in turn contains the `fileResource` like this:

```json
{
  "httpStatus": "Accepted",
  "httpStatusCode": 202,
  "status": "OK",
  "response": {
    "responseType": "FileResource",
    "fileResource": {
      "name": "name-of-file.png",
      "created": "2015-10-16T16:34:20.654+0000",
      "lastUpdated": "2015-10-16T16:34:20.667+0000",
      "externalAccess": false,
      "publicAccess": "--------",
      "user": { ... },
      "displayName": "name-of-file.png",
      "contentType": "image/png",
      "contentLength": 512571,
      "contentMd5": "4e1fc1c3f999e5aa3228d531e4adde58",
      "storageStatus": "PENDING",
      "id": "xm4JwRwke0i"
    }
  }
}
```

Note that the response is a *202 Accepted*, indicating that the returned
resource has been submitted for background processing (persisting to the
external file store in this case). Also, note the `storageStatus` field
which indicates whether the contents have been stored or not. At this
point, the persistence to the external store is not yet finished (it is
likely being uploaded to a cloud-based store somewhere) as seen by the
`PENDING` status.

Even though the content has not been fully stored yet the file resource
can now be used, for example as referenced content in a data value (see
[Working with file data values](#datavalue_file)). If we need to check
the updated *storageStatus* or otherwise retrieve the metadata of the
file, the `fileResources` endpoint can be queried.

```bash
curl "https://server/api/fileResources/xm4JwRwke0i" -H "Accept: application/json"
```

This request will return the `FileResource` object as seen in the
response of the above example.

### File resource constraints

<!--DHIS2-SECTION-ID:webapi_file_resources_constraints-->

  - File resources *must* be referenced (assigned) from another object
    in order to be persisted in the long term. A file resource which is
    created but not referenced by another object such as a data value is
    considered to be in *staging*. Any file resources which are in this
    state and are older than *two hours* will be marked for deletion
    and will eventually be purged from the system.

  - The ID returned by the initial creation of the file resource is not
    retrievable from any other location unless the file resource has
    been referenced (in which the ID will be stored as the reference),
    so losing it will require the POST request to be repeated and a new
    object to be created. The *orphaned* file resource will be cleaned
    up automatically.

  - File resource objects are *immutable*, meaning modification is not
    allowed and requires creating a completely new resource instead.

### File resource blocklist

Certain types of files are blocked from being uploaded for security reasons.

The following content types are blocked.

| Content type | Content type |
| ------------------------------------- | ---- |
| text/html                             | application/x-ms-dos-executable |
| text/css                              | application/vnd.microsoft.portable-executable |
| text/javascript                       | application/vnd.apple.installer+xml |
| font/otf                              | application/vnd.mozilla.xul+xml |
| application/x-shockwave-flash         | application/x-httpd-php  |
| application/vnd.debian.binary-package | application/x-sh |
| application/x-rpm                     | application/x-csh |
| application/java-archive              |  |

The following file extensions are blocked.

| File extension | File extension | File extension |
| ---- | ---- | ---- |
| html | deb  | xul  |
| htm  | rpm  | php  |
| css  | jar  | bin  |
| js   | jsp  | sh   |
| mjs  | exe  | csh  |
| otf  | msi  | bat  |
| swf  | mpkg |      |

## Metadata versioning

<!--DHIS2-SECTION-ID:webapi_metadata_versioning-->

This section explains the Metadata Versioning APIs available starting
2.24

  - `/api/metadata/version`: This endpoint will return the current metadata
    version of the system on which it is invoked.

<table>
<caption>Query Parameters</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 23%" />
<col style="width: 57%" />
</colgroup>
<thead>
<tr class="header">
<th>Name</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>versionName</td>
<td>false</td>
<td>If this parameter is not specified, it will return the current version of the system or otherwise it will return the details of the versionName passed as parameter. (versionName is of the syntax &quot;Version_&lt;id&gt;&quot;</td>
</tr>
</tbody>
</table>

### Get metadata version examples

<!--DHIS2-SECTION-ID:webapi_metadata_versioning_examples-->

**Example:** Get the current metadata version of this system

Request:

```
/api/metadata/version
```

Response:

```json
{
  "name": "Version_4",
  "created": "2016-06-30T06:01:28.684+0000",
  "lastUpdated": "2016-06-30T06:01:28.685+0000",
  "externalAccess": false,
  "displayName": "Version_4",
  "type": "BEST_EFFORT",
  "hashCode": "848bf6edbaf4faeb7d1a1169445357b0",
  "id": "Ayz2AEMB6ry"
}
```

**Example:** Get the details of version with name "Version_2"

Request:

```
/api/metadata/version?versionName=Version_2
```

Response:

```json
{
  "name": "Version_2",
  "created": "2016-06-30T05:59:33.238+0000",
  "lastUpdated": "2016-06-30T05:59:33.239+0000",
  "externalAccess": false,
  "displayName": "Version_2",
  "type": "BEST_EFFORT",
  "hashCode": "8050fb1a604e29d5566675c86d02d10b",
  "id": "SaNyhusVxBG"
}
```

  - `/api/metadata/version/history`: This endpoint will return the list of all
    metadata versions of the system on which it is invoked.

<table>
<caption>Query Parameters</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 23%" />
<col style="width: 57%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Name</p></th>
<th><p>Required</p></th>
<th><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>baseline</p></td>
<td><p>false</p></td>
<td><p>If this parameter is not specified, it will return list of all metadata versions. Otherwise we need to pass a versionName parameter of the form &quot;Version_&lt;id&gt;&quot;. It will then return the list of versions present in the system which were created after the version name supplied as the query parameter.</p></td>
</tr>
</tbody>
</table>

### Get the list of all metadata versions

<!--DHIS2-SECTION-ID:webapi_get_list_of_metadata_versions-->

**Example:** Get the list of all versions in this system

Request:

```
/api/metadata/version/history
```

Response:

```json
{
  "metadataversions": [{
    "name": "Version_1",
    "type": "BEST_EFFORT",
    "created": "2016-06-30T05:54:41.139+0000",
    "id": "SjnhUp6r4hG",
    "hashCode": "fd1398ff7ec9fcfd5b59d523c8680798"
  }, {
    "name": "Version_2",
    "type": "BEST_EFFORT",
    "created": "2016-06-30T05:59:33.238+0000",
    "id": "SaNyhusVxBG",
    "hashCode": "8050fb1a604e29d5566675c86d02d10b"
  }, {
    "name": "Version_3",
    "type": "BEST_EFFORT",
    "created": "2016-06-30T06:01:23.680+0000",
    "id": "FVkGzSjAAYg",
    "hashCode": "70b779ea448b0da23d8ae0bd59af6333"
  }]
}
```

**Example:** Get the list of all versions in this system created after "Version_2"

Request:

```
/api/metadata/version/history?baseline=Version_2
```

Response:

```json
{
  "metadataversions": [{
    "name": "Version_3",
    "type": "BEST_EFFORT",
    "created": "2016-06-30T06:01:23.680+0000",
    "id": "FVkGzSjAAYg",
    "hashCode": "70b779ea448b0da23d8ae0bd59af6333"
  }, {
    "name": "Version_4",
    "type": "BEST_EFFORT",
    "created": "2016-06-30T06:01:28.684+0000",
    "id": "Ayz2AEMB6ry",
    "hashCode": "848bf6edbaf4faeb7d1a1169445357b0"
  }]
 }
```

  - `/api/metadata/version/create`: This endpoint will create the metadata
    version for the version type as specified in the parameter.

<table>
<caption>Query Parameters</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 23%" />
<col style="width: 57%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Name</p></th>
<th><p>Required</p></th>
<th><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>type</p></td>
<td><p>true</p></td>
<td><p>The type of metadata version which needs to be created.</p>
<ul>
<li><p>BEST_EFFORT</p></li>
<li><p>ATOMIC</p></li>
</ul></td>
</tr>
</tbody>
</table>

Users can select the type of metadata which needs to be created.
Metadata Version type governs how the importer should treat the given
version. This type will be used while importing the metadata. There are
two types of metadata.

  - *BEST_EFFORT*: This type suggests that missing references can be
    ignored and the importer can continue importing the metadata (e.g.
    missing data elements on a data element group import).

  - *ATOMIC*: This type ensures a strict type checking of the metadata 
    references and the metadata import will fail if any of the references 
    do not exist.

> **Note**
>
> It's recommended to have an ATOMIC type of versions to ensure that all
> systems (central and local) have the same metadata. Any missing
> reference is caught in the validation phase itself. Please see the
> importer details for a full explanation.

### Create metadata version

<!--DHIS2-SECTION-ID:webapi_create_metadata_version-->

**Example:** Create metadata version of type `BEST_EFFORT`

Request:

```bash
curl -X POST -u admin:district "https://play.dhis2.org/dev/api/metadata/version/create?type=BEST_EFFORT"
```

Response:

```json
{
  "name": "Version_1",
  "created": "2016-06-30T05:54:41.139+0000",
  "lastUpdated": "2016-06-30T05:54:41.333+0000",
  "externalAccess": false,
  "publicAccess": "--------",
  "user": {
    "name": "John Traore",
    "created": "2013-04-18T17:15:08.407+0000",
    "lastUpdated": "2016-04-06T00:06:06.571+0000",
    "externalAccess": false,
    "displayName": "John Traore",
    "id": "xE7jOejl9FI"
  },
  "displayName": "Version_1",
  "type": "BEST_EFFORT",
  "hashCode": "fd1398ff7ec9fcfd5b59d523c8680798",
  "id": "SjnhUp6r4hG"
}
```

  - `/api/metadata/version/{versionName}/data`: This endpoint will download
    the actual metadata specific to the version name passed as path
    parameter.

  - `/api/metadata/version/{versionName}/data.gz`: This endpoint will download
    the actual metadata specific to the version name passed as path
    parameter in a compressed format (gzipped).

<table>
<caption>Path parameters</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Name</p></th>
<th><p>Required</p></th>
<th><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>versionName</p></td>
<td><p>true</p></td>
<td><p>Path parameter of the form &quot;Version_&lt;id&gt;&quot; so that the API downloads the specific version</p></td>
</tr>
</tbody>
</table>

### Download version metadata

<!--DHIS2-SECTION-ID:webapi_download_version_metadata-->

**Example:** Get the actual metadata for "Version 5"

Request:

```bash
curl -u admin:district "https://play.dhis2.org/dev/api/metadata/version/Version_5/data"
```

Response:

```json
{
  "date": "2016-06-30T06:10:23.120+0000",
  "dataElements": [
    {
      "code": "ANC 5th Visit",
      "created": "2016-06-30T06:10:09.870+0000",
      "lastUpdated": "2016-06-30T06:10:09.870+0000",
      "name": "ANC 5th Visit",
      "id": "sCuZKDsix7Y",
      "shortName": "ANC 5th Visit ",
      "aggregationType": "SUM",
      "domainType": "AGGREGATE",
      "zeroIsSignificant": false,
      "valueType": "NUMBER",
      "categoryCombo": {
        "id": "p0KPaWEg3cf"
      },
      "user": {
        "id": "xE7jOejl9FI"
      }
    }
  ]
}
```

## Metadata Synchronization

<!--DHIS2-SECTION-ID:webapi_metadata_synchronization-->

This section explains the Metadata Synchronization API available
starting 2.24

  - `/api/metadata/sync`: This endpoint performs metadata sync of the
    version name passed in the query parameter by downloading and
    importing the specified version from the remote server as defined in
    the settings app.

<table>
<caption>Query parameters</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th><p>Name</p></th>
<th><p>Required</p></th>
<th><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>versionName</p></td>
<td><p>true</p></td>
<td><p>versionName query parameter of the form &quot;Version_&lt;id&gt;&quot; . The api downloads this version from the remote server and imports it in the local system.</p></td>
</tr>
</tbody>
</table>

  - This API should be used with utmost care. Please note that there is
    an alternate way to achieve sync in a completely automated manner by
    leveraging the Metadata Sync Task from the "Data Administration"
    app. See Chapter 22, Section 22.17 of User Manual for more details
    regarding Metadata Sync Task.

  - This sync API can alternatively be used to sync metadata for the
    versions which have failed from the metadata sync scheduler. Due to
    its dependence on the given metadata version number, care should be
    taken for the order in which this gets invoked. E.g. If this api is
    used to sync some higher version from the central instance, then the
    sync might fail as the metadata dependencies are not present in the
    local instance.

  - Assume the local instance is at `Version_12` and if this endpoint is used
    to sync `Version_15` (of type `BEST_EFFORT`) from the central
    instance, the scheduler will start syncing metadata from
    `Version_16`. So the local instance will not have the metadata
    versions between `Version_12` and `Version_15`. You need to manually
    sync the missing versions using these endpoints only.

### Sync metadata version

<!--DHIS2-SECTION-ID:webapi_metadata_synchronization_version-->

**Example:** Sync Version_6 from central system to this system

Request:

```bash
curl -u admin:district "https://play.dhis2.org/dev/api/metadata/sync?versionName=Version_6"
```

## Data values

<!--DHIS2-SECTION-ID:webapi_data_values-->

This section is about sending and reading data values.

    /api/33/dataValueSets

### Sending data values

<!--DHIS2-SECTION-ID:webapi_sending_data_values-->

A common use-case for system integration is the need to send a set of
data values from a third-party system into DHIS. In this example, we will
use the DHIS2 demo on `http://play.dhis2.org/demo` as basis. We assume
that we have collected case-based data using a simple software client
running on mobile phones for the *Mortality <5 years* data set in the
community of *Ngelehun CHC* (in *Badjia* chiefdom, *Bo* district) for
the month of January 2014. We have now aggregated our data into a
statistical report and want to send that data to the DHIS2 instance. The
base URL to the demo API is `http://play.dhis2.org/demo/api`. The following
links are relative to the base URL.


The resource which is most appropriate for our purpose of sending data
values is the `/api/dataValueSets` resource. A data value set represents a
set of data values which have a relationship, usually from being
captured off the same data entry form. The format looks like
this:

```xml
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0" dataSet="dataSetID"
  completeDate="date" period="period" orgUnit="orgUnitID" attributeOptionCombo="aocID">
  <dataValue dataElement="dataElementID" 
    categoryOptionCombo="cocID" value="1" comment="comment1"/>
  <dataValue dataElement="dataElementID" 
    categoryOptionCombo="cocID" value="2" comment="comment2"/>
  <dataValue dataElement="dataElementID" 
    categoryOptionCombo="cocID" value="3" comment="comment3"/>
</dataValueSet>
```

JSON is supported in this format:

```json
{
  "dataSet": "dataSetID",
  "completeDate": "date",
  "period": "period",
  "orgUnit": "orgUnitID",
  "attributeOptionCombo": "aocID",
  "dataValues": [
    {
      "dataElement": "dataElementID", 
      "categoryOptionCombo": "cocID", 
      "value": "1", 
      "comment": "comment1"
    },
    {
      "dataElement": "dataElementID", 
      "categoryOptionCombo": "cocID", 
      "value": "2", 
      "comment": "comment2"
    },
    {
      "dataElement": "dataElementID", 
      "categoryOptionCombo": "cocID", 
      "value": "3", 
      "comment": "comment3"
    }
  ]
}
```

CSV is supported in this format:

```csv
"dataelement","period","orgunit","catoptcombo","attroptcombo","value","strby","lstupd","cmt"
"dataElementID","period","orgUnitID","cocID","aocID","1","username","2015-04-01","comment1"
"dataElementID","period","orgUnitID","cocID","aocID","2","username","2015-04-01","comment2"
"dataElementID","period","orgUnitID","cocID","aocID","3","username","2015-04-01","comment3"
```

> **Note**
>
> Please refer to the date and period section above for time formats.

From the example, we can see that we need to identify the period, the
data set, the org unit (facility) and the data elements for which to
report.

To obtain the identifier for the data set we make a request to the
`/api/dataSets` resource. From there we find and follow the link to 
the *Mortality < 5 years* data set which leads us to `/api/dataSets/pBOMPrpg1QX`. 
The resource representation for the *Mortality < 5 years* data set conveniently
advertises links to the data elements which are members of it. From here
we can follow these links and obtain the identifiers of the data
elements. For brevity we will only report on three data elements:
*Measles* with id `f7n9E0hX8qk`, *Dysentery* with id `Ix2HsbDMLea` and
*Cholera* with id `eY5ehpbEsB7`.

What remains is to get hold of the identifier of the organisation
unit. The *dataSet* representation conveniently provides a link to organisation
units which report on it so we search for *Ngelehun CHC* and follow the
link to the HTML representation at `/api/organisationUnits/DiszpKrYNg8`, which
tells us that the identifier of this org unit is `DiszpKrYNg8`.

From our case-based data, we assume that we have 12 cases of measles, 14
cases of dysentery and 16 cases of cholera. We have now gathered enough
information to be able to put together the XML data value set
message:

```xml
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0" dataSet="pBOMPrpg1QX"
  completeDate="2014-02-03" period="201401" orgUnit="DiszpKrYNg8">
  <dataValue dataElement="f7n9E0hX8qk" value="12"/>
  <dataValue dataElement="Ix2HsbDMLea" value="14"/>
  <dataValue dataElement="eY5ehpbEsB7" value="16"/>
</dataValueSet>
```

In JSON format:

```json
{
  "dataSet": "pBOMPrpg1QX",
  "completeDate": "2014-02-03",
  "period": "201401",
  "orgUnit": "DiszpKrYNg8",
  "dataValues": [
    {
      "dataElement": "f7n9E0hX8qk", 
      "value": "1"
    },
    {
      "dataElement": "Ix2HsbDMLea", 
      "value": "2"
    },
    {
      "dataElement": "eY5ehpbEsB7", 
      "value": "3"
    }
  ]
}
```

To perform functional testing we will use the _curl_ tool which provides
an easy way of transferring data using HTTP. First, we save the data
value set XML content in a file called `datavalueset.xml`. From the
directory where this file resides we invoke the following from the
command line:

```bash
curl -d @datavalueset.xml "https://play.dhis2.org/demo/api/33/dataValueSets"
  -H "Content-Type:application/xml" -u admin:district
```

For sending JSON content you must set the content-type header
accordingly:

```bash
curl -d @datavalueset.json "https://play.dhis2.org/demo/api/33/dataValueSets"
  -H "Content-Type:application/json" -u admin:district
```

The command will dispatch a request to the demo Web API, set
`application/xml` as the content-type and authenticate using
`admin`/`district` as username/password. If all goes well this will return a
`200 OK` HTTP status code. You can verify that the data has been
received by opening the data entry module in DHIS2 and select the org
unit, data set and period used in this example.

The API follows normal semantics for error handling and HTTP status
codes. If you supply an invalid username or password, `401 Unauthorized`
is returned. If you supply a content-type other than `application/xml`,
`415 Unsupported Media Type` is returned. If the XML content is invalid
according to the DXF namespace, `400 Bad Request` is returned. If you
provide an invalid identifier in the XML content, `409 Conflict` is
returned together with a descriptive message.

### Sending bulks of data values

<!--DHIS2-SECTION-ID:webapi_sending_bulks_data_values-->

The previous example showed us how to send a set of related data values
sharing the same period and organisation unit. This example will show us
how to send large bulks of data values which don't necessarily are
logically related.

Again we will interact with the `/api/dataValueSets` resource. This time we
will not specify the `dataSet` and `completeDate` attributes. Also, we will
specify the `period` and `orgUnit` attributes on the individual data value
elements instead of on the outer data value set element. This will
enable us to send data values for various periods and organisation units:

```xml
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0">
  <dataValue dataElement="f7n9E0hX8qk" 
    period="201401" orgUnit="DiszpKrYNg8" value="12"/>
  <dataValue dataElement="f7n9E0hX8qk" 
    period="201401" orgUnit="FNnj3jKGS7i" value="14"/>
  <dataValue dataElement="f7n9E0hX8qk" 
    period="201402" orgUnit="DiszpKrYNg8" value="16"/>
  <dataValue dataElement="f7n9E0hX8qk" 
    period="201402" orgUnit="Jkhdsf8sdf4" value="18"/>
</dataValueSet>
```

In JSON format:

```json
{
  "dataValues": [
    {
      "dataElement": "f7n9E0hX8qk", 
      "period": "201401", 
      "orgUnit": "DiszpKrYNg8", 
      "value": "12"
    }, 
    {
      "dataElement": "f7n9E0hX8qk", 
      "period": "201401", 
      "orgUnit": "FNnj3jKGS7i", 
      "value": "14"
    }, 
    {
      "dataElement": "f7n9E0hX8qk", 
      "period": "201402", 
      "orgUnit": "DiszpKrYNg8", 
      "value": "16"
    }, 
    {
      "dataElement": "f7n9E0hX8qk", 
      "period": "201402", 
      "orgUnit": "Jkhdsf8sdf4", 
      "value": "18"
    }
  ]
}
```

In CSV format:

```csv
"dataelement","period","orgunit","categoryoptioncombo","attributeoptioncombo","value"
"f7n9E0hX8qk","201401","DiszpKrYNg8","bRowv6yZOF2","bRowv6yZOF2","1"
"Ix2HsbDMLea","201401","DiszpKrYNg8","bRowv6yZOF2","bRowv6yZOF2","2"
"eY5ehpbEsB7","201401","DiszpKrYNg8","bRowv6yZOF2","bRowv6yZOF2","3"
```

We test by using curl to send the data values in XML format:

```bash
curl -d @datavalueset.xml "https://play.dhis2.org/demo/api/33/dataValueSets"
  -H "Content-Type:application/xml" -u admin:district
```

Note that when using CSV format you must use the binary data option to
preserve the line-breaks in the CSV file:

```bash
curl --data-binary @datavalueset.csv "https://play.dhis2.org/demo/24/api/dataValueSets"
  -H "Content-Type:application/csv" -u admin:district
```

The data value set resource provides an XML response which is useful
when you want to verify the impact your request had. The first time we
send the data value set request above the server will respond with the
following import summary:

```xml
<importSummary>
  <dataValueCount imported="2" updated="1" ignored="1"/>
  <dataSetComplete>false</dataSetComplete>
</importSummary>
```

This message tells us that 3 data values were imported, 1 data value was
updated while zero data values were ignored. The single update comes as
a result of us sending that data value in the previous example. A data
value will be ignored if it references a non-existing data element,
period, org unit or data set. In our case, this single ignored value was
caused by the last data value having an invalid reference to org unit.
The data set complete element will display the date of which the data
value set was completed, or false if no data element attribute was
supplied.

### Import parameters

<!--DHIS2-SECTION-ID:webapi_data_values_import_parameters-->

The import process can be customized using a set of import parameters:

<table>
<caption>Import parameters</caption>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Values (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dataElementIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the data element object to use to map the data values.</td>
</tr>
<tr class="even">
<td>orgUnitIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the org unit object to use to map the data values.</td>
</tr>
<tr class="odd">
<td>categoryOptionComboIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the category option combo and attribute option combo objects to use to map the data values.</td>
</tr>
<tr class="even">
<td>idScheme</td>
<td>id | name | code| attribute:ID</td>
<td>Property of all objects including data elements, org units and category option combos, to use to map the data values.</td>
</tr>
<tr class="odd">
<td>preheatCache</td>
<td>false | true</td>
<td>Indicates whether to preload metadata caches before starting to import data values, will speed up large import payloads with high metadata cardinality.</td>
</tr>
<tr class="even">
<td>dryRun</td>
<td>false | true</td>
<td>Whether to save changes on the server or just return the import summary.</td>
</tr>
<tr class="odd">
<td>importStrategy</td>
<td>CREATE | UPDATE | CREATE_AND_UPDATE | DELETE</td>
<td>Save objects of all, new or update import status on the server.</td>
</tr>
<tr class="even">
<td>skipExistingCheck</td>
<td>false | true</td>
<td>Skip checks for existing data values. Improves performance. Only use for empty databases or when the data values to import do not exist already.</td>
</tr>
<tr class="even">
<td>skipAudit</td>
<td>false | true</td>
<td>Skip audit, meaning audit values will not be generated. Improves performance at the cost of ability to audit changes. Requires authority "F_SKIP_DATA_IMPORT_AUDIT".</td>
</tr>
<tr class="odd">
<td>async</td>
<td>false | true</td>
<td>Indicates whether the import should be done asynchronous or synchronous. The former is suitable for very large imports as it ensures that the request does not time out, although it has a significant performance overhead. The latter is faster but requires the connection to persist until the process is finished.</td>
</tr>
<tr class="even">
<td>force</td>
<td>false | true</td>
<td>Indicates whether the import should be forced. Data import could be rejected for various reasons of data set locking for example due to approval, data input period, expiry days, etc. In order to override such locks and force data input one can use data import with force=true. However, one needs to be a *superuser* for this parameter to work.</td>
</tr>
</tbody>
</table>

All parameters are optional and can be supplied as query parameters in
the request URL like this:

    /api/33/dataValueSets?dataElementIdScheme=code&orgUnitIdScheme=name
      &dryRun=true&importStrategy=CREATE

They can also be supplied as XML attributes on the data value set
element like below. XML attributes will override query string
parameters.

```xml
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0" dataElementIdScheme="code"
  orgUnitIdScheme="name" dryRun="true" importStrategy="CREATE">
</dataValueSet>
```

Note that the `preheatCache` parameter can have a huge impact on
performance. For small import files, leaving it to false will be fast.
For large import files which contain a large number of distinct data
elements and organisation units, setting it to true will be orders of
magnitude faster.

#### Data value requirements

<!--DHIS2-SECTION-ID:webapi_data_values_import_requirement-->

Data value import supports a set of value types. For each value type,
there is a special requirement. The following table lists the edge cases
for value types.

<table>
<caption>Value type requirements</caption>
<thead>
<tr class="header">
<th>Value type</th>
<th>Requirements</th>
<th>Comment</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>BOOLEAN</td>
<td>true | True | TRUE | false | False | FALSE | 1 | 0 | t | f |</td>
<td>Used when the value is a boolean, true or false value. The import service does not care if the input begins with an uppercase or lowercase letter, or if it's all uppercase.</td>
</tr>
</tbody>
</table>

#### Identifier schemes

<!--DHIS2-SECTION-ID:webapi_data_values_identifier_schemes-->

Regarding the id schemes, by default the identifiers used in the XML
messages use the DHIS2 stable object identifiers referred to as `UID`.
In certain interoperability situations we might experience that an external
system decides the identifiers of the objects. In that case we can use
the `code` property of the organisation units and other objects to set
fixed identifiers. When importing data values we hence need to reference
the code property instead of the identifier property of these metadata
objects. Identifier schemes can be specified in the XML message as well
as in the request as query parameters. To specify it in the XML payload
you can do this:

```xml
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0"
  dataElementIdScheme="CODE" orgUnitIdScheme="UID" idScheme="CODE">
</dataValueSet>
```

The parameter table above explains how the id schemes can be specified
as query parameters. The following rules apply for what takes
precedence:

  - Id schemes defined in the XML or JSON payload take precedence over
    id schemes defined as URL query parameters.

  - Specific id schemes including dataElementIdScheme and
    orgUnitIdScheme take precedence over the general idScheme.

  - The default id scheme is UID, which will be used if no explicit id
    scheme is defined.

The following identifier schemes are available.

  - uid (default)

  - code

  - name

  - attribute (followed by UID of attribute)

The attribute option is special and refers to meta-data attributes which
have been marked as *unique*. When using this option, `attribute` must
be immediately followed by the identifier of the attribute, e.g.
"attribute:DnrLSdo4hMl".

#### Async data value import

<!--DHIS2-SECTION-ID:webapi_data_values_async_import-->

Data values can be sent and imported in an asynchronous fashion by
supplying an `async` query parameter set to *true*:

    /api/33/dataValueSets?async=true

This will initiate an asynchronous import job for which you can monitor
the status at the task summaries API. The API response indicates the
unique identifier of the job, type of job and the URL you can use to
monitor the import job status. The response will look similar to this:

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "message": "Initiated dataValueImport",
  "response": {
    "name": "dataValueImport",
    "id": "YR1UxOUXmzT",
    "created": "2018-08-20T14:17:28.429",
    "jobType": "DATAVALUE_IMPORT",
    "relativeNotifierEndpoint": "/api/system/tasks/DATAVALUE_IMPORT/YR1UxOUXmzT"
  }
}
```

Please read the section on *asynchronous task status* for more
information.

### CSV data value format

<!--DHIS2-SECTION-ID:webapi_data_values_csv-->

The following section describes the CSV format used in DHIS2. The first
row is assumed to be a header row and will be ignored during import.

<table>
<caption>CSV format of DHIS2</caption>
<tbody>
<tr class="odd">
<td>Column</td>
<td>Required</td>
<td>Description</td>
</tr>
<tr class="even">
<td>Data element</td>
<td>Yes</td>
<td>Refers to ID by default, can also be name and code based on selected id scheme</td>
</tr>
<tr class="odd">
<td>Period</td>
<td>Yes</td>
<td>In ISO format</td>
</tr>
<tr class="even">
<td>Org unit</td>
<td>Yes</td>
<td>Refers to ID by default, can also be name and code based on selected id scheme</td>
</tr>
<tr class="odd">
<td>Category option combo</td>
<td>No</td>
<td>Refers to ID</td>
</tr>
<tr class="even">
<td>Attribute option combo</td>
<td>No</td>
<td>Refers to ID (from version 2.16)</td>
</tr>
<tr class="odd">
<td>Value</td>
<td>No</td>
<td>Data value</td>
</tr>
<tr class="even">
<td>Stored by</td>
<td>No</td>
<td>Refers to username of user who entered the value</td>
</tr>
<tr class="odd">
<td>Last updated</td>
<td>No</td>
<td>Date in ISO format</td>
</tr>
<tr class="even">
<td>Comment</td>
<td>No</td>
<td>Free text comment</td>
</tr>
<tr class="odd">
<td>Follow up</td>
<td>No</td>
<td>true or false</td>
</tr>
</tbody>
</table>

An example of a CSV file which can be imported into DHIS2 is seen below.

```csv
"dataelement","period","orgunit","catoptcombo","attroptcombo","value","storedby","timestamp"
"DUSpd8Jq3M7","201202","gP6hn503KUX","Prlt0C1RF0s",,"7","bombali","2010-04-17"
"DUSpd8Jq3M7","201202","gP6hn503KUX","V6L425pT3A0",,"10","bombali","2010-04-17"
"DUSpd8Jq3M7","201202","OjTS752GbZE","V6L425pT3A0",,"9","bombali","2010-04-06"
```

### Generating data value set template

<!--DHIS2-SECTION-ID:webapi_data_values_template-->

To generate a data value set template for a certain data set you can use
the `/api/dataSets/<id>/dataValueSet` resource. XML and JSON response
formats are supported. Example:

    /api/dataSets/BfMAe6Itzgt/dataValueSet.json

The parameters you can use to further adjust the output are described
below:

<table style="width:100%;">
<caption>Data values query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 19%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>period</td>
<td>No</td>
<td>Period to use, will be included without any checks.</td>
</tr>
<tr class="even">
<td>orgUnit</td>
<td>No</td>
<td>Organisation unit to use, supports multiple orgUnits, both id and code can be used.</td>
</tr>
<tr class="odd">
<td>comment</td>
<td>No</td>
<td>Should comments be include, default: Yes.</td>
</tr>
<tr class="even">
<td>orgUnitIdScheme</td>
<td>No</td>
<td>Organisation unit scheme to use, supports id | code.</td>
</tr>
<tr class="odd">
<td>dataElementIdScheme</td>
<td>No</td>
<td>Data-element scheme to use, supports id | code.</td>
</tr>
</tbody>
</table>

### Reading data values

<!--DHIS2-SECTION-ID:webapi_reading_data_values-->

This section explains how to retrieve data values from the Web API by
interacting with the *dataValueSets* resource. Data values can be
retrieved in *XML*, *JSON* and *CSV* format. Since we want to read data
we will use the *GET* HTTP verb. We will also specify that we are
interested in the XML resource representation by including an `Accept`
HTTP header with our request. The following query parameters are
required:

<table>
<caption>Data value set query parameters</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 72%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dataSet</td>
<td>Data set identifier. Can be repeated any number of times.</td>
</tr>
<tr class="even">
<td>dataElementGroup</td>
<td>Data element group identifier. Can be repeated any number of times.</td>
</tr>
<tr class="odd">
<td>period</td>
<td>Period identifier in ISO format. Can be repeated any number of times.</td>
</tr>
<tr class="even">
<td>startDate</td>
<td>Start date for the time span of the values to export.</td>
</tr>
<tr class="odd">
<td>endDate</td>
<td>End date for the time span of the values to export.</td>
</tr>
<tr class="even">
<td>orgUnit</td>
<td>Organisation unit identifier. Can be repeated any number of times.</td>
</tr>
<tr class="odd">
<td>children</td>
<td>Whether to include the children in the hierarchy of the organisation units.</td>
</tr>
<tr class="even">
<td>orgUnitGroup</td>
<td>Organisation unit group identifier. Can be repeated any number of times.</td>
</tr>
<tr class="odd">
<td>attributeOptionCombo</td>
<td>Attribute option combo identifier. Can be repeated any number of times.</td>
</tr>
<tr class="even">
<td>includeDeleted</td>
<td>Whether to include deleted data values.</td>
</tr>
<tr class="odd">
<td>lastUpdated</td>
<td>Include only data values which are updated since the given time stamp.</td>
</tr>
<tr class="even">
<td>lastUpdatedDuration</td>
<td>Include only data values which are updated within the given duration. The format is &lt;value&gt;&lt;time-unit&gt;, where the supported time units are &quot;d&quot; (days), &quot;h&quot; (hours), &quot;m&quot; (minutes) and &quot;s&quot; (seconds).</td>
</tr>
<tr class="odd">
<td>limit</td>
<td>The max number of results in the response.</td>
</tr>
<tr class="even">
<td>idScheme</td>
<td>Property of meta data objects to use for data values in response.</td>
</tr>
<tr class="odd">
<td>dataElementIdScheme</td>
<td>Property of the data element object to use for data values in response.</td>
</tr>
<tr class="even">
<td>orgUnitIdScheme</td>
<td>Property of the org unit object to use for data values in response.</td>
</tr>
<tr class="odd">
<td>categoryOptionComboIdScheme</td>
<td>Property of the category option combo and attribute option combo objects to use for data values in response.</td>
</tr>
<tr class="even">
<td>dataSetIdScheme</td>
<td>Property of the data set object to use in the response.</td>
</tr>
</tbody>
</table>

The following response formats are supported:

  - xml (application/xml)

  - json (application/json)

  - csv (application/csv)

  - adx (application/adx+xml)

Assuming that we have posted data values to DHIS2 according to the
previous section called *Sending data values* we can now put together
our request for a single data value set and request it using cURL:

```bash
curl "https://play.dhis2.org/demo/api/33/dataValueSets?dataSet=pBOMPrpg1QX&period=201401&orgUnit=DiszpKrYNg8"
  -H "Accept:application/xml" -u admin:district
```

We can also use the start and end dates query parameters to request a
larger bulk of data values. I.e. you can also request data values for
multiple data sets and org units and a time span in order to export
larger chunks of data. Note that the period query parameter takes
precedence over the start and end date parameters. An example looks like
this:

```bash
curl "https://play.dhis2.org/demo/api/33/dataValueSets?dataSet=pBOMPrpg1QX&dataSet=BfMAe6Itzgt
  &startDate=2013-01-01&endDate=2013-01-31&orgUnit=YuQRtpLP10I&orgUnit=vWbkYPRmKyS&children=true"
  -H "Accept:application/xml" -u admin:district
```

To retrieve data values which have been created or updated within the
last 10 days you can make a request like this:

    /api/dataValueSets?dataSet=pBOMPrpg1QX&orgUnit=DiszpKrYNg8&lastUpdatedDuration=10d

The response will look like this:

```xml
<?xml version='1.0' encoding='UTF-8'?>
<dataValueSet xmlns="http://dhis2.org/schema/dxf/2.0" dataSet="pBOMPrpg1QX"
  completeDate="2014-01-02" period="201401" orgUnit="DiszpKrYNg8">
<dataValue dataElement="eY5ehpbEsB7" period="201401" orgUnit="DiszpKrYNg8"
  categoryOptionCombo="bRowv6yZOF2" value="10003"/>
<dataValue dataElement="Ix2HsbDMLea" period="201401" orgUnit="DiszpKrYNg8"
  categoryOptionCombo="bRowv6yZOF2" value="10002"/>
<dataValue dataElement="f7n9E0hX8qk" period="201401" orgUnit="DiszpKrYNg8"
  categoryOptionCombo="bRowv6yZOF2" value="10001"/>
</dataValueSet>
```

You can request the data in JSON format like this:

    /api/dataValueSets.json?dataSet=pBOMPrpg1QX&period=201401&orgUnit=DiszpKrYNg8

The response will look something like this:

```json
{
  "dataSet": "pBOMPrpg1QX",
  "completeDate": "2014-02-03",
  "period": "201401",
  "orgUnit": "DiszpKrYNg8",
  "dataValues": [
    {
      "dataElement": "eY5ehpbEsB7", 
      "categoryOptionCombo": "bRowv6yZOF2", 
      "period": "201401",
      "orgUnit": "DiszpKrYNg8", 
      "value": "10003"
    }, 
    {
      "dataElement": "Ix2HsbDMLea", 
      "categoryOptionCombo": "bRowv6yZOF2", 
      "period": "201401",
      "orgUnit": "DiszpKrYNg8", 
      "value": "10002"
    }, 
    {
      "dataElement": "f7n9E0hX8qk", 
      "categoryOptionCombo": "bRowv6yZOF2", 
      "period": "201401",
      "orgUnit": "DiszpKrYNg8", 
      "value": "10001"
    }
  ]
}
```

Note that data values are softly deleted, i.e. a deleted value has the
`deleted` property set to true instead of being permanently deleted.
This is useful when integrating multiple systems in order to communicate
deletions. You can include deleted values in the response like this:

    /api/33/dataValueSets.json?dataSet=pBOMPrpg1QX&period=201401
      &orgUnit=DiszpKrYNg8&includeDeleted=true

You can also request data in CSV format like this:

    /api/33/dataValueSets.csv?dataSet=pBOMPrpg1QX&period=201401
      &orgUnit=DiszpKrYNg8

The response will look like this:

```csv
dataelement,period,orgunit,catoptcombo,attroptcombo,value,storedby,lastupdated,comment,flwup
f7n9E0hX8qk,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,12,system,2015-04-05T19:58:12.000,comment1,false
Ix2HsbDMLea,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,14,system,2015-04-05T19:58:12.000,comment2,false
eY5ehpbEsB7,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,16,system,2015-04-05T19:58:12.000,comment3,false
FTRrcoaog83,201401,DiszpKrYNg8,bRowv6yZOF2,bRowv6yZOF2,12,system,2014-03-02T21:45:05.519,comment4,false
```

The following constraints apply to the data value sets resource:

  - At least one data set must be specified.

  - Either at least one period or a start date and end date must be
    specified.

  - At least one organisation unit must be specified.

  - Organisation units must be within the hierarchy of the organisation
    units of the authenticated user.

  - Limit cannot be less than zero.

### Sending, reading and deleting individual data values

<!--DHIS2-SECTION-ID:webapi_sending_individual_data_values-->

This example will show how to send individual data values to be saved in
a request. This can be achieved by sending a *POST* request to the
`dataValues` resource:

    /api/dataValues

The following query parameters are supported for this resource:

<table style="width:100%;">
<caption>Data values query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 19%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>de</td>
<td>Yes</td>
<td>Data element identifier</td>
</tr>
<tr class="even">
<td>pe</td>
<td>Yes</td>
<td>Period identifier</td>
</tr>
<tr class="odd">
<td>ou</td>
<td>Yes</td>
<td>Organisation unit identifier</td>
</tr>
<tr class="even">
<td>co</td>
<td>No</td>
<td>Category option combo identifier, default will be used if omitted</td>
</tr>
<tr class="odd">
<td>cc</td>
<td>No (must be combined with cp)</td>
<td>Attribute category combo identifier</td>
</tr>
<tr class="even">
<td>cp</td>
<td>No (must be combined with cc)</td>
<td>Attribute category option identifiers, separated with ; for multiple values</td>
</tr>
<tr class="odd">
<td>ds</td>
<td>No</td>
<td>Data set, to check if POST or DELETE is allowed for period and organisation unit. If specified, the data element must be assigned to this data set. If not specified, a data set containing the data element will be chosen to check if the operation is allowed.</td>
</tr>
<tr class="even">
<td>value</td>
<td>No</td>
<td>Data value. For boolean values, the following will be accepted: true | True | TRUE | false | False | FALSE | 1 | 0 | t | f |</td>
</tr>
<tr class="odd">
<td>comment</td>
<td>No</td>
<td>Data comment</td>
</tr>
<tr class="even">
<td>followUp</td>
<td>No</td>
<td>Follow up on data value, will toggle the current boolean value</td>
</tr>
</tbody>
</table>

If any of the identifiers given are invalid, if the data value or
comment is invalid or if the data is locked, the response will contain
the *409 Conflict* status code and descriptive text message. If the
operation leads to a saved or updated value, *200 OK* will be returned.
An example of a request looks like this:

```bash
curl "https://play.dhis2.org/demo/api/33/dataValues?de=s46m5MS0hxu
  &pe=201301&ou=DiszpKrYNg8&co=Prlt0C1RF0s&value=12"
  -X POST -u admin:district
```

This resource also allows a special syntax for associating the value to
an attribute option combination. This can be done by sending the
identifier of the attribute category combination, together with the identifiers
of the attribute category options which the value represents within the
combination. The category combination is specified with the `cc` parameter, while
the category options are specified as a semi-colon separated string with the `cp`
parameter. It is necessary to ensure that the category options are all part
of the category combination. An example looks like this:

```bash
curl "https://play.dhis2.org/demo/api/33/dataValues?de=s46m5MS0hxu&ou=DiszpKrYNg8
  &pe=201308&cc=dzjKKQq0cSO&cp=wbrDrL2aYEc;btOyqprQ9e8&value=26"
  -X POST -u admin:district
```

You can retrieve a data value with a request using the *GET* method. The
value, comment and followUp params are not applicable in this regard:

```bash
curl "https://play.dhis2.org/demo/api/33/dataValues?de=s46m5MS0hxu
  &pe=201301&ou=DiszpKrYNg8&co=Prlt0C1RF0s"
  -u admin:district
```

You can delete a data value with a request using the *DELETE* method.

#### Working with file data values

<!--DHIS2-SECTION-ID:datavalue_file-->

When dealing with data values which have a data element of type *file*
there is some deviation from the method described above. These data
values are special in that the contents of the value is a UID reference
to a *FileResource* object instead of a self-contained constant. These
data values will behave just like other data values which store text
content, but should be handled differently in order to produce
meaningful input and output.

The process of storing one of these data values roughly goes like this:

1.  Upload the file to the `/api/fileResources` endpoint as described
    in the file resource section.

2.  Retrieve the `id` property of the returned *FileResource*.

3.  Store the retrieved id *as the value* to the data value using any
    of the methods described above.

Only one-to-one relationships between data values and file resources are
allowed. This is enforced internally so that saving a file resource id
in several data values is not allowed and will return an error. Deleting
the data value will delete the referenced file resource. Direct deletion
of file resources are not possible.

The data value can now be retrieved as any other but the returned data
will be the UID of the file resource. In order to retrieve the actual
contents (meaning the file which is stored in the file resource mapped
to the data value) a GET request must be made to `/api/dataValues/files`
mirroring the query parameters as they would be for the data value
itself. The `/api/dataValues/files` endpoint only supports GET requests.

It is worth noting that due to the underlying storage mechanism working
asynchronously the file content might not be immediately ready for
download from the `/api/dataValues/files` endpoint. This is especially true
for large files which might require time consuming uploads happening in
the background to an external file store (depending on the system
configuration). Retrieving the file resource meta-data from the
`/api/fileResources/<id>` endpoint allows checking the `storageStatus`
of the content before attempting to download it.

## ADX data format

<!--DHIS2-SECTION-ID:webapi_adx_data_format-->

From version 2.20 we have included support for an international standard
for aggregate data exchange called ADX. ADX is developed and maintained
by the Quality Research and Public Health committee of the IHE
(Integrating the HealthCare Enterprise). The wiki page detailing QRPH
activity can be found at
[wiki.ihe.net](http://wiki.ihe.net/index.php?title=Quality,_Research_and_Public_Health#Current_Domain_Activities).
ADX is still under active development and has now been published for
trial implementation. Note that what is implemented currently in DHIS2
is the functionality to read and write adx formatted data, i.e. what is
described as Content Consumer and Content Producer actors in the ADX
profile.

The structure of an ADX data message is quite similar to what you might
already be familiar with from DXF 2 data described earlier. There are a
few important differences. We will describe these differences with
reference to a small example:

```xml
<adx xmlns="urn:ihe:qrph:adx:2015" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="urn:ihe:qrph:adx:2015 ../schema/adx_loose.xsd" 
  exported="2015-02-08T19:30:00Z">
  <group orgUnit="OU_559" period="2015-06-01/P1M" 
    completeDate="2015-07-01" dataSet="(TB/HIV)VCCT">
    <dataValue dataElement="VCCT_0" GENDER="FMLE" HIV_AGE="AGE0-14" value="32"/>
    <dataValue dataElement="VCCT_1" GENDER="FMLE" HIV_AGE="AGE0-14" value="20"/>
    <dataValue dataElement="VCCT_2" GENDER="FMLE" HIV_AGE="AGE0-14" value="10"/>
    <dataValue dataElement="PLHIV_TB_0" GENDER="FMLE" HIV_AGE="AGE0-14" value="10"/>
    <dataValue dataElement="PLHIV_TB_1" GENDER="FMLE" HIV_AGE="AGE0-14" value="10"/>

    <dataValue dataElement="VCCT_0" GENDER="MLE" HIV_AGE="AGE0-14" value="32"/>
    <dataValue dataElement="VCCT_1" GENDER="MLE" HIV_AGE="AGE0-14" value="20"/>
    <dataValue dataElement="VCCT_2" GENDER="MLE" HIV_AGE="AGE0-14" value="10"/>
    <dataValue dataElement="PLHIV_TB_0" GENDER="MLE" HIV_AGE="AGE0-14" value="10"/>
    <dataValue dataElement="PLHIV_TB_1" GENDER="MLE" HIV_AGE="AGE0-14" value="10"/>

    <dataValue dataElement="VCCT_0" GENDER="FMLE" HIV_AGE="AGE15-24" value="32"/>
    <dataValue dataElement="VCCT_1" GENDER="FMLE" HIV_AGE="AGE15-24" value="20"/>
    <dataValue dataElement="VCCT_2" GENDER="FMLE" HIV_AGE="AGE15-24" value="10"/>
    <dataValue dataElement="PLHIV_TB_0" GENDER="FMLE" HIV_AGE="AGE15-24" value="10"/>
    <dataValue dataElement="PLHIV_TB_1" GENDER="FMLE" HIV_AGE="AGE15-24" value="10"/>

    <dataValue dataElement="VCCT_0" GENDER="MLE" HIV_AGE="AGE15-24" value="32"/>
    <dataValue dataElement="VCCT_1" GENDER="MLE" HIV_AGE="AGE15-24" value="20"/>
    <dataValue dataElement="VCCT_2" GENDER="MLE" HIV_AGE="AGE15-24" value="10"/>
    <dataValue dataElement="PLHIV_TB_0" GENDER="MLE" HIV_AGE="AGE15-24" value="10"/>
    <dataValue dataElement="PLHIV_TB_1" GENDER="MLE" HIV_AGE="AGE15-24" value="10"/>
  </group>
</adx>
```

### The adx root element

The adx root element has only one mandatory attribute, which is the
*exported* timestamp. In common with other adx elements, the schema is
extensible in that it does not restrict additional application specific
attributes.

### The group element

Unlike dxf2, adx requires that the datavalues are grouped according to
orgUnit, period and dataSet. The example above shows a data report for
the "(TB/HIV) VCCT" dataset from the online demo database. This example
is using codes as identifiers instead of dhis2 uids. Codes are the
preferred form of identifier when using adx.

The orgUnit, period and dataSet attributes are mandatory in adx. The
group element may contain additional attributes. In our DHIS2
implementation any additional attributes are simply passed through to
the underlying importer. This means that all attributes which currently
have meaning in dxf2 (such as completeDate in the example above) can
continue to be used in adx and they will be processed in the same way.

A significant difference between adx and dxf2 is in the way that periods
are encoded. Adx makes strict use of ISO8601 and encodes the reporting
period as (date|datetime)/(duration). So the period in the example above
is a period of 1 month (P1M) starting on 2015-06-01. So it is the data
for June 2015. The notation is a bit more verbose, but it is very
flexible and allows us to support all existing period types in DHIS2

### ADX period definitions

DHIS2 supports a limited number of periods or durations during import.
Periods should begin with the date in which the duration begins, followed by
a "/" and then the duration notation as noted in the table. The
following table details all of the ADX supported period types, along
with examples.

<table>
<caption>ADX Periods</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th>Period type</th>
<th>Duration notation</th>
<th>Example</th>
<th>Duration</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Daily</td>
<td>P1D</td>
<td>2017-10-01/P1M</td>
<td>Oct 01 2017</td>
</tr>
<tr class="even">
<td>Weekly</td>
<td>P7D</td>
<td>2017-10-01/P7D</td>
<td>Oct 01 2017-Oct 07-2017</td>
</tr>
<tr class="odd">
<td>Monthly</td>
<td>P1M</td>
<td>2017-10-01/P1M</td>
<td>Oct 01 2017-Oct 31 2017</td>
</tr>
<tr class="even">
<td>Bi-monthly</td>
<td>P2M</td>
<td>2017-11-01/P2M</td>
<td>Nov 01 2017-Dec 31 2017</td>
</tr>
<tr class="odd">
<td>Quarterly</td>
<td>P3M</td>
<td>2017-09-01/P3M</td>
<td>Sep 01 2017-Dec 31 2017</td>
</tr>
<tr class="even">
<td>Six-monthly</td>
<td>P6M</td>
<td>2017-01-01/P6M</td>
<td>Jan 01 2017-Jun 30 2017</td>
</tr>
<tr class="odd">
<td>Yearly</td>
<td>P1Ý</td>
<td>2017-01-01/P1Y</td>
<td>Jan 01 2017-Dec 31 2017</td>
</tr>
<tr class="even">
<td>Financial October</td>
<td>P1Y</td>
<td>2017-10-01/P1Y</td>
<td>Oct 01 2017-Sep 30 2018</td>
</tr>
<tr class="odd">
<td>Financial April</td>
<td>P1Y</td>
<td>2017-04-01/P1Y</td>
<td>April 1 2017-Mar 31 2018</td>
</tr>
<tr class="even">
<td>Financial July</td>
<td>P1Y</td>
<td>2017-07-01/P1Y</td>
<td>July 1 2017-June 30 2018</td>
</tr>
</tbody>
</table>

### Data values

The dataValue element in adx is very similar to its equivalent in DXF.
The mandatory attributes are *dataElement* and *value*. The *orgUnit* and
*period* attributes don't appear in the dataValue as they are required
at the *group* level.

The most significant difference is the way that disaggregation is
represented. DXF uses the categoryOptionCombo to indicate the disaggregation
of data. In adx the disaggregations (e.g. AGE_GROUP and SEX) are
expressed explicitly as attributes. One important constraint on using
adx is that the categories used for dataElements in the dataSet MUST
have a code assigned to them, and further, that code must be of a form
which is suitable for use as an XML attribute. The exact constraint on
an XML attribute name is described in the W3C XML standard - in practice,
this means no spaces, no non-alphanumeric characters other than '_' and
it may not start with a letter. The example above shows examples of
'good' category codes ('GENDER' and 'HIV_AGE').

This restriction on the form of codes applies only to categories.
Currently, the convention is not enforced by DHIS2 when you are assigning
codes, but you will get an informative error message if you try to
import adx data and the category codes are either not assigned or not
suitable.

The main benefits of using explicit dimensions of disaggregated data are
that

  - The system producing the data does not have to be synchronised with the
    categoryOptionCombo within DHIS2.

  - The producer and consumer can match their codes to a 3rd party
    authoritative source, such as a vterminology service. Note that in
    the example above the Gender and AgeGroup codes are using code lists
    from the [WHO Global Health Observatory](http://apps.who.int/gho/data/node.resources.api).

Note that this feature may be extremely useful, for example when
producing disaggregated data from an EMR system, but there may be cases
where a *categoryOptionCombo* mapping is easier or more desirable. The
DHIS2 implementation of adx will check for the existence of a
*categoryOptionCombo* attribute and, if it exists, it will use that it
preference to exploded dimension attributes. Similarly, an
*attributeOptionCombo* attribute on the *group* element will be
processed in the legacy way. Otherwise, the attributeOptionCombo can be
treated as exploded categories just as on the *dataValue*.

In the simple example above, each of the dataElements in the dataSet
have the same dimensionality (categorycombo) so the data is neatly
rectangular. This need not be the case. dataSets may contain
dataElements with different categoryCombos, resulting in a
*ragged-right* adx data message.

### Importing data

DHIS2 exposes an endpoint for POST adx data at `/api/dataValueSets`
using *application/xml+adx* as content type. So, for example, the
following curl command can be used to POST the example data above to the
DHIS2 demo server:

```bash
curl -u admin:district -X POST -H "Content-Type: application/adx+xml"
  -d @data.xml "https://play.dhis2.org/demo/api/33/dataValueSets?dataElementIdScheme=code&orgUnitIdScheme=code"
```

Note the query parameters are the same as are used with DXF data. The
adx endpoint should interpret all the existing DXF parameters with the
same semantics as DXF.

### Exporting data

DHIS2 exposes an endpoint to GET adx data sets at `/api/dataValueSets`
using *application/xml+adx* as the accepted content type. So, for
example, the following curl command can be used to retrieve the adx
data:

```bash
curl -u admin:district -H "Accept: application/adx+xml"
 "https://play.dhis2.org/demo/api/33/dataValueSets?dataValueSets?orgUnit=M_CLINIC&dataSet=MALARIA&period=201501"
```

Note the query parameters are the same as are used with DXF data. An
important difference is that the identifiers for dataSet and orgUnit are
assumed to be codes rather than uids.

## Program rules

<!--DHIS2-SECTION-ID:webapi_program_rules-->

This section is about sending and reading program rules, and explains
the program rules data model. The program rules give functionality to
configure dynamic behaviour in the programs in DHIS2.

### Program rule model

<!--DHIS2-SECTION-ID:webapi_program_rule_model-->

The program rules data model consists of programRuleVariables,
programRules and programRuleActions. The programRule contains an
expression - when this expression is true, the child programRuleActions
is triggered. The programRuleVariables is used to address data elements,
tracked entity data values and other data values needed to run the
expressions. All programRules in a program share the same library of
programRuleVariables, and one programRuleVariable can be used in several
programRules' expressions.

![](resources/images/program_rules/program-rule-model.jpg)

#### Program rule model details

The following table gives a detailed overview over the programRule
model.

<table style="width:100%;">
<caption>programRule</caption>
<colgroup>
<col style="width: 16%" />
<col style="width: 66%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr class="header">
<th>name</th>
<th>description</th>
<th>Compulsory</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>program</td>
<td>The program of which the programRule is executed in.</td>
<td>Compulsory</td>
</tr>
<tr class="even">
<td>name</td>
<td>The name with which the program rule will be displayed to dhis2 configurators. Not visible to the end user of the program.</td>
<td>Compulsory</td>
</tr>
<tr class="odd">
<td>description</td>
<td>The description of the program rule, can be used by configurators to describe the rule. Not visible to the end user of the program.</td>
<td>Compulsory</td>
</tr>
<tr class="even">
<td>programStage</td>
<td>If a programStage is set for a program rule, the rule will only be evaluated inside the specified program stage.</td>
<td>optional</td>
</tr>
<tr class="odd">
<td>condition</td>
<td>The expression that needs to be evaluated to true in order for the program rule to trigger its child actions. The expression is written using operators, function calls, hard coded values, constants and program rule variables.
<pre><code>d2:hasValue(&#39;hemoglobin&#39;) &amp;&amp; #{hemoglobin} &lt;= 7</code></pre></td>
<td>Compulsory</td>
</tr>
<tr class="even">
<td>priority</td>
<td>The priority to run the rule in cases where the order of the rules matters. In most cases the rules does not depend on being run before or after other rules, and in these cases the priority can be omitted. If no priority is set, the rule will be run after any rules that has a priority defined. If a priority(integer) is set, the rule with the lowest priority will be run before rules with higher priority.</td>
<td>optional</td>
</tr>
</tbody>
</table>

#### Program rule action model details

The following table gives a detailed overview over the programRuleAction
model.

<table style="width:100%;">
<caption>programRuleAction</caption>
<colgroup>
<col style="width: 16%" />
<col style="width: 66%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr class="header">
<th>name</th>
<th>description</th>
<th>Compulsory</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>programRule</td>
<td>The programRule that is the parent of this action.</td>
<td>Compulsory</td>
</tr>
<tr class="even">
<td>programRule- ActionType</td>
<td>The type of action that is to be performed.
<ul>
<li><p>`DISPLAYTEXT` - Displays a text in a given widget.</p></li>
<li><p>`DISPLAYKEYVALUEPAIR` - Displays a key and value pair(like a program indicator) in a given widget.</p></li>
<li><p>`HIDEFIELD` - Hide a specified dataElement or trackedEntityAttribute.</p>
<ul>
<li><p><em>content</em> - if defined, the text in <em>content</em> will be displayed to the end user in the instance where a value is previously entered into a field that is now about to be hidden (and therefore blanked). If <em>content</em> is not defined, a standard message will be shown to the user in this instance.</p></li>
<li><p><em>dataElement</em> - if defined, the HIDEFIELD action will hide this dataElement when the rule is effective.</p></li>
<li><p><em>trackedEntityDataValue</em> - if defined, the HIDEFIELD action will hide this trackedEntityDataValue when the rule is effective.</p></li>
</ul></li>
<li><p>`HIDESECTION` - Hide a specified section.</p>
<ul>
<li><p><em>programStageSection</em> - must be defined. This is the programStageSection that will be hidden in case the parent rule is effective.</p></li>
</ul></li>
<li><p>`ASSIGN` - Assign a dataElement a value(help the user calculate something or fill in an obvious value somewhere)</p>
<ul>
<li><p><em>content</em> - if defined, the value in <em>data</em> is assigned to this variable. If content id defined, and thus a variable is assigned for use in other rules, it is important to also assign a <em>programRule.priority</em> to make sure the rule with an ASSIGN action runs before the rule that will in turn evaluate the assigned variable.</p></li>
<li><p><em>data</em> - must be defined, data forms an expression that is evaluated and assigned to either a variable(#{myVariable}), a dataElement, or both.</p></li>
<li><p><em>dataElement</em> - if defined, the value in <em>data</em> is assigned to this data element.</p></li>
</ul>
<p>Either the content or dataElement must be defined for the ASSIGN action to be effective.</p></li>
<li><p>`SHOWWARNING` - Show a warning to the user, not blocking the user from completing the event or registration.</p>
<ul>
<li><p><em>content</em> - if defined, content is a static part that is displayed at the end of the error message.</p></li>
<li><p><em>data</em> - if defined, data forms an expression that is evaluated and added to the end of the warning message.</p></li>
<li><p><em>dataElement</em> - if defined, the warning message is displayed next to this data element.</p></li>
<li><p><em>trackedEntityAttribute</em> - if defined, the warning message is displayed next to this tracked entity attribute.</p></li>
</ul>
<p>Either dataElement or trackedEntityAttribute must be specified.</p></li>
<li><p>`SHOWERROR` - Show an error to the user, blocking the user from completing the event or registration.</p>
<ul>
<li><p><em>content</em> - if defined, content is a static part that is displayed in the start of the error message.</p></li>
<li><p><em>data</em> - if defined, data forms an expression that is evaluated and added to the end of the error message.</p></li>
<li><p><em>dataElement</em> - if defined, the error message is linked to this data element.</p></li>
<li><p><em>trackedEntityAttribute</em> - if defined, the error message is linked to this tracked entity attribute.</p></li>
</ul>
<p>Either dataElement or trackedEntityAttribute must be specified.</p></li>
<li><p>`WARNINGONCOMPLETINON` - Show a warning to the user on the &quot;Complete form&quot; dialog, but allowing the user to complete the event.</p>
<ul>
<li><p><em>content</em> - if defined, content is a static part that is displayed at the end of the error message.</p></li>
<li><p><em>data</em> - if defined, data forms an expression that is evaluated and added to the end of the warning message.</p></li>
<li><p><em>dataElement</em> - if defined, the warning message prefixed with the name/formName of the data element.</p></li>
</ul></li>
<li><p>`ERRORONCOMPLETION` - Show an error to the user on in a modal window when the user tries to complete the event. The user is prevented from completing the event.</p>
<ul>
<li><p><em>content</em> - if defined, content is a static part that is displayed in the start of the error message.</p></li>
<li><p><em>data</em> - if defined, data forms an expression that is evaluated and added to the end of the error message.</p></li>
<li><p><em>dataElement</em> - if defined, the error message is linked to this data element.</p></li>
</ul></li>
<li><p>`CREATEEVENT` - Create an event within the same enrollment.</p>
<ul>
<li><p><em>content</em></p></li>
<li><p><em>data</em> - if defined, contains data values to assign the created event. The format is &lt;uid&gt;:&lt;data value&gt;. Where several values is specified, these are separated with comma.</p>
<pre><code>AcMrnleqHqc:100,AqK1IHqCkEE:&#39;Polyhydramnios&#39;</code></pre></li>
<li><p><em>programStage</em> - must be defined, and designates the program stage that the rule shall create an event of.</p></li>
</ul></li>
<li><p>`SETMANDATORYFIELD` - Set a field to be mandatory.</p>
<ul>
<li><p><em>dataElement</em> - if defined, this data element will be set to be mandatory in the data entry form.</p></li>
<li><p><em>trackedEntityAttribute</em> - if defined, this tracked entity attribute will be set to mandatory in the registration form or profile.</p></li>
</ul></li>
<li><p>`SENDMESSAGE` - To send message at completion of event/enrollment or at data value update.</p>
<ul>
<li><p><em>messageTemplate</em> - if defined, this template will be delivered either as SMS or EMAIL depending upon DeliveryChannel value in message template.</p></li>
</ul></li>
<li><p>`SCHEDULEMESSAGE` - To schedule message at completion of event/enrollment or at data value update.</p>
<ul>
<li><p><em>messageTemplate</em> - if defined, this template will be delivered either as SMS or EMAIL depending upon DeliveryChannel value in message template.</p></li>
<li><p><em>Date to send message</em> - Expression which is going to be used for evaluation of scheduled date. This expression should result in Date, any other resultant will be discarded and notification will not get scheduled.</p></li>
</ul></li>
</ul></td>
<td>Compulsory</td>
</tr>
<tr class="odd">
<td>location</td>
<td>Used for actionType DISPLAYKEYVALUEPAIR and DISPLAYTEXT to designate which widget to display the text or keyvaluepair in. Compulsory for DISPLAYKEYVALUEPAIR and DISPLAYTEXT.</td>
<td>See description</td>
</tr>
<tr class="even">
<td>content</td>
<td>Used for user messages in the different actions. See the actionType overview for a detailed explanation for how it is used in each of the action types. Compulsory for SHOWWARNING, SHOWERROR, WARNINGONCOMPLETION, ERRORONCOMPLETION, DISPLAYTEXT and DISPLAYKEYVALUEPAIR. Optional for HIDEFIELD and ASSIGN.</td>
<td>See description</td>
</tr>
<tr class="odd">
<td>data</td>
<td>Used for expressions in the different actions. See the actionType overview for a detailed explanation for how it is used in each of the action types. Compulsory for ASSIGN. Optional for SHOWWARNING, SHOWERROR, WARNINGONCOMPLETION, ERRORONCOMPLETION, DISPLAYTEXT, CREATEEVENT and DISPLAYKEYVALUEPAIR</td>
<td>See description</td>
</tr>
<tr class="even">
<td>dataElement</td>
<td>Used for linking rule actions to dataElements. See the actionType overview for a detailed explanation for how it is used in each of the action types. Optional for SHOWWARNING, SHOWERROR, WARNINGONCOMPLETION, ERRORONCOMPLETION, ASSIGN and HIDEFIELD</td>
<td>See description</td>
</tr>
<tr class="odd">
<td>trackedEntity- Attribute</td>
<td>Used for linking rule actions to trackedEntityAttributes. See the actionType overview for a detailed explanation for how it is used in each of the action types. Optional for SHOWWARNING, SHOWERROR and HIDEFIELD.</td>
<td>See description</td>
</tr>
<tr class="even">
<td>option</td>
<td>Used for linking rule actions to options. See the actionType overview for a detailed explanation for how it is used in each of the action types. Optional for HIDEOPTION</td>
<td>See description</td>
</tr>
<tr class="odd">
<td>optionGroup</td>
<td>Used for linking rule actions to optionGroups. See the actionType overview for a detailed explanation for how it is used in each of the action types. Compulsory for SHOWOPTIONGROUP, HIDEOPTIONGROUP.</td>
<td>See description</td>
</tr>
<tr class="even">
<td>programStage</td>
<td>Only used for CREATEEVENT rule actions. Compulsory for CREATEEEVENT.</td>
<td>See description</td>
</tr>
<tr class="odd">
<td>programStage- Section</td>
<td>Only used for HIDESECTION rule actions. Compulsory for HIDESECTION</td>
<td>See description</td>
</tr>
</tbody>
</table>

#### Program rule variable model details

The following table gives a detailed overview over the
programRuleVariable model.

<table style="width:100%;">
<caption>programRuleVariable</caption>
<colgroup>
<col style="width: 16%" />
<col style="width: 66%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr class="header">
<th>name</th>
<th>description</th>
<th>Compulsory</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>the name for the programRuleVariable - this name is used in expressions.
<pre><code>#{myVariable} &gt; 5</code></pre></td>
<td>Compulsory</td>
</tr>
<tr class="even">
<td>sourceType</td>
<td>Defines how this variable is populated with data from the enrollment and events.
<ul>
<li><p>DATAELEMENT_NEWEST_EVENT_PROGRAM_STAGE - In tracker capture, gets the newest value that exists for a data element, within the events of a given program stage in the current enrollment. In event capture, gets the newest value among the 10 newest events on the organisation unit.</p></li>
<li><p>DATAELEMENT_NEWEST_EVENT_PROGRAM - In tracker capture, get the newest value that exists for a data element across the whole enrollment. In event capture, gets the newest value among the 10 newest events on the organisation unit.</p></li>
<li><p>DATAELEMENT_CURRENT_EVENT - Gets the value of the given data element in the current event only.</p></li>
<li><p>DATAELEMENT_PREVIOUS_EVENT - In tracker capture, gets the newest value that exists among events in the program that precedes the current event. In event capture, gets the newvest value among the 10 preceeding events registered on the organisation unit.</p></li>
<li><p>CALCULATED_VALUE - Used to reserve a variable name that will be assigned by a ASSIGN program rule action</p></li>
<li><p>TEI_ATTRIBUTE - Gets the value of a given tracked entity attribute</p></li>
</ul></td>
<td>Compulsory</td>
</tr>
<tr class="odd">
<td>dataElement</td>
<td>Used for linking the programRuleVariable to a dataElement. Compulsory for all sourceTypes that starts with DATAELEMENT_.</td>
<td>See description</td>
</tr>
<tr class="even">
<td>trackedEntity- Attribute</td>
<td>Used for linking the programRuleVariable to a trackedEntityAttribute. Compulsory for sourceType TEI_ATTRIBUTE.</td>
<td>See description</td>
</tr>
<tr class="odd">
<td>useCodeFor- OptionSet</td>
<td>If checked, the variable will be populated with the code - not the name - from any linked option set. Default is unchecked, meaning that the name of the option is populated.</td>
<td></td>
</tr>
<tr class="even">
<td>programStage</td>
<td>Used for specifying a specific program stage to retreive the programRuleVariable value from. Compulsory for DATAELEMENT_NEWEST_EVENT_PROGRAM_STAGE.</td>
<td>See description</td>
</tr>
</tbody>
</table>

### Creating program rules

<!--DHIS2-SECTION-ID:webapi_creating_program_rules-->

- To perform crud operations, `programRules` resource is available in API.

To retrieve list of programRules you can do a GET request like this:

    /api/programRules
    
To retrieve single programRule you can do a GET request like this:

    /api/programRules/<program_rule_uid>
    
To save/add single programRule you can do a POST request like this:

    /api/programRules/<program_rule_uid>
    
To update single programRule you can do a PUT request like this:

    /api/programRules/<program_rule_uid>
    
To delete single programRule you can do a DELETE request like this:

    /api/programRules/<program_rule_uid>
    
To retrieve description of programRule condition you can use POST and provide condition string in the POST body.

    /api/programRules/condition/description?<program_rule_uid>

## Forms

<!--DHIS2-SECTION-ID:webapi_forms-->

To retrieve information about a form (which corresponds to a data set
and its sections) you can interact with the `form` resource. The form
response is accessible as XML and JSON and will provide information
about each section (group) in the form as well as each field in the
sections, including labels and identifiers. By supplying period and
organisation unit identifiers the form response will be populated with
data values.

<table>
<caption>Form query parameters</caption>
<colgroup>
<col style="width: 12%" />
<col style="width: 12%" />
<col style="width: 74%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>pe</td>
<td>ISO period</td>
<td>Period for which to populate form data values.</td>
</tr>
<tr class="even">
<td>ou</td>
<td>UID</td>
<td>Organisation unit for which to populate form data values.</td>
</tr>
<tr class="odd">
<td>metaData</td>
<td>false | true</td>
<td>Whether to include metadata about each data element of form sections.</td>
</tr>
</tbody>
</table>

To retrieve the form for a data set you can do a GET request like this:

    /api/dataSets/<dataset-id>/form.json

To retrieve the form for the data set with identifier "BfMAe6Itzgt" in
XML:

    /api/dataSets/BfMAe6Itzgt/form

To retrieve the form including metadata in JSON:

    /api/dataSets/BfMAe6Itzgt/form.json?metaData=true

To retrieve the form filled with data values for a specific period and
organisation unit in XML:

    /api/dataSets/BfMAe6Itzgt/form.xml?ou=DiszpKrYNg8&pe=201401

When it comes to custom data entry forms, this resource also allows for
creating such forms directly for a data set. This can be done through a
POST or PUT request with content type text/html where the payload is the
custom form markup such as:

```bash
curl -d @form.html "localhost/api/dataSets/BfMAe6Itzgt/form"
  -H "Content-Type:text/html" -u admin:district -X PUT
```

## Documents

<!--DHIS2-SECTION-ID:webapi_documents-->

References to files can be stored with the document resource.

<table>
<caption>Document fields</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>Field name</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>unique name of document</td>
</tr>
<tr class="even">
<td>external</td>
<td>flag identifying the location of the document. TRUE for external files, FALSE for internal ones</td>
</tr>
<tr class="odd">
<td>url</td>
<td>the location of the file. URL for external files. File resource id for internal ones (see <a href="#webapi_file_resources">File resources</a>)</td>
</tr>
</tbody>
</table>

A GET request to the documents endpoint will return all documents:

    /api/documents

A POST request to the documents endpoint will create a new document:

```bash
curl -X POST -d @document.json -H "Content-type: application/json"
  "http://dhis.domain/api/documents"
```

```json
{
  "name": "dhis home",
  "external": true,
  "url": "https://www.dhis2.org"
}
```

A GET request with the id of a document appended will return information
about the document. A PUT request to the same endpoint will update the
fields of the document:

    /api/documents/<documentId>

Appending */data* to the GET request will return the actual file content
of the document:

    /api/documents/<documentId>/data

## Validation

<!--DHIS2-SECTION-ID:webapi_validation-->

To generate a data validation summary you can interact with the
validation resource. The dataSet resource is optimized for data entry
clients for validating a data set / form, and can be accessed like this:

    /api/33/validation/dataSet/QX4ZTUbOt3a.json?pe=201501&ou=DiszpKrYNg8

In addition to validate rules based on data set, there are two
additional methods for performing validation: Custom validation and
Scheduled validation.

Custom validation can be initiated through the "Data Quality" app, where
you can configure the periods, validation rule groups and organisation
units to be included in the analysis and if you want to send out
notifications for and/or persist the results found. The result of this
analysis will be a list of violations found using your criteria.

The first path variable is an identifier referring to the data set to
validate. XML and JSON resource representations are supported. The
response contains violations of validation rules. This will be extended
with more validation types in the coming versions.

To retrieve validation rules which are relevant for a specific data set,
meaning validation rules with formulas where all data elements are part
of the specific data set, you can make a GET request to to
`validationRules` resource like this:

    /api/validationRules?dataSet=<dataset-id>

The validation rules have a left side and a right side, which is
compared for validity according to an operator. The valid operator
values are found in the table below.

<table>
<caption>Operators</caption>
<colgroup>
<col style="width: 28%" />
<col style="width: 71%" />
</colgroup>
<thead>
<tr class="header">
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>equal_to</td>
<td>Equal to</td>
</tr>
<tr class="even">
<td>not_equal_to</td>
<td>Not equal to</td>
</tr>
<tr class="odd">
<td>greater_than</td>
<td>Greater than</td>
</tr>
<tr class="even">
<td>greater_than_or_equal_to</td>
<td>Greater than or equal to</td>
</tr>
<tr class="odd">
<td>less_than</td>
<td>Less than</td>
</tr>
<tr class="even">
<td>less_than_or_equal_to</td>
<td>Less than or equal to</td>
</tr>
<tr class="odd">
<td>compulsory_pair</td>
<td>If either side is present, the other must also be</td>
</tr>
<tr class="even">
<td>exclusive_pair</td>
<td>If either side is present, the other must not be</td>
</tr>
</tbody>
</table>

The left side and right side expressions are mathematical expressions
which can contain references to data elements and category option
combinations on the following format:

    ${<dataelement-id>.<catoptcombo-id>}

The left side and right side expressions have a *missing value
strategy*. This refers to how the system should treat data values which
are missing for data elements / category option combination references
in the formula in terms of whether the validation rule should be checked
for validity or skipped. The valid missing value strategies are found in
the table below.

<table>
<caption>Missing value strategies</caption>
<colgroup>
<col style="width: 28%" />
<col style="width: 71%" />
</colgroup>
<thead>
<tr class="header">
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>SKIP_IF_ANY_VALUE_MISSING</td>
<td>Skip validation rule if any data value is missing</td>
</tr>
<tr class="even">
<td>SKIP_IF_ALL_VALUES_MISSING</td>
<td>Skip validation rule if all data values are missing</td>
</tr>
<tr class="odd">
<td>NEVER_SKIP</td>
<td>Never skip validation rule irrespective of missing data values</td>
</tr>
</tbody>
</table>

## Validation Results

<!--DHIS2-SECTION-ID:webapi_validation_results-->

Validation results are persisted results of violations found during a
validation analysis. If you choose "persist results" when starting or
scheduling a validation analysis, any violations found will be stored in
the database. When a result is stored in the database it will be used
for 3 things:

1.  Generating analytics based on the stored results.

2.  Persisted results that have not generated a notification, will do so,
    once.

3.  Keeping track of whether or not the result has generated a
    notification.

4.  Skipping rules that have been already checked when running
    validation analysis.

This means if you don't persist your results, you will be unable to
generate analytics for validation results, if checked, results will
generate notifications every time it's found and running validation
analysis might be slower.

The validation results persisted can be viewed at the following
endpoint:

    /api/33/validationResults

You can also inspect an individual result using the validation result id
in this endpoint:

    /api/33/validationResults/<id>

Validation results are sent out to the appropriate users once every day,
but can also be manually triggered to run on demand using the following
api endpoint:

    /api/33/validation/sendNotifications

Only unsent results are sent using this endpoint.

## Data analysis

<!--DHIS2-SECTION-ID:webapi_data_analysis-->

Several resources for performing data analysis and finding data quality
and validation issues are provided.

### Validation rule analysis

<!--DHIS2-SECTION-ID:webapi_data_analysis_validation_rules-->

To run validation rules and retrieve violations:

    /api/dataAnalysis/validationRules

The following query parameters are supported:

<table>
<caption>Validation rule analysis query parameters</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
<th>Option</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>vrg</td>
<td>Validation rule group</td>
<td>ID</td>
</tr>
<tr class="even">
<td>ou</td>
<td>Organisation unit</td>
<td>ID</td>
</tr>
<tr class="odd">
<td>startDate</td>
<td>Start date for the timespan</td>
<td>Date</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>End date for the timespan</td>
<td>Date</td>
</tr>
<tr class="odd">
<td>persist</td>
<td>Whether to persist violations in the system</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>notification</td>
<td>Whether to send notifications about violations</td>
<td>false | true</td>
</tr>
</tbody>
</table>

Sample output:
```json
    [{
	"validationRuleId": "kgh54Xb9LSE",
	"validationRuleDescription": "Malaria outbreak",
	"organisationUnitId": "DiszpKrYNg8",
	"organisationUnitDisplayName": "Ngelehun CHC",
	"organisationUnitPath": "/ImspTQPwCqd/O6uvpzGd5pu/YuQRtpLP10I/DiszpKrYNg8",
	"organisationUnitAncestorNames": "Sierra Leone / Bo / Badjia / ",
	"periodId": "201901",
	"periodDisplayName": "January 2019",
	"attributeOptionComboId": "HllvX50cXC0",
	"attributeOptionComboDisplayName": "default",
	"importance": "MEDIUM",
	"leftSideValue": 10.0,
	"operator": ">",
	"rightSideValue": 14.0
}, {
	"validationRuleId": "ZoG4yXZi3c3",
	"validationRuleDescription": "ANC 2 cannot be higher than ANC 1",
	"organisationUnitId": "DiszpKrYNg8",
	"organisationUnitDisplayName": "Ngelehun CHC",
	"organisationUnitPath": "/ImspTQPwCqd/O6uvpzGd5pu/YuQRtpLP10I/DiszpKrYNg8",
	"organisationUnitAncestorNames": "Sierra Leone / Bo / Badjia / ",
	"periodId": "201901",
	"periodDisplayName": "January 2019",
	"attributeOptionComboId": "HllvX50cXC0",
	"attributeOptionComboDisplayName": "default",
	"importance": "MEDIUM",
	"leftSideValue": 22.0,
	"operator": "<=",
	"rightSideValue": 19.0
}]
```

### Standard deviation based outlier analysis

<!--DHIS2-SECTION-ID:webapi_data_analysis_std_dev_outlier-->

To identify data outliers based on standard deviations of the average
value:

    /api/dataAnalysis/stdDevOutlier

The following query parameters are supported:

<table>
<caption>Standard deviation outlier analysis query parameters</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
<th>Option</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ou</td>
<td>Organisation unit</td>
<td>ID</td>
</tr>
<tr class="even">
<td>startDate</td>
<td>Start date for the timespan</td>
<td>Date</td>
</tr>
<tr class="odd">
<td>endDate</td>
<td>End date for the timespan</td>
<td>Date</td>
</tr>
<tr class="even">
<td>ds</td>
<td>Data sets, parameter can be repeated</td>
<td>ID</td>
</tr>
<tr class="odd">
<td>standardDeviation</td>
<td>Number of standard deviations from the average</td>
<td>Numeric value</td>
</tr>
</tbody>
</table>

### Min/max value based outlier analysis

<!--DHIS2-SECTION-ID:webapi_data_analysis_min_max_outlier-->

To identify data outliers based on min/max values:

    /api/dataAnalysis/minMaxOutlier

The supported query parameters are equal to the *std dev based outlier
analysis* resource described above.

### Follow-up data analysis

To identify data marked for follow-up:

    /api/dataAnalysis/followup

The supported query parameters are equal to the *std dev based outlier
analysis* resource described above.

## Data integrity

<!--DHIS2-SECTION-ID:webapi_data_integrity-->

The data integrity capabilities of the data administration module are
available through the web API. This section describes how to run the
data integrity process as well as retrieving the result. The details of
the analysis performed are described in the user manual.

### Running data integrity

<!--DHIS2-SECTION-ID:webapi_data_integrity_run-->

The operation of measuring data integrity is a fairly resource (and
time) demanding task. It is therefore run as an asynchronous process and
only when explicitly requested. Starting the task is done by forming an
empty POST request to the *dataIntegrity* endpoint like so (demonstrated
in curl syntax):

```bash
curl -X POST "https://localhost/api/33/dataIntegrity"
```

If successful the request will return HTTP 202 immediately. The location
header of the response points to the resource used to check the status
of the request. The payload also contains a json object of the job
created. Forming a GET request to the given location yields an empty
JSON response if the task has not yet completed and a JSON taskSummary
object when the task is done. Polling (conservatively) to this resource
can hence be used to wait for the task to finish.

### Fetching the result

<!--DHIS2-SECTION-ID:webapi_data_integrity_fetch_results-->

Once data integrity is finished running the result can be fetched from
the `system/taskSummaries` resource like so:

```bash
curl "https://dhis.domain/api/33/system/taskSummaries/DATAINTEGRITY"
```

The returned object contains a summary for each point of analysis,
listing the names of the relevant integrity violations. As stated in the
leading paragraph for this section the details of the analysis (and the
resulting data) can be found in the user manual chapter on Data
Administration.

## Indicators

<!--DHIS2-SECTION-ID:webapi_indicators-->

This section describes indicators and indicator expressions.

### Aggregate indicators

<!--DHIS2-SECTION-ID:webapi_aggregate_indicators-->

To retrieve indicators you can make a GET request to the indicators
resource like this:

    /api/indicators

Indicators represent expressions which can be calculated and presented
as a result. The indicator expressions are split into a numerator and
denominator. The numerators and denominators are mathematical
expressions which can contain references to data elements, other indicators, constants and
organisation unit groups. The variables will be substituted with data
values when used e.g. in reports. Variables which are allowed in
expressions are described in the following table.

<table>
<caption>Indicator variables</caption>
<colgroup>
<col style="width: 39%" />
<col style="width: 22%" />
<col style="width: 37%" />
</colgroup>
<thead>
<tr class="header">
<th>Variable</th>
<th>Object</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>#{&lt;dataelement-id&gt;.&lt;categoryoptcombo-id&gt;.&lt;attributeoptcombo-id&gt;}</td>
<td>Data element operand</td>
<td>Refers to a combination of an aggregate data element and a category option combination. Both category and attribute option combo ids are optional, and a wildcard &quot;*&quot; symbol can be used to indicate any value.</td>
</tr>
<tr class="even">
<td>#{&lt;dataelement-id&gt;.&lt;categoryoptiongroup-id&gt;.&lt;attributeoptcombo-id&gt;}</td>
<td>Category Option Group</td>
<td>Refers to an aggregate data element and a category option group, containing multiple category option combinations.</td>
</tr>
<tr class="odd">
<td>#{&lt;dataelement-id&gt;}</td>
<td>Aggregate data element</td>
<td>Refers to the total value of an aggregate data element across all category option combinations.</td>
</tr>
<tr class="even">
<td>D{&lt;program-id&gt;.&lt;dataelement-id&gt;}</td>
<td>Program data element</td>
<td>Refers to the value of a tracker data element within a program.</td>
</tr>
<tr class="odd">
<td>A{&lt;program-id&gt;.&lt;attribute-id&gt;}</td>
<td>Program tracked entity attribute</td>
<td>Refers to the value of a tracked entity attribute within a program.</td>
</tr>
<tr class="even">
<td>I{&lt;program-indicator-id&gt;}</td>
<td>Program indicator</td>
<td>Refers to the value of a program indicator.</td>
</tr>
<tr class="odd">
<td>R{&lt;dataset-id&gt;.&lt;metric&gt;}</td>
<td>Reporting rate</td>
<td>Refers to a reporting rate metric. The metric can be REPORTING_RATE, REPORTING_RATE_ON_TIME, ACTUAL_REPORTS, ACTUAL_REPORTS_ON_TIME, EXPECTED_REPORTS.</td>
</tr>
<tr class="even">
<td>C{&lt;constant-id&gt;}</td>
<td>Constant</td>
<td>Refers to a constant value.</td>
</tr>
<tr class="odd">
<td>N{&lt;indicator-id&gt;}</td>
<td>Indicator</td>
<td>Refers to an existing Indicator.</td>
</tr>
<tr class="even">
<td>OUG{&lt;orgunitgroup-id&gt;}</td>
<td>Organisation unit group</td>
<td>Refers to the count of organisation units within an organisation unit group.</td>
</tr>
</tbody>
</table>

The syntax looks like
    this:

    #{<dataelement-id>.<catoptcombo-id>} + C{<constant-id>} + OUG{<orgunitgroup-id>}

A corresponding example looks like this:

    #{P3jJH5Tu5VC.S34ULMcHMca} + C{Gfd3ppDfq8E} + OUG{CXw2yu5fodb}

Note that for data element variables the category option combo
identifier can be omitted. The variable will then represent the total
for the data element, e.g. across all category option combos. Example:

    #{P3jJH5Tu5VC} + 2

Data element operands can include any of category option combination and
attribute option combination, and use wildcards to indicate any
    value:

    #{P3jJH5Tu5VC.S34ULMcHMca} + #{P3jJH5Tu5VC.*.j8vBiBqGf6O} + #{P3jJH5Tu5VC.S34ULMcHMca.*}

An example which uses a program data element and a program
    attribute:

    ( D{eBAyeGv0exc.vV9UWAZohSf} * A{IpHINAT79UW.cejWyOfXge6} ) / D{eBAyeGv0exc.GieVkTxp4HH}

An example which combines program indicators and aggregate indicators:

    I{EMOt6Fwhs1n} * 1000 / #{WUg3MYWQ7pt}

An example which uses a reporting rate looks like this:

    R{BfMAe6Itzgt.REPORTING_RATE} * #{P3jJH5Tu5VC.S34ULMcHMca}

Another example which uses actual data set reports:

    R{BfMAe6Itzgt.ACTUAL_REPORTS} / R{BfMAe6Itzgt.EXPECTED_REPORTS}

An example which uses an existing indicator would look like this:

    N{Rigf2d2Zbjp} * #{P3jJH5Tu5VC.S34ULMcHMca}

Expressions can be any kind of valid mathematical expression, as an
example:

    ( 2 * #{P3jJH5Tu5VC.S34ULMcHMca} ) / ( #{FQ2o8UBlcrS.S34ULMcHMca} - 200 ) * 25

### Program indicators

<!--DHIS2-SECTION-ID:webapi_program_indicators-->

To retrieve program indicators you can make a GET request to the program
indicators resource like this:

    /api/programIndicators

Program indicators can contain information collected in a program.
Indicators have an expression which can contain references to data
elements, attributes, constants and program variables. Variables which
are allowed in expressions are described in the following table.

<table>
<caption>Program indicator variables</caption>
<colgroup>
<col style="width: 31%" />
<col style="width: 68%" />
</colgroup>
<thead>
<tr class="header">
<th>Variable</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>#{&lt;programstage-id&gt;.&lt;dataelement-id&gt;}</td>
<td>Refers to a combination of program stage and data element id.</td>
</tr>
<tr class="even">
<td>A{&lt;attribute-id&gt;}</td>
<td>Refers to a tracked entity attribute.</td>
</tr>
<tr class="odd">
<td>V{&lt;variable-id&gt;}</td>
<td>Refers to a program variable.</td>
</tr>
<tr class="even">
<td>C{&lt;constant-id&gt;}</td>
<td>Refers to a constant.</td>
</tr>
</tbody>
</table>

The syntax looks like
    this:

    #{<programstage-id>.<dataelement-id>} + #{<attribute-id>} + V{<varible-id>} + C{<constant-id>}

A corresponding example looks like
    this:

    #{A03MvHHogjR.a3kGcGDCuk6} + A{OvY4VVhSDeJ} + V{incident_date} + C{bCqvfPR02Im}

### Expressions

<!--DHIS2-SECTION-ID:webapi_expressions-->

Expressions are mathematical formulas which can contain references to
data elements, constants and organisation unit groups. To validate and
get the textual description of an expression, you can make a GET request
to the expressions resource:

    /api/expressions/description?expression=<expression-string>

The response follows the standard JSON web message format. The *status*
property indicates the outcome of the validation and will be "OK" if
successful and "ERROR" if failed. The *message* property will be "Valid"
if successful and provide a textual description of the reason why the
validation failed if not. The *description* provides a textual
description of the expression.

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "message": "Valid",
  "description": "Acute Flaccid Paralysis"
}
```

## Complete data set registrations

<!--DHIS2-SECTION-ID:webapi_complete_data_set_registrations-->

This section is about complete data set registrations for data sets. A
registration marks as a data set as completely captured.

### Completing data sets

<!--DHIS2-SECTION-ID:webapi_completing_data_sets-->

This section explains how to register data sets as complete. This is
achieved by interacting with the *completeDataSetRegistrations*
resource:

    /api/33/completeDataSetRegistrations

The endpoint supports the *POST* method for registering data set
completions. The endpoint is functionally very similar to the
*dataValueSets* endpoint, with support for bulk import of complete
registrations.

Importing both *XML* and *JSON* formatted payloads are supported. The
basic format of this payload, given as *XML* in this example, is like
so:

```xml
<completeDataSetRegistrations xmlns="http://dhis2.org/schema/dxf/2.0">
  <completeDataSetRegistration period="200810" dataSet="eZDhcZi6FLP" 
    organisationUnit="qhqAxPSTUXp" attributeOptionCombo="bRowv6yZOF2" storedBy="imported"/>
  <completeDataSetRegistration period="200811" dataSet="eZDhcZi6FLP" 
    organisationUnit="qhqAxPSTUXp" attributeOptionCombo="bRowv6yZOF2" storedBy="imported"/>
</completeDataSetRegistrations>
```

The *storedBy* attribute is optional (as it is a nullable property on
the complete registration object). You can also optionally set the
*date* property (time of registration) as an attribute. It the time is
not set, the current time will be used.

The import process supports the following query parameters:

<table>
<caption>Complete data set registrations query parameters</caption>
<colgroup>
<col style="width: 16%" />
<col style="width: 18%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Values</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dataSetIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the data set to use to map the complete registrations.</td>
</tr>
<tr class="even">
<td>orgUnitIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the organisation unit to use to map the complete registrations.</td>
</tr>
<tr class="odd">
<td>attributeOptionComboIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the attribute option combos to use to map the complete registrations.</td>
</tr>
<tr class="even">
<td>idScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of all objects including data sets, org units and attribute option combos, to use to map the complete registrations.</td>
</tr>
<tr class="odd">
<td>preheatCache</td>
<td>false | true</td>
<td>Whether to save changes on the server or just return the import summary.</td>
</tr>
<tr class="even">
<td>dryRun</td>
<td>false | true</td>
<td>Whether registration applies to sub units</td>
</tr>
<tr class="odd">
<td>importStrategy</td>
<td>CREATE | UPDATE | CREATE_AND_UPDATE | DELETE</td>
<td>Save objects of all, new or update import status on the server.</td>
</tr>
<tr class="even">
<td>skipExistingCheck</td>
<td>false | true</td>
<td>Skip checks for existing complete registrations. Improves performance. Only use for empty databases or when the registrations to import do not exist already.</td>
</tr>
<tr class="odd">
<td>async</td>
<td>false | true</td>
<td>Indicates whether the import should be done asynchronous or synchronous. The former is suitable for very large imports as it ensures that the request does not time out, although it has a significant performance overhead. The latter is faster but requires the connection to persist until the process is finished.</td>
</tr>
</tbody>
</table>

### Reading complete data set registrations

<!--DHIS2-SECTION-ID:webapi_reading_complete_data_sets-->

This section explains how to retrieve data set completeness
registrations. We will be using the *completeDataSetRegistrations*
resource. The query parameters to use are these:

<table>
<caption>Data value set query parameters</caption>
<colgroup>
<col style="width: 18%" />
<col style="width: 81%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dataSet</td>
<td>Data set identifier, multiple data sets are allowed</td>
</tr>
<tr class="even">
<td>period</td>
<td>Period identifier in ISO format. Multiple periods are allowed.</td>
</tr>
<tr class="odd">
<td>startDate</td>
<td>Start date for the time span of the values to export</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>End date for the time span of the values to export</td>
</tr>
<tr class="odd">
<td>created</td>
<td>Include only registrations which were created since the given timestamp</td>
</tr>
<tr class="even">
<td>createdDuration</td>
<td>Include only registrations which were created within the given duration. The format is &lt;value&gt;&lt;time-unit&gt;, where the supported time units are &quot;d&quot;, &quot;h&quot;, &quot;m&quot;, &quot;s&quot; <em>(days, hours, minutes, seconds).</em> The time unit is relative to the current time.</td>
</tr>
<tr class="odd">
<td>orgUnit</td>
<td>Organisation unit identifier, can be specified multiple times. Not applicable if orgUnitGroup is given.</td>
</tr>
<tr class="even">
<td>orgUnitGroup</td>
<td>Organisation unit group identifier, can be specified multiple times. Not applicable if orgUnit is given.</td>
</tr>
<tr class="odd">
<td>children</td>
<td>Whether to include the children in the hierarchy of the organisation units</td>
</tr>
<tr class="even">
<td>limit</td>
<td>The maximum number of registrations to include in the response.</td>
</tr>
<tr class="odd">
<td>idScheme</td>
<td>Identifier property used for meta data objects in the response.</td>
</tr>
<tr class="even">
<td>dataSetIdScheme</td>
<td>Identifier property used for data sets in the response. Overrides idScheme.</td>
</tr>
<tr class="odd">
<td>orgUnitIdScheme</td>
<td>Identifier property used for organisation units in the response. Overrides idScheme.</td>
</tr>
<tr class="even">
<td>attributeOptionComboIdScheme</td>
<td>Identifier property used for attribute option combos in the response. Overrides idScheme.</td>
</tr>
</tbody>
</table>

The dataSet and orgUnit parameters can be repeated in order to include
multiple data sets and organisation units.

The period, start/end date, created and createdDuration parameters
provide multiple ways to set the time dimension for the request, thus only
one can be used. For example, it doesn't make sense to both set the
start/end date and to set the periods.

An example request looks like this:

```bash
curl "https://play.dhis2.org/demo/api/33/completeDataSetRegistrations?dataSet=pBOMPrpg1QX
  &dataSet=pBOMPrpg1QX&startDate=2014-01-01&endDate=2014-01-31&orgUnit=YuQRtpLP10I
  &orgUnit=vWbkYPRmKyS&children=true"
  -H "Accept:application/xml" -u admin:district
```

You can get the response in *xml* and *json* format. You can indicate
which response format you prefer through the *Accept* HTTP header like
in the example above. For xml you use *application/xml*; for json you
use *application/json*.

### Un-completing data sets

<!--DHIS2-SECTION-ID:webapi_uncompleting_data_sets-->

This section explains how you can un-register the completeness of a data
set. To un-complete a data set you will interact with the
completeDataSetRegistrations resource:

    /api/33/completeDataSetRegistrations

This resource supports *DELETE* for un-registration. The following query
parameters are supported:

<table>
<caption>Complete data set registrations query parameters</caption>
<colgroup>
<col style="width: 16%" />
<col style="width: 18%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ds</td>
<td>Yes</td>
<td>Data set identifier</td>
</tr>
<tr class="even">
<td>pe</td>
<td>Yes</td>
<td>Period identifier</td>
</tr>
<tr class="odd">
<td>ou</td>
<td>Yes</td>
<td>Organisation unit identifier</td>
</tr>
<tr class="even">
<td>cc</td>
<td>No (must combine with cp)</td>
<td>Attribute combo identifier (for locking check)</td>
</tr>
<tr class="odd">
<td>cp</td>
<td>No (must combine with cp)</td>
<td>Attribute option identifiers, separated with ; for multiple values (for locking check)</td>
</tr>
<tr class="even">
<td>multiOu</td>
<td>No (default false)</td>
<td>Whether registration applies to sub units</td>
</tr>
</tbody>
</table>

## Data approval

<!--DHIS2-SECTION-ID:webapi_data_approval-->

This section explains how to approve, unapprove and check approval
status using the *dataApprovals* resource. Approval is done per data
approval workflow, period, organisation unit and attribute option combo.

    /api/33/dataApprovals

A data approval workflow is associated with several entities:

* A period type which defines the frequency of approval
* An optional category combination
* One or many data approval levels which are part of the workflow
* One or many data sets which are used for data collection

### Get approval status

<!--DHIS2-SECTION-ID:webapi_data_approval_get_status-->

To get approval information for a data set you can issue a GET request:

    /api/dataApprovals?wf=rIUL3hYOjJc&pe=201801&ou=YuQRtpLP10I

<table style="width:100%;">
<caption>Data approval query parameters</caption>
<colgroup>
<col style="width: 16%" />
<col style="width: 18%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>wf</td>
<td>Yes</td>
<td>Data approval workflow identifier</td>
</tr>
<tr class="even">
<td>pe</td>
<td>Yes</td>
<td>Period identifier</td>
</tr>
<tr class="odd">
<td>ou</td>
<td>Yes</td>
<td>Organisation unit identifier</td>
</tr>
<tr class="even">
<td>aoc</td>
<td>No</td>
<td>Attribute option combination identifier</td>
</tr>
</tbody>
</table>

> **Note**
>
> For backward compatibility, the parameter `ds` for data set may be given instead of `wf` for workflow in this and other data approval requests as described below. If the data set is given, the workflow associated with that data set will be used.

This will produce a response similar to this:

```json
{
  "mayApprove": false,
  "mayUnapprove": false,
  "mayAccept": false,
  "mayUnaccept": false,
  "state": "UNAPPROVED_ELSEWHERE"
}
```

The returned parameters are:

<table>
<caption>Data approval returned parameters</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr class="header">
<th>Return Parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>mayApprove</td>
<td>Whether the current user may approve this data selection.</td>
</tr>
<tr class="even">
<td>mayUnapprove</td>
<td>Whether the current user may unapprove this data selection.</td>
</tr>
<tr class="odd">
<td>mayAccept</td>
<td>Whether the current user may accept this data selection.</td>
</tr>
<tr class="even">
<td>mayUnaccept</td>
<td>Whether the current user may unaccept this data selection.</td>
</tr>
<tr class="odd">
<td>state</td>
<td>One of the data approval states from the table below.</td>
</tr>
</tbody>
</table>

<table>
<caption>Data approval states</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 66%" />
</colgroup>
<thead>
<tr class="header">
<th>State</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>UNAPPROVABLE</td>
<td>Data approval does not apply to this selection. (Data is neither approved nor unapproved.)</td>
</tr>
<tr class="even">
<td>UNAPPROVED_WAITING</td>
<td>Data could be approved for this selection, but is waiting for some lower-level approval before it is ready to be approved.</td>
</tr>
<tr class="odd">
<td>UNAPPROVED_ELSEWHERE</td>
<td>Data is unapproved, and is waiting for approval somewhere else (not approvable here.)</td>
</tr>
<tr class="even">
<td>UNAPPROVED_READY</td>
<td>Data is unapproved, and is ready to be approved for this selection.</td>
</tr>
<tr class="odd">
<td>APPROVED_HERE</td>
<td>Data is approved, and was approved here (so could be unapproved here.)</td>
</tr>
<tr class="even">
<td>APPROVED_ELSEWHERE</td>
<td>Data is approved, but was not approved here (so cannot be unapproved here.) This covers the following cases:
<ul>
<li><p>Data is approved at a higher level.</p></li>
<li><p>Data is approved for wider scope of category options.</p></li>
<li><p>Data is approved for all sub-periods in selected period.</p></li>
</ul>
In the first two cases, there is a single data approval object that covers the selection. In the third case there is not.</td>
</tr>
<tr class="odd">
<td>ACCEPTED_HERE</td>
<td>Data is approved and accepted here (so could be unapproved here.)</td>
</tr>
<tr class="even">
<td>ACCEPTED_ELSEWHERE</td>
<td>Data is approved and accepted, but elsewhere.</td>
</tr>
</tbody>
</table>

Note that when querying for the status of data approval, you may specify
any combination of the query parameters. The combination you specify
does not need to describe the place where data is to be approved at one
of the approval levels. For example:

  - The organisation unit might not be at an approval level. The
    approval status is determined by whether data is approved at an
    approval level for an ancestor of the organisation unit.

  - You may specify individual attribute category options. The approval
    status is determined by whether data is approved for an attribute
    category option combination that includes one or more of these
    options.

  - You may specify a time period that is longer than the period for the
    data set at which the data is entered and approved. The approval
    status is determined by whether the data is approved for all the
    data set periods within the period you specify.

For data sets which are associated with a category combo you might want
to fetch data approval records for individual attribute option combos
from the following resource with a GET request:

    /api/dataApprovals/categoryOptionCombos?wf=rIUL3hYOjJc&pe=201801&ou=YuQRtpLP10I

### Bulk get approval status

To get a list of multiple approval statuses, you can issue a GET request similar to this:

    /api/dataApprovals/approvals?wf=rIUL3hYOjJc&pe=201801,201802&ou=YuQRtpLP10I

The parameters `wf`, `pe`, `ou`, and `aoc` are the same as for getting a single approval status, except that you can provide a comma-separated list of one or more values for each parameter.

This will give you a response containing a list of approval parameters and statuses, something like this:

```json
[
  {
    "aoc": "HllvX50cXC0",
    "pe": "201801",
    "level": "KaTJLhGmU95",
    "ou": "YuQRtpLP10I",
    "permissions": {
      "mayApprove": false,
      "mayUnapprove": true,
      "mayAccept": true,
      "mayUnaccept": false,
      "mayReadData": true
    },
    "state": "APPROVED_HERE",
    "wf": "rIUL3hYOjJc"
  },
  {
    "aoc": "HllvX50cXC0",
    "pe": "201802",
    "ou": "YuQRtpLP10I",
    "permissions": {
      "mayApprove": true,
      "mayUnapprove": false,
      "mayAccept": false,
      "mayUnaccept": false,
      "mayReadData": true
    },
    "state": "UNAPPROVED_READY",
    "wf": "rIUL3hYOjJc"
  }
]
```

The returned fields are described in the table below.

| Field       | Description |
| ----------- | ----------- |
| aoc         | Attribute option combination identifier |
| pe          | Period identifier |
| ou          | Organisation Unit identifier |
| permissions | The permissions: 'mayApprove', 'mayUnapprove', 'mayAccept', 'mayUnaccept', and 'mayReadData' (same definitions as for get single approval status). |
| state       | One of the data approval states (same as for get single approval status.) |
| wf          | Data approval workflow identifier |

### Approve data

<!--DHIS2-SECTION-ID:webapi_data_approval_approve_data-->

To approve data you can issue a *POST* request to the *dataApprovals*
resource. To un-approve data, you can issue a *DELETE* request to the
dataApprovals resource.

    POST DELETE /api/33/dataApprovals

To accept data that is already approved you can issue a *POST* request
to the *dataAcceptances* resource. To un-accept data, you can issue a
*DELETE* request to the *dataAcceptances* resource.

    POST DELETE /api/33/dataAcceptances

These requests contain the following parameters:

<table style="width:100%;">
<caption>Data approval action parameters</caption>
<colgroup>
<col style="width: 16%" />
<col style="width: 18%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr class="header">
<th>Action parameter</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>wf</td>
<td>Yes</td>
<td>Data approval workflow identifier</td>
</tr>
<tr class="even">
<td>pe</td>
<td>Yes</td>
<td>Period identifier</td>
</tr>
<tr class="odd">
<td>ou</td>
<td>Yes</td>
<td>Organisation unit identifier</td>
</tr>
<tr class="even">
<td>aoc</td>
<td>No</td>
<td>Attribute option combination identifier</td>
</tr>
</tbody>
</table>

Note that, unlike querying the data approval status, you must specify
parameters that correspond to a selection of data that could be
approved. In particular, both of the following must be true:

  - The organisation unit's level must be specified by an approval level
    in the workflow.

  - The time period specified must match the period type of the
    workflow.

### Bulk approve data

<!--DHIS2-SECTION-ID:webapi_data_approval_bulk_approve_data-->

You can approve a bulk of data records by posting to
the `/api/dataApprovals/approvals` resource.

    POST /api/33/dataApprovals/approvals

You can unapprove a bulk of data records by posting to the
`/api/dataApprovals/unapprovals` resource.

    POST /api/33/dataApprovals/unapprovals

You can accept a bulk of records by posting to the
`/api/dataAcceptances/acceptances` resource.

    POST /api/33/dataAcceptances/acceptances

You can unaccept a bulk of records by posting to the
`/api/dataAcceptances/unacceptances` resource.

    POST /api/33/dataAcceptances/unacceptances

The approval payload is supported as JSON and looks like this:

```json
{
  "wf": [
    "pBOMPrpg1QX", "lyLU2wR22tC"
  ],
  "pe": [
    "201601", "201602"
  ],
  "approvals": [
    {
      "ou": "cDw53Ej8rju",
      "aoc": "ranftQIH5M9"
    }, 
    {
      "ou": "cDw53Ej8rju",
      "aoc": "fC3z1lcAW5x"
    }
  ]
}
```

### Get data approval levels

To retrieve data approval workflows and their data approval levels you 
can make a GET request similar to this:

    /api/dataApprovalWorkflows?
      fields=id,name,periodType,dataApprovalLevels[id,name,level,orgUnitLevel]

## Auditing

<!--DHIS2-SECTION-ID:webapi_auditing-->

DHIS2 does automatic auditing on all updates and deletions of aggregate
data values, tracked entity data values, tracked entity attribute
values, and data approvals. This section explains how to fetch this
data.

### Aggregate data value audits

<!--DHIS2-SECTION-ID:webapi_auditing_aggregate_audits-->

The endpoint for aggregate data value audits is located at
`/api/audits/dataValue`, and the available parameters are displayed in
the table below.

<table>
<caption>Aggregate data value query parameters</caption>
<colgroup>
<col style="width: 12%" />
<col style="width: 14%" />
<col style="width: 72%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ds</td>
<td>Data Set</td>
<td>One or more data set identifiers to get data elements from.</td>
</tr>
<tr class="even">
<td>de</td>
<td>Data Element</td>
<td>One or more data element identifiers.</td>
</tr>
<tr class="odd">
<td>pe</td>
<td>ISO Period</td>
<td>One or more period ISO identifiers.</td>
</tr>
<tr class="even">
<td>ou</td>
<td>Organisation Unit</td>
<td>One or more org unit identifiers.</td>
</tr>
<tr class="odd">
<td>auditType</td>
<td>UPDATE | DELETE</td>
<td>Filter by audit type.</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off</td>
</tr>
<tr class="odd">
<td>page</td>
<td>1 (default)</td>
<td>If paging is enabled, this parameter decides which page to show</td>
</tr>
</tbody>
</table>

Get all audits for data set with ID *lyLU2wR22tC*:

    /api/33/audits/dataValue?ds=lyLU2wR22tC

### Tracked entity data value audits

<!--DHIS2-SECTION-ID:webapi_tracked_entity_data_value_audits-->

The endpoint for tracked entity data value audits is located at
`/api/audits/trackedEntityDataValue`, and the available parameters are
displayed in the table below.

<table>
<caption>Tracked entity data value query parameters</caption>
<colgroup>
<col style="width: 12%" />
<col style="width: 16%" />
<col style="width: 71%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>de</td>
<td>Data Element</td>
<td>One or more data element identifiers.</td>
</tr>
<tr class="even">
<td>ps</td>
<td>Program Stage Entity</td>
<td>One or more program stage instance identifiers.</td>
</tr>
<tr class="odd">
<td>auditType</td>
<td>UPDATE | DELETE</td>
<td>Filter by audit type.</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off</td>
</tr>
<tr class="odd">
<td>page</td>
<td>1 (default)</td>
<td>If paging is enabled, this parameter decides which page to show</td>
</tr>
</tbody>
</table>

Get all audits which have data element ID eMyVanycQSC or qrur9Dvnyt5:

    /api/33/audits/trackedEntityDataValue?de=eMyVanycQSC&de=qrur9Dvnyt5

### Tracked entity attribute value audits

<!--DHIS2-SECTION-ID:webapi_tracked_entity_attribute_value_audits-->

The endpoint for tracked entity attribute value audits is located at
`/api/audits/trackedEntityAttributeValue`, and the available parameters
are displayed in the table below.

<table>
<caption>Tracked entity attribute value query parameters</caption>
<colgroup>
<col style="width: 12%" />
<col style="width: 16%" />
<col style="width: 70%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>tea</td>
<td>Tracked Entity Attributes</td>
<td>One or more tracked entity attribute identifiers.</td>
</tr>
<tr class="even">
<td>te</td>
<td>Tracked Entity Instances</td>
<td>One or more tracked entity instance identifiers.</td>
</tr>
<tr class="odd">
<td>auditType</td>
<td>UPDATE | DELETE</td>
<td>Filter by audit type.</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off</td>
</tr>
<tr class="odd">
<td>page</td>
<td>1 (default)</td>
<td>If paging is enabled, this parameter decides which page to show</td>
</tr>
</tbody>
</table>

Get all audits which have attribute with ID VqEFza8wbwA:

    /api/33/audits/trackedEntityAttributeValue?tea=VqEFza8wbwA

### Tracked entity instance audits

<!--DHIS2-SECTION-ID:webapi_tracked_entity_instance_audits-->

Once auditing is enabled for tracked entity instances (by setting
allowAuditLog of tracked entity types to true), all read and search
operations are logged. The endpoint for accessing audit logs is
api/audits/trackedEntityInstance. Below are available parameters to
interact with this endpoint.

<table>
<caption>Tracked entity instance audit query parameters</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>tei</td>
<td>Tracked Entity Instance</td>
<td>One or more tracked entity instance identifiers</td>
</tr>
<tr class="even">
<td>user</td>
<td>User</td>
<td>One or more user identifiers</td>
</tr>
<tr class="odd">
<td>auditType</td>
<td>SEARCH | READ</td>
<td>Audit type to filter for</td>
</tr>
<tr class="even">
<td>startDate</td>
<td>Start date</td>
<td>Start date for audit filtering in yyyy-mm-dd format.</td>
</tr>
<tr class="odd">
<td>endDate</td>
<td>End date</td>
<td>End date for audit filtering in yyyy-mm-dd format.</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off.</td>
</tr>
<tr class="odd">
<td>page</td>
<td>1 (default)</td>
<td>Specific page to ask for.</td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>50 (default)</td>
<td>Page size.</td>
</tr>
</tbody>
</table>

Get all tracked entity instance audits of type READ with
startDate=2018-03-01 and endDate=2018-04-24 in a page size of 5:

    /api/33/audits/trackedEntityInstance.json?startDate=2018-03-01
      &endDate=2018-04-24&auditType=READ&pageSize=5

### Enrollment audits

<!--DHIS2-SECTION-ID:webapi_enrollment_audits-->

Once auditing is enabled for enrollments (by setting allowAuditLog of
tracker programs to true), all read operations are logged. The
endpoint for accessing audit logs is api/audits/enrollment. Below are
available parameters to interact with this endpoint.

<table>
<caption>Enrollment audit query parameters</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>en</td>
<td>Enrollment</td>
<td>One or more tracked entity instance identifiers</td>
</tr>
<tr class="even">
<td>user</td>
<td>User</td>
<td>One or more user identifiers</td>
</tr>
<tr class="odd">
<td>startDate</td>
<td>Start date</td>
<td>Start date for audit filtering in yyyy-mm-dd format.</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>End date</td>
<td>End date for audit filtering in yyyy-mm-dd format.</td>
</tr>
<tr class="odd">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off.</td>
</tr>
<tr class="even">
<td>page</td>
<td>1 (default)</td>
<td>Specific page to ask for.</td>
</tr>
<tr class="odd">
<td>pageSize</td>
<td>50 (default)</td>
<td>Page size.</td>
</tr>
</tbody>
</table>

Get all enrollment audits with startDate=2018-03-01 and
endDate=2018-04-24 in a page size of 5:

    /api/audits/enrollment.json?startDate=2018-03-01&endDate=2018-04-24&pageSize=5

Get all enrollment audits for user admin:

    /api/audits/enrollment.json?user=admin

### Data approval audits

The endpoint for data approval audits is located at
/api/audits/dataApproval, and the available parameters are displayed in
the table below.

<table>
<caption>Data approval query parameters</caption>
<colgroup>
<col style="width: 12%" />
<col style="width: 16%" />
<col style="width: 70%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Option</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dal</td>
<td>Data Approval Level</td>
<td>One or more data approval level identifiers.</td>
</tr>
<tr class="even">
<td>wf</td>
<td>Workflow</td>
<td>One or more data approval workflow identifiers.</td>
</tr>
<tr class="odd">
<td>ou</td>
<td>Organisation Unit</td>
<td>One or more organisation unit identifiers.</td>
</tr>
<tr class="even">
<td>aoc</td>
<td>Attribute Option Combo</td>
<td>One or more attribute option combination identifiers.</td>
</tr>
<tr class="odd">
<td>startDate</td>
<td>Start Date</td>
<td>Starting Date for approvals in yyyy-mm-dd format.</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>End Date</td>
<td>Ending Date for approvals in yyyy-mm-dd format.</td>
</tr>
<tr class="odd">
<td>skipPaging</td>
<td>false | true</td>
<td>Turn paging on / off</td>
</tr>
<tr class="even">
<td>page</td>
<td>1 (default)</td>
<td><p>If paging is enabled, this parameter decides which page to show.</p></td>
</tr>
</tbody>
</table>

Get all audits for data approval workflow RwNpkAM7Hw7:

    /api/33/audits/dataApproval?wf=RwNpkAM7Hw7

## Message conversations

<!--DHIS2-SECTION-ID:webapi_message_conversations-->

DHIS2 features a mechanism for sending messages for purposes such as
user feedback, notifications, and general information to users. Messages
are grouped into conversations. To interact with message conversations
you can send POST and GET request to the *messageConversations*
resource.

    /api/33/messageConversations

Messages are delivered to the DHIS2 message inbox but can also be sent
to the user's email addresses and mobile phones as SMS. In this example,
we will see how we can utilize the Web API to send, read and manage
messages. We will pretend to be the *DHIS2 Administrator* user and send
a message to the *Mobile* user. We will then pretend to be the mobile
user and read our new message. Following this, we will manage the admin
user inbox by marking and removing messages.

### Writing and reading messages

<!--DHIS2-SECTION-ID:webapi_writing_messages-->

The resource we need to interact with when sending and reading messages
is the *messageConversations* resource. We start by visiting the Web API
entry point at <http://play.dhis2.org/demo/api> where we find and follow
the link to the *messageConversations* resource at
<http://play.dhis2.org/demo/api/messageConversations>. The description
tells us that we can use a POST request to create a new message using
the following XML format for sending to multiple users:

```xml
<message xmlns="http://dhis2.org/schema/dxf/2.0">
  <subject>This is the subject</subject>
  <text>This is the text</text>
  <users>
    <user id="user1ID" />
    <user id="user2ID" />
    <user id="user3ID" />
  </users>
</message>
```

For sending to all users contained in one or more user groups, we can
use:

```xml
<message xmlns="http://dhis2.org/schema/dxf/2.0">
  <subject>This is the subject</subject>
  <text>This is the text</text>
  <userGroups>
    <userGroup id="userGroup1ID" />
    <userGroup id="userGroup2ID" />
    <userGroup id="userGroup3ID" />
  </userGroups>
</message>
```

For sending to all users connected to one or more organisation units, we
can use:

```xml
<message xmlns="http://dhis2.org/schema/dxf/2.0">
  <subject>This is the subject</subject>
  <text>This is the text</text>
  <organisationUnits>
    <organisationUnit id="ou1ID" />
    <organisationUnit id="ou2ID" />
    <organisationUnit id="ou3ID" />
  </organisationUnits>
</message>
```

Since we want to send a message to our friend the mobile user we need to
look up her identifier. We do so by going to the Web API entry point and
follow the link to the *users* resource at `/api/users`. We continue by 
following link to the mobile user at `/api/users/PhzytPW3g2J` where we learn
that her identifier is *PhzytPW3g2J*. We are now ready to put our XML
message together to form a message where we want to ask the mobile user
whether she has reported data for January 2014:

```xml
<message xmlns="http://dhis2.org/schema/dxf/2.0">
  <subject>Mortality data reporting</subject>
  <text>Have you reported data for the Mortality data set for January 2014?</text>
  <users>
    <user id="PhzytPW3g2J" />
  </users>
</message>
```

To test this we save the XML content into a file called *message.xml*.
We use cURL to dispatch the message the DHIS2 demo instance where we
indicate that the content-type is XML and authenticate as the *admin*
user:

```bash
curl -d @message.xml "https://play.dhis2.org/demo/api/messageConversations"
  -H "Content-Type:application/xml" -u admin:district -X POST
```

A corresponding payload in JSON and POST command looks like this:

```json
{
  "subject": "Hey",
  "text": "How are you?",
  "users": [
    {
      "id": "OYLGMiazHtW"
    },
    {
      "id": "N3PZBUlN8vq"
    }
  ],
  "userGroups": [
    {
      "id": "ZoHNWQajIoe"
    }
  ],
  "organisationUnits": [
    {
      "id": "DiszpKrYNg8"
    }
  ]
}
```

```bash
curl -d @message.json "https://play.dhis2.org/demo/api/33/messageConversations"
  -H "Content-Type:application/json" -u admin:district -X POST
```

If all is well we receive a *201 Created* HTTP status code. Also, note
that we receive a *Location* HTTP header which value informs us of the
URL of the newly created message conversation resource - this can be
used by a consumer to perform further action.

We will now pretend to be the mobile user and read the message which was
just sent by dispatching a GET request to the *messageConversations*
resource. We supply an *Accept* header with *application/xml* as the
value to indicate that we are interested in the XML resource
representation and we authenticate as the *mobile* user:

```bash
curl "https://play.dhis2.org/demo/api/33/messageConversations"
  -H "Accept:application/xml" -u mobile:district
```

In response we get the following XML:

```xml
<messageConversations xmlns="http://dhis2.org/schema/dxf/2.0"
  link="https://play.dhis2.org/demo/api/messageConversations">
  <messageConversation name="Mortality data reporting" id="ZjHHSjyyeJ2"
    link="https://play.dhis2.org/demo/api/messageConversations/ZjHHSjyyeJ2"/>
  <messageConversation name="DHIS2 version 2.7 is deployed" id="GDBqVfkmnp2"
    link="https://play.dhis2.org/demo/api/messageConversations/GDBqVfkmnp2"/>
</messageConversations>
```

From the response, we are able to read the identifier of the newly sent
message which is *ZjHHSjyyeJ2*. Note that the link to the specific
resource is embedded and can be followed in order to read the full
message. We can reply directly to an existing message conversation once we know
the URL by including the message text as the request payload. We
are now able to construct a URL for sending our reply:

```bash
curl -d "Yes the Mortality data set has been reported"
  "https://play.dhis2.org/demo/api/messageConversations/ZjHHSjyyeJ2"
  -H "Content-Type:text/plain" -u mobile:district -X POST
```

If all went according to plan you will receive a *200 OK* status code.

In 2.30 we added an URL search parameter:

    queryString=?&queryOperator=?

The filter searches for matches in subject, text, and senders for message 
conversations. The default query operator is *token*, however other operators 
can be defined in the query.

### Managing messages

<!--DHIS2-SECTION-ID:webapi_managing_messages-->

As users receive and send messages, conversations will start to pile up
in their inboxes, eventually becoming laborious to track. We will now
have a look at managing a user's messages inbox by removing and marking
conversations through the Web-API. We will do so by performing some
maintenance in the inbox of the "DHIS Administrator" user.

First, let's have a look at removing a few messages from the inbox. Be
sure to note that all removal operations described here only remove the
relation between a user and a message conversation. In practical terms
this means that we are not deleting the messages themselves (or any
content for that matter) but are simply removing the message thread from
the user such that it is no longer listed in the
`/api/messageConversations` resource.

To remove a message conversation from a users inbox we need to issue a
*DELETE* request to the resource identified by the id of the message
conversation and the participating user. For example, to remove the user
with id `xE7jOejl9FI` from the conversation with id `jMe43trzrdi`:

```bash
curl "https://play.dhis2.org/demo/api/33/messageConversations/jMe43trzrdi
```

If the request was successful the server will reply with a *200 OK*. The
response body contains an XML or JSON object (according to the accept
header of the request) containing the id of the removed user.

```json
{
  "removed" : ["xE7jOejl9FI"]
}
```

On failure the returned object will contain a message payload which
describes the error.

```json
{
  "message" : "No user with uid: dMV6G0tPAEa"
}
```

The observant reader will already have noticed that the object returned
on success in our example is actually a list of ids (containing a single
entry). This is due to the endpoint also supporting batch removals. The
request is made to the same *messageConversations* resource but follows
slightly different semantics. For batch operations, the conversation ids
are given as query string parameters. The following example removes two
separate message conversations for the current user:

```bash
curl "https://play.dhis2.org/demo/api/messageConversations?mc=WzMRrCosqc0&mc=lxCjiigqrJm"
  -X DELETE -u admin:district
```

If you have sufficient permissions, conversations can be removed on
behalf of another user by giving an optional user id parameter.

```bash
curl "https://play.dhis2.org/demo/api/messageConversations?mc=WzMRrCosqc0&mc=lxCjiigqrJm&user=PhzytPW3g2J"
  -X DELETE -u admin:district
```

As indicated, batch removals will return the same message format as for
single operations. The list of removed objects will reflect successful
removals performed. Partially erroneous requests (i.e. non-existing id)
will therefore not cancel the entire batch operation.

Messages carry a boolean *read* property. This allows tracking whether a
user has seen (opened) a message or not. In a typical application
scenario (e.g. the DHIS2 web portal) a message will be marked read as
soon as the user opens it for the first time. However, users might want
to manage the read or unread status of their messages in order to keep
track of certain conversations.

Marking messages read or unread follows similar semantics as batch
removals, and also supports batch operations. To mark messages as read
we issue a *POST* to the `messageConversations/read` resource with a
request body containing one or more message ids. To mark messages as
unread we issue an identical request to the `messageConversations/unread` 
resource. As is the case for removals, an optional *user* request parameter 
can be given.

Let's mark a couple of messages as read by the current user:

```bash
curl "https://play.dhis2.org/dev/api/messageConversations/read"
  -d '["ZrKML5WiyFm","Gc03smoTm6q"]' -X POST
  -H "Content-Type: application/json" -u admin:district
```

The response is a *200 OK* with the following JSON body:

```json
{
  "markedRead": ["ZrKML5WiyFm", "Gc03smoTm6q"]
}
```

You can add recipients to an existing message conversation. The resource is located at:

    /api/33/messageConversations/id/recipients

The options for this resource is a list of users, user groups and
organisation units. The request should look like this:

```json
{
  "users": [
    {
      "id": "OYLGMiazHtW"
    },
    {
      "id": "N3PZBUlN8vq"
    }
  ],
  "userGroups": [
    {
      "id": "DiszpKrYNg8"
    }
  ],
  "organisationUnits": [
    {
      "id": "DiszpKrYNg8"
    }
  ]
}

```

### Message Attachments

<!--DHIS2-SECTION-ID:webapi_message_attachments-->

Creating messages with attachments is done in two steps: uploading the
file to the *attachments* resource, and then including one or several of
the attachment IDs when creating a new message.

A POST request to the *attachments* resource will upload the file to the
server.

```
curl -F file=@attachment.png "https://play.dhis2.org/demo/api/messageConversations/attachments"
  -u admin:district 
```

The request returns an object that represents the attachment. The id of
this object must be used when creating a message in order to link the
attachment with the message.

```json
{
  "created": "2018-07-20T16:54:18.210",
  "lastUpdated": "2018-07-20T16:54:18.212",
  "externalAccess": false,
  "publicAccess": "--------",
  "user": {
    "name": "John Traore",
    "created": "2013-04-18T17:15:08.407",
    "lastUpdated": "2018-03-09T23:06:54.512",
    "externalAccess": false,
    "displayName": "John Traore",
    "favorite": false,
    "id": "xE7jOejl9FI"
  },
  "lastUpdatedBy": {
    "id": "xE7jOejl9FI",
    "name": "John Traore"
  },
  "favorite": false,
  "id": "fTpI4GOmujz"
}
```

When creating a new message, the ids can be passed in the request body
to link the uploaded files to the message being created.

```json
{
  "subject": "Hey",
  "text": "How are you?",
  "users": [
    {
      "id": "OYLGMiazHtW"
    },
    {
      "id": "N3PZBUlN8vq"
    }
  ],
  "userGroups": [
    {
      "id": "ZoHNWQajIoe"
    }
  ],
  "organisationUnits": [
    {
      "id": "DiszpKrYNg8"
    }
  ],
  "attachments": [
    "fTpI4GOmujz",
    "h2ZsOxMFMfq"
  ]
}
```

When replying to a message, the ids can be passed as a request
parameter.

```bash
curl -d "Yes the Mortality data set has been reported"
  "https://play.dhis2.org/demo/api/33/messageConversations/ZjHHSjyyeJ2?attachments=fTpI4GOmujz,h2ZsOxMFMfq"
  -H "Content-Type:text/plain" -u mobile:district -X POST
```

Once a message with an attachment has been created, the attached file
can be accessed with a GET request to the following URL:

    /api/messageConversations/<mcv-id>/<msg-id>/attachments/<attachment-id>

Where <mcv-id> is the *message conversation* ID, <msg-id> is the ID of
the *message* that contains the attachment and <attachment-id> is the
ID of the specific *message attachment*.

### Tickets and Validation Result Notifications

<!--DHIS2-SECTION-ID:webapi_messaging_tickets-->

You can use the "write feedback" tool to create tickets and messages.
The only difference between a ticket and a message is that you can give
a status and a priority to a ticket. To set the status:

    POST /api/messageConversations/<uid>/status

To set the priority:

    POST /api/messageConversations/<uid>/priority

In 2.29, messages generated by validation analysis now also be used in
the status and priority properties. By default, messages generated by
validation analysis will inherit the priority of the validation rule in
question, or the highest importance if the message contains multiple
rules.

In 2.30, validation rules can be assigned to any user while tickets
still need to be assigned to a user in the system's feedback recipient
group.

<table>
<caption>A list of valid status and priority values</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>Status</th>
<th>Priority</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>OPEN</td>
<td>LOW</td>
</tr>
<tr class="even">
<td>PENDING</td>
<td>MEDIUM</td>
</tr>
<tr class="odd">
<td>INVALID</td>
<td>HIGH</td>
</tr>
<tr class="even">
<td>SOLVED</td>
<td></td>
</tr>
</tbody>
</table>

You can also add an internal message to a ticket, which can only be seen
by users who have "Manage tickets" permissions. To create an internal
reply, include the "internal" parameter, and set it to

```bash
curl -d "This is an internal message"
  "https://play.dhis2.org/demo/api/33/messageConversations/ZjHHSjyyeJ2?internal=true"
  -H "Content-Type:text/plain" -u admin:district -X POST
```

## Interpretations

<!--DHIS2-SECTION-ID:webapi_interpretations-->

For resources related to data analysis in DHIS2, such as pivot tables,
charts, maps, event reports and event charts, you can write and share
data interpretations. An interpretation can be a comment, question,
observation or interpretation about a data report or visualization.

    /api/interpretations

### Reading interpretations

<!--DHIS2-SECTION-ID:webapi_reading_interpretations-->

To read interpretations we will interact with the
`/api/interpretations` resource. A typical GET request using field
filtering can look like this:

    GET /api/interpretations?fields=*,comments[id,text,user,mentions]

The output in JSON response format could look like below (additional
fields omitted for brevity):

```json
{
  "interpretations": [
    {
      "id": "XSHiFlHAhhh",
      "created": "2013-05-30T10:24:06.181+0000",
      "text": "Data looks suspicious, could be a data entry mistake.",
      "type": "REPORT_TABLE",
      "likes": 2,
      "user": {
        "id": "uk7diLujYif"
      },
      "reportTable": {
        "id": "LcSxnfeBxyi"
      },
      "visualization": {
        "id": "LcSxnfeBxyi"
      }
    }, {
      "id": "kr4AnZmYL43",
      "created": "2013-05-29T14:47:13.081+0000",
      "text": "Delivery rates in Bo looks high.",
      "type": "CHART",
      "likes": 3,
      "user": {
        "id": "uk7diLujYif"
      },
      "chart": {
        "id": "HDEDqV3yv3H"
      },
      "visualization": {
        "id": "HDEDqV3yv3H"
      },
      "mentions": [
        {
          "created": "2018-06-25T10:25:54.498",
          "username": "boateng"
        }
      ],
      "comments": [
        {
          "id": "iB4Etq8yTE6",
          "text": "This report indicates a surge.",
          "user": {
            "id": "B4XIfwOcGyI"
          }
        },
        {
          "id": "iB4Etq8yTE6",
          "text": "Likely caused by heavy rainfall.",
          "user": {
            "id": "B4XIfwOcGyI"
          }
        }, 
        {
          "id": "SIjkdENan8p",
          "text": "Have a look at this @boateng.",
          "user": {
            "id": "xE7jOejl9FI"
          },
          "mentions": [
            {
              "created": "2018-06-25T10:03:52.316",
              "username": "boateng"
            }
          ]
        }
      ]
    }
  ]
}
```

<table>
<caption>Interpretation fields</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>id</td>
<td>The interpretation identifier.</td>
</tr>
<tr class="even">
<td>created</td>
<td>The time of when the interpretation was created.</td>
</tr>
<tr class="odd">
<td>type</td>
<td>The type of analytical object being interpreted. Valid options: REPORT_TABLE, CHART, MAP, EVENT_REPORT, EVENT_CHART, DATASET_REPORT.
</tr>
<tr class="even">
<td>user</td>
<td>Association to the user who created the interpretation.</td>
</tr>
<tr class="odd">
<td>reportTable</td>
<td>Association to the report table if type is REPORT_TABLE.</td>
</tr>
<tr class="even">
<td>chart</td>
<td>Association to the chart if type is CHART.</td>
</tr>
<tr class="odd">
<td>visualization</td>
<td>Association to the visualization if type is CHART or REPORT_TABLE (**both types are in deprecation process in favour of VISUALIZATION**).</td>
</tr>
<tr class="even">
<td>map</td>
<td>Association to the map if type is MAP.</td>
</tr>
<tr class="odd">
<td>eventReport</td>
<td>Association to the event report is type is EVENT_REPORT.</td>
</tr>
<tr class="even">
<td>eventChart</td>
<td>Association to the event chart if type is EVENT_CHART.</td>
</tr>
<tr class="odd">
<td>dataSet</td>
<td>Association to the data set if type is DATASET_REPORT.</td>
</tr>
<tr class="even">
<td>comments</td>
<td>Array of comments for the interpretation. The text field holds the actual comment.</td>
</tr>
<tr class="odd">
<td>mentions</td>
<td>Array of mentions for the interpretation. A list of users identifiers.</td>
</tr>
</tbody>
</table>

For all analytical objects you can append */data* to the URL to retrieve
the data associated with the resource (as opposed to the metadata). As
an example, by following the map link and appending /data one can
retrieve a PNG (image) representation of the thematic map through the
following URL:

    https://play.dhis2.org/demo/api/maps/bhmHJ4ZCdCd/data

For all analytical objects you can filter by *mentions*. To retrieve all
the interpretations/comments where a user has been mentioned you have
three options. You can filter by the interpretation mentions (mentions
in the interpretation
    description):

    GET /api/interpretations?fields=*,comments[*]&filter=mentions.username:in:[boateng]

You can filter by the interpretation comments mentions (mentions in any
comment):

    GET /api/interpretations?fields=*,comments[*]
      &filter=comments.mentions.username:in:[boateng]

You can filter by intepretations which contains the mentions either
in the interpretation or in any comment (OR junction):

    GET /api/interpretations?fields=*,comments[*]&filter=mentions:in:[boateng]

### Writing interpretations

<!--DHIS2-SECTION-ID:webapi_writing_interpretations-->

When writing interpretations you will supply the interpretation text as
the request body using a POST request with content type "text/plain".
The URL pattern looks like the below, where {object-type} refers to the
type of the object being interpreted and {object-id} refers to the
identifier of the object being interpreted.

    /api/interpretations/{object-type}/{object-id}

Valid options for object type are *reportTable*, *chart*, *map*,
*eventReport*, *eventChart* and *dataSetReport*.

Some valid examples for interpretations are listed below.

> **Note**
>
> The `charts` and `reportTables` APIs are deprecated. We recommend using the `visualizations` API instead.

    /api/interpretations/reportTable/yC86zJxU1i1
    /api/interpretations/chart/ZMuYVhtIceD
    /api/interpretations/visualization/hQxZGXqnLS9
    /api/interpretations/map/FwLHSMCejFu
    /api/interpretations/eventReport/xJmPLGP3Cde
    /api/interpretations/eventChart/nEzXB2M9YBz
    /api/interpretations/dataSetReport/tL7eCjmDIgM

As an example, we will start by writing an interpretation for the chart
with identifier *EbRN2VIbPdV*. To write chart interpretations we will
interact with the `/api/interpretations/chart/{chartId}` resource.
The interpretation will be the request body. Based on this we can put
together the following request using cURL:

```bash
curl -d "This chart shows a significant ANC 1-3 dropout" -X POST
  "https://play.dhis2.org/demo/api/interpretations/chart/EbRN2VIbPdV"
  -H "Content-Type:text/plain" -u admin:district
```

Notice that the response provides a Location header with a value
indicating the location of the created interpretation. This is useful
from a client perspective when you would like to add a comment to the
interpretation.

### Updating and removing interpretations

<!--DHIS2-SECTION-ID:webapi_updating_removing_interpretations-->

To update an existing interpretation you can use a PUT request where the
interpretation text is the request body using the following URL pattern,
where {id} refers to the interpretation identifier:

    /api/interpretations/{id}

Based on this we can use curl to update the interpretation:

```bash
curl -d "This charts shows a high dropout" -X PUT
  "https://play.dhis2.org/demo/api/interpretations/chart/EV08iI1cJRA"
  -H "Content-Type:text/plain" -u admin:district
```

You can use the same URL pattern as above using a DELETE request to
remove the interpretation.

### Creating interpretation comments

<!--DHIS2-SECTION-ID:webapi_creating_interpretation_comments-->

When writing comments to interpretations you will supply the comment
text as the request body using a POST request with content type
"text/plain". The URL pattern looks like the below, where
{interpretation-id} refers to the interpretation identifier.

    /api/interpretations/{interpretation-id}/comments

Second, we will write a comment to the interpretation we wrote in the
example above. By looking at the interpretation response you will see
that a *Location* header is returned. This header tells us the URL of
the newly created interpretation and from that, we can read its
identifier. This identifier is randomly generated so you will have to
replace the one in the command below with your own. To write a comment
we can interact with the `/api/interpretations/{id}/comments`
resource like this:

```bash
curl -d "An intervention is needed" -X POST
  "https://play.dhis2.org/demo/api/interpretations/j8sjHLkK8uY/comments"
  -H "Content-Type:text/plain" -u admin:district
```

### Updating and removing interpretation comments

<!--DHIS2-SECTION-ID:webapi_updating_removing_interpretation_comments-->

To updating an interpretation comment you can use a PUT request where
the comment text is the request body using the following URL pattern:

    /api/interpretations/{interpretation-id}/comments/{comment-id}

Based on this we can use curl to update the comment:

```bash
curl "https://play.dhis2.org/demo/api/interpretations/j8sjHLkK8uY/comments/idAzzhVWvh2"
  -d "I agree with that." -X PUT -H "Content-Type:text/plain" -u admin:district
```

You can use the same URL pattern as above using a DELETE request to the
remove the interpretation comment.

### Liking interpretations

<!--DHIS2-SECTION-ID:webapi_liking_interpretations-->

To like an interpretation you can use an empty POST request to the
*like* resource:

    POST /api/interpretations/{id}/like

A like will be added for the currently authenticated user. A user can
only like an interpretation once.

To remove a like for an interpretation you can use a DELETE request to
the same resource as for the like operation.

The like status of an interpretation can be viewed by looking at the
regular Web API representation:

    GET /api/interpretations/{id}

The like information is found in the *likes* field, which represents the
number of likes, and the *likedBy* array, which enumerates the users who
have liked the interpretation.

```json
{
  "id": "XSHiFlHAhhh",
  "text": "Data looks suspicious, could be a data entry mistake.",
  "type": "REPORT_TABLE",
  "likes": 2,
  "likedBy": [
    {
      "id": "k7Hg12fJ2f1"
    },
    {
      "id": "gYhf26fFkjFS"
    }
  ]
}
```

## Viewing analytical resource representations

<!--DHIS2-SECTION-ID:webapi_viewing_analytical_resource_representations-->

DHIS2 has several resources for data analysis. These resources include
*charts*, *maps*, *reportTables*, *reports* and *documents*. By visiting
these resources you will retrieve information about the resource. For
instance, by navigating to `/api/charts/R0DVGvXDUNP` the response will
contain the name, last date of modification and so on for the chart. To
retrieve the analytical representation, for instance, a PNG
representation of the chart, you can append */data* to all these
resources. For instance, by visiting `/api/charts/R0DVGvXDUNP/data` the
system will return a PNG image of the chart.

<table>
<caption>Analytical resources</caption>
<colgroup>
<col style="width: 17%" />
<col style="width: 17%" />
<col style="width: 32%" />
<col style="width: 32%" />
</colgroup>
<thead>
<tr class="header">
<th>Resource</th>
<th>Description</th>
<th>Data URL</th>
<th>Resource representations</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>charts</td>
<td>Charts</td>
<td>/api/charts/&lt;identifier&gt;/data</td>
<td>png</td>
</tr>
<tr class="even">
<td>eventCharts</td>
<td>Event charts</td>
<td>/api/eventCharts/&lt;identifier&gt;/data</td>
<td>png</td>
</tr>
<tr class="odd">
<td>maps</td>
<td>Maps</td>
<td>/api/maps/&lt;identifier&gt;/data</td>
<td>png</td>
</tr>
<tr class="even">
<td>reportTables</td>
<td>Pivot tables</td>
<td>/api/reportTables/&lt;identifier&gt;/data</td>
<td>json | jsonp | html | xml | pdf | xls | csv</td>
</tr>
<tr class="odd">
<td>reports</td>
<td>Standard reports</td>
<td>/api/reports/&lt;identifier&gt;/data</td>
<td>pdf | xls | html</td>
</tr>
<tr class="even">
<td>documents</td>
<td>Resources</td>
<td>/api/documents/&lt;identifier&gt;/data</td>
<td>&lt;follows document&gt;</td>
</tr>
</tbody>
</table>

The data content of the analytical representations can be modified by
providing a *date* query parameter. This requires that the analytical
resource is set up for relative periods for the period dimension.

<table>
<caption>Data query parameters</caption>
<colgroup>
<col style="width: 21%" />
<col style="width: 28%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>date</td>
<td>Date in yyyy-MM-dd format</td>
<td>Basis for relative periods in report (requires relative periods)</td>
</tr>
</tbody>
</table>

<table>
<caption>Query parameters for png / image types (charts, maps)</caption>
<colgroup>
<col style="width: 21%" />
<col style="width: 78%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>width</td>
<td>Width of image in pixels</td>
</tr>
<tr class="even">
<td>height</td>
<td>Height of image in pixels</td>
</tr>
</tbody>
</table>

Some examples of valid URLs for retrieving various analytical
representations are listed below.

    /api/charts/R0DVGvXDUNP/data
    /api/charts/R0DVGvXDUNP/data?date=2013-06-01
    
    /api/reportTables/jIISuEWxmoI/data.html
    /api/reportTables/jIISuEWxmoI/data.html?date=2013-01-01
    /api/reportTables/FPmvWs7bn2P/data.xls
    /api/reportTables/FPmvWs7bn2P/data.pdf
    
    /api/maps/DHE98Gsynpr/data
    /api/maps/DHE98Gsynpr/data?date=2013-07-01
    
    /api/reports/OeJsA6K1Otx/data.pdf
    /api/reports/OeJsA6K1Otx/data.pdf?date=2014-01-01

## Plugins

<!--DHIS2-SECTION-ID:webapi_plugins-->

DHIS2 comes with plugins which enable you to embed live data directly in
your web portal or web site. Currently, plugins exist for charts, maps
and pivot tables.

Please be aware that all of the code examples in this section are for
demonstration purposes only. They should not be used as is in
production systems. To make things simple, the credentials
(admin/district) have been embedded into the scripts. In a real scenario,
you should never expose credentials in javascript as it opens a
vulnerability to the application. In addition, you would create a user
with more minimal privileges rather than make use of a superuser to
fetch resources for your portal.

It is possible to workaround exposing the credentials by using a reverse
proxy such as nginx or apache2. The proxy can be configured to inject
the required Authorization header for only the endpoints that you wish
to make public. There is some documentation to get you started in the
section of the implementers manual which describes [reverse
proxy](https://docs.dhis2.org/master/en/implementer/html/install_reverse_proxy_configuration.html#install_making_resources_available_with_nginx)
configuration.

### Embedding pivot tables with the Pivot Table plug-in

<!--DHIS2-SECTION-ID:webapi_pivot_table_plugin-->

In this example, we will see how we can embed good-looking, light-weight
html pivot tables with data served from a DHIS2 back-end into a Web
page. To accomplish this we will use the Pivot table plug-in. The
plug-in is written in Javascript and depends on the jQuery library only.
A complete working example can be found at
<http://play.dhis2.org/portal/table.html>. Open the page in a web
browser and view the source to see how it is set up.

We start by having a look at what the complete html file could look
like. This setup puts two tables in our web page. The first one is
referring to an existing table. The second is configured inline.

```html
<!DOCTYPE html>
<html>
<head>
  <script src="https://dhis2-cdn.org/v227/plugin/jquery-2.2.4.min.js"></script>
  <script src="https://dhis2-cdn.org/v227/plugin/reporttable.js"></script>

  <script>
    reportTablePlugin.url = "https://play.dhis2.org/demo";
    reportTablePlugin.username = "admin";
    reportTablePlugin.password = "district";
    reportTablePlugin.loadingIndicator = true;

    // Referring to an existing table through the id parameter, render to "report1" div

    var r1 = { el: "report1", id: "R0DVGvXDUNP" };

    // Table configuration, render to "report2" div

    var r2 = {
      el: "report2",
      columns: [
        {dimension: "dx", items: [{id: "YtbsuPPo010"}, {id: "l6byfWFUGaP"}]}
      ],
      rows: [
        {dimension: "pe", items: [{id: "LAST_12_MONTHS"}]}
      ],
      filters: [
        {dimension: "ou", items: [{id: "USER_ORGUNIT"}]}
      ],

      // All following properties are optional
      title: "My custom title",
      showColTotals: false,
      showRowTotals: false,
      showColSubTotals: false,
      showRowSubTotals: false,
      showDimensionLabels: false,
      hideEmptyRows: true,
      skipRounding: true,
      aggregationType: "AVERAGE",
      showHierarchy: true,
      completedOnly: true,
      displayDensity: "COMFORTABLE",
      fontSize: "SMALL",
      digitGroupSeparator: "COMMA",
      legendSet: {id: "fqs276KXCXi"}
    };

    reportTablePlugin.load([r1, r2]);
  </script>
</head>

<body>
  <div id="report1"></div>
  <div id="report2"></div>
</body>
</html>
```

Two files are included in the header section of the HTML document. The
first file is the jQuery JavaScript library (we use the DHIS2 content
delivery network in this case). The second file is the Pivot table
plug-in. Make sure the path is pointing to your DHIS2 server
installation.

Now let us have a look at the various options for the Pivot tables. One
property is required: *el* (please refer to the table below). Now, if
you want to refer to pre-defined tables already made inside DHIS2 it is
sufficient to provide the additional *id* parameter. If you instead want
to configure a pivot table dynamically you should omit the id parameter
and provide data dimensions inside a *columns* array, a *rows* array and
optionally a *filters* array instead.

A data dimension is defined as an object with a text property called
*dimension*. This property accepts the following values: *dx*
(indicator, data element, data element operand, data set, event data
item and program indicator), *pe* (period), *ou* (organisation unit) or
the id of any organisation unit group set or data element group set (can
be found in the web api). The data dimension also has an array property
called *items* which accepts objects with an *id* property.

To sum up, if you want to have e.g. "ANC 1 Coverage", "ANC 2 Coverage"
and "ANC 3 Coverage" on the columns in your table you can make the
following *columns* config:

```json
columns: [{
  dimension: "dx",
  items: [
    {id: "Uvn6LCg7dVU"}, // the id of ANC 1 Coverage
    {id: "OdiHJayrsKo"}, // the id of ANC 2 Coverage
    {id: "sB79w2hiLp8"}  // the id of ANC 3 Coverage
  ]
}]
```

<table>
<caption>Pivot table plug-in configuration</caption>
<thead>
<tr class="header">
<th>Param</th>
<th>Type</th>
<th>Required</th>
<th>Options (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>url</td>
<td>string</td>
<td>Yes</td>
<td></td>
<td>Base URL of the DHIS2 server</td>
</tr>
<tr class="even">
<td>username</td>
<td>string</td>
<td>Yes (if cross-domain)</td>
<td></td>
<td>Used for authentication if the server is running on a different domain</td>
</tr>
<tr class="odd">
<td>password</td>
<td>string</td>
<td>Yes (if cross-domain)</td>
<td></td>
<td>Used for authentication if the server is running on a different domain</td>
</tr>
<tr class="even">
<td>loadingIndicator</td>
<td>boolean</td>
<td>No</td>
<td></td>
<td>Whether to show a loading indicator before the table appears</td>
</tr>
</tbody>
</table>

<table>
<caption>Pivot table configuration</caption>
<thead>
<tr class="header">
<th>Param</th>
<th>Type</th>
<th>Required</th>
<th>Options (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>el</td>
<td>string</td>
<td>Yes</td>
<td></td>
<td>Identifier of the HTML element to render the table in your web page</td>
</tr>
<tr class="even">
<td>id</td>
<td>string</td>
<td>No</td>
<td></td>
<td>Identifier of a pre-defined table (favorite) in DHIS2</td>
</tr>
<tr class="odd">
<td>columns</td>
<td>array</td>
<td>Yes (if no id provided)</td>
<td></td>
<td>Data dimensions to include in table as columns</td>
</tr>
<tr class="even">
<td>rows</td>
<td>array</td>
<td>Yes (if no id provided)</td>
<td></td>
<td>Data dimensions to include in table as rows</td>
</tr>
<tr class="odd">
<td>filter</td>
<td>array</td>
<td>No</td>
<td></td>
<td>Data dimensions to include in table as filters</td>
</tr>
<tr class="even">
<td>title</td>
<td>string</td>
<td>No</td>
<td></td>
<td>Show a custom title above the table</td>
</tr>
<tr class="odd">
<td>showColTotals</td>
<td>boolean</td>
<td>No</td>
<td>true | false</td>
<td>Whether to display totals for columns</td>
</tr>
<tr class="even">
<td>showRowTotals</td>
<td>boolean</td>
<td>No</td>
<td>true | false</td>
<td>Whether to display totals for rows</td>
</tr>
<tr class="odd">
<td>showColSubTotals</td>
<td>boolean</td>
<td>No</td>
<td>true | false</td>
<td>Whether to display sub-totals for columns</td>
</tr>
<tr class="even">
<td>showRowSubTotals</td>
<td>boolean</td>
<td>No</td>
<td>true | false</td>
<td>Whether to display sub-totals for rows</td>
</tr>
<tr class="odd">
<td>showDimensionLabels</td>
<td>boolean</td>
<td>No</td>
<td>true | false</td>
<td>Whether to display the name of the dimension top-left in the table</td>
</tr>
<tr class="even">
<td>hideEmptyRows</td>
<td>boolean</td>
<td>No</td>
<td>false | true</td>
<td>Whether to hide rows with no data</td>
</tr>
<tr class="odd">
<td>skipRounding</td>
<td>boolean</td>
<td>No</td>
<td>false | true</td>
<td>Whether to skip rounding of data values</td>
</tr>
<tr class="even">
<td>completedOnly</td>
<td>boolean</td>
<td>No</td>
<td>false | true</td>
<td>Whether to only show completed events</td>
</tr>
<tr class="odd">
<td>showHierarchy</td>
<td>boolean</td>
<td>No</td>
<td>false | true</td>
<td>Whether to extend orgunit names with the name of all anchestors</td>
</tr>
<tr class="even">
<td>aggregationType</td>
<td>string</td>
<td>No</td>
<td>&quot;SUM&quot; |&quot;AVERAGE&quot; | &quot;AVERAGE_SUM_ORG_UNIT&quot;|&quot;LAST&quot;|&quot;LAST_AVERAGE_ORG_UNIT&quot;| &quot;COUNT&quot; | &quot;STDDEV&quot; | &quot;VARIANCE&quot; | &quot;MIN&quot; | &quot;MAX&quot;</td>
<td>Override the data element's default aggregation type</td>
</tr>
<tr class="odd">
<td>displayDensity</td>
<td>string</td>
<td>No</td>
<td>&quot;NORMAL&quot; | &quot;COMFORTABLE&quot; | &quot;COMPACT&quot;</td>
<td>The amount of space inside table cells</td>
</tr>
<tr class="even">
<td>fontSize</td>
<td>string</td>
<td>No</td>
<td>&quot;NORMAL&quot; | &quot;LARGE&quot; | &quot;SMALL&quot;</td>
<td>Table font size</td>
</tr>
<tr class="odd">
<td>digitGroupSeparator</td>
<td>string</td>
<td>No</td>
<td>&quot;SPACE&quot; | &quot;COMMA&quot; | &quot;NONE&quot;</td>
<td>How values are formatted: 1 000 | 1,000 | 1000</td>
</tr>
<tr class="even">
<td>legendSet</td>
<td>object</td>
<td>No</td>
<td></td>
<td>Color the values in the table according to the legend set</td>
</tr>
<tr class="odd">
<td>userOrgUnit</td>
<td>string / array</td>
<td>No</td>
<td></td>
<td>Organisation unit identifiers, overrides organisation units associated with curretn user, single or array</td>
</tr>
<tr class="even">
<td>relativePeriodDate</td>
<td>string</td>
<td>No</td>
<td></td>
<td>Date identifier e.g: &quot;2016-01-01&quot;. Overrides the start date of the relative period</td>
</tr>
</tbody>
</table>

### Embedding charts with the Visualizer chart plug-in

<!--DHIS2-SECTION-ID:webapi_chart_plugin-->

In this example, we will see how we can embed good-looking Highcharts
charts (<http://www.highcharts.com>) with data served from a DHIS2
back-end into a Web page. To accomplish this we will use the DHIS2
Visualizer plug-in. The plug-in is written in JavaScript and depends on
the jQuery library. A complete working example can be found at
<http://play.dhis2.org/portal/chart.html>. Open the page in a web
browser and view the source to see how it is set up.

We start by having a look at what the complete html file could look
like. This setup puts two charts on our web page. The first one is
referring to an existing chart. The second is configured inline.

```html
<!DOCTYPE html>
<html>
<head>
  <script src="https://dhis2-cdn.org/v227/plugin/jquery-2.2.4.min.js"></script>
  <script src="https://dhis2-cdn.org/v227/plugin/chart.js"></script>

  <script>
    chartPlugin.url = "https://play.dhis2.org/demo";
    chartPlugin.username = "admin";
    chartPlugin.password = "district";
    chartPlugin.loadingIndicator = true;

    // Referring to an existing chart through the id parameter, render to "report1" div

    var r1 = { el: "report1", id: "R0DVGvXDUNP" };

    // Chart configuration, render to "report2" div

    var r2 = {
      el: "report2",
      columns: [
        {dimension: "dx", items: [{id: "YtbsuPPo010"}, {id: "l6byfWFUGaP"}]}
      ],
      rows: [
        {dimension: "pe", items: [{id: "LAST_12_MONTHS"}]}
      ],
      filters: [
        {dimension: "ou", items: [{id: "USER_ORGUNIT"}]}
      ],

      // All following properties are optional
      title: "Custom title",
      type: "line",
      showValues: false,
      hideEmptyRows: true,
      regressionType: "LINEAR",
      completedOnly: true,
      targetLineValue: 100,
      targetLineTitle: "My target line title",
      baseLineValue: 20,
      baseLineTitle: "My base line title",
      aggregationType: "AVERAGE",
      rangeAxisMaxValue: 100,
      rangeAxisMinValue: 20,
      rangeAxisSteps: 5,
      rangeAxisDecimals: 2,
      rangeAxisTitle: "My range axis title",
      domainAxisTitle: "My domain axis title",
      hideLegend: true
    };

    // Render the charts

    chartPlugin.load(r1, r2);
  </script>
</head>

<body>
  <div id="report1"></div>
  <div id="report2"></div>
</body>
</html>
```

Two files are included in the header section of the HTML document. The
first file is the jQuery JavaScript library (we use the DHIS2 content
delivery network in this case). The second file is the Visualizer chart
plug-in. Make sure the path is pointing to your DHIS2 server
installation.

Now let us have a look at the various options for the charts. One
property is required: *el* (please refer to the table below). Now, if
you want to refer to pre-defined charts already made inside DHIS2 it is
sufficient to provide the additional *id* parameter. If you instead want
to configure a chart dynamically you should omit the id parameter and
provide data dimensions inside a *columns* array, a *rows* array and
optionally a *filters* array instead.

A data dimension is defined as an object with a text property called
*dimension*. This property accepts the following values: *dx*
(indicator, data element, data element operand, data set, event data
item and program indicator), *pe* (period), *ou* (organisation unit) or
the id of any organisation unit group set or data element group set (can
be found in the web api). The data dimension also has an array property
called *items* which accepts objects with an *id* property.

To sum up, if you want to have e.g. "ANC 1 Coverage", "ANC 2 Coverage"
and "ANC 3 Coverage" on the columns in your chart you can make the
following *columns* config:

```json
columns: [{
  dimension: "dx",
  items: [
    {id: "Uvn6LCg7dVU"}, // the id of ANC 1 Coverage
    {id: "OdiHJayrsKo"}, // the id of ANC 2 Coverage
    {id: "sB79w2hiLp8"}  // the id of ANC 3 Coverage
  ]
}]
```

<table>
<caption>Chart plug-in configuration</caption>
<thead>
<tr class="header">
<th>Param</th>
<th>Type</th>
<th>Required</th>
<th>Options (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>url</td>
<td>string</td>
<td>Yes</td>
<td></td>
<td>Base URL of the DHIS2 server</td>
</tr>
<tr class="even">
<td>username</td>
<td>string</td>
<td>Yes (if cross-domain)</td>
<td></td>
<td>Used for authentication if the server is running on a different domain</td>
</tr>
<tr class="odd">
<td>password</td>
<td>string</td>
<td>Yes (if cross-domain)</td>
<td></td>
<td>Used for authentication if the server is running on a different domain</td>
</tr>
<tr class="even">
<td>loadingIndicator</td>
<td>boolean</td>
<td>No</td>
<td></td>
<td>Whether to show a loading indicator before the chart appears</td>
</tr>
</tbody>
</table>

<table>
<caption>Chart configuration</caption>
<thead>
<tr class="header">
<th>Param</th>
<th>Type</th>
<th>Required</th>
<th>Options (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>el</td>
<td>string</td>
<td>Yes</td>
<td></td>
<td>Identifier of the HTML element to render the chart in your web page</td>
</tr>
<tr class="even">
<td>id</td>
<td>string</td>
<td>No</td>
<td></td>
<td>Identifier of a pre-defined chart (favorite) in DHIS</td>
</tr>
<tr class="odd">
<td>type</td>
<td>string</td>
<td>No</td>
<td>column | stackedcolumn | bar | stackedbar | line | area | pie | radar | gauge</td>
<td>Chart type</td>
</tr>
<tr class="even">
<td>columns</td>
<td>array</td>
<td>Yes (if no id provided)</td>
<td></td>
<td>Data dimensions to include in chart as series</td>
</tr>
<tr class="odd">
<td>rows</td>
<td>array</td>
<td>Yes (if no id provided)</td>
<td></td>
<td>Data dimensions to include in chart as category</td>
</tr>
<tr class="even">
<td>filter</td>
<td>array</td>
<td>No</td>
<td></td>
<td>Data dimensions to include in chart as filters</td>
</tr>
<tr class="odd">
<td>title</td>
<td>string</td>
<td>No</td>
<td></td>
<td>Show a custom title above the chart</td>
</tr>
<tr class="even">
<td>showValues</td>
<td>boolean</td>
<td>No</td>
<td>false | true</td>
<td>Whether to display data values on the chart</td>
</tr>
<tr class="odd">
<td>hideEmptyRows</td>
<td>boolean</td>
<td>No</td>
<td>false | true</td>
<td>Whether to hide empty categories</td>
</tr>
<tr class="even">
<td>completedOnly</td>
<td>boolean</td>
<td>No</td>
<td>false | true</td>
<td>Whether to only show completed events</td>
</tr>
<tr class="odd">
<td>regressionType</td>
<td>string</td>
<td>No</td>
<td>&quot;NONE&quot; | &quot;LINEAR&quot;</td>
<td>Show trend lines</td>
</tr>
<tr class="even">
<td>targetLineValue</td>
<td>number</td>
<td>No</td>
<td></td>
<td>Display a target line with this value</td>
</tr>
<tr class="odd">
<td>targetLineTitle</td>
<td>string</td>
<td>No</td>
<td></td>
<td>Display a title on the target line (does not apply without a target line value)</td>
</tr>
<tr class="even">
<td>baseLineValue</td>
<td>number</td>
<td>No</td>
<td></td>
<td>Display a base line with this value</td>
</tr>
<tr class="odd">
<td>baseLineTitle</td>
<td>string</td>
<td>No</td>
<td></td>
<td>Display a title on the base line (does not apply without a base line value)</td>
</tr>
<tr class="even">
<td>rangeAxisTitle</td>
<td>number</td>
<td>No</td>
<td></td>
<td>Title to be displayed along the range axis</td>
</tr>
<tr class="odd">
<td>rangeAxisMaxValue</td>
<td>number</td>
<td>No</td>
<td></td>
<td>Max value for the range axis to display</td>
</tr>
<tr class="even">
<td>rangeAxisMinValue</td>
<td>number</td>
<td>No</td>
<td></td>
<td>Min value for the range axis to display</td>
</tr>
<tr class="odd">
<td>rangeAxisSteps</td>
<td>number</td>
<td>No</td>
<td></td>
<td>Number of steps for the range axis to display</td>
</tr>
<tr class="even">
<td>rangeAxisDecimals</td>
<td>number</td>
<td>No</td>
<td></td>
<td>Bumber of decimals for the range axis to display</td>
</tr>
<tr class="odd">
<td>domainAxisTitle</td>
<td>number</td>
<td>No</td>
<td></td>
<td>Title to be displayed along the domain axis</td>
</tr>
<tr class="even">
<td>aggregationType</td>
<td>string</td>
<td>No</td>
<td>&quot;SUM&quot; |&quot;AVERAGE&quot; | &quot;AVERAGE_SUM_ORG_UNIT&quot;|&quot;LAST&quot;|&quot;LAST_AVERAGE_ORG_UNIT&quot;| &quot;COUNT&quot; | &quot;STDDEV&quot; | &quot;VARIANCE&quot; | &quot;MIN&quot; | &quot;MAX&quot;</td>
<td>Override the data element's default aggregation type</td>
</tr>
<tr class="odd">
<td>hideLegend</td>
<td>boolean</td>
<td>No</td>
<td>false | true</td>
<td>Whether to hide the series legend</td>
</tr>
<tr class="even">
<td>hideTitle</td>
<td>boolean</td>
<td>No</td>
<td>false | true</td>
<td>Whether to hide the chart title</td>
</tr>
<tr class="odd">
<td>userOrgUnit</td>
<td>string / array</td>
<td>No</td>
<td></td>
<td>Organisation unit identifiers, overrides organisation units associated with curretn user, single or array</td>
</tr>
<tr class="even">
<td>relativePeriodDate</td>
<td>string</td>
<td>No</td>
<td></td>
<td>Date identifier e.g: &quot;2016-01-01&quot;. Overrides the start date of the relative period</td>
</tr>
</tbody>
</table>

### Embedding maps with the GIS map plug-in

<!--DHIS2-SECTION-ID:webapi_map_plugin-->

In this example we will see how we can embed maps with data served from
a DHIS2 back-end into a Web page. To accomplish this we will use the GIS
map plug-in. The plug-in is written in JavaScript and depends on the Ext
JS library only. A complete working example can be found at
<http://play.dhis2.org/portal/map.html>. Open the page in a web browser
and view the source to see how it is set up.

We start by having a look at what the complete html file could look
like. This setup puts two maps on our web page. The first one is
referring to an existing map. The second is configured inline.

```html
<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" type="text/css" href="http://dhis2-cdn.org/v215/ext/resources/css/ext-plugin-gray.css" />
  <script src="http://dhis2-cdn.org/v215/ext/ext-all.js"></script>
  <script src="https://maps.google.com/maps/api/js?sensor=false"></script>
  <script src="http://dhis2-cdn.org/v215/openlayers/OpenLayers.js"></script>
  <script src="http://dhis2-cdn.org/v215/plugin/map.js"></script>

  <script>
    var base = "https://play.dhis2.org/demo";

    // Login - if OK, call the setLinks function

    Ext.onReady( function() {
      Ext.Ajax.request({
        url: base + "dhis-web-commons-security/login.action",
        method: "POST",
        params: { j_username: "portal", j_password: "Portal123" },
        success: setLinks
      });
    });

    function setLinks() {
      DHIS.getMap({ url: base, el: "map1", id: "ytkZY3ChM6J" });

      DHIS.getMap({
        url: base,
        el: "map2",
        mapViews: [{
          columns: [{dimension: "in", items: [{id: "Uvn6LCg7dVU"}]}], // data
          rows: [{dimension: "ou", items: [{id: "LEVEL-3"}, {id: "ImspTQPwCqd"}]}], // organisation units,
          filters: [{dimension: "pe", items: [{id: "LAST_3_MONTHS"}]}], // period
          // All following options are optional
          classes: 7,
          colorLow: "02079c",
          colorHigh: "e5ecff",
          opacity: 0.9,
          legendSet: {id: "fqs276KXCXi"}
        }]
      });
    }
  </script>
</head>

<body>
  <div id="map1"></div>
  <div id="map2"></div>
</body>
</html>
```

Four files and Google Maps are included in the header section of the
HTML document. The first two files are the Ext JS JavaScript library (we
use the DHIS2 content delivery network in this case) and its stylesheet.
The third file is the OpenLayers JavaScript mapping framework
(<http://openlayers.org>) and finally we include the GIS map plug-in.
Make sure the path is pointing to your DHIS2 server
    installation.

    <link rel="stylesheet" type="text/css" href="http://dhis2-cdn.org/v215/ext/resources/css/ext-plugin-gray.css" />
    <script src="http://dhis2-cdn.org/v215/ext/ext-all.js"></script>
    <script src="https://maps.google.com/maps/api/js?sensor=false"></script>
    <script src="http://dhis2-cdn.org/v215/openlayers/OpenLayers.js"></script>
    <script src="http://dhis2-cdn.org/v215/plugin/map.js"></script>

To authenticate with the DHIS2 server we use the same approach as in the
previous section. In the header of the HTML document we include the
following Javascript inside a script element. The *setLinks* method will
be implemented later. Make sure the *base* variable is pointing to your
DHIS2 installation.

    Ext.onReady( function() {
      Ext.Ajax.request({
        url: base + "dhis-web-commons-security/login.action",
        method: "POST",
        params: { j_username: "portal", j_password: "Portal123" },
        success: setLinks
      });
    });

Now let us have a look at the various options for the GIS plug-in. Two
properties are required: *el* and *url* (please refer to the table
below). Now, if you want to refer to pre-defined maps already made in
the DHIS2 GIS it is sufficient to provide the additional *id* parameter.
If you instead want to configure a map dynamically you should omit the id
parameter and provide *mapViews* (layers) instead. They should be
configured with data dimensions inside a *columns* array, a *rows* array
and optionally a *filters* array instead.

A data dimension is defined as an object with a text property called
*dimension*. This property accepts the following values: *in*
(indicator), *de* (data element), *ds* (data set), *dc* (data element
operand), *pe* (period), *ou* (organisation unit) or the id of any
organisation unit group set or data element group set (can be found in
the web api). The data dimension also has an array property called
*items* which accepts objects with an *id* property.

To sum up, if you want to have a layer with e.g. "ANC 1 Coverage" in
your map you can make the following *columns* config:

```json
columns: [{
  dimension: "in", // could be "in", "de", "ds", "dc", "pe", "ou" or any dimension id
  items: [{id: "Uvn6LCg7dVU"}], // the id of ANC 1 Coverage
}]
```

<table>
<caption>GIS map plug-in configuration</caption>
<thead>
<tr class="header">
<th>Param</th>
<th>Type</th>
<th>Required</th>
<th>Options (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>el</td>
<td>string</td>
<td>Yes</td>
<td></td>
<td>Identifier of the HTML element to render the map in your web page</td>
</tr>
<tr class="even">
<td>url</td>
<td>string</td>
<td>Yes</td>
<td></td>
<td>Base URL of the DHIS2 server</td>
</tr>
<tr class="odd">
<td>id</td>
<td>string</td>
<td>No</td>
<td></td>
<td>Identifier of a pre-defined map (favorite) in DHIS</td>
</tr>
<tr class="even">
<td>baseLayer</td>
<td>string/boolean</td>
<td>No</td>
<td>'gs', 'googlestreets' | 'gh', 'googlehybrid' | 'osm', 'openstreetmap' | false, null, 'none', 'off'</td>
<td>Show background map</td>
</tr>
<tr class="odd">
<td>hideLegend</td>
<td>boolean</td>
<td>No</td>
<td>false | true</td>
<td>Hide legend panel</td>
</tr>
<tr class="even">
<td>mapViews</td>
<td>array</td>
<td>Yes (if no id provided)</td>
<td></td>
<td>Array of layers</td>
</tr>
</tbody>
</table>

If no id is provided you must add map view objects with the following
config options:

<table>
<caption>Map plug-in configuration</caption>
<tbody>
<tr class="odd">
<td>layer</td>
<td>string</td>
<td>No</td>
<td>&quot;thematic1&quot; | &quot;thematic2&quot; | &quot;thematic3&quot; | &quot;thematic4&quot; | &quot;boundary&quot; | &quot;facility&quot; |</td>
<td>The layer to which the map view content should be added</td>
</tr>
<tr class="even">
<td>columns</td>
<td>array</td>
<td>Yes</td>
<td></td>
<td>Indicator, data element, data operand or data set (only one will be used)</td>
</tr>
<tr class="odd">
<td>rows</td>
<td>array</td>
<td>Yes</td>
<td></td>
<td>Organisation units (multiple allowed)</td>
</tr>
<tr class="even">
<td>filter</td>
<td>array</td>
<td>Yes</td>
<td></td>
<td>Period (only one will be used)</td>
</tr>
<tr class="odd">
<td>classes</td>
<td>integer</td>
<td>No</td>
<td>5 | 1-7</td>
<td>The number of automatic legend classes</td>
</tr>
<tr class="even">
<td>method</td>
<td>integer</td>
<td>No</td>
<td>2 | 3</td>
<td>Legend calculation method where 2 = equal intervals and 3 = equal counts</td>
</tr>
<tr class="odd">
<td>colorLow</td>
<td>string</td>
<td>No</td>
<td>&quot;ff0000&quot; (red) | Any hex color</td>
<td>The color representing the first automatic legend class</td>
</tr>
<tr class="even">
<td>colorHigh</td>
<td>string</td>
<td>No</td>
<td>&quot;00ff00&quot; (green) | Any hex color</td>
<td>The color representing the last automatic legend class</td>
</tr>
<tr class="odd">
<td>radiusLow</td>
<td>integer</td>
<td>No</td>
<td>5 | Any integer</td>
<td>Only applies for facilities (points) - radius of the point with lowest value</td>
</tr>
<tr class="even">
<td>radiusHigh</td>
<td>integer</td>
<td>No</td>
<td>15 | Any integer</td>
<td>Only applies for facilities (points) - radius of the point with highest value</td>
</tr>
<tr class="odd">
<td>opacity</td>
<td>double</td>
<td>No</td>
<td>0.8 | 0 - 1</td>
<td>Opacity/transparency of the layer content</td>
</tr>
<tr class="even">
<td>legendSet</td>
<td>object</td>
<td>No</td>
<td></td>
<td>Pre-defined legend set. Will override the automatic legend set.</td>
</tr>
<tr class="odd">
<td>labels</td>
<td>boolean/object</td>
<td>No</td>
<td>false | true | object properties: fontSize (integer), color (hex string), strong (boolean), italic (boolean)</td>
<td>Show labels on the map</td>
</tr>
<tr class="even">
<td>width</td>
<td>integer</td>
<td>No</td>
<td></td>
<td>Width of map</td>
</tr>
<tr class="odd">
<td>height</td>
<td>integer</td>
<td>No</td>
<td></td>
<td>Height of map</td>
</tr>
<tr class="even">
<td>userOrgUnit</td>
<td>string / array</td>
<td>No</td>
<td></td>
<td>Organisation unit identifiers, overrides organisation units associated with current user, single or array</td>
</tr>
</tbody>
</table>

We continue by adding one pre-defined and one dynamically configured map
to our HTML document. You can browse the list of available maps using
the Web API here: <http://play.dhis2.org/demo/api/33/maps>.

```javascript
function setLinks() {
  DHIS.getMap({ url: base, el: "map1", id: "ytkZY3ChM6J" });

  DHIS.getMap({
 url: base,
 el: "map2",
 mapViews: [
   columns: [ // Chart series
  columns: [{dimension: "in", items: [{id: "Uvn6LCg7dVU"}]}], // data
   ],
   rows: [ // Chart categories
  rows: [{dimension: "ou", items: [{id: "LEVEL-3"}, {id: "ImspTQPwCqd"}]}], // organisation units
   ],
   filters: [
  filters: [{dimension: "pe", items: [{id: "LAST_3_MONTHS"}]}], // period
   ],
   // All following options are optional
   classes: 7,
   colorLow: "02079c",
   colorHigh: "e5ecff",
   opacity: 0.9,
   legendSet: {id: "fqs276KXCXi"}
 ]
  });
}
```

Finally we include some *div* elements in the body section of the HTML
document with the identifiers referred to in the plug-in JavaScript.

```html
<div id="map1"></div>
<div id="map2"></div>
```

To see a complete working example please visit
<http://play.dhis2.org/portal/map.html>.



## SQL views

<!--DHIS2-SECTION-ID:webapi_sql_views-->

The SQL views resource allows you to create and retrieve the result set
of SQL views. The SQL views can be executed directly against the
database and render the result set through the Web API resource.

    /api/sqlViews

SQL views are useful for creating data views which may be more easily
constructed with SQL compared combining the multiple objects of the Web
API. As an example, lets assume we have been asked to provide a view of
all organization units with their names, parent names, organization unit
level and name, and the coordinates listed in the database. The view
might look something like this:

```sql
SELECT ou.name as orgunit, par.name as parent, ou.coordinates, ous.level, oul.name from organisationunit ou
INNER JOIN _orgunitstructure ous ON ou.organisationunitid = ous.organisationunitid
INNER JOIN organisationunit par ON ou.parentid = par.organisationunitid
INNER JOIN orgunitlevel oul ON ous.level = oul.level
WHERE ou.coordinates is not null
ORDER BY oul.level, par.name, ou.name
```

We will use *curl* to first execute the view on the DHIS2 server. This
is essentially a materialization process, and ensures that we have the
most recent data available through the SQL view when it is retrieved
from the server. You can first look up the SQL view from the
api/sqlViews resource, then POST using the following command:

```bash
curl "https://play.dhis2.org/demo/api/sqlViews/dI68mLkP1wN/execute" -X POST -u admin:district
```

The next step in the process is the retrieval of the data.The basic
structure of the URL is as follows

    http://{server}/api/sqlViews/{id}/data(.csv)

The `{server}` parameter should be replaced with your own server. The
next part of the URL `/api/sqlViews/` should be appended with the
specific SQL view identifier. Append either `data` for XML data or
`data.csv` for comma delimited values. Support response formats are
json, xml, csv, xls, html and html+css. As an example, the following
command would retrieve XML data for the SQL view defined above.

```bash
curl "https://play.dhis2.org/demo/api/sqlViews/dI68mLkP1wN/data.csv" -u admin:district
```

There are three types of SQL views:

  - *SQL view:* Standard SQL views.

  - *Materialized SQL view:* SQL views which are materialized, meaning
    written to disk. Needs to be updated to reflect changes in
    underlying tables. Supports criteria to filter result set.

  - *SQL queries:* Plain SQL queries. Support inline variables for
    customized queries.

### Criteria

<!--DHIS2-SECTION-ID:webapi_sql_view_criteria-->

You can do simple filtering on the columns in the result set by
appending *criteria* query parameters to the URL, using the column names
and filter values separated by columns as parameter values, on the
following format:

    /api/sqlViews/{id}/data?criteria=col1:value1&criteria=col2:value2

As an example, to filter the SQL view result set above to only return
organisation units at level 4 you can use the following
    URL:

    https://play.dhis2.org/demo/api/sqlViews/dI68mLkP1wN/data.csv?criteria=level:4

### Variables

<!--DHIS2-SECTION-ID:webapi_sql_view_variables-->

SQL views support variable substitution. Variable substitution is only
available for SQL view of type *query*, meaning SQL views which are not
created in the database but simply executed as regular SQL queries.
Variables can be inserted directly into the SQL query and must be on
this format:

    ${variable-key}

As an example, an SQL query that retrieves all data elements of a given
value type where the value type is defined through a variable can look
like this:

    select * from dataelement where valuetype = '${valueType}';

These variables can then be supplied as part of the URL when requested
through the *sqlViews* Web API resource. Variables can be supplied on
the following format:

    /api/sqlViews/{id}/data?var=key1:value1&var=key2:value2

An example query corresponding to the example above can look like this:

    /api/sqlViews/dI68mLkP1wN/data.json?var=valueType:int

The *valueType* variable will be substituted with the *int* value, and
the query will return data elements with int value type.

The variable parameter must contain alphanumeric characters only. The
variables must contain alphanumeric, dash, underscore and whitespace
characters only.

SQL Views of type *query* also support two system-defined variables that allow the query to access information about the user executing the view:

| variable | means |
| -------- | ----- |
| ${_current_user_id} | the user's database id |
| ${_current_username} | the user's username |

Values for these variables cannot be supplied as part of the URL. They are always filled with information about the user.

For example, the following SQL view of type *query* shows all the organisation units that are assigned to the user:

```sql
    select ou.path, ou.name
    from organisationunit ou_user
    join organisationunit ou on ou.path like ou_user.path || '%'
    join usermembership um on um.organisationunitid = ou_user.organisationunitid
    where um.userinfoid = ${_current_user_id}
    order by ou.path
```

### Filtering

<!--DHIS2-SECTION-ID:webapi_sql_view_filtering-->

The SQL view api supports data filtering, equal to the [metadata object
filter](#webapi_metadata_object_filter). For a complete list of filter
operators you can look at the documentation for [metadata object
filter](#webapi_metadata_object_filter).

To use filters, simply add them as parameters at the end of the request
url for your SQL view like
    this:

    /api/sqlViews/w3UxFykyHFy/data.json?filter=orgunit_level:eq:2&filter=orgunit_name:ilike:bo

This request will return a result including org units with "bo" in the
name and which has org unit level 2.

The following example will return all org units with `orgunit_level` 2 or
4:

    /api/sqlViews/w3UxFykyHFy/data.json?filter=orgunit_level:in:[2,4]

And last, an example to return all org units that does not start with
"Bo"

    /api/sqlViews/w3UxFykyHFy/data.json?filter=orgunit_name:!like:Bo

## Dashboard

<!--DHIS2-SECTION-ID:webapi_dashboard-->

The dashboard is designed to give you an overview of multiple analytical
items like maps, charts, pivot tables and reports which together can
provide a comprehensive overview of your data. Dashboards are available
in the Web API through the *dashboards* resource. A dashboard contains a
list of dashboard *items*. An item can represent a single resource, like
a chart, map or report table, or represent a list of links to analytical
resources, like reports, resources, tabular reports and users. A
dashboard item can contain up to eight links. Typically, a dashboard
client could choose to visualize the single-object items directly in a
user interface, while rendering the multi-object items as clickable
links.

    /api/dashboards

### Browsing dashboards

<!--DHIS2-SECTION-ID:webapi_browsing_dashboards-->

To get a list of your dashboards with basic information including
identifier, name and link in JSON format you can make a *GET* request to
the following URL:

    /api/dashboards.json

The dashboards resource will provide a list of dashboards. Remember that
the dashboard object is shared so the list will be affected by the
currently authenticated user. You can retrieve more information about a
specific dashboard by following its link, similar to this:

    /api/dashboards/vQFhmLJU5sK.json

A dashboard contains information like name and creation date and an
array of dashboard items. The response in JSON format will look similar
to this response (certain information has been removed for the sake of
brevity).

```json
{
  "lastUpdated" : "2013-10-15T18:17:34.084+0000",
  "id": "vQFhmLJU5sK",
  "created": "2013-09-08T20:55:58.060+0000",
  "name": "Mother and Child Health",
  "href": "https://play.dhis2.org/demo/api/dashboards/vQFhmLJU5sK",
  "publicAccess": "--------",
  "externalAccess": false,
  "itemCount": 17,
  "displayName": "Mother and Child Health",
  "access": {
    "update": true,
    "externalize": true,
    "delete": true,
    "write": true,
    "read": true,
    "manage": true
  },
  "user": {
    "id": "xE7jOejl9FI",
    "name": "John Traore",
    "created": "2013-04-18T15:15:08.407+0000",
    "lastUpdated": "2014-12-05T03:50:04.148+0000",
    "href": "https://play.dhis2.org/demo/api/users/xE7jOejl9FI"
  },
  "dashboardItems": [{
    "id": "bu1IAnPFa9H",
    "created": "2013-09-09T12:12:58.095+0000",
    "lastUpdated": "2013-09-09T12:12:58.095+0000"
    }, {
    "id": "ppFEJmWWDa1",
    "created": "2013-09-10T13:57:02.480+0000",
    "lastUpdated": "2013-09-10T13:57:02.480+0000"
  }],
  "userGroupAccesses": []
}
```

A more tailored response can be obtained by specifying specific fields
in the request. An example is provided below, which would return more
detailed information about each object on a users dashboard.

    /api/dashboards/vQFhmLJU5sK/?fields=:all,dashboardItems[:all]

### Searching dashboards

<!--DHIS2-SECTION-ID:webapi_searching_dasboards-->

When a user is building a dashboard it is convenient
to be able to search for various analytical resources using the
*/dashboards/q* resource. This resource lets you search for matches on
the name property of the following objects: charts, maps, report tables,
users, reports and resources. You can do a search by making a *GET*
request on the following resource URL pattern, where my-query should be
replaced by the preferred search query:

    /api/dashboards/q/my-query.json

For example, this query:

    /api/dashboards/q/ma?count=6&maxCount=20&max=CHART&max=MAP

Will search for the following:

* Analytical object name contains the string "ma"
* Return up to 6 of each type
* For CHART and MAP types, return up to 20 items

<table>
<caption>dashboards/q query parameters</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 44%" />
<col style="width: 35%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
<th>Type</th>
<th>Default</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>count</td>
<td>The number of items of each type to return</td>
<td>Positive integer</td>
<td>6</td>
</tr>
<tr class="odd">
<td>maxCount</td>
<td>The number of items of max types to return</td>
<td>Positive integer</td>
<td>25</td>
</tr>
<tr class="even">
<td>max</td>
<td>The type to return the maxCount for</td>
<td>String [CHART|MAP|REPORT_TABLE|USER|REPORT|RESOURCE|VISUALIZATION]</td>
<td>N/A</td>
</tr>
</tbody>
</table>

JSON and XML response formats are supported. The response in JSON format
will contain references to matching resources and counts of how many
matches were found in total and for each type of resource. It will look
similar to this:

```json
{
  "charts": [{
    "name": "ANC: 1-3 dropout rate Yearly",
    "id": "LW0O27b7TdD"
  }, {
    "name": "ANC: 1 and 3 coverage Yearly",
    "id": "UlfTKWZWV4u"
  }, {
    "name": "ANC: 1st and 3rd trends Monthly",
    "id": "gnROK20DfAA"
  }],
  "visualizations": [{
    "name": "ANC: ANC 3 Visits Cumulative Numbers",
    "id": "arf9OiyV7df",
    "type": "LINE"
  }, {
    "name": "ANC: 1st and 2rd trends Monthly",
    "id": "jkf6OiyV7el",
    "type": "PIVOT_TABLE"
  }],
  "maps": [{
    "name": "ANC: 1st visit at facility (fixed) 2013",
    "id": "YOEGBvxjAY0"
  }, {
    "name": "ANC: 3rd visit coverage 2014 by district",
    "id": "ytkZY3ChM6J"
  }],
  "reportTables": [{
    "name": "ANC: ANC 1 Visits Cumulative Numbers",
    "id": "tWg9OiyV7mu"
  }],
  "reports": [{
    "name": "ANC: 1st Visit Cumulative Chart",
    "id": "Kvg1AhYHM8Q"
  }, {
    "name": "ANC: Coverages This Year",
    "id": "qYVNH1wkZR0"
  }],
  "searchCount": 8,
  "chartCount": 3,
  "mapCount": 2,
  "reportTableCount": 1,
  "reportCount": 2,
  "userCount": 0,
  "patientTabularReportCount": 0,
  "resourceCount": 0
}
```

### Creating, updating and removing dashboards

<!--DHIS2-SECTION-ID:webapi_creating_updating_removing_dashboards-->

Creating, updating and deleting dashboards follow standard REST
semantics. In order to create a new dashboard you can make a *POST*
request to the `/api/dashboards` resource. From a consumer perspective
it might be convenient to first create a dashboard and later add items
to it. JSON and XML formats are supported for the request payload. To
create a dashboard with the name "My dashboard" you can use a payload in
JSON like this:

    {
      "name": "My dashboard"
    }

To update, e.g. rename, a dashboard, you can make a *PUT* request with a
similar request payload the same api/dashboards resource.

To remove a dashboard, you can make a *DELETE* request to the specific
dashboard resource similar to this:

    /api/dashboards/vQFhmLJU5sK

### Adding, moving and removing dashboard items and content

<!--DHIS2-SECTION-ID:webapi_adding_moving_removing_dashboard_items-->

In order to add dashboard items a consumer can use the
`/api/dashboards/<dashboard-id>/items/content` resource, where
\<dashboard-id\> should be replaced by the relevant dashboard
identifier. The request must use the *POST* method. The URL syntax and
parameters are described in detail in the following table.

<table>
<caption>Items content parameters</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 44%" />
<col style="width: 35%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
<th>Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>type</td>
<td>Type of the resource to be represented by the dashboard item</td>
<td>chart | visualization | map | reportTable | users | reports | reportTables | resources | patientTabularReports | app</td>
</tr>
<tr class="even">
<td>id</td>
<td>Identifier of the resource to be represented by the dashboard item</td>
<td>Resource identifier</td>
</tr>
</tbody>
</table>

A *POST* request URL for adding a chart to a specific dashboard could
look like this, where the last id query parameter value is the chart
resource
    identifier:

    /api/dashboards/vQFhmLJU5sK/items/content?type=chart&id=LW0O27b7TdD

When adding resource of type map, chart, report table and app, the API
will create and add a new item to the dashboard. When adding a resource
of type users, reports, report tables and resources, the API will try to
add the resource to an existing dashboard item of the same type. If no
item of same type or no item of same type with less than eight resources
associated with it exists, the API will create a new dashboard item and
add the resource to it.

In order to move a dashboard item to a new position within the list of
items in a dashboard, a consumer can make a *POST* request to the
following resource URL, where `<dashboard-id>` should be replaced by the
identifier of the dashboard, `<item-id>` should be replaced by the
identifier of the dashboard item and `<index>` should be replaced by the
new position of the item in the dashboard, where the index is
zero-based:

    /api/dashboards/<dashboard-id>/items/<item-id>/position/<index>

To remove a dashboard item completely from a specific dashboard a
consumer can make a *DELETE* request to the below resource URL, where
`<dashboard-id>` should be replaced by the identifier of the dashboard
and `<item-id>` should be replaced by the identifier of the dashboard
item. The dashboard item identifiers can be retrieved through a GET
request to the dashboard resource URL.

    /api/dashboards/<dashboard-id>/items/<item-id>

To remove a specific content resource within a dashboard item a consumer
can make a *DELETE* request to the below resource URL, where
`<content-resource-id>` should be replaced by the identifier of a
resource associated with the dashboard item; e.g. the identifier of a
report or a user. For instance, this can be used to remove a single
report from a dashboard item of type reports, as opposed to removing the
dashboard item completely:

    /api/dashboards/<dashboard-id>/items/<item-id>/content/<content-resource-id>

## Visualization

<!--DHIS2-SECTION-ID:webapi_visualization-->

The Visualization API is designed to help clients to interact with charts and pivot/report tables. The endpoints of this API are used by the Data Visualization application which allows the creation, configuration and management of charts and pivot tables based on the client's definitions. The main idea is to enable clients and users to have a unique and centralized API providing all types of charts and pivot tables as well as specific parameters and configuration for each type of visualization.

This API was introduced with the expectation to unify both `charts` and `reportTables` APIs and entirely replace them in favour of the `visualizations` API (which means that the usage of `charts` and `reportTables` APIs should be avoided). In summary, the following resources/APIs:

    /api/charts, /api/reportTables

*are being replaced by*

    /api/visualizations

> **Note**
>
> New applications and clients should avoid using the `charts` and `reportTables` APIs because they are deprecated. Use the `visualizations` API instead.

A Visualization object is composed of many attributes (some of them related to charts and others related to pivot tables), but the most important ones responsible to reflect the core information of the object are: *"id", "name", "type", "dataDimensionItems", "columns", "rows" and "filters".*

The root endpoint of the API is `/api/visualizations`, and the list of current attributes and elements are described in the table below.

<table>
<caption>Visualization attributes</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>id</td>
<td>The unique identifier.</td>
</tr>
<tr class="even">
<td>code</td>
<td>A custom code to identify the Visualization.</td>
</tr>
<tr class="odd">
<td>name</td>
<td>The name of the Visualization</td>
</tr>
<tr class="even">
<td>type</td>
<td>The type of the Visualization. The valid types are: COLUMN, STACKED_COLUMN, BAR, STACKED_BAR, LINE, AREA, PIE, RADAR, GAUGE, YEAR_OVER_YEAR_LINE YEAR_OVER_YEAR_COLUMN, SINGLE_VALUE, PIVOT_TABLE.</td>
</tr>
<tr class="odd">
<td>title</td>
<td>A custom title.</td>
</tr>
<tr class="even">
<td>subtitle</td>
<td>A custom subtitle.</td>
</tr>
<tr class="odd">
<td>description</td>
<td>Defines a custom description for the Visualization.</td>
</tr>
<tr class="even">
<td>created</td>
<td>The date/time of the Visualization creation.</td>
</tr>
<tr class="odd">
<td>startDate</td>
<td>The beginning date used during the filtering.</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>The ending date used during the filtering.</td>
</tr>
<tr class="odd">
<td>sortOrder</td>
<td>The sorting order of this Visualization. Integer value.</td>
</tr>
<tr class="even">
<td>user</td>
<td>An object representing the creator of the Visualization.</td>
</tr>
<tr class="odd">
<td>publicAccess</td>
<td>Sets the permissions for public access.</td>
</tr>
<tr class="even">
<td>displayDensity</td>
<td>The display density of the text.</td>
</tr>
<tr class="odd">
<td>fontSize</td>
<td>The font size of the text.</td>
</tr>
<tr class="even">
<td>fontStyle</td>
<td>Custom font styles for: visualizationTitle, visualizationSubtitle, horizontalAxisTitle, verticalAxisTitle, targetLineLabel, baseLineLabel, seriesAxisLabel, categoryAxisLabel, legend.</td>
</tr>
<tr class="odd">
<td>relativePeriods</td>
<td>An object representing the relative periods used in the analytics query.</td>
</tr>
<tr class="even">
<td>legendSet</td>
<td>An object representing the definitions for the legend.</td>
</tr>
<tr class="odd">
<td>legendDisplayStyle</td>
<td>The legend's display style. It can be: FILL or TEXT.</td>
</tr>
<tr class="even">
<td>legendDisplayStrategy</td>
<td>The legend's display style. It can be: FIXED or BY_DATA_ITEM.</td>
</tr>
<tr class="odd">
<td>aggregationType</td>
<td>Determines how the values in the pivot table are aggregated. Valid options: SUM, AVERAGE, AVERAGE_SUM_ORG_UNIT, LAST, LAST_AVERAGE_ORG_UNIT, FIRST, FIRST_AVERAGE_ORG_UNIT, COUNT, STDDEV, VARIANCE, MIN, MAX, NONE, CUSTOM or DEFAULT.</td>
</tr>
<tr class="even">
<td>regressionType</td>
<td>A valid regression type: NONE, LINEAR, POLYNOMIAL or LOESS.</td>
</tr>
<tr class="odd">
<td>targetLineValue</td>
<td>The chart target line. Accepts a Double type.</td>
</tr>
<tr class="even">
<td>targetLineLabel</td>
<td>The chart target line label.</td>
</tr>
<tr class="odd">
<td>rangeAxisLabel</td>
<td>The chart vertical axis (y) label/title.</td>
</tr>
<tr class="even">
<td>domainAxisLabel</td>
<td>The chart horizontal axis (x) label/title.</td>
</tr>
<tr class="odd">
<td>rangeAxisMaxValue</td>
<td>The chart axis maximum value. Values outside of the range will not be displayed.</td>
</tr>
<tr class="even">
<td>rangeAxisMinValue</td>
<td>The chart axis minimum value. Values outside of the range will not be displayed.</td>
</tr>
<tr class="odd">
<td>rangeAxisSteps</td>
<td>The number of axis steps between the minimum and maximum values.</td>
</tr>
<tr class="even">
<td>rangeAxisDecimals</td>
<td>The number of decimals for the axes values.</td>
</tr>
<tr class="odd">
<td>baseLineValue</td>
<td>A chart baseline value.</td>
</tr>
<tr class="even">
<td>baseLineLabel</td>
<td>A chart baseline label.</td>
</tr>
<tr class="odd">
<td>digitGroupSeparator</td>
<td>The digit group separator. Valid values: COMMA, SPACE or NONE.</td>
</tr>
<tr class="even">
<td>topLimit</td>
<td>The top limit set for the Pivot table.</td>
</tr>
<tr class="odd">
<td>measureCriteria</td>
<td>Describes the criteria applied to this measure.</td>
</tr>
<tr class="even">
<td>percentStackedValues</td>
<td>Uses stacked values or not. More likely to be applied for graphics/charts. Boolean value.</td>
</tr>
<tr class="odd">
<td>noSpaceBetweenColumns</td>
<td>Show/hide space between columns. Boolean value.</td>
</tr>
<tr class="even">
<td>regression</td>
<td>Indicates whether the Visualization contains regression columns. More likely to be applicable to Pivot/Report. Boolean value.</td>
</tr>
<tr class="odd">
<td>externalAccess</td>
<td>Indicates whether the Visualization is available as external read-only. Boolean value.</td>
</tr>
<tr class="even">
<td>userOrganisationUnit</td>
<td>Indicates if the user has an organisation unit. Boolean value.</td>
</tr>
<tr class="odd">
<td>userOrganisationUnitChildren</td>
<td>Indicates if the user has a children organisation unit. Boolean value.</td>
</tr>
<tr class="even">
<td>userOrganisationUnitGrandChildren</td>
<td>Indicates if the user has a grand children organisation unit . Boolean value.</td>
</tr>
<tr class="odd">
<td>reportingParams</td>
<td>Object used to define boolean attributes related to reporting.</td>
</tr>
<tr class="even">
<td>rowTotals</td>
<td>Displays (or not) the row totals. Boolean value.</td>
</tr>
<tr class="odd">
<td>colTotals</td>
<td>Displays (or not) the columns totals. Boolean value.</td>
</tr>
<tr class="even">
<td>rowSubTotals</td>
<td>Displays (or not) the row sub-totals. Boolean value.</td>
</tr>
<tr class="odd">
<td>colSubTotals</td>
<td>Displays (or not) the columns sub-totals. Boolean value.</td>
</tr>
<tr class="even">
<td>cumulativeValues</td>
<td>Indicates whether the visualization is using cumulative values. Boolean value.</td>
</tr>
<tr class="odd">
<td>hideEmptyColumns</td>
<td>Indicates whether to hide columns with no data values. Boolean value.</td>
</tr>
<tr class="even">
<td>hideEmptyRows</td>
<td>Indicates whether to hide rows with no data values. Boolean value.</td>
</tr>
<tr class="odd">
<td>completedOnly</td>
<td>Indicates whether to hide columns with no data values. Boolean value.</td>
</tr>
<tr class="even">
<td>skipRounding</td>
<td>Apply or not rounding. Boolean value.</td>
</tr>
<tr class="odd">
<td>showDimensionLabels</td>
<td>Shows the dimension labels or not. Boolean value.</td>
</tr>
<tr class="even">
<td>hideTitle</td>
<td>Hides the title or not. Boolean value.</td>
</tr>
<tr class="odd">
<td>hideSubtitle</td>
<td>Hides the subtitle or not. Boolean value.</td>
</tr>
<tr class="even">
<td>hideLegend</td>
<td>Show/hide the legend. Very likely to be used by charts. Boolean value.</td>
</tr>
<tr class="odd">
<td>showHierarchy</td>
<td>Displays (or not) the organisation unit hierarchy names. Boolean value.</td>
</tr>
<tr class="even">
<td>showData</td>
<td>Used by charts to hide or not data/values within the rendered model. Boolean value.</td>
</tr>
<tr class="odd">
<td>lastUpdatedBy</td>
<td>Object that represents the user that applied the last changes to the Visualization.</td>
</tr>
<tr class="even">
<td>lastUpdated</td>
<td>The date/time of the last time the Visualization was changed.</td>
</tr>
<tr class="odd">
<td>favorites</td>
<td>List of user ids who have marked this object as a favorite.</td>
</tr>
<tr class="even">
<td>subscribers</td>
<td>List of user ids who have subscribed to this Visualization.</td>
</tr>
<tr class="odd">
<td>translations</td>
<td>Set of available object translation, normally filtered by locale.</td>
</tr>
</tbody>
</table>

### Retrieving visualizations

<!--DHIS2-SECTION-ID:webapi_visualization_retrieving_visualizations-->

To retrieve a list of all existing visualizations, in JSON format, with some basic information (including identifier, name and pagination) you can make a `GET` request to the URL below. You should see a list of all public/shared visualizations plus your private ones.

    GET /api/visualizations.json

If you want to retrieve the JSON definition of a specific Visualization you can add its respective identifier to the URL:

    GET /api/visualizations/hQxZGXqnLS9.json

The following representation is an example of a response in JSON format (for brevity, certain information has been removed). For the complete schema, please use `GET /api/schemas/visualization`.

```json
{
  "lastUpdated": "2020-02-06T11:57:09.678",
  "href": "http://my-domain/dhis/api/visualizations/hQxZGXqnLS9",
  "id": "hQxZGXqnLS9",
  "created": "2017-05-19T17:22:00.785",
  "name": "ANC: ANC 1st visits last 12 months cumulative values",
  "publicAccess": "rw------",
  "userOrganisationUnitChildren": false,
  "type": "LINE",
  "access": {},
  "reportingParams": {
    "parentOrganisationUnit": false,
    "reportingPeriod": false,
    "organisationUnit": false,
    "grandParentOrganisationUnit": false
  },
  "dataElementGroupSetDimensions": [],
  "attributeDimensions": [],
  "yearlySeries": [],
  "filterDimensions": [
    "dx"
  ],
  "columns": [
    {
      "id": "ou"
    }
  ],
  "dataElementDimensions": [],
  "categoryDimensions": [],
  "rowDimensions": [
    "pe"
  ],
  "columnDimensions": [
    "ou"
  ],
  "dataDimensionItems": [
    {
      "dataDimensionItemType": "DATA_ELEMENT",
      "dataElement": {
        "id": "fbfJHSPpUQD"
      }
    }
  ],
  "filters": [
    {
      "id": "dx"
    }
  ],
  "rows": [
    {
      "id": "pe"
    }
  ]
}
```
A more tailored response can be obtained by specifying, in the URL, the fields you want to extract. Ie.:

    GET /api/visualizations/hQxZGXqnLS9.json?fields=interpretations

will return

```json
{
  "interpretations": [
    {
      "id": "Lfr8I2RPU0C"
    },
    {
      "id": "JuwgdJlJPGb"
    },
    {
      "id": "WAoU2rSpyZp"
    }
  ]
}
```

As seen, the `GET` above will return only the interpretations related to the given identifier (in this case `hQxZGXqnLS9`).

### Creating, updating and removing visualizations

<!--DHIS2-SECTION-ID:webapi_visualization_add_update_remove_visualizations-->

These operations follow the standard *REST* semantics. A new Visualization can be created through a `POST` request to the `/api/visualizations` resource with a valid JSON payload. An example of payload could be:

```json
{
  "columns": [
    {
      "dimension": "J5jldMd8OHv",
      "items": [
        {
          "name": "CHP",
          "id": "uYxK4wmcPqA",
          "displayName": "CHP",
          "displayShortName": "CHP",
          "dimensionItemType": "ORGANISATION_UNIT_GROUP"
        },
        {
          "name": "Hospital",
          "id": "tDZVQ1WtwpA",
          "displayName": "Hospital",
          "displayShortName": "Hospital",
          "dimensionItemType": "ORGANISATION_UNIT_GROUP"
        }
      ]
    }
  ],
  "rows": [
    {
      "dimension": "SooXFOUnciJ",
      "items": [
        {
          "name": "DOD",
          "id": "B0bjKC0szQX",
          "displayName": "DOD",
          "displayShortName": "DOD",
          "dimensionItemType": "CATEGORY_OPTION_GROUP"
        },
        {
          "name": "CDC",
          "id": "OK2Nr4wdfrZ",
          "displayName": "CDC",
          "displayShortName": "CDC",
          "dimensionItemType": "CATEGORY_OPTION_GROUP"
        }
      ]
    }
  ],
  "filters": [
    {
      "dimension": "ou",
      "items": [
        {
          "name": "Sierra Leone",
          "id": "ImspTQPwCqd",
          "displayName": "Sierra Leone",
          "displayShortName": "Sierra Leone",
          "dimensionItemType": "ORGANISATION_UNIT"
        },
        {
          "name": "LEVEL-1",
          "id": "LEVEL-H1KlN4QIauv",
          "displayName": "LEVEL-1"
        }
      ]
    }
  ],
  "name": "HIV Cases Monthly",
  "description": "Cases of HIV across the months",
  "category": "XY1vwCQskjX",
  "showDimensionLabels": true,
  "hideEmptyRows": true,
  "hideEmptyColumns": true,
  "skipRounding": true,
  "aggregationType": "SUM",
  "regressionType": "LINEAR",
  "type": "PIVOT_TABLE",
  "numberType": "VALUE",
  "measureCriteria": "Some criteria",
  "showHierarchy": true,
  "completedOnly": true,
  "displayDensity": "NORMAL",
  "fontSize": "NORMAL",
  "digitGroupSeparator": "SPACE",
  "legendDisplayStyle": "FILL",
  "legendDisplayStrategy": "FIXED",
  "hideEmptyRowItems": "BEFORE_FIRST_AFTER_LAST",
  "regression": false,
  "cumulative": true,
  "sortOrder": 1,
  "topLimit": 2,
  "rowTotals": true,
  "colTotals": true,
  "hideTitle": true,
  "hideSubtitle": true,
  "hideLegend": true,
  "showData": true,
  "baseLineLabel": "A base label",
  "targetLineLabel": "A target label",
  "targetLineValue": 45.5,
  "baseLineValue": 19.99,
  "percentStackedValues": true,
  "noSpaceBetweenColumns": true,
  "rowSubTotals": true,
  "colSubTotals": true,
  "domainAxisLabel": "A domain axis label",
  "rangeAxisLabel": "A range axis label",
  "rangeAxisMaxValue": 123.65,
  "rangeAxisMinValue": 33.89,
  "rangeAxisSteps": 5,
  "rangeAxisDecimals": 10,
  "userOrgUnitType": "TEI_SEARCH",
  "externalAccess": false,
  "publicAccess": "--------",
  "reportingParams": {
    "reportingPeriod": true,
    "organisationUnit": true,
    "parentOrganisationUnit": true,
    "grandParentOrganisationUnit": true
  },
  "parentGraphMap": {
    "ImspTQPwCqd": ""
  },
  "access": {
    "read": true,
    "update": true,
    "externalize": true,
    "delete": false,
    "write": true,
    "manage": false
  },
  "optionalAxes": [
    {
      "dimensionalItem": "fbfJHSPpUQD",
      "axis": 1
    },
    {
      "dimensionalItem": "cYeuwXTCPkU",
      "axis": 2
    }
  ],
  "relativePeriods": {
    "thisYear": false,
    "quartersLastYear": true,
    "last52Weeks": false,
    "thisWeek": false,
    "lastMonth": false,
    "last14Days": false,
    "biMonthsThisYear": false,
    "monthsThisYear": false,
    "last2SixMonths": false,
    "yesterday": false,
    "thisQuarter": false,
    "last12Months": false,
    "last5FinancialYears": false,
    "thisSixMonth": false,
    "lastQuarter": false,
    "thisFinancialYear": false,
    "last4Weeks": false,
    "last3Months": false,
    "thisDay": false,
    "thisMonth": false,
    "last5Years": false,
    "last6BiMonths": false,
    "last4BiWeeks": false,
    "lastFinancialYear": false,
    "lastBiWeek": false,
    "weeksThisYear": false,
    "last6Months": false,
    "last3Days": false,
    "quartersThisYear": false,
    "monthsLastYear": false,
    "lastWeek": false,
    "last7Days": false,
    "thisBimonth": false,
    "lastBimonth": false,
    "lastSixMonth": false,
    "thisBiWeek": false,
    "lastYear": false,
    "last12Weeks": false,
    "last4Quarters": false
  },
  "user": {},
  "yearlySeries": [
    "THIS_YEAR"
  ],
  "userGroupAccesses": [
    {
      "access": "rwx-----",
      "userGroupUid": "ZoHNWQajIoe",
      "displayName": "Bo District M&E officers",
      "id": "ZoHNWQajIoe"
    }
  ],
  "userAccesses": [
    {
      "access": "--------",
      "displayName": "John Barnes",
      "id": "DXyJmlo9rge",
      "userUid": "DXyJmlo9rge"
    }
  ],
  "legendSet": {
    "name": "Death rate up",
    "id": "ham2eIDJ9k6",
    "legends": [
      {
        "startValue": 1,
        "endValue": 2,
        "color": "red",
        "image": "some-image"
      },
      {
        "startValue": 2,
        "endValue": 3,
        "color": "blue",
        "image": "other-image"
      }
    ]
  },
  "fontStyle": {
    "visualizationTitle": {
      "font": "VERDANA",
      "fontSize": 16,
      "bold": true,
      "italic": false,
      "underline": false,
      "textColor": "#3a3a3a",
      "textAlign": "LEFT"
    },
    "horizontalAxisTitle": {
      "font": "ROBOTO",
      "fontSize": 12,
      "bold": false,
      "italic": true,
      "underline": false,
      "textColor": "#2a2a2a",
      "textAlign": "CENTER"
    },
    "categoryAxisLabel": {
      "font": "ROBOTO",
      "fontSize": 12,
      "bold": false,
      "italic": true,
      "underline": false,
      "textColor": "#dedede",
      "textAlign": "CENTER"
    },
    "targetLineLabel": {
      "font": "ARIAL",
      "fontSize": 12,
      "bold": false,
      "italic": true,
      "underline": false,
      "textColor": "#dedede",
      "textAlign": "CENTER"
    }
  }
}
```

To update a specific Visualization, you can send a `PUT` request to the same `/api/visualizations` resource with a similar payload `PLUS` the respective Visualization's identifier, ie.:

    PUT /api/visualizations/hQxZGXqnLS9

Finally, to delete an existing Visualization, you can make a `DELETE` request specifying the identifier of the Visualization to be removed, as shown:

    DELETE /api/visualizations/hQxZGXqnLS9

## Data items

<!--DHIS2-SECTION-ID:webapi_data_items-->

This endpoint allows the user to query data related to a few different dimensional items. These items are: `INDICATOR`, `DATA_ELEMENT`, `DATA_SET`, `PROGRAM_INDICATOR`, `PROGRAM_DATA_ELEMENT`, `PROGRAM_ATTRIBUTE`. The endpoint supports only `GET` requests and, as other endpoints, can return responses in JSON or XML format.

The URL is `/api/dataItems` and as you can imagine, it is able to retrieve different objects through the same endpoint in the same `GET` request. For this reason, some queriable attributes available will differ depending on the dimensional item(s) being queried.

To understand the statement above let's have a look at the followings request examples:

1) `GET /api/dataItems?filter=dimensionItemType:eq:DATA_ELEMENT&filter=valueType:eq:TEXT`
In this example the item type `DATA_ELEMENT` has a `valueType` attribute which can be used in the query.

2) `GET /api/dataItems?filter=dimensionItemType:in:[PROGRAM_INDICATOR]&filter=program.id:eq:IpHINAT79UW`
Here, the `PROGRAM_INDICATOR` allows filtering by `program.id`.

So, based on the examples `1)` and `2)` if you try filtering a `DATA_ELEMENT` by `program.id` or filter a `PROGRAM_INDICATOR` by `valueType` you will get an error, as the respective attributes don't belong to those dimensional items.

Another important aspect to be highlighted is that this endpoint follows the same querying standards as other existing endpoints, like `Metadata object  filter` for example. As a consequence, it supports the same operators. See <a href="#webapi_metadata_object_filter">Metadata object filter</a> for the list of available operators.

### Possible endpoint responses

<!--DHIS2-SECTION-ID:webapi_data_items_possible_responses-->

Base on the `GET` request/query, a few different responses are possible. Below we are summarizing each possibility.

#### Results found (HTTP status code 302)

```
{
  "pager": {
    "page": 1,
    "pageCount": 1,
    "total": 26,
    "pageSize": 50
  },
  "nameableObjects": [
    {
      "code": "DE_399",
      "lastUpdated": "2014-11-11T21:56:05.728",
      "id": "A2VfEfPflHV",
      "created": "2011-12-24T12:24:25.088",
      "name": "All other new",
      "shortName": "Others new",
      "aggregationType": "SUM",
      "displayName": "All other new",
      "publicAccess": "rw------",
      "displayShortName": "Others new",
      "externalAccess": false,
      "dimensionItem": "A2VfEfPflHV",
      "displayFormName": "All other new",
      "favorite": false,
      "dimensionItemType": "DATA_ELEMENT",
      "access": {
        "read": true,
        "update": true,
        "externalize": false,
        "delete": true,
        "write": true,
        "manage": true
      },
      "user": {
        "id": "GOLswS44mh8"
      },
      "favorites": [],
      "translations": [
        {
          "property": "SHORT_NAME",
          "locale": "en_GB",
          "value": "Others new"
        },
        {
          "property": "NAME",
          "locale": "en_GB",
          "value": "All other new"
        }
      ],
      "userGroupAccesses": [],
      "attributeValues": [],
      "userAccesses": [],
      "legendSets": []
    }, ...
  ]
}
```

#### Results not found (HTTP status code 404)

```
{
  "pager": {
    "page": 1,
    "pageCount": 1,
    "total": 0,
    "pageSize": 50
  },
  "nameableObjects": []
}
```

#### Invalid query (HTTP status code 409)

```
{
  "httpStatus": "Conflict",
  "httpStatusCode": 409,
  "status": "ERROR",
  "message": "Unable to parse element `INVALID_TYPE` on filter `dimensionItemType`. The values available are: [INDICATOR, DATA_ELEMENT, DATA_ELEMENT_OPERAND, DATA_SET, PROGRAM_INDICATOR, PROGRAM_DATA_ELEMENT, PROGRAM_ATTRIBUTE]",
  "errorCode": "E2016"
}
```

#### Unhandled error (HTTP status code 500)

```
{
  "httpStatus": "Internal Server Error",
  "httpStatusCode": 500,
  "status": "ERROR"
}
```

### Pagination

<!--DHIS2-SECTION-ID:webapi_data_items_pagination-->

This endpoint also supports pagination as a default option. If needed, you can disable pagination by adding `paging=false` to the `GET` request.
ie.: `/api/dataItems?filter=dimensionItemType:in:[INDICATOR]&paging=false`.

Here is an example of a payload when the pagination is enabled. Remember that pagination is the default option and does not need to be explicitly set.

```
{
  "pager": {
    "page": 1,
    "pageCount": 20,
    "total": 969,
    "pageSize": 50,
    "nextPage": "http://your-domain/dhis/api/dataItems?page=2&filter=dimensionItemType:in:[INDICATOR]"
  },
  "nameableObjects": [...]
}
```

> **Note**
>
> The pagination of this endpoint needs to consolidate different dimensional items before building the response payload. Because of that, if some `order` is defined in the `GET` request, each page will bring an array of dimensional items respecting the ordering set.
>
> When paging is enabled the ordering is applied per page and not on the full result. In the other hand, if paging is disabled, the ordering will be applied to the full list of results. This will result in a difference in order. The first will order per page basis while the second will order the full list of items all at once.
>
> For better performance, we recommend leaving the pagination always enabled. It will optimize the performance by avoiding memory consumption and increasing the response time.

### Response attributes

<!--DHIS2-SECTION-ID:webapi_data_items_response_attributes-->

Now that we have a good idea of the main features and usage of this endpoint let's have a look in the list of attributes returned in the response.

<table>
<caption>Data items attributes</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>id</td>
<td>The unique identifier.</td>
</tr>
<tr class="even">
<td>code</td>
<td>A custom code to identify the dimensional item.</td>
</tr>
<tr class="odd">
<td>created</td>
<td>The date of creation.</td>
</tr>
<tr class="even">
<td>lastUpdated</td>
<td>The last date when this item was updated.</td>
</tr>
<tr class="odd">
<td>name</td>
<td>The name given for the item.</td>
</tr>
<tr class="even">
<td>shortName</td>
<td>A short name given for the item.</td>
</tr>
<tr class="odd">
<td>displayName</td>
<td>The display name defined.</td>
</tr>
<tr class="even">
<td>displayShortName</td>
<td>The display short name set.</td>
</tr>
<tr class="odd">
<td>displayFormName</td>
<td>The name of the associated form.</td>
</tr>
<tr class="even">
<td>dimensionItem</td>
<td>The unique identifier, same as id.</td>
</tr>
<tr class="odd">
<td>dimensionItemType</td>
<td>The dimension type. Possible types: INDICATOR, DATA_ELEMENT, REPORTING_RATE, PROGRAM_INDICATOR, PROGRAM_DATA_ELEMENT, PROGRAM_ATTRIBUTE.</td>
</tr>
<tr class="even">
<td>aggregationType</td>
<td>The aggregation type defined for this dimensional item. They can be: SUM, AVERAGE, AVERAGE_SUM_ORG_UNIT, LAST,
LAST_AVERAGE_ORG_UNIT, FIRST, FIRST_AVERAGE_ORG_UNIT, COUNT, STDDEV, VARIANCE, MIN, MAX, NONE, CUSTOM, DEFAULT.</td>
</tr>
<tr class="odd">
<td>publicAccess</td>
<td>The permissions set for public access.</td>
</tr>
<tr class="even">
<td>externalAccess</td>
<td>Indicates whether the item is available externaly as read-only. Boolean value.</td>
</tr>
<tr class="odd">
<td>favorites</td>
<td>List of user ids who have marked this object as a favorite.</td>
</tr>
<tr class="even">
<td>favorite</td>
<td>Indicates if the current istem is set as favorite for the current user. Boolean value.</td>
</tr>
<tr class="odd">
<td>access</td>
<td>Access information for this item, related to the current user.</td>
</tr>
<tr class="even">
<td>user</td>
<td>The owner of this object.</td>
</tr>
<tr class="odd">
<td>translations</td>
<td>Set of translatable objects available. Normally filtered by locale.</td>
</tr>
<tr class="even">
<td>userGroupAccesses</td>
<td>Groups access to the current dimensional item.</td>
</tr>
<tr class="odd">
<td>attributeValues</td>
<td>Set of the dynamic attributes values that belong to the current item.</td>
</tr>
<tr class="even">
<td>userAccesses</td>
<td>List of user accesses related to this object.</td>
</tr>
<tr class="odd">
<td>legendSet</td>
<td>Defines the legend set values. Will override the automatic legend set.</td>
</tr>
</tbody>
</table>

## Analytics

<!--DHIS2-SECTION-ID:webapi_analytics-->

To access analytical, aggregated data in DHIS2 you can work with the
*analytics* resource. The analytics resource is powerful as it lets you
query and retrieve data aggregated along all available data dimensions.
For instance, you can ask the analytics resource to provide the
aggregated data values for a set of data elements, periods and
organisation units. Also, you can retrieve the aggregated data for a
combination of any number of dimensions based on data elements and
organisation unit group sets.

    /api/33/analytics

### Request query parameters

<!--DHIS2-SECTION-ID:webapi_analytics_query_parameters-->

The analytics resource lets you specify a range of query parameters:

<table>
<caption>Query parameters</caption>
<colgroup>
<col style="width: 17%" />
<col style="width: 10%" />
<col style="width: 45%" />
<col style="width: 27%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options (default first)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dimension</td>
<td>Yes</td>
<td>Dimensions and dimension items to be retrieved, repeated for each.</td>
<td>Any dimension</td>
</tr>
<tr class="even">
<td>filter</td>
<td>No</td>
<td>Filters and filter items to apply to the query, repeated for each.</td>
<td>Any dimension</td>
</tr>
<tr class="odd">
<td>aggregationType</td>
<td>No</td>
<td>Aggregation type to use in the aggregation process.</td>
<td>SUM | AVERAGE | AVERAGE_SUM_ORG_UNIT | LAST | LAST_AVERAGE_ORG_UNIT | COUNT | STDDEV | VARIANCE | MIN | MAX</td>
</tr>
<tr class="even">
<td>measureCriteria</td>
<td>No</td>
<td>Filters for the data/measures.</td>
<td>EQ | GT | GE | LT | LE</td>
</tr>
<tr class="odd">
<td>preAggregationMeasureCriteria</td>
<td>No</td>
<td>Filters for the data/measure, applied before aggregation is performed.</td>
<td>EQ | GT | GE | LT | LE</td>
</tr>
<tr>
<td>startDate</td>
<td>No</td>
<td>Start date for a date range. Will be applied as a filter. Can not be used together with a period dimension or filter.</td>
<td>Date</td>
</tr>
<tr>
<td>endDate</td>
<td>No</td>
<td>End date for date range. Will be applied as a filter. Can not be used together with a period dimension or filter.</td>
<td>Date</td>
</tr>
<tr class="even">
<td>skipMeta</td>
<td>No</td>
<td>Exclude the metadata part of the response (improves performance).</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>skipData</td>
<td>No</td>
<td>Exclude the data part of the response.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>skipRounding</td>
<td>No</td>
<td>Skip rounding of data values, i.e. provide full precision.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>hierarchyMeta</td>
<td>No</td>
<td>Include names of organisation unit ancestors and hierarchy paths of organisation units in the metadata.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>ignoreLimit</td>
<td>No</td>
<td>Ignore limit on max 50 000 records in response - use with care.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>tableLayout</td>
<td>No</td>
<td>Use plain data source or table layout for the response.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>hideEmptyRows</td>
<td>No</td>
<td>Hides empty rows in response, applicable when table layout is true.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>hideEmptyColumns</td>
<td>No</td>
<td>Hides empty columns in response, applicable when table layout is true.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>showHierarchy</td>
<td>No</td>
<td>Display full org unit hierarchy path together with org unit name.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>includeNumDen</td>
<td>No</td>
<td>Include the numerator and denominator used to calculate the value in the response.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>includeMetadataDetails</td>
<td>No</td>
<td>Include metadata details to raw data response.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>displayProperty</td>
<td>No</td>
<td>Property to display for metadata.</td>
<td>NAME | SHORTNAME</td>
</tr>
<tr class="even">
<td>outputIdScheme</td>
<td>No</td>
<td>Identifier scheme to use for metadata items the query response, can be identifier, code or attributes.</td>
<td>UID | CODE |NAME| ATTRIBUTE:&lt;ID&gt;</td>
</tr>
<tr class="odd">
<td>inputIdScheme</td>
<td>No</td>
<td>Identifier scheme to use for metadata items in the query request, can be an identifier, code or attributes.</td>
<td>UID | CODE | ATTRIBUTE:&lt;ID&gt;</td>
</tr>
<tr class="even">
<td>approvalLevel</td>
<td>No</td>
<td>Include data which has been approved at least up to the given approval level, refers to identifier of approval level.</td>
<td>Identifier of approval level</td>
</tr>
<tr class="odd">
<td>relativePeriodDate</td>
<td>No</td>
<td>Date used as basis for relative periods.</td>
<td>Date.</td>
</tr>
<tr class="even">
<td>userOrgUnit</td>
<td>No</td>
<td>Explicitly define the user org units to utilize, overrides organisation units associated with the current user, multiple identifiers can be separated by semicolon.</td>
<td>Organisation unit identifiers.</td>
</tr>
<tr class="odd">
<td>columns</td>
<td>No</td>
<td>Dimensions to use as columns for table layout.</td>
<td>Any dimension (must be query dimension)</td>
</tr>
<tr class="even">
<td>rows</td>
<td>No</td>
<td>Dimensions to use as rows for table layout.</td>
<td>Any dimension (must be query dimension)</td>
</tr>
<tr class="odd">
<td>order</td>
<td>No</td>
<td>Specify the ordering of rows based on value.</td>
<td>ASC | DESC</td>
</tr>
<tr class="even">
<td>timeField</td>
<td>No</td>
<td>The time field to base event aggregation on. Applies to event data items only. Can be a predefined option or the ID of an attribute or data element with a time-based value type.</td>
<td>EVENT_DATE | ENROLLMENT_DATE | INCIDENT_DATE | DUE_DATE | COMPLETED_DATE | CREATED | LAST_UPDATED | &lt;Attribute ID&gt; | &lt;Data element ID&gt;</td>
</tr>
<tr>
<td>orgUnitField</td>
<td>No</td>
<td>The organisation unit field to base event aggregation on. Applies to event data items only. Can be the ID of an attribute or data element with the Organisation unit value type. The default option is specified as omitting the query parameter.
<td>&lt;Attribute ID&gt; | &lt;Data element ID&gt;</td>
</tr>
</tbody>
</table>

The *dimension* query parameter defines which dimensions should be
included in the analytics query. Any number of dimensions can be
specified. The dimension parameter should be repeated for each dimension
to include in the query response. The query response can potentially
contain aggregated values for all combinations of the specified
dimension items.

The *filter* parameter defines which dimensions should be used as
filters for the data retrieved in the analytics query. Any number of
filters can be specified. The filter parameter should be repeated for
each filter to use in the query. A filter differs from a dimension in
that the filter dimensions will not be part of the query response
content, and that the aggregated values in the response will be
collapsed on the filter dimensions. In other words, the data in the
response will be aggregated on the filter dimensions, but the filters
will not be included as dimensions in the actual response. As an
example, to query for certain data elements filtered by the periods and
organisation units you can use the following URL:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU&filter=pe:2014Q1;2014Q2
      &filter=ou:O6uvpzGd5pu;lc3eMKXaEfw

The *aggregationType* query parameter lets you define which aggregation
operator should be used for the query. By default, the aggregation
operator defined for data elements included in the query will be used.
If your query does not contain any data elements but does include data
element groups, the aggregation operator of the first data element in
the first group will be used. The order of groups and data elements is
undefined. This query parameter allows you to override the default and
specify a specific aggregation operator. As an example, you can set the
aggregation operator to "count" with the following URL:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD&dimension=pe:2014Q1&dimension=ou:O6uvpzGd5pu
      &aggregationType=COUNT

The *measureCriteria* query parameter lets you filter out ranges of data
records to return. You can instruct the system to return only records
where the aggregated data value is equal, greater than, greater or
equal, less than or less or equal to certain values. You can specify any
number of criteria on the following format, where *criteria* and
*value* should be substituted with real values:

    /api/33/analytics?measureCriteria=criteria:value;criteria:value

As an example, the following query will return only records where the
data value is greater or equal to 6500 and less than 33000:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU&dimension=pe:2014
      &dimension=ou:O6uvpzGd5pu;lc3eMKXaEfw&measureCriteria=GE:6500;LT:33000

Similar to *measureCriteria*, the *preAggregationMeasureCriteria* query
parameter lets you filter out data, only before aggregation is
performed. For example, the following query only aggregates data where
the original value is within the criteria defined:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU&dimension=pe:2014
      &dimension=ou:O6uvpzGd5pu;lc3eMKXaEfw&preAggregationMeasureCriteria=GE:10;LT:100

The *startDate* and *endDate* parameters can be used to specify a custom 
date range to aggregate over. When specifying a date range you can not
specify relative nor fixed periods as dimension or filter. The date range
will filter the analytics response. You can use it like this:

    /api/33/analytics.json?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &dimension=ou:ImspTQPwCqd&startDate=2018-01-01&endDate=2018-06-01

In order to have the analytics resource generate the data in the shape
of a ready-made table, you can provide the *tableLayout* parameter with
true as value. Instead of generating a plain, normalized data source,
the analytics resource will now generate the data in a table layout. You
can use the *columns* and *rows* parameters with dimension identifiers
separated by semi-colons as values to indicate which ones to use as
table columns and rows. The column and rows dimensions must be present
as a data dimension in the query (not a filter). Such a request can look
like this:

    /api/33/analytics.html?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU&dimension=pe:2014Q1;2014Q2
      &dimension=ou:O6uvpzGd5pu&tableLayout=true&columns=dx;ou&rows=pe

The *order* parameter can be used for analytics resource to generate
ordered data. The data will be ordered in ascending (or descending) order
of values. An example request for ordering the values in descending
order is:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD&dimension=pe:LAST_12_MONTHS
      &dimension=ou:O6uvpzGd5pu&order=DESC

### Dimensions and items

<!--DHIS2-SECTION-ID:webapi_analytics_dimensions_and_items-->

DHIS2 features a multi-dimensional data model with several fixed and
dynamic data dimensions. The fixed dimensions are the data element,
period (time) and organisation unit dimension. You can dynamically add
dimensions through categories, data element group sets and organisation
unit group sets. The table below displays the available data dimensions
in DHIS2. Each data dimension has a corresponding *dimension
identifier*, and each dimension can have a set of *dimension items*:

<table>
<caption>Dimensions and dimension items</caption>
<colgroup>
<col style="width: 38%" />
<col style="width: 12%" />
<col style="width: 49%" />
</colgroup>
<thead>
<tr class="header">
<th>Dimension</th>
<th>Dimension id</th>
<th>Dimension items</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Data elements, indicators, data set reporting rate metrics, data element operands, program indicators, program data elements, program attributes, validation rules</td>
<td>dx</td>
<td>Data element, indicator, data set reporting rate metrics, data element operand, program indicator, program attribute identifiers, keyword DE_GROUP-&lt;group-id&gt;, IN_GROUP-&lt;group-id&gt;, use &lt;dataelement-id&gt;.&lt;optioncombo-id&gt; for data element operands, &lt;program-id&gt;.&lt;dataelement-id&gt; for program data elements, &lt;program-id&gt;.&lt;attribute-id&gt; for program attributes, &lt;validationrule-id&gt; for validation results.</td>
</tr>
<tr class="even">
<td>Periods (time)</td>
<td>pe</td>
<td>ISO periods and relative periods, see &quot;date and period format&quot;</td>
</tr>
<tr class="odd">
<td>Organisation unit hierarchy</td>
<td>ou</td>
<td>Organisation unit identifiers, and keywords USER_ORGUNIT, USER_ORGUNIT_CHILDREN, USER_ORGUNIT_GRANDCHILDREN, LEVEL-&lt;level&gt; and OU_GROUP-&lt;group-id&gt;</td>
</tr>
<tr class="even">
<td>Category option combinations</td>
<td>co</td>
<td>Category option combo identifiers  (omit to get all items)</td>
</tr>
<tr class="odd">
<td>Attribute option combinations</td>
<td>ao</td>
<td>Category option combo identifiers (omit to get all items)</td>
</tr>
<tr class="even">
<td>Categories</td>
<td>&lt;category id&gt;</td>
<td>Category option identifiers (omit to get all items)</td>
</tr>
<tr class="odd">
<td>Data element group sets</td>
<td>&lt;group set id&gt;</td>
<td>Data element group identifiers (omit to get all items)</td>
</tr>
<tr class="even">
<td>Organisation unit group sets</td>
<td>&lt;group set id&gt;</td>
<td>Organisation unit group identifiers (omit to get all items)</td>
</tr>
<tr class="odd">
<td>Category option group sets</td>
<td>&lt;group set id&gt;</td>
<td>Category option group identifiers (omit to get all items)</td>
</tr>
</tbody>
</table>

It is not necessary to be aware of which objects are used for the
various dynamic dimensions when designing analytics queries. You can get
a complete list of dynamic dimensions by visiting this URL in the Web API:

    /api/33/dimensions

If you want to retrieve only the dimensional items for a given dynamic dimension you can
use the exemple below. The pagination is disabled by default. It can be enabled by adding
the pagination parameter `paging=true` to the URL.

    /api/33/dimensions/J5jldMd8OHv/items?paging=true

The base URL to the analytics resource is `/api/analytics`. To request
specific dimensions and dimension items you can use a query string on
the following format, where `dim-id` and `dim-item` should be substituted with real values:

    /api/33/analytics?dimension=dim-id:dim-item;dim-item&dimension=dim-id:dim-item;dim-item

As illustrated above, the dimension identifier is followed by a colon
while the dimension items are separated by semi-colons. As an example, a
query for two data elements, two periods and two organisation units can
be done with the following URL:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &dimension=pe:2016Q1;2016Q2&dimension=ou:O6uvpzGd5pu;lc3eMKXaEfw

To query for data broken down by category option combinations instead of
data element totals you can include the category dimension in the query
string, for instance like this:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &dimension=co&dimension=pe:201601&dimension=ou:O6uvpzGd5pu;lc3eMKXaEfw

When selecting data elements you can also select all data elements in a
group as items by using the DE_GROUP-<id> syntax:

    /api/33/analytics?dimension=dx:DE_GROUP-h9cuJOkOwY2
      &dimension=pe:201601&dimension=ou:O6uvpzGd5pu

When selecting data set reporting rates, the syntax contains a data
set identifier followed by a reporting rate metric:

    /api/33/analytics?dimension=dx:BfMAe6Itzgt.REPORTING_RATE;BfMAe6Itzgt.ACTUAL_REPORTS
      &dimension=pe:201601&dimension=ou:O6uvpzGd5pu

To query for program data elements (of tracker domain type) you can get
those by specifying the program for each data element using the
<program-id>.<dataelement-id> syntax:

    /api/33/analytics.json?dimension=dx:eBAyeGv0exc.qrur9Dvnyt5;eBAyeGv0exc.GieVkTxp4HH
      &dimension=pe:LAST_12_MONTHS&filter=ou:ImspTQPwCqd

To query for program attributes (tracked entity attributes) you can get
those by specifying the program for each attribute using the
<program.id>.<attribute-id> syntax:

    /api/33/analytics.json?dimension=dx:IpHINAT79UW.a3kGcGDCuk6;IpHINAT79UW.UXz7xuGCEhU
      &dimension=pe:LAST_4_QUARTERS&dimension=ou:ImspTQPwCqd

To query for organisation unit group sets and data elements you can use
the following URL. Notice how the group set identifier is used as
a dimension identifier and the groups as dimension items:

    /api/33/analytics?dimension=Bpx0589u8y0:oRVt7g429ZO;MAs88nJc9nL
      &dimension=pe:2016&dimension=ou:ImspTQPwCqd

To query for data elements and categories you can use this URL. Use the
category identifier as a dimension identifier and the category options as
dimension items:

    /api/33/analytics?dimension=dx:s46m5MS0hxu;fClA2Erf6IO&dimension=pe:2016
      &dimension=YNZyaJHiHYq:btOyqprQ9e8;GEqzEKCHoGA&filter=ou:ImspTQPwCqd

To query using relative periods and organisation units associated with
the current user you can use a URL like this:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &dimension=pe:LAST_12_MONTHS&dimension=ou:USER_ORGUNIT

When selecting organisation units for a dimension you can select an
entire level optionally constrained by any number of boundary
organisation units with the `LEVEL-<level>` syntax. Boundary refers to a
top node in a sub-hierarchy, meaning that all organisation units at the
given level below the given boundary organisation unit in the hierarchy
will be included in the response, and is provided as regular organisation unit 
dimension items. The level value can either be a numerical level or refer to the identifier
of the organisation unit level entity. A simple query for all org units at level three:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD&dimension=pe:2016&dimension=ou:LEVEL-3

A query for level three and four with two boundary org units can be
specified like this:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD&dimension=pe:2016
      &dimension=ou:LEVEL-3;LEVEL-4;O6uvpzGd5pu;lc3eMKXaEf

When selecting organisation units you can also select all organisation
units in an organisation unit group to be included as dimension items
using the OU_GROUP-<id> syntax. The organisation units in the groups
can optionally be constrained by any number of boundary organisation
units. Both the level and the group items can be repeated any number of
times:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD&dimension=pe:2016
      &dimension=ou:OU_GROUP-w0gFTTmsUcF;OU_GROUP-EYbopBOJWsW;O6uvpzGd5pu;lc3eMKXaEf

You can utilize identifier schemes for the metadata part of the
analytics response with the outputIdScheme property like this. You can
use ID, code and attributes as identifier scheme:

    /api/33/analytics?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &dimension=pe:2017Q1;2017Q2&dimension=ou:O6uvpzGd5pu&outputIdScheme=CODE

A few things to be aware of when using the analytics resource are listed
below.

  - Data elements, indicator, data set reporting rates, program data
    elements and program indicators are part of a common data dimension,
    identified as "dx". This means that you can use any of data
    elements, indicators and data set identifiers together with the "dx"
    dimension identifier in a query.

  - For the category, data element group set and organisation unit group
    set dimensions, all dimension items will be used in the query if no
    dimension items are specified.

  - For the period dimension, the dimension items are ISO period
    identifiers and/or relative periods. Please refer to the section
    above called "Date and period format" for the period format and
    available relative periods.

  - For the organisation unit dimension, you can specify the items to be
    the organisation unit or sub-units of the organisation unit
    associated with the user currently authenticated for the request
    using the keys `USER_ORGUNIT` or `USER_ORGUNIT_CHILDREN` as items,
    respectively. You can also specify organisation unit identifiers
    directly, or a combination of both.

  - For the organisation unit dimension, you can specify the organisation
    hierarchy level and the boundary unit to use for the request on the
    format `LEVEL-<level>-<boundary-id>`; as an example
    `LEVEL-3-ImspTQPwCqd` implies all organisation units below the given
    boundary unit at level 3 in the hierarchy.

  - For the organisation unit dimension, the dimension items are the
    organisation units and their sub-hierarchy - data will be aggregated
    for all organisation units below the given organisation unit in the
    hierarchy.

  - You cannot specify dimension items for the category option
    combination dimension. Instead, the response will contain the items
    which are linked to the data values.

### The dx dimension

<!--DHIS2-SECTION-ID:webapi_analytics_dx_dimension-->

The `dx` dimension is a special dimension which can contain all of the
following data types.

<table>
<caption>Data dx dimension types</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 23%" />
<col style="width: 27%" />
<col style="width: 23%" />
</colgroup>
<thead>
<tr class="header">
<th>Type</th>
<th>Syntax</th>
<th>Description</th>
<th>Data source</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Indicator</td>
<td>&lt;indicator-id&gt;</td>
<td>Indicator identifier.</td>
<td>Aggregated data</td>
</tr>
<tr class="even">
<td>Indicator grop</td>
<td>IN_GROUP-&lt;indicatorgroup-id&gt;</td>
<td>Keyword followed by an indicator group identifier. Will include all indicators in the group in the response.</td>
<td>Aggregated data</td>
</tr>
<tr class="odd">
<td>Data element</td>
<td>&lt;dataelement-id&gt;</td>
<td>Data element identifier.</td>
<td>Aggregated data</td>
</tr>
<tr class="even">
<td>Data element group</td>
<td>DE_GROUP-&lt;dataelementgroup-id&gt;</td>
<td>Keyword followed by a data element group identifier. Will include all data elements in the group in the response.</td>
<td>Aggregated data</td>
</tr>
<tr class="odd">
<td>Data element operand</td>
<td>&lt;dataelement-id&gt;.&lt;categoryoptcombo-id&gt;.&lt;attributeoptcombo-id&gt;</td>
<td>Data element identifier followed by one or both of category option combination and attribute option combo identifier. Wildcard &quot;*&quot; symbol can be used to indicate any option combination value. The attribute option combination identifier can be completely left out.</td>
<td>Aggregate data</td>
</tr>
<tr class="even">
<td>Data set</td>
<td>&lt;dataset-id&gt;.&lt;reporting-rate-metric&gt;</td>
<td>Data set identifier followed by reporting rate metric. Can be REPORTING_RATE | REPORTING_RATE_ON_TIME | ACTUAL_REPORTS | ACTUAL_REPORTS_ON_TIME | EXPECTED_REPORTS.</td>
<td>Data set completeness registrations</td>
</tr>
<tr class="odd">
<td>Program data element</td>
<td>&lt;program-id&gt;.&lt;dataelement-id&gt;</td>
<td>Program identifier followed by data element identifier. Reads from events within the specified program.</td>
<td>Events from the given program</td>
</tr>
<tr class="even">
<td>Program indicator</td>
<td>&lt;programindicator-id&gt;</td>
<td>Program indicator identifier. Reads from events from within the program associated with the program identifier.</td>
<td>Events from the program of the program indicator</td>
</tr>
<tr class="odd">
<td>Validation result</td>
<td>&lt;validationrule-id&gt;</td>
<td>Validation rule identifier. Will include validation rule violations for the validation rule, requires that validation results are generated and persisted.</td>
<td>Validation results</td>
</tr>
</tbody>
</table>

Items from all of the various `dx` types can be combined in an analytics
request. An example looks like this:

    /api/33/analytics.json
      ?dimension=dx:Uvn6LCg7dVU;BfMAe6Itzgt.REPORTING_RATE;IpHINAT79UW.a3kGcGDCuk6
      &dimension=pe:LAST_12_MONTHS&filter=ou:ImspTQPwCqd

The group syntax can be used together with any other item as well. An
example looks like this:

    /api/33/analytics.json
      ?dimension=dx:DE_GROUP-qfxEYY9xAl6;IN_GROUP-oehv9EO3vP7;BfMAe6Itzgt.REPORTING_RATE
      &dimension=pe:LAST_12_MONTHS&filter=ou:ImspTQPwCqd

Data element operands can optionally specify attribute option
combinations and use wildcards e.g. to specify all category option
combination values:

    /api/33/analytics.json
      ?dimension=dx:Uvn6LCg7dVU.*.j8vBiBqGf6O;Uvn6LCg7dVU.Z4oQs46iTeR
      &dimension=pe:LAST_12_MONTHS&filter=ou:ImspTQPwCqd

> **Tip**
>
> A great way to learn how to use the analytics API is to use the DHIS2
> *pivot table* app. You can play around with pivot tables using the
> various dimensions and items and click Download > Plain data source > JSON
> to see the resulting analytics API calls in the address bar of
> your Web browser.

### Response formats

<!--DHIS2-SECTION-ID:webapi_analytics_response_formats-->

The analytics response containing aggregate data can be returned in
various representation formats. As usual, you can indicate interest in a
specific format by appending a file extension to the URL, through the
`Accept` HTTP header or through the `format` query parameter. The
default format is JSON. The available formats and content-types are
listed below.

  - json (application/json)

  - jsonp (application/javascript)

  - xml (application/xml)

  - csv (application/csv)

  - html (text/html)

  - html+css (text/html)

  - xls (application/vnd.ms-excel)

As an example, to request an analytics response in XML format you can
use the following URL:

    /api/33/analytics.xml?dimension=dx:fbfJHSPpUQD
      &dimension=pe:2016&dimension=ou:O6uvpzGd5pu;lc3eMKXaEfw

The analytics responses must be retrieved using the HTTP *GET* method.
This allows for direct linking to analytics responses from Web pages as
well as other HTTP-enabled clients. To do functional testing we can use
the cURL library. By executing this command against the demo database
you will get an analytics response in JSON format:

```bash
curl "play.dhis2.org/demo/api/analytics.json?dimension=dx:eTDtyyaSA7f;FbKK4ofIv5R
  &dimension=pe:2016Q1;2016Q2&filter=ou:ImspTQPwCqd" -u admin:district
```

The JSON response will look like this:

```json
{
  "headers": [
    {
      "name": "dx",
      "column": "Data",
      "meta": true,
      "type": "java.lang.String"
    },
    {
      "name": "pe",
      "column": "Period",
      "meta": true,
      "type": "java.lang.String"
    },
    {
      "name": "value",
      "column": "Value",
      "meta": false,
      "type": "java.lang.Double"
    }
  ],
  "height": 4,
  "metaData": {
    "pe": [
      "2016Q1",
      "2016Q2"
    ],
    "ou": [
      "ImspTQPwCqd"
    ],
    "names": {
      "2016Q1": "Jan to Mar 2016",
      "2016Q2": "Apr to Jun 2016",
      "FbKK4ofIv5R": "Measles Coverage <1 y",
      "ImspTQPwCqd": "Sierra Leone",
      "eTDtyyaSA7f": "Fully Immunized Coverage"
    }
  },
  "rows": [
    [
      "eTDtyyaSA7f",
      "2016Q2",
      "81.1"
    ],
    [
      "eTDtyyaSA7f",
      "2016Q1",
      "74.7"
    ],
    [
      "FbKK4ofIv5R",
      "2016Q2",
      "88.9"
    ],
    [
      "FbKK4ofIv5R",
      "2016Q1",
      "84.0"
    ]
  ],
  "width": 3
}
```

The response represents a table of dimensional data. The *headers* array
gives an overview of which columns are included in the table and what
the columns contain. The *column* property shows the column dimension
identifier, or if the column contains measures, the word "Value". The
*meta* property is *true* if the column contains dimension items or
*false* if the column contains a measure (aggregated data values). The
*name* property is similar to the column property, except it displays
"value" in case the column contains a measure. The *type* property
indicates the Java class type of column values.

The *height* and *width* properties indicate how many data columns and
rows are contained in the response, respectively.

The *metaData periods* property contains a unique, ordered array of the
periods included in the response. The *metaData ou* property contains an
array of the identifiers of organisation units included in the response.
The *metaData names* property contains a mapping between the identifiers
used in the data response and the names of the objects they represent.
It can be used by clients to substitute the identifiers within the data
response with names in order to give a more meaningful view of the data
table.

The *rows* array contains the dimensional data table. It contains
columns with dimension items (object or period identifiers) and a column
with aggregated data values. The example response above has a
data/indicator column, a period column and a value column. The first
column contains indicator identifiers, the second contains ISO period
identifiers and the third contains aggregated data values.

### Constraints and validation

<!--DHIS2-SECTION-ID:webapi_analytics_constraints-->

There are several constraints to the input parameters you can provide to the
analytics resource. If any of the constraints are violated, the API will
return a *409 Conflict* response and a response message looking similar to this:

```json
{
  "httpStatus": "Conflict",
  "httpStatusCode": 409,
  "status": "ERROR",
  "message": "Only a single indicator can be specified as filter",
  "errorCode": "E7108"
}
```

The `httpStatus` and `httpStatusCode` fields indicate the HTTP status and
status code per the HTTP specification. The `messsage` field provides a
human-readable description of the validation error. The `errorCode` field
provides a machine-readable code which can be used by clients to handle
validation errors. The possible validation errors for the aggregate analytics
API are described in the table below.

| Error code | Message |
| ---------- | ------- |
| E7100      | Query parameters cannot be null |
| E7101      | At least one dimension must be specified |
| E7102      | At least one data dimension item or data element group set dimension item must be specified |
| E7103      | Dimensions cannot be specified as dimension and filter simultaneously |
| E7104      | At least one period as dimension or filter, or start and dates, must be specified |
| E7105      | Periods and start and end dates cannot be specified simultaneously |
| E7106      | Start date cannot be after end date |
| E7107      | Start and end dates cannot be specified for reporting rates |
| E7108      | Only a single indicator can be specified as filter |
| E7109      | Only a single reporting rate can be specified as filter |
| E7110      | Category option combos cannot be specified as filter |
| E7111      | Dimensions cannot be specified more than once |
| E7112      | Reporting rates can only be specified together with dimensions of type |
| E7113      | Assigned categories cannot be specified when data elements are not specified |
| E7114      | Assigned categories can only be specified together with data elements, not indicators or reporting rates |
| E7115      | Data elements must be of a value and aggregation type that allow aggregation |
| E7116      | Indicator expressions cannot contain cyclic references |
| E7117      | A data dimension 'dx' must be specified when output format is DATA_VALUE_SET |
| E7118      | A period dimension 'pe' must be specified when output format is DATA_VALUE_SET |
| E7119      | An organisation unit dimension 'ou' must be specified when output format is DATA_VALUE_SET |
| E7120      | User is not allowed to view org unit |
| E7121      | User is not allowed to read data for object |
| E7122      | Data approval level does not exist |
| E7123      | Current user is constrained by a dimension but has access to no dimension items |
| E7124      | Dimension is present in query without any valid dimension options |
| E7125      | Dimension identifier does not reference any dimension |
| E7126      | Column must be present as dimension in query |
| E7127      | Row must be present as dimension in query |
| E7128      | Query result set exceeded max limit |
| E7129      | Program is specified but does not exist |
| E7130      | Program stage is specified but does not exist |
| E7131      | Query failed, likely because the query timed out |

### Data value set format

<!--DHIS2-SECTION-ID:webapi_analytics_data_value_set_format-->

The analytics *dataValueSet* resource allows for returning aggregated
data in the data value set format. This format represents raw data
values, as opposed to data which has been aggregated along various
dimensions. Exporting aggregated data as regular data values is useful
for data exchange between systems when the target system contains data
of finer granularity compared to what the destination system is storing.

As an example, one can specify an indicator in the target system to
summarize data for multiple data elements and import this data for a
single data element in the destination system. As another example, one
can aggregate data collected at organisation unit level 4 in the target
system to level 2 and import that data in the destination system.

You can retrieve data in the raw data value set format from the
dataValueSet resource:

    /api/33/analytics/dataValueSet

The following resource representations are supported:

  - json (application/json)

  - xml (application/xml)

When using the data value set format, exactly three dimensions must be
specified as analytics dimensions with at least one dimension item each:

  - Data (dx)

  - Period (pe)

  - Organisation unit (ou)

Any other dimension will be ignored. Filters will be applied as with
regular analytics requests. Note that any data dimension type can be
specified, including indicators, data elements, data element operands,
data sets and program indicators.

An example request which aggregates data for specific indicators,
periods and organisation units and returns it as regular data values in
XML looks like this:

    api/analytics/dataValueSet.xml?dimension=dx:Uvn6LCg7dVU;OdiHJayrsKo
      &dimension=pe:LAST_4_QUARTERS&dimension=ou:lc3eMKXaEfw;PMa2VCrupOd

A request which aggregates data for data element operands and uses CODE
as output identifier scheme looks like the below. When defining the
output identifier scheme, all metadata objects part of the response are
affected:

    api/analytics/dataValueSet.json?dimension=dx:fbfJHSPpUQD.pq2XI5kz2BY;fbfJHSPpUQD.PT59n8BQbqM
      &dimension=pe:LAST_12_MONTHS&dimension=ou:ImspTQPwCqd&outputIdScheme=CODE

When using attribute-based identifier schemes for export there is a risk
of producing duplicate data values. The boolean query parameter
duplicatesOnly can be used for debugging purposes to return only
duplicates data values. This response can be used to clean up the
duplicates:

    api/analytics/dataValueSet.xml?dimension=dx:Uvn6LCg7dVU;OdiHJayrsKo
      &dimension=pe:LAST_4_QUARTERS&dimension=ou:lc3eMKXaEfw&duplicatesOnly=true

### Raw data format

<!--DHIS2-SECTION-ID:webapi_analytics_raw_data-->

The analytics *rawData* resource allows for returning the data stored in
the analytics data tables without any aggregation being performed. This
is useful for clients which would like to perform aggregation and
filtering on their own without having to denormalize data in the
available data dimensions themselves.

    /api/analytics/rawData

The following resource representations are supported:

  - json (application/json)

  - csv (application/csv)

This resource follows the syntax of the regular analytics resource. Only
a subset of the query parameters are supported. Additionally, a
*startDate* and *endDate* parameter are available. The supported
parameters are listed in the table below.

<table>
<caption>Query parameters</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required / Notes</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dimension</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>startDate</td>
<td>No / yyyy-MM-dd</td>
</tr>
<tr class="odd">
<td>endDate</td>
<td>No / yyyy-MM-dd</td>
</tr>
<tr class="even">
<td>skipMeta</td>
<td>No</td>
</tr>
<tr class="odd">
<td>skipData</td>
<td>No</td>
</tr>
<tr class="even">
<td>hierarchyMeta</td>
<td>No</td>
</tr>
<tr class="odd">
<td>showHierarchy</td>
<td>No</td>
</tr>
<tr class="even">
<td>displayProperty</td>
<td>No</td>
</tr>
<tr class="odd">
<td>outputIdScheme</td>
<td>No</td>
</tr>
<tr class="even">
<td>inputIdScheme</td>
<td>No</td>
</tr>
<tr class="odd">
<td>userOrgUnit</td>
<td>No</td>
</tr>
</tbody>
</table>

The *dimension* query parameter defines which dimensions (table columns)
should be included in the response. It can optionally be constrained
with items. The *filter* query parameter defines which items and
dimensions (table columns) should be used as a filter for the response.

For the organisation unit dimension, the response will contain data
associated with the organisation unit and all organisation units in the
sub-hierarchy (children in the tree). This is different compared to the
regular analytics resource, where only the explicitly selected
organisation units are included.

To retrieve a response with specific data elements, specific periods,
specific organisation units and all data for two custom dimensions you
can issue a request like this:

    /api/analytics/rawData.json?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU;Jtf34kNZhzP
      &dimension=J5jldMd8OHv&dimension=Bpx0589u8y0
      &dimension=pe:LAST_12_MONTHS
      &dimension=ou:O6uvpzGd5pu;fdc6uOvgoji

The *startDate* and *endDate* parameters allow for fetching data linked
to any period between those dates. This avoids the need for defining all
periods explicitly in the
    request:

    /api/analytics/rawData.json?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU;Jtf34kNZhzP
      &dimension=J5jldMd8OHv&dimension=Bpx0589u8y0
      &startDate=2015-01-01&endDate=2015-12-31
      &dimension=ou:O6uvpzGd5pu;fdc6uOvgoji

The *filter* parameter can be used to filter a response without
including that dimension as part of the response, this time in CSV
format:

    /api/analytics/rawData.csv?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU;Jtf34kNZhzP
      &filter=J5jldMd8OHv:uYxK4wmcPqA;tDZVQ1WtwpA
      &startDate=2015-01-01&endDate=2015-12-31
      &dimension=ou:O6uvpzGd5pu

The *outputIdScheme* parameter is useful if you want human readable data
responses as it can be set to *NAME* like this:

    /api/analytics/rawData.csv?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &filter=J5jldMd8OHv:uYxK4wmcPqA;tDZVQ1WtwpA
      &startDate=2017-01-01&endDate=2017-12-31
      &dimension=ou:O6uvpzGd5pu
      &outputIdScheme=NAME

The response from the *rawData* resource will look identical to the
regular analytics resource; the difference is that the response contains
raw, non-aggregated data, suitable for further aggregation by
third-party systems.

### Debugging

<!--DHIS2-SECTION-ID:webapi_analytics_debugging-->

When debugging analytics requests it can be useful to examine the data
value source of the aggregated analytics response. The
*analytics/debug/sql* resource will provide an SQL statement that
returns the relevant content of the datavalue table. You can produce
this SQL by doing a GET request with content type "text/html" or
"text/plain" like below. The dimension and filter syntax are identical to
regular analytics queries:

    /api/analytics/debug/sql?dimension=dx:fbfJHSPpUQD;cYeuwXTCPkU
      &filter=pe:2016Q1;2016Q2&filter=ou:O6uvpzGd5pu

## Event analytics

<!--DHIS2-SECTION-ID:webapi_event_analytics-->

The event analytics API lets you access aggregated event data and query
*events* captured in DHIS2. This resource lets you retrieve events based
on a program and optionally a program stage, and lets you retrieve and
filter events on any event dimensions.

    /api/33/analytics/events

### Dimensions and items

<!--DHIS2-SECTION-ID:webapi_event_analytics_dimensions_items-->

Event dimensions include data elements, attributes, organisation units
and periods. The aggregated event analytics resource will return
aggregated information such as counts or averages. The query analytics
resource will simply return events matching a set of criteria and does
not perform any aggregation. You can specify dimension items in the form
of options from option sets and legends from legend sets for data
elements and attributes which are associated with such. The event
dimensions are listed in the table below.

<table>
<caption>Event dimensions</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 11%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr class="header">
<th>Dimension</th>
<th>Dimension id</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Data elements</td>
<td>&lt;id&gt;</td>
<td>Data element identifiers</td>
</tr>
<tr class="even">
<td>Attributes</td>
<td>&lt;id&gt;</td>
<td>Attribute identifiers</td>
</tr>
<tr class="odd">
<td>Periods</td>
<td>pe</td>
<td>ISO periods and relative periods, see &quot;date and period format&quot;</td>
</tr>
<tr class="even">
<td>Organisation units</td>
<td>ou</td>
<td>Organisation unit identifiers and keywords USER_ORGUNIT, USER_ORGUNIT_CHILDREN, USER_ORGUNIT_GRANDCHILDREN, LEVEL-&lt;level&gt; and OU_GROUP-&lt;group-id&gt;</td>
</tr>
<tr class="odd">
<td>Organisation unit group sets</td>
<td>&lt;org unit group set id&gt;</td>
<td>Organisation unit group set identifiers</td>
</tr>
<tr class="even">
<td>Categories</td>
<td>&lt;category id&gt;</td>
<td>Category identifiers (program attribute categories only)</td>
</tr>
</tbody>
</table>

### Request query parameters

<!--DHIS2-SECTION-ID:webapi_event_analytics_request_query_parameters-->

The analytics event API lets you specify a range of query parameters.

<table>
<caption>Query parameters for both event query and aggregate analytics</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 11%" />
<col style="width: 48%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options (default first)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>program</td>
<td>Yes</td>
<td>Program identifier.</td>
<td>Any program identifier</td>
</tr>
<tr class="even">
<td>stage</td>
<td>No</td>
<td>Program stage identifier.</td>
<td>Any program stage identifier</td>
</tr>
<tr class="odd">
<td>startDate</td>
<td>Yes</td>
<td>Start date for events.</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>Yes</td>
<td>End date for events.</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr class="odd">
<td>dimension</td>
<td>Yes</td>
<td>Dimension identifier including data elements, attributes, program indicators, periods, organisation units and organisation unit group sets. Parameter can be repeated any number of times. Item filters can be applied to a dimension on the format &lt;item-id&gt;:&lt;operator&gt;:&lt;filter&gt;. Filter values are case-insensitive.</td>
<td>Operators can be EQ | GT | GE | LT | LE | NE | LIKE | IN</td>
</tr>
<tr class="even">
<td>filter</td>
<td>No</td>
<td>Dimension identifier including data elements, attributes, periods, organisation units and organisation unit group sets. Parameter can be repeated any number of times. Item filters can be applied to a dimension on the format &lt;item-id&gt;:&lt;operator&gt;:&lt;filter&gt;. Filter values are case-insensitive.</td>
<td></td>
</tr>
<tr class="odd">
<td>hierarchyMeta</td>
<td>No</td>
<td>Include names of organisation unit ancestors and hierarchy paths of organisation units in the metadata.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>eventStatus</td>
<td>No</td>
<td>Specify status of events to include.</td>
<td>ACTIVE | COMPLETED | SCHEDULE | OVERDUE | SKIPPED</td>
</tr>
<tr class="odd">
<td>programStatus</td>
<td>No</td>
<td>Specify enrollment status of events to include.</td>
<td>ACTIVE | COMPLETED | CANCELLED</td>
</tr>
<tr class="even">
<td>relativePeriodDate</td>
<td>string</td>
<td>No</td>
<td>Date identifier e.g: &quot;2016-01-01&quot;. Overrides the start date of the relative period</td>
</tr>
<tr class="odd">
<td>columns</td>
<td>No</td>
<td>Dimensions to use as columns for table layout.</td>
<td>Any dimension (must be query dimension)</td>
</tr>
<tr class="even">
<td>rows</td>
<td>No</td>
<td>Dimensions to use as rows for table layout.</td>
<td>Any dimension (must be query dimension)</td>
</tr>
</tbody>
</table>

<table>
<caption>Query parameters for event query analytics only</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 11%" />
<col style="width: 48%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ouMode</td>
<td>No</td>
<td>The mode of selecting organisation units. Default is DESCENDANTS, meaning all sub units in the hierarchy. CHILDREN refers to immediate children in the hierarchy; SELECTED refers to the selected organisation units only.</td>
<td>DESCENDANTS, CHILDREN, SELECTED</td>
</tr>
<tr class="even">
<td>asc</td>
<td>No</td>
<td>Dimensions to be sorted ascending, can reference event date, org unit name and code and any item identifiers.</td>
<td>EVENTDATE | OUNAME | OUCODE | item identifier</td>
</tr>
<tr class="odd">
<td>desc</td>
<td>No</td>
<td>Dimensions to be sorted descending, can reference event date, org unit name and code and any item identifiers.</td>
<td>EVENTDATE | OUNAME | OUCODE | item identifier</td>
</tr>
<tr class="even">
<td>coordinatesOnly</td>
<td>No</td>
<td>Whether to only return events which have coordinates.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>dataIdScheme</td>
<td>No</td>
<td>Id scheme to be used for data, more specifically data elements and attributes which have an option set or legend set, e.g. return the name of the option instead of the code, or the name of the legend instead of the legend ID, in the data response.</td>
<td>NAME | CODE | UID</td>
</tr>
<tr class="even">
<td>page</td>
<td>No</td>
<td>The page number. Default page is 1.</td>
<td>Numeric positive value</td>
</tr>
<tr class="odd">
<td>pageSize</td>
<td>No</td>
<td>The page size. Default size is 50 items per page.</td>
<td>Numeric zero or positive value</td>
</tr>
</tbody>
</table>

<table>
<caption>Query parameters for aggregate event analytics only</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 11%" />
<col style="width: 48%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>value</td>
<td>No</td>
<td>Value dimension identifier. Can be a data element or an attribute which must be of numeric value type.</td>
<td>Data element or attribute identifier</td>
</tr>
<tr class="even">
<td>aggregationType</td>
<td>No</td>
<td>Aggregation type for the value dimension. Default is AVERAGE.</td>
<td>SUM | AVERAGE | AVERAGE_SUM_ORG_UNIT | LAST | LAST_AVERAGE_ORG_UNIT | COUNT | STDDEV | VARIANCE | MIN | MAX</td>
</tr>
<tr class="odd">
<td>showHierarchy</td>
<td>No</td>
<td>Display full org unit hierarchy path together with org unit name.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>displayProperty</td>
<td>No</td>
<td>Property to display for metadata.</td>
<td>NAME | SHORTNAME</td>
</tr>
<tr class="odd">
<td>sortOrder</td>
<td>No</td>
<td>Sort the records on the value column in ascending or descending order.</td>
<td>ASC | DESC</td>
</tr>
<tr class="even">
<td>limit</td>
<td>No</td>
<td>The maximum number of records to return. Cannot be larger than 10 000.</td>
<td>Numeric positive value</td>
</tr>
<tr class="odd">
<td>outputType</td>
<td>No</td>
<td>Specify output type for analytical data which can be events, enrollments or tracked entity instances. The two last options apply to programs with registration only.</td>
<td>EVENT | ENROLLMENT | TRACKED_ENTITY_INSTANCE</td>
</tr>
<tr class="even">
<td>collapseDataDimensions</td>
<td>No</td>
<td>Collapse all data dimensions (data elements and attributes) into a single dimension in the response.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>skipMeta</td>
<td>No</td>
<td>Exclude the meta data part of the response (improves performance).</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>skipData</td>
<td>No</td>
<td>Exclude the data part of the response.</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>skipRounding</td>
<td>No</td>
<td>Skip rounding of aggregate data values.</td>
<td>false | true</td>
</tr>
<tr class="even">
<td>aggregateData</td>
<td>No</td>
<td>Produce aggregate values for the data dimensions (as opposed to dimension items).</td>
<td>false | true</td>
</tr>
<tr class="odd">
<td>timeField</td>
<td>No</td>
<td>The time field to base event aggregation on. Applies to event data items only. Can be a predefined option or the ID of an attribute or data element having a time-based value type.</td>
<td>EVENT_DATE | ENROLLMENT_DATE | INCIDENT_DATE | DUE_DATE | COMPLETED_DATE | &lt;Attribute ID&gt; | &lt;Data element ID&gt;</td>
</tr>
<tr>
<td>orgUnitField</td>
<td>No</td>
<td>The organisation unit field to base event aggregation on. Applies to event data items only. Can be the ID of an attribute or data element with the Organisation unit value type. The default option is specified as omitting the query parameter.
<td>&lt;Attribute ID&gt; | &lt;Data element ID&gt;</td>
</tr>
</tbody>
</table>

<table>
<caption>Query parameters for cluster event analytics only</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 11%" />
<col style="width: 49%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>clusterSize</td>
<td>Yes</td>
<td>Size of clusters in meters.</td>
<td>Numeric positive value</td>
</tr>
<tr class="even">
<td>coordinateField</td>
<td>No</td>
<td>Field to base geospatial event analytics on. Default is event. Can be set to identifiers of attributes and data elements of value type coordinate.</td>
<td>EVENT | &lt;attribute-id&gt; | &lt;dataelement-id&gt;</td>
</tr>
<tr class="odd">
<td>bbox</td>
<td>Yes</td>
<td>Bounding box / area of events to include in the response on the format &quot;min longitude, min latitude, max longitude , max latitude&quot;.</td>
<td>String</td>
</tr>
<tr class="even">
<td>includeClusterPoints</td>
<td>No</td>
<td>Include information about underlying points for each cluster, be careful if cluster represent a very high number of points.</td>
<td>false | true</td>
</tr>
</tbody>
</table>

### Event query analytics

<!--DHIS2-SECTION-ID:webapi_event_query_analytics-->

The *analytics/events/query* resource lets you query for captured
events. This resource does not perform any aggregation, rather it lets
you query and filter for information about events.

    /api/33/analytics/events/query

You can specify any number of dimensions and any number of filters in a
query. Dimension item identifiers can refer to any of data elements,
person attributes, person identifiers, fixed and relative periods and
organisation units. Dimensions can optionally have a query operator and
a filter. Event queries should be on the format described
    below.

    /api/33/analytics/events/query/<program-id>?startDate=yyyy-MM-dd&endDate=yyyy-MM-dd
      &dimension=ou:<ou-id>;<ou-id>&dimension=<item-id>&dimension=<item-id>:<operator>:<filter>

For example, to retrieve events from the "Inpatient morbidity and
mortality" program between January and October 2016, where the "Gender"
and "Age" data elements are included and the "Age" dimension is filtered
on "18", you can use the following
    query:

    /api/33/analytics/events/query/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:O6uvpzGd5pu;fdc6uOvgoji&dimension=oZg33kd9taw&dimension=qrur9Dvnyt5:EQ:18

To retrieve events for the "Birth" program stage of the "Child
programme" program between March and December 2016, where the "Weight"
data element, filtered for values larger than
    2000:

    /api/33/analytics/events/query/IpHINAT79UW?stage=A03MvHHogjR&startDate=2016-03-01
      &endDate=2016-12-31&dimension=ou:O6uvpzGd5pu&dimension=UXz7xuGCEhU:GT:2000

Sorting can be applied to the query for the event date of the event and
any dimensions. To sort descending on the event date and ascending on
the "Age" data element dimension you can
    use:

    /api/33/analytics/events/query/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:O6uvpzGd5pu&dimension=qrur9Dvnyt5&desc=EVENTDATE&asc=qrur9Dvnyt5

Paging can be applied to the query by specifying the page number and the
page size parameters. If page number is specified but page size is not,
a page size of 50 will be used. If page size is specified but page
number is not, a page number of 1 will be used. To get the third page of
the response with a page size of 20 you can use a query like
    this:

    /api/33/analytics/events/query/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:O6uvpzGd5pu&dimension=qrur9Dvnyt5&page=3&pageSize=20

#### Filtering

Filters can be applied to data elements, person attributes and person
identifiers. The filtering is done through the query parameter value on
the following format:

    &dimension=<item-id>:<operator>:<filter-value>

As an example, you can filter the "Weight" data element for values
greater than 2000 and lower than 4000 like this:

    &dimension=UXz7xuGCEhU:GT:2000&dimension=UXz7xuGCEhU:LT:4000

You can filter the "Age" data element for multiple, specific ages using
the IN operator like this:

    &dimension=qrur9Dvnyt5:IN:18;19;20

You can specify multiple filters for a given item by repeating the
operator and filter components, all separated with semi-colons:

    &dimension=qrur9Dvnyt5:GT:5:LT:15

The available operators are listed below.

<table>
<caption>Filter operators</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr class="header">
<th>Operator</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>EQ</td>
<td>Equal to</td>
</tr>
<tr class="even">
<td>GT</td>
<td>Greater than</td>
</tr>
<tr class="odd">
<td>GE</td>
<td>Greater than or equal to</td>
</tr>
<tr class="even">
<td>LT</td>
<td>Less than</td>
</tr>
<tr class="odd">
<td>LE</td>
<td>Less than or equal to</td>
</tr>
<tr class="even">
<td>NE</td>
<td>Not equal to</td>
</tr>
<tr class="odd">
<td>LIKE</td>
<td>Like (free text match)</td>
</tr>
<tr class="even">
<td>IN</td>
<td>Equal to one of multiple values separated by &quot;;&quot;</td>
</tr>
</tbody>
</table>

#### Response formats

The default response representation format is JSON. The requests must be
using the HTTP *GET* method. The following response formats are
supported.

  - json (application/json)

  - jsonp (application/javascript)

  - xls (application/vnd.ms-excel)

As an example, to get a response in Excel format you can use a file
extension in the request URL like this:

    /api/33/analytics/events/query/eBAyeGv0exc.xls?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:O6uvpzGd5pu&dimension=oZg33kd9taw&dimension=qrur9Dvnyt5

You can set the hierarchyMeta query parameter to true in order to
include names of all ancestor organisation units in the meta-section of
the response:

    /api/33/analytics/events/query/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:YuQRtpLP10I&dimension=qrur9Dvnyt5:EQ:50&hierarchyMeta=true

The default response JSON format will look similar to this:

```json
{
  "headers": [
    {
      "name": "psi",
      "column": "Event",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "ps",
      "column": "Program stage",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "eventdate",
      "column": "Event date",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "coordinates",
      "column": "Coordinates",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "ouname",
      "column": "Organisation unit name",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "oucode",
      "column": "Organisation unit code",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "ou",
      "column": "Organisation unit",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "oZg33kd9taw",
      "column": "Gender",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    },
    {
      "name": "qrur9Dvnyt5",
      "column": "Age",
      "type": "java.lang.String",
      "hidden": false,
      "meta": false
    }
  ],
  "metaData": {
    "names": {
      "qrur9Dvnyt5": "Age",
      "eBAyeGv0exc": "Inpatient morbidity and mortality",
      "ImspTQPwCqd": "Sierra Leone",
      "O6uvpzGd5pu": "Bo",
      "YuQRtpLP10I": "Badjia",
      "oZg33kd9taw": "Gender"
    },
    "ouHierarchy": {
      "YuQRtpLP10I": "/ImspTQPwCqd/O6uvpzGd5pu"
    }
  },
  "width": 8,
  "height": 4,
  "rows": [
    [
      "yx9IDINf82o",
      "Zj7UnCAulEk",
      "2016-08-05",
      "[5.12, 1.23]",
      "Ngelehun",
      "OU_559",
      "YuQRtpLP10I",
      "Female",
      "50"
    ],
    [
      "IPNa7AsCyFt",
      "Zj7UnCAulEk",
      "2016-06-12",
      "[5.22, 1.43]",
      "Ngelehun",
      "OU_559",
      "YuQRtpLP10I",
      "Female",
      "50"
    ],
    [
      "ZY9JL9dkhD2",
      "Zj7UnCAulEk",
      "2016-06-15",
      "[5.42, 1.33]",
      "Ngelehun",
      "OU_559",
      "YuQRtpLP10I",
      "Female",
      "50"
    ],
    [
      "MYvh4WAUdWt",
      "Zj7UnCAulEk",
      "2016-06-16",
      "[5.32, 1.53]",
      "Ngelehun",
      "OU_559",
      "YuQRtpLP10I",
      "Female",
      "50"
    ]
  ]
}
```

The *headers* section of the response describes the content of the query
result. The event unique identifier, the program stage identifier, the
event date, the organisation unit name, the organisation unit code and
the organisation unit identifier appear as the first six dimensions in
the response and will always be present. Next comes the data elements,
person attributes and person identifiers which were specified as
dimensions in the request, in this case, the "Gender" and "Age" data
element dimensions. The header section contains the identifier of the
dimension item in the "name" property and a readable dimension
description in the "column" property.

The *metaData* section, *ou* object contains the identifiers of all
organisation units present in the response mapped to a string
representing the hierarchy. This hierarchy string lists the identifiers
of the ancestors (parents) of the organisation unit starting from the
root. The *names* object contains the identifiers of all items in the
response mapped to their names.

The *rows* section contains the events produced by the query. Each row
represents exactly one event.

In order to have the event analytics resource generate the data in the
shape of a ready-made table, you can provide *rows* and *columns*
parameters with requested dimension identifiers separated by semi-colons
as values to indicate which ones to use as table columns and rows.
Instead of generating a plain, normalized data source, the event
analytics resource will now generate the data in table layout. The
column and rows dimensions must be present as a data dimension in the
query (not a filter). Such a request can look like this:

    /api/33/analytics.html+css?dimension=dx:cYeuwXTCPkU;fbfJHSPpUQD&dimension=pe:WEEKS_THIS_YEAR
      &filter=ou:ImspTQPwCqd&displayProperty=SHORTNAME&columns=dx&rows=pe

### Event aggregate analytics

<!--DHIS2-SECTION-ID:webapi_event_aggregate_analytics-->

The `/analytics/events/aggregate` resource lets you retrieve *aggregated
numbers* of events captured in DHIS2. This resource lets you retrieve
aggregate data based on a program and optionally a program stage, and
lets you filter on any event dimension.

    /api/33/analytics/events/aggregate

The events aggregate resource does not return the event information
itself, rather the aggregate numbers of events matching the request
query. Event dimensions include data elements, person attributes, person
identifiers, periods and organisation units. Aggregate event queries
should be on the format described below.

    /api/33/analytics/events/aggregate/<program-id>?startDate=yyyy-MM-dd&endDate=yyyy-MM-dd
      &dimension=ou:<ou-id>;<ou-id>&dimension=<item-id>&dimension=<item-id>:<operator>:<filter>

For example, to retrieve aggregate numbers for events from the
"Inpatient morbidity and mortality" program between January and October
2016, where the "Gender" and "Age" data elements are included, the "Age"
dimension item is filtered on "18" and the "Gender" item is filtered on
"Female", you can use the following query:

    /api/33/analytics/events/aggregate/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:O6uvpzGd5pu&dimension=oZg33kd9taw:EQ:Female&dimension=qrur9Dvnyt5:GT:50

To retrieve data for fixed and relative periods instead of start and end
date, in this case, May 2016 and last 12 months, and the organisation
unit associated with the current user, you can use the following query:

    /api/33/analytics/events/aggregate/eBAyeGv0exc?dimension=pe:201605;LAST_12_MONTHS
      &dimension=ou:USER_ORGUNIT;fdc6uOvgo7ji&dimension=oZg33kd9taw

In order to specify "Female" as a filter for "Gender" for the data
response, meaning "Gender" will not be part of the response but will
filter the aggregate numbers in it, you can use the following syntax:

    /api/33/analytics/events/aggregate/eBAyeGv0exc?dimension=pe:2016;
      &dimension=ou:O6uvpzGd5pu&filter=oZg33kd9taw:EQ:Female

To specify the "Bo" organisation unit and the period "2016" as filters,
and the "Mode of discharge" and Gender" as dimensions, where "Gender" is
filtered on the "Male" item, you can use a query like this:

    /api/33/analytics/events/aggregate/eBAyeGv0exc?filter=pe:2016&filter=ou:O6uvpzGd5pu
      &dimension=fWIAEtYVEGk&dimension=oZg33kd9taw:EQ:Male

To create a "top 3 report" for "Mode of discharge" you can use the limit
and sortOrder query parameters similar to this:

    /api/33/analytics/events/aggregate/eBAyeGv0exc?filter=pe:2016&filter=ou:O6uvpzGd5pu
      &dimension=fWIAEtYVEGk&limit=3&sortOrder=DESC

To specify a value dimension with a corresponding aggregation type you
can use the value and aggregationType query parameters. Specifying a
value dimension will make the analytics engine return aggregate values
for the values of that dimension in the response as opposed to counts of
events.

    /api/33/analytics/events/aggregate/eBAyeGv0exc.json?stage=Zj7UnCAulEk&dimension=ou:ImspTQPwCqd
      &dimension=pe:LAST_12_MONTHS&dimension=fWIAEtYVEGk&value=qrur9Dvnyt5&aggregationType=AVERAGE

To base event analytics aggregation on a specific data element or attribute
of value type date or date time you can use the `timeField` parameter:

    /api/33/analytics/events/aggregate/IpHINAT79UW.json?dimension=ou:ImspTQPwCqd
    &dimension=pe:LAST_12_MONTHS&dimension=cejWyOfXge6&stage=A03MvHHogjR&timeField=ENROLLMENT_DATE

To base event analytics aggregation on a specific data element or attribute
of value type organisation unit you can use the `orgUnitField` parameter:

    /api/33/analytics/events/aggregate/eBAyeGv0exc.json?dimension=ou:ImspTQPwCqd
    &dimension=pe:THIS_YEAR&dimension=oZg33kd9taw&stage=Zj7UnCAulEk&orgUnitField=S33cRBsnXPo

#### Ranges / legend sets

For aggregate queries, you can specify a range / legend set for numeric
data element and attribute dimensions. The purpose is to group the
numeric values into ranges. As an example, instead of generating data
for an "Age" data element for distinct years, you can group the
information into age groups. To achieve this, the data element or
attribute must be associated with the legend set. The format is
described below:

    ?dimension=<item-id>-<legend-set-id>

An example looks like
    this:

    /api/33/analytics/events/aggregate/eBAyeGv0exc.json?stage=Zj7UnCAulEk
      &dimension=qrur9Dvnyt5-Yf6UHoPkdS6&dimension=ou:ImspTQPwCqd&dimension=pe:LAST_MONTH

#### Response formats

The default response representation format is JSON. The requests must be
using the HTTP *GET* method. The response will look similar to this:

```json
{
  "headers": [
    {
      "name": "oZg33kd9taw",
      "column": "Gender",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "qrur9Dvnyt5",
      "column": "Age",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "pe",
      "column": "Period",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "ou",
      "column": "Organisation unit",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "value",
      "column": "Value",
      "type": "java.lang.String",
      "meta": false
    }
  ],
  "metaData": {
    "names": {
      "eBAyeGv0exc": "Inpatient morbidity and mortality"
    }
  },
  "width": 5,
  "height": 39,
  "rows": [
    [
      "Female",
      "95",
      "201605",
      "O6uvpzGd5pu",
      "2"
    ],
    [
      "Female",
      "63",
      "201605",
      "O6uvpzGd5pu",
      "2"
    ],
    [
      "Female",
      "67",
      "201605",
      "O6uvpzGd5pu",
      "1"
    ],
    [
      "Female",
      "71",
      "201605",
      "O6uvpzGd5pu",
      "1"
    ],
    [
      "Female",
      "75",
      "201605",
      "O6uvpzGd5pu",
      "14"
    ],
    [
      "Female",
      "73",
      "201605",
      "O6uvpzGd5pu",
      "5"
    ]
  ]
}
```

Note that the max limit for rows to return in a single response is 10 000. 
If the query produces more than the max limit, a *409 Conflict* status code 
will be returned.

### Event clustering analytics

<!--DHIS2-SECTION-ID:webapi_event_clustering_analytics-->

The *analytics/events/cluster* resource provides clustered geospatial
event data. A request looks like this:

    /api/33/analytics/events/cluster/eBAyeGv0exc?startDate=2016-01-01&endDate=2016-10-31
      &dimension=ou:LEVEL-2&clusterSize=100000
      &bbox=-13.2682125,7.3721619,-10.4261178,9.904012&includeClusterPoints=false

The cluster response provides the count of underlying points, the center
point and extent of each cluster. If the `includeClusterPoints` query
parameter is set to true, a comma-separated string with the identifiers
of the underlying events is included. A sample response looks like this:

```json
{
  "headers": [
    {
      "name": "count",
      "column": "Count",
      "type": "java.lang.Long",
      "meta": false
    },
    {
      "name": "center",
      "column": "Center",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "extent",
      "column": "Extent",
      "type": "java.lang.String",
      "meta": false
    },
    {
      "name": "points",
      "column": "Points",
      "type": "java.lang.String",
      "meta": false
    }
  ],
  "width": 3,
  "height": 4,
  "rows": [
    [
      "3",
      "POINT(-13.15818 8.47567)",
      "BOX(-13.26821 8.4St7215,-13.08711 8.47807)",
      ""
    ],
    [
      "9",
      "POINT(-13.11184 8.66424)",
      "BOX(-13.24982 8.51961,-13.05816 8.87696)",
      ""
    ],
    [
      "1",
      "POINT(-12.46144 7.50597)",
      "BOX(-12.46144 7.50597,-12.46144 7.50597)",
      ""
    ],
    [
      "7",
      "POINT(-12.47964 8.21533)",
      "BOX(-12.91769 7.66775,-12.21011 8.49713)",
      ""
    ]
  ]
}
```

### Event count and extent analytics

<!--DHIS2-SECTION-ID:webapi_event_count_extent_analytics-->

The *analytics/events/count* resource is suitable for geometry-related
requests for retrieving the count and extent (bounding box) of events
for a specific query. The query syntax is equal to the *events/query*
resource. A request looks like
    this:

    /api/33/analytics/events/count/eBAyeGv0exc?startDate=2016-01-01
      &endDate=2016-10-31&dimension=ou:O6uvpzGd5pu

The response will provide the count and extent in JSON format:

```json
{
  extent: "BOX(-13.2682125910096 7.38679562779441,-10.4261178860988 9.90401290212795)",
  count: 59
}
```

### Constraints and validation

<!--DHIS2-SECTION-ID:webapi_event_analytics_constraints-->

There are several constraints to the input parameters you can provide to the
event analytics resource. If any of the constraints are violated, the API will
return a *409 Conflict* response and a response message looking similar to this:

```json
{
  "httpStatus": "Conflict",
  "httpStatusCode": 409,
  "status": "ERROR",
  "message": "At least one organisation unit must be specified",
  "errorCode": "E7200"
}
```

The possible validation errors for the event analytics API are described 
in the table below.

| Error code | Message |
| ---------- | ------- |
| E7200      | At least one organisation unit must be specified |
| E7201      | Dimensions cannot be specified more than once |
| E7202      | Query items cannot be specified more than once |
| E7203      | Value dimension cannot also be specified as an item or item filter |
| E7204      | Value dimension or aggregate data must be specified when aggregation type is specified |
| E7205      | Start and end date or at least one period must be specified |
| E7206      | Start date is after end date |
| E7207      | Page number must be a positive number |
| E7208      | Page size must be zero or a positive number |
| E7209      | Limit is larger than max limit |
| E7210      | Time field is invalid |
| E7211      | Org unit field is invalid |
| E7212      | Cluster size must be a positive number |
| E7213      | Bbox is invalid, must be on format: 'min-lng,min-lat,max-lng,max-lat' |
| E7214      | Cluster field must be specified when bbox or cluster size are specified |
| E7215      | Query item cannot specify both legend set and option set |
| E7216      | Query item must be aggregateable when used in aggregate query |
| E7217      | User is not allowed to view event analytics data |
| E7218      | Spatial database support is not enabled |
| E7219      | Data element must be of value type coordinate in order to be used as coordinate field |
| E7220      | Attribute must be of value type coordinate to in order to be used as coordinate field |
| E7221      | Coordinate field is invalid |
| E7222      | Query item or filter is invalid |
| E7223      | Value does not refer to a data element or attribute which are numeric and part of the program |
| E7224      | Item identifier does not reference any data element, attribute or indicator part of the program |
| E7225      | Program stage is mandatory for data element dimensions in enrollment analytics queries |
| E7226      | Dimension is not a valid query item |
| E7227      | Relationship entity type not supported |

## Enrollment analytics

<!--DHIS2-SECTION-ID:webapi_enrollment_analytics-->

The enrollment analytics API lets you access aggregated event data and query *enrollments with their event data* captured in DHIS2. This resource lets you retrieve data for a program based on program stages and data elements - in addition to tracked entity attributes. When querying event data for a specific programstages within each enrollment, the data element values for each program stage will be returned as one row in the response from the api. If querying a data element in a program stage that is repeatable, the newest data element value will be used for that data element in the api response.

### Dimensions and items

<!--DHIS2-SECTION-ID:webapi_enrollment_analytics_dimensions-->

Enrollment dimensions include data elements, attributes, organisation units and periods. The query analytics resource will simply return enrollments matching a set of criteria and does not perform any aggregation.

<table>
<caption>Enrollment dimensions</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 11%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr class="header">
<th>Dimension</th>
<th>Dimension id</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>Data elements in program stages</td>
<td>&lt;program stage id&gt;.&lt;data element id&gt;</td>
<td>Data element identifiers must include the program stage when querying data for enrollments.

    dimension=edqlbukwRfQ.vANAXwtLwcT

</td>
</tr>
<tr>
<td>Attributes</td>
<td>&lt;id&gt;</td>
<td>Attribute identifiers</td>
</tr>
<tr>
<td>Periods</td>
<td>pe</td>
<td>ISO periods and relative periods, see &quot;date and period format&quot;</td>
</tr>
<tr>
<td>Organisation units</td>
<td>ou</td>
<td>Organisation unit identifiers and keywords USER_ORGUNIT, USER_ORGUNIT_CHILDREN, USER_ORGUNIT_GRANDCHILDREN, LEVEL-&lt;level&gt; and OU_GROUP-&lt;group-id&gt;</td>
</tr>
</tbody>
</table>

### Enrollment query analytics

<!--DHIS2-SECTION-ID:webapi_enrollment_query_analytics-->

The *analytics/enrollments/query* resource lets you query for captured enrollments. This resource does not perform any aggregation, rather it lets you query and filter for information about enrollments.

    /api/33/analytics/enrollments/query

You can specify any number of dimensions and any number of filters in a query. Dimension item identifiers can refer to any of the data elements in program stages, tracked entity attributes, fixed and relative periods and organisation units. Dimensions can optionally have a query operator and a filter. Enrollment queries should be on the format described below.

    /api/33/analytics/enrollments/query/<program-id>?startDate=yyyy-MM-dd&endDate=yyyy-MM-dd
      &dimension=ou:<ou-id>;<ou-id>&dimension=<item-id>&dimension=<item-id>:<operator>:<filter>

For example, to retrieve enrollments in the from the "Antenatal care" program from January 2019, where the "First name" is picked up from attributes, "Chronic conditions" and "Smoking" data elements are included from the first program stage, and "Hemoglobin value" from the following program stage, and only women that have "Cronic conditions" would be included, you can use the following query:

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.json?dimension=ou:ImspTQPwCqd
      &dimension=w75KJ2mc4zz&dimension=WZbXY0S00lP.de0FEHSIoxh:eq:1&dimension=w75KJ2mc4zz
      &dimension=WZbXY0S00lP.sWoqcoByYmD&dimension=edqlbukwRfQ.vANAXwtLwcT
      &startDate=2019-01-01&endDate=2019-01-31

To retrieve enrollments in the from the "Antenatal care" program from last month (relative to the point in time the query is executed), where the "Chronic conditions" and "Smoking" data elements are included from the first program stage, and "Hemoglobin value" from the followup program stage, only including smoking women with hemoglobin less than 20:

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.json?dimension=ou:ImspTQPwCqd
      &dimension=WZbXY0S00lP.de0FEHSIoxh&dimension=w75KJ2mc4zz
      &dimension=WZbXY0S00lP.sWoqcoByYmD:eq:1&dimension=edqlbukwRfQ.vANAXwtLwcT:lt:20
      &dimension=pe:LAST_MONTH

Sorting can be applied to the query for the enrollment and incident dates of the enrollment:

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.xls?dimension=ou:ImspTQPwCqd
      &columns=w75KJ2mc4zz&dimension=WZbXY0S00lP.sWoqcoByYmD&dimension=pe:LAST_MONTH
      &stage=WZbXY0S00lP&pageSize=10&page=1&asc=ENROLLMENTDATE&ouMode=DESCENDANTS

Paging can be applied to the query by specifying the page number and the page size parameters. If page number is specified but page size is not, a page size of 50 will be used. If page size is specified but page number is not, a page number of 1 will be used. To get the second page of the response with a page size of 10 you can use a query like this:

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.json?dimension=ou:ImspTQPwCqd
      &dimension=WZbXY0S00lP.de0FEHSIoxh&dimension=w75KJ2mc4zz&dimension=pe:LAST_MONTH
      &dimension=WZbXY0S00lP.sWoqcoByYmD&pageSize=10&page=2

#### Filtering

Filters can be applied to data elements, person attributes and person identifiers. The filtering is done through the query parameter value on the following format:

    &dimension=<item-id>:<operator>:<filter-value>

As an example, you can filter the "Weight" data element for values greater than 2000 and lower than 4000 like this:

    &dimension=WZbXY0S00lP.UXz7xuGCEhU:GT:2000&dimension=WZbXY0S00lP.UXz7xuGCEhU:LT:4000

You can filter the "Age" attribute for multiple, specific ages using the IN operator like this:

    &dimension=qrur9Dvnyt5:IN:18;19;20

You can specify multiple filters for a given item by repeating the operator and filter components, all separated with semi-colons:

    &dimension=qrur9Dvnyt5:GT:5:LT:15

The available operators are listed below.

<table>
<caption>Filter operators</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr class="header">
<th>Operator</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>EQ</td>
<td>Equal to</td>
</tr>
<tr>
<td>GT</td>
<td>Greater than</td>
</tr>
<tr>
<td>GE</td>
<td>Greater than or equal to</td>
</tr>
<tr>
<td>LT</td>
<td>Less than</td>
</tr>
<tr>
<td>LE</td>
<td>Less than or equal to</td>
</tr>
<tr>
<td>NE</td>
<td>Not equal to</td>
</tr>
<tr>
<td>LIKE</td>
<td>Like (free text match)</td>
</tr>
<tr>
<td>IN</td>
<td>Equal to one of multiple values separated by &quot;;&quot;</td>
</tr>
</tbody>
</table>

### Request query parameters

<!--DHIS2-SECTION-ID:webapi_enrollment_analytics_query_parameters-->

The analytics enrollment query API lets you specify a range of query parameters.

<table>
<caption>Query parameters for enrollment query endpoint</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 11%" />
<col style="width: 48%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options (default first)</th>
</tr>
</thead>
<tbody>
<tr>
<td>program</td>
<td>Yes</td>
<td>Program identifier.</td>
<td>Any program identifier</td>
</tr>
<tr>
<td>startDate</td>
<td>No</td>
<td>Start date for enrollments.</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr>
<td>endDate</td>
<td>No</td>
<td>End date for enrollments.</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr>
<td>dimension</td>
<td>Yes</td>
<td>Dimension identifier including data elements, attributes, program indicators, periods, organisation units and organisation unit group sets. Parameter can be repeated any number of times. Item filters can be applied to a dimension on the format &lt;item-id&gt;:&lt;operator&gt;:&lt;filter&gt;. Filter values are case-insensitive.</td>
<td>Operators can be EQ | GT | GE | LT | LE | NE | LIKE | IN</td>
</tr>
<tr>
<td>filter</td>
<td>No</td>
<td>Dimension identifier including data elements, attributes, periods, organisation units and organisation unit group sets. Parameter can be repeated any number of times. Item filters can be applied to a dimension on the format &lt;item-id&gt;:&lt;operator&gt;:&lt;filter&gt;. Filter values are case-insensitive.</td>
<td></td>
</tr>
<tr>
<td>programStatus</td>
<td>No</td>
<td>Specify enrollment status of enrollments to include.</td>
<td>ACTIVE | COMPLETED | CANCELLED</td>
</tr>
<tr>
<td>relativePeriodDate</td>
<td>string</td>
<td>No</td>
<td>Date identifier e.g: &quot;2016-01-01&quot;. Overrides the start date of the relative period</td>
</tr>
<tr>
<td>ouMode</td>
<td>No</td>
<td>The mode of selecting organisation units. Default is DESCENDANTS, meaning all sub units in the hierarchy. CHILDREN refers to immediate children in the hierarchy; SELECTED refers to the selected organisation units only.</td>
<td>DESCENDANTS, CHILDREN, SELECTED</td>
</tr>
<tr>
<td>asc</td>
<td>No</td>
<td>Dimensions to be sorted ascending, can reference enrollment date, incident date, org unit name and code.</td>
<td> ENROLLMENTDATE | INCIDENTDATE| OUNAME | OUCODE </td>
</tr>
<tr>
<td>desc</td>
<td>No</td>
<td>Dimensions to be sorted descending, can reference enrollment date, incident date, org unit name and code.</td>
<td> ENROLLMENTDATE | INCIDENTDATE| OUNAME | OUCODE </td>
</tr>
<td>hierarchyMeta</td>
<td>No</td>
<td>Include names of organisation unit ancestors and hierarchy paths of organisation units in the metadata.</td>
<td>false | true</td>
</tr>
<tr>
<td>coordinatesOnly</td>
<td>No</td>
<td>Whether to only return enrollments which have coordinates.</td>
<td>false | true</td>
</tr>
<tr>
<td>page</td>
<td>No</td>
<td>The page number. Default page is 1.</td>
<td>Numeric positive value</td>
</tr>
<tr>
<td>pageSize</td>
<td>No</td>
<td>The page size. Default size is 50 items per page.</td>
<td>Numeric zero or positive value</td>
</tr>
</tbody>
</table>

#### Response formats

The default response representation format is JSON. The requests must be using the HTTP *GET* method. The following response formats are supported.

  - json (application/json)
  - xml (application/xml)
  - xls (application/vnd.ms-excel)
  - csv  (application/csv)
  - html (text/html)
  - html+css (text/html)

As an example, to get a response in Excel format you can use a file extension in the request URL like this:

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.xls?dimension=ou:ImspTQPwCqd
      &dimension=WZbXY0S00lP.de0FEHSIoxh&columns=w75KJ2mc4zz
      &dimension=WZbXY0S00lP.sWoqcoByYmD&dimension=pe:LAST_MONTH&stage=WZbXY0S00lP
      &pageSize=10&page=1&asc=ENROLLMENTDATE&ouMode=DESCENDANTS

The default response JSON format will look similar to this:

```json
{
  "headers": [
    {
      "name": "pi",
      "column": "Enrollment",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "tei",
      "column": "Tracked entity instance",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "enrollmentdate",
      "column": "Enrollment date",
      "valueType": "DATE",
      "type": "java.util.Date",
      "hidden": false,
      "meta": true
    },
    {
      "name": "incidentdate",
      "column": "Incident date",
      "valueType": "DATE",
      "type": "java.util.Date",
      "hidden": false,
      "meta": true
    },
    {
      "name": "geometry",
      "column": "Geometry",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "longitude",
      "column": "Longitude",
      "valueType": "NUMBER",
      "type": "java.lang.Double",
      "hidden": false,
      "meta": true
    },
    {
      "name": "latitude",
      "column": "Latitude",
      "valueType": "NUMBER",
      "type": "java.lang.Double",
      "hidden": false,
      "meta": true
    },
    {
      "name": "ouname",
      "column": "Organisation unit name",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "oucode",
      "column": "Organisation unit code",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "ou",
      "column": "Organisation unit",
      "valueType": "TEXT",
      "type": "java.lang.String",
      "hidden": false,
      "meta": true
    },
    {
      "name": "de0FEHSIoxh",
      "column": "WHOMCH Chronic conditions",
      "valueType": "BOOLEAN",
      "type": "java.lang.Boolean",
      "hidden": false,
      "meta": true
    },
    {
      "name": "sWoqcoByYmD",
      "column": "WHOMCH Smoking",
      "valueType": "BOOLEAN",
      "type": "java.lang.Boolean",
      "hidden": false,
      "meta": true
    }
  ],
  "metaData": {
    "pager": {
      "page": 2,
      "total": 163,
      "pageSize": 4,
      "pageCount": 41
    },
    "items": {
      "ImspTQPwCqd": {
        "name": "Sierra Leone"
      },
      "PFDfvmGpsR3": {
        "name": "Care at birth"
      },
      "bbKtnxRZKEP": {
        "name": "Postpartum care visit"
      },
      "ou": {
        "name": "Organisation unit"
      },
      "PUZaKR0Jh2k": {
        "name": "Previous deliveries"
      },
      "edqlbukwRfQ": {
        "name": "Antenatal care visit"
      },
      "WZbXY0S00lP": {
        "name": "First antenatal care visit"
      },
      "sWoqcoByYmD": {
        "name": "WHOMCH Smoking"
      },
      "WSGAb5XwJ3Y": {
        "name": "WHO RMNCH Tracker"
      },
      "de0FEHSIoxh": {
        "name": "WHOMCH Chronic conditions"
      }
    },
    "dimensions": {
      "pe": [],
      "ou": [
        "ImspTQPwCqd"
      ],
      "sWoqcoByYmD": [],
      "de0FEHSIoxh": []
    }
  },
  "width": 12,
  "rows": [
    [
      "A0cP533hIQv",
      "to8G9jAprnx",
      "2019-02-02 12:05:00.0",
      "2019-02-02 12:05:00.0",
      "",
      "0.0",
      "0.0",
      "Tonkomba MCHP",
      "OU_193264",
      "xIMxph4NMP1",
      "0",
      "1"
    ],
    [
      "ZqiUn2uXmBi",
      "SJtv0WzoYki",
      "2019-02-02 12:05:00.0",
      "2019-02-02 12:05:00.0",
      "",
      "0.0",
      "0.0",
      "Mawoma MCHP",
      "OU_254973",
      "Srnpwq8jKbp",
      "0",
      "0"
    ],
    [
      "lE747mUAtbz",
      "PGzTv2A1xzn",
      "2019-02-02 12:05:00.0",
      "2019-02-02 12:05:00.0",
      "",
      "0.0",
      "0.0",
      "Kunsho CHP",
      "OU_193254",
      "tdhB1JXYBx2",
      "",
      "0"
    ],
    [
      "nmcqu9QF8ow",
      "pav3tGLjYuq",
      "2019-02-03 12:05:00.0",
      "2019-02-03 12:05:00.0",
      "",
      "0.0",
      "0.0",
      "Korbu MCHP",
      "OU_678893",
      "m73lWmo5BDG",
      "",
      "1"
    ]
  ],
  "height": 4
}
```

The *headers* section of the response describes the content of the query result. The enrollment unique identifier, the tracked entity instance identifier, the enrollment date, the incident date, geometry, latitude, longitude, the organisation unit name and the organisation unit code appear as the first dimensions in the response and will always be present. Next comes the data elements, and tracked entity attributes which were specified as dimensions in the request, in this case, the "WHOMCH Chronic conditions" and "WHOMCH smoking" data element dimensions. The header section contains the identifier of the dimension item in the "name" property and a readable dimension description in the "column" property.

The *metaData* section, *ou* object contains the identifiers of all organisation units present in the response mapped to a string representing the hierarchy. This hierarchy string lists the identifiers of the ancestors (parents) of the organisation unit starting from the root. The *names* object contains the identifiers of all items in the response mapped to their names.

The *rows* section contains the enrollments produced by the query. Each row represents exactly one enrollment.

### Support of analytics across tracked entity instance relationships with program indicators

The non-aggregation enrollment analytics API also supports linking Program Indicators to Relationship Types, in order to show the result of a calculation of a specific Program Indicator applied to the related entities of the listed Tracked Entity Instance.

![](resources/images/enrollments/enrollments-pi-relationship.jpg)

For the Program Indicator/Relationship Type link to work, the `/api/33/analytics/enrollments/query` API requires an additional dimension which must include the chosen Relationship Type UID and the chosen Program Indicator UID:

    /api/33/analytics/enrollments/query/<program-id>
      ?dimension=<relationshiptype-id>.<programindicator-id>

For example, to retrieve a list of enrollments from the "WHO RMNCH Tracker" program for January 2019 and display the count of Malaria Cases linked to that Enrollment by "Malaria case linked to person" type of relationship, you can use the following query

    /api/33/analytics/enrollments/query/WSGAb5XwJ3Y.json?dimension=mxZDvSZYxlw.nFICjJluo74
      &startDate=2019-01-01&endDate=2019-01-31    

The API supports using program indicators which are not associated to the "main" program (that is the program ID specified after `/query/`).

## Org unit analytics

<!--DHIS2-SECTION-ID:webapi_org_unit_analytics-->

The org unit analytics API provides statistics on org units classified by org unit group sets, i.e. counts of org units per org unit group within org unit group sets.

    GET /api/orgUnitAnalytics?ou=<org-unit-id>&ougs=<org-unit-group-set-id>

The API requires at least one organisation unit and at least one organisation unit group set. Multiple org units and group sets can be provided separated by a semicolon.

### Request query parameters

The org unit analytics resource lets you specify a range of query parameters:

<table>
<caption>Org unit analytics query parameters</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 60%" />
<col style="width: 20%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
<th>Required</th>
</tr>
</thead>
<tbody>
<tr>
<td>ou</td>
<td>Org unit identifiers, potentially separated by a semicolon.</td>
<td>Yes</td>
</tr>
<tr>
<td>ougs</td>
<td>Org unit group set identifiers, potentially separated by a semicolon.</td>
<td>Yes</td>
</tr>
<tr>
<td>columns</td>
<td>Org unit group set identifiers, potentially separated by a semicolon. Defines which group sets are rendered as columns in a table layout.</td>
<td>No</td>
</tr>
</tbody>
</table>

The response will contain a column for the parent org unit, columns for each org unit group set part of the request and a column for the count. The statistics include the count of org units which are part of the sub-hierarchy of the org units specified in the request. The response contains a metadata section which specifies the name of each org unit and org unit group part of the response referenced by their identifiers.

The default response is normalized with a single `count` column. The response can be rendered in a table layout by specifying at least one org unit group set using the `columns` query parameter.

### Response formats

The org unit analytics endpoint supports the following representation formats:

- json (application/json)
- csv (application/csv)
- xls (application/vnd.ms-excel)
- pdf (application/pdf)

### Examples

To fetch org unit analytics for an org unit and org unit group set:

    GET /api/orgUnitAnalytics?ou=lc3eMKXaEfw&ougs=J5jldMd8OHv

To fetch org unit analytics data for two org units and two org unit group sets:

    GET /api/orgUnitAnalytics?ou=lc3eMKXaEfw;PMa2VCrupOd&ougs=J5jldMd8OHv;Bpx0589u8y0

To fetch org unit analytics data in table mode with one group set rendered as columns:

    GET /api/orgUnitAnalytics?ou=fdc6uOvgoji;jUb8gELQApl;lc3eMKXaEfw;PMa2VCrupOd
      &ougs=J5jldMd8OHv&columns=J5jldMd8OHv

### Constraints and validation

The possible validation errors specifically for the org unit analytics API are described in the table below. Some errors specified for the aggregate analytics API are also relevant.

| Error code | Message |
| ---------- | ------- |
| E7300      | At least one organisation unit must be specified |
| E7301      | At least one organisation unit group set must be specified |

## Data set report

<!--DHIS2-SECTION-ID:webapi_data_set_report-->

Data set reports can be generated through the web api using the
`/dataSetReport` resource. This resource generates reports on data set
and returns the result in the form of an HTML table.

    /api/33/dataSetReport

### Request query parameters

The request supports the following parameters:

<table>
<caption>Data set report query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 50%" />
<col style="width: 17%" />
<col style="width: 17%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Description</th>
<th>Type</th>
<th>Required</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ds</td>
<td>Data set to create the report from.</td>
<td>Data set UID</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>pe</td>
<td>Period to create the report from.</td>
<td>ISO String</td>
<td>Yes</td>
</tr>
<tr class="odd">
<td>ou</td>
<td>Organisation unit to create the report from.</td>
<td>Organisation unit UID</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>filter</td>
<td>Filters to be used as filters for the report. Can be repeated any number of times. Follows the analytics API syntax.</td>
<td>One or more UIDs</td>
<td>No</td>
</tr>
<tr class="odd">
<td>selectedUnitOnly</td>
<td>Whether to use captured data only or aggregated data.</td>
<td>Boolean</td>
<td>No</td>
</tr>
</tbody>
</table>

The data set report resource accepts `GET` requests only. The response content type is `application/json` and returns data in a grid. This endpoint works for all types of data sets, including default, section and custom forms.

An example request to retrieve a report for a data set and org unit for 2018 looks like this:

    GET /api/33/dataSetReport?ds=BfMAe6Itzgt&pe=201810&ou=ImspTQPwCqd&selectedUnitOnly=false

To get a data set report with a filter you can use the `filter` parameter. In this case, the filter is based on an org unit group set and two org unit groups:

    GET /api/33/dataSetReport?ds=BfMAe6Itzgt&pe=201810&ou=ImspTQPwCqd
      &filter=J5jldMd8OHv:RXL3lPSK8oG;tDZVQ1WtwpA

### Response formats

The data set report endpoint supports output in the following formats. You can retrieve a specific endpoint using the file extension or `Accept` HTTP header.

- json (application/json)
- pdf (application/pdf)
- xls (application/vnd.ms-excel)

### Custom forms

A dedicated endpoint is available for data sets with custom HTML forms. This endpoint returns the HTML form content with content type `text/html` with data inserted into it. Note that you can use the general data set report endpoint also for data sets with custom forms; however, that will return the report in JSON format as a grid. This endpoint only works for data sets with custom HTML forms.

    GET /api/33/dataSetReport/custom

The syntax for this endpoint is otherwise equal to the general data set report endpoint. To retrieve a custom HTML data set report you can issue a request like this:

    GET /api/33/dataSetReport/custom?ds=lyLU2wR22tC&pe=201810&ou=ImspTQPwCqd


## Push Analysis

<!--DHIS2-SECTION-ID:webapi_push_analysis-->

The push analysis API includes endpoints for previewing a push analysis
report for the logged in user and manually triggering the system to
generate and send push analysis reports, in addition to the normal CRUD
operations. When using the create and update endpoints for push
analysis, the push analysis will be scheduled to run based on the
properties of the push analysis. When deleting or updating a
push analysis to be disabled, the job will also be stopped from running
in the future.

To get an HTML preview of an existing push analysis, you can do a GET
request to the following endpoint:

    /api/33/pushAnalysis/<id>/render

To manually trigger a push analysis job, you can do a POST request to
this endpoint:

    /api/33/pushAnalysis/<id>/run

A push analysis consists of the following properties, where some are
required to automatically run push analysis jobs:

<table>
<caption>Push analysis properties</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
<th>Type</th>
<th>Required</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dashboard</td>
<td>Dashboard on which reports are based</td>
<td>Dashboard UID</td>
<td>Yes</td>
</tr>
<tr class="even">
<td>message</td>
<td>Appears after title in reports</td>
<td>String</td>
<td>No</td>
</tr>
<tr class="odd">
<td>recipientUserGroups</td>
<td>A set of user groups who should receive the reports</td>
<td>One or more user Group UID</td>
<td>No. Scheduled jobs without any recipient will be skipped.</td>
</tr>
<tr class="even">
<td>enabled</td>
<td>Indicated whether this push analysis should be scheduled or not. False by default.</td>
<td>Boolean</td>
<td>Yes. Must be true to be scheduled.</td>
</tr>
<tr class="odd">
<td>schedulingFrequency</td>
<td>The frequency of which reports should be scheduled.</td>
<td>&quot;DAILY&quot;, &quot;WEEKLY&quot;, &quot;MONTHLY&quot;</td>
<td>No. Push analysis without a frequency will not be scheduled</td>
</tr>
<tr class="even">
<td>schedulingDayOfFrequency</td>
<td>The day in the frequency the job should be scheduled.</td>
<td>Integer. Any value when frequency is &quot;DAILY&quot;. 0-7 when frequency is &quot;WEEKLY&quot;. 1-31 when frequency is &quot;MONTHLY&quot;</td>
<td>No. Push analysis without a valid day of frequency for the frequency set will not be scheduled.</td>
</tr>
</tbody>
</table>

## Data usage analytics

<!--DHIS2-SECTION-ID:webapi_usage_analytics-->

The usage analytics API lets you access information about how people are
using DHIS2 based on data analysis. When users access favorites, an
event is recorded. The event consists of the user name, the UID of the
favorite, when the event took place, and the type of event. The
different types of events are listed in the table.

    /api/33/dataStatistics

The usage analytics API lets you retrieve aggregated snapshots of usage
analytics based on time intervals. The API captures user views (for
example the number of times a chart or pivot table has been viewed by a
user) and saved analysis favorites (for example favorite charts and
pivot tables). DHIS2 will capture nightly snapshots which are then
aggregated at request.

### Request query parameters

<!--DHIS2-SECTION-ID:webapi_usage_analytics_request_query_parameters-->

The usage analytics (data statistics) API supports two operations:

  - *POST:* creates a view event

  - *GET:* retrieves aggregated statistics

### Create view events (POST)

<!--DHIS2-SECTION-ID:webapi_usage_analytics_create_view_events-->

The usage analytics API lets you create event views. The
dataStatisticsEventType parameter describes what type of item was
viewed. The favorite parameter indicates the identifier of the relevant
favorite.

URL that creates a new event view of
    charts:

    POST /api/33/dataStatistics?eventType=CHART_VIEW&favorite=LW0O27b7TdD

A successful save operation returns an HTTP status code 201. The table
below shows the supported types of events.

<table>
<caption>Supported event types</caption>
<colgroup>
<col style="width: 38%" />
<col style="width: 61%" />
</colgroup>
<thead>
<tr class="header">
<th>Key</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>REPORT_TABLE_VIEW</td>
<td>Report table (pivot table) view</td>
</tr>
<tr class="even">
<td>CHART_VIEW</td>
<td>Chart view</td>
</tr>
<tr class="odd">
<td>MAP_VIEW</td>
<td>Map view (GIS)</td>
</tr>
<tr class="even">
<td>EVENT_REPORT_VIEW</td>
<td>Event report view</td>
</tr>
<tr class="odd">
<td>EVENT_CHART_VIEW</td>
<td>Event chart view</td>
</tr>
<tr class="even">
<td>DASHBOARD_VIEW</td>
<td>Dashboard view</td>
</tr>
<tr class="odd">
<td>DATA_SET_REPORT_VIEW</td>
<td>Data set report view</td>
</tr>
</tbody>
</table>

### Retrieve aggregated usage analytics report (GET)

<!--DHIS2-SECTION-ID:webapi_aggregated_usage_analytics-->

The usage analytics (data statistics) API lets you specify certain query
parameters when asking for an aggregated report.

<table>
<caption>Query parameters for aggregated usage analytics (data statistics)</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>startDate</td>
<td>Yes</td>
<td>Start date for period</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>Yes</td>
<td>End date for period</td>
<td>Date in yyyy-MM-dd format</td>
</tr>
<tr class="odd">
<td>interval</td>
<td>Yes</td>
<td>Type of interval to be aggregated</td>
<td>DAY, WEEK, MONTH, YEAR</td>
</tr>
</tbody>
</table>

The startDate and endDate parameters specify the period for which
snapshots are to be used in the aggregation. You must format the dates
as shown above. If no snapshots are saved in the specified period, an
empty list is sent back. The parameter called interval specifies what
type of aggregation will be done.

API query that creates a query for a monthly
    aggregation:

    GET /api/33/dataStatistics?startDate=2014-01-02&endDate=2016-01-01&interval=MONTH

### Retrieve top favorites

<!--DHIS2-SECTION-ID:webapi_usage_analytics_top_favorites-->

The usage analytics API lets you retrieve the top favorites used in
DHIS2, and by user.

<table>
<caption>Query parameters for top favorites</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
<th>Options</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>eventType</td>
<td>Yes</td>
<td>The data statistics event type</td>
<td>See above table</td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>No</td>
<td>Size of the list returned</td>
<td>For example 5, 10, 25. Default is 25</td>
</tr>
<tr class="odd">
<td>sortOrder</td>
<td>No</td>
<td>Descending or ascending</td>
<td>ASC or DESC. Default is DESC.</td>
</tr>
<tr class="even">
<td>username</td>
<td>No</td>
<td>If specified, the response will only contain favorites by this user.</td>
<td>For example 'admin'</td>
</tr>
</tbody>
</table>

The API query can be used without a username, and will then find the top
favorites of the system.

    /api/33/dataStatistics/favorites?eventType=CHART_VIEW&pageSize=25&sortOrder=ASC

If the username is specified, the response will only contain the top favorites of that user.

    /api/33/dataStatistics/favorites?eventType=CHART_VIEW&pageSize=25&sortOrder=ASC&username=admin

### Response format

<!--DHIS2-SECTION-ID:webapi_usage_analytics_response_format-->

You can return the aggregated data in a usage analytics response in
several representation formats. The default format is JSON. The
available formats and content types are:

  - json (application/json)

  - xml (application/xml)

  - html (text/html)

API query that requests a usage analytics response in XML
    format:

    /api/33/dataStatistics.xml?startDate=2014-01-01&endDate=2016-01-01&interval=WEEK

You must retrieve the aggregated usage analytics response with the HTTP
GET method. This allows you to link directly from Web pages and other
HTTP-enabled clients to usage analytics responses. To do functional
testing use the cURL library.

Execute this command against the demo database to get an usage analytics
response in JSON format:

```bash
curl "play.dhis2.org/demo/api/33/dataStatistics?startDate=2016-02-01&endDate=2016-02-14
  &interval=WEEK" -u admin:district
```

The JSON response looks like this:

```json
[
  {
    "year": 2016,
    "week": 5,
    "mapViews": 2181,
    "chartViews": 2227,
    "reportTableViews": 5633,
    "eventReportViews": 6757,
    "eventChartViews": 9860,
    "dashboardViews": 10082,
    "totalViews": 46346,
    "averageViews": 468,
    "averageMapViews": 22,
    "averageChartViews": 22,
    "averageReportTableViews": 56,
    "averageEventReportViews": 68,
    "averageEventChartViews": 99,
    "averageDashboardViews": 101,
    "savedMaps": 1805,
    "savedCharts": 2205,
    "savedReportTables": 1995,
    "savedEventReports": 1679,
    "savedEventCharts": 1613,
    "savedDashboards": 0,
    "savedIndicators": 1831,
    "activeUsers": 99,
    "users": 969
  },
  {
    "year": 2016,
    "week": 6,
    "mapViews": 2018,
    "chartViews": 2267,
    "reportTableViews": 4714,
    "eventReportViews": 6697,
    "eventChartViews": 9511,
    "dashboardViews": 12181,
    "totalViews": 47746,
    "averageViews": 497,
    "averageMapViews": 21,
    "averageChartViews": 23,
    "averageReportTableViews": 49,
    "averageEventReportViews": 69,
    "averageEventChartViews": 99,
    "averageDashboardViews": 126,
    "savedMaps": 1643,
    "savedCharts": 1935,
    "savedReportTables": 1867,
    "savedEventReports": 1977,
    "savedEventCharts": 1714,
    "savedDashboards": 0,
    "savedIndicators": 1646,
    "activeUsers": 96,
    "users": 953
  }
]
```

### Retrieve statistics for a favorite

<!--DHIS2-SECTION-ID:webapi_usage_analytics_retrieve_favorite_statistics-->

You can retrieve the number of view for a specific favorite by using the
*favorites* resource, where *{favorite-id}* should be substituted with
the identifier of the favorite of interest:

    /api/33/dataStatistics/favorites/{favorite-id}.json

The response will contain the number of views for the given favorite and
look like this:

```json
{
  "views": 3
}
```

## Geospatial features

<!--DHIS2-SECTION-ID:webapi_geospatial_features-->

The *geoFeatures* resource lets you retrieve geospatial information from
DHIS2. Geospatial features are stored together with organisation units.
The syntax for retrieving features is identical to the syntax used for
the organisation unit dimension for the analytics resource. It is
recommended to read up on the analytics api resource before continuing
to read this section. You must use the GET request type, and only JSON
response format is supported.

As an example, to retrieve geo features for all organisation units at
level 3 in the organisation unit hierarchy you can use a GET request
with the following URL:

    /api/33/geoFeatures.json?ou=ou:LEVEL-3

To retrieve geo features for organisation units at a level within the
boundary of an organisation unit (e.g. at level 2) you can use this URL:

    /api/33/geoFeatures.json?ou=ou:LEVEL-4;O6uvpzGd5pu

The semantics of the response properties are described in the following
table.

<table>
<caption>Geo features response</caption>
<colgroup>
<col style="width: 14%" />
<col style="width: 85%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>id</td>
<td>Organisation unit / geo feature identifier</td>
</tr>
<tr class="even">
<td>na</td>
<td>Organisation unit / geo feature name</td>
</tr>
<tr class="odd">
<td>hcd</td>
<td>Has coordinates down, indicating whether one or more children organisation units exist with coordinates (below in the hierarchy)</td>
</tr>
<tr class="even">
<td>hcu</td>
<td>Has coordinates up, indicating whether the parent organisation unit has coordinates (above in the hierarchy)</td>
</tr>
<tr class="odd">
<td>le</td>
<td>Level of this organisation unit / geo feature.</td>
</tr>
<tr class="even">
<td>pg</td>
<td>Parent graph, the graph of parent organisation unit identifiers up to the root in the hierarchy</td>
</tr>
<tr class="odd">
<td>pi</td>
<td>Parent identifier, the identifier of the parent of this organisation unit</td>
</tr>
<tr class="even">
<td>pn</td>
<td>Parent name, the name of the parent of this organisation unit</td>
</tr>
<tr class="odd">
<td>ty</td>
<td>Geo feature type, 1 = point and 2 = polygon or multi-polygon</td>
</tr>
<tr class="even">
<td>co</td>
<td>Coordinates of this geo feature</td>
</tr>
</tbody>
</table>

### GeoJSON

To export GeoJSON, you can simply add *.geosjon* as an extension to the
endpoint */api/organisationUnits*, or you can use the *Accept* header
*application/json+geojson*.

Two parameters are supported: `level` (defaults to 1) and `parent`
(defaults to root organisation units). Both can be included multiple times. 
Some examples follow.

Get all features at level 2 and 4:

    /api/organisationUnits.geojson?level=2&level=4

Get all features at level 3 with a boundary organisation unit:

    /api/organisationUnits.geojson?parent=fdc6uOvgoji&level=3

## Generating resource and analytics tables

<!--DHIS2-SECTION-ID:webapi_generating_resource_analytics_tables-->

DHIS2 features a set of generated database tables which are used as
a basis for various system functionality. These tables can be executed
immediately or scheduled to be executed at regular intervals through the
user interface. They can also be generated through the Web API as
explained in this section. This task is typically one for a system
administrator and not consuming clients.

The resource tables are used internally by the DHIS2 application for
various analysis functions. These tables are also valuable for users
writing advanced SQL reports. They can be generated with a POST or PUT
request to the following URL:

    /api/33/resourceTables

The analytics tables are optimized for data aggregation and used
currently in DHIS2 for the pivot table module. The analytics tables can
be generated with a POST or PUT request to:

    /api/33/resourceTables/analytics

<table>
<caption>Analytics tables optional query parameters</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 14%" />
<col style="width: 52%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Options</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>skipResourceTables</td>
<td>false | true</td>
<td>Skip generation of resource tables</td>
</tr>
<tr class="even">
<td>skipAggregate</td>
<td>false | true</td>
<td>Skip generation of aggregate data and completeness data</td>
</tr>
<tr class="odd">
<td>skipEvents</td>
<td>false | true</td>
<td>Skip generation of event data</td>
</tr>
<tr class="even">
<td>skipEnrollment</td>
<td>false | true</td>
<td>Skip generation of enrollment data</td>
</tr>
<tr class="odd">
<td>lastYears</td>
<td>integer</td>
<td>Number of last years of data to include</td>
</tr>
</tbody>
</table>

"Data Quality" and "Data Surveillance" can be run through the monitoring
task, triggered with the following endpoint:

    /api/33/resourceTables/monitoring

This task will analyse your validation rules, find any violations and
persist them as validation results.

These requests will return immediately and initiate a server-side
process.

## Maintenance

<!--DHIS2-SECTION-ID:webapi_maintenance-->

To perform maintenance you can interact with the *maintenance* resource. You should use *POST* or *PUT* as a method for requests. The following methods are available.

Analytics tables clear will drop all analytics tables.

    POST PUT /api/maintenance/analyticsTablesClear

Analytics table analyze will collects statistics about the contents of analytics tables in the database.

    POST PUT /api/maintenance/analyticsTablesAnalyze

Expired invitations clear will remove all user account invitations which
have expired.

    POST PUT /api/maintenance/expiredInvitationsClear

Period pruning will remove periods which are not linked to any data
values.

    POST PUT /api/maintenance/periodPruning

Zero data value removal will delete zero data values linked to data
elements where zero data is defined as not significant:

    POST PUT /api/maintenance/zeroDataValueRemoval

Soft deleted data value removal will permanently delete soft deleted data values.

    POST PUT /api/maintenance/softDeletedDataValueRemoval

Soft deleted program stage instance removal will permanently delete soft deleted events.

    POST PUT /api/maintenance/softDeletedProgramStageInstanceRemoval

Soft deleted program instance removal will permanently delete soft deleted enrollments.

    POST PUT /api/maintenance/softDeletedProgramInstanceRemoval

Soft deleted tracked entity instance removal will permanently delete soft deleted tracked entity instances.

    POST PUT /api/maintenance/softDeletedTrackedEntityInstanceRemoval

Drop SQL views will drop all SQL views in the database. Note that it will not delete the DHIS2 SQL view entities.

    POST PUT /api/maintenance/sqlViewsDrop

Create SQL views will recreate all SQL views in the database.

    POST PUT /api/maintenance/sqlViewsCreate

Category option combo update will remove obsolete and generate missing category option combos for all category combinations.

    POST PUT /api/maintenance/categoryOptionComboUpdate

It is also possible to update category option combos for a single category combo using the following endpoint.

    POST PUT /api/maintenance/categoryOptionComboUpdate/categoryCombo/<category-combo-uid>

Cache clearing will clear the application Hibernate cache and the analytics partition caches.

    POST PUT /api/maintenance/cacheClear

Org unit paths update will re-generate the organisation unit path property. This can be useful e.g. if you imported org units with SQL.

    POST PUT /api/maintenance/ouPathsUpdate

Data pruning will remove complete data set registrations, data approvals, data value audits and data values, in this case for an organisation unit.

    POST PUT /api/maintenance/dataPruning/organisationUnits/<org-unit-id>

Data pruning for data elements, which will remove data value audits and data values.

    POST PUT /api/maintenance/dataPruning/dataElement/<data-element-uid>

Metadata validation will apply all metadata validation rules and return the result of the operation.

    POST PUT /api/metadataValidation

App reload will refresh the DHIS2 managed cache of installed apps by reading from the file system.

    POST PUT /api/appReload

Maintenance operations are supported in a batch style with a POST request to the api/maintenance resource where the operations are supplied as query parameters:

    POST PUT /api/maintenance?analyticsTablesClear=true&expiredInvitationsClear=true
      &periodPruning=true&zeroDataValueRemoval=true&sqlViewsDrop=true&sqlViewsCreate=true
      &categoryOptionComboUpdate=true&cacheClear=true&ouPathsUpdate=true

## System resource

<!--DHIS2-SECTION-ID:webapi_system_resource-->

The system resource provides you with convenient information and
functions. The system resource can be found at */api/system*.

### Generate identifiers

<!--DHIS2-SECTION-ID:webapi_system_resource_generate_identifiers-->

To generate valid, random DHIS2 identifiers you can do a GET request to
this resource:

    /api/33/system/id?limit=3

The *limit* query parameter is optional and indicates how many
identifiers you want to be returned with the response. The default is to
return one identifier. The response will contain a JSON object with an
array named codes, similar to this:

```json
{
  "codes": [
    "Y0moqFplrX4",
    "WI0VHXuWQuV",
    "BRJNBBpu4ki"
  ]
}
```

The DHIS2 UID format has these requirements:

  - 11 characters long.

  - Alphanumeric characters only, ie. alphabetic or numeric characters
    (A-Za-z0-9).

  - Start with an alphabetic character (A-Za-z).

### View system information

<!--DHIS2-SECTION-ID:webapi_system_resource_view_system_information-->

To get information about the current system you can do a GET request to
this URL:

    /api/33/system/info

JSON and JSONP response formats are supported. The system info response
currently includes the below properties.

```json
{
  contextPath: "http://yourdomain.com",
  userAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/29.0.1547.62",
  version: "2.13-SNAPSHOT",
  revision: "11852",
  buildTime: "2013-09-01T21:36:21.000+0000",
  serverDate: "2013-09-02T12:35:54.311+0000",
  environmentVariable: "DHIS2_HOME",
  javaVersion: "1.7.0_06",
  javaVendor: "Oracle Corporation",
  javaIoTmpDir: "/tmp",
  javaOpts: "-Xms600m -Xmx1500m -XX:PermSize=400m -XX:MaxPermSize=500m",
  osName: "Linux",
  osArchitecture: "amd64",
  osVersion: "3.2.0-52-generic",
  externalDirectory: "/home/dhis/config/dhis2",
  databaseInfo: {
    type: "PostgreSQL",
    name: "dhis2",
    user: "dhis",
    spatialSupport: false
  },
  memoryInfo: "Mem Total in JVM: 848 Free in JVM: 581 Max Limit: 1333",
  cpuCores: 8
}
```

> **Note**
>
> If the user who is requesting this resource does not have full authority in the system then only the first seven properties will be included, as this information is security sensitive.

To get information about the system context only, i.e. `contextPath` and
`userAgent`, you can make a GET request to the below URL. JSON and
JSONP response formats are supported:

    /api/33/system/context

### Check if username and password combination is correct

<!--DHIS2-SECTION-ID:webapi_system_resource_check_username_password-->

To check if some user credentials (a username and password combination)
is correct you can make a *GET* request to the following resource using
*basic authentication*:

    /api/33/system/ping

You can detect the outcome of the authentication by inspecting the *HTTP
status code* of the response header. The meanings of the possible status
codes are listed below. Note that this applies to Web API requests in
general.

<table>
<caption>HTTP Status codes</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 12%" />
<col style="width: 74%" />
</colgroup>
<thead>
<tr class="header">
<th>HTTP Status code</th>
<th>Description</th>
<th>Outcome</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>200</td>
<td>OK</td>
<td>Authentication was successful</td>
</tr>
<tr class="even">
<td>302</td>
<td>Found</td>
<td>No credentials were supplied with the request - no authentication took place</td>
</tr>
<tr class="odd">
<td>401</td>
<td>Unauthorized</td>
<td>The username and password combination was incorrect - authentication failed</td>
</tr>
</tbody>
</table>

### View asynchronous task status

<!--DHIS2-SECTION-ID:webapi_system_resource_view_async_task_status-->

Tasks which often take a long time to complete can be performed
asynchronously. After initiating an async task you can poll the status
through the `system/tasks` resource by supplying the task category and
the task identifier of interest.

When polling for the task status you need to authenticate as the same
user which initiated the task. The following task categories are
supported:

<table>
<caption>Task categories</caption>
<colgroup>
<col style="width: 21%" />
<col style="width: 78%" />
</colgroup>
<thead>
<tr class="header">
<th>Identifier</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ANALYTICS_TABLE</td>
<td>Generation of the analytics tables.</td>
</tr>
<tr class="even">
<td>RESOURCE_TABLE</td>
<td>Generation of the resource tables.</td>
</tr>
<tr class="odd">
<td>MONITORING</td>
<td>Processing of data surveillance/monitoring validation rules.</td>
</tr>
<tr class="even">
<td>DATAVALUE_IMPORT</td>
<td>Import of data values.</td>
</tr>
<tr class="odd">
<td>EVENT_IMPORT</td>
<td>Import of events.</td>
</tr>
<tr class="even">
<td>ENROLLMENT_IMPORT</td>
<td>Import of enrollments.</td>
</tr>
<tr class="odd">
<td>TEI_IMPORT</td>
<td>Import of tracked entity instances.</td>
</tr>
<tr class="even">
<td>METADATA_IMPORT</td>
<td>Import of metadata.</td>
</tr>
<tr class="odd">
<td>DATA_INTEGRITY</td>
<td>Processing of data integrity checks.</td>
</tr>
</tbody>
</table>

Each asynchronous task is automatically assigned an identifier which can
be used to monitor the status of the task. This task identifier is
returned by the API when you initiate an async task through the various
async-enabled endpoints.

#### Monitoring a task

You can poll the task status through a GET request to the system tasks
resource like this:

    /api/33/system/tasks/{task-category-id}/{task-id}

An example request may look like this:

    /api/33/system/tasks/DATAVALUE_IMPORT/j8Ki6TgreFw

The response will provide information about the status, such as the
notification level, category, time and status. The *completed* property
indicates whether the process is considered to be complete.

```json
[{
  "uid": "hpiaeMy7wFX",
  "level": "INFO",
  "category": "DATAVALUE_IMPORT",
  "time": "2015-09-02T07:43:14.595+0000",
  "message": "Import done",
  "completed": true
}]
```

#### Monitoring all tasks for a category

You can poll all tasks for a specific category through a GET request to
the system tasks resource:

    /api/33/system/tasks/{task-category-id}

An example request to poll for the status of data value import tasks
looks like this:

    /api/33/system/tasks/DATAVALUE_IMPORT

#### Monitor all tasks

You can request a list of all currently running tasks in the system with
a GET request to the system tasks resource:

    /api/33/system/tasks

The response will look similar to this:

```json
[{
  "EVENT_IMPORT": {},
  "DATA_STATISTICS": {},
  "RESOURCE_TABLE": {},
  "FILE_RESOURCE_CLEANUP": {},
  "METADATA_IMPORT": {},
  "CREDENTIALS_EXPIRY_ALERT": {},
  "SMS_SEND": {},
  "MOCK": {},
  "ANALYTICSTABLE_UPDATE": {},
  "COMPLETE_DATA_SET_REGISTRATION_IMPORT": {},
  "DATAVALUE_IMPORT": {},
  "DATA_SET_NOTIFICATION": {},
  "DATA_INTEGRITY": {
    "OB1qGRlCzap": [{
      "uid": "LdHQK0PXZyF",
      "level": "INFO",
      "category": "DATA_INTEGRITY",
      "time": "2018-03-26T15:02:32.171",
      "message": "Data integrity checks completed in 38.31 seconds.",
      "completed": true
    }]
  },
  "PUSH_ANALYSIS": {},
  "MONITORING": {},
  "VALIDATION_RESULTS_NOTIFICATION": {},
  "REMOVE_EXPIRED_RESERVED_VALUES": {},
  "DATA_SYNC": {},
  "SEND_SCHEDULED_MESSAGE": {},
  "DATAVALUE_IMPORT_INTERNAL": {},
  "PROGRAM_NOTIFICATIONS": {},
  "META_DATA_SYNC": {},
  "ANALYTICS_TABLE": {},
  "PREDICTOR": {}
}]
```

### View asynchronous task summaries

The task summaries resource allows you to retrieve a summary of an
asynchronous task invocation. You need to specify the category and
optionally the identifier of the task. The task identifier can be
retrieved from the response of the API request which initiated the
asynchronous task.

To retrieve the summary of a specific task you can issue a request to:

    /api/33/system/taskSummaries/{task-category-id}/{task-id}

An example request might look like this:

    /api/33/system/taskSummaries/DATAVALUE_IMPORT/k72jHfF13J1

The response will look similar to this:

```json
{
  "responseType": "ImportSummary",
  "status": "SUCCESS",
  "importOptions": {
    "idSchemes": {},
    "dryRun": false,
    "async": true,
    "importStrategy": "CREATE_AND_UPDATE",
    "mergeMode": "REPLACE",
    "reportMode": "FULL",
    "skipExistingCheck": false,
    "sharing": false,
    "skipNotifications": false,
    "datasetAllowsPeriods": false,
    "strictPeriods": false,
    "strictCategoryOptionCombos": false,
    "strictAttributeOptionCombos": false,
    "strictOrganisationUnits": false,
    "requireCategoryOptionCombo": false,
    "requireAttributeOptionCombo": false,
    "skipPatternValidation": false
  },
  "description": "Import process completed successfully",
  "importCount": {
    "imported": 0,
    "updated": 431,
    "ignored": 0,
    "deleted": 0
  },
  "dataSetComplete": "false"
}
```

You might also retrieve import summaries for multiple tasks of a
specific category with a request like
this:

    /api/33/system/taskSummaries/{task-category-id}

### Get appearance information

<!--DHIS2-SECTION-ID:webapi_system_resource_get_appearance_information-->

You can retrieve the available flag icons in JSON format with a GET
request:

    /api/33/system/flags

You can retrieve the available UI styles in JSON format with a GET
request:

    /api/33/system/styles

## Locales

<!--DHIS2-SECTION-ID:webapi_locales-->

DHIS2 supports translations both for the user interface and for database
content.

### UI locales

You can retrieve the available locales for the user interface through
the following resource with a GET request. XML and JSON resource
representations are supported.

    /api/33/locales/ui

### Database content locales

You can retrieve and create locales for the database content with GET and
POST requests through the following resource. XML and JSON resource
representations are supported.

    /api/33/locales/db

## Translations

<!--DHIS2-SECTION-ID:webapi_translations-->

DHIS2 allows for translations of database content. You can work with
translations through the Web API using the *translations* resource.

    /api/33/translations

### Create a translation

You can create a translation with a POST request in JSON format:

```json
{
  "objectId": "P3jJH5Tu5VC",
  "className": "DataElement",
  "locale": "es",
  "property": "name",
  "value": "Casos de fiebre amarilla"
}
```

    POST /api/33/translations

The properties which support translations are listed in the table below.

<table>
<caption>Property names</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>Property name</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>Object name</td>
</tr>
<tr class="even">
<td>shortName</td>
<td>Object short name</td>
</tr>
<tr class="odd">
<td>description</td>
<td>Object description</td>
</tr>
</tbody>
</table>

The classes which support translations are listed in the table below.

<table>
<caption>Class names</caption>
<colgroup>
<col style="width: 34%" />
<col style="width: 65%" />
</colgroup>
<thead>
<tr class="header">
<th>Class name</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>DataElementCategoryOption</td>
<td>Category option</td>
</tr>
<tr class="even">
<td>DataElementCategory</td>
<td>Category</td>
</tr>
<tr class="odd">
<td>DataElementCategoryCombo</td>
<td>Category combination</td>
</tr>
<tr class="even">
<td>DataElement</td>
<td>Data element</td>
</tr>
<tr class="odd">
<td>DataElementGroup</td>
<td>Data element group</td>
</tr>
<tr class="even">
<td>DataElementGroupSet</td>
<td>Data element group set</td>
</tr>
<tr class="odd">
<td>Indicator</td>
<td>Indicator</td>
</tr>
<tr class="even">
<td>IndicatorType</td>
<td>Indicator type</td>
</tr>
<tr class="odd">
<td>IndicatorGroup</td>
<td>Indicator group</td>
</tr>
<tr class="even">
<td>IndicatorGroupSet</td>
<td>Indicator group set</td>
</tr>
<tr class="odd">
<td>OrganisationUnit</td>
<td>Organisation unit</td>
</tr>
<tr class="even">
<td>OrganisationUnitGroup</td>
<td>Organisation unit group</td>
</tr>
<tr class="odd">
<td>OrganisationUnitGroupSet</td>
<td>Organisation unit group set</td>
</tr>
<tr class="even">
<td>DataSet</td>
<td>Data set</td>
</tr>
<tr class="odd">
<td>Section</td>
<td>Data set section</td>
</tr>
<tr class="even">
<td>ValidationRule</td>
<td>Validation rule</td>
</tr>
<tr class="odd">
<td>ValidationRuleGroup</td>
<td>Validation rule group</td>
</tr>
<tr class="even">
<td>Program</td>
<td>Program</td>
</tr>
<tr class="odd">
<td>ProgramStage</td>
<td>Program stage</td>
</tr>
<tr class="even">
<td>TrackedEntityAttribute</td>
<td>Tracked entity attribute</td>
</tr>
<tr class="odd">
<td>TrackedEntity</td>
<td>Tracked entity</td>
</tr>
<tr class="even">
<td>RelationshipType</td>
<td>Relationship type for tracked entity instances</td>
</tr>
<tr class="odd">
<td>OptionSet</td>
<td>Option set</td>
</tr>
<tr class="even">
<td>Attribute</td>
<td>Attribute for metadata</td>
</tr>
</tbody>
</table>

### Get translations

You can browse all translations through the translations resource:

    GET /api/33/translations

You can use the standard filtering technique to fetch translations of
interest. E.g. to get all translations for data elements in the Spanish
locale you can use this request:

    /api/33/translations.json?fields=*&filter=className:eq:DataElement&filter=locale:eq:es

To get translations for a specific object for all properties:

    /api/33/translations.json?fields=*&filter=className:eq:DataElement
      &filter=locale:eq:fr&filter=objectId:eq:fbfJHSPpUQD

## Short Message Service (SMS)

<!--DHIS2-SECTION-ID:webapi_sms-->

This section covers the SMS Web API for sending and receiving short text
messages.

### Outbound SMS service

The Web API supports sending outgoing SMS using the POST method. SMS can
be sent to single or multiple destinations. One or more gateways need
to be configured before using the service. An SMS will not be sent if
there is no gateway configured. It needs a set of recipients and
message text in JSON format as shown below.

    /api/sms/outbound

```json
{
  "message":"Sms Text",
  "recipients": [
    "004712341234",
    "004712341235"
  ]
}
```

> **Note**
>
> Recipients list will be partitioned if the size exceeds `MAX_ALLOWED_RECIPIENTS` limit of 200.

The Web API also supports a query parameter version, but the
parameterized API can only be used for sending SMS to a single
destination.

    /api/sms/outbound?message=text&recipient=004712341234
    
Outbound messages can be fetched using GET resource.

    GET /api/sms/outbound
    GET /api/sms/outbound?filter=status:eq:SENT
    GET /api/sms/outbound?filter=status:eq:SENT&fields=*
    
Outbound messages can be deleted using DELETE resource.

    DELETE /api/sms/outbound/{uid}
    DELETE /api/sms/outbound?ids=uid1,uid2	

#### Gateway response codes

Gateway may response with following response codes.

<table>
<caption>Gateway response codes</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 73%" />
</colgroup>
<thead>
<tr class="header">
<th>Response code</th>
<th>Response Message</th>
<th>Detail Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>RESULT_CODE_0</td>
<td>success</td>
<td>Message has been sent successfully</td>
</tr>
<tr class="even">
<td>RESULT_CODE_1</td>
<td>scheduled</td>
<td>Message has been scheduled successfully</td>
</tr>
<tr class="odd">
<td>RESULT_CODE_22</td>
<td>internal fatal error</td>
<td>Internal fatal error</td>
</tr>
<tr class="even">
<td>RESULT_CODE_23</td>
<td>authentication failure</td>
<td>Authentication credentials are incorrect</td>
</tr>
<tr class="odd">
<td>RESULT_CODE_24</td>
<td>data validation failed</td>
<td>Parameters provided in request are incorrect</td>
</tr>
<tr class="even">
<td>RESULT_CODE_25</td>
<td>insufficient credits</td>
<td>Credit is not enough to send message</td>
</tr>
<tr class="odd">
<td>RESULT_CODE_26</td>
<td>upstream credits not available</td>
<td>Upstream credits not available</td>
</tr>
<tr class="even">
<td>RESULT_CODE_27</td>
<td>exceeded your daily quota</td>
<td>You have exceeded your daily quota</td>
</tr>
<tr class="odd">
<td>RESULT_CODE_40</td>
<td>temporarily unavailable</td>
<td>Service is temporarily down</td>
</tr>
<tr class="even">
<td>RESULT_CODE_201</td>
<td>maximum batch size exceeded</td>
<td>Maximum batch size exceeded</td>
</tr>
<tr class="odd">
<td>RESULT_CODE_200</td>
<td>success</td>
<td>The request was successfully completed</td>
</tr>
<tr class="even">
<td>RESULT_CODE_202</td>
<td>accepted</td>
<td>The message(s) will be processed</td>
</tr>
<tr class="odd">
<td>RESULT_CODE_207</td>
<td>multi-status</td>
<td>More than one message was submitted to the API; however, not all messages have the same status</td>
</tr>
<tr class="even">
<td>RESULT_CODE_400</td>
<td>bad request</td>
<td>Validation failure (such as missing/invalid parameters or headers)</td>
</tr>
<tr class="odd">
<td>RESULT_CODE_401</td>
<td>unauthorized</td>
<td>Authentication failure. This can also be caused by IP lockdown settings</td>
</tr>
<tr class="even">
<td>RESULT_CODE_402</td>
<td>payment required</td>
<td>Not enough credit to send message</td>
</tr>
<tr class="odd">
<td>RESULT_CODE_404</td>
<td>not found</td>
<td>Resource does not exist</td>
</tr>
<tr class="even">
<td>RESULT_CODE_405</td>
<td>method not allowed</td>
<td>Http method is not support on the resource</td>
</tr>
<tr class="odd">
<td>RESULT_CODE_410</td>
<td>gone</td>
<td>Mobile number is blocked</td>
</tr>
<tr class="even">
<td>RESULT_CODE_429</td>
<td>too many requests</td>
<td>Generic rate limiting error</td>
</tr>
<tr class="odd">
<td>RESULT_CODE_503</td>
<td>service unavailable</td>
<td>A temporary error has occurred on our platform - please retry</td>
</tr>
</tbody>
</table>

### Inbound SMS service

The Web API supports collecting incoming SMS messages using the POST
method. Incoming messages routed towards the DHIS2 Web API can be
received using this API. The API collects inbound SMS messages and
provides it to listeners for parsing, based on the SMS content (SMS
Command). An example payload in JSON format is given below. Text,
originator, received date and sent date are mandatory parameters. The
rest are optional but the system will use the default value for these
parameters.

    /api/sms/inbound

```json
{
  "text": "sample text",
  "originator": "004712341234",
  "gatewayid": "unknown",
  "receiveddate": "2016-05-01",
  "sentdate":"2016-05-01",
  "smsencoding": "1",
  "smsstatus":"1"
}
```

Inbound messages can be fetched using GET resourcef

    GET /api/sms/inbound
    GET /api/sms/inbound?fields=*&filter=smsstatus=INCOMING

Inbound messages can be deleted using DELETE resource

    DELETE /api/sms/inbound/{uid}
    DELETE /api/sms/inbound?ids=uid1,uid2
 
To import all un parsed messages
	
	POST /api/sms/inbound/import
    
<table>
<caption>User query parameters</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 73%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>message</td>
<td>String</td>
<td>This is mandatory parameter which carries the actual text message.</td>
</tr>
<tr class="even">
<td>originator</td>
<td>String</td>
<td>This is mandatory parameter which shows by whom this message was actually sent from.</td>
</tr>
<tr class="odd">
<td>gateway</td>
<td>String</td>
<td>This is an optional parameter which gives gateway id. If not present default text &quot;UNKNOWN&quot; will be stored</td>
</tr>
<tr class="even">
<td>receiveTime</td>
<td>Date</td>
<td>This is an optional parameter. It is timestamp at which message was received at the gateway.</td>
</tr>
</tbody>
</table>

### Gateway service administration

The Web API exposes resources which provide a way to configure and
update SMS gateway configurations.

The list of different gateways configured can be retrieved using a GET
method.

    GET /api/33/gateways

Configurations can also be retrieved for a specific gateway type using
GET method.

    GET /api/33/gateways/{uid}

New gateway configurations can be added using POST. POST api requires type request parameter and currently its value can have either one *http,bulksms,clickatell,smpp*. First added gateway will be set to default. Only one gateway is allowed to be default at one time. Default gateway can only be changed through its api. If default gateway is removed then the next one the list will automatically becomes default.

    POST /api/33/gateways

Configuration can be updated with by providing uid and gateway configurations as mentioned below

    PUT /api/33/gateways/{uids}

Configurations can be removed for specific gateway type using DELETE
method.

    DELETE /api/33/gateways/{uid}

Default gateway can be retrieved and updated.

    GET /api/33/gateways/default

Default gateway can be set using the PUT method.

    PUT /api/33/gateways/default/{uid}

### Gateway configuration

The Web API lets you create and update gateway configurations. For each
type of gateway there are different parameters in the JSON payload.
Sample JSON payloads for each gateway are given below. POST is used to
create and PUT to update configurations. Header parameter can be used in
case of GenericHttpGateway to send one or more parameter as http header.

#### Clickatell

```json
{
  "type" : "clickatell",
  "name" : "clickatell",
  "username": "clickatelluser",
  "authToken": "XXXXXXXXXXXXXXXXXXXX",
  "urlTemplate": "https://platform.clickatell.com/messages"
}
```

#### Bulksms

```json
{
  "type": "bulksms",
  "name": "bulkSMS",
  "username": "bulkuser",
  "password": "abc123"
}
```

#### SMPP Gateway

```json
{
  "type": "smpp",
  "name": "smpp gateway2",
  "systemId": "smppclient1",
  "host": "localhost",
  "systemType": "cp",
  "numberPlanIndicator": "UNKNOWN",
  "typeOfNumber": "UNKNOWN",
  "bindType": "BIND_TX",
  "port": 2775,
  "password":"password",
  "compressed": false
}
```

#### Generic HTTP

```json
{
  "type": "http",
  "name": "Generic",
  "configurationTemplate": "username=${username}&password=${password}&to=${recipients}&countrycode=880&message=${text$}&messageid=0",
  "useGet": false,
  "sendUrlParameters":false,
  "contentType": "APPLICATION_JSON",
  "urlTemplate":"https://samplegateway.com/messages",
  "parameters": [
    {
      "header": true,
      "encode": false,
      "key": "username",
      "value": "user_uio",
      "confidential": true
    },
    {
      "header": true,
      "encode": false,
      "key": "password",
      "value": "123abcxyz",
      "confidential": true
    },
    {
      "header": false,
      "encode": false,
      "key": "deliveryReport",
      "value": "yes",
      "confidential": false
    }
  ],
  "isDefault": false
}
```

In generic http gateway any number of parameters can be added. 

<table>
<caption>Generic SMS gateway parameters</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 13%" />
<col style="width: 73%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>String</td>
<td>name of the gateway</td>
</tr>
<tr class="even">
<td>configurationTemplate</td>
<td>String</td>
<td>Configuration template which get populated with parameter values. For example configuration template given above will be populated like this { "to": "+27001234567", "body": "Hello World!"}</td>
</tr>
<tr class="odd">
<td>useGet</td>
<td>Boolean</td>
<td>Http POST nethod will be used by default. In order to change it and Http GET, user can set useGet flag to true.</td>
</tr>
<tr class="even">
<td>contentType</td>
<td>String</td>
<td>Content type specify what type of data is being sent. Supported types are APPLICATION_JSON, APPLICATION_XML, FORM_URL_ENCODED, TEXT_PLAIN</td>
</tr>
<tr class="odd">
<td>urlTemplate</td>
<td>String</td>
<td>Url template</td>
</tr>
<tr class="even">
<td>header</td>
<td>Boolean</td>
<td>If parameter needs to be sent in Http headers</td>
</tr>
<tr class="odd">
<td>encode</td>
<td>Boolean</td>
<td>If parameter needs to be encoded</td>
</tr>
<tr class="even">
<td>key</td>
<td>String</td>
<td>parameter key</td>
</tr>
<tr class="odd">
<td>value</td>
<td>String</td>
<td>parameter value</td>
</tr>
<tr class="even">
<td>confidential</td>
<td>Boolean</td>
<td>If parameter is confidential. This parameter will not be exposed through API</td>
</tr>
<tr class="odd">
<td>sendUrlParameters</td>
<td>Boolean</td>
<td>If this flag is checked then urlTemplate can be appended with query parameters. This is usefull if gateway API only support HTTP GET. Sample urlTemplate looks like this "urlTemplate":"https://samplegateway.com/messages?apiKey={apiKey}&to={recipients},content={text},deliveryreport={dp}"</td>
</tr>
</tbody>
</table>

HTTP.OK will be returned if configurations are saved successfully otherwise *Error*

## SMS Commands

<!--DHIS2-SECTION-ID:webapi_sms_commands-->

SMS commands are being used to collect data through SMS. These commands
belong to specific parser type. Each parser has different functionality.

The list of commands can be retrieved using GET.

    GET /api/smsCommands

One particular command can be retrieved using GET.

    GET /api/smsCommands/uid

One particular command can be updated using PUT.

    PUT /api/smsCommands/uid

Command can be created using POST.

    POST /api/smsCommands

One particular command can be deleted using DELETE.

    DELETE /api/smsCommands/uid

#### SMS command types

| Type | Usage |
|---|---|
|KEY_VALUE_PARSER | For aggregate data collection.|
|ALERT_PARSER | To send alert messages.|
|UNREGISTERED_PARSER | For disease surveillance case reporting.|
|TRACKED_ENTITY_REGISTRATION_PARSER | For tracker entity registration.|
|PROGRAM_STAGE_DATAENTRY_PARSER | Data collection for program stage. ( TEI is identified based on phoneNumner )|
|EVENT_REGISTRATION_PARSER | Registration of single event. This is used for event programs.|

#### SMS command types for Android

These command types can be used by the Android app for data submission via SMS when internet is unavailable. The SMS is composed by the Android app.

| Type | Usage |
|---|---|
|AGGREGATE_DATASET | For aggregate data collection.|
|ENROLLMENT | For tracker entity registration.|
|TRACKER_EVENT | Event registration for tracker programs.|
|SIMPLE_EVENT | Event registration for event programs.|
|RELATIONSHIP | To create relationships.|
|DELETE | To delete event.|

## Program Messages

<!--DHIS2-SECTION-ID:webapi_program_messages-->

Program message lets you send messages to tracked entity instances,
contact addresses associated with organisation units, phone numbers and
email addresses. You can send messages through the `messages` resource.

    /api/33/messages

### Sending program messages

Program messages can be sent using two delivery channels:

  - SMS (SMS)

  - Email address (EMAIL)

Program messages can be sent to various recipients:

  - Tracked entity instance: The system will look up attributes of value
    type PHONE_NUMBER or EMAIL (depending on the specified delivery
    channels) and use the corresponding attribute values.

  - Organisation unit: The system will use the phone number or email
    information registered for the organisation unit.

  - List of phone numbers: The system will use the explicitly defined
    phone numbers.

  - List of email addresses: The system will use the explicitly defined
    email addresses.

Below is a sample JSON payload for sending messages using POST requests.
Note that message resource accepts a wrapper object named
`programMessages` which can contain any number of program messages.

    POST /api/33/messages

```json
{
  "programMessages": [{
    "recipients": {
      "trackedEntityInstance": {
        "id": "UN810PwyVYO"
      },
      "organisationUnit": {
        "id": "Rp268JB6Ne4"
      },
      "phoneNumbers": [
        "55512345",
        "55545678"
      ],
      "emailAddresses": [
        "johndoe@mail.com",
        "markdoe@mail.com"
      ]
    },
    "programInstance": {
      "id": "f3rg8gFag8j"
    },
    "programStageInstance": {
      "id": "pSllsjpfLH2"
    },
    "deliveryChannels": [
      "SMS", "EMAIL"
    ],
    "subject": "Outbreak alert",
    "text": "An outbreak has been detected",
    "storeCopy": false
  }]
}
```

The fields are explained in the following table.

<table>
<caption>Program message payload</caption>
<colgroup>
<col style="width: 21%" />
<col style="width: 21%" />
<col style="width: 31%" />
<col style="width: 26%" />
</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Required</th>
<th>Description</th>
<th>Values</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>recipients</td>
<td>Yes</td>
<td>Recipients of the program message. At least one recipient must be specified. Any number of recipients / types can be specified for a message.</td>
<td>Can be trackedEntityInstance, organisationUnit, an array of phoneNumbers or an array of emailAddresses.</td>
</tr>
<tr class="even">
<td>programInstance</td>
<td>Either this or programStageInstance required</td>
<td>The program instance / enrollment.</td>
<td>Enrollment ID.</td>
</tr>
<tr class="odd">
<td>programStageInstance</td>
<td>Either this or programInstance required</td>
<td>The program stage instance / event.</td>
<td>Event ID.</td>
</tr>
<tr class="even">
<td>deliveryChannels</td>
<td>Yes</td>
<td>Array of delivery channels.</td>
<td>SMS | EMAIL</td>
</tr>
<tr class="odd">
<td>subject</td>
<td>No</td>
<td>The message subject. Not applicable for SMS delivery channel.</td>
<td>Text.</td>
</tr>
<tr class="even">
<td>text</td>
<td>Yes</td>
<td>The message text.</td>
<td>Text.</td>
</tr>
<tr class="odd">
<td>storeCopy</td>
<td>No</td>
<td>Whether to store a copy of the program message in DHIS2.</td>
<td>false (default) | true</td>
</tr>
</tbody>
</table>

A minimalistic example for sending a message over SMS to a tracked
entity instance looks like this:

```bash
curl -d @message.json "https://play.dhis2.org/demo/api/33/messages"
  -H "Content-Type:application/json" -u admin:district
```

```json
{
  "programMessages": [{
    "recipients": {
      "trackedEntityInstance": {
        "id": "PQfMcpmXeFE"
      }
    },
    "programInstance": {
      "id": "JMgRZyeLWOo"
    },
    "deliveryChannels": [
      "SMS"
    ],
    "text": "Please make a visit on Thursday"
  }]
}
```

### Retrieving and deleting program messages

The list of messages can be retrieved using GET.

    GET /api/33/messages

To get list of all scheduled message 

	GET /api/33/messages/scheduled
	GET /api/33/messages/scheduled?scheduledAt=2020-12-12 

One particular message can also be retrieved using GET.

    GET /api/33/messages/{uid}

Message can be deleted using DELETE.

    DELETE /api/33/messages/{uid}
    

### Querying program messages

The program message API supports program message queries based on
request parameters. Messages can be filtered based on below mentioned
query parameters. All requests should use the GET HTTP verb for
retrieving information.

<table>
<caption>Query program messages API</caption>
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>URL</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>programInstance</td>
<td>/api/33/messages?programInstance=6yWDMa0LP7</td>
</tr>
<tr class="even">
<td>programStageInstance</td>
<td>/api/33/messages?programStageInstance=SllsjpfLH2</td>
</tr>
<tr class="odd">
<td>trackedEntityInstance</td>
<td>/api/33/messages?trackedEntityInstance=xdfejpfLH2</td>
</tr>
<tr class="even">
<td>organisationUnit</td>
<td>/api/33/messages?ou=Sllsjdhoe3</td>
</tr>
<tr class="odd">
<td>processedDate</td>
<td>/api/33/messages?processedDate=2016-02-01</td>
</tr>
</tbody>
</table>

## Users

<!--DHIS2-SECTION-ID:webapi_users-->

This section covers the user resource methods.

    /api/33/users

### User query

<!--DHIS2-SECTION-ID:webapi_users_query-->

The *users* resource offers additional query parameters beyond the
standard parameters (e.g. paging). To query for users at the users
resource you can use the following parameters.

<table>
<caption>User query parameters</caption>
<colgroup>
<col style="width: 18%" />
<col style="width: 17%" />
<col style="width: 63%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>query</td>
<td>Text</td>
<td>Query value for first name, surname, username and email, case in-sensitive.</td>
</tr>
<tr class="even">
<td>phoneNumber</td>
<td>Text</td>
<td>Query for phone number.</td>
</tr>
<tr class="odd">
<td>canManage</td>
<td>false | true</td>
<td>Filter on whether the current user can manage the returned users through the managed user group relationships.</td>
</tr>
<tr class="even">
<td>authSubset</td>
<td>false | true</td>
<td>Filter on whether the returned users have a subset of the authorities of the current user.</td>
</tr>
<tr class="odd">
<td>lastLogin</td>
<td>Date</td>
<td>Filter on users who have logged in later than the given date.</td>
</tr>
<tr class="even">
<td>inactiveMonths</td>
<td>Number</td>
<td>Filter on users who have not logged in for the given number of months.</td>
</tr>
<tr class="odd">
<td>inactiveSince</td>
<td>Date</td>
<td>Filter on users who have not logged in later than the given date.</td>
</tr>
<tr class="even">
<td>selfRegistered</td>
<td>false | true</td>
<td>Filter on users who have self-registered their user account.</td>
</tr>
<tr class="odd">
<td>invitationStatus</td>
<td>none | all | expired</td>
<td>Filter on user invitations, including all or expired invitations.</td>
</tr>
<tr class="even">
<td>ou</td>
<td>Identifier</td>
<td>Filter on users who are associated with the organisation unit with the given identifier.</td>
</tr>
<tr class="odd">
<td>userOrgUnits</td>
<td>false | true</td>
<td>Filter on users who are associated with the organisation units linked to the currently logged in user.</td>
</tr>
<tr class="even">
<td>includeChildren</td>
<td>false | true</td>
<td>Includes users from all children organisation units of the ou parameter.</td>
</tr>
<tr class="odd">
<td>page</td>
<td>Number</td>
<td>The page number.</td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>Number</td>
<td>The page size.</td>
</tr>
</tbody>
</table>

A query for max 10 users with "konan" as first name or surname (case
in-sensitive) who have a subset of authorities compared to the current
user:

    /api/33/users?query=konan&authSubset=true&pageSize=10

### User lookup

The user lookup API provides an endpoint for retrieving users where the
response contains a minimal set of information. It does not require a 
specific authority and is suitable  for allowing clients to look up information 
such as user first and surname,  without exposing potentially sensitive 
user information.

```
/api/userLookup
```

The user lookup endpoint has two methods.

#### User lookup by identifier

You can do a user lookup by identifier using the following API request.

```
GET /api/userLookup/{id}
```

The user `id` will be matched against the following user properties
in the specified order:

- UID
- UUID
- username

An example request looks like this:

```
/api/userLookup/QqvaU7JjkUV
```

The response will contain minimal information about a user.

```json
{
  "id": "QqvaU7JjkUV",
  "username": "nkono",
  "firstName": "Thomas",
  "surname": "Nkono",
  "displayName": "Thomas Nkono"
}
```

#### User lookup query

You can make a query for users using the following API request.

```
GET /api/userLookup?query={string}
```

The `query` request parameter is mandatory. The query `string` will be matched
against the following user properties:

- First name
- Surname
- Email
- Username

An example request looks like this:

```
/api/userLookup?query=John
```

The response will contain information about the users matching the request.

```json
{
  "users": [
    {
      "id": "DXyJmlo9rge",
      "username": "jbarnes",
      "firstName": "John",
      "surname": "Barnes",
      "displayName": "John Barnes"
    },
    {
      "id": "N3PZBUlN8vq",
      "username": "jkamara",
      "firstName": "John",
      "surname": "Kamara",
      "displayName": "John Kamara"
    }
  ]
}
```

### User account create and update

<!--DHIS2-SECTION-ID:webapi_users_create_update-->

Creating and updating users are supported through the API. A basic 
payload to create a user looks like the below example. Note that the password 
will be sent in plain text so remember to enable SSL/HTTPS for network transport.

```json
{
  "id": "Mj8balLULKp",
  "firstName": "John",
  "surname": "Doe",
  "email": "johndoe@mail.com",
  "userCredentials": {
    "id": "lWCkJ4etppc",
    "userInfo": {
    "id": "Mj8balLULKp"
  },
  "username": "johndoe123",
  "password": "Your-password-123",
  "skype": "john.doe",
  "telegram": "joh.doe",
  "whatsApp": "+1-541-754-3010",
  "facebookMessenger": "john.doe",
  "avatar": {
    "id": "<fileResource id>"
  },
  "userRoles": [
    {
      "id": "Ufph3mGRmMo"
    }
  ]
  },
  "organisationUnits": [
    {
      "id": "Rp268JB6Ne4"
    }
  ],
  "userGroups": [
    {
      "id": "wl5cDMuUhmF"
    }
  ]
}
```

```bash
curl -X POST -d @u.json "http://server/api/33/users" -u user:pass 
  -H "Content-Type: application/json" 
```

In the user creation payload, user groups are only supported when importing 
or *POSTing* a single user at a time. If you attempt to create more than one 
user while specifiying user groups, you will not recieve an error and the 
users will be created but no user groups will be assigned. This is by design 
and is limited because of the many-to-many relationship between users and 
user groups whereby user groups is the owner of the relationship. To update 
or create mulitple users and their user groups, consider a program to *POST* 
one at a time, or *POST* all users followed by another action to 
update their user groups while specifiying the new user's identifiers.

After the user is created, a *Location* header is sent back with the
newly generated ID (you can also provide your own using the `/api/system/id`
endpoint). The same payload can then be used to do updates, but remember
to then use *PUT* instead of *POST* and the endpoint is now `/api/users/ID`.

```bash
curl -X PUT -d @u.json "http://server/api/33/users/ID" -u user:pass 
  -H "Content-Type: application/json" 
```

For more info about the full payload available, please see `/api/schemas/user`.

For more info about uploading and retrieving user avatars, please see the
`/fileResources` endpoint.

### User account invitations

<!--DHIS2-SECTION-ID:webapi_user_invitations-->

The Web API supports inviting people to create user accounts through the
`invite` resource. To create an invitation you should POST a user in XML
or JSON format to the invite resource. A specific username can be forced
by defining the username in the posted entity. By omitting the username,
the person will be able to specify it herself. The system will send out
an invitation through email. This requires that email settings have been
properly configured.

The invite resource is useful in order to securely
allow people to create accounts without anyone else knowing the password
or by transferring the password in plain text. The payload to use for
the invite is the same as for creating users. An example payload in JSON
looks like this:

```json
{
  "firstName": "John",
  "surname": "Doe",
  "email": "johndoe@mail.com",
  "userCredentials": {
    "username": "johndoe",
    "userRoles": [{
      "id": "Euq3XfEIEbx"
    }]
  },
  "organisationUnits": [ {
    "id": "ImspTQPwCqd"
  } ],
  "userGroups": [ {
    "id": "vAvEltyXGbD"
  }]
}
```

The user invite entity can be posted like this:

```bash
curl -d @invite.json "localhost/api/33/users/invite" -u admin:district
  -H "Content-Type:application/json" 
```

To send out invites for multiple users at the same time you must use a
slightly different format. For JSON:

```json
{
  "users": [ {
    "firstName": "John",
    "surname": "Doe",
    "email": "johndoe@mail.com",
    "userCredentials": {
      "username": "johndoe",
      "userRoles": [ {
        "id": "Euq3XfEIEbx"
      } ]
    },
    "organisationUnits": [ {
      "id": "ImspTQPwCqd"
      } ]
    }, {
    "firstName": "Tom",
    "surname": "Johnson",
    "email": "tomj@mail.com",
    "userCredentials": {
      "userRoles": [ {
        "id": "Euq3XfEIEbx"
      } ]
    },
    "organisationUnits": [ {
      "id": "ImspTQPwCqd"
      } ]
    }
  ]
}
```

To create multiple invites you can post the payload to the
api/users/invites resource like this:

```bash
curl -d @invites.json "localhost/api/33/users/invites" -u admin:district
  -H "Content-Type:application/json"
```

There are certain requirements for user account invitations to be sent
out:

  - Email SMTP server must be configured properly on the server.

  - The user to be invited must have specified a valid email.

  - If username is specified it must not be already taken by another
    existing user.

If any of these requirements are not met the invite resource will return
with a *409 Conflict* status code together with a descriptive message.

### User replication

<!--DHIS2-SECTION-ID:webapi_user_replication-->

To replicate a user you can use the *replica* resource. Replicating a
user can be useful when debugging or reproducing issues reported by a
particular user. You need to provide a new username and password for the
replicated user which you will use to authenticate later. Note that you
need the ALL authority to perform this action. To replicate a user you
can post a JSON payload looking like below:

```json
{
  "username": "user_replica",
  "password": "SecretPassword"
}
```

This payload can be posted to the replica resource, where you provide
the identifier of the user to replicate in the URL:

    /api/33/users/<uid>/replica

An example of replicating a user using curl looks like this:

```bash
curl -d @replica.json "localhost/api/33/users/N3PZBUlN8vq/replica"
  -H "Content-Type:application/json" -u admin:district
```

## Current user information

<!--DHIS2-SECTION-ID:webapi_current_user_information-->

In order to get information about the currently authenticated user and
its associations to other resources you can work with the *me* resource
(you can also refer to it by its old name *currentUser*). The current
user related resources gives your information which is useful when
building clients for instance for data entry and user management. The
following describes these resources and their purpose.

Provides basic information about the user that you are currently logged
in as, including username, user credentials, assigned organisation
units:

    /api/me

Gives information about currently unread messages and interpretations:

    /api/me/dashboard

In order to change password, this end point can be used to validate
newly entered password. Password validation will be done based on
PasswordValidationRules configured in the system. This end point support
POST and password string should be sent in POST body.

    /api/me/validatePassword

While changing password, this end point (support POST) can be used to
verify old password. Password string should be sent in POST body.

    /api/me/verifyPassword

Returns the set of authorities granted to the current user:

    /api/me/authorization

Returns true or false, indicating whether the current user has been
granted the given `<auth>` authorization:

    /api/me/authorization/<auth>

Gives the data approval levels which are relevant to the current user:

    /api/me/dataApprovalLevels

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
<td>Not in use</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyLastSuccessfulScheduledDataSetNotifications</td>
<td>Not in use</td>
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
<td>Not in use</td>
<td>No</td>
</tr>
<tr class="even">
<td>keyHideMonthlyPeriods</td>
<td>Not in use</td>
<td>No</td>
</tr>
<tr class="odd">
<td>keyHideBiMonthlyPeriods</td>
<td>Not in use</td>
<td>No</td>
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

## Organisation units

<!--DHIS2-SECTION-ID:webapi_organisation_units-->

The *organisationUnits* resource follows the standard conventions as
other metadata resources in DHIS2. This resource supports some
additional query parameters.

### Get list of organisation units

<!--DHIS2-SECTION-ID:webapi_list_of_organisation_units-->

To get a list of organisation units you can use the following resource.

    /api/33/organisationUnits

<table>
<caption>Organisation units query parameters</caption>
<colgroup>
<col style="width: 17%" />
<col style="width: 17%" />
<col style="width: 65%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Options</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>userOnly</td>
<td>false | true</td>
<td>Data capture organisation units associated with current user only.</td>
</tr>
<tr class="even">
<td>userDataViewOnly</td>
<td>false | true</td>
<td>Data view organisation units associated with current user only.</td>
</tr>
<tr class="odd">
<td>userDataViewFallback</td>
<td>false | true</td>
<td>Data view organisation units associated with current user only with fallback to data capture organisation units.</td>
</tr>
<tr class="even">
<td>query</td>
<td>string</td>
<td>Query against the name, code and ID properties.</td>
</tr>
<tr class="odd">
<td>level</td>
<td>integer</td>
<td>Organisation units at the given level in the hierarchy.</td>
</tr>
<tr class="even">
<td>maxLevel</td>
<td>integer</td>
<td>Organisation units at the given max level or levels higher up in the hierarchy.</td>
</tr>
<tr class="odd">
<td>withinUserHierarchy</td>
<td>false | true</td>
<td>Limits search and retrieval to organisation units that are within the users data capture scope.</td>
</tr>
<tr class="even">
<td>withinUserSearchHierarchy</td>
<td>false | true</td>
<td>Limits search and retrieval to organisation units that are within the current users search scope. Note: "withinUserHierarchy", if true, takes higher precedence.</td>
</tr>
<tr class="odd">
<td>memberCollection</td>
<td>string</td>
<td>For displaying count of members within a collection, refers to the name of the collection associated with organisation units.</td>
</tr>
<tr class="even">
<td>memberObject</td>
<td>UID</td>
<td>For displaying count of members within a collection, refers to the identifier of the object member of the collection.</td>
</tr>
</tbody>
</table>

### Get organisation unit with relations

<!--DHIS2-SECTION-ID:webapi_organisation_units_with_relations-->

To get an organisation unit with related organisation units you can use
the following resource.

    /api/33/organisationUnits/{id}

<table>
<caption>Organisation unit parameters</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 58%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Options</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>includeChildren</td>
<td>false | true</td>
<td>Include immediate children of the specified organisation unit, i.e. the units at the immediate level below in the subhierarchy.</td>
</tr>
<tr class="even">
<td>includeDescendants</td>
<td>false | true</td>
<td>Include all children of the specified organisation unit, i.e. all units in the sub-hierarchy.</td>
</tr>
<tr class="odd">
<td>includeAncestors</td>
<td>false | true</td>
<td>Include all parents of the specified organisation unit.</td>
</tr>
<tr class="even">
<td>level</td>
<td>integer</td>
<td>Include children of the specified organisation unit at the given level of the sub-hierarchy (relative to the organisation unit where the immediate level below is level 1).</td>
</tr>
</tbody>
</table>

## Data sets

<!--DHIS2-SECTION-ID:webapi_data_sets-->

The *dataSets* resource follows the standard conventions as other
metadata resources in DHIS2. This resource supports some additional
query parameters.

    /api/33/dataSets

To retrieve the version of a data set you can issue a GET request:

    GET /api/33/dataSets/<uid>/version

To bump (increase by one) the version of a data set you can issue a POST
request:

    POST /api/33/dataSets/<uid>/version

### DataSet Notification Template

<!--DHIS2-SECTION-ID:webapi_dataset_notifications-->

The *dataset notification templates* resource follows the standard
conventions as other metadata resources in DHIS2.

    GET /api/33/dataSetNotficationTemplates

To retrieve data set notification template you can issue a GET request:

    GET /api/33/dataSetNotficationTemplates/<uid>

To add data set notification template you can issue a POST request:

    POST /api/33/dataSetNotficationTemplates

To delete data set notification template you can issue a DELETE request:

    DELETE /api/33/dataSetNotficationTemplates/<uid>

JSON payload sample is given below:

```json
{
  "name": "dataSetNotificationTemplate1",
  "notificationTrigger": "COMPLETION",
  "relativeScheduledDays": 0,
  "notificationRecipient": "ORGANISATION_UNIT_CONTACT",
  "dataSets": [{
    "id": "eZDhcZi6FLP"
  }],
  "deliveryChannels": ["SMS"],
  "subjectTemplate": "V{data_name}",
  "messageTemplate": "V{data_name}V{complete_registration_period}",
  "sendStrategy": "SINGLE_NOTIFICATION"
}

```

## Filled organisation unit levels

<!--DHIS2-SECTION-ID:webapi_filled_organisation_unit_levels-->

The *filledOrganisationUnitLevels* resource provides an ordered list of
organisation unit levels, where generated levels are injected into the
list to fill positions for which it does not exist a persisted level.

    GET /api/33/filledOrganisationUnitLevels

To set the organisation unit levels you can issue a POST request with a
JSON payload looking like this.

```json
{
  "organisationUnitLevels": [{
    "name": "National",
    "level": 1,
    "offlineLevels": 3
  }, {
    "name": "District",
    "level": 2
  }, {
    "name": "Chiefdom",
    "level": 3
  }, {
    "name": "Facility",
    "level": 4
  }]
}
```

To do functional testing with curl you can issue the following command.

```bash
curl "http://localhost/api/33/filledOrganisationUnitLevels" -H "Content-Type:application/json"
  -d @levels.json -u admin:district
```

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

## Read-Only configuration service

<!--DHIS2-SECTION-ID:webapi_readonly_configuration_interface-->

To access configuration you can now use read-only service. This service
will provide read-only access to *UserSettings, SystemSettings and DHIS2
server configurations* You can get XML and JSON responses through the
*Accept* header. You can *GET* all settings from:

    /api/33/configuration/settings

You can get filtered settings based on setting type:

    GET /api/33/configuration/settings/filter?type=USER_SETTING
    
    GET /api/33/configuration/settings/filter?type=CONFIGURATION

More than one type can be
    provided

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

## Internationalization

<!--DHIS2-SECTION-ID:webapi_i18n-->

In order to retrieve key-value pairs for translated strings you can use
the *i18n* resource.

    /api/33/i18n

The endpoint is located at */api/i18n* and the request format is a simple
array of the key-value pairs:

```json
[
  "access_denied",
  "uploading_data_notification"
]
```

The request must be of type *POST* and use *application/json* as
content-type. An example using curl, assuming the request data is saved
as a file `keys.json`:

```bash
curl -d @keys.json "play.dhis2.org/demo/api/33/i18n" -X POST
  -H "Content-Type: application/json" -u admin:district
```

The result will look like this:

```json
{
  "access_denied":"Access denied",
  "uploading_data_notification":"Uploading locally stored data to the server"
}
```

## SVG conversion

<!--DHIS2-SECTION-ID:webapi_svg_conversion-->

The Web API provides a resource which can be used to convert SVG content
into more widely used formats such as PNG and PDF. Ideally this
conversion should happen on the client side, but not all client side
technologies are capable of performing this task. Currently PNG and PDF
output formats are supported. The SVG content itself should be passed with
a *svg* query parameter, and an optional query parameter *filename* can
be used to specify the filename of the response attachment file. Note
that the file extension should be omitted. For PNG you can send a *POST*
request to the following URL with Content-type
`application/x-www-form-urlencoded`, identical to a regular HTML form
submission.

    api/svg.png

For PDF you can send a *POST* request to the following URL with
content-type `application/x-www-form-urlencoded`.

    api/svg.pdf

<table>
<caption>Query parameters</caption>
<colgroup>
<col style="width: 21%" />
<col style="width: 11%" />
<col style="width: 67%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>svg</td>
<td>Yes</td>
<td>The SVG content</td>
</tr>
<tr class="even">
<td>filename</td>
<td>No</td>
<td>The file name for the returned attachment without file extension</td>
</tr>
</tbody>
</table>

## Tracker Web API

<!--DHIS2-SECTION-ID:webapi_tracker_api-->

Tracker Web API consists of 3 endpoints that have full CRUD (create,
read, update, delete) support. The 3 endpoints are
`/api/trackedEntityInstances`, `/api/enrollments` and
`/api/events` and they are responsible for tracked entity instance,
enrollment and event items.

### Tracked entity instance management

<!--DHIS2-SECTION-ID:webapi_tracked_entity_instance_management-->

Tracked entity instances have full CRUD support in the API. Together
with the API for enrollment most operations needed for working with
tracked entity instances and programs are supported.

    /api/33/trackedEntityInstances

#### Creating a new tracked entity instance

<!--DHIS2-SECTION-ID:webapi_creating_tei-->

For creating a new person in the system, you will be working with the
*trackedEntityInstances* resource. A template payload can be seen below:

```json
{
  "trackedEntity": "tracked-entity-id",
  "orgUnit": "org-unit-id",
  "geometry": "<Geo JSON>",
  "attributes": [{
    "attribute": "attribute-id",
    "value": "attribute-value"
  }]
}
```

The field "geometry" accepts a GeoJson object, where the type of the
GeoJson have to match the featureType of the TrackedEntityType
definition. An example GeoJson object looks like this:

```json
{
  "type": "Point",
  "coordinates": [1, 1]
}
```

The "coordinates" field was introduced in 2.29, and accepts a coordinate 
or a polygon as a value.

For getting the IDs for `relationship` and `attributes` you can have a look
at the respective resources `relationshipTypes`, `trackedEntityAttributes`.
To create a tracked entity instance you must use the HTTP *POST* method. 
You can post the payload the following URL:

    /api/trackedEntityInstances

For example, let us create a new instance of a person tracked entity and
specify its first name and last name attributes:

```json
{
  "trackedEntity": "nEenWmSyUEp",
  "orgUnit": "DiszpKrYNg8",
  "attributes": [
    {
      "attribute": "w75KJ2mc4zz",
      "value": "Joe"
    },
    {
      "attribute": "zDhUuAYrxNC",
      "value": "Smith"
    }
  ]
}
```

To push this to the server you can use the cURL command like this:

```bash
curl -d @tei.json "https://play.dhis2.org/demo/api/trackedEntityInstances" -X POST
  -H "Content-Type: application/json" -u admin:district
```

To create multiple instances in one request you can wrap the payload in
an outer array like this and POST to the same resource as above:[]()

```json
{
  "trackedEntityInstances": [
    {
      "trackedEntity": "nEenWmSyUEp",
      "orgUnit": "DiszpKrYNg8",
      "attributes": [
        {
          "attribute": "w75KJ2mc4zz",
          "value": "Joe"
        },
        {
          "attribute": "zDhUuAYrxNC",
          "value": "Smith"
        }
      ]
    },
    {
      "trackedEntity": "nEenWmSyUEp",
      "orgUnit": "DiszpKrYNg8",
      "attributes": [
        {
          "attribute": "w75KJ2mc4zz",
          "value": "Jennifer"
        },
        {
          "attribute": "zDhUuAYrxNC",
          "value": "Johnson"
        }
      ]
    }
  ]
}
```

The system does not allow the creation of a tracked entity instance
(as well as enrollment and event) with a UID that was already used in
the system. That means that UIDs cannot be reused.

#### Updating a tracked entity instance

<!--DHIS2-SECTION-ID:webapi_updating_tei-->

For updating a tracked entity instance, the payload is equal to the
previous section. The difference is that you must use the HTTP *PUT*
method for the request when sending the payload. You will also need to
append the person identifier to the *trackedEntityInstances* resource in
the URL like this, where `<tracked-entity-instance-identifier>` should
be replaced by the identifier of the tracked entity instance:

    /api/trackedEntityInstances/<tracked-entity-instance-id>

The payload has to contain all, even non-modified, attributes and
relationships. Attributes or relationships that were present before and
are not present in the current payload any more will be removed from the
system. This means that if attributes/relationships are empty in the
current payload, all existing attributes/relationships will be deleted
from the system. From 2.31, it is possible to ignore empty
attributes/relationships in the current payload. A request parameter of
`ignoreEmptyCollection` set to `true` can be used in case you do not
wish to send in any attributes/relationships and also do not want them
to be deleted from the system.

It is not allowed to update an already deleted tracked entity instance.
Also, it is not allowed to mark a tracked entity instance as deleted via
an update request. The same rules apply to enrollments and events.

#### Deleting a tracked entity instance

<!--DHIS2-SECTION-ID:webapi_deleting_tei-->

In order to delete a tracked entity instance, make a request to the URL
identifying the tracked entity instance with the *DELETE*
method. The URL is equal to the one above used for update.

#### Create and enroll tracked entity instances

<!--DHIS2-SECTION-ID:webapi_create_enroll_tei-->

It is also possible to both create (and update) a tracked entity
instance and at the same time enroll into a program.

```json
{
  "trackedEntity": "tracked-entity-id",
  "orgUnit": "org-unit-id",
  "attributes": [{
    "attribute": "attribute-id",
    "value": "attribute-value"
  }],
  "enrollments": [{
    "orgUnit": "org-unit-id",
    "program": "program-id",
    "enrollmentDate": "2013-09-17",
    "incidentDate": "2013-09-17"
   }, {
    "orgUnit": "org-unit-id",
    "program": "program-id",
    "enrollmentDate": "2013-09-17",
    "incidentDate": "2013-09-17"
   }]
}
```

You would send this to the server as you would normally when creating or
updating a new tracked entity instance.

```bash
curl -X POST -d @tei.json -H "Content-Type: application/json"
  -u user:pass "http://server/api/33/trackedEntityInstances"
```

#### Complete example of payload including: tracked entity instance, enrollment and event

<!--DHIS2-SECTION-ID:webapi_create_enroll_tei_create_event-->

It is also possible to create (and update) a tracked entity instance, at
the same time enroll into a program and create an event.

```json
{
  "trackedEntityType": "nEenWmSyUEp",
  "orgUnit": "DiszpKrYNg8",
  "attributes": [
    {
      "attribute": "w75KJ2mc4zz",
      "value": "Joe"
    },
    {
      "attribute": "zDhUuAYrxNC",
      "value": "Rufus"
    },
    {
     "attribute":"cejWyOfXge6",
     "value":"Male"
    }
  ],
  "enrollments":[
    {
      "orgUnit":"DiszpKrYNg8",
      "program":"ur1Edk5Oe2n",
      "enrollmentDate":"2017-09-15",
      "incidentDate":"2017-09-15",
      "events":[
        {
          "program":"ur1Edk5Oe2n",
          "orgUnit":"DiszpKrYNg8",
          "eventDate":"2017-10-17",
          "status":"COMPLETED",
          "storedBy":"admin",
          "programStage":"EPEcjy3FWmI",
          "coordinate": {
            "latitude":"59.8",
            "longitude":"10.9"
          },
          "dataValues": [
            {
              "dataElement":"qrur9Dvnyt5",
              "value":"22"
            },
            {
              "dataElement":"oZg33kd9taw",
              "value":"Male"
            }
         ]
      },
      {
         "program":"ur1Edk5Oe2n",
         "orgUnit":"DiszpKrYNg8",
         "eventDate":"2017-10-17",
         "status":"COMPLETED",
         "storedBy":"admin",
         "programStage":"EPEcjy3FWmI",
         "coordinate": {
           "latitude":"59.8",
           "longitude":"10.9"
         },
         "dataValues":[
           {
             "dataElement":"qrur9Dvnyt5",
             "value":"26"
           },
           {
             "dataElement":"oZg33kd9taw",
             "value":"Female"
           }
         ]
       }
     ]
    }
  ]  
}
```

You would send this to the server as you would normally when creating or
updating a new tracked entity instance.

```bash
curl -X POST -d @tei.json -H "Content-Type: application/json"
  -u user:pass "http://server/api/33/trackedEntityInstances"
```

#### Generated tracked entity instance attributes

<!--DHIS2-SECTION-ID:webapi_generate_tei_attributes-->

Tracked entity instance attributes that are using automatic generation of
unique values have three endpoints that are used by apps. The endpoints
are all used for generating and reserving values.

In 2.29 we introduced TextPattern for defining and generating these
patterns. All existing patterns will be converted to a valid TextPattern
when upgrading to 2.29.

> **Note**
>
> As of 2.29, all these endpoints will require you to include any
> variables reported by the `requiredValues` endpoint listed as
> required. Existing patterns, consisting of only `#`, will be upgraded
> to the new TextPattern syntax `RANDOM(<old-pattern>)`. The RANDOM
> segment of the TextPattern is not a required variable, so this
> endpoint will work as before for patterns defined before 2.29.

##### Finding required values

A TextPattern can contain variables that change based on different
factors. Some of these factors will be unknown to the server, so the
values for these variables have to be supplied when generating and
reserving values.

This endpoint will return a map of required and optional values, that
the server will inject into the TextPattern when generating new values.
Required variables have to be supplied for the generation, but optional
variables should only be supplied if you know what you are doing.

    GET /api/33/trackedEntityAttributes/Gs1ICEQTPlG/requiredValues

```json
{
  "REQUIRED": [
    "ORG_UNIT_CODE"
  ],
  "OPTIONAL": [
    "RANDOM"
  ]
}
```

##### Generate value endpoint

<!--DHIS2-SECTION-ID:webapi_generate_values-->

Online web apps and other clients that want to generate a value that
will be used right away can use the simple generate endpoint. This
endpoint will generate a value that is guaranteed to be unique at the
time of generation. The value is also guaranteed not to be reserved. As
of 2.29, this endpoint will also reserve the value generated for 3 days.

If your TextPattern includes required values, you can pass them as
parameters like the example below:

The expiration time can also be overridden at the time of generation, by
adding the `?expiration=<number-of-days>` to the request.

    GET /api/33/trackedEntityAttributes/Gs1ICEQTPlG/generate?ORG_UNIT_CODE=OSLO

```json
{
  "ownerObject": "TRACKEDENTITYATTRIBUTE",
  "ownerUid": "Gs1ICEQTPlG",
  "key": "RANDOM(X)-OSL",
  "value": "C-OSL",
  "created": "2018-03-02T12:01:36.680",
  "expiryDate": "2018-03-05T12:01:36.678"
}
```

##### Generate and reserve value endpoint

<!--DHIS2-SECTION-ID:webapi_generate_reserve_values-->

The generate and reserve endpoint is used by offline clients that need
to be able to register tracked entities with unique ids. They will
reserve a number of unique ids that this device will then use when
registering new tracked entity instances. The endpoint is called to
retrieve a number of tracked entity instance reserved values. An
optional parameter numberToReserve specifies how many ids to generate
(default is 1).

If your TextPattern includes required values, you can pass them as
parameters like the example below:

Similar to the /generate endpoint, this endpoint can also specify the
expiration time in the same way. By adding the `?expiration=<number-of-days>` 
you can override the default 60 days.

    GET /api/33/trackedEntityAttributes/Gs1ICEQTPlG/generateAndReserve?numberToReserve=3&ORG_UNIT_CODE=OSLO

```json
[
  {
    "ownerObject": "TRACKEDENTITYATTRIBUTE",
    "ownerUid": "Gs1ICEQTPlG",
    "key": "RANDOM(X)-OSL",
    "value": "B-OSL",
    "created": "2018-03-02T13:22:35.175",
    "expiryDate": "2018-05-01T13:22:35.174"
  },
  {
    "ownerObject": "TRACKEDENTITYATTRIBUTE",
    "ownerUid": "Gs1ICEQTPlG",
    "key": "RANDOM(X)-OSL",
    "value": "Q-OSL",
    "created": "2018-03-02T13:22:35.175",
    "expiryDate": "2018-05-01T13:22:35.174"
  },
  {
    "ownerObject": "TRACKEDENTITYATTRIBUTE",
    "ownerUid": "Gs1ICEQTPlG",
    "key": "RANDOM(X)-OSL",
    "value": "S-OSL",
    "created": "2018-03-02T13:22:35.175",
    "expiryDate": "2018-05-01T13:22:35.174"
  }
]
```

##### Reserved values

Reserved values are currently not accessible through the api, however, they
are returned by the `generate` and `generateAndReserve` endpoints. The
following table explains the properties of the reserved value object:

#####

<table style="width:100%;">
<caption>Reserved values</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 84%" />
</colgroup>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ownerObject</td>
<td>The metadata type referenced when generating and reserving the value. Currently only TRACKEDENTITYATTRIBUTE is supported.</td>
</tr>
<tr class="even">
<td>ownerUid</td>
<td>The uid of the metadata object referenced when generating and reserving the value.</td>
</tr>
<tr class="odd">
<td>key</td>
<td>A partially generated value where generated segments are not yet added.</td>
</tr>
<tr class="even">
<td>value</td>
<td>The fully resolved value reserved. This is the value you send to the server when storing data.</td>
</tr>
<tr class="odd">
<td>created</td>
<td>The timestamp when the reservation was made</td>
</tr>
<tr class="even">
<td>expiryDate</td>
<td>The timestamp when the reservation will no longer be reserved</td>
</tr>
</tbody>
</table>

Expired reservations are removed daily. If a pattern changes, values
that were already reserved will be accepted when storing data, even if
they don't match the new pattern, as long as the reservation has not
expired.

#### Image attributes

Working with image attributes is a lot like working with file data
values. The value of an attribute with the image value type is the id of
the associated file resource. A GET request to the
`/api/trackedEntityInstances/<entityId>/<attributeId>/image`
endpoint will return the actual image. The optional height and width
parameters can be used to specify the dimensions of the image.

```bash
curl "http://server/api/33/trackedEntityInstances/ZRyCnJ1qUXS/zDhUuAYrxNC/image?height=200&width=200"
  > image.jpg
```

The API also supports a *dimension* parameter. It can take three possible values: `small` (254x254), `medium` (512x512), `large` (1024x1024) or `original`. Image type attributes will be stored in pre-generated sizes
and will be furnished upon request based on the value of the `dimension` parameter.

```bash
curl "http://server/api/33/trackedEntityInstances/ZRyCnJ1qUXS/zDhUuAYrxNC/image?dimension=medium"
```

#### Tracked entity instance query

<!--DHIS2-SECTION-ID:webapi_tracked_entity_instance_query-->

To query for tracked entity instances you can interact with the
`/api/trackedEntityInstances` resource.

    /api/33/trackedEntityInstances

##### Request syntax

<!--DHIS2-SECTION-ID:webapi_tei_query_request_syntax-->

<table style="width:100%;">
<caption>Tracked entity instances query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 84%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>filter</td>
<td>Attributes to use as a filter for the query. Param can be repeated any number of times. Filters can be applied to a dimension on the format &lt;attribute-id&gt;:&lt;operator&gt;:&lt;filter&gt;[:&lt;operator&gt;:&lt;filter&gt;]. Filter values are case-insensitive and can be repeated together with operator any number of times. Operators can be EQ | GT | GE | LT | LE | NE | LIKE | IN.</td>
</tr>
<tr class="even">
<td>ou</td>
<td>Organisation unit identifiers, separated by &quot;;&quot;.</td>
</tr>
<tr class="odd">
<td>ouMode</td>
<td>The mode of selecting organisation units, can be SELECTED | CHILDREN | DESCENDANTS | ACCESSIBLE | CAPTURE | ALL. Default is SELECTED, which refers to the selected selected organisation units only. See table below for explanations.</td>
</tr>
<tr class="even">
<td>program</td>
<td>Program identifier. Restricts instances to being enrolled in the given program.</td>
</tr>
<tr class="odd">
<td>programStatus</td>
<td>Status of the instance for the given program. Can be ACTIVE | COMPLETED | CANCELLED.</td>
</tr>
<tr class="even">
<td>followUp</td>
<td>Follow up status of the instance for the given program. Can be true | false or omitted.</td>
</tr>
<tr class="odd">
<td>programStartDate</td>
<td>Start date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="even">
<td>programEndDate</td>
<td>End date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="odd">
<td>trackedEntity</td>
<td>Tracked entity identifier. Restricts instances to the given tracked instance type.</td>
</tr>
<tr class="even">
<td>page</td>
<td>The page number. Default page is 1.</td>
</tr>
<tr class="odd">
<td>pageSize</td>
<td>The page size. Default size is 50 rows per page.</td>
</tr>
<tr class="even">
<td>totalPages</td>
<td>Indicates whether to include the total number of pages in the paging response (implies higher response time).</td>
</tr>
<tr class="odd">
<td>skipPaging</td>
<td>Indicates whether paging should be ignored and all rows should be returned.</td>
</tr>
<tr class="even">
<td>lastUpdatedStartDate</td>
<td>Filter for events which were updated after this date. Cannot be used together with <em>lastUpdatedDuration</em>.</td>
</tr>
<tr class="odd">
<td>lastUpdatedEndDate</td>
<td>Filter for events which were updated up until this date. Cannot be used together with <em>lastUpdatedDuration</em>.</td>
</tr>
<tr class="even">
<td>lastUpdatedDuration</td>
<td>Include only items which are updated within the given duration. The format is <value><time-unit>, where the supported time units are “d” (days), “h” (hours), “m” (minutes) and “s” (seconds). Cannot be used together with <em>lastUpdatedStartDate</em> and/or <em>lastUpdatedEndDate</em>.</td>
</tr>
<tr class="odd">
<td>assignedUserMode</td>
<td>Restricts result to tei with events assigned based on the assigned user selection mode, can be CURRENT | PROVIDED | NONE | ANY.</td>
</tr>
<tr class="even">
<td>assignedUser</td>
<td>Filter the result down to a limited set of teis with events that are assigned to the given user IDs by using <em>assignedUser=id1;id2</em>.This parameter will be considered only if assignedUserMode is either PROVIDED or null. The API will error out, if for example, assignedUserMode=CURRENT and assignedUser=someId</td>
</tbody>
</table>

The available organisation unit selection modes are explained in the
following table.

<table>
<caption>Organisation unit selection modes</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th>Mode</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>SELECTED</td>
<td>Organisation units defined in the request.</td>
</tr>
<tr class="even">
<td>CHILDREN</td>
<td>The selected organisation units and the immediate children, i.e. the organisation units at the level below.</td>
</tr>
<tr class="odd">
<td>DESCENDANTS</td>
<td>The selected organisation units and all children, i.e. all organisation units in the sub-hierarchy.</td>
</tr>
<tr class="even">
<td>ACCESSIBLE</td>
<td>The data view organisation units associated with the current user and all children, i.e. all organisation units in the sub-hierarchy. Will fall back to data capture organisation units associated with the current user if the former is not defined.</td>
</tr>
<tr class="odd">
<td>CAPTURE</td>
<td>The data capture organisation units associated with the current user and all children, i.e. all organisation units in the sub-hierarchy.</td>
</tr>
<tr class="even">
<td>ALL</td>
<td>All organisation units in the system. Requires the ALL authority.</td>
</tr>
</tbody>
</table>

The query is case insensitive. The following rules apply to the query
parameters.

  - At least one organisation unit must be specified using the *ou*
    parameter (one or many), or *ouMode=ALL* must be specified.

  - Only one of the *program* and *trackedEntity* parameters can be
    specified (zero or one).

  - If *programStatus* is specified then *program* must also be
    specified.

  - If *followUp* is specified then *program* must also be specified.

  - If *programStartDate* or *programEndDate* is specified then
    *program* must also be specified.

  - Filter items can only be specified once.

A query for all instances associated with a specific organisation unit
can look like this:

    /api/33/trackedEntityInstances.json?ou=DiszpKrYNg8

To query for instances using one attribute with a filter and one
attribute without a filter, with one organisation unit using the
descendant organisation unit query mode:

    /api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A
      &filter=AMpUYgxuCaE&ou=DiszpKrYNg8;yMCshbaVExv

A query for instances where one attribute is included in the response
and one attribute is used as a filter:

    /api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A
      &filter=AMpUYgxuCaE:LIKE:Road&ou=DiszpKrYNg8

A query where multiple operand and filters are specified for a filter
item:

    api/33/trackedEntityInstances.json?ou=DiszpKrYNg8&program=ur1Edk5Oe2n
      &filter=lw1SqmMlnfh:GT:150:LT:190

To query on an attribute using multiple values in an *IN* filter:

    api/33/trackedEntityInstances.json?ou=DiszpKrYNg8
      &filter=dv3nChNSIxy:IN:Scott;Jimmy;Santiago

To constrain the response to instances which are part of a specific
program you can include a program query parameter:

    api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A&ou=O6uvpzGd5pu
      &ouMode=DESCENDANTS&program=ur1Edk5Oe2n

To specify program enrollment dates as part of the query:

    api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A&ou=O6uvpzGd5pu
      &program=ur1Edk5Oe2n&programStartDate=2013-01-01&programEndDate=2013-09-01

To constrain the response to instances of a specific tracked entity you
can include a tracked entity query parameter:

    api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A&ou=O6uvpzGd5pu
      &ouMode=DESCENDANTS&trackedEntity=cyl5vuJ5ETQ

By default the instances are returned in pages of size 50, to change
this you can use the page and pageSize query parameters:

    api/33/trackedEntityInstances.json?filter=zHXD5Ve1Efw:EQ:A&ou=O6uvpzGd5pu
      &ouMode=DESCENDANTS&page=2&pageSize=3

You can use a range of operators for the filtering:

<table>
<caption>Filter operators</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr class="header">
<th>Operator</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>EQ</td>
<td>Equal to</td>
</tr>
<tr class="even">
<td>GT</td>
<td>Greater than</td>
</tr>
<tr class="odd">
<td>GE</td>
<td>Greater than or equal to</td>
</tr>
<tr class="even">
<td>LT</td>
<td>Less than</td>
</tr>
<tr class="odd">
<td>LE</td>
<td>Less than or equal to</td>
</tr>
<tr class="even">
<td>NE</td>
<td>Not equal to</td>
</tr>
<tr class="odd">
<td>LIKE</td>
<td>Like (free text match)</td>
</tr>
<tr class="even">
<td>IN</td>
<td>Equal to one of multiple values separated by &quot;;&quot;</td>
</tr>
</tbody>
</table>

##### Response format

<!--DHIS2-SECTION-ID:webapi_tei_query_response_format-->

This resource supports JSON, JSONP, XLS and CSV resource
representations.

  - json (application/json)

  - jsonp (application/javascript)

  - xml (application/xml)

The response in JSON/XML is in object format and can look like the
following. Please note that field filtering is supported, so if you want
a full view, you might want to add `fields=*` to the query:

```json
{
  "trackedEntityInstances": [
    {
      "lastUpdated": "2014-03-28 12:27:52.399",
      "trackedEntity": "cyl5vuJ5ETQ",
      "created": "2014-03-26 15:40:19.997",
      "orgUnit": "ueuQlqb8ccl",
      "trackedEntityInstance": "tphfdyIiVL6",
      "relationships": [],
      "attributes": [
        {
          "displayName": "Address",
          "attribute": "AMpUYgxuCaE",
          "type": "string",
          "value": "2033 Akasia St"
        },
        {
          "displayName": "TB number",
          "attribute": "ruQQnf6rswq",
          "type": "string",
          "value": "1Z 989 408 56 9356 521 9"
        },
        {
          "displayName": "Weight in kg",
          "attribute": "OvY4VVhSDeJ",
          "type": "number",
          "value": "68.1"
        },
        {
          "displayName": "Email",
          "attribute": "NDXw0cluzSw",
          "type": "string",
          "value": "LiyaEfrem@armyspy.com"
        },
        {
          "displayName": "Gender",
          "attribute": "cejWyOfXge6",
          "type": "optionSet",
          "value": "Female"
        },
        {
          "displayName": "Phone number",
          "attribute": "P2cwLGskgxn",
          "type": "phoneNumber",
          "value": "085 813 9447"
        },
        {
          "displayName": "First name",
          "attribute": "dv3nChNSIxy",
          "type": "string",
          "value": "Liya"
        },
        {
          "displayName": "Last name",
          "attribute": "hwlRTFIFSUq",
          "type": "string",
          "value": "Efrem"
        },
        {
          "code": "Height in cm",
          "displayName": "Height in cm",
          "attribute": "lw1SqmMlnfh",
          "type": "number",
          "value": "164"
        },
        {
          "code": "City",
          "displayName": "City",
          "attribute": "VUvgVao8Y5z",
          "type": "string",
          "value": "Kranskop"
        },
        {
          "code": "State",
          "displayName": "State",
          "attribute": "GUOBQt5K2WI",
          "type": "number",
          "value": "KwaZulu-Natal"
        },
        {
          "code": "Zip code",
          "displayName": "Zip code",
          "attribute": "n9nUvfpTsxQ",
          "type": "number",
          "value": "3282"
        },
        {
          "code": "National identifier",
          "displayName": "National identifier",
          "attribute": "AuPLng5hLbE",
          "type": "string",
          "value": "465700042"
        },
        {
          "code": "Blood type",
          "displayName": "Blood type",
          "attribute": "H9IlTX2X6SL",
          "type": "string",
          "value": "B-"
        },
        {
          "code": "Latitude",
          "displayName": "Latitude",
          "attribute": "Qo571yj6Zcn",
          "type": "string",
          "value": "-30.659626"
        },
        {
          "code": "Longitude",
          "displayName": "Longitude",
          "attribute": "RG7uGl4w5Jq",
          "type": "string",
          "value": "26.916172"
        }
      ]
    }
  ]
}
```

#### Tracked entity instance grid query

<!--DHIS2-SECTION-ID:webapi_tracked_entity_instance_grid_query-->

To query for tracked entity instances you can interact with the
*/api/trackedEntityInstances/grid* resource. There are two types of
queries: One where a *query* query parameter and optionally *attribute*
parameters are defined, and one where *attribute* and *filter*
parameters are defined. This endpoint uses a more compact "grid" format,
and is an alternative to the query in the previous section.

    /api/33/trackedEntityInstances/query

##### Request syntax

<!--DHIS2-SECTION-ID:webapi_tei_grid_query_request_syntax-->

<table style="width:100%;">
<caption>Tracked entity instances query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 84%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>query</td>
<td>Query string. Attribute query parameter can be used to define which attributes to include in the response. If no attributes but a program is defined, the attributes from the program will be used. If no program is defined, all attributes will be used. There are two formats. The first is a plan query string. The second is on the format &lt;operator&gt;:&lt;query&gt;. Operators can be EQ | LIKE. EQ implies exact matches on words, LIKE implies partial matches on words. The query will be split on space, where each word will form a logical AND query.</td>
</tr>
<tr class="even">
<td>attribute</td>
<td>Attributes to be included in the response. Can also be used as a filter for the query. Param can be repeated any number of times. Filters can be applied to a dimension on the format &lt;attribute-id&gt;:&lt;operator&gt;:&lt;filter&gt;[:&lt;operator&gt;:&lt;filter&gt;]. Filter values are case-insensitive and can be repeated together with operator any number of times. Operators can be EQ | GT | GE | LT | LE | NE | LIKE | IN. Filters can be omitted in order to simply include the attribute in the response without any constraints.</td>
</tr>
<tr class="odd">
<td>filter</td>
<td>Attributes to use as a filter for the query. Param can be repeated any number of times. Filters can be applied to a dimension on the format &lt;attribute-id&gt;:&lt;operator&gt;:&lt;filter&gt;[:&lt;operator&gt;:&lt;filter&gt;]. Filter values are case-insensitive and can be repeated together with operator any number of times. Operators can be EQ | GT | GE | LT | LE | NE | LIKE | IN.</td>
</tr>
<tr class="even">
<td>ou</td>
<td>Organisation unit identifiers, separated by &quot;;&quot;.</td>
</tr>
<tr class="odd">
<td>ouMode</td>
<td>The mode of selecting organisation units, can be SELECTED | CHILDREN | DESCENDANTS | ACCESSIBLE | ALL. Default is SELECTED, which refers to the selected organisation units only. See table below for explanations.</td>
</tr>
<tr class="even">
<td>program</td>
<td>Program identifier. Restricts instances to being enrolled in the given program.</td>
</tr>
<tr class="odd">
<td>programStatus</td>
<td>Status of the instance for the given program. Can be ACTIVE | COMPLETED | CANCELLED.</td>
</tr>
<tr class="even">
<td>followUp</td>
<td>Follow up status of the instance for the given program. Can be true | false or omitted.</td>
</tr>
<tr class="odd">
<td>programStartDate</td>
<td>Start date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="even">
<td>programEndDate</td>
<td>End date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="odd">
<td>trackedEntity</td>
<td>Tracked entity identifier. Restricts instances to the given tracked instance type.</td>
</tr>
<tr class="even">
<td>eventStatus</td>
<td>Status of any event associated with the given program and the tracked entity instance. Can be ACTIVE | COMPLETED | VISITED | SCHEDULED | OVERDUE | SKIPPED.</td>
</tr>
<tr class="odd">
<td>eventStartDate</td>
<td>Start date of event associated with the given program and event status.</td>
</tr>
<tr class="even">
<td>eventEndDate</td>
<td>End date of event associated with the given program and event status.</td>
</tr>
<tr class="odd">
<td>programStage</td>
<td>The programStage for which the event related filters should be applied to. If not provided all stages will be considered.</td>
</tr>
<tr class="even">
<td>skipMeta</td>
<td>Indicates whether meta data for the response should be included.</td>
</tr>
<tr class="odd">
<td>page</td>
<td>The page number. Default page is 1.</td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>The page size. Default size is 50 rows per page.</td>
</tr>
<tr class="odd">
<td>totalPages</td>
<td>Indicates whether to include the total number of pages in the paging response (implies higher response time).</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>Indicates whether paging should be ignored and all rows should be returned.</td>
</tr>
</tbody>
</table>

The available organisation unit selection modes are explained in the
following table.

<table>
<caption>Organisation unit selection modes</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th>Mode</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>SELECTED</td>
<td>Organisation units defined in the request.</td>
</tr>
<tr class="even">
<td>CHILDREN</td>
<td>Immediate children, i.e. only the first level below, of the organisation units defined in the request.</td>
</tr>
<tr class="odd">
<td>DESCENDANTS</td>
<td>All children, i.e. at only levels below, e.g. including children of children, of the organisation units defined in the request.</td>
</tr>
<tr class="even">
<td>ACCESSIBLE</td>
<td>All descendants of the data view organisation units associated with the current user. Will fall back to data capture organisation units associated with the current user if the former is not defined.</td>
</tr>
<tr class="odd">
<td>CAPTURE</td>
<td>The data capture organisation units associated with the current user and all children, i.e. all organisation units in the sub-hierarchy.</td>
</tr>
<tr class="even">
<td>ALL</td>
<td>All organisation units in the system. Requires authority.</td>
</tr>
</tbody>
</table>

Note that you can specify "attribute" with filters or directly using the "filter" params for constraining the
instances to return.

Certain rules apply to which attributes are returned.

  - If "query" is specified without any attributes or program, then all attributes that 
    are marked as "Display in List without Program" is included in the response.

  - If program is specified,  all the attributes linked to the program will
    be included in the response.

  - If tracked entity type is specified, then all tracked entity type attributes 
    will be included in the response.

You can specify queries with words separated by space - in that
situation the system will query for each word independently and return
records where each word is contained in any attribute. A query item can
be specified once as an attribute and once as a filter if needed. The
query is case insensitive. The following rules apply to the query
parameters.

  - At least one organisation unit must be specified using the *ou*
    parameter (one or many), or *ouMode=ALL* must be specified.

  - Only one of the *program* and *trackedEntity* parameters can be
    specified (zero or one).

  - If *programStatus* is specified then *program* must also be
    specified.

  - If *followUp* is specified then *program* must also be specified.

  - If *programStartDate* or *programEndDate* is specified then
    *program* must also be specified.

  - If *eventStatus* is specified then *eventStartDate* and
    *eventEndDate* must also be specified.

  - A query cannot be specified together with filters.

  - Attribute items can only be specified once.

  - Filter items can only be specified once.

A query for all instances associated with a specific organisation unit
can look like this:

    /api/33/trackedEntityInstances/query.json?ou=DiszpKrYNg8

A query on all attributes for a specific value and organisation unit,
using an exact word match:

    /api/33/trackedEntityInstances/query.json?query=scott&ou=DiszpKrYNg8

A query on all attributes for a specific value, using a partial word
match:

    /api/33/trackedEntityInstances/query.json?query=LIKE:scott&ou=DiszpKrYNg8

You can query on multiple words separated by the URL character for
space which is %20, will use a logical AND query for each
    word:

    /api/33/trackedEntityInstances/query.json?query=isabel%20may&ou=DiszpKrYNg8

A query where the attributes to include in the response are specified:

    /api/33/trackedEntityInstances/query.json?query=isabel
      &attribute=dv3nChNSIxy&attribute=AMpUYgxuCaE&ou=DiszpKrYNg8

To query for instances using one attribute with a filter and one
attribute without a filter, with one organisation unit using the
descendants organisation unit query mode:

    /api/33/trackedEntityInstances/query.json?attribute=zHXD5Ve1Efw:EQ:A
      &attribute=AMpUYgxuCaE&ou=DiszpKrYNg8;yMCshbaVExv

A query for instances where one attribute is included in the response
and one attribute is used as a
    filter:

    /api/33/trackedEntityInstances/query.json?attribute=zHXD5Ve1Efw:EQ:A
      &filter=AMpUYgxuCaE:LIKE:Road&ou=DiszpKrYNg8

A query where multiple operand and filters are specified for a filter
item:

    /api/33/trackedEntityInstances/query.json?ou=DiszpKrYNg8&program=ur1Edk5Oe2n
      &filter=lw1SqmMlnfh:GT:150:LT:190

To query on an attribute using multiple values in an IN
    filter:

    /api/33/trackedEntityInstances/query.json?ou=DiszpKrYNg8
      &attribute=dv3nChNSIxy:IN:Scott;Jimmy;Santiago

To constrain the response to instances which are part of a specific
program you can include a program query parameter:

    /api/33/trackedEntityInstances/query.json?filter=zHXD5Ve1Efw:EQ:A
      &ou=O6uvpzGd5pu&ouMode=DESCENDANTS&program=ur1Edk5Oe2n

To specify program enrollment dates as part of the query:

    /api/33/trackedEntityInstances/query.json?filter=zHXD5Ve1Efw:EQ:A
      &ou=O6uvpzGd5pu&program=ur1Edk5Oe2n&programStartDate=2013-01-01
      &programEndDate=2013-09-01

To constrain the response to instances of a specific tracked entity you
can include a tracked entity query parameter:

    /api/33/trackedEntityInstances/query.json?attribute=zHXD5Ve1Efw:EQ:A
      &ou=O6uvpzGd5pu&ouMode=DESCENDANTS&trackedEntity=cyl5vuJ5ETQ

By default the instances are returned in pages of size 50, to change
this you can use the page and pageSize query parameters:

    /api/33/trackedEntityInstances/query.json?attribute=zHXD5Ve1Efw:EQ:A
      &ou=O6uvpzGd5pu&ouMode=DESCENDANTS&page=2&pageSize=3

To query for instances which have events of a given status within a
given time span:

    /api/33/trackedEntityInstances/query.json?ou=O6uvpzGd5pu
      &program=ur1Edk5Oe2n&eventStatus=LATE_VISIT
      &eventStartDate=2014-01-01&eventEndDate=2014-09-01

You can use a range of operators for the filtering:

<table>
<caption>Filter operators</caption>
<colgroup>
<col style="width: 19%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr class="header">
<th>Operator</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>EQ</td>
<td>Equal to</td>
</tr>
<tr class="even">
<td>GT</td>
<td>Greater than</td>
</tr>
<tr class="odd">
<td>GE</td>
<td>Greater than or equal to</td>
</tr>
<tr class="even">
<td>LT</td>
<td>Less than</td>
</tr>
<tr class="odd">
<td>LE</td>
<td>Less than or equal to</td>
</tr>
<tr class="even">
<td>NE</td>
<td>Not equal to</td>
</tr>
<tr class="odd">
<td>LIKE</td>
<td>Like (free text match)</td>
</tr>
<tr class="even">
<td>IN</td>
<td>Equal to one of multiple values separated by &quot;;&quot;</td>
</tr>
</tbody>
</table>

##### Response format

<!--DHIS2-SECTION-ID:webapi_tei_grid_query_response_format-->

This resource supports JSON, JSONP, XLS and CSV resource
representations.

  - json (application/json)

  - jsonp (application/javascript)

  - xml (application/xml)

  - csv (application/csv)

  - xls (application/vnd.ms-excel)

The response in JSON comes is in a tabular format and can look like the
following. The *headers* section describes the content of each column.
The instance, created, last updated, org unit and tracked entity columns
are always present. The following columns correspond to attributes
specified in the query. The *rows* section contains one row per
instance.

```json
{
  "headers": [{
    "name": "instance",
    "column": "Instance",
    "type": "java.lang.String"
  }, {
    "name": "created",
    "column": "Created",
    "type": "java.lang.String"
  }, {
    "name": "lastupdated",
    "column": "Last updated",
    "type": "java.lang.String"
  }, {
    "name": "ou",
    "column": "Org unit",
    "type": "java.lang.String"
  }, {
    "name": "te",
    "column": "Tracked entity",
    "type": "java.lang.String"
  }, {
    "name": "zHXD5Ve1Efw",
    "column": "Date of birth type",
    "type": "java.lang.String"
  }, {
    "name": "AMpUYgxuCaE",
    "column": "Address",
    "type": "java.lang.String"
  }],
  "metaData": {
    "names": {
      "cyl5vuJ5ETQ": "Person"
    }
  },
  "width": 7,
  "height": 7,
  "rows": [
    ["yNCtJ6vhRJu", "2013-09-08 21:40:28.0", "2014-01-09 19:39:32.19", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "21 Kenyatta Road"],
    ["fSofnQR6lAU", "2013-09-08 21:40:28.0", "2014-01-09 19:40:19.62", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "56 Upper Road"],
    ["X5wZwS5lgm2", "2013-09-08 21:40:28.0", "2014-01-09 19:40:31.11", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "56 Main Road"],
    ["pCbogmlIXga", "2013-09-08 21:40:28.0", "2014-01-09 19:40:45.02", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "12 Lower Main Road"],
    ["WnUXrY4XBMM", "2013-09-08 21:40:28.0", "2014-01-09 19:41:06.97", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "13 Main Road"],
    ["xLNXbDs9uDF", "2013-09-08 21:40:28.0", "2014-01-09 19:42:25.66", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "14 Mombasa Road"],
    ["foc5zag6gbE", "2013-09-08 21:40:28.0", "2014-01-09 19:42:36.93", "DiszpKrYNg8", "cyl5vuJ5ETQ", "A", "15 Upper Hill"]
  ]
}
```

#### Tracked entity instance filters

<!--DHIS2-SECTION-ID:webapi_tei_filters-->

To create, read, update and delete tracked entity instance filters you
can interact with the */api/trackedEntityInstanceFilters* resource.

    /api/33/trackedEntityInstanceFilters

##### Create and update a tracked entity instance filter definition

For creating and updating a tracked entity instance filter in the
system, you will be working with the *trackedEntityInstanceFilters*
resource. The tracked entity instance filter definitions are used in the
Tracker Capture app to display relevant predefined "Working lists" in
the tracker user interface.

<table>
<caption>Payload</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Payload values</th>
<th>Description</th>
<th>Example</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>Name of the filter. Required.</td>
<td></td>
</tr>
<tr class="even">
<td>description</td>
<td>A description of the filter.</td>
<td></td>
</tr>
<tr class="odd">
<td>sortOrder</td>
<td>The sort order of the filter. Used in Tracker Capture to order the filters in the program dashboard.</td>
<td></td>
</tr>
<tr class="even">
<td>style</td>
<td>Object containing css style.</td>
<td>( &quot;color&quot;: &quot;blue&quot;, &quot;icon&quot;: &quot;fa fa-calendar&quot;}</td>
</tr>
<tr class="odd">
<td>program</td>
<td>Object containing the id of the program. Required.</td>
<td>{ &quot;id&quot; : &quot;uy2gU8kTjF&quot;}</td>
</tr>
<tr class="even">
<td>enrollmentStatus</td>
<td>The TEIs enrollment status. Can be none(any enrollmentstatus) or ACTIVE|COMPLETED|CANCELED</td>
<td></td>
</tr>
<tr class="odd">
<td>followup</td>
<td>When this parameter is true, the filter only returns TEIs that have an enrollment with status followup.</td>
<td></td>
</tr>
<tr class="even">
<td>enrollmentCreatedPeriod</td>
<td>Period object containing a period in which the enrollment must be created. See <em>Period</em> definition table below.</td>
<td>{ &quot;periodFrom&quot;: -15, &quot;periodTo&quot;: 15}</td>
</tr>
<tr class="odd">
<td>eventFilters</td>
<td>A list of eventFilters. See <em>Event filters</em> definition table below.</td>
<td>[{&quot;programStage&quot;: &quot;eaDH9089uMp&quot;, &quot;eventStatus&quot;: &quot;OVERDUE&quot;, &quot;eventCreatedPeriod&quot;: {&quot;periodFrom&quot;: -15, &quot;periodTo&quot;: 15}}]</td>
</tr>
</tbody>
</table>

<table>
<caption>Event filters definition</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td>programStage</td>
<td>Which programStage the TEI needs an event in to be returned.</td>
<td>&quot;eaDH9089uMp&quot;</td>
</tr>
<tr class="even">
<td>eventStatus</td>
<td>The events status. Can be none(any event status) or ACTIVE|COMPLETED|SCHEDULED|OVERDUE</td>
<td>ACTIVE</td>
</tr>
<tr class="odd">
<td>eventCreatedPeriod</td>
<td>Period object containing a period in which the event must be created. See <em>Period</em> definition below.</td>
<td>{ &quot;periodFrom&quot;: -15, &quot;periodTo&quot;: 15}</td>
</tr>
<tr class="even">
<td>assignedUserMode</td>
<td>To specify the assigned user selection mode for events. Possible values are CURRENT (events assigned to current user)| PROVIDED (events assigned to users provided in "assignedUsers" list) | NONE (events assigned to no one) | ANY (events assigned to anyone). If PROVIDED (or null), non-empty assignedUsers in the payload will be considered.</td>
<td>"assignedUserMode": "PROVIDED"</td>
</tr>
<tr class="odd">
<td>assignedUsers</td>
<td>To specify a list of assigned users for events. To be used along with PROVIDED assignedUserMode above.</td>
<td>"assignedUsers": ["a3kGcGDCuk7", "a3kGcGDCuk8"]</td>
</tr>
</tbody>
</table>

<table>
<caption>Period definition</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td>periodFrom</td>
<td>Number of days from current day. Can be positive or negative integer.</td>
<td>-15</td>
</tr>
<tr class="even">
<td>periodTo</td>
<td>Number of days from current day. Must be bigger than periodFrom. Can be positive or negative integer.</td>
<td>15</td>
</tr>
</tbody>
</table>

##### Tracked entity instance filters query

To query for tracked entity instance filters in the system, you can
interact with the */api/trackedEntityInstanceFilters* resource.

<table>
<caption>Tracked entity instance filters query parameters</caption>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>program</td>
<td>Program identifier. Restricts filters to the given program.</td>
</tr>
</tbody>
</table>

### Enrollment management

<!--DHIS2-SECTION-ID:webapi_enrollment_management-->

Enrollments have full CRUD support in the API. Together with the API
for tracked entity instances most operations needed for working with
tracked entity instances and programs are supported.

    /api/33/enrollments

#### Enrolling a tracked entity instance into a program

<!--DHIS2-SECTION-ID:webapi_enrolling_tei-->

For enrolling persons into a program, you will need to first get the
identifier of the person from the *trackedEntityInstances* resource.
Then, you will need to get the program identifier from the *programs*
resource. A template payload can be seen below:

```json
{
  "trackedEntityInstance": "ZRyCnJ1qUXS",
  "orgUnit": "ImspTQPwCqd",
  "program": "S8uo8AlvYMz",
  "enrollmentDate": "2013-09-17",
  "incidentDate": "2013-09-17"
}
```

This payload should be used in a *POST* request to the enrollments
resource identified by the following URL:

    /api/33/enrollments

For cancelling or completing an enrollment, you can make a *PUT*
request to the `enrollments` resource, including the identifier and the
action you want to perform. For cancelling an enrollment for a tracked
entity instance:

    /api/33/enrollments/<enrollment-id>/cancelled

For completing an enrollment for a tracked entity instance you can make a
*PUT* request to the following URL:

    /api/33/enrollments/<enrollment-id>/completed

For deleting an enrollment, you can make a *DELETE* request to the
following URL:

    /api/33/enrollments/<enrollment-id>

#### Enrollment instance query

<!--DHIS2-SECTION-ID:webapi_enrollment_instance_query-->

To query for enrollments you can interact with the */api/enrollments*
resource.

    /api/33/enrollments

##### Request syntax

<!--DHIS2-SECTION-ID:webapi_enrollment_query_request_syntax-->

<table style="width:100%;">
<caption>Enrollment query parameters</caption>
<colgroup>
<col style="width: 15%" />
<col style="width: 84%" />
</colgroup>
<thead>
<tr class="header">
<th>Query parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ou</td>
<td>Organisation unit identifiers, separated by &quot;;&quot;.</td>
</tr>
<tr class="even">
<td>ouMode</td>
<td>The mode of selecting organisation units, can be SELECTED | CHILDREN | DESCENDANTS | ACCESSIBLE | CAPTURE | ALL. Default is SELECTED, which refers to the selected organisation units only. See table below for explanations.</td>
</tr>
<tr class="odd">
<td>program</td>
<td>Program identifier. Restricts instances to being enrolled in the given program.</td>
</tr>
<tr class="even">
<td>programStatus</td>
<td>Status of the instance for the given program. Can be ACTIVE | COMPLETED | CANCELLED.</td>
</tr>
<tr class="odd">
<td>followUp</td>
<td>Follow up status of the instance for the given program. Can be true | false or omitted.</td>
</tr>
<tr class="even">
<td>programStartDate</td>
<td>Start date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="odd">
<td>programEndDate</td>
<td>End date of enrollment in the given program for the tracked entity instance.</td>
</tr>
<tr class="even">
<td>lastUpdatedDuration</td>
<td>Include only items which are updated within the given duration. The format is <value><time-unit>, where the supported time units are “d” (days), “h” (hours), “m” (minutes) and “s” (seconds).</td>
</tr>
<tr class="odd">
<td>trackedEntity</td>
<td>Tracked entity identifier. Restricts instances to the given tracked instance type.</td>
</tr>
<tr class="even">
<td>trackedEntityInstance</td>
<td>Tracked entity instance identifier. Should not be used together with trackedEntity.</td>
</tr>
<tr class="odd">
<td>page</td>
<td>The page number. Default page is 1.</td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>The page size. Default size is 50 rows per page.</td>
</tr>
<tr class="odd">
<td>totalPages</td>
<td>Indicates whether to include the total number of pages in the paging response (implies higher response time).</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>Indicates whether paging should be ignored and all rows should be returned.</td>
</tr>
<tr class="odd">
<td>includeDeleted</td>
<td>Indicates whether to include soft deleted enrollments or not. It is false by default.</td>
</tr>
</tbody>
</table>

The available organisation unit selection modes are explained in the
following table.

<table>
<caption>Organisation unit selection modes</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th>Mode</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>SELECTED</td>
<td>Organisation units defined in the request (default).</td>
</tr>
<tr class="even">
<td>CHILDREN</td>
<td>Immediate children, i.e. only the first level below, of the organisation units defined in the request.</td>
</tr>
<tr class="odd">
<td>DESCENDANTS</td>
<td>All children, i.e. at only levels below, e.g. including children of children, of the organisation units defined in the request.</td>
</tr>
<tr class="even">
<td>ACCESSIBLE</td>
<td>All descendants of the data view organisation units associated with the current user. Will fall back to data capture organisation units associated with the current user if the former is not defined.</td>
</tr>
<tr class="odd">
<td>ALL</td>
<td>All organisation units in the system. Requires authority.</td>
</tr>
</tbody>
</table>

The query is case insensitive. The following rules apply to the query
parameters.

  - At least one organisation unit must be specified using the *ou*
    parameter (one or many), or *ouMode=ALL* must be specified.

  - Only one of the *program* and *trackedEntity* parameters can be
    specified (zero or one).

  - If *programStatus* is specified then *program* must also be
    specified.

  - If *followUp* is specified then *program* must also be specified.

  - If *programStartDate* or *programEndDate* is specified then
    *program* must also be specified.

A query for all enrollments associated with a specific organisation unit
can look like this:

    /api/33/enrollments.json?ou=DiszpKrYNg8

To constrain the response to enrollments which are part of a specific
program you can include a program query
    parameter:

    /api/33/enrollments.json?ou=O6uvpzGd5pu&ouMode=DESCENDANTS&program=ur1Edk5Oe2n

To specify program enrollment dates as part of the
    query:

    /api/33/enrollments.json?&ou=O6uvpzGd5pu&program=ur1Edk5Oe2n
      &programStartDate=2013-01-01&programEndDate=2013-09-01

To constrain the response to enrollments of a specific tracked entity
you can include a tracked entity query
    parameter:

    /api/33/enrollments.json?ou=O6uvpzGd5pu&ouMode=DESCENDANTS&trackedEntity=cyl5vuJ5ETQ

To constrain the response to enrollments of a specific tracked entity
instance you can include a tracked entity instance query parameter, in
this case we have restricted it to available enrollments viewable for
current
    user:

    /api/33/enrollments.json?ouMode=ACCESSIBLE&trackedEntityInstance=tphfdyIiVL6

By default the enrollments are returned in pages of size 50, to change
this you can use the page and pageSize query
    parameters:

    /api/33/enrollments.json?ou=O6uvpzGd5pu&ouMode=DESCENDANTS&page=2&pageSize=3

##### Response format

<!--DHIS2-SECTION-ID:webapi_enrollment_query_response_format-->

This resource supports JSON, JSONP, XLS and CSV resource
representations.

  - json (application/json)

  - jsonp (application/javascript)

  - xml (application/xml)

The response in JSON/XML is in object format and can look like the
following. Please note that field filtering is supported, so if you want
a full view, you might want to add `fields=*` to the query:

```json
{
  "enrollments": [
    {
      "lastUpdated": "2014-03-28T05:27:48.512+0000",
      "trackedEntity": "cyl5vuJ5ETQ",
      "created": "2014-03-28T05:27:48.500+0000",
      "orgUnit": "DiszpKrYNg8",
      "program": "ur1Edk5Oe2n",
      "enrollment": "HLFOK0XThjr",
      "trackedEntityInstance": "qv0j4JBXQX0",
      "followup": false,
      "enrollmentDate": "2013-05-23T05:27:48.490+0000",
      "incidentDate": "2013-05-10T05:27:48.490+0000",
      "status": "ACTIVE"
    }
  ]
}
```

### Events

<!--DHIS2-SECTION-ID:webapi_events-->

This section is about sending and reading events.

    /api/33/events

#### Sending events

<!--DHIS2-SECTION-ID:webapi_sending_events-->

DHIS2 supports three kinds of events: single events with no registration
(also referred to as anonymous events), single event with registration
and multiple events with registration. Registration implies that the
data is linked to a tracked entity instance which is identified using
some sort of identifier.

To send events to DHIS2 you must interact with the *events* resource.
The approach to sending events is similar to sending aggregate data
values. You will need a *program* which can be looked up using the
*programs* resource, an *orgUnit* which can be looked up using the
*organisationUnits* resource, and a list of valid data element
identifiers which can be looked up using the *dataElements* resource.
For events with registration, a *tracked entity instance* identifier is
required, read about how to get this in the section about the
*trackedEntityInstances* resource. For sending events to programs with
multiple stages, you will need to also include the *programStage*
identifier, the identifiers for programStages can be found in the
*programStages* resource.

A simple single event with no registration example payload in XML format
where we send events from the "Inpatient morbidity and mortality"
program for the "Ngelehun CHC" facility in the demo database can be seen
below:

```xml
<?xml version="1.0" encoding="utf-8"?>
<event program="eBAyeGv0exc" orgUnit="DiszpKrYNg8"
  eventDate="2013-05-17" status="COMPLETED" storedBy="admin">
  <coordinate latitude="59.8" longitude="10.9" />
  <dataValues>
    <dataValue dataElement="qrur9Dvnyt5" value="22" />
    <dataValue dataElement="oZg33kd9taw" value="Male" />
    <dataValue dataElement="msodh3rEMJa" value="2013-05-18" />
  </dataValues>
</event>
```

To perform some testing we can save the XML payload as a file
called*event.xml* and send it as a POST request to the events resource
in the API using curl with the following command:

```bash
curl -d @event.xml "https://play.dhis2.org/demo/api/33/events"
  -H "Content-Type:application/xml" -u admin:district
```

The same payload in JSON format looks like this:

```json
{
  "program": "eBAyeGv0exc",
  "orgUnit": "DiszpKrYNg8",
  "eventDate": "2013-05-17",
  "status": "COMPLETED",
  "completedDate": "2013-05-18",
  "storedBy": "admin",
  "coordinate": {
    "latitude": 59.8,
    "longitude": 10.9
  },
  "dataValues": [
    {
      "dataElement": "qrur9Dvnyt5", 
      "value": "22"
    },
    {
      "dataElement": "oZg33kd9taw", 
      "value": "Male"
    }, 
    {
      "dataElement": "msodh3rEMJa", 
      "value": "2013-05-18"
    }
  ]
}
```

To send this you can save it to a file called *event.json* and use curl
like this:

```bash
curl -d @event.json "localhost/api/33/events" -H "Content-Type:application/json"
  -u admin:district
```

We also support sending multiple events at the same time. A payload in
XML format might look like this:

```xml
<?xml version="1.0" encoding="utf-8"?>
<events>
  <event program="eBAyeGv0exc" orgUnit="DiszpKrYNg8"
    eventDate="2013-05-17" status="COMPLETED" storedBy="admin">
    <coordinate latitude="59.8" longitude="10.9" />
    <dataValues>
      <dataValue dataElement="qrur9Dvnyt5" value="22" />
      <dataValue dataElement="oZg33kd9taw" value="Male" />
    </dataValues>
  </event>
  <event program="eBAyeGv0exc" orgUnit="DiszpKrYNg8"
    eventDate="2013-05-17" status="COMPLETED" storedBy="admin">
    <coordinate latitude="59.8" longitude="10.9" />
    <dataValues>
      <dataValue dataElement="qrur9Dvnyt5" value="26" />
      <dataValue dataElement="oZg33kd9taw" value="Female" />
    </dataValues>
  </event>
</events>
```

You will receive an import summary with the response which can be
inspected in order to get information about the outcome of the request,
like how many values were imported successfully. The payload in JSON
format looks like this:

```json
{
  "events": [
  {
    "program": "eBAyeGv0exc",
    "orgUnit": "DiszpKrYNg8",
    "eventDate": "2013-05-17",
    "status": "COMPLETED",
    "storedBy": "admin",
    "coordinate": {
      "latitude": "59.8",
      "longitude": "10.9"
    },
    "dataValues": [
      {
        "dataElement": "qrur9Dvnyt5", 
        "value": "22"
      },
      {
        "dataElement": "oZg33kd9taw", 
        "value": "Male"
      }
    ]
  },
  {
    "program": "eBAyeGv0exc",
    "orgUnit": "DiszpKrYNg8",
    "eventDate": "2013-05-17",
    "status": "COMPLETED",
    "storedBy": "admin",
    "coordinate": {
      "latitude": "59.8",
      "longitude": "10.9"
    },
    "dataValues": [
      {
        "dataElement": "qrur9Dvnyt5", 
        "value": "26"
      },
      {
        "dataElement": "oZg33kd9taw", 
        "value": "Female"
      }
    ]
  } ]
}
```

You can also use GeoJson to store any kind of geometry on your event. An example payload using GeoJson instead of the former latitude and longitude properties can be seen here:

```json
{
  "program": "eBAyeGv0exc",
  "orgUnit": "DiszpKrYNg8",
  "eventDate": "2013-05-17",
  "status": "COMPLETED",
  "storedBy": "admin",
  "geometry": {
    "type": "POINT",
    "coordinates": [59.8, 10.9]
  },
  "dataValues": [
    {
      "dataElement": "qrur9Dvnyt5", 
      "value": "22"
    }, 
    { 
      "dataElement": "oZg33kd9taw", 
      "value": "Male"
    }, 
    {
      "dataElement": "msodh3rEMJa", 
      "value": "2013-05-18"
    }
  ]
}
```

As part of the import summary you will also get the identifier
*reference* to the event you just sent, together with a *href* element
which points to the server location of this event. The table below
describes the meaning of each element.

<table>
<caption>Events resource format</caption>
<colgroup>
<col style="width: 13%" />
<col style="width: 8%" />
<col style="width: 8%" />
<col style="width: 30%" />
<col style="width: 38%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Type</th>
<th>Required</th>
<th>Options (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>program</td>
<td>string</td>
<td>true</td>
<td></td>
<td>Identifier of the single event with no registration program</td>
</tr>
<tr class="even">
<td>orgUnit</td>
<td>string</td>
<td>true</td>
<td></td>
<td>Identifier of the organisation unit where the event took place</td>
</tr>
<tr class="odd">
<td>eventDate</td>
<td>date</td>
<td>true</td>
<td></td>
<td>The date of when the event occurred</td>
</tr>
<tr class="even">
<td>completedDate</td>
<td>date</td>
<td>false</td>
<td></td>
<td>The date of when the event is completed. If not provided, the current date is selected as the event completed date</td>
</tr>
<tr class="odd">
<td>status</td>
<td>enum</td>
<td>false</td>
<td>ACTIVE | COMPLETED | VISITED | SCHEDULE | OVERDUE | SKIPPED</td>
<td>Whether the event is complete or not</td>
</tr>
<tr class="even">
<td>storedBy</td>
<td>string</td>
<td>false</td>
<td>Defaults to current user</td>
<td>Who stored this event (can be username, system-name, etc)</td>
</tr>
<tr class="odd">
<td>coordinate</td>
<td>double</td>
<td>false</td>
<td></td>
<td>Refers to where the event took place geographically (latitude and longitude)</td>
</tr>
<tr class="even">
<td>dataElement</td>
<td>string</td>
<td>true</td>
<td></td>
<td>Identifier of data element</td>
</tr>
<tr class="odd">
<td>value</td>
<td>string</td>
<td>true</td>
<td></td>
<td>Data value or measure for this event</td>
</tr>
</tbody>
</table>

##### OrgUnit matching

By default the orgUnit parameter will match on the
ID, you can also select the orgUnit id matching scheme by using the
parameter orgUnitIdScheme=SCHEME, where the options are: *ID*, *UID*,
*UUID*, *CODE*, and *NAME*. There is also the *ATTRIBUTE:* scheme, which
matches on a *unique* metadata attribute value.

#### Updating events

<!--DHIS2-SECTION-ID:webapi_updating_events-->

To update an existing event, the format of the payload is the same, but
the URL you are posting to must add the identifier to the end of the URL
string and the request must be PUT.

The payload has to contain all, even non-modified, attributes.
Attributes that were present before and are not present in the current
payload any more will be removed by the system.

It is not allowed to update an already deleted event. The same applies
to tracked entity instance and enrollment.

```bash
curl -X PUT -d @updated_event.xml "localhost/api/33/events/ID"
  -H "Content-Type: application/xml" -u admin:district
```

```bash
curl -X PUT -d @updated_event.json "localhost/api/33/events/ID"
  -H "Content-Type: application/json" -u admin:district
```

#### Deleting events

<!--DHIS2-SECTION-ID:webapi_deleting_events-->

To delete an existing event, all you need is to send a DELETE request
with an identifier reference to the server you are using.

```bash
curl -X DELETE "localhost/api/33/events/ID" -u admin:district
```

#### Assigning user to events

<!--DHIS2-SECTION-ID:webapi_user_assign_event-->

A user can be assigned to an event. This can be done by including the appropriate property in the payload when updating or creating the event. 

      "assignedUser": "<id>"

The id refers to the if of the user. Only one user can be assigned to an event at a time.

User assignment must be enabled in the program stage before users can be assigned to events.
#### Getting events

<!--DHIS2-SECTION-ID:webapi_getting_events-->

To get an existing event you can issue a GET request including the
identifier like this:

```bash
curl "http://localhost/api/33/events/ID" -H "Content-Type: application/xml" -u admin:district
```

#### Querying and reading events

<!--DHIS2-SECTION-ID:webapi_querying_reading_events-->

This section explains how to read out the events that have been stored
in the DHIS2 instance. For more advanced uses of the event data, please
see the section on event analytics. The output format from the
`/api/events` endpoint will match the format that is used to send events
to it (which the analytics event api does not support). Both XML and
JSON are supported, either through adding .json/.xml or by setting the
appropriate *Accept* header. The query is paged by default and the
default page size is 50 events, *field* filtering works as it does for
metadata, add the *fields* parameter and include your wanted properties,
i.e. *?fields=program,status*.

<table>
<caption>Events resource query parameters</caption>
<thead>
<tr class="header">
<th>Key</th>
<th>Type</th>
<th>Required</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>program</td>
<td>identifier</td>
<td>true (if not programStage is provided)</td>
<td>Identifier of program</td>
</tr>
<tr class="even">
<td>programStage</td>
<td>identifier</td>
<td>false</td>
<td>Identifier of program stage</td>
</tr>
<tr class="odd">
<td>programStatus</td>
<td>enum</td>
<td>false</td>
<td>Status of event in program, ca be ACTIVE | COMPLETED | CANCELLED</td>
</tr>
<tr class="even">
<td>followUp</td>
<td>boolean</td>
<td>false</td>
<td>Whether event is considered for follow up in program, can be true | false or omitted.</td>
</tr>
<tr class="odd">
<td>trackedEntityInstance</td>
<td>identifier</td>
<td>false</td>
<td>Identifier of tracked entity instance</td>
</tr>
<tr class="even">
<td>orgUnit</td>
<td>identifier</td>
<td>true</td>
<td>Identifier of organisation unit</td>
</tr>
<tr class="odd">
<td>ouMode</td>
<td>enum</td>
<td>false</td>
<td>Org unit selection mode, can be SELECTED | CHILDREN | DESCENDANTS</td>
</tr>
<tr class="even">
<td>startDate</td>
<td>date</td>
<td>false</td>
<td>Only events newer than this date</td>
</tr>
<tr class="odd">
<td>endDate</td>
<td>date</td>
<td>false</td>
<td>Only events older than this date</td>
</tr>
<tr class="even">
<td>status</td>
<td>enum</td>
<td>false</td>
<td>Status of event, can be ACTIVE | COMPLETED | VISITED | SCHEDULED | OVERDUE | SKIPPED</td>
</tr>
<tr class="odd">
<td>lastUpdatedStartDate</td>
<td>date</td>
<td>false</td>
<td>Filter for events which were updated after this date. Cannot be used together with <em>lastUpdatedDuration</em>.</td>
</tr>
<tr class="even">
<td>lastUpdatedEndDate</td>
<td>date</td>
<td>false</td>
<td>Filter for events which were updated up until this date. Cannot be used together with <em>lastUpdatedDuration</em>.</td>
</tr>
<tr class="odd">
<td>lastUpdatedDuration</td>
<td>string</td>
<td>false</td>
<td>Include only items which are updated within the given duration. The format is <value><time-unit>, where the supported time units are “d” (days), “h” (hours), “m” (minutes) and “s” (seconds). Cannot be used together with <em>lastUpdatedStartDate</em> and/or <em>lastUpdatedEndDate</em>.</td>
</tr>
<tr class="even">
<td>skipMeta</td>
<td>boolean</td>
<td>false</td>
<td>Exclude the meta data part of response (improves performance)</td>
</tr>
<tr class="odd">
<td>page</td>
<td>integer</td>
<td>false</td>
<td>Page number</td>
</tr>
<tr class="even">
<td>pageSize</td>
<td>integer</td>
<td>false</td>
<td>Number of items in each page</td>
</tr>
<tr class="odd">
<td>totalPages</td>
<td>boolean</td>
<td>false</td>
<td>Indicates whether to include the total number of pages in the paging response.</td>
</tr>
<tr class="even">
<td>skipPaging</td>
<td>boolean</td>
<td>false</td>
<td>Indicates whether to skip paging in the query and return all events.</td>
</tr>
<tr class="odd">
<td>dataElementIdScheme</td>
<td>string</td>
<td>false</td>
<td>Data element ID scheme to use for export, valid options are UID, CODE and ATTRIBUTE:{ID}</td>
</tr>
<tr class="even">
<td>categoryOptionComboIdScheme</td>
<td>string</td>
<td>false</td>
<td>Category Option Combo ID scheme to use for export, valid options are UID, CODE and 
ATTRIBUTE:{ID}</td>
</tr>
<tr class="odd">
<td>orgUnitIdScheme</td>
<td>string</td>
<td>false</td>
<td>Organisation Unit ID scheme to use for export, valid options are UID, CODE and 
ATTRIBUTE:{ID}</td>
</tr>
<tr class="even">
<td>programIdScheme</td>
<td>string</td>
<td>false</td>
<td>Program ID scheme to use for export, valid options are UID, CODE and ATTRIBUTE:{ID}</td>
</tr>
<tr class="odd">
<td>programStageIdScheme</td>
<td>string</td>
<td>false</td>
<td>Program Stage ID scheme to use for export, valid options are UID, CODE and ATTRIBUTE:{ID}</td>
</tr>
<tr class="even">
<td>idScheme</td>
<td>string</td>
<td>false</td>
<td>Allows to set id scheme for data element, category option combo, orgUnit, program and program 
stage at once.</td>
</tr>
<tr class="odd">
<td>order</td>
<td>string</td>
<td>false</td>
<td>The order of which to retrieve the events from the API. Usage: order=&lt;property&gt;:asc/desc - Ascending order is default.
<p>Properties: event | program | programStage | enrollment | enrollmentStatus | orgUnit | orgUnitName | trackedEntityInstance | eventDate | followup | status | dueDate | storedBy | created | lastUpdated | completedBy | completedDate</p>
<pre><code>order=orgUnitName:DESC</code></pre>
<pre><code>order=lastUpdated:ASC</code></pre></td>
</tr>
<tr class="even">
<td>event</td>
<td>comma delimited string</td>
<td>false</td>
<td>Filter the result down to a limited set of IDs by using <em>event=id1;id2</em>.</td>
</tr>
<tr class="odd">
<td>skipEventId</td>
<td>boolean</td>
<td>false</td>
<td>Skips event identifiers in the response</td>
</tr>
<tr class="even">
<td>attributeCc (**)</td>
<td>string</td>
<td>false</td>
<td>Attribute category combo identifier (must be combined with <em>attributeCos</em>)</td>
</tr>
<tr class="odd">
<td>attributeCos (**)</td>
<td>string</td>
<td>false</td>
<td>Attribute category option identifiers, separated with ; (must be combined with <em>attributeCc</em>)</td>
</tr>
<tr class="even">
<td>async</td>
<td>false | true</td>
<td>false</td>
<td>Indicates whether the import should be done asynchronous or synchronous.</td>
</tr>
<tr class="odd">
<td>includeDeleted</td>
<td>boolean</td>
<td>false</td>
<td>When true, soft deleted events will be included in your query result.</td>
</tr>
<tr class="even">
<td>assignedUserMode</td>
<td>enum</td>
<td>false</td>
<td>Assigned user selection mode, can be CURRENT | PROVIDED | NONE | ANY.</td>
</tr>
<tr class="odd">
<td>assignedUser</td>
<td>comma delimited strings</td>
<td>false</td>
<td>Filter the result down to a limited set of events that are assigned to the given user IDs by using <em>assignedUser=id1;id2</em>. This parameter will be considered only if assignedUserMode is either PROVIDED or null. The API will error out, if for example, assignedUserMode=CURRENT and assignedUser=someId</td>
</tr>
</tbody>
</table>

> **Note**
>
> If the query contains neither `attributeCC` nor `attributeCos`, the server returns events for all attribute option combos where the user has read access.

##### Examples

Query for all events with children of a certain organisation unit:

    /api/29/events.json?orgUnit=YuQRtpLP10I&ouMode=CHILDREN

Query for all events with all descendants of a certain organisation
unit, implying all organisation units in the sub-hierarchy:

    /api/33/events.json?orgUnit=O6uvpzGd5pu&ouMode=DESCENDANTS

Query for all events with a certain program and organisation unit:

    /api/33/events.json?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc

Query for all events with a certain program and organisation unit,
sorting by due date
    ascending:

    /api/33/events.json?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc&order=dueDate

Query for the 10 events with the newest event date in a certain program
and organisation unit - by paging and ordering by due date descending:

    /api/33/events.json?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc
      &order=eventDate:desc&pageSize=10&page=1

Query for all events with a certain program and organisation unit for a
specific tracked entity instance:

    /api/33/events.json?orgUnit=DiszpKrYNg8
      &program=eBAyeGv0exc&trackedEntityInstance=gfVxE3ALA9m

Query for all events with a certain program and organisation unit older
or equal to
    2014-02-03:

    /api/33/events.json?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc&endDate=2014-02-03

Query for all events with a certain program stage, organisation unit and
tracked entity instance in the year 2014:

    /api/33/events.json?orgUnit=DiszpKrYNg8&program=eBAyeGv0exc
      &trackedEntityInstance=gfVxE3ALA9m&startDate=2014-01-01&endDate=2014-12-31

Query files associated with event data values. In the specific case of fetching an image file an 
additional parameter can be provided to fetch the image with different dimensions. If dimension is 
not provided, the system will return the original image. The parameter will be ignored in case of 
fetching non-image files e.g pdf. Possible dimension values are *small(254 x 254), 
medium(512 x 512), large(1024 x 1024) or original*. Any value other than those mentioned will be 
discarded and the original image will be returned.

    /api/33/events/files?eventUid=hcmcWlYkg9u&dataElementUid=C0W4aFuVm4P&dimension=small

Retrieve events with specified Organisation unit and Program, and use _Attribute:Gq0oWTf2DtN_ as 
identifier scheme
    
    /api/events?orgUnit=DiszpKrYNg8&program=lxAQ7Zs9VYR&idScheme=Attribute:Gq0oWTf2DtN

Retrieve events with specified Organisation unit and Program, and use UID as identifier scheme for 
orgUnits, Code as identifier scheme for Program stages, and _Attribute:Gq0oWTf2DtN_ as identifier 
scheme for the rest of the metadata with assigned attribute.
    
    api/events.json?orgUnit=DiszpKrYNg8&program=lxAQ7Zs9VYR&idScheme=Attribute:Gq0oWTf2DtN
      &orgUnitIdScheme=UID&programStageIdScheme=Code

#### Event grid query

In addition to the above event query end point, there is an event grid
query end point where a more compact "grid" format of events are
returned. This is possible by interacting with
/api/events/query.json|xml|xls|csv endpoint.

    /api/33/events/query

Most of the query parameters mentioned in event querying and reading
section above are valid here. However, since the grid to be returned
comes with specific set of columns that apply to all rows (events), it
is mandatory to specify a program stage. It is not possible to mix
events from different programs or program stages in the return.

Returning events from a single program stage, also opens up for new
functionality - for example sorting and searching events based on their
data element values. api/events/query has support for this. Below are
some examples

A query to return an event grid containing only selected data elements
for a program stage

    /api/33/events/query.json?orgUnit=DiszpKrYNg8&programStage=Zj7UnCAulEk
      &dataElement=qrur9Dvnyt5,fWIAEtYVEGk,K6uUAvq500H&order=lastUpdated:desc
      &pageSize=50&page=1&totalPages=true

A query to return an event grid containing all data elements of a
program
    stage

    /api/33/events/query.json?orgUnit=DiszpKrYNg8&programStage=Zj7UnCAulEk
      &includeAllDataElements=true

A query to filter events based on data element
    value

    /api/33/events/query.json?orgUnit=DiszpKrYNg8&programStage=Zj7UnCAulEk
      &filter=qrur9Dvnyt5:GT:20:LT:50

In addition to the filtering, the above example also illustrates one
thing: the fact that there are no data elements mentioned to be returned
in the grid. When this happens, the system defaults back to return only
those data elements marked "Display in report" under program stage
configuration.

We can also extend the above query to return us a grid sorted (asc|desc)
based on data element
    value

    /api/33/events/query.json?orgUnit=DiszpKrYNg8&programStage=Zj7UnCAulEk
      &filter=qrur9Dvnyt5:GT:20:LT:50&order=qrur9Dvnyt5:desc

#### Event filters

<!--DHIS2-SECTION-ID:webapi_event_filters-->

To create, read, update and delete event filters you
can interact with the `/api/eventFilters` resource.

    /api/33/eventFilters

##### Create and update an event filter definition

For creating and updating an event filter in the
system, you will be working with the *eventFilters*
resource. *POST* is used to create and *PUT* method is used to update. The event filter definitions are used in the
Tracker Capture app to display relevant predefined "Working lists" in
the tracker user interface.

<table>
<caption>Request Payload</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Request Property</th>
<th>Description</th>
<th>Example</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>Name of the filter.</td>
<td>"name":"My working list"</td>
</tr>
<tr class="even">
<td>description</td>
<td>A description of the filter.</td>
<td>"description":"for listing all events assigned to me".</td>
</tr>
<tr class="odd">
<td>program</td>
<td>The uid of the program.</td>
<td>"program" : "a3kGcGDCuk6"</td>
</tr>
<tr class="even">
<td>programStage</td>
<td>The uid of the program stage.</td>
<td>"programStage" : "a3kGcGDCuk6"</td>
</tr>
<tr class="even">
<td>eventQueryCriteria</td>
<td>Object containing parameters for querying, sorting and filtering events.</td>
<td>  
  "eventQueryCriteria": {
    "organisationUnit":"a3kGcGDCuk6",
    "status": "COMPLETED",
    "createdDate": {
      "from": "2014-05-01",
      "to": "2019-03-20"
    },
    "dataElements": ["a3kGcGDCuk6:EQ:1", "a3kGcGDCuk6"],
    "filters": ["a3kGcGDCuk6:EQ:1"],
    "programStatus": "ACTIVE",
    "ouMode": "SELECTED",
    "assignedUserMode": "PROVIDED",
    "assignedUsers" : ["a3kGcGDCuk7", "a3kGcGDCuk8"],
    "followUp": false,
    "trackedEntityInstance": "a3kGcGDCuk6",
    "events": ["a3kGcGDCuk7", "a3kGcGDCuk8"],
    "fields": "eventDate,dueDate",
    "order": "dueDate:asc,createdDate:desc"
  }
</td>
</tr>
</tbody>
</table>

<table>
<caption>Event Query Criteria definition</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td>followUp</td>
<td>Used to filter events based on enrollment followUp flag. Possible values are true|false.</td>
<td>"followUp": true</td>
</tr>
<tr class="even">
<td>organisationUnit</td>
<td>To specify the uid of the organisation unit</td>
<td>"organisationUnit": "a3kGcGDCuk7"</td>
</tr>
<tr class="odd">
<td>ouMode</td>
<td>To specify the OU selection mode. Possible values are SELECTED| CHILDREN|DESCENDANTS|ACCESSIBLE|CAPTURE|ALL</td>
<td>"ouMode": "SELECTED"</td>
</tr>
<tr class="even">
<td>assignedUserMode</td>
<td>To specify the assigned user selection mode for events. Possible values are CURRENT| PROVIDED| NONE | ANY. See table below to understand what each value indicates. If PROVIDED (or null), non-empty assignedUsers in the payload will be considered.</td>
<td>"assignedUserMode": "PROVIDED"</td>
</tr>
<tr class="odd">
<td>assignedUsers</td>
<td>To specify a list of assigned users for events. To be used along with PROVIDED assignedUserMode above.</td>
<td>"assignedUsers": ["a3kGcGDCuk7", "a3kGcGDCuk8"]</td>
</tr>
<tr class="even">
<td>displayOrderColumns</td>
<td>To specify the output ordering of columns</td>
<td>"displayOrderColumns": ["eventDate", "dueDate", "program"]</td>
</tr>
<tr class="odd">
<td>order</td>
<td>To specify ordering/sorting of fields and its directions in comma separated values. A single item in order is of the form "dataItem:direction".</td>
<td>"order"="a3kGcGDCuk6:desc,eventDate:asc"</td>
</tr>
<tr class="even">
<td>dataFilters</td>
<td>To specify filters to be applied when listing events</td>
<td>"dataFilters"=[{
      "dataItem": "abcDataElementUid",
      "le": "20",
      "ge": "10",
      "lt": "20",
      "gt": "10",
      "in": ["India", "Norway"],
      "like": "abc",
      "dateFilter": {
        "startDate": "2014-05-01",
        "endDate": "2019-03-20",
        "startBuffer": -5,
        "endBuffer": 5,
        "period": "LAST_WEEK",
        "type": "RELATIVE"
      }
    }]</td>
</tr>
<tr class="odd">
<td>status</td>
<td> Any valid EventStatus</td>
<td>  "eventStatus": "COMPLETED"</td>
</tr>
<tr class="even">
<td>events</td>
<td>To specify list of events</td>
<td>"events"=["a3kGcGDCuk6"]</td>
</tr>
<tr class="odd">
<td>completedDate</td>
<td>DateFilterPeriod object date filtering based on completed date.</td>
<td>
  "completedDate": {
    "startDate": "2014-05-01",
    "endDate": "2019-03-20",
    "startBuffer": -5,
    "endBuffer": 5,
    "period": "LAST_WEEK",
    "type": "RELATIVE"
  }
</td>
</tr>
<tr class="even">
<td>eventDate</td>
<td>DateFilterPeriod object date filtering based on event date.</td>
<td>
  "eventDate": {
    "startBuffer": -5,
    "endBuffer": 5,
    "type": "RELATIVE"
  }
</td>
</tr>
<tr class="odd">
<td>dueDate</td>
<td>DateFilterPeriod object date filtering based on due date.</td>
<td>
  "dueDate": {
    "period": "LAST_WEEK",
    "type": "RELATIVE"
  }
</td>
</tr>
<tr class="even">
<td>lastUpdatedDate</td>
<td>DateFilterPeriod object date filtering based on last updated date.</td>
<td>
  "lastUpdatedDate": {
    "startDate": "2014-05-01",
    "endDate": "2019-03-20",
    "type": "ABSOLUTE"
  }
</td>
</tr>

</tbody>
</table>

<table>
<caption>DateFilterPeriod object definition</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td>type</td>
<td>Specify whether the date period type is ABSOLUTE | RELATIVE</td>
<td>"type" : "RELATIVE"</td>
</tr>
<tr class="even">
<td>period</td>
<td>Specify if a relative system defined period is to be used. Applicable only when "type" is RELATIVE. (see <a href="#webapi_date_relative_period_values">Relative Periods</a> for supported relative periods)</td>
<td>"period" : "THIS_WEEK"</td>
</tr>
<tr class="odd">
<td>startDate</td>
<td>Absolute start date. Applicable only when "type" is ABSOLUTE</td>
<td>"startDate":"2014-05-01"</td>
</tr>
<tr class="even">
<td>endDate</td>
<td>Absolute end date. Applicable only when "type" is ABSOLUTE</td>
<td>"startDate":"2014-05-01"</td>
</tr>
<tr class="odd">
<td>startBuffer</td>
<td>Relative custom start date. Applicable only when "type" is RELATIVE</td>
<td>"startBuffer":-10</td>
</tr>
<tr class="even">
<td>endBuffer</td>
<td>Relative custom end date. Applicable only when "type" is RELATIVE</td>
<td>"startDate":+10</td>
</tr>
</tbody>
</table>

The available assigned user selection modes are explained in the
following table.

<table>
<caption>Assigned user selection modes (event assignment)</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th>Mode</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>CURRENT</td>
<td>Assigned to the current logged in user</td>
</tr>
<tr class="even">
<td>PROVIDED</td>
<td>Assigned to the users provided in the "assignedUser" parameter</td>
</tr>
<tr class="odd">
<td>NONE</td>
<td>Assigned to no users.</td>
</tr>
<tr class="even">
<td>ANY</td>
<td>Assigned to any users.</td>
</tr>
</tbody>
</table>

A sample payload that can be used to create/update an eventFilter is shown below.

```json
{
  "program": "ur1Edk5Oe2n",
  "description": "Simple Filter for TB events",
  "name": "TB events",
  "eventQueryCriteria": {
    "organisationUnit":"DiszpKrYNg8",
    "eventStatus": "COMPLETED",
    "eventDate": {
      "startDate": "2014-05-01",
      "endDate": "2019-03-20",
      "startBuffer": -5,
      "endBuffer": 5,
      "period": "LAST_WEEK",
      "type": "RELATIVE"
    },
    "dataFilters": [{
      "dataItem": "abcDataElementUid",
      "le": "20",
      "ge": "10",
      "lt": "20",
      "gt": "10",
      "in": ["India", "Norway"],
      "like": "abc"
    },
    {
      "dataItem": "dateDataElementUid",
      "dateFilter": {
        "startDate": "2014-05-01",
        "endDate": "2019-03-20",
        "type": "ABSOLUTE"
      }
    },
    {
      "dataItem": "anotherDateDataElementUid",
      "dateFilter": {
        "startBuffer": -5,
        "endBuffer": 5,
        "type": "RELATIVE"
      }
    },
    {
      "dataItem": "yetAnotherDateDataElementUid",
      "dateFilter": {
        "period": "LAST_WEEK",
        "type": "RELATIVE"
      }
    }],
    "programStatus": "ACTIVE"
  }
}
```


##### Retrieving and deleting event filters

A specific event filter can be retrieved by using the following api

    GET /api/33/eventFilters/{uid}

All event filters can be retrieved by using the following api.

    GET /api/33/eventFilters?fields=*

All event filters for a specific program can be retrieved by using the following api

    GET /api/33/eventFilters?filter=program:eq:IpHINAT79UW

An event filter can be deleted by using the following api

    DELETE /api/33/eventFilters/{uid}

### Relationships
Relationships are links between two entities in tracker. These entities can be tracked entity instances, enrollments and events.

There are multiple endpoints that allow you to see, create, delete and update relationships. The most common is the /api/trackedEntityInstances endpoint, where you can include relationships in the payload to create, update or deleting them if you omit them - Similar to how you work with enrollments and events in the same endpoint. All the tracker endpoints, /api/trackedEntityInstances, /api/enrollments and /api/events also list their relationships if requested in the field filter.

The standard endpoint for relationships is, however, /api/relationships. This endpoint provides all the normal CRUD operations for relationships.

List all relationships require you to provide the UID of the trackedEntityInstance, Enrollment or event that you want to list all the relationships for:  

    GET /api/relationships?tei=ABCDEF12345
    GET /api/relationships?enrollment=ABCDEF12345
    GET /api/relationships?event=ABCDEF12345

This request will return a list of any relationship you have access to see that includes the trackedEntityInstance, enrollment or event you specified. Each relationship is represented with the following JSON:

```json
{
  "relationshipType": "dDrh5UyCyvQ",
  "relationshipName": "Mother-Child",
  "relationship": "t0HIBrc65Rm",
  "bidirectional": false,
  "from": {
    "trackedEntityInstance": {
      "trackedEntityInstance": "vOxUH373fy5"
    }
  },
  "to": {
    "trackedEntityInstance": {
      "trackedEntityInstance": "pybd813kIWx"
    }
  },
  "created": "2019-04-26T09:30:56.267",
  "lastUpdated": "2019-04-26T09:30:56.267"
}
```

You can also view specified relationships using the following endpoint:

    GET /api/relationships/<id>

To create or update a relationship, you can use the following endpoints:

    POST /api/relationships
    PUT /api/relationships

And use the following payload structure:

```json
{
  "relationshipType": "dDrh5UyCyvQ",
  "from": {
    "trackedEntityInstance": {
      "trackedEntityInstance": "vOxUH373fy5"
    }
  },
  "to": {
    "trackedEntityInstance": {
      "trackedEntityInstance": "pybd813kIWx"
    }
  }
}
```

To delete a relationship, you can use this endpoint:

      DELETE /api/relationships/<id>

In our example payloads, we use a relationship between trackedEntityInstances. Because of this, the "from" and "to" properties of our payloads include "trackedEntityInstance" objects. If your relationship includes other entities, you can use the following properties:

```json
{
  "enrollment": {
    "enrollment": "<id>"
  }
}
```

```json
{
  "event": {
    "event": "<id>"
  }
}
```

### Update strategies

<!--DHIS2-SECTION-ID:webapi_tei_update_strategies-->

Two update strategies for all 3 tracker endpoints are supported:
enrollment and event creation. This is useful when you have generated an
identifier on the client side and are not sure if it was created or not
on the server.

<table>
<caption>Available tracker strategies</caption>
<colgroup>
<col style="width: 24%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>CREATE</td>
<td>Create only, this is the default behavior.</td>
</tr>
<tr class="even">
<td>CREATE_AND_UPDATE</td>
<td>Try and match the ID, if it exist then update, if not create.</td>
</tr>
</tbody>
</table>

To change the parameter, please use the strategy parameter:

    POST /api/33/trackedEntityInstances?strategy=CREATE_AND_UPDATE

### Tracker bulk deletion

<!--DHIS2-SECTION-ID:webapi_tracker_bulk_deletion-->

Bulk deletion of tracker objects work in a similar fashion to adding and
updating tracker objects, the only difference is that the
`importStrategy` is *DELETE*.

*Example: Bulk deletion of tracked entity instances:*

```json
{
  "trackedEntityInstances": [
    {
      "trackedEntityInstance": "ID1"
    }, { 
      "trackedEntityInstance": "ID2"
    }, { 
      "trackedEntityInstance": "ID3"
    }
  ]
}
```

```bash
curl -X POST -d @data.json -H "Content-Type: application/json"
  "http://server/api/33/trackedEntityInstances?strategy=DELETE"
```

*Example: Bulk deletion of enrollments:*

```json
{
  "enrollments": [
    {
       "enrollment": "ID1"
    }, { 
      "enrollment": "ID2" 
    }, { 
      "enrollment": "ID3"
    }
  ]
}
```

```bash
curl -X POST -d @data.json -H "Content-Type: application/json"
  "http://server/api/33/enrollments?strategy=DELETE"
```

*Example: Bulk deletion of events:*

```json
{
  "events": [
    {
      "event": "ID1"
    }, { 
      "event": "ID2"
    }, { 
      "event": "ID3"
    }
  ]
}
```

```bash
curl -X POST -d @data.json -H "Content-Type: application/json"
  "http://server/api/33/events?strategy=DELETE"
```

### Identifier reuse and item deletion via POST and PUT methods

<!--DHIS2-SECTION-ID:webapi_updating_and_deleting_items-->

Tracker endpoints */trackedEntityInstances*, */enrollments*, */events*
support CRUD operations. The system keeps track of used identifiers.
Therefore, an item which has been created and then deleted (e.g. events,
enrollments) cannot be created or updated again. If attempting to delete
an already deleted item, the system returns a success response as
deletion of an already deleted item implies no change.

The system does not allow to delete an item via an update (*PUT*) or
create (*POST*) method. Therefore, an attribute *deleted* is ignored in
both *PUT* and *POST* methods, and in *POST* method it is by default set
to *false*.

### Import parameters

<!--DHIS2-SECTION-ID:webapi_import_parameters-->

The import process can be customized using a set of import parameters:

<table>
<caption>Import parameters</caption>
<thead>
<tr class="header">
<th>Parameter</th>
<th>Values (default first)</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>dataElementIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the data element object to use to map the data values.</td>
</tr>
<tr class="even">
<td>orgUnitIdScheme</td>
<td>id | name | code | attribute:ID</td>
<td>Property of the org unit object to use to map the data values.</td>
</tr>
<tr class="odd">
<td>idScheme</td>
<td>id | name | code| attribute:ID</td>
<td>Property of all objects including data elements, org units and category option combos, to use to map the data values.</td>
</tr>
<tr class="even">
<td>dryRun</td>
<td>false | true</td>
<td>Whether to save changes on the server or just return the import summary.</td>
</tr>
<tr class="odd">
<td>strategy</td>
<td>CREATE | UPDATE | CREATE_AND_UPDATE | DELETE</td>
<td>Save objects of all, new or update import status on the server.</td>
</tr>
<tr class="even">
<td>skipNotifications</td>
<td>true | false</td>
<td>Indicates whether to send notifications for completed events.</td>
</tr>
<tr class="odd">
<td>skipFirst</td>
<td>true | false</td>
<td>Relevant for CSV import only. Indicates whether CSV file contains a header row which should be skipped.</td>
</tr>
<tr class="even">
<td>importReportMode</td>
<td>FULL, ERRORS, DEBUG</td>
<td>Sets the `ImportReport` mode, controls how much is reported back after the import is done. `ERRORS` only includes <em>ObjectReports</em> for object which has errors. `FULL` returns an <em>ObjectReport</em> for all objects imported, and `DEBUG` returns the same plus a name for the object (if available).</td>
</tr>
</tbody>
</table>

#### CSV Import / Export

<!--DHIS2-SECTION-ID:webapi_events_csv_import_export-->

In addition to XML and JSON for event import/export, in DHIS2.17 we
introduced support for the CSV format. Support for this format builds on
what was described in the last section, so here we will only write about
what the CSV specific parts are.

To use the CSV format you must either use the `/api/events.csv`
endpoint, or add *content-type: text/csv* for import, and *accept:
text/csv* for export when using the `/api/events` endpoint.

The order of column in the CSV which are used for both export and import
is as follows:

<table>
<caption>CSV column</caption>
<thead>
<tr class="header">
<th>Index</th>
<th>Key</th>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td>event</td>
<td>identifier</td>
<td>Identifier of event</td>
</tr>
<tr class="even">
<td>2</td>
<td>status</td>
<td>enum</td>
<td>Status of event, can be ACTIVE | COMPLETED | VISITED | SCHEDULED | OVERDUE | SKIPPED</td>
</tr>
<tr class="odd">
<td>3</td>
<td>program</td>
<td>identifier</td>
<td>Identifier of program</td>
</tr>
<tr class="even">
<td>4</td>
<td>programStage</td>
<td>identifier</td>
<td>Identifier of program stage</td>
</tr>
<tr class="odd">
<td>5</td>
<td>enrollment</td>
<td>identifier</td>
<td>Identifier of enrollment (program instance)</td>
</tr>
<tr class="even">
<td>6</td>
<td>orgUnit</td>
<td>identifier</td>
<td>Identifier of organisation unit</td>
</tr>
<tr class="odd">
<td>7</td>
<td>eventDate</td>
<td>date</td>
<td>Event date</td>
</tr>
<tr class="even">
<td>8</td>
<td>dueDate</td>
<td>date</td>
<td>Due Date</td>
</tr>
<tr class="odd">
<td>9</td>
<td>latitude</td>
<td>double</td>
<td>Latitude where event happened</td>
</tr>
<tr class="even">
<td>10</td>
<td>longitude</td>
<td>double</td>
<td>Longitude where event happened</td>
</tr>
<tr class="odd">
<td>11</td>
<td>dataElement</td>
<td>identifier</td>
<td>Identifier of data element</td>
</tr>
<tr class="even">
<td>12</td>
<td>value</td>
<td>string</td>
<td>Value / measure of event</td>
</tr>
<tr class="odd">
<td>13</td>
<td>storedBy</td>
<td>string</td>
<td>Event was stored by (defaults to current user)</td>
</tr>
<tr class="even">
<td>14</td>
<td>providedElsewhere</td>
<td>boolean</td>
<td>Was this value collected somewhere else</td>
</tr>
<tr class="odd">
<td>14</td>
<td>completedDate</td>
<td>date</td>
<td>Completed date of event</td>
</tr>
<tr class="even">
<td>14</td>
<td>completedBy</td>
<td>string</td>
<td>Username of user who completed event</td>
</tr>
</tbody>
</table>

*Example of 2 events with 2 different data value
    each:*

```csv
EJNxP3WreNP,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,1,,
EJNxP3WreNP,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,2,,
qPEdI1xn7k0,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,3,,
qPEdI1xn7k0,COMPLETED,<pid>,<psid>,<enrollment-id>,<ou>,2016-01-01,2016-01-01,,,<de>,4,,
```

#### Import strategy: SYNC

<!--DHIS2-SECTION-ID:webapi_sync_import_strategy-->

The import strategy SYNC should be used only by internal synchronization
task and not for regular import. The SYNC strategy allows all 3
operations: CREATE, UPDATE, DELETE to be present in the payload at the
same time.

### Tracker Ownership Management

<!--DHIS2-SECTION-ID:webapi_tracker_ownership_management-->

A new concept called Tracker Ownership is introduced from 2.30. There
will now be one owner organisation unit for a tracked entity instance in
the context of a program. Programs that are configured with an access
level of *PROTECTED* or *CLOSED* will adhere to the ownership
privileges. Only those users belonging to the owning org unit for a
tracked entity-program combination will be able to access the data
related to that program for that tracked entity.

#### Tracker Ownership Override : Break the Glass

<!--DHIS2-SECTION-ID:webapi_tracker_ownership_override_api-->

It is possible to temporarily override this ownership privilege for a
program that is configured with an access level of *PROTECTED*. Any user
will be able to temporarily gain access to the program related data, if
the user specifies a reason for accessing the tracked entity-program
data. This act of temporarily gaining access is termed as *breaking the
glass*. Currently, the temporary access is granted for 3 hours. DHIS2
audits breaking the glass along with the reason specified by the user.
It is not possible to gain temporary access to a program that has been
configured with an access level of *CLOSED*. To break the glass for a
tracked entity program combination, you can issue a POST request as
shown:

    /api/33/tracker/ownership/override?trackedEntityInstance=DiszpKrYNg8
      &program=eBAyeGv0exc&reason=patient+showed+up+for+emergency+care

#### Tracker Ownership Transfer

<!--DHIS2-SECTION-ID:webapi_tracker_ownership_transfer_api-->

It is possible to transfer the ownership of a tracked entity-program
from one org unit to another. This will be useful in case of patient
referrals or migrations. Only an owner (or users who have broken the
glass) can transfer the ownership. To transfer ownership of a tracked
entity-program to another organisation unit, you can issue a PUT request
as shown:

    /api/33/tracker/ownership/transfer?trackedEntityInstance=DiszpKrYNg8
      &program=eBAyeGv0exc&ou=EJNxP3WreNP


## Potential Duplicates  

Potential duplicates are records we work with in the data deduplication feature. Due to the nature of the deduplication feature, this API endpoint is somewhat restricted.

A potential duplicate represents a single or pair of records which are suspected to be a duplicate.

The payload of a potential duplicate looks like this:

```json
{
  "teiA": "<id>",
  "teiB": "<id>",
  "status": "OPEN|INVALID|MERGED"
}
```

You can retrieve a list of potential duplicates using the following endpoint:

    GET /api/potentialDuplicates

Additionally you can inspect individual records:

    GET /api/potentialDuplicates/<id>

To create a new potential duplicate, you can use this endpoint:

    POST /api/potentialDuplicates

The payload you provide needs at least _teiA_ to be a valid tracked entity instance; _teiB_ is optional. If _teiB_ is set, it also needs to point to an existing tracked entity instance.

```json
{
  "teiA": "<id>",
  "teiB": "<id>"
}
```

You can mark a potential duplicate as _invalid_ to tell the system that the potential duplicate has been investigated and deemed to be not a duplicate. To do so you can use the following endpoint:

    PUT /api/potentialDuplicates/<id>/invalidation

To hard delete a potential duplicate:

    DELETE /api/potentialDuplicates/<id>

## Email

<!--DHIS2-SECTION-ID:webapi_email-->

The Web API features a resource for sending emails. For emails to be
sent it is required that the SMTP configuration has been properly set up
and that a system notification email address for the DHIS2 instance has
been defined. You can set SMTP settings from the email settings screen
and system notification email address from the general settings screen
in DHIS2.

    /api/33/email

### System notification

<!--DHIS2-SECTION-ID:webapi_email_system_notification-->

The *notification* resource lets you send system email notifications
with a given subject and text in JSON or XML. The email will be sent to
the notification email address as defined in the DHIS2 general system
settings:

```json
{
  "subject": "Integrity check summary",
  "text": "All checks ran successfully"
}
```

You can send a system email notification by posting to the notification
resource like this:

```bash
curl -d @email.json "localhost/api/33/email/notification" -X POST 
  -H "Content-Type:application/json" -u admin:district
```

### Outbound emails

You can also send a general email notification by posting to the
notification resource as mentioned below. `F_SEND_EMAIL` or `ALL`
authority has to be in the system to make use of this api. Subject
parameter is optional. "DHIS 2" string will be sent as default subject
if it is not provided in url. Url should be encoded in order to use this
API.

```bash
curl "localhost/api/33/email/notification?recipients=xyz%40abc.com&message=sample%20email&subject=Test%20Email" 
  -X POST -u admin:district
```

### Test message

<!--DHIS2-SECTION-ID:webapi_email_test_message-->

To test whether the SMTP setup is correct by sending a test email to
yourself you can interact with the *test* resource. To send test emails
it is required that your DHIS2 user account has a valid email address
associated with it. You can send a test email like this:

```bash
curl "localhost/api/33/email/test" -X POST -H "Content-Type:application/json" -u admin:district
```

## Sharing

<!--DHIS2-SECTION-ID:webapi_sharing-->

The sharing solution allows you to share most objects in the system with
specific user groups and to define whether objects should be publicly
accessible or private. To get and set sharing status for objects you can
interact with the *sharing* resource.

    /api/33/sharing

### Get sharing status

<!--DHIS2-SECTION-ID:webapi_get_sharing_status-->

To request the sharing status for an object use a GET request to:

    /api/33/sharing?type=dataElement&id=fbfJHSPpUQD

The response looks like the below.

```json
{
  "meta": {
    "allowPublicAccess": true,
    "allowExternalAccess": false
  },
  "object": {
    "id": "fbfJHSPpUQD",
    "name": "ANC 1st visit",
    "publicAccess": "rw------",
    "externalAccess": false,
    "user": {},
    "userGroupAccesses": [
      {
        "id": "hj0nnsVsPLU",
        "access": "rw------"
      },
      {
        "id": "qMjBflJMOfB",
        "access": "r-------"
      }
    ]
  }
}
```

### Set sharing status

<!--DHIS2-SECTION-ID:webapi_set_sharing_status-->

You can define the sharing status for an object using the same URL with
a POST request, where the payload in JSON format looks like this:

```json
{
  "object": {
    "publicAccess": "rw------",
    "externalAccess": false,
    "user": {},
    "userGroupAccesses": [
      {
        "id": "hj0nnsVsPLU",
        "access": "rw------"
      },
      {
        "id": "qMjBflJMOfB",
        "access": "r-------"
      }
    ]
  }
}
```

In this example, the payload defines the object to have read-write
public access, no external access (without login), read-write access to
one user group and read-only access to another user group. You can
submit this to the sharing resource using curl:

```bash
curl -d @sharing.json "localhost/api/33/sharing?type=dataElement&id=fbfJHSPpUQD"
  -H "Content-Type:application/json" -u admin:district
```

## Scheduling

<!--DHIS2-SECTION-ID:webapi_scheduling-->

DHIS2 allows for scheduling of jobs of various types. Each type of job has different properties for configuration, giving you finer control over how jobs are run. In addition, you can configure the same job to run with different configurations and at different intervals if required.

<table>
<caption>Main properties</caption>
<thead>
<tr class="header">
<th>Property</th>
<th>Description</th>
<th>Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>Name of the job.</td>
<td>String</td>
</tr>
<tr class="even">
<td>cronExpression</td>
<td>The cron expression which defines the interval for when the job should run.</td>
<td>String (Cron expression)</td>
</tr>
<tr class="odd">
<td>jobType</td>
<td>The job type represent which task is run. In the next table, you can get an overview of existing job types. Each job type can have a specific set of parameters for job configuration.</td>
<td>String (Enum)</td>
</tr>
<tr class="even">
<td>jobParameters</td>
<td>Job parameters, if applicable for job type.</td>
<td>(See list of job types)</td>
</tr>
<tr class="odd">
<td>enabled</td>
<td>A job can be added to the system without it being scheduled by setting `enabled` to false in the JSON payload. Use this if you want to temporarily stop scheduling for a job, or if a job configuration is not complete yet.</td>
<td>Boolean</td>
</tr>
</tbody>
</table>

<table>
<caption>Available job types</caption>
<thead>
<tr class="header">
<th>Job type</th>
<th>Parameters</th>
<th>Param(Type:Default)</th>
</tr>
</thead>
<tbody>
<tr>
<td>DATA_INTEGRITY</td>
<td>NONE</td>
<td></td>
</tr>
<tr>
<td>ANALYTICS_TABLE</td>
<td><ul>
<li><p>lastYears: Number of years back to include</p></li>
<li><p>skipTableTypes: Skip generation of tables</p><p>Possible values: DATA_VALUE, COMPLETENESS, COMPLETENESS_TARGET, ORG_UNIT_TARGET, EVENT, ENROLLMENT, VALIDATION_RESULT</p></li>
<li><p>skipResourceTables: Skip generation of resource tables</p></li>
</ul></td>
<td><ul>
<li><p>lastYears (int:0)</p></li>
<li><p>skipTableTypes (Array of String (Enum):None )</p></li>
<li><p>skipResourceTables (Boolean)</p></li>
</ul></td>
</tr>
<tr>
<td>CONTINUOUS_ANALYTICS_TABLE</td>
<td><ul>
<li><p>fullUpdateHourOfDay: Hour of day for full update of analytics tables (0-23)</p></li>
<li><p>lastYears: Number of years back to include</p></li>
<li><p>skipTableTypes: Skip generation of tables</p><p>Possible values: DATA_VALUE, COMPLETENESS, COMPLETENESS_TARGET, ORG_UNIT_TARGET, EVENT, ENROLLMENT, VALIDATION_RESULT</p></li>
<li><p>skipResourceTables: Skip generation of resource tables</p></li>
</ul></td>
<td><ul>
<li><p>lastYears (int:0)</p></li>
<li><p>skipTableTypes (Array of String (Enum):None )</p></li>
<li><p>skipResourceTables (Boolean)</p></li>
</ul></td>
</tr>
<tr>
<td>DATA_SYNC</td>
<td>NONE</td>
<td></td>
</tr>
<tr >
<td>META_DATA_SYNC</td>
<td>NONE</td>
<td></td>
</tr>
<tr>
<td>SEND_SCHEDULED_MESSAGE</td>
<td>NONE</td>
<td></td>
</tr>
<tr>
<td>PROGRAM_NOTIFICATIONS</td>
<td>NONE</td>
<td></td>
</tr>
<tr>
<td>MONITORING (Validation rule analysis)</td>
<td><ul>
<li><p>relativeStart: A number related to date of execution which resembles the start of the period to monitor</p></li>
<li><p>relativeEnd: A number related to date of execution which resembles the end of the period to monitor</p></li>
<li><p>validationRuleGroups: Validation rule groups(UIDs) to include in job</p></li>
<li><p>sendNotification: Set &quot;true&quot; if job should send notifications based on validation rule groups</p></li>
<li><p>persistsResults: Set &quot;true&quot; if job should persist validation results</p></li>
</ul></td>
<td><ul>
<li><p>relativeStart (int:0)</p></li>
<li><p>relativeEnd (int:0)</p></li>
<li><p>validationRuleGroups (Array of String (UIDs):None )</p></li>
<li><p>sendNotification (Boolean:false)</p></li>
<li><p>persistsResults (Boolean:false)</p></li>
</ul></td>
</tr>
<tr>
<td>PUSH_ANALYSIS</td>
<td><ul>
<li><p>pushAnalysis: The uid of the push analysis you want to run</p></li>
</ul></td>
<td><ul>
<li><p>pushAnalysis (String:None)</p></li>
</ul></td>
</tr>
<tr>
<td>PREDICTOR</td>
<td><ul>
<li><p>relativeStart: A number related to date of execution which resembles the start of the period to monitor</p></li>
<li><p>relativeEnd: A number related to date of execution which resembles the start of the period to monitor</p></li>
<li><p>predictors: Predictors(UIDs) to include in job</p></li>
</ul></td>
<td><ul>
<li><p>relativeStart (int:0)</p></li>
<li><p>relativeEnd (int:0)</p></li>
<li><p>predictors (Array of String (UIDs):None )</p></li>
</ul></td>
</tr>
</tbody>
</table>

### Get available job types

To get a list of all available job types you can use the following endpoint:

	GET /api/jobConfigurations/jobTypes

The response contains information about each job type including name, job type, key, scheduling type and available parameters. The scheduling type can either be `CRON`, meaning jobs can be scheduled using a cron expression with the `cronExpression` field, or `FIXED_DELAY`, meaning jobs can be scheduled to run with a fixed delay in between with the `delay` field. The field delay is given in seconds. 

A response will look similar to this:

```json
{
  "jobTypes": [
    {
      "name": "Data integrity",
      "jobType": "DATA_INTEGRITY",
      "key": "dataIntegrityJob",
      "schedulingType": "CRON"
    }, {
      "name": "Resource table",
      "jobType": "RESOURCE_TABLE",
      "key": "resourceTableJob",
      "schedulingType": "CRON"
    }, {
      "name": "Continuous analytics table",
      "jobType": "CONTINUOUS_ANALYTICS_TABLE",
      "key": "continuousAnalyticsTableJob",
      "schedulingType": "FIXED_DELAY"
    }
  ]
}
```

### Create job

To configure jobs you can do a POST request to the following resource:

    /api/jobConfigurations

A job without parameters in JSON format looks like this :

```json
{
  "name": "",
  "jobType": "JOBTYPE",
  "cronExpression": "0 * * ? * *",
}
```

An example of an analytics table job with parameters in JSON format:

```json
{
  "name": "Analytics tables last two years",
  "jobType": "ANALYTICS_TABLE",
  "cronExpression": "0 * * ? * *",
  "jobParameters": {
    "lastYears": "2",
    "skipTableTypes": [],
    "skipResourceTables": false
  }
}
```

As example of a push analysis job with parameters in JSON format:

```json
{
   "name": "Push anlysis charts",
   "jobType": "PUSH_ANALYSIS",
   "cronExpression": "0 * * ? * *",
   "jobParameters": {
     "pushAnalysis": [
       "jtcMAKhWwnc"
     ]
    }
 }
```

An example of a job with scheduling type `FIXED_DELAY` and 120 seconds delay:

```json
{
  "name": "Continuous analytics table",
  "jobType": "CONTINUOUS_ANALYTICS_TABLE",
  "delay": "120",
  "jobParameters": {
    "fullUpdateHourOfDay": 4
  }
}
```

### Get jobs

List all job configurations:

    GET /api/jobConfigurations

Retrieve a job:

    GET /api/jobConfigurations/{id}

The response payload looks like this:

```json
{
  "lastUpdated": "2018-02-22T15:15:34.067",
  "id": "KBcP6Qw37gT",
  "href": "http://localhost:8080/api/jobConfigurations/KBcP6Qw37gT",
  "created": "2018-02-22T15:15:34.067",
  "name": "analytics last two years",
  "jobStatus": "SCHEDULED",
  "displayName": "analytics last two years",
  "enabled": true,
  "externalAccess": false,
  "jobType": "ANALYTICS_TABLE",
  "nextExecutionTime": "2018-02-26T03:00:00.000",
  "cronExpression": "0 0 3 ? * MON",
  "jobParameters": {
    "lastYears": 2,
    "skipTableTypes": [],
    "skipResourceTables": false
  },
  "favorite": false,
  "configurable": true,
  "access": {
    "read": true,
    "update": true,
    "externalize": true,
    "delete": true,
    "write": true,
    "manage": true
  },
  "lastUpdatedBy": {
    "id": "GOLswS44mh8"
  },
  "favorites": [],
  "translations": [],
  "userGroupAccesses": [],
  "attributeValues": [],
  "userAccesses": []
}
```

### Update job

Update a job with parameters using the following endpoint and JSON payload format:

    PUT /api/jobConfiguration/{id}

```json
{
  "name": "analytics last two years",
  "enabled": true,
  "cronExpression": "0 0 3 ? * MON",
  "jobType": "ANALYTICS_TABLE",
  "jobParameters": {
    "lastYears": "3",
    "skipTableTypes": [],
    "skipResourceTables": false
  }
}
```

### Delete job

Delete a job using:

    DELETE /api/jobConfiguration/{id}

Note that some jobs with custom configuration parameters may not be added if the
required system settings are not configured. An example of this is data
synchronization, which requires remote server configuration.

## Schema

<!--DHIS2-SECTION-ID:webapi_schema-->

A resource which can be used to introspect all available DXF 2 objects
can be found on `/api/schemas`. For specific resources you can have a
look at `/api/schemas/<type>`.

To get all available schemas in XML:

    GET /api/schemas.xml

To get all available schemas in JSON:

    GET /api/schemas.json

To get JSON schema for a specific class:

    GET /api/schemas/dataElement.json

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

## Synchronization

<!--DHIS2-SECTION-ID:webapi_synchronization-->

This section covers pull and push of data and metadata.

### Data value push

<!--DHIS2-SECTION-ID:webapi_sync_data_push-->

To initiate a data value push to a remote server one must first configure the
URL and credentials for the relevant server from System settings >
Synchronization, then make a POST request to the following resource:

    /api/33/synchronization/dataPush

### Metadata pull

<!--DHIS2-SECTION-ID:webapi_sync_metadata_pull-->

To initiate a metadata pull from a remote JSON document you can make a
POST request with a *url* as request payload to the following resource:

    /api/33/synchronization/metadataPull

### Availability check

<!--DHIS2-SECTION-ID:webapi_sync_availability_check-->

To check the availability of the remote data server and verify user
credentials you can make a GET request to the following resource:

    /api/33/synchronization/availability

## Apps

<!--DHIS2-SECTION-ID:webapi_apps-->

The `/api/apps` endpoint can be used for installing, deleting and
listing apps. The app key is based on the app name, but with all
non-alphanumerical characters removed, and spaces replaced with a dash.
*My app!* will return the key *My-app*.

> **Note**
>
> Previous to 2.28, the app key was derived from the name of the ZIP
> archive, excluding the file extension. URLs using the old format
> should still return the correct app in the api.

    /api/33/apps

### Get apps

<!--DHIS2-SECTION-ID:webapi_get_apps-->

> **Note**
>
> Previous to 2.28 the app property folderName referred to the actual
> path of the installed app. With the ability to store apps on cloud
> services, folderName's purpose changed, and will now refer to the app
> key.

You can read the keys for apps by listing all apps from the apps
resource and look for the *key* property. To list all installed apps in
JSON:

```bash
curl -u user:pass -H "Accept: application/json" "http://server.com/api/33/apps"
```

You can also simply point your web browser to the resource URL:

    http://server.com/api/33/apps

The apps list can also be filtered by app type and by name, by appending
one or more *filter* parameters to the URL:

    http://server.com/api/33/apps?filter=appType:eq:DASHBOARD_APP&filter=name:ilike:youtube

App names support the *eq* and *ilike* filter operators, while *appType*
supports *eq* only.

### Install an app

<!--DHIS2-SECTION-ID:webapi_install_app-->

To install an app, the following command can be issued:

```bash
curl -X POST -u user:pass -F file=@app.zip "http://server.com/api/33/apps"
```

### Delete an app

<!--DHIS2-SECTION-ID:webapi_delete_app-->

To delete an app, you can issue the following command:

```bash
curl -X DELETE -u user:pass "http://server.com/api/33/apps/<app-key>"
```

### Reload apps

<!--DHIS2-SECTION-ID:webapi_reload_apps-->

To force a reload of currently installed apps, you can issue the
following command. This is useful if you added a file manually directly
to the file system, instead of uploading through the DHIS2 user
interface.

```bash
curl -X PUT -u user:pass "http://server.com/api/33/apps"
```

### Share apps between instances

<!--DHIS2-SECTION-ID:webapi_share_apps_between_instances-->

If the DHIS2 instance has been configured to use cloud storage, apps
will now be installed and stored on the cloud service. This will enable
multiple instances share the same versions on installed apps, instead of
installing the same apps on each individual instance.

> **Note**
>
> Previous to 2.28, installed apps would only be stored on the instance's
> local filesystem. Apps installed before 2.28 will still be available on the
> instance it was installed, but it will not be shared with other
> instances, as it's still located on the instances local filesystem.

## App store

<!--DHIS2-SECTION-ID:webapi_app_store-->

The Web API exposes the content of the DHIS2 App Store as a JSON
representation which can found at the `/api/appStore` resource.

    /api/33/appStore

### Get apps

<!--DHIS2-SECTION-ID:webapi_get_app_store_apps-->

You can retrieve apps with a GET request:

    GET /api/33/appStore

A sample JSON response is described below.

```json
{
  [
    {
      "name": "Tabular Tracker Capture",
      "description": "Tabular Tracker Capture is an app that makes you more effective.",
      "sourceUrl": "https://github.com/dhis2/App-repository",
      "appType": "DASHBOARD_WIDGET",
      "status": "PENDING",
      "id": "NSD06BVoV21",
      "developer": {
        "name": "DHIS",
        "organisation": "Uio",
        "address": "Oslo",
        "email": "dhis@abc.com",
      },
      "versions": [
        {
          "id": "upAPqrVgwK6",
          "version": "1.2",
          "minDhisVersion": "2.17",
          "maxDhisVersion": "2.20",
          "downloadUrl": "https://dhis2.org/download/appstore/tabular-capture-12.zip",
          "demoUrl": "http://play.dhis2.org/demo"
        }
      ],
      "images": [
        {
          "id": "upAPqrVgwK6",
          "logo": "true",
          "imageUrl": "https://dhis2.org/download/appstore/tabular-capture-12.png",
          "description": "added feature snapshot",
          "caption": "dialog",
        }
      ]
    }
  ]
}
```

### Install apps

<!--DHIS2-SECTION-ID:webapi_install_app_store_apps-->

You can install apps on your instance of DHIS2 assuming you have the
appropriate permissions. An app is referred to using the `id` property
of the relevant version of the app. An app is installed with a POST
request with the version id to the following resource:

    POST /api/33/appStore/{app-version-id}

## Data store

<!--DHIS2-SECTION-ID:webapi_data_store-->

Using the *dataStore* resource, developers can store arbitrary data for
their apps. Access to a datastore's key is based on its sharing settings. 
By default all keys created are publicly accessible (read and write). 
Additionally,  access to a datastore's namespace is limited to the user's 
access to the corresponding app, if the app has reserved the namespace. 
For example a user with access to the "sampleApp" application will also
be able to use the sampleApp namespace in the datastore. If a namespace
is not reserved, no specific access is required to use it.

    /api/33/dataStore

### Data store structure

<!--DHIS2-SECTION-ID:webapi_data_store_structure-->

Data store entries consist of a namespace, key and value. The
combination of namespace and key is unique. The value data type is JSON.

<table>
<caption>Data store structure</caption>
<colgroup>
<col style="width: 22%" />
<col style="width: 40%" />
<col style="width: 36%" />
</colgroup>
<thead>
<tr class="header">
<th>Item</th>
<th>Description</th>
<th>Data type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Namespace</td>
<td>Namespace for organization of entries.</td>
<td>String</td>
</tr>
<tr class="even">
<td>Key</td>
<td>Key for identification of values.</td>
<td>String</td>
</tr>
<tr class="odd">
<td>Value</td>
<td>Value holding the information for the entry.</td>
<td>JSON</td>
</tr>
<tr class="even">
<td>Encrypted</td>
<td>Indicates whether the value of the given key should be encrypted</td>
<td>Boolean</td>
</tr>
</tbody>
</table>

### Get keys and namespaces

<!--DHIS2-SECTION-ID:webapi_data_store_get_keys_and_namespaces-->

For a list of all existing namespaces:

    GET /api/33/dataStore

Example curl request for listing:

```bash
curl "play.dhis2.org/demo/api/33/dataStore" -u admin:district
```

Example response:

```json
[
  "foo",
  "bar"
]
```

For a list of all keys in a namespace:

    GET /api/33/dataStore/<namespace>

Example curl request for listing:

```bash
curl "play.dhis2.org/demo/api/33/dataStore/foo" -u admin:district
```

Example response:

```json
[
  "key_1",
  "key_2"
]
```

To retrieve a value for an existing key from a namespace:

    GET /api/33/dataStore/<namespace>/<key>

Example curl request for retrieval:

```bash
curl "play.dhis2.org/demo/api/33/dataStore/foo/key_1"-u admin:district
```

Example response:

```json
{
  "foo":"bar"
}
```

To retrieve meta-data for an existing key from a namespace:

    GET /api/33/dataStore/<namespace>/<key>/metaData

Example curl request for retrieval:

```bash
curl "play.dhis2.org/demo/api/33/dataStore/foo/key_1/metaData" -u admin:district
```

Example response:

```json
{
  "created": "...",
  "user": {...},
  "namespace": "foo",
  "key": "key_1"
}
```

### Create values

<!--DHIS2-SECTION-ID:webapi_data_store_create_values-->

To create a new key and value for a namespace:

    POST /api/33/dataStore/<namespace>/<key>

Example curl request for create, assuming a valid JSON payload:

```bash
curl "https://play.dhis2.org/demo/api/33/dataStore/foo/key_1" -X POST
  -H "Content-Type: application/json" -d "{\"foo\":\"bar\"}" -u admin:district
```

Example response:

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 201,
  "status": "OK",
  "message": "Key 'key_1' created."
}
```

If you require the data you store to be encrypted (for example user
credentials or similar) you can append a query to the url like this:

    GET /api/33/dataStore/<namespace>/<key>?encrypt=true

### Update values

<!--DHIS2-SECTION-ID:webapi_data_store_update_values-->

To update a key that exists in a namespace:

    PUT /api/33/dataStore/<namespace>/<key>

Example curl request for update, assuming valid JSON payload:

```bash
curl "https://play.dhis2.org/demo/api/33/dataStore/foo/key_1" -X PUT -d "[1, 2, 3]"
  -H "Content-Type: application/json" -u admin:district
```

Example response:

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "message": "Key 'key_1' updated."
}
```

### Delete keys

<!--DHIS2-SECTION-ID:webapi_data_store_delete_keys-->

To delete an existing key from a namespace:

    DELETE /api/33/dataStore/<namespace>/<key>

Example curl request for delete:

```bash
curl "play.dhis2.org/demo/api/33/dataStore/foo/key_1" -X DELETE -u admin:district
```

Example response:

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "message": "Key 'key_1' deleted from namespace 'foo'."
}
```

To delete all keys in a namespace:

    DELETE /api/33/dataStore/<namespace>

Example curl request for delete:

```bash
curl "play.dhis2.org/demo/api/33/dataStore/foo" -X DELETE -u admin:district
```

Example response:

```json
{
  "httpStatus": "OK",
  "httpStatusCode": 200,
  "status": "OK",
  "message": "Namespace 'foo' deleted."
}
```

### Sharing datastore keys

<!--DHIS2-SECTION-ID:webapi_data_store_sharing-->

Sharing of datastore keys follows the same principle as for other metadata sharing (see
[Sharing](#webapi_sharing)).

To get sharing settings for a specific datastore key:

    GET /api/33/sharing?type=dataStore&id=<uid>

To modify sharing settings for a specific datastore key:

    POST /api/33/sharing?type=dataStore&id=<uid> 

with the following request:

```json
{
  "object": {
    "publicAccess": "rw------",
    "externalAccess": false,
    "user": {},
    "userAccesses": [],
    "userGroupAccesses": [
      {
        "id": "hj0nnsVsPLU",
        "access": "rw------"
      },
      {
        "id": "qMjBflJMOfB",
        "access": "r-------"
      }
    ]
  }
}
```

## User data store

<!--DHIS2-SECTION-ID:webapi_user_data_store-->

In addition to the *dataStore* which is shared between all users of the
system, a user-based data store is also available. Data stored to the
*userDataStore* is associated with individual users, so that each user
can have different data on the same namespace and key combination. All
calls against the *userDataStore* will be associated with the logged in
user. This means one can only see, change, remove and add values
associated with the currently logged in user.

    /api/33/userDataStore

### User data store structure

<!--DHIS2-SECTION-ID:webapi_user_data_store_structure-->

*userDataStore* consists of a user, a namespace, keys and associated
values. The combination of user, namespace and key is unique.

<table>
<caption>User data store structure</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Item</th>
<th>Description</th>
<th>Data Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>User</td>
<td>The user this data is associated with</td>
<td>String</td>
</tr>
<tr class="even">
<td>Namespace</td>
<td>The namespace the key belongs to</td>
<td>String</td>
</tr>
<tr class="odd">
<td>Key</td>
<td>The key a value is stored on</td>
<td>String</td>
</tr>
<tr class="even">
<td>Value</td>
<td>The value stored</td>
<td>JSON</td>
</tr>
<tr class="odd">
<td>Encrypted</td>
<td>Indicates whether the value should be encrypted</td>
<td>Boolean</td>
</tr>
</tbody>
</table>

### Get namespaces

<!--DHIS2-SECTION-ID:webapi_user_data_store_get_namespaces-->

Returns an array of all existing namespaces

    GET /api/33/userDataStore

Example
    request:

```bash
curl -H "Content-Type: application/json" -u admin:district "play.dhis2.org/api/33/userDataStore"
```

```json
[
  "foo",
  "bar"
]
```

### Get keys

<!--DHIS2-SECTION-ID:webapi_user_data_store_get_keys-->

Returns an array of all existing keys in a given namespace

    GET /api/userDataStore/<namespace>

Example request:

```bash
curl -H "Content-Type: application/json" -u admin:district "play.dhis2.org/api/33/userDataStore/foo"
```

```json
[
  "key_1",
  "key_2"
]
```

### Get values

<!--DHIS2-SECTION-ID:webapi_user_data_store_get_values-->

Returns the value for a given namespace and key

    GET /api/33/userDataStore/<namespace>/<key>

Example request:

```bash
curl -H "Content-Type: application/json" -u admin:district "play.dhis2.org/api/33/userDataStore/foo/bar"
```

```json
{
  "some": "value"
}
```

### Create value

<!--DHIS2-SECTION-ID:webapi_user_data_store_create_values-->

Adds a new value to a given key in a given namespace.

    POST /api/33/userDataStore/<namespace>/<key>

Example request:

```bash
curl -X POST -H "Content-Type: application/json" -u admin:district -d "['some value']"
  "play.dhis2.org/api/33/userDataStore/foo/bar"
```

```json
{
  "httpStatus": "Created",
  "httpStatusCode": 201,
  "status": "OK",
  "message": "Key 'bar' in namespace 'foo' created."
}
```

If you require the value to be encrypted (For example user credentials
and such) you can append a query to the url like this:

    GET /api/33/userDataStore/<namespace>/<key>?encrypt=true

### Update values

<!--DHIS2-SECTION-ID:webapi_user_data_store_update_values-->

Updates an existing value

    PUT /api/33/userDataStore/<namespace>/<key>

Example request:

```bash
curl -X PUT -H "Content-Type: application/json" -u admin:district -d "['new value']"
  "play.dhis2.org/api/33/userDataStore/foo/bar"
```

```json
{
  "httpStatus":"Created",
  "httpStatusCode":201,
  "status":"OK",
  "message":"Key 'bar' in namespace 'foo' updated."
}
```

### Delete key

<!--DHIS2-SECTION-ID:webapi_user_data_store_delete_key-->

Delete a key

    DELETE /api/33/userDataStore/<namespace>/<key>

Example request:

```bash
curl -X DELETE -u admin:district "play.dhis2.org/api/33/userDataStore/foo/bar"
```

```json
{
  "httpStatus":"OK",
  "httpStatusCode":200,
  "status":"OK",
  "message":"Key 'bar' deleted from the namespace 'foo."
}
```

### Delete namespace

<!--DHIS2-SECTION-ID:webapi_user_data_store_delete_namespace-->

Delete all keys in the given namespace

    DELETE /api/33/userDataStore/<namespace>

Example request:

```bash
curl -X DELETE -u admin:district "play.dhis2.org/api/33/userDataStore/foo"
```

```json
{
  "httpStatus":"OK",
  "httpStatusCode":200,
  "status":"OK",
  "message":"All keys from namespace 'foo' deleted."
}
```

## Predictors

<!--DHIS2-SECTION-ID:webapi_predictors-->

A predictor allows you to generate data values based on an expression.
This can be used for example to generate targets, thresholds,
or estimated values.

To retrieve predictors you can make a GET request to the predictors
resource like this:

    /api/predictors

### Creating a predictor

<!--DHIS2-SECTION-ID:webapi_create_predictor-->

You can create a predictor with a POST request to the predictors
resource:

    POST /api/predictors

A sample payload looks like this:

```json
{
  "id": "AG10KUJCrRk",
  "name": "Malaria Outbreak Threshold Predictor",
  "shortName": "Malaria Outbreak Predictor",
  "description": "Computes the threshold for potential malaria outbreaks based on the mean plus 1.5x the std dev",
  "output": {
    "id": "nXJJZNVAy0Y"
  },
  "generator": {
    "expression": "AVG(#{r6nrJANOqMw})+1.5*STDDEV(#{r6nrJANOqMw})",
    "description": "Maximum normal malaria case count",
    "missingValueStrategy": "NEVER_SKIP",
    "slidingWindow": false
  },
  "periodType": "Monthly",
  "sequentialSampleCount": 4,
  "sequentialSkipCount": 1,
  "annualSampleCount": 3,
  "organisationUnitLevels": [4]
}
```

The output element refers to the identifier of the data element for
which to saved predicted data values. The generator element refers to the
expression to use when calculating the predicted values.

### Predictor expressions

<!--DHIS2-SECTION-ID:webapi_predictor_expressions-->

A predictor always has a generator expression that describes how the
predicted value is calculated. A predictor may also have a skip test
expression returning a boolean value. When the skip test expression is
present, it is evaluated in each of the sampled periods to tell whether
values from that period should be skipped.

The following variables may be used in either a generator expression
or a skip test expression:

| Variable    | Object     | Description |
| ----------- | ---------- | ----------- |
| #{\<dataelement-id>} | Aggregate data element | Refers to the total value of an aggregate data element across all category option combinations. |
| #{\<dataelement-id>.\<categoryoptcombo-id> | Data element operand | Refers to a combination of an aggregate data element and a category option combination. |
| D{\<program-id>.\<dataelement-id>} | Program data element | Refers to the value of a tracker data element within a program. |
| A{\<program-id>.\<attribute-id>} | Program tracked entity attribute | Refers to the value of a tracked entity attribute within a program. |
| I{\<program-indicator-id>} | Program indicator | Refers to the value of a program indicator. |
| R{\<dataset-id>.\<metric>} | Reporting rate | Refers to a reporting rate metric. The metric can be REPORTING_RATE, REPORTING_RATE_ON_TIME, ACTUAL_REPORTS, ACTUAL_REPORTS_ON_TIME, EXPECTED_REPORTS. |
| C{\<constant-id>} | Constant | Refers to a constant value. |
| OUG{\<orgunitgroup-id>} | Organisation unit group | Refers to the count of organisation units within an organisation unit group. |
| [days] | Number of days | The number of days in the current period. |

### Generating predicted values

<!--DHIS2-SECTION-ID:webapi_generating_predicted_values-->

To run all predictors (generating predicted values) you can make a POST
request to the run resource:

    POST /api/predictors/run

To run a single predictor you can make a POST request to the run
resource for a predictor:

    POST /api/predictors/AG10KUJCrRk/run

## Min-max data elements

<!--DHIS2-SECTION-ID:webapi_min_max_data_elements-->

The min-max data elements resource allows you to set minimum and maximum
value ranges for data elements. It is unique by the combination of
organisation unit, data element and category option combo.

    /api/minMaxDataElements

<table>
<caption>Min-max data element data structure</caption>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Item</th>
<th>Description</th>
<th>Data type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>source</td>
<td>Organisation unit identifier</td>
<td>String</td>
</tr>
<tr class="even">
<td>dataElement</td>
<td>Data element identifier</td>
<td>String</td>
</tr>
<tr class="odd">
<td>optionCombo</td>
<td>Data element category option combo identifier</td>
<td>String</td>
</tr>
<tr class="even">
<td>min</td>
<td>Minimum value</td>
<td>Integer</td>
</tr>
<tr class="odd">
<td>max</td>
<td>Maximum value</td>
<td>Integer</td>
</tr>
<tr class="even">
<td>generated</td>
<td>Indicates whether this object is generated by the system (and not set manually).</td>
<td>Boolean</td>
</tr>
</tbody>
</table>

You can retrieve a list of all min-max data elements from the following
resource:

    GET /api/minMaxDataElements.json

You can filter the response like this:

    GET /api/minMaxDataElements.json?filter=dataElement.id:eq:UOlfIjgN8X6
    
    GET /api/minMaxDataElements.json?filter=dataElement.id:in:[UOlfIjgN8X6,xc8gmAKfO95]

The filter parameter for min-max data elements supports two operators:
eq and in. You can also use the `fields` query parameter.

    GET /api/minMaxDataElements.json?fields=:all,dataElement[id,name]

### Add/update min-max data element

<!--DHIS2-SECTION-ID:webapi_add_update_min_max_data_element-->

To add a new min-max data element, use POST request to:

    POST /api/minMaxDataElements.json

The JSON content format looks like this:

```json
{
  "min": 1,
  "generated": false,
  "max": 100,
  "dataElement": {
    "id": "UOlfIjgN8X6"
   },
  "source": {
    "id": "DiszpKrYNg8"
  },
  "optionCombo": {
    "id": "psbwp3CQEhs"
  }
}
```

If the combination of data element, organisation unit and category
option combo exists, the min-max value will be updated.

### Delete min-max data element

<!--DHIS2-SECTION-ID:webapi_delete_min_max_data_element-->

To delete a min-max data element, send a request with DELETE method:

    DELETE /api/minMaxDataElements.json

The JSON content is in similar format as above:

```json
{
  "min": 1,
  "generated": false,
  "max": 100,
  "dataElement": {
	"id": "UOlfIjgN8X6"
   },
  "source": {
	"id": "DiszpKrYNg8"
  },
  "optionCombo": {
	"id": "psbwp3CQEhs"
  }
}
```

## Lock exceptions

<!--DHIS2-SECTION-ID:webapi_lock_exceptions-->

The lock exceptions resource allows you to open otherwise locked data
sets for data entry for a specific data set, period and organisation
unit. You can read lock exceptions from the following resource:

    /api/lockExceptions

To create a new lock exception you can use a POST request and specify
the data set, period and organisation unit:

    POST /api/lockExceptions?ds=BfMAe6Itzgt&pe=201709&ou=DiszpKrYNg8

To delete a lock exception you can use a similar request syntax with a
DELETE request:

    DELETE /api/lockExceptions?ds=BfMAe6Itzgt&pe=201709&ou=DiszpKrYNg8

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

This assumes that a Google service account has been set up and
configured for DHIS2. Please consult the installation guide for more
info.

## Analytics table hooks

<!--DHIS2-SECTION-ID:webapi_analytics_table_hooks-->

Analytics table hooks provide a mechanism for invoking SQL scripts
during different phases of the analytics table generation process. This
is useful for customizing data in resource and analytics tables, e.g. in
order to achieve specific logic for calculations and aggregation.
Analytics table hooks can be manipulated at the following API endpoint:

    /api/analyticsTableHooks

The analytics table hooks API supports the standard HTTP CRUD operations
for creating (POST), updating (PUT), retrieving (GET) and deleting
(DELETE) entities.

### Hook fields

<!--DHIS2-SECTION-ID:webapi_analytics_table_hook_fields-->

Analytics table hooks have the following fields:

<table style="width:100%;">
<caption>Analytics table hook fields</caption>
<colgroup>
<col style="width: 22%" />
<col style="width: 30%" />
<col style="width: 46%" />
</colgroup>
<thead>
<tr class="header">
<th>Field</th>
<th>Options</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>name</td>
<td>Text</td>
<td>Name of the hook.</td>
</tr>
<tr class="even">
<td>phase</td>
<td>RESOURCE_TABLE_POPULATED, ANALYTICS_TABLE_POPULATED</td>
<td>The phase for when the SQL script should be invoked.</td>
</tr>
<tr class="odd">
<td>resourceTableType</td>
<td><p>See column &quot;Table type&quot; in table &quot;Phases, table types and temporary tables&quot; below</p></td>
<td>The type of resource table for which to invoke the SQL script. Applies only for hooks defined with the RESOURCE_TABLE_POPULATED phase.</td>
</tr>
<tr class="even">
<td>analyticsTableType</td>
<td>See column &quot;Table type&quot; in table &quot;Phases, table types and temporary tables&quot; below</td>
<td>The type of analytics table for which to invoke the SQL script. Applies only for hooks defined with the ANALYTICS_TABLE_POPULATED phase.</td>
</tr>
<tr class="odd">
<td>sql</td>
<td>Text</td>
<td>The SQL script to invoke.</td>
</tr>
</tbody>
</table>

The *ANALYTICS_TABLE_POPULATED* phase takes place after the analytics
table has been populated, but before indexes have been created and the
temp table has been swapped with the main table. As a result, the SQL
script should refer to the analytics temp table, e.g. *analytics_temp*,
*analytics_completeness_temp*.

This applies also to the *RESOURCE_TABLE_POPULATED* phase, which takes
place after the resource table has been populated, but before indexes
have been created and the temp table has been swapped with the main
table. As a result, the SQL script should refer to the resource temp
table, e.g. *_orgunitstructure_temp*, *_categorystructure_temp*.

You should define only one of the *resourceTableType* and
*analyticsTableType* fields, depending on which *phase* is defined.

You can refer to the temporary database table which matches the
specified hook table type only (other temporary tables will not be
available). As an example, if you specify *ORG_UNIT_STRUCTURE* as the
resource table type, you can refer to the *_orgunitstructure_temp*
temporary database table only.

The following table shows the valid combinations of phases, table types
and temporary tables.

<table>
<caption>Phases, table types and temporary tables</caption>
<colgroup>
<col style="width: 27%" />
<col style="width: 39%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th>Phase</th>
<th>Table type</th>
<th>Temporary table</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td rowspan="12">RESOURCE_TABLE_POPULATED</td>
<td>ORG_UNIT_STRUCTURE</td>
<td>_orgunitstructure_temp</td>
</tr>
<tr class="even">
<td>DATA_SET_ORG_UNIT_CATEGORY</td>
<td>_datasetorgunitcategory_temp</td>
</tr>
<tr class="odd">
<td>CATEGORY_OPTION_COMBO_NAME</td>
<td>_categoryoptioncomboname_temp</td>
</tr>
<tr class="even">
<td>DATA_ELEMENT_GROUP_SET_STRUCTURE</td>
<td>_dataelementgroupsetstructure_temp</td>
</tr>
<tr class="odd">
<td>INDICATOR_GROUP_SET_STRUCTURE</td>
<td>_indicatorgroupsetstructure_temp</td>
</tr>
<tr class="even">
<td>ORG_UNIT_GROUP_SET_STRUCTURE</td>
<td>_organisationunitgroupsetstructure_temp</td>
</tr>
<tr class="odd">
<td>CATEGORY_STRUCTURE</td>
<td>_categorystructure_temp</td>
</tr>
<tr class="even">
<td>DATA_ELEMENT_STRUCTURE</td>
<td>_dataelementstructure_temp</td>
</tr>
<tr class="odd">
<td>PERIOD_STRUCTURE</td>
<td>_periodstructure_temp</td>
</tr>
<tr class="even">
<td>DATE_PERIOD_STRUCTURE</td>
<td>_dateperiodstructure_temp</td>
</tr>
<tr class="odd">
<td>DATA_ELEMENT_CATEGORY_OPTION_COMBO</td>
<td>_dataelementcategoryoptioncombo_temp</td>
</tr>
<tr class="even">
<td>DATA_APPROVAL_MIN_LEVEL</td>
<td>_dataapprovalminlevel_temp</td>
</tr>
<tr class="odd">
<td rowspan="7">ANALYTICS_TABLE_POPULATED</td>
<td>DATA_VALUE</td>
<td>analytics_temp</td>
</tr>
<tr class="even">
<td>COMPLETENESS</td>
<td>analytics_completeness_temp</td>
</tr>
<tr class="odd">
<td>COMPLETENESS_TARGET</td>
<td>analytics_completenesstarget_temp</td>
</tr>
<tr class="even">
<td>ORG_UNIT_TARGET</td>
<td>analytics_orgunittarget_temp</td>
</tr>
<tr class="odd">
<td>EVENT</td>
<td>analytics_event_temp_&lt;program-uid&gt;</td>
</tr>
<tr class="even">
<td>ENROLLMENT</td>
<td>analytics_enrollment_temp_&lt;program-uid&gt;</td>
</tr>
<tr class="odd">
<td>VALIDATION_RESULT</td>
<td>analytics_validationresult_temp</td>
</tr>
</tbody>
</table>

### Creating hooks

<!--DHIS2-SECTION-ID:webapi_create_analytics_table_hook-->

To create a hook which should run after the resource tables have been
populated you can do a *POST* request like this using *JSON* format:

```bash
curl -d @hooks.json "localhost/api/analyticsTableHooks" -H "Content-Type:application/json" -u admin:district
```

```json
{
  "name": "Update 'Area' in org unit group set resource table",
  "phase": "RESOURCE_TABLE_POPULATED",
  "resourceTableType": "ORG_UNIT_GROUP_SET_STRUCTURE",
  "sql": "update _organisationunitgroupsetstructure_temp set \"uIuxlbV1vRT\" = 'b0EsAxm8Nge'"
}
```

To create a hook which should run after the data value analytics table
has been populated you can do a *POST* request like this using *JSON*
format:

```json
{
  "name": "Update 'Currently on treatment' data in analytics table",
  "phase": "ANALYTICS_TABLE_POPULATED",
  "analyticsTableType": "DATA_VALUE",
  "sql": "update analytics_temp set monthly = '200212' where \"monthly\" in ('200210', '200211')"
}
```

## Metadata repository

<!--DHIS2-SECTION-ID:webapi_metadata_repository-->

DHIS2 provides a metadata repository containing metadata packages with
various content. A metadata package is a DHIS2-compliant JSON document
which describes a set of metadata objects.

To retrieve an index over available metadata packages you can issue a
GET request to the *metadataRepo* resource:

    GET /api/synchronization/metadataRepo

A metadata package entry contains information about the package and a
URL to the relevant package. An index could look like this:

```json
{
  "packages": [
    {
      "id": "sierre-leone-demo",
      "name": "Sierra Leone demo",
      "description": "Sierra Leone demo database",
      "version": "0.1",
      "href": "https://dhis2.org/metadata-repo/221/sierra-leone-demo/metadata.json"
    },
    {
      "id": "trainingland-org-units",
      "name": "Trainingland organisation units",
      "description": "Trainingland organisation units with four levels",
      "version": "0.1",
      "href": "https://dhis2.org/metadata-repo/221/trainingland-org-units/metadata.json"
    }
  ]
}
```

A client can follow the URLs and install a metadata package through a
POST request with content type *text/plain* with the metadata package
URL as the payload to the *metadataPull* resource:

    POST /api/synchronization/metadataPull

An example curl command looks like this:

```bash
curl "localhost:8080/api/synchronization/metadataPull" -X POST
  -d "https://dhis2.org/metadata-repo/221/trainingland-org-units/metadata.json"
  -H "Content-Type:text/plain" -u admin:district
```

## Icons

<!--DHIS2-SECTION-ID:webapi_icons-->

DHIS2 includes a collection of icons that can be used to give visual
context to metadata. These icons can be accessed through the icons
resource.

    GET /api/icons

This endpoint returns a list of information about the available icons.
Each entry contains information about the icon, and a reference to the
actual icon.

```json
{
  key: "mosquito_outline",
  description: "Mosquito outline",
  keywords: [
    "malaria",
    "mosquito",
    "dengue"
  ],
  href: "<dhis server>/api/icons/mosquito_outline/icon.svg"
}
```

The keywords can be used to filter which icons to return. Passing a list
of keywords with the request will only return icons that match all the
keywords:

    GET /api/icons?keywords=shape,small

A list of all unique keywords can be found at the keywords resource:

    GET /api/icons/keywords
