# Overview { #webapi } 

The Web API is a component which makes it possible for external systems
to access and manipulate data stored in an instance of DHIS2. More
precisely, it provides a programmatic interface to a wide range of
exposed data and service methods for applications such as third-party
software clients, web portals and internal DHIS2 modules.

## Introduction { #webapi_introduction } 

The Web API adheres to many of the principles behind the REST
architectural style. To mention some important ones:

1.  The fundamental building blocks are referred to as *resources*. A
    resource can be anything exposed to the Web, from a document to a
    business process - anything a client might want to interact with.
    The information aspects of a resource can be retrieved or exchanged
    through resource *representations*. A representation is a view of a
    resource's state at any given time. For instance, the *visualizations*
    resource in DHIS2 represents visualizations of aggregated data for
    a certain set of parameters. This resource can be retrieved in a
    variety of representation formats including JSON and CSV.
2.  All resources can be uniquely identified by a *URI* (also referred
    to as *URL*). All resources have a default representation. You can
    indicate that you are interested in a specific representation by
    supplying an *Accept* HTTP header, a file extension or a *format*
    query parameter. So in order to retrieve a CSV representation of
    an analytics data response you can supply an *Accept: application/csv* 
    header or append *.csv* or *?format=csv* to your request URL.
3.  Interactions with the API requires the correct use of HTTP *methods* or
    *verbs*. This implies that for a resource you must issue a *GET*
    request when you want to retrieve it, *POST* request when you want
    to create one, *PUT* when you want to update it and *DELETE* when
    you want to remove it.

## Authentication { #webapi_authentication } 

The DHIS2 Web API supports three protocols for authentication: 

- [Basic Authentication](#webapi_basic_authentication)
- [Personal Access Tokens (PAT)](#webapi_pat_authentication)
- [OAuth 2](#webapi_oauth2)

You can verify and get information about the currently authenticated 
user by making a GET request to the following URL:

    /api/33/me

And more information about authorities (and if a user has a certain
authority) by using the endpoints:

    /api/33/me/authorities
    /api/33/me/authorities/ALL

## Basic Authentication { #webapi_basic_authentication } 

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

## Two-factor authentication { #webapi_2fa } 

DHIS2 supports two-factor authentication. This can be enabled per user.
When enabled, users will be asked to enter a 2FA code when logging in. You
can read more about 2FA [here](https://www.google.com/landing/2step/).

## Personal Access Token { #webapi_pat_authentication }
Personal access tokens (PATs) are an alternative to using passwords for
authentication to DHIS2 when using the API.

PATs can be a more secure alternative to HTTP Basic Authentication,
and should be your preferred choice when creating a new app/script etc. 

HTTP Basic Authentication is considered insecure because, among other things, 
it sends your username and password in clear text. It may be deprecated in 
future DHIS2 versions or made opt-in, meaning that basic authentication would 
need to be explicitly enabled in the configuration.

#### Important security concerns!

Your PATs will automatically inherit all the permissions and authorizations your
user has. It is therefore extremely important that you limit the access granted to
your token depending on how you intend to use it, see **Configuring your token**.

**If you only want the token to have access to a narrow and specific part of the
server, it is advised to rather create a new special user that you assign only
the roles/authorities you want it to have access to.**


### Creating a token
To create a new PAT, you have two choices:
* A. Create a token in the UI on your account's profile page.
* B. Create a token via the API.

### A. Creating a token on the account's page
Log in with your username and password, go to your profile page
(Click top right corner, and chose "Edit profile" from the dropdown).
On your user profile page, choose "Personal access tokens" from the
left side menu.
You should now be on the "Manage personal access tokens" page and see the
text: "You don't have any active personal access tokens".
Click "Generate new token" to make a new token.
A "Generate new token" popup will be shown and present you with two choices:

#### 1. Server/script context:
_"This type is used for integrations and scripts that won't be accessed by a browser"._

If you plan to use the token in an application, a script or similar, this
type should be your choice.

#### 2. Browser context:
_"This type us used for applications, like public portals, that will be accessed with a web browser"._

If you need to link to DHIS2 on a webpage, or e.g. embed in an iframe,
this is probably the type of token you want.


### Configuring your token

After choosing what token type you want, you can configure different access constraints on
your token. By constraint, we mean how to limit and narrow down how your token can be used.
This can be of crucial importance if you plan on using the token in a public environment,
e.g. on a public dashboard on another site, embedded in an iframe.
Since tokens always have the same access/authorities that your user currently has, taking special 
care is needed if you intend to use it in any environment you don't have 100% control over.

**NB**: If anyone else gets their hands on your token, they can do anything your user can do. 
It is not possible to distinguish between actions performed using the token and other actions
performed by your user.

**Important**: It is strongly advised that you create a separate unique user with only the roles/authorities
you want the token to have if you plan on using PAT tokens in a non-secure and/or public environment,
e.g. on a PC or server, you don't have 100% control over, or "embedded" in a webpage on another server.

#### The different constraint types are as follows:
* Expiry time
* Allowed UP addresses
* Allowed HTTP methods
* Allowed HTTP referrers

##### Expiry time
Expiry time simply sets for how long you want your token to be usable, the default is 30
days. After the expiry time, the token will simply return a 401 (Unauthorized) message.
You can set any expiry time you want, but it is strongly advised that you set an expiry time 
that is reasonable for your use case.

#### Allowed IP addresses
This is a comma-separated list of IP addresses you want to limit where the token requests can come from.

**Important**: IP address validation relies on the X-Forwarded-For header, which can be spoofed.
For security, make sure a load balancer or reverse proxy overwrites this header.

#### Allowed HTTP methods
A comma-separated list of HTTP methods you want your token to be able to use.
If you only need your token to view data, not modify or delete, selecting only the GET HTTP method 
makes sense.

#### Allowed HTTP referrers
HTTP referer is a header added to the request, when you click on a link, this says which site/page 
you were on when you clicked the link. 
Read more about the HTTP referer header here: https://en.wikipedia.org/wiki/HTTP_referer

This can be used to limit the use of a "public" token embedded on another page on another site. 
Making sure that the referer header match the site hostname in should come from, can
help avoid abuse of the token, e.g. if someone posts it on a public forum.

**Important**: this is not a security feature. The `referer` header can easily be spoofed.
This setting is intended to discourage unauthorized third-party developers from connecting
to public access instances.

#### Saving your token:
When you are done configuring your token, you can save it by clicking the "Generate new token"
button, on the bottom right of the pop-up.
When doing so the token will be saved and a secret token key will be generated on the server.
The new secret token key will be shown on the bottom of the PAT token list with a green background,
and the text "Newly created token".
The secret token key will look similar to this:
```
d2pat_5xVA12xyUbWNedQxy4ohH77WlxRGVvZZ1151814092
```
**Important**: This generated secret token key will only be shown once, so it is important 
that you copy the token key now and save it in a secure place for use later. 
The secret token key will be securely hashed on the server, and only the hash of this secret token 
key will be saved to the database. This is done to minimize the security impact if someone gets 
unauthorized access to the database, similar to the way passwords are handled.

### B. Creating a token via the API

Example of how to create a new Personal Access Token with the API:

```
POST https://play.dhis2.org/dev/api/apiToken
Content-Type: application/json
Authorization: Basic admin district

{}
```
**NB**: Remember the empty JSON body (`{}`) in the payload! 

This will return a response containing a token similar to this:
```json
{
  "httpStatus": "Created",
  "httpStatusCode": 201,
  "status": "OK",
  "response": {
     "responseType": "ApiTokenCreationResponse",
     "key": "d2pat_5xVA12xyUbWNedQxy4ohH77WlxRGVvZZ1151814092",
     "uid": "jJYrtIVP7qU",
     "klass": "org.hisp.dhis.security.apikey.ApiToken",
     "errorReports": []
  }
}
```

**Important**: The token key will only be shown once here in this response.
You need to copy and save this is in a secure place for use later!

The token itself consists of three parts:
1. Prefix: (`d2pat_`) indicates what type of token this is.
2. Random bytes Base64 encoded: (`5xVA12xyUbWNedQxy4ohH77WlxRGVvZZ`)
3. CRC32 checksum: (`1151814092`) the checksum part is padded with 0 so that it always stays ten characters long.


#### Configure your token via the API:
To change any of the constraints on your token, you can issue the following HTTP API request.

**NB**: Only the constraints are possible to modify after the token is created! 

```
PUT https://play.dhis2.org/dev/api/apiToken/jJYrtIVP7qU
Content-Type: application/json
Authorization: Basic admin district
```

```json
{
  "version": 1,
  "type": "PERSONAL_ACCESS_TOKEN",
  "expire": 163465349603200,
  "attributes": [
      {
        "type": "IpAllowedList",
        "allowedIps": ["192.168.0.1"]
      },
      {
        "type": "MethodAllowedList",
        "allowedMethods": ["GET"]
      }
  ]
}
```

### Using your Personal Access Token

To issue a request with your newly created token, use the Authorization header
accordingly.
The Authorization header format is:
```
Authorization: ApiToken [YOUR_SECRET_API_TOKEN_KEY]
```
**Example**:
```
GET https://play.dhis2.org/dev/api/apiToken/jJYrtIVP7qU
Content-Type: application/json
Authorization: ApiToken d2pat_5xVA12xyUbWNedQxy4ohH77WlxRGVvZZ1151814092
```


### Deleting your Personal Access Token
You can delete your PATs either in the UI on your profile page where you created it,
or via the API like this:
```
DELETE https://play.dhis2.org/dev/api/apiToken/jJYrtIVP7qU
Content-Type: application/json
Authorization: ApiToken d2pat_5xVA12xyUbWNedQxy4ohH77WlxRGVvZZ1151814092
```


## OAuth2 { #webapi_oauth2 } 

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
HTTP status message *forbidden* and a descriptive message.

Table: WebMessage properties

| Name | Description |
|---|---|
| httpStatus | HTTP Status message for this response, see RFC 2616 (Section 10) for more information. |
| httpStatusCode | HTTP Status code for this response, see RFC 2616 (Section 10) for more information. |
| status | DHIS2 status, possible values are *OK* &#124; *WARNING* &#124; *ERROR*, where `OK` means everything was successful, `ERROR` means that operation did not complete and `WARNING` means the operation was partially successful, if the message contains a `response` property, please look there for more information. |
| message | A user-friendly message telling whether the operation was a success or not. |
| devMessage | A more technical, developer-friendly message (not currently in use). |
| response | Extension point for future extensions of the `WebMessage` format. |

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
    THIS_BIWEEK, LAST_BIWEEK, LAST_4_BIWEEKS
    THIS_MONTH, LAST_MONTH, THIS_BIMONTH, LAST_BIMONTH, THIS_QUARTER, LAST_QUARTER,
    THIS_SIX_MONTH, LAST_SIX_MONTH, MONTHS_THIS_YEAR, QUARTERS_THIS_YEAR,
    THIS_YEAR, MONTHS_LAST_YEAR, QUARTERS_LAST_YEAR, LAST_YEAR, LAST_5_YEARS, LAST_10_YEARS, LAST_10_FINANCIAL_YEARS, LAST_12_MONTHS, 
    LAST_3_MONTHS, LAST_6_BIMONTHS, LAST_4_QUARTERS, LAST_2_SIXMONTHS, THIS_FINANCIAL_YEAR,
    LAST_FINANCIAL_YEAR, LAST_5_FINANCIAL_YEARS

### Custom date periods { #webapi_date_custom_date_periods }

Analytics `query` resources support extra parameters to express periods.

Default `pe` dimension will fall back to:

- `eventDate` for `/analytics/events/query`
- `enrollmentDate` for `/analytics/enrollments/query`

Adding conditions on one or more date fields and combining them are allowed.

#### Usage of custom date periods

In resources supporting custom date periods, there are extra query parameters that will be combined to express conditions on the time dimension.

| custom date period | events query resource  | enrollment query resource |
|--------------------|------------------------|---------------------------|
| `eventDate`        | [x]                    | [ ]                       |
| `enrollmentDate`   | [x]                    | [x]                       |
| `scheduledDate`    | [x]                    | [ ]                       |
| `incidentDate`     | [x]                    | [x]                       |
| `lastUpdated`      | [x]                    | [x]                       |

Conditions can be expressed in the following form:

`analytics/events/query/...?...&eventDate=2021&...`

It's possible to combine more time fields in the same query:

`analytics/events/query/...?...&eventDate=2021&incidentDate=202102&...`

All of these conditions can be combined with `pe` dimension:

`analytics/events/query/...?...&dimension=pe:TODAY&enrollmentDate=2021&incidentDate=202102&...`

Supported formats are described in "date and period format" above. An extra format is provided to express a range of dates: `yyyyMMdd_yyyyMMdd` and `yyyy-MM-dd_yyyy-MM-dd`.

In the example bellow, the endpoint will return events that are scheduled to happen between 20210101 and 20210104:

`analytics/events/query/...?...&dimension=pe:TODAY&enrollmentDate=2021&incidentDate=202102&scheduledDate=20210101_20210104&...`


## Authorities
System authority ids and names can be listed using:

    /api/authorities

It returns the following format:
```json
{
  "systemAuthorities": [
    {
      "id": "ALL",
      "name": "ALL"
    },
    {
      "id": "F_ACCEPT_DATA_LOWER_LEVELS",
      "name": "Accept data at lower levels"
    }
  ]
}
```

