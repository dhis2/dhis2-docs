---
title: Configure OpenID Connect with Authelia and LLDAP
---

# Configure OpenID Connect with Authelia and LLDAP

**This guide explains how to set up OpenID Connect (OIDC) for DHIS2 using [Authelia](https://www.authelia.com/) as the identity provider and [LLDAP](https://github.com/lldap/lldap) as the user directory.**

OIDC enables _Single Sign-On_ (SSO) across multiple applications, where a user authenticates once and gains access to DHIS2 and other systems without re-entering credentials. For system administrators, it centralises user management: usernames, passwords and account deactivation are maintained in one place.

## Why Authelia and LLDAP?

[Keycloak](https://www.keycloak.org/) is a popular full-featured identity provider, but it is a heavyweight application that can require significant resources. Authelia combined with LLDAP is a lighter-weight alternative well suited to self-hosted environments:

- **LLDAP** is an opinionated, minimal LDAP server focused purely on storing users and groups. It exposes a small, clean web UI and CLI for user management and does not attempt to replicate the full LDAP specification.
- **Authelia** is a self-hosted authentication and authorisation server that sits in front of your applications. It provides OIDC, two-factor authentication (TOTP, WebAuthn), and per-application access policies. It authenticates users against a backend such as LLDAP.

Together they provide a capable SSO stack with a much smaller footprint than Keycloak.

### Use cases

The primary use cases for this stack in a DHIS2 context are:

- **Protecting sensitive administrative interfaces** at the nginx layer — tools such as Glowroot, Grafana, and pgAdmin are often deployed alongside DHIS2 but lack robust built-in authentication. Authelia can enforce two-factor authentication in front of these tools without modifying the applications themselves.
- **Enabling two-factor authentication for DHIS2 admin users** — by configuring DHIS2 to delegate login to Authelia via OIDC, admin accounts benefit from TOTP or WebAuthn as a second factor.

The number of users managed in this stack is typically small — a handful of system administrators and technical staff rather than the full DHIS2 user base. LLDAP is capable of handling larger directories, but for the bulk of DHIS2 users (who may number in the tens or hundreds of thousands in large national deployments) authentication is managed within DHIS2 itself.

### Why not Keycloak?

Keycloak is a comprehensive Identity and Access Management (IAM) platform with a much larger feature set. However, in most DHIS2 deployments its advanced IAM capabilities go unused — the typical requirement is simply to provide SSO and two-factor authentication for a small group of administrators. Keycloak carries a significant operational overhead: it requires a dedicated database, substantial memory, and ongoing maintenance. For installations where a lightweight solution is sufficient, Authelia and LLDAP are easier to deploy and maintain.

## Architecture

This guide uses two LXD containers on the same host as the DHIS2 server:

- `lldap1` — runs LLDAP, the user directory (LDAP on port 3890)
- `authelia1` — runs Authelia, the OIDC provider (port 9091)

An nginx reverse proxy on the host terminates SSL and routes traffic to each container. DHIS2 is assumed to be accessible at `https://example.com/dhis`.

Replace `example.com` with your actual domain throughout this guide.

## Prerequisites

- A DHIS2 instance accessible at `https://example.com/dhis`
- nginx with SSL configured on the host (certificates in place)
- LXD installed and initialised on the host
- UFW firewall in use on the containers

---

## Step 1: Create the LXD containers

On the host, launch two Ubuntu 24.04 containers:

```bash
lxc launch ubuntu:24.04 lldap1
lxc launch ubuntu:24.04 authelia1
```

Note the IP address of each container — you will need these for firewall rules:

```bash
lxc list
```

In this guide the containers have the following IPs. Replace these with your actual values:

- LLDAP container: `172.19.2.41`
- Authelia container: `172.19.2.50`

---

## Step 2: Install and configure LLDAP

Work inside the `lldap1` container:

```bash
lxc exec lldap1 -- bash
```

### Install LLDAP

LLDAP is not available in the Ubuntu package repositories. Install it from the OpenSUSE build service:

```bash
sudo apt install -y curl gpg

# Add the repository
echo 'deb http://download.opensuse.org/repositories/home:/Masgalor:/LLDAP/xUbuntu_24.04/ /' \
  | sudo tee /etc/apt/sources.list.d/home:Masgalor:LLDAP.list

# Download and install the signing key (scoped to this repo only)
curl -fsSL https://download.opensuse.org/repositories/home:Masgalor:LLDAP/xUbuntu_24.04/Release.key \
  | gpg --dearmor \
  | sudo tee /usr/share/keyrings/home_Masgalor_LLDAP.gpg > /dev/null

# Bind the repo to the key
sudo sed -i 's|^deb |deb [signed-by=/usr/share/keyrings/home_Masgalor_LLDAP.gpg] |' \
  /etc/apt/sources.list.d/home:Masgalor:LLDAP.list

sudo apt update
sudo apt install -y lldap lldap-extras lldap-set-password
```

> **Note**
>
> `lldap-extras` provides the `lldap-cli` command-line tool used for managing users and groups. `lldap-set-password` is a utility for setting user passwords.

### Configure LLDAP

Generate a JWT secret for LLDAP:

```bash
openssl rand -base64 32
```

Edit the LLDAP configuration file:

```bash
sudo nano /etc/lldap/lldap_config.toml
```

Set the following values. Replace the placeholders with your actual values:

```toml
# Secret used to sign JWT tokens issued by LLDAP
jwt_secret = "your-generated-jwt-secret"

# Base DN for your directory — adjust to match your domain
ldap_base_dn = "dc=example,dc=com"

# LLDAP admin credentials
ldap_user_dn = "admin"
ldap_user_pass = "a-strong-admin-password"
```

### Start LLDAP

```bash
sudo systemctl enable --now lldap
sudo systemctl status lldap
```

### Configure the firewall

Allow the Authelia container to query LLDAP:

```bash
sudo ufw allow from 172.19.2.50 to any port 3890 proto tcp
```

> **Note**
>
> LLDAP includes a web UI on port 17170, but it does not function correctly when served from a sub-path (e.g. `/lldap`), and this is intentional — the LLDAP maintainers have explicitly declined to support sub-path deployment on security grounds. Since most DHIS2 installations share a single domain and do not have the DNS flexibility to assign a dedicated subdomain to every service, exposing the LLDAP web UI is not practical in this setup. Use the `lldap-cli` tool for all user and group management as shown in the steps below.
>
> If you do control your DNS and can assign a dedicated subdomain (e.g. `lldap.example.com`), running each service on its own subdomain is the more secure approach and will allow you to use the web UI.

### Add groups

Create the groups you want to use for access control. These group names will be referenced in the Authelia access policy:

```bash
lldap-cli group add "admins"
lldap-cli group add "monitoring-admins"
lldap-cli group add "db-admins"
```

### Add users

Add users to the directory and assign them to groups:

```bash
# Add a user: lldap-cli user add <username> <email> -d "<display name>" -p "<password>"
lldap-cli user add bobby bobby@example.com -d "Bobby Tables" -p "a-strong-password"

# Add the user to a group
lldap-cli user group add bobby "admins"
```

Verify the user can authenticate against the directory:

```bash
ldapwhoami -H ldap://localhost:3890 -x \
  -D "uid=bobby,ou=people,dc=example,dc=com" -W
```

### Create the Authelia bind user

Authelia needs a dedicated read-only user to search the directory. Create one and add it to the `lldap_strict_readonly` group:

```bash
lldap-cli user add authelia authelia@example.com -d "Authelia Bind User" -p "a-strong-bind-password"
lldap-cli user group add authelia lldap_strict_readonly
```

> **Note**
>
> The `lldap_strict_readonly` group is built into LLDAP. Members can search and read the directory but cannot make any modifications.

---

## Step 3: Install and configure Authelia

Work inside the `authelia1` container:

```bash
lxc exec authelia1 -- bash
```

### Install Authelia

Download the latest `.deb` package from the [Authelia releases page](https://github.com/authelia/authelia/releases) and install it:

```bash
wget https://github.com/authelia/authelia/releases/download/v4.39.15/authelia_4.39.15-1_amd64.deb
sudo dpkg -i authelia_4.39.15-1_amd64.deb
```

> **Tip**
>
> Check the [releases page](https://github.com/authelia/authelia/releases) for the latest version before downloading.

### Generate the required secrets

Authelia requires several secrets. Generate them now and keep them in a temporary secure location — you will paste them into the configuration file in the next step.

**1. JWT secret, session secret, and storage encryption key**

All three are random hex strings:

```bash
openssl rand -hex 32   # JWT secret (for password reset tokens)
openssl rand -hex 32   # Session secret (signs session cookies)
openssl rand -hex 32   # Storage encryption key (encrypts the SQLite database)
```

**2. OIDC client secret**

This is the shared secret between Authelia and DHIS2. Generate a plaintext secret and then hash it. Authelia stores the hash; DHIS2 uses the plaintext value:

```bash
# Generate a random plaintext secret
openssl rand -hex 32

# Hash it for the Authelia config
authelia crypto hash generate pbkdf2 --variant sha512 --password 'the-plaintext-secret-from-above'
```

Keep both the plaintext and hashed values — the plaintext goes into `dhis.conf`, the hash goes into the Authelia config.

**3. RSA key pair** (used to sign OIDC tokens)

```bash
authelia crypto pair rsa generate --bits 4096 --directory /etc/authelia/keys/
```

The private key must be indented correctly when embedded in the YAML configuration. Use this helper to produce a correctly indented version for pasting:

```bash
sed 's/^/          /' /etc/authelia/keys/private.pem
```

### Configure Authelia

Edit the Authelia configuration file:

```bash
sudo nano /etc/authelia/configuration.yml
```

The minimal functional configuration is shown below. Replace all placeholder values:

```yaml
theme: dark

server:
  address: tcp://0.0.0.0:9091/authelia  # path prefix must match the nginx proxy_pass path

log:
  level: info

authentication_backend:
  ldap:
    implementation: lldap
    address: ldap://172.19.2.41:3890 #Be sure to replace this IP with your LLDAP IP
    base_dn: dc=example,dc=com
    user: uid=authelia,ou=people,dc=example,dc=com
    password: "your-authelia-bind-password"

access_control:
  rules:
    - domain: "example.com"
      policy: bypass
      resources:
        - "^/authelia/.*$"
        - "^/authelia$"

    - domain: "example.com"
      policy: two_factor
      subject:
        - "group:admins"
      resources:
        - "^/dhis-glowroot(/.*)?$"   # Glowroot APM
        - "^/grafana(/.*)?$"          # Grafana dashboards
        - "^/pgadmin(/.*)?$"          # pgAdmin

identity_validation:
  reset_password:
    jwt_secret: "your-jwt-secret"

session:
  name: authelia_session
  same_site: lax
  expiration: 1h
  inactivity: 15m
  remember_me: 7d
  secret: "your-session-secret"
  cookies:
    - domain: "example.com"
      authelia_url: "https://example.com/authelia"

identity_providers:
  oidc:
    jwks:
      - key_id: 'main'
        algorithm: 'RS256'
        use: 'sig'
        key: |
          -----BEGIN PRIVATE KEY-----
          <indented private key content — use the sed output from above>
          -----END PRIVATE KEY-----
    clients:
      - client_id: 'dhis2'
        client_name: 'DHIS2'
        client_secret: 'the-hashed-client-secret-from-above'
        public: false
        authorization_policy: 'two_factor'
        redirect_uris:
          - 'https://example.com/dhis/oauth2/code/authelia'
        scopes:
          - 'openid'
          - 'profile'
          - 'email'
        grant_types:
          - 'authorization_code'
        response_types:
          - 'code'
        token_endpoint_auth_method: 'client_secret_basic'
        pkce_challenge_method: 'S256'

storage:
  encryption_key: "your-storage-encryption-key"
  local:
    path: /var/lib/authelia/db.sqlite3

notifier:
  filesystem:
    filename: /var/lib/authelia/notification.txt

totp:
  issuer: "example.com"
  period: 30
  skew: 1
  digits: 6
  algorithm: sha1
```

> **Note**
>
> A primary use case for this setup is protecting sensitive administrative interfaces — such as Glowroot (APM), Grafana (monitoring), or pgAdmin (database) — that do not have their own robust authentication. These tools are often deployed alongside DHIS2 but should not be publicly accessible without strong authentication. The specific paths to protect will vary depending on your installation; adjust the `resources` list accordingly.

> **Important**
>
> The private key embedded under `identity_providers.oidc.jwks[].key` must be indented with 10 spaces on every line. Use the `sed` command shown in the previous step to produce a correctly indented version.

> **Note**
>
> The `notifier` is configured here to write to a local file rather than send email. This is suitable for initial setup and testing. In production, replace this with an SMTP notifier so that users can receive password reset and two-factor registration emails.

### Prepare directories and start Authelia

The `.deb` package creates an `authelia` system user. Create the data directory and set ownership before starting the service:

```bash
sudo mkdir -p /var/lib/authelia
sudo chown -R authelia:authelia /var/lib/authelia /etc/authelia
```

Then enable and start the service:

```bash
sudo systemctl enable --now authelia
sudo systemctl status authelia
```

Confirm it is listening on port 9091:

```bash
curl -I http://127.0.0.1:9091/authelia/
```

---

## Step 4: Configure nginx

Add the following location blocks to your nginx server configuration (inside the `server` block that handles `https://example.com`). Replace `172.19.2.50` with the actual IP address of your `authelia1` container throughout.

**Proxy the Authelia portal:**

```nginx
# Serve the Authelia portal under /authelia/
location /authelia/ {
    proxy_pass http://172.19.2.50:9091/authelia/;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-Uri $request_uri;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
```

**Add the internal auth verification endpoint:**

This internal location is used by nginx's `auth_request` directive to check whether a request is authenticated before passing it to a protected application. It is not needed for DHIS2's own OIDC login flow, but is required to protect other applications such as Glowroot or Grafana:

```nginx
location = /authelia/auth {
    internal;

    proxy_pass http://172.19.2.50:9091/api/verify;
    proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Uri $request_uri;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    proxy_pass_request_body off;
    proxy_set_header Content-Length "";
}
```

**Protecting an application — Glowroot example:**

To put an application behind Authelia, add `auth_request /authelia/auth;` to its location block. The `error_page 401` directive redirects unauthenticated users to the Authelia login page, with the original URL passed as a `rd` (redirect) parameter so they are returned to their destination after login:

```nginx
location /dhis-glowroot {
    auth_request /authelia/auth;
    error_page 401 =302 https://example.com/authelia/?rd=$scheme://$http_host$request_uri;

    proxy_pass http://172.19.2.11:4000/dhis-glowroot;
    include /etc/nginx/proxy_params;
    proxy_redirect off;

    proxy_set_header X-Frame-Options "SAMEORIGIN";
    proxy_set_header X-Content-Type-Options "nosniff";
    proxy_set_header X-Forwarded-Port 443;

    proxy_hide_header Strict-Transport-Security;
    proxy_hide_header X-Powered-By;
    proxy_hide_header Server;
}
```

Replace `172.19.2.11:4000` with the address of your Glowroot instance. The same pattern — adding `auth_request /authelia/auth;` and the `error_page 401` redirect — can be applied to any other application you want to protect.

Reload nginx to apply the changes:

```bash
sudo nginx -t && sudo systemctl reload nginx
```

---

## Step 5: Configure DHIS2

### Update dhis.conf

Add the following to the `dhis.conf` configuration file for the DHIS2 instance. Replace `your-plaintext-client-secret` with the plaintext client secret generated in Step 3.

```properties
# Enable OIDC login
oidc.oauth2.login.enabled = on

# Authelia OIDC settings
oidc.provider.authelia.client_id = dhis2
oidc.provider.authelia.client_secret = your-plaintext-client-secret
oidc.provider.authelia.mapping_claim = email

oidc.provider.authelia.authorization_uri = https://example.com/authelia/api/oidc/authorization
oidc.provider.authelia.token_uri = https://example.com/authelia/api/oidc/token
oidc.provider.authelia.user_info_uri = https://example.com/authelia/api/oidc/userinfo
oidc.provider.authelia.jwk_uri = https://example.com/authelia/jwks.json

oidc.provider.authelia.scopes = openid profile email
oidc.provider.authelia.redirect_url = https://example.com/dhis/oauth2/code/authelia

oidc.provider.authelia.enable_logout = on
oidc.logout.redirect_url = https://example.com/dhis

oidc.provider.authelia.enable_pkce = on
oidc.provider.authelia.display_alias = Authelia
```

Restart DHIS2 for the changes to take effect.

> **Note**
>
> The provider key `authelia` used in the property names (e.g. `oidc.provider.authelia.*`) can be any short identifier. It must match the value used in `oidc.provider.authelia.redirect_url` (the `oauth2/code/authelia` path segment) and the `redirect_uris` configured in Authelia.

### Create DHIS2 users

Each user who will log in via Authelia must have a corresponding DHIS2 user account. The DHIS2 user is linked to the Authelia/LLDAP user via the **OIDC mapping value**, which must match the user's email address as stored in LLDAP.

* Log in to DHIS2 with a local administrator account.
* Navigate to **Apps** > **Users** > **Users**.
* Create a new user or edit an existing one.
* Enable **External authentication only (OpenID or LDAP)**.
* Set the **OIDC mapping value** to the user's email address (e.g. `bobby@example.com`).
* Assign appropriate user roles and organisation units.
* Click **Save**.

---

## Step 6: Sign in to DHIS2 with Authelia

* Navigate to the DHIS2 login page. A button labelled **Authelia** should appear.
* Click the button. You will be redirected to the Authelia login page.
* Enter the LLDAP username and password. Authelia will prompt for a second factor (TOTP or WebAuthn) if the access policy requires it.
* After successful authentication you will be redirected back to DHIS2 and logged in as the mapped DHIS2 user.

> **Tip**
>
> You can verify the Authelia OIDC discovery endpoint is reachable and inspect the available endpoints with:
> ```
> curl https://example.com/authelia/.well-known/openid-configuration
> ```

---

## Summary

This guide has covered:

1. Creating dedicated LXD containers for LLDAP and Authelia
2. Installing and configuring LLDAP as a lightweight user directory
3. Installing Authelia and generating all required secrets and key material
4. Configuring Authelia as an OIDC provider backed by LLDAP
5. Configuring DHIS2 to delegate authentication to Authelia
6. Creating DHIS2 users mapped to LLDAP identities

Users are now managed centrally in LLDAP and authenticate through Authelia. The same Authelia instance can protect additional applications by adding further OIDC clients or configuring it as a forward-auth proxy for nginx.
