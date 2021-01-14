# Email

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



