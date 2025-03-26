# OpenID Connect (OIDC) configuration { #install_oidc_configuration } 

DHIS2 supports the OpenID Connect (OIDC) identity layer for single sign-in (SSO). OIDC is a standard authentication protocol that lets users sign in with an identity provider (IdP) such as for example Google. After users have successfully signed in to their IdP, they will be automatically signed in to DHIS2.

This section provides general information about using DHIS2 with an OIDC provider, as well as complete configuration examples.

The DHIS2 OIDC 'authorization code' authentication flow:

1. A user attempts to log in to DHIS2 and clicks the OIDC provider button on the login page.

2. DHIS2 redirects the browser to the IdP's login page.

3. If not already logged in, the user is prompted for credentials. When successfully authenticated, the IdP responds with a redirect back to the DHIS2 server. The redirect includes a unique authorization code generated for the user.

4. The DHIS2 server internally sends the user's authorization code back to the IdP server along with its own client id and client secret credentials.

5. The IdP returns an ID token back to the DHIS2 server. DHIS2 server performs validation of the token.

6. The DHIS2 server looks up the internal DHIS2 user with the mapping claims found in the ID token (defaults to email), authorizes the user and completes the login process.

## Requirements for using OIDC with DHIS2:

### IdP server account

You must have an admin account on an online identity provider (IdP) or on a standalone server that are supported by DHIS2.

The following IdPs are currently supported and tested:

* Google
* Azure AD
* WSO2
* Okta (See separate tutorial: [here](#configure-openid-connect-with-okta))

There is also a **generic provider** config which can support "any" OIDC compatible provider.

### DHIS2 user account

You must explicitly create the users in the DHIS2 server before they can log in with the identity provider. Importing them from an external directory such as Active Directory is currently not supported. Provisioning and management of users with an external identity store is not supported by the OIDC standard.

### IdP claims and mapping of users

To sign in to DHIS2 with OIDC, a given user must be provisioned in the IdP and then mapped to a pre created user account in DHIS2. OIDC uses a method that relies on claims to share user account attributes with other applications. Claims include user account attributes such as email, phone number, name, etc. DHIS2 relies on a IdP claim to map user accounts from the IdP to those in the DHIS2 server. By default, DHIS2 expects the IdP to pass the _email_ claim. Depending on your IdP, you may need to configure DHIS2 to use a different IdP claim.

If you are using Google or Azure AD as an IdP, the default behavior is to use the _email_ claim to map IdP identities to DHIS2 user accounts.

> **Note**
>
> In order for a DHIS2 user to be able to log in with an IdP, the user profile checkbox: *External authentication only OpenID or LDAP* must be checked and *OpenID* field must match the claim (mapping claim) returned by the IdP. Email is the default claim used by both Google and Azure AD.

## Configure the Identity Provider for OIDC

This topic provides general information about configuring an identity provider (IdP) to use OIDC with DHIS2. This is one step in a multi-step process. Each IdP has slightly different ways to configure it. Check your IdP's own documentation for how to create and configure an OIDC application. Here we refer to the DHIS2 server as the OIDC "application".

### Redirect URL

All IdPs will require a redirect URL to your DHIS2 server. 
You can construct it using the following pattern:

```
(protocol):/(your DHIS2 host)/oauth2/code/PROVIDER_KEY
```

Example when using Google IdP:

```
https://mydhis2-server.org/oauth2/code/google
```

External links to instructions for configuring your IdP:

* [Google](https://developers.google.com/identity/protocols/oauth2/openid-connect)
* [Azure AD tutorial](https://medium.com/xebia-engineering/authentication-and-authorization-using-azure-active-directory-266980586ab8)


## Example setup for Google

1. Register an account and sign in. For example, for Google, you can go to the Google [developer console](https://console.developers.google.com).
2. In the Google developer dashboard, click 'create a new project'.
3. Follow the instructions for creating an OAuth 2.0 client ID and client secret.
4. Set your "Authorized redirect URL" to: `https://mydhis2-server.org/oauth2/code/google`
5. Copy and keep the "client id" and "client secret" in a secure place.

> **Tip**
>
> When testing on a local DHIS2 instance running for example on your laptop, you can use localhost as the redirect URL, like this: `https://localhost:8080/oauth2/code/google`
> *Remember to also add the redirect URL in the Google developer console*

### Google dhis.conf example:
```properties
# Enables OIDC login
oidc.oauth2.login.enabled = on

# Client id, given to you in the Google developer console
oidc.provider.google.client_id = <my-client-id>

# Client secret, given to you in the Google developer console
oidc.provider.google.client_secret = <my-client-secret>

# [Optional] Authorized redirect URI, the same as set in the Google developer console 
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public url, like the example below.
oidc.provider.google.redirect_url = https://mydhis2-server.org/oauth2/code/google

# [Optional] Where to redirect after logging out.
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public url, like the example below. 
oidc.logout.redirect_url = https://mydhis2-server.org
```

## Example setup for Azure AD

Make sure your Azure AD account in the Azure portal is configured with a redirect URL like: `(protocol):/(host)/oauth2/code/PROVIDER_KEY`. 
To register your DHIS2 server as an "application" in the Azure portal, follow these steps:

> **Note**
>
> PROVIDER_KEY is the "name" part of the configuration key, example: "oidc.provider.PROVIDER_KEY.tenant = My Azure SSO"
> If you have multiple Azure providers you want to configure, you can use this name form: (azure.0), (azure.1) etc.
> Redirect URL example: https://mydhis2-server.org/oauth2/code/azure.0

1. Search for and select *App registrations*.
2. Click *New registration*.
3. In the *Name* field, enter a descriptive name for your DHIS2 instance.
4. In the *Redirect URI* field, enter the redirect URL as specified above.
5. Click *Register*.

### Azure AD dhis.conf example:
```properties
# Enables OIDC login
oidc.oauth2.login.enabled = on

# First provider (azure.0):

# Tenant ID, also called Directory ID, in UUID format
oidc.provider.azure.0.tenant = <my-tenant-id>

# Client id, given to you in the Azure portal, in UUID format
oidc.provider.azure.0.client_id = <my-client-id>

# Client secret, given to you in the Azure portal
oidc.provider.azure.0.client_secret =<my-client-secret>

# [Optional] Authorized redirect URI, the as set in Azure portal 
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public URL
oidc.provider.azure.0.redirect_url = https://mydhis2-server.org/oauth2/code/azure.0

# [Optional] Where to redirect after logging out.
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public URL
oidc.logout.redirect_url = https://mydhis2-server.org

# [Optional], defaults to 'email'
oidc.provider.azure.0.mapping_claim = email

# [Optional], defaults to 'on'
oidc.provider.azure.0.support_logout = on

# Second provider (azure.1):

# Tenant ID, also called Directory ID, in UUID format
oidc.provider.azure.1.tenant = <my-client-id>
...
```

## Generic providers

The generic provider can be used to configure "any" standard OIDC provider which are compatible with "Spring Security".

In the example below we will configure the Norwegian governmental _HelseID_ OIDC provider using the provider key `helseid`.

The defined provider will appear as a button on the login page with the provider key as the default name, 
or the value of the `display_alias` if defined. The provider key is arbitrary and can be any alphanumeric string, 
except for the reserved names used by the specific providers (`google`, `azure.0,azure.1...`, `wso2`).

> **Note**
> The generic provider uses the following hardcoded configuration defaults:
> **(These are not possible to change)**
> * Client Authentication, `ClientAuthenticationMethod.BASIC`: [rfc](https://tools.ietf.org/html/rfc6749#section-2.3)
> * Authenticated Requests, `AuthenticationMethod.HEADER`: [rfc](https://tools.ietf.org/html/rfc6750#section-2) 

### Generic (helseid) dhis.conf example:

```properties
# Enables OIDC login
oidc.oauth2.login.enabled = on

# Required variables:
oidc.provider.helseid.client_id = <my-client-id>
oidc.provider.helseid.client_secret = <my-client-secret>
oidc.provider.helseid.mapping_claim = helseid://claims/identity/email
oidc.provider.helseid.authorization_uri = https://helseid.no/connect/authorize
oidc.provider.helseid.token_uri = https://helseid.no/connect/token
oidc.provider.helseid.user_info_uri = https://helseid.no/connect/userinfo
oidc.provider.helseid.jwk_uri = https://helseid.no/.well-known/openid-configuration/jwks
oidc.provider.helseid.end_session_endpoint = https://helseid.no/connect/endsession
oidc.provider.helseid.scopes = helseid://scopes/identity/email

# [Optional] Authorized redirect URI, the as set in Azure portal 
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public url, like the example below.
oidc.provider.helseid.redirect_url = https://mydhis2-server.org/oauth2/code/helseid

# [Optional], defaults to 'on'
oidc.provider.helseid.enable_logout = on

# [Optional] Where to redirect after logging out.
# If your public hostname is different from what the server sees internally, 
# you need to provide your full public URL, like the example below.
oidc.logout.redirect_url = https://mydhis2-server.org

# [Optional] PKCE support, see: https://oauth.net/2/pkce/), default is 'false'
oidc.provider.helseid.enable_pkce = on

# [Optional] Extra variables appended to the request. 
# Must be key/value pairs like: "KEY1 VALUE1,KEY2 VALUE2,..."
oidc.provider.helseid.extra_request_parameters = acr_values lvl4,other_key value2

# [Optional] This is the alias/name displayed on the login button in the DHIS2 login page
oidc.provider.helseid.display_alias = HelseID

# [Optional] Link to an url for a logo. (Can use absolute or relative URLs)
oidc.provider.helseid.logo_image = ../security/btn_helseid.svg

# [Optional] CSS padding for the logo image
oidc.provider.helseid.logo_image_padding = 0px 1px
```

## JWT bearer token authentication

Authentication with *JWT bearer tokens* can be enabled for clients which API-based when OIDC is configured. 
The DHIS2 Android client is such a type of client and have to use JWT authentication if OIDC login is enabled.

> **Note**
>
> DHIS2 currently only supports the OAuth2 authorization code grant flow for authentication with JWT, (also known as "three-legged OAuth")
> DHIS2 currently only supports using Google as an OIDC provider when using JWT tokens


## Requirements
* Configure your Google OIDC provider as described above 
* Disable the config parameter ```oauth2.authorization.server.enabled``` by setting it to 'off'
* Enable the config parameter ```oidc.jwt.token.authentication.enabled``` by setting it to 'on'
* Generate an Android OAuth2 client_id as described [here](https://developers.google.com/identity/protocols/oauth2/native-app#creatingcred)

## JWT authentication example

The following `dhis.conf` section shows an example of how to enable JWT authentication for an API-based client.

```properties
# Enables OIDC login
oidc.oauth2.login.enabled = on

# Minimum required config variables:
oidc.provider.google.client_id = <my-client-id>
oidc.provider.google.client_secret = <my-client-secret>

# Enable JWT support
oauth2.authorization.server.enabled = off
oidc.jwt.token.authentication.enabled = on

# Define client 1 using JWT tokens
oidc.provider.google.ext_client.0.client_id = <my-jwt-client-id>

# Define client 2 using JWT tokens
oidc.provider.google.ext_client.1.client_id = <my-jwt-client-id>
```

> **Note**
>
> [Check out our tutorial for setting up Okta as a generic OIDC provider.](../../../topics/tutorials/configure-oidc-with-okta.md)

## Connecting a single identity provider account to multiple DHIS2 accounts { #connect_single_identity_to_multiple_accounts }

DHIS2 has the ability to map a single identity provider account to multiple DHIS2 accounts. API calls are available to list the linked accounts and also switch between then.

When this option is selected, the `openid` database field in the `userinfo` table does not need to be unique.  When presented with an `openid` value from the identity provider, DHIS2 will log in the user that most recently logged in.

The following `dhis.conf` section shows how to enable linked accounts.

```properties
# Enable a single OIDC account to log in as one of several DHIS2 accounts
linked_accounts.enabled = on
```

For instructions on how to list linked accounts and switch between them, see [*Switching between user accounts connected to the same identity provider account* in the Users chapter of the developer documentation.](../../../develop/using-the-api/dhis-core-version-master/users.html#switching-between-user-accounts-connected-to-the-same-identity-provider-account)
