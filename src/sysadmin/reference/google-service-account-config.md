# Google service account configuration { #install_google_service_account_configuration } 

DHIS2 can connect to various Google service APIs. For instance, the
DHIS2 Maps app can utilize the Google Earth Engine API to load Earth Engine map
layers. DHIS2 connects to these APIs with the JSON key file of a Google
service account.

To create the Google Cloud project, the service account and its key, follow
[Accessing map layers from Google Earth Engine](https://docs.dhis2.org/en/topics/tutorials/google-earth-engine-sign-up.html).

## Install the key file

Rename the key file to `dhis-google-auth.json` and put it in the
`DHIS2_HOME` directory (the same location as the `dhis.conf` file).
As an example this location could be:

    /home/dhis/config/dhis-google-auth.json

DHIS2 reads the key file when it starts: restart DHIS2 after adding or
replacing it.

## Bing Maps API key { #install_bing_maps_api_key }

To enable use of Bing Maps basemap layers, you need to set up the Bing Maps API
key. See [Bing Maps API key documentation](https://www.microsoft.com/en-us/maps/bing-maps/create-a-bing-maps-key)
for information on setting up the key.

