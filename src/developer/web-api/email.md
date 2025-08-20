# Email

## Email { #webapi_email } 

The Web API features a resource for sending emails. For emails to be
sent it is required that the SMTP configuration has been properly set up
and that a system notification email address for the DHIS2 instance has
been defined. You can set SMTP settings from the email settings screen
and system notification email address from the general settings screen
in DHIS2.

    /api/33/email

### System notification { #webapi_email_system_notification } 

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

The previous example is convenient for short messages. However, since the
message is passed as a query string, it can quickly hit the URL length
limit of the server. For longer messages, it is better to send the data
in the POST request body. The following example shows how to send an
email with a longer message in the request body:

```bash
curl -u admin:district -X POST 'localhost/api/33/email/notification' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'recipients=recipient1@example.com,recipient2@example.com' \
  --data-urlencode 'subject=Important System Update' \
  --data-urlencode 'message=Dear user, we are writing to inform you about an important system update that will take place this weekend. The system will be unavailable for a few hours. We apologize for any inconvenience this may cause. Please plan your work accordingly. Best regards, The DHIS2 Team.'
```

To send an email with an HTML body, you can simply provide the HTML content
in the `message` parameter. The email client should interpret the
HTML and render it accordingly. Note that the `Content-Type` header in
the `curl` command should be `application/x-www-form-urlencoded`, as the
data is sent as URL-encoded form data. The following example shows how
to send an email with a simple HTML table:

```bash
curl -u admin:district -X POST 'localhost/api/33/email/notification' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'recipients=recipient1@example.com,recipient2@example.com' \
  --data-urlencode 'subject=System Maintenance Schedule' \
  --data-urlencode 'message=<html><body><h2>System Maintenance</h2><p>Dear user,</p><p>We are writing to inform you about scheduled system maintenance. The following table shows the maintenance schedule for the upcoming week:</p><table border="1"><tr><th>Day</th><th>Time</th></tr><tr><td>Monday</td><td>10 PM - 11 PM</td></tr><tr><td>Wednesday</td><td>10 PM - 11 PM</td></tr></table><p>We apologize for any inconvenience this may cause. Please plan your work accordingly.</p><p>Best regards,<br>The DHIS2 Team</p></body></html>'
```

### Test message { #webapi_email_test_message } 

To test whether the SMTP setup is correct by sending a test email to
yourself you can interact with the *test* resource. To send test emails
it is required that your DHIS2 user account has a valid email address
associated with it. You can send a test email like this:

```bash
curl "localhost/api/33/email/test" -X POST -H "Content-Type:application/json" -u admin:district
```



