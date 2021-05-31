# SMS

## Short Message Service (SMS) { #webapi_sms } 

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

## SMS Commands { #webapi_sms_commands } 

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


