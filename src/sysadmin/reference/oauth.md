# OAuth2 and OpenID Connect (OIDC) { #install_oauth2_oidc_configuration }

DHIS2's OAuth2 / OIDC stack has two sides:

1. **DHIS2 as an Authorization Server**. DHIS2 can issue its own OAuth2
   access tokens and OpenID Connect ID tokens. Web apps, server-to-server
   integrations, and the DHIS2 Android Capture app authenticate against
   it. This is built on top of
   [Spring Authorization Server](https://docs.spring.io/spring-authorization-server/reference/).
2. **DHIS2 as a Relying Party (OIDC login)**. Users can sign in to DHIS2
   with an external identity provider such as Google, Microsoft Entra ID
   (Azure AD), WSO2, Okta, or any standards-compliant OIDC provider.
   DHIS2 validates the ID token and matches it to a local user account.

Both sides can be enabled at the same time. This chapter covers both,
plus how client applications use the resulting tokens to call the DHIS2
API (JWT bearer authentication).


## Terminology

| Term | Meaning in this chapter |
|------|-------------------------|
| Authorization Server (AS) | The component that issues tokens. In DHIS2 this is Spring Authorization Server, enabled via `oauth2.server.enabled=on`. |
| Resource Server | The component that validates tokens and protects APIs. In DHIS2 this is the same process, the DHIS2 web API. |
| Identity Provider (IdP) | The OIDC provider that authenticates end users. Can be DHIS2 itself (internal) or an external provider (Google, Azure AD, …). |
| Relying Party (RP) | The OIDC client. When DHIS2 is logging users in via an external IdP, DHIS2 is the RP. |
| Registered client (OAuth2 client) | A database record describing an application allowed to request tokens from the AS. See [OAuth2 clients](#oauth2_clients). |
| DCR | Dynamic Client Registration (RFC 7591). Lets a client register itself at runtime instead of an admin creating it up front. Used by the Android Capture app. |
| IAT | Initial Access Token. A short-lived JWT that authorizes exactly one DCR registration call. |
| `private_key_jwt` | Client authentication method in which the client proves its identity by signing a JWT with its private key, rather than sending a shared secret (RFC 7523). |
| JWKS | JSON Web Key Set. The public-key document used to verify JWT signatures. |

---

## Enabling the authorization server { #enabling_the_authorization_server }

The authorization server is off by default. To turn it on, set in
`dhis.conf`:

```properties
# Public HTTPS base URL of this DHIS2 instance.
# Used as the OAuth2 issuer URI (the `iss` claim in issued tokens).
# Must be set; the authorization server refuses to start otherwise.
server.base.url = https://dhis2.example.org

# Turn on Spring Authorization Server.
oauth2.server.enabled = on
```

When `oauth2.server.enabled = on`, DHIS2 exposes the following endpoints
(paths are the Spring Authorization Server defaults):

| Endpoint | Path | Purpose |
|----------|------|---------|
| Authorization | `/oauth2/authorize` | User-facing authorization endpoint (authorization_code flow). |
| Token | `/oauth2/token` | Token exchange (authorization_code, refresh_token, client_credentials, `private_key_jwt` client assertion). |
| JWKS | `/oauth2/jwks` | Public keys used to verify issued JWTs. |
| Revocation | `/oauth2/revoke` | Revoke an access or refresh token (RFC 7009). |
| Introspection | `/oauth2/introspect` | Token introspection (RFC 7662). |
| OIDC userinfo | `/oauth2/userinfo` | Standard OIDC userinfo endpoint. |
| OIDC discovery | `/.well-known/openid-configuration` | OIDC discovery document. |
| Dynamic Client Registration | `/connect/register` | RFC 7591 client registration (used by Android DCR). |
| Device enrollment (DHIS2-specific) | `/api/auth/enrollDevice` | Mints a one-time Initial Access Token for DCR. See [DCR](#dynamic_client_registration). |

### Issuer URI and `server.base.url` { #oauth2_issuer_uri }

The OAuth2 issuer URI (the `iss` claim in every issued JWT, and the base
for all OIDC discovery metadata) is derived from `server.base.url`. Set
it to the **public** URL clients use to reach DHIS2. If DHIS2 sits
behind a TLS-terminating reverse proxy, use the external `https://` URL,
not the internal `http://` URL Tomcat sees.

The authorization server reads the issuer URI directly from
`server.base.url` rather than inferring it from the incoming HTTP
request. Without this, deployments behind SSL-terminating proxies
issued tokens with `iss: http://...` that external clients and OIDC
discovery rejected.

`server.base.url` is normalized so that it
is treated the same with or without a trailing slash.

The authorization server throws `IllegalStateException` at startup if
`server.base.url` is empty when `oauth2.server.enabled=on`.
DHIS2 also logs a warning when `server.base.url` is missing in any configuration.

### Persistent signing keystore { #oauth2_keystore }

The authorization server signs every issued JWT with an RSA private
key. DHIS2 loads the signing key from one of two sources, chosen at
startup:

1. **From a keystore file** (recommended for production): a Java
   KeyStore (`.jks` / `.p12`) on disk.
2. **Ephemeral** (default): a fresh RSA-2048 keypair is generated in
   memory at startup. **Every restart invalidates every previously
   issued token**, because the public key used to sign them is gone.
   This mode is only appropriate for development or first-boot.

Configuration keys (all in `dhis.conf`):

```properties
# Path to the Java keystore containing the signing key.
# If empty, DHIS2 falls back to the ephemeral mode below.
oauth2.server.jwt.keystore.path = /etc/dhis2/oauth2-signing.p12

# Password for the keystore file itself.
oauth2.server.jwt.keystore.password = <keystore-password>

# Alias of the key entry inside the keystore. REQUIRED when keystore.path is set.
oauth2.server.jwt.keystore.alias = dhis2-oauth2-signing

# Optional: password protecting the private-key entry, if different from
# the keystore password.
oauth2.server.jwt.keystore.key-password = <key-password>

# If no keystore.path is configured, generate an ephemeral RSA-2048
# keypair at startup. Default: true. Set to false in production to make
# a missing keystore a hard error instead of silently falling back to
# an ephemeral key.
oauth2.server.jwt.keystore.generate-if-missing = false
```

Only **RSA** keys are supported for the authorization server signing
key (no EC, no HMAC).

### Creating a signing keystore

A simple way to create a PKCS12 keystore containing a 2048-bit RSA key:

```bash
keytool -genkeypair \
  -alias dhis2-oauth2-signing \
  -keyalg RSA -keysize 2048 \
  -validity 3650 \
  -storetype PKCS12 \
  -keystore /etc/dhis2/oauth2-signing.p12 \
  -storepass "<keystore-password>" \
  -keypass "<key-password>" \
  -dname "CN=dhis2-oauth2-signing"

chmod 600 /etc/dhis2/oauth2-signing.p12
chown tomcat:tomcat /etc/dhis2/oauth2-signing.p12
```

Then point `dhis.conf` at the file with the alias and password.

After starting DHIS2, the corresponding public key is published at
`https://dhis2.example.org/oauth2/jwks`. Clients and resource servers
fetch it from there to verify tokens.

### Key rotation

The keystore is read once at startup. To rotate the signing key, add a
new key entry to the keystore (or swap keystores), update
`oauth2.server.jwt.keystore.alias`, and restart DHIS2. All tokens
signed by the previous key become unverifiable as soon as the new
public key replaces the old one at `/oauth2/jwks`. Plan rotations to
coincide with short-lived token expiry.

> There is currently no on-the-fly key rotation; all token-validity
> coverage comes from access-token TTL.

---

## OAuth2 clients { #oauth2_clients }

Every application that asks DHIS2 for a token must be registered as an
**OAuth2 client**. Clients are persisted in the `oauth2_client` table.

### Client concepts

| Concept | Values in DHIS2 |
|---------|-----------------|
| Client authentication methods | `client_secret_basic`, `client_secret_post`, `client_secret_jwt`, `private_key_jwt`, `none`. Stored as a comma-separated list on the client. |
| Authorization grant types | `authorization_code`, `refresh_token` (**allowed via the admin API**). `client_credentials` is reserved for the internal DCR system registrar only. |
| Scopes | Any string; standard `openid`, `profile`, `email` are honored by the token customizer. |
| Redirect URIs | `http://` and `https://` always accepted. Custom schemes (e.g. the Android deep-link `dhis2oauth://oauth`) must appear verbatim in the `deviceEnrollmentRedirectAllowlist` system setting. |

> **Only `authorization_code` and `refresh_token` are accepted when
> creating clients via the admin API or metadata import.** Trying to
> create a client with `client_credentials` returns HTTP 409 with the
> `E4000` error. The internal `system-dcr-registrar-client` is the
> only client allowed to use `client_credentials` and is managed by
> DHIS2 itself.

### Managing clients via the API { #oauth2_clients_rest }

CRUD endpoint: `/api/oAuth2Clients` (standard DHIS2 metadata CRUD).
Requires the `F_OAUTH2_CLIENT_MANAGE` authority.

#### Create a confidential web-app client

```bash
curl -u admin:district -X POST \
  -H 'Content-Type: application/json' \
  https://dhis2.example.org/api/oAuth2Clients \
  -d '{
    "clientId": "my-web-app",
    "clientSecret": "REPLACE-WITH-STRONG-RANDOM",
    "name": "My Web App",
    "clientAuthenticationMethods": "client_secret_basic",
    "authorizationGrantTypes": "authorization_code,refresh_token",
    "redirectUris": "https://my-web-app.example.org/callback",
    "scopes": "openid,profile,email",
    "clientSettings": "{\"requireAuthorizationConsent\":true}",
    "tokenSettings": "{}"
  }'
```

#### List clients

```bash
curl -u admin:district \
  'https://dhis2.example.org/api/oAuth2Clients?fields=id,clientId,name,authorizationGrantTypes'
```

The internal `system-dcr-registrar-client` is filtered out of list
responses. Attempts to create, update, delete, or rename a client to
`system-dcr-registrar-client` are rejected with HTTP 409.

#### Update a client

```bash
curl -u admin:district -X PUT \
  -H 'Content-Type: application/json' \
  https://dhis2.example.org/api/oAuth2Clients/<uid> \
  -d '{ "clientId":"my-web-app", "redirectUris":"https://my-web-app.example.org/callback,https://my-web-app.example.org/callback-v2" }'
```

If you PUT without a `name`, the previously-persisted name is
preserved (the Settings UI POSTs without `name`).

#### Delete

```bash
curl -u admin:district -X DELETE \
  https://dhis2.example.org/api/oAuth2Clients/<uid>
```

### Authorizations and consents (read-only)

Issued authorizations and user consents are stored in
`oauth2_authorization` and `oauth2_authorization_consent`. Two
superuser-only read-only controllers surface them for debugging:

- `GET /api/oAuth2Authorizations`: issued tokens and codes per user/client.
- `GET /api/oAuth2AuthorizationConsents`: granted consents per user/client.

These cannot be imported via `/api/metadata` and cannot be mutated via
the REST API; they are managed by the authorization server itself.

### Client secret lifecycle

When a client is created with `client_secret_basic` or
`client_secret_post` authentication, the `clientSecret` supplied in
the POST body is stored and compared verbatim at the token endpoint.
Treat the value like any other long-lived credential:

- Use strong random values. Do not reuse across environments.
- Rotate by PUTting a new `clientSecret` value. The old secret stops
  working immediately.
- Grant the `F_OAUTH2_CLIENT_MANAGE` authority only to users who need
  it.



---

## Dynamic Client Registration (DCR) { #dynamic_client_registration }

DHIS2 supports [RFC 7591 Dynamic Client Registration](https://www.rfc-editor.org/rfc/rfc7591).
DCR is implicitly enabled whenever the authorization server is enabled
(`oauth2.server.enabled=on`). There is no separate `oauth2.dcr.enabled`
key.

The primary driver for DCR is the DHIS2 Android Capture app: every
enrolled device becomes its own first-party OAuth2 client, authenticated
via `private_key_jwt` instead of a shared secret. See
[Android device enrollment walkthrough](#android_dcr_walkthrough).

### Flow

1. A user of the Android app (or any DCR-aware client) hits
   `GET /api/auth/enrollDevice?redirectUri=<deep-link>&state=<nonce>`.
2. DHIS2 validates that `redirectUri` matches the
   `deviceEnrollmentRedirectAllowlist` system setting and that the user
   belongs to a group in `deviceEnrollmentAllowedUserGroups` (if the
   setting is non-empty).
3. DHIS2 mints a one-time, short-lived JWT **Initial Access Token
   (IAT)** and 302-redirects to
   `<redirectUri>?iat=<jwt>&state=<nonce>`.
4. The client POSTs a standard RFC 7591 registration payload to
   `/connect/register`, presenting the IAT as its authorization. The
   payload **must include inline `jwks`** (the client's public keys).
   `jwks_uri` is not accepted.
5. DHIS2 validates the IAT, persists a new `oauth2_client` row with
   `ClientAuthenticationMethod.PRIVATE_KEY_JWT`, and returns the
   standard RFC 7591 registration response.
6. The client subsequently authenticates at `/oauth2/token` by signing
   a JWT assertion with the private key that matches the registered
   public JWKS.

IATs are single-use: after one successful `/connect/register`, the
underlying authorization row is consumed and the IAT cannot be
replayed.

### Relevant system settings

DCR behavior is configured via the standard **System Settings** API
(database-backed, not `dhis.conf`).

| System setting | Default | Controls |
|----------------|---------|----------|
| `deviceEnrollmentRedirectAllowlist` | `dhis2oauth://oauth` | Comma-separated glob allow-list of `redirect_uri` values that `GET /api/auth/enrollDevice` and DCR clients may use. Custom schemes (like the Android deep-link `dhis2oauth://oauth`) **must** appear here to be accepted. |
| `deviceEnrollmentAllowedUserGroups` | *(empty)* | CSV of user-group UIDs. If non-empty, only members of those groups may call `/api/auth/enrollDevice`. Empty means any authenticated user. |
| `deviceEnrollmentIATTtlSeconds` | `60` | Lifetime of the Initial Access Token. |

### Consent prompt behavior

Spring Authorization Server's default for DCR-registered clients is
`requireAuthorizationConsent=true`, which would pop a consent screen
on every authorization_code flow. DHIS2 overrides that default for DCR
clients, every DCR-registered client is saved with `requireAuthorizationConsent=false`
so that first-party device flows don't interrupt the user with a
self-grant prompt.

REST-created (non-DCR) clients still default to
`requireAuthorizationConsent=true`, so the consent screen is shown as
expected for third-party web apps.

### Android device enrollment walkthrough { #android_dcr_walkthrough }

**Server-side setup (one time):**

1. Set `server.base.url` to the public HTTPS URL of the DHIS2
   instance.
2. Set `oauth2.server.enabled = on` in `dhis.conf`.
3. Configure a persistent keystore (see
   [Persistent signing keystore](#oauth2_keystore)); without it,
   every server restart invalidates every device's tokens.
4. (Optional) Restrict device enrollment to a specific user group:
   set `deviceEnrollmentAllowedUserGroups` in System Settings.
5. Confirm the default redirect allow-list value
   `dhis2oauth://oauth` is present in
   `deviceEnrollmentRedirectAllowlist`. This is what the Android app
   uses as its deep-link.

**Per-device flow (automated by the Android app):**

1. The user signs in to DHIS2 via the Android app's embedded browser
   (OIDC authorization_code flow against the internal DHIS2 IdP; see
   [Internal DHIS2 OIDC provider](#internal_dhis2_oidc_provider)).
2. The app generates an RSA keypair on device and stores the private
   key in the Android Keystore.
3. The app calls `GET /api/auth/enrollDevice?redirectUri=dhis2oauth://oauth&state=<nonce>`.
4. DHIS2 validates the redirect URI against the allow-list,
   mints an IAT, and 302-redirects the browser to
   `dhis2oauth://oauth?iat=<jwt>&state=<nonce>`.
5. Android unwraps the deep-link and hands the IAT back to the app.
6. The app POSTs to `/connect/register` with payload:
   ```json
   {
     "redirect_uris": ["dhis2oauth://oauth"],
     "grant_types": ["authorization_code", "refresh_token"],
     "response_types": ["code"],
     "token_endpoint_auth_method": "private_key_jwt",
     "token_endpoint_auth_signing_alg": "RS256",
     "jwks": {
       "keys": [ { ...device public key... } ]
     }
   }
   ```
   Authorization header: `Bearer <iat>`.
7. DHIS2 stores the inline JWKS against the new client
   (ClientSettings key `client.inline.jwks`) and responds with the
   generated `client_id`.
8. Going forward, the app completes authorization_code flows against
   `/oauth2/authorize` and signs JWT client assertions (RFC 7523)
   with its private key when calling `/oauth2/token`.
9. When the user signs out, the post-logout redirect routes back to
   the same `dhis2oauth://oauth` deep-link,
   so the Android app stays in control of the UX.


---

## OIDC login: DHIS2 as a Relying Party { #oidc_login }

DHIS2 supports OpenID Connect for single sign-in. After users
authenticate at their identity provider (IdP), they are signed in to
DHIS2 automatically.

The OIDC 'authorization code' authentication flow:

1. A user opens the DHIS2 login page and clicks the OIDC provider
   button.
2. DHIS2 redirects the browser to the IdP's login page.
3. If not already signed in, the user enters credentials. The IdP
   responds with a redirect back to DHIS2 carrying an authorization
   code.
4. DHIS2 exchanges the authorization code (plus its client id +
   secret, or a `private_key_jwt` assertion) at the IdP's token
   endpoint and receives an ID token.
5. DHIS2 validates the ID token signature against the IdP's JWKS.
6. DHIS2 looks up the internal user by the configured
   `mapping_claim`, authorizes the user, and completes the login.

### Requirements

1. **An IdP.** You must control an account on an external IdP or run
   a standalone one. Tested providers:
    - Google
    - Microsoft Entra ID (Azure AD)
    - WSO2
    - Okta (via the generic provider; see
      [tutorial](../../../topics/tutorials/configure-oidc-with-okta.md))
    - Any OIDC-compliant provider via the **generic** provider config.
    - DHIS2 itself, via the [internal DHIS2 OIDC provider](#internal_dhis2_oidc_provider).
2. **DHIS2 user accounts.** Each user that should log in via OIDC
   must have a matching DHIS2 user row with:
    - `External authentication only (OpenID or LDAP)` checked in the
      user profile, and
    - an `OpenID` value equal to the expected value of the IdP's
      mapping claim (case-sensitive).
      Importing users from an external directory is not supported by the
      OIDC standard and is not provided by DHIS2.
3. **Redirect URL.** Every IdP needs the DHIS2 redirect URL
   registered as an authorized redirect. Pattern:
   ```
   <server.base.url>/oauth2/code/<provider-key>
   ```
   Example for Google:
   ```
   https://dhis2.example.org/oauth2/code/google
   ```

### Claims and user mapping

OIDC uses **claims** to carry user attributes (email, name, preferred
username, phone, etc.). DHIS2 maps an IdP account to a DHIS2 account
by looking up the DHIS2 user whose `OpenID` field equals the IdP's
mapping-claim value.

The mapping claim is `email` by default for all external providers
(Google, Azure AD, WSO2, generic). The **internal DHIS2 provider**
uses `username` by default.

If your IdP presents a different claim (for example `preferred_username`
or a custom claim), set `oidc.provider.<id>.mapping_claim` to that
claim name.

### Enabling OIDC login

```properties
# Global switch for OIDC login (oauth2Login filter chain + provider repo).
oidc.oauth2.login.enabled = on

# Optional: where to land the user after they log out of the IdP.
oidc.logout.redirect_url = https://dhis2.example.org
```

Then configure at least one provider. Examples follow.

### Google { #oidc_google }

1. In the [Google developer console](https://console.developers.google.com), create a
   project and an OAuth 2.0 client ID/secret.
2. Add the DHIS2 redirect URL:
   `https://dhis2.example.org/oauth2/code/google`.
3. Configure DHIS2:

```properties
oidc.oauth2.login.enabled = on

oidc.provider.google.client_id = <my-client-id>
oidc.provider.google.client_secret = <my-client-secret>

# Optional overrides
oidc.provider.google.redirect_url = https://dhis2.example.org/oauth2/code/google
oidc.logout.redirect_url = https://dhis2.example.org
```

> **Tip**
>
> When testing locally, use `https://localhost:8080/oauth2/code/google`
> and add the same URL to the Google console.

### Microsoft Entra ID (Azure AD) { #oidc_azure }

1. In the Azure portal, go to **App registrations → New registration**
   and set the redirect URI to:
   `https://dhis2.example.org/oauth2/code/azure.0`
2. Copy the tenant (directory) ID and the client ID/secret.
3. Configure DHIS2:

```properties
oidc.oauth2.login.enabled = on

# First Azure provider (azure.0):
oidc.provider.azure.0.tenant = <my-tenant-id>
oidc.provider.azure.0.client_id = <my-client-id>
oidc.provider.azure.0.client_secret = <my-client-secret>
oidc.provider.azure.0.redirect_url = https://dhis2.example.org/oauth2/code/azure.0

# Optional:
oidc.provider.azure.0.mapping_claim = email      # default is email
oidc.provider.azure.0.enable_logout = on         # default is on

oidc.logout.redirect_url = https://dhis2.example.org
```

Multiple Azure tenants are supported. Use `azure.0`, `azure.1`, …
blocks; each becomes its own login-page button.


### Generic providers { #oidc_generic }

The generic provider can be used for "any" standards-compliant OIDC
IdP. It appears as a button on the login page with the provider key
as the default name (or the value of `display_alias` if defined). The
provider key can be any alphanumeric string except the reserved names
`google`, `azure`, `wso2`, and `dhis2`.

Example: configuring a fictional OIDC provider `myprovider`.

```properties
oidc.oauth2.login.enabled = on

# Required properties:
oidc.provider.myprovider.client_id = <my-client-id>
oidc.provider.myprovider.client_secret = <my-client-secret>
oidc.provider.myprovider.mapping_claim = email
oidc.provider.myprovider.authorization_uri = https://myprovider.example.org/connect/authorize
oidc.provider.myprovider.token_uri = https://myprovider.example.org/connect/token
oidc.provider.myprovider.user_info_uri = https://myprovider.example.org/connect/userinfo
oidc.provider.myprovider.jwk_uri = https://myprovider.example.org/.well-known/openid-configuration/jwks

# Optional:
oidc.provider.myprovider.end_session_endpoint = https://myprovider.example.org/connect/endsession
oidc.provider.myprovider.scopes = openid,email,profile
oidc.provider.myprovider.redirect_url = https://dhis2.example.org/oauth2/code/myprovider
oidc.provider.myprovider.enable_logout = on
oidc.provider.myprovider.enable_pkce = on
oidc.provider.myprovider.display_alias = My Provider
oidc.provider.myprovider.login_image = ../security/btn_myprovider.svg
oidc.provider.myprovider.login_image_padding = 0px 1px

# Optional extra request parameters appended to the authorization request
# (key/value pairs, comma-separated):
oidc.provider.myprovider.extra_request_parameters = acr_values lvl4,other_key value2

oidc.logout.redirect_url = https://dhis2.example.org
```

The full set of keys supported per generic provider:

| Key | Required | Purpose |
|-----|----------|---------|
| `client_id` | yes | Client ID issued by the IdP. |
| `client_secret` | yes (unless `private_key_jwt`) | Client secret issued by the IdP. |
| `authorization_uri` | yes | IdP authorization endpoint. |
| `token_uri` | yes | IdP token endpoint. |
| `user_info_uri` | yes | IdP userinfo endpoint. |
| `jwk_uri` | yes | IdP JWKS endpoint (public keys). |
| `mapping_claim` | no (default `email`) | Claim used to map to the DHIS2 user. |
| `redirect_url` | no | Override the default redirect URL. |
| `issuer_uri` | no | Expected `iss` claim. |
| `end_session_endpoint` | no | IdP logout endpoint. |
| `scopes` | no (default `openid,email`) | Scopes requested in the authorization request. |
| `display_alias` | no | Label for the login-page button. |
| `login_image` | no | Relative path to a logo for the button. |
| `login_image_padding` | no | CSS padding around the logo. |
| `enable_logout` | no (default `on`) | Use `end_session_endpoint` on logout. |
| `enable_pkce` | no (default `off`) | Enable PKCE (RFC 7636). |
| `authorization_grant_type` | no (default `authorization_code`) | Grant type. |
| `client_authentication_method` | no | `client_secret_basic`, `client_secret_post`, or `private_key_jwt`. |
| `keystore_path` / `keystore_password` / `key_alias` / `key_password` | for `private_key_jwt` | See [private_key_jwt client auth](#oidc_private_key_jwt). |
| `jwk_set_url` | for `private_key_jwt` | URL at which the IdP can fetch DHIS2's public key. |
| `extra_request_parameters` | no | Extra params on the authorization request. |

Unknown keys are logged at startup with a suggestion of the
closest valid key.

### `private_key_jwt` client authentication to the IdP { #oidc_private_key_jwt }

Some enterprise IdPs require clients to authenticate with a JWT
assertion signed by the client's private key (RFC 7523 /
`private_key_jwt`) instead of a shared secret. DHIS2 supports this
per-provider by loading a key from a dedicated per-provider
keystore:

```properties
oidc.provider.myprovider.client_id = <client-id-from-idp>
oidc.provider.myprovider.client_authentication_method = private_key_jwt

# RSA key DHIS2 signs JWT client assertions with:
oidc.provider.myprovider.keystore_path = /etc/dhis2/myprovider-client.p12
oidc.provider.myprovider.keystore_password = <keystore-password>
oidc.provider.myprovider.key_alias = myprovider-client
oidc.provider.myprovider.key_password = <key-password>

# URL exposing the matching public JWK for the IdP to fetch.
# DHIS2 serves it at /api/publicKeys/<client_id>/jwks.json by default;
# set jwk_set_url so the JWT header `jku` points at that URL.
oidc.provider.myprovider.jwk_set_url = https://dhis2.example.org/api/publicKeys/<client-id>/jwks.json
```

Register the public JWK (or `jwk_set_url`) with the IdP during client
setup there; the IdP uses it to verify the `private_key_jwt`
assertion. Rotation works the same way as the authorization-server
keystore: add a new key entry, update the alias, restart DHIS2.

> **Two keystores, two purposes**
>
> - `oauth2.server.jwt.keystore.*` signs tokens **issued by** DHIS2 as
    >   an authorization server. Only one keystore per instance.
> - `oidc.provider.<id>.keystore_*` signs JWT assertions sent **from**
    >   DHIS2 to an external IdP during OIDC login. One keystore per
    >   provider, used only when that provider is configured with
    >   `private_key_jwt`.

### Internal DHIS2 OIDC provider { #internal_dhis2_oidc_provider }

When `oauth2.server.enabled = on`, DHIS2 automatically registers
itself as an OIDC provider with the registration ID `dhis2-internal`.
This provider is **not** shown on the web login page (it is used only
for the Android app's authorization_code flow against the internal
authorization server and for resource-server JWT validation).

The internal provider is
fully auto-configured from `server.base.url`. The following minimum
config is enough to enable DHIS2-as-IdP for the Android app:

```properties
server.base.url = https://dhis2.example.org
oauth2.server.enabled = on
```

All of the `oidc.provider.dhis2.*` endpoint URIs are derived from
`server.base.url` at startup. The separate `oidc.oauth2.login.enabled`
key is **not** needed for the internal provider (it controls only the
web-facing external-IdP login buttons).

If you need to override the internal provider's client credentials
(rare, usually for tests), the following keys exist:

```properties
oidc.provider.dhis2.client_id = dhis2-internal   # default
oidc.provider.dhis2.client_secret = secret       # default
oidc.provider.dhis2.mapping_claim = username     # default
oidc.provider.dhis2.server_url = <override server.base.url>
```

### Linked accounts { #connect_single_identity_to_multiple_accounts }

DHIS2 can map a single IdP identity to multiple DHIS2 accounts. Users
can list their linked accounts and switch between them via API.

When enabled, the `openid` column in `userinfo` is no longer unique:
on a successful IdP sign-in, DHIS2 logs in the account that most
recently signed in.

```properties
linked_accounts.enabled = on
# Optional: override where the user is redirected during account switch.
linked_accounts.logout_url = https://dhis2.example.org/dhis-web-login/logout
linked_accounts.relogin_url = https://dhis2.example.org/
```

See [Switching between user accounts connected to the same identity
provider account](../../../develop/using-the-api/dhis-core-version-master/users.html#switching-between-user-accounts-connected-to-the-same-identity-provider-account) for the user-switching API.

---

## JWT bearer token authentication { #jwt_bearer_authentication }

After obtaining an access token (from DHIS2's own authorization
server, the internal DHIS2 IdP, or any registered external IdP),
clients authenticate subsequent API calls with:

```
Authorization: Bearer <jwt>
```

### When JWT bearer authentication is active

Two flags in `dhis.conf` enable inbound JWT bearer authentication:

| Key | What it does |
|-----|--------------|
| `oauth2.server.enabled` | Enables the Spring Authorization Server **and** the JWT bearer filter. Also registers the internal `dhis2-internal` OIDC provider so DHIS2 accepts its own issued tokens. |
| `oidc.jwt.token.authentication.enabled` | Enables **only** the JWT bearer filter (for accepting tokens issued by an external IdP). Does not expose an authorization server. |

Either flag adds a bearer-token filter after HTTP basic auth. If both
are on, the filter is still registered once; the difference is only
whether the internal provider is wired.

### Token validation

Tokens are validated per request by
`Dhis2JwtAuthenticationManagerResolver`. Behavior:

- Extract `iss` from the JWT header. Look up a registered provider
  (internal or external) by matching issuer URI.
- Verify the signature against the provider's JWKS.
- Match the token audience:
    - If `iss` is the internal `dhis2-internal` provider, **every** `aud`
      must match a registered `Dhis2OAuth2Client.clientId`.
    - Otherwise, the provider's registered client IDs must include at
      least one audience.
- Map the token to a DHIS2 user via the provider's
  `mapping_claim` (`username` or `email` are supported; any other
  value fails the request with `InvalidBearerTokenException`).

### Minimal configuration for Android clients

For the DHIS2 Android Capture app to authenticate against a DHIS2
instance using JWT bearer tokens issued by the internal DHIS2 IdP,
only two config keys are required:

```properties
server.base.url = https://dhis2.example.org
oauth2.server.enabled = on
```

(Plus a persistent keystore; see
[Persistent signing keystore](#oauth2_keystore).)

### Minimal configuration for third-party JWT-issued tokens

To accept tokens issued by an external IdP (Google, Azure AD, custom)
**without** running DHIS2's own authorization server, configure the
IdP as a generic OIDC provider and enable the bearer filter:

```properties
# Global OIDC login switch (also controls the bearer filter)
oidc.jwt.token.authentication.enabled = on

# External IdP as a generic provider
oidc.provider.myprovider.client_id = <my-idp-client-id>
oidc.provider.myprovider.client_secret = <my-idp-client-secret>
oidc.provider.myprovider.authorization_uri = ...
oidc.provider.myprovider.token_uri = ...
oidc.provider.myprovider.user_info_uri = ...
oidc.provider.myprovider.jwk_uri = ...
oidc.provider.myprovider.mapping_claim = email
```

Clients then obtain tokens from the IdP and call DHIS2 with the
resulting bearer token. DHIS2 verifies the signature against the
provider's JWKS and maps the token to a DHIS2 user via
`mapping_claim`.


---

## Configuration reference { #oauth2_config_reference }

All keys live in `dhis.conf`.

### Authorization server

| Key | Type | Default | Purpose |
|-----|------|---------|---------|
| `oauth2.server.enabled` | `on`/`off` | `off` | Enable the Spring Authorization Server, DCR endpoints, internal DHIS2 OIDC provider, and the JWT bearer filter. |
| `oauth2.server.jwt.keystore.path` | path | `` | Keystore file containing the authorization-server signing key. |
| `oauth2.server.jwt.keystore.password` | string | `` | Keystore password. |
| `oauth2.server.jwt.keystore.alias` | string | `` | Alias of the key entry inside the keystore. Required when `keystore.path` is set. |
| `oauth2.server.jwt.keystore.key-password` | string | `` | Password of the private-key entry. Optional; defaults to the keystore password. |
| `oauth2.server.jwt.keystore.generate-if-missing` | `true`/`false` | `true` | Generate an ephemeral RSA-2048 keypair at startup if `keystore.path` is empty. Set to `false` in production. |
| `server.base.url` | URL | `` | Public HTTPS base URL; used as OAuth2 issuer URI when the authorization server is enabled. |

### OIDC login (DHIS2 as Relying Party)

| Key | Type | Default | Purpose |
|-----|------|---------|---------|
| `oidc.oauth2.login.enabled` | `on`/`off` | `off` | Enable the `oauth2Login` filter chain for web login with external IdPs. |
| `oidc.logout.redirect_url` | URL | `` | Where the user lands after logging out of the IdP. |
| `oidc.jwt.token.authentication.enabled` | `on`/`off` | `off` | Enable inbound JWT bearer token authentication (without running an authorization server). |
| `oidc.provider.google.client_id` | string | `` | Google client ID. |
| `oidc.provider.google.client_secret` | string | `` | Google client secret. |
| `oidc.provider.google.mapping_claim` | string | `email` | Claim used to map Google identities to DHIS2 users. |
| `oidc.provider.google.redirect_url` | URL | `` | Optional override for the redirect URL. |
| `oidc.provider.azure.<n>.tenant` | string | `` | Azure tenant (directory) ID for provider `n`. |
| `oidc.provider.azure.<n>.client_id` | string | `` | Azure client ID. |
| `oidc.provider.azure.<n>.client_secret` | string | `` | Azure client secret. |
| `oidc.provider.azure.<n>.mapping_claim` | string | `email` | Mapping claim. |
| `oidc.provider.azure.<n>.enable_logout` | `on`/`off` | `on` | Enable logout via the Azure `end_session_endpoint`. |
| `oidc.provider.wso2.*` | - | - | WSO2 provider (see WSO2 section). |
| `oidc.provider.<id>.*` | - | - | Generic OIDC provider. Full key set documented under [Generic providers](#oidc_generic). |
| `oidc.provider.dhis2.client_id` | string | `dhis2-internal` | Override the internal-provider client ID (rare; usually unset). |
| `oidc.provider.dhis2.client_secret` | string | `secret` | Override the internal-provider client secret. |
| `oidc.provider.dhis2.mapping_claim` | string | `username` | Mapping claim for the internal provider. |
| `oidc.provider.dhis2.server_url` | URL | `` | Override base URL; defaults to `server.base.url`. |
| `linked_accounts.enabled` | `on`/`off` | `off` | Allow one IdP identity to map to multiple DHIS2 accounts. |
| `linked_accounts.logout_url` | URL | `` | Logout URL used by the account-switch flow. |
| `linked_accounts.relogin_url` | URL | `` | Re-login URL used by the account-switch flow. |

### System settings (database-backed)

| Setting | Default | Purpose |
|---------|---------|---------|
| `deviceEnrollmentRedirectAllowlist` | `dhis2oauth://oauth` | Allow-list of `redirect_uri` values for DCR and for custom-scheme clients. |
| `deviceEnrollmentAllowedUserGroups` | *(empty)* | CSV of user-group UIDs allowed to enroll devices. Empty = any authenticated user. |
| `deviceEnrollmentIATTtlSeconds` | `60` | Lifetime of Initial Access Tokens. |

---

## Troubleshooting { #oauth2_troubleshooting }

**The authorization server does not start (`IllegalStateException: server.base.url is required`).**
Set `server.base.url` in `dhis.conf` to the public HTTPS URL of the instance.

**Issued tokens have `iss: http://...` instead of `https://...`.**
Set `server.base.url` to the full public HTTPS URL. The issuer URI
is derived from `server.base.url` directly; your app server does
not need to know it is behind a proxy.

**Tokens issued before a restart stop working after restart.**
You are running with the default ephemeral-keystore mode. Configure
a persistent keystore (see
[Persistent signing keystore](#oauth2_keystore)).

**`POST /api/oAuth2Clients` with `"authorizationGrantTypes":"client_credentials"` returns 409 (`E4000`).**
Only `authorization_code` and `refresh_token` are permitted via the
admin API. `client_credentials` is reserved for the internal DCR
system registrar.

**Creating a client with a custom-scheme redirect URI (`dhis2oauth://oauth`) is rejected.**
Add the exact URI to the `deviceEnrollmentRedirectAllowlist` system
setting. `http://` and `https://` URIs are always accepted.

**OIDC login button does not appear.**
Check that `oidc.oauth2.login.enabled = on` and that at least one
`oidc.provider.*.client_id` is configured with matching
`client_secret`. Unknown keys are logged at startup with a
suggestion of the closest valid key.

**JWT bearer request fails with HTTP 401 and `Invalid mapping claim`.**
The provider's `mapping_claim` is neither `username` nor `email`; only
these two are supported. Set `oidc.provider.<id>.mapping_claim` to
one of them.


**`/connect/register` rejects the payload for a missing `jwks`.**
DHIS2 DCR requires an inline JWKS object in the registration body;
`jwks_uri` is not accepted. Include the full `jwks` object with the
client's public keys.

---

## Upgrade notes: 2.41 to 2.42 { #oauth2_upgrade_2_42 }

2.42 replaces the authorization server implementation. 2.41 shipped
an authorization server built on the deprecated
`spring-security-oauth2` project; 2.42 uses the actively maintained
Spring Authorization Server. This is a rewrite, not a drop-in
upgrade: the configuration key, endpoint paths, token format, and
client schema all change.

### Breaking changes

| Area | 2.41 | 2.42 |
|------|------|------|
| Implementation | `spring-security-oauth2` (deprecated) | Spring Authorization Server |
| Enable key | `oauth2.authorization.server.enabled` | `oauth2.server.enabled` |
| Token endpoint | `/oauth/token` | `/oauth2/token` |
| Authorize endpoint | `/oauth/authorize` | `/oauth2/authorize` |
| Access token format | Opaque, server-stored | JWT, RSA-signed |
| JWKS endpoint | none | `/oauth2/jwks` |
| Signing key | not applicable | RSA keypair from keystore |
| `OAuth2Client` entity | `cid`, `secret`, `redirectUris`, `grantTypes` | Spring AS `RegisteredClient` with full OAuth2/OIDC properties |
| Client tables | `oauth2client`, `oauth2clientgranttypes`, `oauth2clientredirecturis` | `oauth2_client` |
| Authorization tables | `oauth_access_token`, `oauth_code` | `oauth2_authorization`, `oauth2_authorization_consent` |

The `/api/oAuth2Clients` endpoint path and the
`F_OAUTH2_CLIENT_MANAGE` authority that gates it are unchanged, but
the request and response JSON schemas are different.

### What is unchanged from 2.41

- OIDC login as a Relying Party (`oidc.oauth2.login.enabled`) with
  Google, Microsoft Entra ID, WSO2, and generic providers.
- Inbound JWT bearer authentication against external IdPs
  (`oidc.jwt.token.authentication.enabled`).
- Linked accounts (`linked_accounts.*`).

### Upgrade actions

If 2.41 had the authorization server enabled:

1. Rename `oauth2.authorization.server.enabled` to
   `oauth2.server.enabled` in `dhis.conf`.
2. Configure a persistent signing keystore
   (`oauth2.server.jwt.keystore.*`). Without it, tokens are signed
   with an ephemeral keypair that is regenerated on every restart.
   See [Persistent signing keystore](#oauth2_keystore).
3. Recreate every registered OAuth2 client against the new schema
   via `POST /api/oAuth2Clients`. Rows in the legacy `oauth2client*`
   tables are not migrated.
4. Update client applications for the new endpoint paths (`/oauth/*`
   becomes `/oauth2/*`) and the new token format (opaque becomes
   JWT, validated against `/oauth2/jwks`).
5. Existing access tokens and authorization codes do not survive the
   upgrade; clients must re-authenticate.

If 2.41 did not have the authorization server enabled, the upgrade
is a no-op: the new authorization server is disabled by default.

