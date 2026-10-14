# Using the User Impersonation Feature in DHIS2 { #user_impersonation }

## Overview

User impersonation, also known as user switching, is a powerful feature provided in DHIS2 for administrative users to
log in as another user. This feature is especially useful for troubleshooting or resolving user-related issues, as it
allows an administrator to experience DHIS2 exactly as the user does.

This feature is built upon the `SwitchUserFilter` from Spring Security, but with additional configuration options.

> **Note**
>
> The feature is **disabled** by default. To enable it, you must set the `switch_user_feature.enabled` property
> to `true` in
> your `dhis.conf` file.
>
> This feature is considered **experimental** and is only meant to be called from configured IP address(s). Hence, to
> use it
> you must know the IP address from which you will be calling it and configure the `switch_user_allow_listed_ips`
> property
> in the `dhis.conf` file. This restriction might be removed in the future.

## How it works

Impersonation is done through two API endpoints. Both use `POST`; opening them in the browser address bar (a `GET` request) will not work.

| Action | Request |
|---|---|
| Start impersonating | `POST /api/auth/impersonate?username=<USERNAME>` |
| Stop impersonating | `POST /api/auth/impersonateExit` |

While impersonating, every request in the same session runs as the impersonated user, with that user's authorities, sharing and organisation units.

A successful request returns:

```json
{ "status": "IMPERSONATION_SUCCESS", "username": "<USERNAME>" }
```

and exiting returns `"status": "IMPERSONATION_EXIT_SUCCESS"`.

`GET /api/me` includes an `impersonation` field with the username of the original user while impersonation is active. From 2.43 it also includes `canImpersonate: true` when the current user is allowed to impersonate (feature enabled, required authority, and request from an allowed IP).

Logging in again in the same browser session ends impersonation.

## How to use

1. Enable the feature in `dhis.conf` and restart the server (see Configuration).
2. Log in as a user with the `ALL` authority or the `F_IMPERSONATE_USER` authority.
3. Send `POST /api/auth/impersonate?username=<USERNAME>` from the same session, for example:
```
   curl -b cookies.txt -c cookies.txt -X POST "https://<server>/api/auth/impersonate?username=<USERNAME>"
```
4. Use DHIS2 as the impersonated user.
5. Send `POST /api/auth/impersonateExit` to return to your own user.

## Configuration

| Property | Description | Default |
|---|---|---|
| `switch_user_feature.enabled` | Enables the feature. When disabled, both endpoints return 404. | `off` |
| `switch_user_allow_listed_ips` | Comma-separated list of IP addresses from which impersonation requests are accepted. Values must match exactly; ranges/CIDR are not supported. | `localhost,127.0.0.1,[0:0:0:0:0:0:0:1]` (2.43 adds `0:0:0:0:0:0:0:1`) |

Example:

```
switch_user_feature.enabled = on
switch_user_allow_listed_ips = 10.0.0.5
```

> **Important: reverse proxies**
>
> The allow-list is checked against the address of whatever connects directly to DHIS2. In most deployments that is a reverse proxy or load balancer, not the user's browser:
>
> - If nginx or Apache runs on the same server (as in the recommended setup), every request appears to come from `127.0.0.1`. Because `127.0.0.1` is in the default allow-list, **every user passes the IP check** once the feature is enabled.
> - In Docker or Kubernetes, requests appear to come from the proxy container or ingress address.
>
> To restrict impersonation to specific client IPs, configure Tomcat to take the client IP from your proxy (see *Reverse proxy → Passing the client IP to DHIS2*), and only then add client IPs to the allow-list. Without this, the allow-list cannot distinguish users.
>
> From 2.43, a rejected request returns `403 … not allowed to impersonate user from IP: <address>`, which shows the address DHIS2 sees.

## Security restrictions

- The feature is disabled by default.
- The user must have the `ALL` or `F_IMPERSONATE_USER` authority.
- Requests must come from an allowed IP (see the note on reverse proxies above).
- Users without the `ALL` authority cannot impersonate a user who has `ALL`.
- Users cannot impersonate themselves.
- An impersonated session cannot start a further impersonation unless the impersonated user has `F_IMPERSONATE_USER`.

## Logging

Each switch is logged as an `AuthenticationSwitchUserEvent`:

```
Authentication event: AuthenticationSwitchUserEvent; username: <impersonator>; targetUser: <impersonated user>
```

When exiting, `username` is the impersonated user and `targetUser` is the original user.
