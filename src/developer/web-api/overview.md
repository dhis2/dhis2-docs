# Overview { #webapi } 

The Web API is a component which makes it possible for external systems
to access and manipulate data stored in an instance of DHIS2. More
precisely, it provides a programmatic interface to a wide range of
exposed data and service methods for applications such as third-party
software clients, web portals and internal DHIS2 modules.

## Introduction { #webapi_introduction } 

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

## Authentication { #webapi_authentication } 

The DHIS2 Web API supports two protocols for authentication, Basic
Authentication and OAuth 2. You can verify and get information about the
currently authenticated user by making a GET request to the following
URL:

    /api/33/me

And more information about authorities (and if a user has a certain
authority) by using the endpoints:

    /api/33/me/authorities
    /api/33/me/authorities/ALL

### Basic Authentication { #webapi_basic_authentication } 

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

### Two-factor authentication { #webapi_2fa } 

DHIS2 supports two-factor authentication. This can be enabled per user.
When enabled, users will be asked to enter a 2FA code when logging in. You
can read more about 2FA [here](https://www.google.com/landing/2step/).

### OAuth2 { #webapi_oauth2 } 

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

#### Grant type password { #webapi_oauth2_password } 

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

#### Grant type refresh\_token { #webapi_refresh_token } 

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

#### Grant type authorization_code { #webapi_authorization_code } 

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

## Error and info messages { #webapi_error_info_messages } 

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



Table: WebMessage properties

| Name | Description |
|---|---|
| httpStatus | HTTP Status message for this response, see RFC 2616 (Section 10) for more information. |
| httpStatusCode | HTTP Status code for this response, see RFC 2616 (Section 10) for more information. |
| status | DHIS2 status, possible values are *OK* &#124; *WARNING* &#124; *ERROR*, where `OK` means everything was successful, `ERROR` means that operation did not complete and `WARNING` means the operation was partially successful, if the message contains a `response` property, please look there for more information. |
| message | A user-friendly message telling whether the operation was a success or not. |
| devMessage | A more technical, developer-friendly message (not currently in use). |
| response | Extension point for future extension to the WebMessage format. This will be documented when it starts being used. |

## Date and period format { #webapi_date_perid_format } 

Throughout the Web API, we refer to dates and periods. The date format
is:

    yyyy-MM-dd

For instance, if you want to express March 20, 2014, you must use
*2014-03-20*.

The period format is described in the following table (also available on
the API endpoint `/api/periodTypes`)



Table: Period format

| Interval | Format | Example | Description |
|---|---|---|---|
| Day | yyyyMMdd | 20040315 | March 15, 2004 |
| Week | yyyyWn | 2004W10 | Week 10 2004 |
| Week Wednesday | yyyyWedWn | 2015WedW5 | Week 5 with start Wednesday |
| Week Thursday | yyyyThuWn | 2015ThuW6 | Week 6 with start Thursday |
| Week Saturday | yyyySatWn | 2015SatW7 | Week 7 with start Saturday |
| Week Sunday | yyyySunWn | 2015SunW8 | Week 8 with start Sunday |
| Bi-week | yyyyBiWn | 2015BiW1 | Week 1-2 20015 |
| Month | yyyyMM | 200403 | March 2004 |
| Bi-month | yyyyMMB | 200401B | January-February 2004 |
| Quarter | yyyyQn | 2004Q1 | January-March 2004 |
| Six-month | yyyySn | 2004S1 | January-June 2004 |
| Six-month April | yyyyAprilSn | 2004AprilS1 | April-September 2004 |
| Year | yyyy | 2004 | 2004 |
| Financial Year April | yyyyApril | 2004April | Apr 2004-Mar 2005 |
| Financial Year July | yyyyJuly | 2004July | July 2004-June 2005 |
| Financial Year Oct | yyyyOct | 2004Oct | Oct 2004-Sep 2005 |


### Relative Periods { #webapi_date_relative_period_values } 


In some parts of the API, like for the analytics resource, you can
utilize relative periods in addition to fixed periods (defined above).
The relative periods are relative to the current date and allow e.g.
for creating dynamic reports. The available relative period values are:

    THIS_WEEK, LAST_WEEK, LAST_4_WEEKS, LAST_12_WEEKS, LAST_52_WEEKS,
    THIS_MONTH, LAST_MONTH, THIS_BIMONTH, LAST_BIMONTH, THIS_QUARTER, LAST_QUARTER,
    THIS_SIX_MONTH, LAST_SIX_MONTH, MONTHS_THIS_YEAR, QUARTERS_THIS_YEAR,
    THIS_YEAR, MONTHS_LAST_YEAR, QUARTERS_LAST_YEAR, LAST_YEAR, LAST_5_YEARS, LAST_10_YEARS, LAST_10_FINANCIAL_YEARS, LAST_12_MONTHS, 
    LAST_3_MONTHS, LAST_6_BIMONTHS, LAST_4_QUARTERS, LAST_2_SIXMONTHS, THIS_FINANCIAL_YEAR,
    LAST_FINANCIAL_YEAR, LAST_5_FINANCIAL_YEARS
