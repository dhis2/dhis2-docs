# Apps

## Apps

<!--DHIS2-SECTION-ID:webapi_apps-->

The `/api/apps` endpoint can be used for installing, deleting and
listing apps. The app key is based on the app name, but with all
non-alphanumerical characters removed, and spaces replaced with a dash.
*My app!* will return the key *My-app*.

> **Note**
>
> Previous to 2.28, the app key was derived from the name of the ZIP
> archive, excluding the file extension. URLs using the old format
> should still return the correct app in the api.

    /api/33/apps

### Get apps

<!--DHIS2-SECTION-ID:webapi_get_apps-->

> **Note**
>
> Previous to 2.28 the app property folderName referred to the actual
> path of the installed app. With the ability to store apps on cloud
> services, folderName's purpose changed, and will now refer to the app
> key.

You can read the keys for apps by listing all apps from the apps
resource and look for the *key* property. To list all installed apps in
JSON:

```bash
curl -u user:pass -H "Accept: application/json" "http://server.com/api/33/apps"
```

You can also simply point your web browser to the resource URL:

    http://server.com/api/33/apps

The apps list can also be filtered by app type and by name, by appending
one or more *filter* parameters to the URL:

    http://server.com/api/33/apps?filter=appType:eq:DASHBOARD_APP&filter=name:ilike:youtube

App names support the *eq* and *ilike* filter operators, while *appType*
supports *eq* only.

### Install an app

<!--DHIS2-SECTION-ID:webapi_install_app-->

To install an app, the following command can be issued:

```bash
curl -X POST -u user:pass -F file=@app.zip "http://server.com/api/33/apps"
```

### Delete an app

<!--DHIS2-SECTION-ID:webapi_delete_app-->

To delete an app, you can issue the following command:

```bash
curl -X DELETE -u user:pass "http://server.com/api/33/apps/<app-key>"
```

### Reload apps

<!--DHIS2-SECTION-ID:webapi_reload_apps-->

To force a reload of currently installed apps, you can issue the
following command. This is useful if you added a file manually directly
to the file system, instead of uploading through the DHIS2 user
interface.

```bash
curl -X PUT -u user:pass "http://server.com/api/33/apps"
```

### Share apps between instances

<!--DHIS2-SECTION-ID:webapi_share_apps_between_instances-->

If the DHIS2 instance has been configured to use cloud storage, apps
will now be installed and stored on the cloud service. This will enable
multiple instances share the same versions on installed apps, instead of
installing the same apps on each individual instance.

> **Note**
>
> Previous to 2.28, installed apps would only be stored on the instance's
> local filesystem. Apps installed before 2.28 will still be available on the
> instance it was installed, but it will not be shared with other
> instances, as it's still located on the instances local filesystem.

## App store

<!--DHIS2-SECTION-ID:webapi_app_store-->

The Web API exposes the content of the DHIS2 App Store as a JSON
representation which can found at the `/api/appHub` resource.

    /api/33/appHub

### Get apps

<!--DHIS2-SECTION-ID:webapi_get_app_store_apps-->

You can retrieve apps with a GET request:

    GET /api/33/appHub

A sample JSON response is described below.

```json
{
  [
    {
      "name": "Tabular Tracker Capture",
      "description": "Tabular Tracker Capture is an app that makes you more effective.",
      "sourceUrl": "https://github.com/dhis2/App-repository",
      "appType": "DASHBOARD_WIDGET",
      "status": "PENDING",
      "id": "NSD06BVoV21",
      "developer": {
        "name": "DHIS",
        "organisation": "Uio",
        "address": "Oslo",
        "email": "dhis@abc.com",
      },
      "versions": [
        {
          "id": "upAPqrVgwK6",
          "version": "1.2",
          "minDhisVersion": "2.17",
          "maxDhisVersion": "2.20",
          "downloadUrl": "https://dhis2.org/download/appstore/tabular-capture-12.zip",
          "demoUrl": "http://play.dhis2.org/demo"
        }
      ],
      "images": [
        {
          "id": "upAPqrVgwK6",
          "logo": "true",
          "imageUrl": "https://dhis2.org/download/appstore/tabular-capture-12.png",
          "description": "added feature snapshot",
          "caption": "dialog",
        }
      ]
    }
  ]
}
```

### Install apps

<!--DHIS2-SECTION-ID:webapi_install_app_store_apps-->

You can install apps on your instance of DHIS2 assuming you have the
appropriate permissions. An app is referred to using the `id` property
of the relevant version of the app. An app is installed with a POST
request with the version id to the following resource:

    POST /api/33/appHub/{app-version-id}
