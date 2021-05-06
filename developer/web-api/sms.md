# SMS

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



Table: Gateway response codes

| Response code | Response Message | Detail Description |
|---|---|---|
| RESULT_CODE_0 | success | Message has been sent successfully |
| RESULT_CODE_1 | scheduled | Message has been scheduled successfully |
| RESULT_CODE_22 | internal fatal error | Internal fatal error |
| RESULT_CODE_23 | authentication failure | Authentication credentials are incorrect |
| RESULT_CODE_24 | data validation failed | Parameters provided in request are incorrect |
| RESULT_CODE_25 | insufficient credits | Credit is not enough to send message |
| RESULT_CODE_26 | upstream credits not available | Upstream credits not available |
| RESULT_CODE_27 | exceeded your daily quota | You have exceeded your daily quota |
| RESULT_CODE_40 | temporarily unavailable | Service is temporarily down |
| RESULT_CODE_201 | maximum batch size exceeded | Maximum batch size exceeded |
| RESULT_CODE_200 | success | The request was successfully completed |
| RESULT_CODE_202 | accepted | The message(s) will be processed |
| RESULT_CODE_207 | multi-status | More than one message was submitted to the API; however, not all messages have the same status |
| RESULT_CODE_400 | bad request | Validation failure (such as missing/invalid parameters or headers) |
| RESULT_CODE_401 | unauthorized | Authentication failure. This can also be caused by IP lockdown settings |
| RESULT_CODE_402 | payment required | Not enough credit to send message |
| RESULT_CODE_404 | not found | Resource does not exist |
| RESULT_CODE_405 | method not allowed | Http method is not support on the resource |
| RESULT_CODE_410 | gone | Mobile number is blocked |
| RESULT_CODE_429 | too many requests | Generic rate limiting error |
| RESULT_CODE_503 | service unavailable | A temporary error has occurred on our platform - please retry |

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



Table: User query parameters

| Parameter | Type | Description |
|---|---|---|
| message | String | This is mandatory parameter which carries the actual text message. |
| originator | String | This is mandatory parameter which shows by whom this message was actually sent from. |
| gateway | String | This is an optional parameter which gives gateway id. If not present default text "UNKNOWN" will be stored |
| receiveTime | Date | This is an optional parameter. It is timestamp at which message was received at the gateway. |

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



Table: Generic SMS gateway parameters

| Parameter | Type | Description |
|---|---|---|
| name | String | name of the gateway |
| configurationTemplate | String | Configuration template which get populated with parameter values. For example configuration template given above will be populated like this { "to": "+27001234567", "body": "Hello World!"} |
| useGet | Boolean | Http POST nethod will be used by default. In order to change it and Http GET, user can set useGet flag to true. |
| contentType | String | Content type specify what type of data is being sent. Supported types are APPLICATION_JSON, APPLICATION_XML, FORM_URL_ENCODED, TEXT_PLAIN |
| urlTemplate | String | Url template |
| header | Boolean | If parameter needs to be sent in Http headers |
| encode | Boolean | If parameter needs to be encoded |
| key | String | parameter key |
| value | String | parameter value |
| confidential | Boolean | If parameter is confidential. This parameter will not be exposed through API |
| sendUrlParameters | Boolean | If this flag is checked then urlTemplate can be appended with query parameters. This is usefull if gateway API only support HTTP GET. Sample urlTemplate looks like this `"urlTemplate":"https://samplegateway.com/messages?apiKey={apiKey}&to={recipients},content={text},deliveryreport={dp}"` |

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
