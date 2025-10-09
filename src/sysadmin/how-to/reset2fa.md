# How to Manually Reset 2FA for a User

This guide provides instructions for system administrators to manually reset (disable) two-factor authentication (2FA) for a user account directly in the DHIS2 database. This procedure is intended as a last resort for cases where an administrator is locked out of their account due to lost 2FA credentials or other 2FA-related issues.

## ⚠️ Warning

Direct manipulation of the database can be risky and may lead to data corruption or instability if not done correctly. Always perform a full backup of your database before proceeding with any changes. Follow these instructions carefully.

**Note on DHIS2 Versions:** The `twofactortype` column was introduced in DHIS2 version 2.42, and it is defined as `NOT NULL`. If you are using an older version, the `userinfo` table schema will be different. This guide includes separate instructions for different versions where necessary.

## Prerequisites

-   Administrative access to the DHIS2 database server.
-   An SQL client (e.g., `psql`, DBeaver, pgAdmin) to connect to the DHIS2 PostgreSQL database.
-   The username of the user account for which 2FA needs to be reset.

## Step 1: Connect to the DHIS2 Database

Using your preferred SQL client, connect to the DHIS2 database. You will need the database name, host, port, and credentials for a user with sufficient privileges to read and modify tables.

## Step 2: Identify the User and Check 2FA Status

Before making any changes, it's important to identify the correct user and check their current 2FA status.

#### For DHIS2 2.42 and Newer

Execute the following SQL query, replacing `'some_admin'` with the actual username of the locked-out user:

```sql
SELECT userinfoid, username, secret, twofactortype FROM userinfo WHERE username = 'some_admin';
```

**Expected Output:**

If the user has 2FA enabled, you will see values in the `secret` and `twofactortype` columns. The `twofactortype` will likely be `TOTP_ENABLED` or `EMAIL_ENABLED`.

```
 userinfoid | username   |                 secret                  | twofactortype
------------+------------+-----------------------------------------+---------------
          1 | some_admin | FVG4... (a long secret key) ...24X2    | TOTP_ENABLED
(1 row)
```

If `secret` is `NULL` and `twofactortype` is `NOT_ENABLED`, 2FA is not enabled for this user, and this guide may not solve the login issue.

#### For DHIS2 Versions Before 2.42

For older versions of DHIS2, the `twofactortype` column does not exist. Use the following query instead:

```sql
SELECT userinfoid, username, secret FROM userinfo WHERE username = 'some_admin';
```

**Expected Output:**

If 2FA is enabled, you will see a value in the `secret` column.

```
 userinfoid | username   |                 secret
------------+------------+-----------------------------------------
          1 | some_admin | FVG4... (a long secret key) ...24X2
(1 row)
```

If the `secret` column is `NULL`, 2FA is not enabled for this user.

## Step 3: Disable 2FA for the User

To disable 2FA, you need to clear the `secret` and update the `twofactortype` fields for the user. Remember to replace `'some_admin'` with the correct username.

#### For DHIS2 2.42 and Newer

```sql
UPDATE userinfo SET secret = NULL, twofactortype = 'NOT_ENABLED' WHERE username = 'some_admin';
```

#### For DHIS2 Versions Before 2.42

```sql
UPDATE userinfo SET secret = NULL WHERE username = 'some_admin';
```

After executing the query, you should see a confirmation that the row has been updated.

## Step 4: Verify the Change

To ensure that 2FA has been disabled, run the appropriate `SELECT` query from Step 2 again.

#### For DHIS2 2.42 and Newer

```sql
SELECT userinfoid, username, secret, twofactortype FROM userinfo WHERE username = 'some_admin';
```

**Expected Output:**

The `secret` column should now be `NULL` and `twofactortype` should be `NOT_ENABLED`, indicating that 2FA is no longer active for this user.

```
 userinfoid | username   | secret | twofactortype
------------+------------+--------+---------------
          1 | some_admin |        | NOT_ENABLED
(1 row)
```

#### For DHIS2 Versions Before 2.42

```sql
SELECT userinfoid, username, secret FROM userinfo WHERE username = 'some_admin';
```

**Expected Output:**

The `secret` column should now be `NULL`.

```
 userinfoid | username   | secret
------------+------------+--------
          1 | some_admin |
(1 row)
```

## Step 5: Log In

The user should now be able to log in with only their username and password, without being prompted for a 2FA code. After a successful login, it is highly recommended to re-enroll in 2FA through the user profile settings in the DHIS2 user interface for security.

