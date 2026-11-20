# Google service account configuration { #install_google_service_account_configuration } 

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
