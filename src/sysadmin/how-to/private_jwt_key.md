## Private Key JWT authentication { #install_private_key_jwt_authentication }

DHIS2 supports Private Key JWT as a client authentication method for OpenID Connect (OIDC). Private Key JWT is a secure client authentication method where the client creates and signs a JWT using its own private key. This method provides enhanced security compared to using a static client secret.

Private Key JWT is described in [RFC 7521](https://www.rfc-editor.org/rfc/rfc7521.html) (Assertion Framework) and [RFC 7523](https://www.rfc-editor.org/rfc/rfc7523.html) (JWT Profile for Client Authentication), and referenced by [OpenID Connect](https://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication) and [FAPI 2.0 Security Profile](https://openid.bitbucket.io/fapi/fapi-2_0-security.html).

### Prerequisites

Before you begin, you should have:

*   A running DHIS2 instance.
*   An OpenID Connect provider (e.g., Keycloak, Okta, Google) that you have administrative access to.
*   Basic understanding of OIDC concepts.

### Configuration steps

To configure Private Key JWT authentication in DHIS2, follow these steps:

1.  **Generate a key pair**

    You need to generate an RSA key pair. You can use the Java `keytool` utility for this. The key will be stored in a Java Keystore (`.jks`) file.

    ```sh
    keytool -genkeypair -alias mykey -keyalg RSA -keysize 2048 \
      -keystore mykey.jks -storepass mypass -keypass mypass \
      -validity 365 -dname "CN=DHIS2, OU=IT, O=MyOrg, L=City, S=State, C=Country"
    ```

    *   `-alias mykey`: The alias for your key. You will use this in `dhis.conf`.
    *   `-keyalg RSA`: The key algorithm. DHIS2 currently supports RSA keys for this feature.
    *   `-keysize 2048`: The size of the key. 2048 bits is a secure minimum.
    *   `-keystore mykey.jks`: The name of the keystore file.
    *   `-storepass mypass` and `-keypass mypass`: Passwords for the keystore and the key. Use strong passwords.
    *   `-validity 365`: The validity of the key in days.
    *   `-dname "..."`: The distinguished name for the certificate. This avoids the interactive prompt.

    This command creates a file named `mykey.jks`. Place this file in a secure location on your DHIS2 server.

### Importing an existing key pair

If you already have a private key and a public key certificate in PEM format, you can import them into a Java Keystore instead of generating a new key.

**Prerequisites:**
*   You have `openssl` and `keytool` command-line tools installed.
*   You have a private key file (e.g., `private.pem`).
*   You have a public key certificate file (e.g., `public.pem`). A raw public key is not sufficient; it must be a certificate.

Follow these steps:

1.  **Combine your PEM files into a PKCS12 file**

    Use `openssl` to create a `.p12` file that bundles your private key and public certificate. You will be asked to create an export password.

    ```sh
    openssl pkcs12 -export -in public.pem -inkey private.pem \
      -out mykey.p12 -name mykey
    ```
    * `-in public.pem`: Your public key certificate file.
    * `-inkey private.pem`: Your private key file.
    * `-out mykey.p12`: The output PKCS12 file.
    * `-name mykey`: The alias for the key. This will be used as the `key_alias` in `dhis.conf`.

2.  **Import the PKCS12 file into a Java Keystore**

    Use `keytool` to import the `.p12` file into a new Java Keystore (`.jks`) file. You will be prompted for the destination keystore password and the source keystore password (the one you created in the previous step).

    ```sh
    keytool -importkeystore \
      -srckeystore mykey.p12 -srcstoretype PKCS12 \
      -destkeystore mykey.jks -deststoretype JKS
    ```
    * `-srckeystore mykey.p12`: The source PKCS12 file.
    * `-destkeystore mykey.jks`: The destination Java Keystore. This is the file you will reference in `dhis.conf`.

You now have a `mykey.jks` file containing your existing key pair. You can now proceed to step 2 and update your `dhis.conf` file, using the path to this new keystore.

2.  **Update `dhis.conf`**

    Add the following properties to your `dhis.conf` configuration file to enable Private Key JWT authentication for your OIDC provider.

    Replace `[provider_key]` with your OIDC provider identifier (e.g., `keycloak`). This is the same key you use for other `oidc.provider.*` settings.

    ```properties
    # Specify the authentication method as private_key_jwt
    oidc.provider.[provider_key].client_authentication_method = private_key_jwt

    # Path to the keystore file containing the private key
    oidc.provider.[provider_key].keystore_path = /path/to/your/keystore.jks

    # Password for the keystore
    oidc.provider.[provider_key].keystore_password = keystorepassword

    # Alias of the key within the keystore
    oidc.provider.[provider_key].key_alias = mykey

    # Password for the key (may be the same as keystore password)
    oidc.provider.[provider_key].key_password = keypassword

    # URL where the JWKS (JSON Web Key Set) containing your public key will be exposed
    oidc.provider.[provider_key].jwk_set_url = https://your-dhis2-server.org/api/publicKeys/[provider_key]/jwks.json
    ```

3.  **Configure your OIDC provider**

    Now, you need to configure your OIDC provider to trust your DHIS2 server's public key.

    *   In your OIDC provider's client configuration, change the "Client authentication" method to "Signed JWT" or "Private Key JWT".
    *   Configure your OIDC provider to use your DHIS2 server's JWKS URL. This is the URL you set in the `jwk_set_url` property. The OIDC provider will fetch this URL to get the public key needed to verify the JWT signed by DHIS2.

### OIDC provider-specific setup

#### Keycloak setup example

If you are using Keycloak as your OIDC provider:

1.  In your client settings in Keycloak:
    *   Go to the "Credentials" tab.
    *   Choose "Signed JWT" as the client authenticator.
    *   Select the appropriate signature algorithm (e.g., "RS256" or "Any algorithm").
    *   Save the changes.

2.  Configure the client to use your DHIS2 server's JWKS URL:
    *   Go to the "Keys" tab in the client settings.
    *   Enable "Use JWKS URL".
    *   Enter the JWKS URL from your DHIS2 configuration: `https://your-dhis2-server.org/api/publicKeys/keycloak/jwks.json`
    *   Save the changes.

### Security considerations

*   **Keystore File:** Store your keystore file securely. The user running the DHIS2 process should be the only user with read access. Use `chown` and `chmod` to set permissions, for example:
    ```sh
    sudo chown dhis:dhis /path/to/your/keystore.jks
    sudo chmod 400 /path/to/your/keystore.jks
    ```
*   **Passwords:** Use strong and unique passwords for your keystore and key.
*   **dhis.conf:** The `dhis.conf` file contains secrets. Ensure it is also protected with restrictive file permissions.
*   **Key Rotation:** Regularly rotate your keys for enhanced security. This involves generating a new key pair and updating your OIDC provider configuration.

### Complete OIDC configuration example

Here's a complete example of a `dhis.conf` configuration for an OIDC provider named `keycloak` using Private Key JWT authentication:

```properties
# Enable OIDC login
oidc.oauth2.login.enabled = on

# Keycloak provider configuration
oidc.provider.keycloak.client_id = myclient
oidc.provider.keycloak.mapping_claim = email
oidc.provider.keycloak.display_alias = Sign in with Keycloak
oidc.provider.keycloak.enable_logout = on
oidc.provider.keycloak.scopes = email
oidc.provider.keycloak.authorization_uri = https://keycloak.example.org/realms/myrealm/protocol/openid-connect/auth
oidc.provider.keycloak.token_uri = https://keycloak.example.org/realms/myrealm/protocol/openid-connect/token
oidc.provider.keycloak.user_info_uri = https://keycloak.example.org/realms/myrealm/protocol/openid-connect/userinfo
oidc.provider.keycloak.jwk_uri = https://keycloak.example.org/realms/myrealm/protocol/openid-connect/certs
oidc.provider.keycloak.end_session_endpoint = https://keycloak.example.org/realms/myrealm/protocol/openid-connect/logout

# Private Key JWT specific configuration
oidc.provider.keycloak.client_authentication_method = private_key_jwt
oidc.provider.keycloak.keystore_path = /etc/dhis2/keycloak_keys.jks
oidc.provider.keycloak.keystore_password = mypass
oidc.provider.keycloak.key_alias = mykey
oidc.provider.keycloak.key_password = mypass
oidc.provider.keycloak.jwk_set_url = https://dhis2.example.org/api/publicKeys/keycloak/jwks.json
```

For more information on general OIDC configuration, see the [OpenID Connect (OIDC) configuration](#install_oidc_configuration) section.
