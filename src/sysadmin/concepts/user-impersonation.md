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

## How It Works

The user impersonation feature operates in the following manner:

1. An administrative user makes a request to a specific URL (e.g., `/impersonate?username=USERNAME`) with the `username`
   parameter
   indicating the username of the user they wish to impersonate.

2. The user impersonation feature intercepts this request, switches the `SecurityContext` to the new user, and redirects
   to the home page.

3. While impersonating another user, the administrative user can make requests as if they were the impersonated user.

4. To switch back to the original user, the administrative user makes a request to another URL (
   e.g., `/impersonateExit`). The user impersonation feature intercepts this request, switches the `SecurityContext`
   back to the original user, and redirects to the home page.

## How To Use

Follow these steps to use the user impersonation feature:

1. Log in as an administrative user with either the `ALL` or `F_IMPERSONATE_USER` authority.
2. Navigate to the URL for user impersonation (e.g., `/impersonate?username=USERNAME`).
3. Provide the `username` parameter of the user you wish to impersonate.
4. The system will switch your session to that of the impersonated user, and you will be redirected to the home page.
5. Perform any actions necessary for troubleshooting or user support.
6. When you're finished, navigate to the URL to end impersonation (e.g., `/impersonateExit`). Your session will be
   switched back to your original administrative user.

## Configuration

The user impersonation feature configuration options.

* `switch_user_feature.enabled` (Enable or disable the feature, default: `disabled`)
* `switch_user_allow_listed_ips` (Default allowed IP(s) are; `localhost,127.0.0.1,[0:0:0:0:0:0:0:1]`)

## Security restrictions
* Feature must be enabled in the `dhis.conf` configuration file, default value is; `disabled`.
* Users trying to impersonate need to send requests from an allowed IP.
* Users without the `ALL` authority can not impersonate another user that has the `ALL` authority.
* Users can not impersonate themselves.

## Security Implications
This feature should be used with caution due to its inherent security implications. Only trusted administrators should
be granted the capability to impersonate users. It's also recommended to pay attention to the log events related to the
user impersonation.

User impersonation events are logged in the following
format: `Authentication event: AuthenticationSwitchUserEvent; username: USER_DOING_THE_IMPERSONATION; targetUser: USER_BEING_IMPERSONATED;`
