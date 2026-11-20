# Google Earth Engine service account configuration { #install_google_service_account_configuration }

The key file of a Google service account gives DHIS2 access to Google Earth
Engine. The Maps app uses it for Earth Engine layers, the Climate app for
climate and environmental data, and the Import/Export app to import Earth Engine
data. DHIS2 uses the key for Earth Engine only.

To create the Google Cloud project, the service account and its key, follow
[Google Earth Engine sign-up](https://docs.dhis2.org/en/topics/tutorials/google-earth-engine-sign-up.html).

## Install the key file

Rename the key file to `dhis-google-auth.json` and put it in the
`DHIS2_HOME` directory (the same location as the `dhis.conf` file).
As an example this location could be:

    /home/dhis/config/dhis-google-auth.json

DHIS2 reads the key file when it starts: restart DHIS2 after adding or
replacing it.

## Check that DHIS2 loaded the key { #check_google_service_account_configuration }

When DHIS2 starts, the server log shows one of these lines:

| Log line | Meaning |
|---|---|
| `Loaded dhis-google-auth.json authentication file` | DHIS2 loaded the key. |
| `Could not find dhis-google-auth.json` | There is no file with this name in the `DHIS2_HOME` directory. |
| `Could not load credential from dhis-google-auth.json` | The file is there, but DHIS2 can't read it as a service account key. |

Once the key is loaded, `GET /api/tokens/google` returns a short-lived Earth
Engine access token, with the properties `access_token`, `expires_in` (in
seconds) and `client_id`. The Maps, Climate and Import/Export apps request this
token to access Earth Engine. If it doesn't return a token, check the server
log. See [Google Service Account](https://docs.dhis2.org/en/develop/using-the-api/dhis-core-version-master/settings-and-configuration.html#webapi_tokens_google_service_account)
in the Web API documentation.

## Replace or revoke a key { #replace_google_service_account_key }

Replace the key when it may have been exposed, or when people who had a copy
should no longer have access:

1. Create a new key for the same service account, as in Step 4 of
   [Google Earth Engine sign-up](https://docs.dhis2.org/en/topics/tutorials/google-earth-engine-sign-up.html).
2. Replace `dhis-google-auth.json` in the `DHIS2_HOME` directory with the new
   key file, and restart DHIS2.
3. Check that DHIS2 loaded the new key, as described in
   [Check that DHIS2 loaded the key](#check_google_service_account_configuration).
4. In the Google Cloud console, go to **IAM & Admin → Service Accounts**, click
   the service account, open the **Keys** tab, and click **Delete** for the old
   key. A deleted key can't be used again or restored.

Access tokens already issued with the old key stay valid until they expire, up
to one hour for the tokens DHIS2 requests.

To stop DHIS2 from using Earth Engine, remove `dhis-google-auth.json`, restart
DHIS2, and delete the key in the Google Cloud console.

See Google's guide
[Create and delete service account keys](https://docs.cloud.google.com/iam/docs/keys-create-delete).
