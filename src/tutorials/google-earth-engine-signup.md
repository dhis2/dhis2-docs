---
title: Signup for a Google Earth Engine account
---
# Signup for a Google Earth Engine account

To enable the [Google Earth Engine](https://earthengine.google.com/) layers in DHIS2 you must follow these steps.

1. **Set up or use an existing Google account**

    To sign up for Earth Engine access you need a Google account. You would likely prefer to use an account associated with your organization instead of a personal account for sustainability. Use an existing account or sign up for one [here](https://accounts.google.com/SignUp).

2. **Sign up for Earth Engine**

    Sign up for Earth Engine access [here](http://earthengine.google.com/signup).

3. **Create a Google service account**

    To use Earth Engine, you must authenticate to Google, and setting up a [service account](https://developers.google.com/earth-engine/service_account) allows you to do that. You first need to create a project from the Google API Console from [here](https://console.developers.google.com/iam-admin/projects). Then create a service account from [this link](https://console.developers.google.com/permissions/serviceaccounts). Select your newly created project and click "Open". Click "Create service account". Type a name for the service account, select "Furnish a new private key", and click "Create". Learn more about service accounts [here](https://developers.google.com/identity/protocols/oauth2/service-account#creatinganaccount).

4. **Whitelist the service account**

    To whitelist the account for Earth Engine access, send the email address associated with the client ID and secret to earthengine@google.com. The service account email address should look something like 23...m30@developer.gserviceaccount.com. Include the Gmail address of the account used to sign up for Earth Engine, and state that you will use Earth Engine for DHIS 2 purposes. Learn more [here](https://developers.google.com/earth-engine/service_account).

5. **Configure DHIS2 for Earth Engine**

    Using your newly created service account, log into the console, download credentials and configure it for DHIS2 as described in the installation guide [here](#install_google_service_account_configuration). Make sure you restart your DHIS2 instance. You should now be able to access the Earth Engine layer from the top menu in the GIS app. Enjoy!
