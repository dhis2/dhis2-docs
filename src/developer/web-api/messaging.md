# Messaging

## Message conversations { #webapi_message_conversations } 

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

### Writing and reading messages { #webapi_writing_messages } 

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

### Managing messages { #webapi_managing_messages } 

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

### Message Attachments { #webapi_message_attachments } 

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

### Tickets and Validation Result Notifications { #webapi_messaging_tickets } 

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

