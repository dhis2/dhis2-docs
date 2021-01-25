# Users

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

### User expiration

<!--DHIS2-SECTION-ID:webapi_user_expiration-->

An expiration date can be set for an user account.
It marks the point in time from which the user account has expired 
and can no longer be used.
Expired user can no longer log in.

To update the expiration date of user with UID `tH7WIiIJ0O3` 
and set it to the date `2021-01-01` use:

```bash
curl -X POST "localhost/api/36/users/tH7WIiIJ0O3/expired?date=2021-01-01"
```

To unset the expiration date so that the account never expires 
use accordingly:

```bash
curl -X POST "localhost/api/36/users/tH7WIiIJ0O3/unexpired"
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


