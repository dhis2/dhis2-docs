# Google service account configuration { #install_google_service_account_configuration } 

DHIS2 can connect to various Google service APIs. For instance, the
DHIS2 Maps app can utilize the Google Earth Engine API to load Earth Engine map
layers. There are 2 ways to obtain the Google API key.

## Set it up yourself

Set up a Google service account and create a private key:

  - Create a Google service account. Please consult the [Google identify
    platform](https://developers.google.com/identity/protocols/OAuth2ServiceAccount#overview)
    documentation.

  - Visit the [Google cloud console](https://console.cloud.google.com)
    and go to API Manager \> Credentials \> Create credentials \>
    Service account key. Select your service account and JSON as key
    type and click Create.

  - Rename the JSON key to *dhis-google-auth.json*.

After downloading the key file, put the `dhis-google-auth.json` file in
the `DHIS2_HOME` directory (the same location as the `dhis.conf` file).
As an example this location could be:

    /home/dhis/config/dhis-google-auth.json

## Send an email to set up the Google Earth Engine API key

If you only intend to use the key for the Google Earth Engine map layers, you
can simply send an email. See the [Google Earth Engine API key documentation](https://docs.dhis2.org/en/topics/tutorials/google-earth-engine-sign-up.html).

## Bing Maps API key { #install_bing_maps_api_key }

To enable use of Bing Maps basemap layers, you need to set up the Bing Maps API
key. See [Bing Maps API key documentation](https://www.microsoft.com/en-us/maps/bing-maps/create-a-bing-maps-key)
for information on setting up the key.

